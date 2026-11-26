-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('0043b70c-f6cf-5921-a70d-34b84c3e087d', 'USER', 'ACTIVE', 'FIC'),
('035ef5a9-ca37-5a2e-9447-95fc948b4b0f', 'USER', 'ACTIVE', 'FIC'),
('0763c833-3eb2-52a0-adda-c7bcc0680e9f', 'USER', 'ACTIVE', 'FIC'),
('085d6cf3-c068-5267-a648-9bf1262a2c76', 'USER', 'ACTIVE', 'FIC'),
('2484674d-6dbb-5a93-b176-4c2bc32d8a0e', 'USER', 'ACTIVE', 'FIC'),
('2573fddc-d60f-52ce-ae0a-10b8863c464d', 'USER', 'ACTIVE', 'FIC'),
('262ccec7-41ca-5c85-b509-85c30cad6cf2', 'USER', 'ACTIVE', 'FIC'),
('300cb485-78a4-50dc-aeb9-2cb55a408436', 'USER', 'ACTIVE', 'FIC'),
('3973d9be-747d-5562-971c-89de1a28f5c1', 'ISSUANCE', 'ACTIVE', 'FIC'),
('3bf4cb30-f829-576d-91a4-af1c364b559a', 'USER', 'ACTIVE', 'FIC'),
('41fbe292-53b1-59b3-9a7f-9d072e480cbb', 'USER', 'ACTIVE', 'FIC'),
('55499fe3-212b-5120-8ec9-c9fe60d937b9', 'USER', 'ACTIVE', 'FIC'),
('722f4ee5-55a3-5d96-aa26-50ee004b6e3c', 'USER', 'ACTIVE', 'FIC'),
('7532c20d-2d49-5712-810c-b8b442c3ebf7', 'USER', 'ACTIVE', 'FIC'),
('77d838ea-68e7-5ae3-86d5-8657359b5cda', 'USER', 'ACTIVE', 'FIC'),
('79429641-ffb8-55c5-99ae-2955d39853e5', 'USER', 'ACTIVE', 'FIC'),
('7cc88e7c-e10e-51bb-8e3a-4d6081d0ba1a', 'USER', 'ACTIVE', 'FIC'),
('882f55c2-d7d0-54bf-bc69-00d393400d45', 'USER', 'ACTIVE', 'FIC'),
('8f28ccc9-7f98-53b4-9593-110b21b7a1af', 'USER', 'ACTIVE', 'FIC'),
('95a72116-7a46-5829-918c-3cac65056c99', 'USER', 'ACTIVE', 'FIC'),
('a462a603-5a1f-58b4-8a3d-85e7272a6424', 'USER', 'ACTIVE', 'FIC'),
('a5ca89da-d444-5be8-8e78-237082ddc8ad', 'USER', 'ACTIVE', 'FIC'),
('b034470f-485e-5715-98d6-9ca5f934740c', 'USER', 'ACTIVE', 'FIC'),
('b157b7af-bed5-5549-8e67-29c37e6dc71c', 'USER', 'ACTIVE', 'FIC'),
('beb66514-9423-569a-8a7e-6e44b5a3edfe', 'USER', 'ACTIVE', 'FIC'),
('fdef6c75-914c-5bab-afa5-6f15815b0705', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('0043b70c-f6cf-5921-a70d-34b84c3e087d', 0),
('035ef5a9-ca37-5a2e-9447-95fc948b4b0f', 0),
('0763c833-3eb2-52a0-adda-c7bcc0680e9f', 0),
('085d6cf3-c068-5267-a648-9bf1262a2c76', 0),
('2484674d-6dbb-5a93-b176-4c2bc32d8a0e', 0),
('2573fddc-d60f-52ce-ae0a-10b8863c464d', 0),
('262ccec7-41ca-5c85-b509-85c30cad6cf2', 0),
('300cb485-78a4-50dc-aeb9-2cb55a408436', 0),
('3973d9be-747d-5562-971c-89de1a28f5c1', 0),
('3bf4cb30-f829-576d-91a4-af1c364b559a', 0),
('41fbe292-53b1-59b3-9a7f-9d072e480cbb', 0),
('55499fe3-212b-5120-8ec9-c9fe60d937b9', 0),
('722f4ee5-55a3-5d96-aa26-50ee004b6e3c', 0),
('7532c20d-2d49-5712-810c-b8b442c3ebf7', 0),
('77d838ea-68e7-5ae3-86d5-8657359b5cda', 0),
('79429641-ffb8-55c5-99ae-2955d39853e5', 0),
('7cc88e7c-e10e-51bb-8e3a-4d6081d0ba1a', 0),
('882f55c2-d7d0-54bf-bc69-00d393400d45', 0),
('8f28ccc9-7f98-53b4-9593-110b21b7a1af', 0),
('95a72116-7a46-5829-918c-3cac65056c99', 0),
('a462a603-5a1f-58b4-8a3d-85e7272a6424', 0),
('a5ca89da-d444-5be8-8e78-237082ddc8ad', 0),
('b034470f-485e-5715-98d6-9ca5f934740c', 0),
('b157b7af-bed5-5549-8e67-29c37e6dc71c', 0),
('beb66514-9423-569a-8a7e-6e44b5a3edfe', 0),
('fdef6c75-914c-5bab-afa5-6f15815b0705', 0);
SELECT account_id FROM balances WHERE account_id IN ('0043b70c-f6cf-5921-a70d-34b84c3e087d','035ef5a9-ca37-5a2e-9447-95fc948b4b0f','0763c833-3eb2-52a0-adda-c7bcc0680e9f','085d6cf3-c068-5267-a648-9bf1262a2c76','2484674d-6dbb-5a93-b176-4c2bc32d8a0e','2573fddc-d60f-52ce-ae0a-10b8863c464d','262ccec7-41ca-5c85-b509-85c30cad6cf2','300cb485-78a4-50dc-aeb9-2cb55a408436','3973d9be-747d-5562-971c-89de1a28f5c1','3bf4cb30-f829-576d-91a4-af1c364b559a','41fbe292-53b1-59b3-9a7f-9d072e480cbb','55499fe3-212b-5120-8ec9-c9fe60d937b9','722f4ee5-55a3-5d96-aa26-50ee004b6e3c','7532c20d-2d49-5712-810c-b8b442c3ebf7','77d838ea-68e7-5ae3-86d5-8657359b5cda','79429641-ffb8-55c5-99ae-2955d39853e5','7cc88e7c-e10e-51bb-8e3a-4d6081d0ba1a','882f55c2-d7d0-54bf-bc69-00d393400d45','8f28ccc9-7f98-53b4-9593-110b21b7a1af','95a72116-7a46-5829-918c-3cac65056c99','a462a603-5a1f-58b4-8a3d-85e7272a6424','a5ca89da-d444-5be8-8e78-237082ddc8ad','b034470f-485e-5715-98d6-9ca5f934740c','b157b7af-bed5-5549-8e67-29c37e6dc71c','beb66514-9423-569a-8a7e-6e44b5a3edfe','fdef6c75-914c-5bab-afa5-6f15815b0705') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0a552eb4-6879-565b-9c47-8de7eb36e54c', 'benchmark-funding-d83500b8-87a0-451e-a964-c99c718efcbb-0', '3973d9be-747d-5562-971c-89de1a28f5c1', 'beb66514-9423-569a-8a7e-6e44b5a3edfe', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3973d9be-747d-5562-971c-89de1a28f5c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'beb66514-9423-569a-8a7e-6e44b5a3edfe';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0a552eb4-6879-565b-9c47-8de7eb36e54c', '3973d9be-747d-5562-971c-89de1a28f5c1', -1000000000), ('0a552eb4-6879-565b-9c47-8de7eb36e54c', 'beb66514-9423-569a-8a7e-6e44b5a3edfe', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0a552eb4-6879-565b-9c47-8de7eb36e54c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('11918158-07e1-53b5-b82c-437afc396d66', 'benchmark-funding-d83500b8-87a0-451e-a964-c99c718efcbb-1', '3973d9be-747d-5562-971c-89de1a28f5c1', '035ef5a9-ca37-5a2e-9447-95fc948b4b0f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3973d9be-747d-5562-971c-89de1a28f5c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '035ef5a9-ca37-5a2e-9447-95fc948b4b0f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('11918158-07e1-53b5-b82c-437afc396d66', '3973d9be-747d-5562-971c-89de1a28f5c1', -1000000000), ('11918158-07e1-53b5-b82c-437afc396d66', '035ef5a9-ca37-5a2e-9447-95fc948b4b0f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '11918158-07e1-53b5-b82c-437afc396d66';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('46216968-d253-5b10-b1d9-8b1ea07dcf1e', 'benchmark-funding-d83500b8-87a0-451e-a964-c99c718efcbb-2', '3973d9be-747d-5562-971c-89de1a28f5c1', '262ccec7-41ca-5c85-b509-85c30cad6cf2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3973d9be-747d-5562-971c-89de1a28f5c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '262ccec7-41ca-5c85-b509-85c30cad6cf2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('46216968-d253-5b10-b1d9-8b1ea07dcf1e', '3973d9be-747d-5562-971c-89de1a28f5c1', -1000000000), ('46216968-d253-5b10-b1d9-8b1ea07dcf1e', '262ccec7-41ca-5c85-b509-85c30cad6cf2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '46216968-d253-5b10-b1d9-8b1ea07dcf1e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1b096031-b5da-5b73-9f0e-90b31c6bc002', 'benchmark-funding-d83500b8-87a0-451e-a964-c99c718efcbb-3', '3973d9be-747d-5562-971c-89de1a28f5c1', '41fbe292-53b1-59b3-9a7f-9d072e480cbb', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3973d9be-747d-5562-971c-89de1a28f5c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '41fbe292-53b1-59b3-9a7f-9d072e480cbb';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1b096031-b5da-5b73-9f0e-90b31c6bc002', '3973d9be-747d-5562-971c-89de1a28f5c1', -1000000000), ('1b096031-b5da-5b73-9f0e-90b31c6bc002', '41fbe292-53b1-59b3-9a7f-9d072e480cbb', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1b096031-b5da-5b73-9f0e-90b31c6bc002';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('646343f9-a3d0-50d9-b2e1-62f20934c2a5', 'benchmark-funding-d83500b8-87a0-451e-a964-c99c718efcbb-4', '3973d9be-747d-5562-971c-89de1a28f5c1', '79429641-ffb8-55c5-99ae-2955d39853e5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3973d9be-747d-5562-971c-89de1a28f5c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '79429641-ffb8-55c5-99ae-2955d39853e5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('646343f9-a3d0-50d9-b2e1-62f20934c2a5', '3973d9be-747d-5562-971c-89de1a28f5c1', -1000000000), ('646343f9-a3d0-50d9-b2e1-62f20934c2a5', '79429641-ffb8-55c5-99ae-2955d39853e5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '646343f9-a3d0-50d9-b2e1-62f20934c2a5';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5c8b201e-c695-5128-aeb6-e673ef4d1e20', 'benchmark-funding-d83500b8-87a0-451e-a964-c99c718efcbb-5', '3973d9be-747d-5562-971c-89de1a28f5c1', 'a5ca89da-d444-5be8-8e78-237082ddc8ad', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3973d9be-747d-5562-971c-89de1a28f5c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a5ca89da-d444-5be8-8e78-237082ddc8ad';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5c8b201e-c695-5128-aeb6-e673ef4d1e20', '3973d9be-747d-5562-971c-89de1a28f5c1', -1000000000), ('5c8b201e-c695-5128-aeb6-e673ef4d1e20', 'a5ca89da-d444-5be8-8e78-237082ddc8ad', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5c8b201e-c695-5128-aeb6-e673ef4d1e20';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('681ec347-d137-5401-9731-4b88c59de685', 'benchmark-funding-d83500b8-87a0-451e-a964-c99c718efcbb-6', '3973d9be-747d-5562-971c-89de1a28f5c1', '882f55c2-d7d0-54bf-bc69-00d393400d45', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3973d9be-747d-5562-971c-89de1a28f5c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '882f55c2-d7d0-54bf-bc69-00d393400d45';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('681ec347-d137-5401-9731-4b88c59de685', '3973d9be-747d-5562-971c-89de1a28f5c1', -1000000000), ('681ec347-d137-5401-9731-4b88c59de685', '882f55c2-d7d0-54bf-bc69-00d393400d45', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '681ec347-d137-5401-9731-4b88c59de685';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('bcd92e9a-ce4b-5b25-97eb-732048a308ba', 'benchmark-funding-d83500b8-87a0-451e-a964-c99c718efcbb-7', '3973d9be-747d-5562-971c-89de1a28f5c1', '300cb485-78a4-50dc-aeb9-2cb55a408436', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3973d9be-747d-5562-971c-89de1a28f5c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '300cb485-78a4-50dc-aeb9-2cb55a408436';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('bcd92e9a-ce4b-5b25-97eb-732048a308ba', '3973d9be-747d-5562-971c-89de1a28f5c1', -1000000000), ('bcd92e9a-ce4b-5b25-97eb-732048a308ba', '300cb485-78a4-50dc-aeb9-2cb55a408436', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'bcd92e9a-ce4b-5b25-97eb-732048a308ba';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('291b5e18-4107-5c08-9aa8-5ffab37008f6', 'benchmark-funding-d83500b8-87a0-451e-a964-c99c718efcbb-8', '3973d9be-747d-5562-971c-89de1a28f5c1', '7532c20d-2d49-5712-810c-b8b442c3ebf7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3973d9be-747d-5562-971c-89de1a28f5c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7532c20d-2d49-5712-810c-b8b442c3ebf7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('291b5e18-4107-5c08-9aa8-5ffab37008f6', '3973d9be-747d-5562-971c-89de1a28f5c1', -1000000000), ('291b5e18-4107-5c08-9aa8-5ffab37008f6', '7532c20d-2d49-5712-810c-b8b442c3ebf7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '291b5e18-4107-5c08-9aa8-5ffab37008f6';
COMMIT;
