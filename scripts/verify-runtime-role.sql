-- Run with the local schema owner after seed-demo.sql. Every attempted mutation
-- is rolled back. This checks the deployed role, separately from owner-based tests.
\set ON_ERROR_STOP on
BEGIN;
SET LOCAL ROLE tpp_app;
DO $$
DECLARE
    denied BOOLEAN;
    request_id UUID := 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee';
BEGIN
    IF current_user <> 'tpp_app' THEN RAISE EXCEPTION 'Expected runtime role'; END IF;
    denied := FALSE;
    BEGIN
        INSERT INTO accounts(id,kind,status,unit)
        VALUES ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeed','ISSUANCE','ACTIVE','FIC');
    EXCEPTION WHEN insufficient_privilege THEN denied := TRUE;
    END;
    IF NOT denied THEN RAISE EXCEPTION 'Runtime could create issuance account'; END IF;

    denied := FALSE;
    BEGIN
        UPDATE ledger_entries SET delta=delta WHERE id=(SELECT min(id) FROM ledger_entries);
    EXCEPTION WHEN insufficient_privilege THEN denied := TRUE;
    END;
    IF NOT denied THEN RAISE EXCEPTION 'Runtime could update ledger history'; END IF;

    denied := FALSE;
    BEGIN
        ALTER TABLE balances DISABLE TRIGGER balances_reconcile;
    EXCEPTION WHEN insufficient_privilege THEN denied := TRUE;
    END;
    IF NOT denied THEN RAISE EXCEPTION 'Runtime could disable balance checks'; END IF;

    denied := FALSE;
    BEGIN
        UPDATE outbox_events SET payload=payload || '{"amountMinor":0}'::jsonb
         WHERE event_id=(SELECT event_id FROM outbox_events ORDER BY created_at LIMIT 1);
    EXCEPTION WHEN object_not_in_prerequisite_state THEN denied := TRUE;
    END;
    IF NOT denied THEN RAISE EXCEPTION 'Runtime could rewrite immutable outbox payload'; END IF;

    denied := FALSE;
    BEGIN
        DELETE FROM outbox_events
         WHERE event_id=(SELECT event_id FROM outbox_events ORDER BY created_at LIMIT 1);
    EXCEPTION WHEN insufficient_privilege THEN denied := TRUE;
    END;
    IF NOT denied THEN RAISE EXCEPTION 'Runtime could erase durable outbox evidence'; END IF;

    denied := FALSE;
    BEGIN
        UPDATE event_inbox SET payload_hash=payload_hash;
    EXCEPTION WHEN insufficient_privilege THEN denied := TRUE;
    END;
    IF NOT denied THEN RAISE EXCEPTION 'Runtime could rewrite inbox identity'; END IF;

    denied := FALSE;
    BEGIN
        INSERT INTO transfers(id,idempotency_key,source_account_id,destination_account_id,amount,unit,status)
        VALUES(request_id,'runtime-role-issuance-probe','00000000-0000-0000-0000-000000000001',
               '00000000-0000-0000-0000-000000000002',1,'FIC','PROCESSING');
        UPDATE transfers SET status='COMPLETED',completed_at=clock_timestamp() WHERE id=request_id;
    EXCEPTION WHEN insufficient_privilege THEN denied := TRUE;
    END;
    IF NOT denied THEN RAISE EXCEPTION 'Runtime could complete issuance'; END IF;
    RAISE NOTICE 'Runtime restrictions passed: issuance creation/completion, ledger/outbox/inbox rewrite, outbox deletion, trigger disable';
END;
$$;
ROLLBACK;
