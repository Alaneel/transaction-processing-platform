-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('08a62257-0ff2-5027-ac8d-b63d7ee1a515', 'USER', 'ACTIVE', 'FIC'),
('192ef3d4-de73-5ec8-8d22-0be458f6ebf9', 'USER', 'ACTIVE', 'FIC'),
('1d1c2fdc-9198-5456-a34c-dd70122ad901', 'USER', 'ACTIVE', 'FIC'),
('1f9c8295-8422-548d-a026-f7b71439952c', 'ISSUANCE', 'ACTIVE', 'FIC'),
('30526516-4d21-519c-9a6f-eb1bf2c1bbd2', 'USER', 'ACTIVE', 'FIC'),
('461f973f-00c2-5510-a188-791194c71a43', 'USER', 'ACTIVE', 'FIC'),
('4943f2e1-d06c-5295-b32f-d1714c533897', 'USER', 'ACTIVE', 'FIC'),
('549117ad-4997-57ba-b043-fc46b644b901', 'USER', 'ACTIVE', 'FIC'),
('584c823f-da64-5d4e-8b8f-e951228c5286', 'USER', 'ACTIVE', 'FIC'),
('6bb30367-62c4-5585-9a6e-22986639e60a', 'USER', 'ACTIVE', 'FIC'),
('92dbc20b-d521-5277-aed0-de994b7de1a7', 'USER', 'ACTIVE', 'FIC'),
('9dda891b-cb03-5fb9-a595-0b7418ca9b54', 'USER', 'ACTIVE', 'FIC'),
('b20cf5ef-2735-54d9-bbac-005ae90b75cb', 'USER', 'ACTIVE', 'FIC'),
('b25a2ff9-10ba-56db-a548-e844fd14befd', 'USER', 'ACTIVE', 'FIC'),
('b2b5b4e7-2920-554f-ae2b-b3ee5738ff5e', 'USER', 'ACTIVE', 'FIC'),
('bb578a71-57d6-5dba-916e-cb7ed606a7d9', 'USER', 'ACTIVE', 'FIC'),
('bb77f847-6227-55e1-9abe-2af1d1a29902', 'USER', 'ACTIVE', 'FIC'),
('c9cd1812-e870-5626-bea3-b0443fbb5bc5', 'USER', 'ACTIVE', 'FIC'),
('e10a4b52-ed4e-5cf7-880e-74d71865aad5', 'USER', 'ACTIVE', 'FIC'),
('e2a9614f-d3b9-5220-ae94-14ef5a88b41b', 'USER', 'ACTIVE', 'FIC'),
('ea508609-77b7-595f-b950-6b5c2af8ec1b', 'USER', 'ACTIVE', 'FIC'),
('eba279ad-5566-5c58-8e00-0c0c4e50ea5a', 'USER', 'ACTIVE', 'FIC'),
('ec128d2f-9e25-5bbc-b0ce-5886297aa117', 'USER', 'ACTIVE', 'FIC'),
('ee78f7c2-5322-5146-928f-b1be81500887', 'USER', 'ACTIVE', 'FIC'),
('f64ef0f4-0f2c-5ac6-ba7a-1d23706d7234', 'USER', 'ACTIVE', 'FIC'),
('fe168250-127b-5273-81b5-e96e4a9c6099', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('08a62257-0ff2-5027-ac8d-b63d7ee1a515', 0),
('192ef3d4-de73-5ec8-8d22-0be458f6ebf9', 0),
('1d1c2fdc-9198-5456-a34c-dd70122ad901', 0),
('1f9c8295-8422-548d-a026-f7b71439952c', 0),
('30526516-4d21-519c-9a6f-eb1bf2c1bbd2', 0),
('461f973f-00c2-5510-a188-791194c71a43', 0),
('4943f2e1-d06c-5295-b32f-d1714c533897', 0),
('549117ad-4997-57ba-b043-fc46b644b901', 0),
('584c823f-da64-5d4e-8b8f-e951228c5286', 0),
('6bb30367-62c4-5585-9a6e-22986639e60a', 0),
('92dbc20b-d521-5277-aed0-de994b7de1a7', 0),
('9dda891b-cb03-5fb9-a595-0b7418ca9b54', 0),
('b20cf5ef-2735-54d9-bbac-005ae90b75cb', 0),
('b25a2ff9-10ba-56db-a548-e844fd14befd', 0),
('b2b5b4e7-2920-554f-ae2b-b3ee5738ff5e', 0),
('bb578a71-57d6-5dba-916e-cb7ed606a7d9', 0),
('bb77f847-6227-55e1-9abe-2af1d1a29902', 0),
('c9cd1812-e870-5626-bea3-b0443fbb5bc5', 0),
('e10a4b52-ed4e-5cf7-880e-74d71865aad5', 0),
('e2a9614f-d3b9-5220-ae94-14ef5a88b41b', 0),
('ea508609-77b7-595f-b950-6b5c2af8ec1b', 0),
('eba279ad-5566-5c58-8e00-0c0c4e50ea5a', 0),
('ec128d2f-9e25-5bbc-b0ce-5886297aa117', 0),
('ee78f7c2-5322-5146-928f-b1be81500887', 0),
('f64ef0f4-0f2c-5ac6-ba7a-1d23706d7234', 0),
('fe168250-127b-5273-81b5-e96e4a9c6099', 0);
SELECT account_id FROM balances WHERE account_id IN ('08a62257-0ff2-5027-ac8d-b63d7ee1a515','192ef3d4-de73-5ec8-8d22-0be458f6ebf9','1d1c2fdc-9198-5456-a34c-dd70122ad901','1f9c8295-8422-548d-a026-f7b71439952c','30526516-4d21-519c-9a6f-eb1bf2c1bbd2','461f973f-00c2-5510-a188-791194c71a43','4943f2e1-d06c-5295-b32f-d1714c533897','549117ad-4997-57ba-b043-fc46b644b901','584c823f-da64-5d4e-8b8f-e951228c5286','6bb30367-62c4-5585-9a6e-22986639e60a','92dbc20b-d521-5277-aed0-de994b7de1a7','9dda891b-cb03-5fb9-a595-0b7418ca9b54','b20cf5ef-2735-54d9-bbac-005ae90b75cb','b25a2ff9-10ba-56db-a548-e844fd14befd','b2b5b4e7-2920-554f-ae2b-b3ee5738ff5e','bb578a71-57d6-5dba-916e-cb7ed606a7d9','bb77f847-6227-55e1-9abe-2af1d1a29902','c9cd1812-e870-5626-bea3-b0443fbb5bc5','e10a4b52-ed4e-5cf7-880e-74d71865aad5','e2a9614f-d3b9-5220-ae94-14ef5a88b41b','ea508609-77b7-595f-b950-6b5c2af8ec1b','eba279ad-5566-5c58-8e00-0c0c4e50ea5a','ec128d2f-9e25-5bbc-b0ce-5886297aa117','ee78f7c2-5322-5146-928f-b1be81500887','f64ef0f4-0f2c-5ac6-ba7a-1d23706d7234','fe168250-127b-5273-81b5-e96e4a9c6099') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c59d662d-e74e-5611-8b3c-cc639aea92d7', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-0', '1f9c8295-8422-548d-a026-f7b71439952c', 'b2b5b4e7-2920-554f-ae2b-b3ee5738ff5e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b2b5b4e7-2920-554f-ae2b-b3ee5738ff5e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c59d662d-e74e-5611-8b3c-cc639aea92d7', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('c59d662d-e74e-5611-8b3c-cc639aea92d7', 'b2b5b4e7-2920-554f-ae2b-b3ee5738ff5e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c59d662d-e74e-5611-8b3c-cc639aea92d7';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('19df47ae-9e07-5407-b5f3-2cda5222b886', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-1', '1f9c8295-8422-548d-a026-f7b71439952c', '92dbc20b-d521-5277-aed0-de994b7de1a7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '92dbc20b-d521-5277-aed0-de994b7de1a7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('19df47ae-9e07-5407-b5f3-2cda5222b886', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('19df47ae-9e07-5407-b5f3-2cda5222b886', '92dbc20b-d521-5277-aed0-de994b7de1a7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '19df47ae-9e07-5407-b5f3-2cda5222b886';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('aa3a7dbc-a8e9-50f3-84ee-f223619114d8', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-2', '1f9c8295-8422-548d-a026-f7b71439952c', '9dda891b-cb03-5fb9-a595-0b7418ca9b54', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9dda891b-cb03-5fb9-a595-0b7418ca9b54';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('aa3a7dbc-a8e9-50f3-84ee-f223619114d8', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('aa3a7dbc-a8e9-50f3-84ee-f223619114d8', '9dda891b-cb03-5fb9-a595-0b7418ca9b54', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'aa3a7dbc-a8e9-50f3-84ee-f223619114d8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f7fe2835-6427-5cfa-8323-1d66f6449cf9', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-3', '1f9c8295-8422-548d-a026-f7b71439952c', 'fe168250-127b-5273-81b5-e96e4a9c6099', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fe168250-127b-5273-81b5-e96e4a9c6099';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f7fe2835-6427-5cfa-8323-1d66f6449cf9', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('f7fe2835-6427-5cfa-8323-1d66f6449cf9', 'fe168250-127b-5273-81b5-e96e4a9c6099', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f7fe2835-6427-5cfa-8323-1d66f6449cf9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5e60914b-b1f6-5a13-a4da-22ba01316894', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-4', '1f9c8295-8422-548d-a026-f7b71439952c', '4943f2e1-d06c-5295-b32f-d1714c533897', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4943f2e1-d06c-5295-b32f-d1714c533897';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5e60914b-b1f6-5a13-a4da-22ba01316894', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('5e60914b-b1f6-5a13-a4da-22ba01316894', '4943f2e1-d06c-5295-b32f-d1714c533897', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5e60914b-b1f6-5a13-a4da-22ba01316894';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('670151b9-1e1f-5904-8258-ec2fa2e5d665', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-5', '1f9c8295-8422-548d-a026-f7b71439952c', 'b25a2ff9-10ba-56db-a548-e844fd14befd', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b25a2ff9-10ba-56db-a548-e844fd14befd';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('670151b9-1e1f-5904-8258-ec2fa2e5d665', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('670151b9-1e1f-5904-8258-ec2fa2e5d665', 'b25a2ff9-10ba-56db-a548-e844fd14befd', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '670151b9-1e1f-5904-8258-ec2fa2e5d665';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c2b05373-9ed4-5354-982d-d7acc309a12b', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-6', '1f9c8295-8422-548d-a026-f7b71439952c', '08a62257-0ff2-5027-ac8d-b63d7ee1a515', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '08a62257-0ff2-5027-ac8d-b63d7ee1a515';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c2b05373-9ed4-5354-982d-d7acc309a12b', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('c2b05373-9ed4-5354-982d-d7acc309a12b', '08a62257-0ff2-5027-ac8d-b63d7ee1a515', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c2b05373-9ed4-5354-982d-d7acc309a12b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('87a88d8f-738b-51c3-a1f6-2ecec4900567', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-7', '1f9c8295-8422-548d-a026-f7b71439952c', '1d1c2fdc-9198-5456-a34c-dd70122ad901', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1d1c2fdc-9198-5456-a34c-dd70122ad901';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('87a88d8f-738b-51c3-a1f6-2ecec4900567', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('87a88d8f-738b-51c3-a1f6-2ecec4900567', '1d1c2fdc-9198-5456-a34c-dd70122ad901', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '87a88d8f-738b-51c3-a1f6-2ecec4900567';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7ed90aaa-57f0-5ef4-aeea-a5385713dcd5', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-8', '1f9c8295-8422-548d-a026-f7b71439952c', '549117ad-4997-57ba-b043-fc46b644b901', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '549117ad-4997-57ba-b043-fc46b644b901';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7ed90aaa-57f0-5ef4-aeea-a5385713dcd5', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('7ed90aaa-57f0-5ef4-aeea-a5385713dcd5', '549117ad-4997-57ba-b043-fc46b644b901', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7ed90aaa-57f0-5ef4-aeea-a5385713dcd5';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e9a2bd74-5481-54c6-b541-830605f8b460', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-9', '1f9c8295-8422-548d-a026-f7b71439952c', 'f64ef0f4-0f2c-5ac6-ba7a-1d23706d7234', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f64ef0f4-0f2c-5ac6-ba7a-1d23706d7234';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e9a2bd74-5481-54c6-b541-830605f8b460', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('e9a2bd74-5481-54c6-b541-830605f8b460', 'f64ef0f4-0f2c-5ac6-ba7a-1d23706d7234', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e9a2bd74-5481-54c6-b541-830605f8b460';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('14fc5281-13f5-5e1f-a560-e5ceaf929202', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-10', '1f9c8295-8422-548d-a026-f7b71439952c', 'e10a4b52-ed4e-5cf7-880e-74d71865aad5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e10a4b52-ed4e-5cf7-880e-74d71865aad5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('14fc5281-13f5-5e1f-a560-e5ceaf929202', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('14fc5281-13f5-5e1f-a560-e5ceaf929202', 'e10a4b52-ed4e-5cf7-880e-74d71865aad5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '14fc5281-13f5-5e1f-a560-e5ceaf929202';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4cb5ceb3-26a8-5a33-9c11-eca76b4215ae', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-11', '1f9c8295-8422-548d-a026-f7b71439952c', 'ee78f7c2-5322-5146-928f-b1be81500887', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ee78f7c2-5322-5146-928f-b1be81500887';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4cb5ceb3-26a8-5a33-9c11-eca76b4215ae', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('4cb5ceb3-26a8-5a33-9c11-eca76b4215ae', 'ee78f7c2-5322-5146-928f-b1be81500887', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4cb5ceb3-26a8-5a33-9c11-eca76b4215ae';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d2e0c1d4-d329-522a-8429-6402f6deffda', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-12', '1f9c8295-8422-548d-a026-f7b71439952c', 'e2a9614f-d3b9-5220-ae94-14ef5a88b41b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e2a9614f-d3b9-5220-ae94-14ef5a88b41b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d2e0c1d4-d329-522a-8429-6402f6deffda', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('d2e0c1d4-d329-522a-8429-6402f6deffda', 'e2a9614f-d3b9-5220-ae94-14ef5a88b41b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd2e0c1d4-d329-522a-8429-6402f6deffda';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('799f3896-354b-550d-80b1-278a56cba1fd', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-13', '1f9c8295-8422-548d-a026-f7b71439952c', '192ef3d4-de73-5ec8-8d22-0be458f6ebf9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '192ef3d4-de73-5ec8-8d22-0be458f6ebf9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('799f3896-354b-550d-80b1-278a56cba1fd', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('799f3896-354b-550d-80b1-278a56cba1fd', '192ef3d4-de73-5ec8-8d22-0be458f6ebf9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '799f3896-354b-550d-80b1-278a56cba1fd';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('2f8379e0-7ea8-5e12-949d-4df2015d631b', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-14', '1f9c8295-8422-548d-a026-f7b71439952c', '584c823f-da64-5d4e-8b8f-e951228c5286', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '584c823f-da64-5d4e-8b8f-e951228c5286';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('2f8379e0-7ea8-5e12-949d-4df2015d631b', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('2f8379e0-7ea8-5e12-949d-4df2015d631b', '584c823f-da64-5d4e-8b8f-e951228c5286', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '2f8379e0-7ea8-5e12-949d-4df2015d631b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1f257458-3b8e-5367-895c-26398e9fc099', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-15', '1f9c8295-8422-548d-a026-f7b71439952c', 'bb77f847-6227-55e1-9abe-2af1d1a29902', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'bb77f847-6227-55e1-9abe-2af1d1a29902';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1f257458-3b8e-5367-895c-26398e9fc099', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('1f257458-3b8e-5367-895c-26398e9fc099', 'bb77f847-6227-55e1-9abe-2af1d1a29902', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1f257458-3b8e-5367-895c-26398e9fc099';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e797b3a4-7069-5299-8dc6-56a553b4132f', 'benchmark-funding-119bdc69-8e2f-4b30-8285-7264b312fca5-16', '1f9c8295-8422-548d-a026-f7b71439952c', 'ec128d2f-9e25-5bbc-b0ce-5886297aa117', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1f9c8295-8422-548d-a026-f7b71439952c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ec128d2f-9e25-5bbc-b0ce-5886297aa117';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e797b3a4-7069-5299-8dc6-56a553b4132f', '1f9c8295-8422-548d-a026-f7b71439952c', -1000000000), ('e797b3a4-7069-5299-8dc6-56a553b4132f', 'ec128d2f-9e25-5bbc-b0ce-5886297aa117', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e797b3a4-7069-5299-8dc6-56a553b4132f';
COMMIT;
