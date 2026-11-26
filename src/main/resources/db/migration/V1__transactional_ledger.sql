-- FIC is a fictional, single unit. Every amount is an integer minor unit.
-- The ±9 quadrillion bound leaves ample headroom inside PostgreSQL BIGINT.
CREATE TABLE accounts (
    id UUID PRIMARY KEY,
    kind VARCHAR(16) NOT NULL DEFAULT 'USER',
    status VARCHAR(16) NOT NULL DEFAULT 'ACTIVE',
    unit VARCHAR(3) NOT NULL DEFAULT 'FIC',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT accounts_kind CHECK (kind IN ('USER', 'ISSUANCE')),
    CONSTRAINT accounts_status CHECK (status IN ('ACTIVE', 'FROZEN')),
    CONSTRAINT accounts_unit CHECK (unit = 'FIC')
);

CREATE TABLE balances (
    account_id UUID PRIMARY KEY REFERENCES accounts(id),
    amount BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT balances_supported_range
        CHECK (amount BETWEEN -9000000000000000 AND 9000000000000000)
);

CREATE TABLE transfers (
    id UUID PRIMARY KEY,
    idempotency_key VARCHAR(128) NOT NULL UNIQUE,
    -- Requested identities deliberately have no FK: unknown-account rejection
    -- must be durable and replayable without creating a fictitious account.
    source_account_id UUID NOT NULL,
    destination_account_id UUID NOT NULL,
    amount BIGINT NOT NULL,
    unit VARCHAR(3) NOT NULL DEFAULT 'FIC',
    status VARCHAR(16) NOT NULL DEFAULT 'PROCESSING',
    rejection_code VARCHAR(64),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMPTZ,
    CONSTRAINT transfers_idempotency_key_nonblank
        CHECK (length(btrim(idempotency_key)) > 0),
    CONSTRAINT transfers_distinct_accounts
        CHECK (source_account_id <> destination_account_id),
    CONSTRAINT transfers_amount
        CHECK (amount > 0 AND amount <= 9000000000000000),
    CONSTRAINT transfers_unit CHECK (unit = 'FIC'),
    CONSTRAINT transfers_status
        CHECK (status IN ('PROCESSING', 'COMPLETED', 'REJECTED')),
    CONSTRAINT transfers_state_shape CHECK (
        (status = 'PROCESSING' AND completed_at IS NULL AND rejection_code IS NULL)
        OR (status = 'COMPLETED' AND completed_at IS NOT NULL AND rejection_code IS NULL)
        OR (status = 'REJECTED' AND completed_at IS NOT NULL
            AND rejection_code IS NOT NULL AND length(btrim(rejection_code)) > 0)
    ),
    CONSTRAINT transfers_completion_time
        CHECK (completed_at IS NULL OR completed_at >= created_at)
);

CREATE TABLE ledger_entries (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    transfer_id UUID NOT NULL REFERENCES transfers(id),
    account_id UUID NOT NULL REFERENCES accounts(id),
    delta BIGINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ledger_entries_delta
        CHECK (delta <> 0 AND delta BETWEEN -9000000000000000 AND 9000000000000000),
    CONSTRAINT ledger_entries_one_posting_per_account UNIQUE (transfer_id, account_id)
);

-- Supports descending keyset pagination and the account's authoritative SUM.
CREATE INDEX ledger_entries_account_id_id_idx ON ledger_entries (account_id, id DESC);

CREATE FUNCTION prevent_history_mutation() RETURNS TRIGGER
LANGUAGE plpgsql SET search_path = pg_catalog, public AS $$
BEGIN
    RAISE EXCEPTION '% on % is forbidden: financial history is immutable', TG_OP, TG_TABLE_NAME
        USING ERRCODE = '55000';
END;
$$;

CREATE TRIGGER ledger_entries_immutable
    BEFORE UPDATE OR DELETE ON ledger_entries
    FOR EACH ROW EXECUTE FUNCTION prevent_history_mutation();
CREATE TRIGGER accounts_no_delete
    BEFORE DELETE ON accounts
    FOR EACH ROW EXECUTE FUNCTION prevent_history_mutation();
CREATE TRIGGER balances_no_delete
    BEFORE DELETE ON balances
    FOR EACH ROW EXECUTE FUNCTION prevent_history_mutation();
CREATE TRIGGER transfers_no_delete
    BEFORE DELETE ON transfers
    FOR EACH ROW EXECUTE FUNCTION prevent_history_mutation();

-- TRUNCATE bypasses row triggers and therefore needs a separate guard.
CREATE TRIGGER accounts_no_truncate
    BEFORE TRUNCATE ON accounts
    FOR EACH STATEMENT EXECUTE FUNCTION prevent_history_mutation();
CREATE TRIGGER balances_no_truncate
    BEFORE TRUNCATE ON balances
    FOR EACH STATEMENT EXECUTE FUNCTION prevent_history_mutation();
CREATE TRIGGER transfers_no_truncate
    BEFORE TRUNCATE ON transfers
    FOR EACH STATEMENT EXECUTE FUNCTION prevent_history_mutation();
CREATE TRIGGER ledger_entries_no_truncate
    BEFORE TRUNCATE ON ledger_entries
    FOR EACH STATEMENT EXECUTE FUNCTION prevent_history_mutation();

CREATE FUNCTION guard_account_identity() RETURNS TRIGGER
LANGUAGE plpgsql SET search_path = pg_catalog, public AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF current_user = 'tpp_app' AND NEW.kind <> 'USER' THEN
            RAISE EXCEPTION 'Runtime role can only create USER accounts'
                USING ERRCODE = '42501';
        END IF;
        RETURN NEW;
    END IF;
    IF ROW(NEW.id, NEW.kind, NEW.unit, NEW.created_at)
       IS DISTINCT FROM ROW(OLD.id, OLD.kind, OLD.unit, OLD.created_at) THEN
        RAISE EXCEPTION 'Account identity, kind, unit and creation time are immutable'
            USING ERRCODE = '55000';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER accounts_guard
    BEFORE INSERT OR UPDATE ON accounts
    FOR EACH ROW EXECUTE FUNCTION guard_account_identity();

CREATE FUNCTION guard_balance() RETURNS TRIGGER
LANGUAGE plpgsql SET search_path = pg_catalog, public AS $$
DECLARE
    account_kind VARCHAR(16);
BEGIN
    IF TG_OP = 'UPDATE' AND NEW.account_id <> OLD.account_id THEN
        RAISE EXCEPTION 'Balance account identity is immutable' USING ERRCODE = '55000';
    END IF;
    SELECT kind INTO account_kind FROM public.accounts WHERE id = NEW.account_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Balance references an unknown account'
            USING ERRCODE = '23503';
    END IF;
    IF account_kind = 'USER' AND NEW.amount < 0 THEN
        RAISE EXCEPTION 'USER account balance cannot be negative'
            USING ERRCODE = '23514', CONSTRAINT = 'user_balances_nonnegative';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER balances_guard
    BEFORE INSERT OR UPDATE ON balances
    FOR EACH ROW EXECUTE FUNCTION guard_balance();

CREATE FUNCTION guard_transfer_transition() RETURNS TRIGGER
LANGUAGE plpgsql SET search_path = pg_catalog, public AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.status <> 'PROCESSING' THEN
            RAISE EXCEPTION 'A transfer must start in PROCESSING'
                USING ERRCODE = '23514', CONSTRAINT = 'transfers_valid_transition';
        END IF;
    ELSE
        IF OLD.status <> 'PROCESSING' THEN
            RAISE EXCEPTION 'Terminal transfers are immutable' USING ERRCODE = '55000';
        END IF;
        IF ROW(NEW.id, NEW.idempotency_key, NEW.source_account_id,
               NEW.destination_account_id, NEW.amount, NEW.unit, NEW.created_at)
           IS DISTINCT FROM ROW(OLD.id, OLD.idempotency_key, OLD.source_account_id,
               OLD.destination_account_id, OLD.amount, OLD.unit, OLD.created_at) THEN
            RAISE EXCEPTION 'Transfer request payload is immutable' USING ERRCODE = '55000';
        END IF;
        -- Reservation precedes business validation, so the runtime role may
        -- durably REJECT an issuance request, but cannot complete one.
        IF current_user = 'tpp_app' AND NEW.status = 'COMPLETED'
           AND EXISTS (SELECT 1 FROM public.accounts
                       WHERE id IN (NEW.source_account_id, NEW.destination_account_id)
                         AND kind = 'ISSUANCE') THEN
            RAISE EXCEPTION 'Runtime role cannot complete issuance transfers'
                USING ERRCODE = '42501';
        END IF;
        IF NEW.status NOT IN ('COMPLETED', 'REJECTED') THEN
            RAISE EXCEPTION 'PROCESSING must transition once to COMPLETED or REJECTED'
                USING ERRCODE = '23514', CONSTRAINT = 'transfers_valid_transition';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER transfers_guard
    BEFORE INSERT OR UPDATE ON transfers
    FOR EACH ROW EXECUTE FUNCTION guard_transfer_transition();

CREATE FUNCTION guard_ledger_insert() RETURNS TRIGGER
LANGUAGE plpgsql SET search_path = pg_catalog, public AS $$
DECLARE
    transfer_status VARCHAR(16);
BEGIN
    -- Holding the transfer row prevents a concurrent terminal transition from
    -- racing a posting. The application already owns this row after reservation.
    SELECT status INTO transfer_status
        FROM public.transfers WHERE id = NEW.transfer_id FOR UPDATE;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Ledger posting references an unknown transfer' USING ERRCODE = '23503';
    END IF;
    IF transfer_status <> 'PROCESSING' THEN
        RAISE EXCEPTION 'Ledger postings can only be appended to a PROCESSING transfer'
            USING ERRCODE = '55000';
    END IF;
    -- Every posting takes the projection row lock. Consequently even a direct
    -- SQL writer cannot race the deferred SUM against another ledger mutation.
    -- Application code locks BOTH balances in database UUID order beforehand;
    -- these are reentrant row locks and introduce no additional application order.
    PERFORM 1 FROM public.balances WHERE account_id = NEW.account_id FOR UPDATE;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Ledger posting requires an account balance' USING ERRCODE = '23503';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER ledger_entries_guard
    BEFORE INSERT ON ledger_entries
    FOR EACH ROW EXECUTE FUNCTION guard_ledger_insert();

CREATE FUNCTION require_account_balance() RETURNS TRIGGER
LANGUAGE plpgsql SET search_path = pg_catalog, public AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM public.balances WHERE account_id = NEW.id) THEN
        RAISE EXCEPTION 'Every account must have one balance row at commit'
            USING ERRCODE = '23514', CONSTRAINT = 'accounts_require_balance';
    END IF;
    RETURN NULL;
END;
$$;

CREATE CONSTRAINT TRIGGER accounts_require_balance
    AFTER INSERT ON accounts DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW EXECUTE FUNCTION require_account_balance();

CREATE FUNCTION verify_transfer_postings() RETURNS TRIGGER
LANGUAGE plpgsql SET search_path = pg_catalog, public AS $$
DECLARE
    final_transfer public.transfers%ROWTYPE;
    posting_count BIGINT;
    net_delta NUMERIC;
    debit_count BIGINT;
    credit_count BIGINT;
BEGIN
    SELECT * INTO STRICT final_transfer FROM public.transfers WHERE id = NEW.id;
    IF final_transfer.status = 'PROCESSING' THEN
        RAISE EXCEPTION 'PROCESSING is transient and cannot be committed'
            USING ERRCODE = '23514', CONSTRAINT = 'transfers_terminal_at_commit';
    END IF;

    SELECT count(*), COALESCE(sum(delta::NUMERIC), 0),
           count(*) FILTER (WHERE account_id = final_transfer.source_account_id
                            AND delta = -final_transfer.amount),
           count(*) FILTER (WHERE account_id = final_transfer.destination_account_id
                            AND delta = final_transfer.amount)
      INTO posting_count, net_delta, debit_count, credit_count
      FROM public.ledger_entries WHERE transfer_id = final_transfer.id;

    IF final_transfer.status = 'COMPLETED'
       AND (posting_count <> 2 OR net_delta <> 0 OR debit_count <> 1 OR credit_count <> 1) THEN
        RAISE EXCEPTION 'COMPLETED transfer requires exactly its source debit and destination credit'
            USING ERRCODE = '23514', CONSTRAINT = 'transfers_balanced_postings';
    END IF;
    IF final_transfer.status = 'REJECTED' AND posting_count <> 0 THEN
        RAISE EXCEPTION 'REJECTED transfer cannot have ledger postings'
            USING ERRCODE = '23514', CONSTRAINT = 'transfers_rejected_without_postings';
    END IF;
    RETURN NULL;
END;
$$;

CREATE CONSTRAINT TRIGGER transfers_verify_postings
    AFTER INSERT OR UPDATE ON transfers DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW EXECUTE FUNCTION verify_transfer_postings();

CREATE FUNCTION verify_balance_projection() RETURNS TRIGGER
LANGUAGE plpgsql SET search_path = pg_catalog, public AS $$
DECLARE
    projected_amount BIGINT;
    ledger_amount NUMERIC;
    account_kind VARCHAR(16);
BEGIN
    SELECT amount INTO STRICT projected_amount
        FROM public.balances WHERE account_id = NEW.account_id FOR UPDATE;
    -- Separate SQL statements intentionally give READ COMMITTED a fresh snapshot
    -- after acquiring the balance lock. SUM(NUMERIC) never overflows BIGINT.
    SELECT COALESCE(sum(delta::NUMERIC), 0) INTO ledger_amount
        FROM public.ledger_entries WHERE account_id = NEW.account_id;
    SELECT kind INTO STRICT account_kind FROM public.accounts WHERE id = NEW.account_id;
    IF projected_amount::NUMERIC <> ledger_amount THEN
        RAISE EXCEPTION 'Materialized balance differs from ledger sum for account %', NEW.account_id
            USING ERRCODE = '23514', CONSTRAINT = 'balances_match_ledger';
    END IF;
    IF account_kind = 'USER' AND projected_amount < 0 THEN
        RAISE EXCEPTION 'USER account balance cannot be negative'
            USING ERRCODE = '23514', CONSTRAINT = 'user_balances_nonnegative';
    END IF;
    RETURN NULL;
END;
$$;

CREATE CONSTRAINT TRIGGER balances_reconcile
    AFTER INSERT OR UPDATE ON balances DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW EXECUTE FUNCTION verify_balance_projection();
CREATE CONSTRAINT TRIGGER ledger_reconcile
    AFTER INSERT ON ledger_entries DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW EXECUTE FUNCTION verify_balance_projection();

-- Ownership/migrations remain separate from runtime privileges. Local initdb
-- creates tpp_app; generic Testcontainers databases may intentionally omit it.
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON FUNCTION prevent_history_mutation() FROM PUBLIC;
REVOKE ALL ON FUNCTION guard_account_identity() FROM PUBLIC;
REVOKE ALL ON FUNCTION guard_balance() FROM PUBLIC;
REVOKE ALL ON FUNCTION guard_transfer_transition() FROM PUBLIC;
REVOKE ALL ON FUNCTION guard_ledger_insert() FROM PUBLIC;
REVOKE ALL ON FUNCTION require_account_balance() FROM PUBLIC;
REVOKE ALL ON FUNCTION verify_transfer_postings() FROM PUBLIC;
REVOKE ALL ON FUNCTION verify_balance_projection() FROM PUBLIC;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_catalog.pg_roles WHERE rolname = 'tpp_app') THEN
        GRANT USAGE ON SCHEMA public TO tpp_app;
        GRANT SELECT, INSERT ON accounts TO tpp_app;
        GRANT UPDATE (status) ON accounts TO tpp_app;
        GRANT SELECT, INSERT, UPDATE ON balances, transfers TO tpp_app;
        GRANT SELECT, INSERT ON ledger_entries TO tpp_app;
        GRANT USAGE, SELECT ON SEQUENCE ledger_entries_id_seq TO tpp_app;
    END IF;
END;
$$;
