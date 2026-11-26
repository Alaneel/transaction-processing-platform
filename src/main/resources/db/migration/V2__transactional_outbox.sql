-- Every completed transfer (including explicitly modeled issuance) owns exactly
-- one immutable v1 event. No Kafka/network call participates in this transaction.
CREATE TABLE outbox_events (
    event_id UUID PRIMARY KEY,
    transfer_id UUID NOT NULL UNIQUE REFERENCES transfers(id),
    event_type VARCHAR(32) NOT NULL DEFAULT 'TransferCompleted' CHECK(event_type='TransferCompleted'),
    schema_version INTEGER NOT NULL DEFAULT 1 CHECK(schema_version=1),
    aggregate_version BIGINT NOT NULL DEFAULT 1 CHECK(aggregate_version=1),
    payload JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    status VARCHAR(16) NOT NULL DEFAULT 'PENDING' CHECK(status IN ('PENDING','CLAIMED','PUBLISHED','BLOCKED')),
    attempt_count INTEGER NOT NULL DEFAULT 0 CHECK(attempt_count>=0),
    next_attempt_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    claimed_by UUID,
    claim_token UUID,
    claimed_at TIMESTAMPTZ,
    lease_until TIMESTAMPTZ,
    published_at TIMESTAMPTZ,
    kafka_topic VARCHAR(249),
    kafka_partition INTEGER CHECK(kafka_partition>=0),
    kafka_offset BIGINT CHECK(kafka_offset>=0),
    last_error_code VARCHAR(64),
    last_error_classification VARCHAR(16) CHECK(last_error_classification IN ('TRANSIENT','AMBIGUOUS','PERMANENT')),
    last_error_detail VARCHAR(256),
    last_error_at TIMESTAMPTZ,
    CHECK(jsonb_typeof(payload)='object'),
    CHECK((status='CLAIMED' AND claimed_by IS NOT NULL AND claim_token IS NOT NULL AND claimed_at IS NOT NULL AND lease_until>claimed_at)
       OR (status<>'CLAIMED' AND claimed_by IS NULL AND claim_token IS NULL AND claimed_at IS NULL AND lease_until IS NULL)),
    CHECK((status='PUBLISHED' AND published_at IS NOT NULL AND kafka_topic IS NOT NULL AND kafka_partition IS NOT NULL AND kafka_offset IS NOT NULL)
       OR (status<>'PUBLISHED' AND published_at IS NULL AND kafka_topic IS NULL AND kafka_partition IS NULL AND kafka_offset IS NULL)),
    CHECK(status<>'BLOCKED' OR last_error_classification='PERMANENT')
);
CREATE INDEX outbox_ready_idx ON outbox_events(next_attempt_at,created_at,event_id) WHERE status='PENDING';
CREATE INDEX outbox_expired_claim_idx ON outbox_events(lease_until,event_id) WHERE status='CLAIMED';
CREATE INDEX outbox_backlog_age_idx ON outbox_events(created_at) WHERE status<>'PUBLISHED';

CREATE TABLE outbox_requeue_audit (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_id UUID NOT NULL REFERENCES outbox_events(event_id),
    reason VARCHAR(256) NOT NULL CHECK(length(btrim(reason)) BETWEEN 1 AND 256),
    requested_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp()
);
CREATE TRIGGER outbox_requeue_audit_immutable BEFORE UPDATE OR DELETE ON outbox_requeue_audit
    FOR EACH ROW EXECUTE FUNCTION prevent_history_mutation();
CREATE TRIGGER outbox_requeue_audit_no_truncate BEFORE TRUNCATE ON outbox_requeue_audit
    FOR EACH STATEMENT EXECUTE FUNCTION prevent_history_mutation();

CREATE FUNCTION transfer_event_payload(event_identity UUID, transfer_row public.transfers, correlation TEXT)
RETURNS JSONB LANGUAGE sql IMMUTABLE SET search_path=pg_catalog,public AS $$
    SELECT jsonb_build_object('eventId',event_identity,'eventType','TransferCompleted','schemaVersion',1,
        'transferId',transfer_row.id,'aggregateVersion',1,'sourceAccountId',transfer_row.source_account_id,
        'destinationAccountId',transfer_row.destination_account_id,'amountMinor',transfer_row.amount,'unit',transfer_row.unit,
        'occurredAt',to_char(transfer_row.completed_at AT TIME ZONE 'UTC','YYYY-MM-DD"T"HH24:MI:SS.US"Z"'),
        'correlationId',correlation);
$$;

CREATE FUNCTION guard_outbox_event() RETURNS TRIGGER
LANGUAGE plpgsql SET search_path=pg_catalog,public AS $$
DECLARE
    transfer_row public.transfers%ROWTYPE;
    expected JSONB;
BEGIN
    IF TG_OP='INSERT' THEN
        SELECT * INTO STRICT transfer_row FROM public.transfers WHERE id=NEW.transfer_id;
        IF transfer_row.status<>'COMPLETED' THEN
            RAISE EXCEPTION 'Only a completed transfer may own an event' USING ERRCODE='23514';
        END IF;
        IF NEW.status<>'PENDING' OR NEW.attempt_count<>0 THEN
            RAISE EXCEPTION 'Outbox starts pending with zero attempts' USING ERRCODE='23514';
        END IF;
        IF COALESCE(NEW.payload->>'correlationId','') !~ '^[A-Za-z0-9._:-]{1,128}$' THEN
            RAISE EXCEPTION 'Invalid event correlation identifier' USING ERRCODE='23514';
        END IF;
        expected := public.transfer_event_payload(NEW.event_id,transfer_row,NEW.payload->>'correlationId');
        IF NEW.payload<>expected THEN
            RAISE EXCEPTION 'Outbox payload must exactly describe its completed transfer' USING ERRCODE='23514';
        END IF;
    ELSE
        IF ROW(NEW.event_id,NEW.transfer_id,NEW.event_type,NEW.schema_version,NEW.aggregate_version,NEW.payload,NEW.created_at)
           IS DISTINCT FROM ROW(OLD.event_id,OLD.transfer_id,OLD.event_type,OLD.schema_version,OLD.aggregate_version,OLD.payload,OLD.created_at) THEN
            RAISE EXCEPTION 'Outbox event identity and payload are immutable' USING ERRCODE='55000';
        END IF;
        IF OLD.status='PUBLISHED' THEN
            RAISE EXCEPTION 'Published delivery evidence is immutable' USING ERRCODE='55000';
        END IF;
        IF NEW.attempt_count<OLD.attempt_count THEN
            RAISE EXCEPTION 'Publication attempt count cannot decrease' USING ERRCODE='23514';
        END IF;
        IF OLD.status='PENDING' AND NEW.status<>'CLAIMED' THEN
            RAISE EXCEPTION 'Pending publication must be claimed first' USING ERRCODE='23514';
        END IF;
        IF OLD.status='BLOCKED' THEN
            IF NEW.status<>'PENDING' OR NOT EXISTS(SELECT 1 FROM public.outbox_requeue_audit
                WHERE event_id=OLD.event_id AND requested_at>=OLD.last_error_at) THEN
                RAISE EXCEPTION 'Blocked event requires an audited requeue' USING ERRCODE='23514';
            END IF;
        END IF;
        IF OLD.status='CLAIMED' AND NEW.status='CLAIMED' THEN
            IF NEW.claim_token=OLD.claim_token THEN
                IF NEW.claimed_by<>OLD.claimed_by OR NEW.attempt_count<>OLD.attempt_count OR OLD.lease_until<=clock_timestamp() THEN
                    RAISE EXCEPTION 'Expired claim cannot be renewed' USING ERRCODE='23514';
                END IF;
            ELSIF OLD.lease_until>clock_timestamp() THEN
                RAISE EXCEPTION 'Live claim cannot be stolen' USING ERRCODE='23514';
            END IF;
        ELSIF OLD.status='CLAIMED' AND OLD.lease_until<=clock_timestamp() THEN
            RAISE EXCEPTION 'Expired publisher cannot overwrite delivery state' USING ERRCODE='23514';
        END IF;
        IF NEW.status='CLAIMED' AND NEW.claim_token IS DISTINCT FROM OLD.claim_token
           AND NEW.attempt_count<>LEAST(OLD.attempt_count::BIGINT+1,2147483647) THEN
            RAISE EXCEPTION 'New claim must advance attempt count' USING ERRCODE='23514';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER outbox_guard BEFORE INSERT OR UPDATE ON outbox_events FOR EACH ROW EXECUTE FUNCTION guard_outbox_event();
CREATE TRIGGER outbox_no_delete BEFORE DELETE ON outbox_events FOR EACH ROW EXECUTE FUNCTION prevent_history_mutation();
CREATE TRIGGER outbox_no_truncate BEFORE TRUNCATE ON outbox_events FOR EACH STATEMENT EXECUTE FUNCTION prevent_history_mutation();

CREATE FUNCTION append_transfer_event() RETURNS TRIGGER
LANGUAGE plpgsql SET search_path=pg_catalog,public AS $$
DECLARE event_identity UUID := gen_random_uuid(); correlation TEXT;
BEGIN
    IF NEW.status='COMPLETED' THEN
        correlation := COALESCE(NULLIF(current_setting('tpp.correlation_id',TRUE),''),'database-fixture');
        INSERT INTO public.outbox_events(event_id,transfer_id,payload)
        VALUES(event_identity,NEW.id,public.transfer_event_payload(event_identity,NEW,correlation));
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER transfers_append_event AFTER UPDATE ON transfers
    FOR EACH ROW WHEN(NEW.status='COMPLETED' AND OLD.status IS DISTINCT FROM NEW.status) EXECUTE FUNCTION append_transfer_event();

-- Preserve existing Phase1 history when migrating an already populated repository.
WITH existing AS MATERIALIZED (
    SELECT t AS transfer_row,gen_random_uuid() AS event_identity FROM transfers t WHERE t.status='COMPLETED'
)
INSERT INTO outbox_events(event_id,transfer_id,payload,created_at)
SELECT event_identity,(transfer_row).id,transfer_event_payload(event_identity,transfer_row,'migration-backfill'),(transfer_row).completed_at
FROM existing;

CREATE FUNCTION require_transfer_event() RETURNS TRIGGER
LANGUAGE plpgsql SET search_path=pg_catalog,public AS $$
DECLARE final_status TEXT;
BEGIN
    SELECT status INTO STRICT final_status FROM public.transfers WHERE id=NEW.id;
    IF final_status='COMPLETED' AND NOT EXISTS(SELECT 1 FROM public.outbox_events WHERE transfer_id=NEW.id) THEN
        RAISE EXCEPTION 'Completed transfer must have its atomic outbox event' USING ERRCODE='23514',CONSTRAINT='completed_transfer_has_event';
    END IF;
    RETURN NULL;
END;
$$;
CREATE CONSTRAINT TRIGGER transfers_require_event AFTER INSERT OR UPDATE ON transfers
    DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION require_transfer_event();

REVOKE ALL ON FUNCTION transfer_event_payload(UUID,public.transfers,TEXT) FROM PUBLIC;
REVOKE ALL ON FUNCTION guard_outbox_event() FROM PUBLIC;
REVOKE ALL ON FUNCTION append_transfer_event() FROM PUBLIC;
REVOKE ALL ON FUNCTION require_transfer_event() FROM PUBLIC;
DO $$ BEGIN
    IF EXISTS(SELECT 1 FROM pg_roles WHERE rolname='tpp_app') THEN
        GRANT SELECT,INSERT,UPDATE ON outbox_events TO tpp_app;
        GRANT SELECT,INSERT ON outbox_requeue_audit TO tpp_app;
        GRANT USAGE,SELECT ON SEQUENCE outbox_requeue_audit_id_seq TO tpp_app;
        -- Called by invoker-security triggers; no SECURITY DEFINER escape hatch.
        GRANT EXECUTE ON FUNCTION transfer_event_payload(UUID,public.transfers,TEXT) TO tpp_app;
    END IF;
END $$;
