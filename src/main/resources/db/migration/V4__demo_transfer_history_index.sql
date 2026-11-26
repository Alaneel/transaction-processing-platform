-- Each fixed demo-account direction can seek a terminal decision cursor and stop
-- after the requested bounded page. No financial rows or prior migrations change.
CREATE INDEX transfers_terminal_pair_decided_idx
    ON transfers (source_account_id, destination_account_id, completed_at DESC, id DESC)
    WHERE status IN ('COMPLETED', 'REJECTED');
