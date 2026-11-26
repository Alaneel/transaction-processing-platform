-- A dedicated projection owns this inbox. Kafka delivery is never balance authority.
CREATE TABLE event_inbox (
    event_id UUID PRIMARY KEY REFERENCES outbox_events(event_id),
    transfer_id UUID NOT NULL UNIQUE REFERENCES transfers(id),
    payload_hash CHAR(64) NOT NULL CHECK (payload_hash ~ '^[0-9a-f]{64}$'),
    event_type VARCHAR(64) NOT NULL CHECK (event_type = 'TransferCompleted'),
    schema_version INTEGER NOT NULL CHECK (schema_version = 1),
    source_topic VARCHAR(249) NOT NULL,
    source_partition INTEGER NOT NULL CHECK (source_partition >= 0),
    source_offset BIGINT NOT NULL CHECK (source_offset >= 0),
    correlation_id VARCHAR(128) NOT NULL,
    processed_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp()
);

CREATE TABLE transfer_activity_projection (
    transfer_id UUID PRIMARY KEY REFERENCES transfers(id),
    event_id UUID NOT NULL UNIQUE REFERENCES event_inbox(event_id),
    source_account_id UUID NOT NULL REFERENCES accounts(id),
    destination_account_id UUID NOT NULL REFERENCES accounts(id),
    amount_minor BIGINT NOT NULL CHECK (amount_minor BETWEEN 1 AND 9000000000000000),
    unit VARCHAR(3) NOT NULL CHECK (unit = 'FIC'),
    occurred_at TIMESTAMPTZ NOT NULL,
    projected_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    CHECK (source_account_id <> destination_account_id)
);

CREATE TABLE account_activity (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_id UUID NOT NULL REFERENCES accounts(id),
    event_id UUID NOT NULL REFERENCES transfer_activity_projection(event_id),
    transfer_id UUID NOT NULL REFERENCES transfer_activity_projection(transfer_id),
    delta_minor BIGINT NOT NULL CHECK (delta_minor <> 0),
    unit VARCHAR(3) NOT NULL CHECK (unit = 'FIC'),
    occurred_at TIMESTAMPTZ NOT NULL,
    projected_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    UNIQUE (event_id, account_id)
);
CREATE INDEX account_activity_page_idx ON account_activity(account_id,id);
CREATE INDEX transfer_activity_freshness_idx ON transfer_activity_projection(projected_at DESC);

CREATE FUNCTION guard_consumer_projection() RETURNS TRIGGER
LANGUAGE plpgsql SET search_path = pg_catalog, public AS $$
DECLARE
    expected public.transfers%ROWTYPE;
    expected_event UUID;
BEGIN
    SELECT * INTO STRICT expected FROM public.transfers WHERE id=NEW.transfer_id;
    SELECT event_id INTO expected_event FROM public.outbox_events WHERE transfer_id=NEW.transfer_id;
    IF expected.status <> 'COMPLETED' OR expected_event IS DISTINCT FROM NEW.event_id THEN
        RAISE EXCEPTION 'Projection requires the committed transfer event identity'
            USING ERRCODE = '23514', CONSTRAINT = 'projection_matches_event';
    END IF;
    IF TG_TABLE_NAME='transfer_activity_projection' THEN
        IF ROW(NEW.source_account_id,NEW.destination_account_id,NEW.amount_minor,NEW.unit,NEW.occurred_at)
           IS DISTINCT FROM ROW(expected.source_account_id,expected.destination_account_id,
                                expected.amount,expected.unit,expected.completed_at) THEN
            RAISE EXCEPTION 'Projection payload differs from its completed transfer'
                USING ERRCODE = '23514', CONSTRAINT = 'projection_matches_transfer';
        END IF;
    ELSIF TG_TABLE_NAME='account_activity' THEN
        IF NOT ((NEW.account_id=expected.source_account_id AND NEW.delta_minor=-expected.amount)
             OR (NEW.account_id=expected.destination_account_id AND NEW.delta_minor=expected.amount))
           OR NEW.unit<>expected.unit OR NEW.occurred_at<>expected.completed_at THEN
            RAISE EXCEPTION 'Activity must be the transfer debit or credit'
                USING ERRCODE = '23514', CONSTRAINT = 'activity_matches_transfer';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;

CREATE FUNCTION require_complete_consumer_effect() RETURNS TRIGGER
LANGUAGE plpgsql SET search_path = pg_catalog, public AS $$
BEGIN
    IF (SELECT count(*) FROM public.transfer_activity_projection WHERE event_id=NEW.event_id)<>1
       OR (SELECT count(*) FROM public.account_activity WHERE event_id=NEW.event_id)<>2 THEN
        RAISE EXCEPTION 'Inbox, transfer projection and paired activity must commit together'
            USING ERRCODE = '23514', CONSTRAINT = 'inbox_requires_complete_projection';
    END IF;
    RETURN NULL;
END;
$$;

CREATE TRIGGER inbox_origin_guard BEFORE INSERT ON event_inbox
    FOR EACH ROW EXECUTE FUNCTION guard_consumer_projection();
CREATE TRIGGER transfer_projection_guard BEFORE INSERT ON transfer_activity_projection
    FOR EACH ROW EXECUTE FUNCTION guard_consumer_projection();
CREATE TRIGGER account_activity_guard BEFORE INSERT ON account_activity
    FOR EACH ROW EXECUTE FUNCTION guard_consumer_projection();
CREATE CONSTRAINT TRIGGER inbox_atomic_effect AFTER INSERT ON event_inbox
    DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION require_complete_consumer_effect();
CREATE TRIGGER inbox_immutable BEFORE UPDATE OR DELETE ON event_inbox
    FOR EACH ROW EXECUTE FUNCTION prevent_history_mutation();
CREATE TRIGGER transfer_projection_immutable BEFORE UPDATE OR DELETE ON transfer_activity_projection
    FOR EACH ROW EXECUTE FUNCTION prevent_history_mutation();
CREATE TRIGGER account_activity_immutable BEFORE UPDATE OR DELETE ON account_activity
    FOR EACH ROW EXECUTE FUNCTION prevent_history_mutation();
CREATE TRIGGER inbox_no_truncate BEFORE TRUNCATE ON event_inbox
    FOR EACH STATEMENT EXECUTE FUNCTION prevent_history_mutation();
CREATE TRIGGER transfer_projection_no_truncate BEFORE TRUNCATE ON transfer_activity_projection
    FOR EACH STATEMENT EXECUTE FUNCTION prevent_history_mutation();
CREATE TRIGGER account_activity_no_truncate BEFORE TRUNCATE ON account_activity
    FOR EACH STATEMENT EXECUTE FUNCTION prevent_history_mutation();

-- Quarantine is the durable DLQ: its commit MUST precede advancing a Kafka offset.
-- Oversized records retain a bounded prefix plus original length/digest explicitly.
CREATE TABLE event_quarantine (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    consumer_group VARCHAR(249) NOT NULL,
    source_topic VARCHAR(249) NOT NULL,
    source_partition INTEGER NOT NULL CHECK (source_partition>=0),
    source_offset BIGINT NOT NULL CHECK (source_offset>=0),
    event_id UUID,
    original_key VARCHAR(1024),
    original_payload BYTEA NOT NULL CHECK (octet_length(original_payload)<=1048576),
    payload_sha256 CHAR(64) NOT NULL,
    original_payload_bytes INTEGER NOT NULL CHECK (original_payload_bytes>=0),
    payload_truncated BOOLEAN NOT NULL,
    error_classification VARCHAR(16) NOT NULL CHECK (error_classification='PERMANENT'),
    error_code VARCHAR(64) NOT NULL,
    error_message VARCHAR(240) NOT NULL,
    processing_attempts INTEGER NOT NULL CHECK (processing_attempts>=1),
    quarantined_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    replay_attempts INTEGER NOT NULL DEFAULT 0 CHECK (replay_attempts>=0),
    last_replay_at TIMESTAMPTZ,
    UNIQUE (consumer_group,source_topic,source_partition,source_offset),
    CHECK (payload_truncated=(original_payload_bytes>1048576))
);
CREATE INDEX event_quarantine_page_idx ON event_quarantine(id);

CREATE TABLE event_quarantine_replays (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    quarantine_id BIGINT NOT NULL REFERENCES event_quarantine(id),
    attempt INTEGER NOT NULL CHECK (attempt>0),
    reason VARCHAR(500) NOT NULL CHECK (length(btrim(reason))>0),
    corrected_payload BYTEA CHECK (octet_length(corrected_payload)<=1048576),
    adopted_event_id UUID,
    status VARCHAR(16) NOT NULL DEFAULT 'STARTED'
        CHECK (status IN ('STARTED','SUCCEEDED','DUPLICATE','REJECTED')),
    result_code VARCHAR(64),
    started_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    finished_at TIMESTAMPTZ,
    UNIQUE (quarantine_id,attempt),
    CHECK ((status='STARTED' AND finished_at IS NULL) OR (status<>'STARTED' AND finished_at IS NOT NULL))
);

CREATE FUNCTION guard_quarantine_evidence() RETURNS TRIGGER
LANGUAGE plpgsql SET search_path = pg_catalog, public AS $$
BEGIN
    IF TG_TABLE_NAME='event_quarantine' THEN
        IF ROW(NEW.id,NEW.consumer_group,NEW.source_topic,NEW.source_partition,NEW.source_offset,
               NEW.event_id,NEW.original_key,NEW.original_payload,NEW.payload_sha256,
               NEW.original_payload_bytes,NEW.payload_truncated,NEW.error_classification,
               NEW.error_code,NEW.error_message,NEW.processing_attempts,NEW.quarantined_at)
           IS DISTINCT FROM ROW(OLD.id,OLD.consumer_group,OLD.source_topic,OLD.source_partition,OLD.source_offset,
               OLD.event_id,OLD.original_key,OLD.original_payload,OLD.payload_sha256,
               OLD.original_payload_bytes,OLD.payload_truncated,OLD.error_classification,
               OLD.error_code,OLD.error_message,OLD.processing_attempts,OLD.quarantined_at)
           OR NEW.replay_attempts<>OLD.replay_attempts+1 OR NEW.last_replay_at IS NULL THEN
            RAISE EXCEPTION 'Quarantine evidence is immutable; replay reservations increment once'
                USING ERRCODE='55000';
        END IF;
    ELSE
        IF OLD.status<>'STARTED' OR NEW.status='STARTED'
           OR ROW(NEW.id,NEW.quarantine_id,NEW.attempt,NEW.reason,NEW.corrected_payload,NEW.started_at)
           IS DISTINCT FROM ROW(OLD.id,OLD.quarantine_id,OLD.attempt,OLD.reason,OLD.corrected_payload,OLD.started_at) THEN
            RAISE EXCEPTION 'Replay audit supports one terminal result'
                USING ERRCODE='55000';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER quarantine_evidence_guard BEFORE UPDATE ON event_quarantine
    FOR EACH ROW EXECUTE FUNCTION guard_quarantine_evidence();
CREATE TRIGGER quarantine_replay_guard BEFORE UPDATE ON event_quarantine_replays
    FOR EACH ROW EXECUTE FUNCTION guard_quarantine_evidence();
CREATE TRIGGER quarantine_no_delete BEFORE DELETE ON event_quarantine
    FOR EACH ROW EXECUTE FUNCTION prevent_history_mutation();
CREATE TRIGGER quarantine_replay_no_delete BEFORE DELETE ON event_quarantine_replays
    FOR EACH ROW EXECUTE FUNCTION prevent_history_mutation();
CREATE TRIGGER quarantine_no_truncate BEFORE TRUNCATE ON event_quarantine
    FOR EACH STATEMENT EXECUTE FUNCTION prevent_history_mutation();
CREATE TRIGGER quarantine_replay_no_truncate BEFORE TRUNCATE ON event_quarantine_replays
    FOR EACH STATEMENT EXECUTE FUNCTION prevent_history_mutation();

REVOKE ALL ON FUNCTION guard_consumer_projection() FROM PUBLIC;
REVOKE ALL ON FUNCTION require_complete_consumer_effect() FROM PUBLIC;
REVOKE ALL ON FUNCTION guard_quarantine_evidence() FROM PUBLIC;
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_catalog.pg_roles WHERE rolname='tpp_app') THEN
        GRANT SELECT,INSERT ON event_inbox,transfer_activity_projection,account_activity,
            event_quarantine,event_quarantine_replays TO tpp_app;
        GRANT UPDATE(replay_attempts,last_replay_at) ON event_quarantine TO tpp_app;
        GRANT UPDATE(adopted_event_id,status,result_code,finished_at) ON event_quarantine_replays TO tpp_app;
        GRANT USAGE,SELECT ON SEQUENCE account_activity_id_seq,event_quarantine_id_seq,
            event_quarantine_replays_id_seq TO tpp_app;
    END IF;
END;
$$;
