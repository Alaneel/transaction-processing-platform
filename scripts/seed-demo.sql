-- Execute using the schema owner, never the public HTTP API.
-- This fixture is idempotent when rerun in the same database. Demo accounts:
-- issuance ...0001, alice ...0002, bob ...0003; USER balances 1,000,000 FIC each.
BEGIN;

SELECT pg_advisory_xact_lock(73310001);

INSERT INTO accounts (id, kind, status, unit) VALUES
    ('00000000-0000-0000-0000-000000000001', 'ISSUANCE', 'ACTIVE', 'FIC'),
    ('00000000-0000-0000-0000-000000000002', 'USER', 'ACTIVE', 'FIC'),
    ('00000000-0000-0000-0000-000000000003', 'USER', 'ACTIVE', 'FIC')
ON CONFLICT (id) DO NOTHING;

INSERT INTO balances (account_id, amount)
SELECT id, 0 FROM accounts
 WHERE id IN ('00000000-0000-0000-0000-000000000001',
              '00000000-0000-0000-0000-000000000002',
              '00000000-0000-0000-0000-000000000003')
ON CONFLICT (account_id) DO NOTHING;

-- The same deterministic lock order is used by the application.
SELECT account_id FROM balances
 WHERE account_id IN ('00000000-0000-0000-0000-000000000001',
                      '00000000-0000-0000-0000-000000000002',
                      '00000000-0000-0000-0000-000000000003')
 ORDER BY account_id FOR UPDATE;

DO $$
DECLARE
    destination UUID;
    transfer UUID;
    seed_key VARCHAR(128);
BEGIN
    FOR destination, transfer, seed_key IN
        SELECT * FROM (VALUES
            ('00000000-0000-0000-0000-000000000002'::UUID,
             '10000000-0000-0000-0000-000000000002'::UUID, 'demo-issuance-alice'),
            ('00000000-0000-0000-0000-000000000003'::UUID,
             '10000000-0000-0000-0000-000000000003'::UUID, 'demo-issuance-bob')
        ) AS seeds(destination, transfer, seed_key)
    LOOP
        INSERT INTO transfers
            (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status)
        VALUES (transfer, seed_key, '00000000-0000-0000-0000-000000000001',
                destination, 1000000, 'FIC', 'PROCESSING')
        ON CONFLICT (idempotency_key) DO NOTHING;

        IF FOUND THEN
            UPDATE balances SET amount = amount - 1000000
             WHERE account_id = '00000000-0000-0000-0000-000000000001';
            UPDATE balances SET amount = amount + 1000000 WHERE account_id = destination;
            INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES
                (transfer, '00000000-0000-0000-0000-000000000001', -1000000),
                (transfer, destination, 1000000);
            UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP
             WHERE id = transfer;
        ELSIF NOT EXISTS (
            SELECT 1 FROM transfers t
             WHERE t.id = transfer AND t.idempotency_key = seed_key
               AND t.source_account_id = '00000000-0000-0000-0000-000000000001'
               AND t.destination_account_id = destination AND t.amount = 1000000
               AND t.unit = 'FIC' AND t.status = 'COMPLETED'
        ) THEN
            RAISE EXCEPTION 'Demo funding key conflicts with a different transfer';
        END IF;
    END LOOP;
END;
$$;

COMMIT;
