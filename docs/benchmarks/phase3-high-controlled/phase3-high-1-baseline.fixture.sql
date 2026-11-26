-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('02852544-d57d-5669-9b27-f075a30511f7', 'USER', 'ACTIVE', 'FIC'),
('028867ea-9895-5d2f-a458-0bf14f317288', 'USER', 'ACTIVE', 'FIC'),
('052d6a4d-0a1f-53c1-b8db-f889fc031ad1', 'USER', 'ACTIVE', 'FIC'),
('059cc10a-477f-57b7-aaf8-bdbab04065d8', 'USER', 'ACTIVE', 'FIC'),
('0707126e-736d-5780-8a94-45d66fc0f1b4', 'USER', 'ACTIVE', 'FIC'),
('089e4b17-4374-515b-963e-e529d962e606', 'USER', 'ACTIVE', 'FIC'),
('089f64d8-a1d5-5c20-bf54-b8064775d187', 'USER', 'ACTIVE', 'FIC'),
('0b3ea53f-d40a-566f-8a65-c88504bfb065', 'USER', 'ACTIVE', 'FIC'),
('0bda6ed5-02c6-5ec5-b6dc-563a3f0736dc', 'USER', 'ACTIVE', 'FIC'),
('0fdf594a-70fc-5507-b51a-a326175098aa', 'USER', 'ACTIVE', 'FIC'),
('1939e950-5ae1-5456-b2eb-62e9250f39c4', 'USER', 'ACTIVE', 'FIC'),
('3245d7df-a4af-52ee-9053-9fbb4d4140c1', 'USER', 'ACTIVE', 'FIC'),
('3fe86036-a362-5b03-bac7-9f53a1bc0c05', 'USER', 'ACTIVE', 'FIC'),
('5513b023-2d63-5dbd-a219-eeaf7703270d', 'USER', 'ACTIVE', 'FIC'),
('64757863-a615-55a1-9179-19d3031bb166', 'USER', 'ACTIVE', 'FIC'),
('684a6280-2931-5e68-89af-cfc85c8d3723', 'USER', 'ACTIVE', 'FIC'),
('6b1473c4-aba0-5138-bfda-5744e1917705', 'USER', 'ACTIVE', 'FIC'),
('8e39e793-f2c1-540a-9e64-c23a976b6e44', 'USER', 'ACTIVE', 'FIC'),
('9429082e-afab-5c9c-91ec-699f0895daeb', 'USER', 'ACTIVE', 'FIC'),
('9b5d828a-5ef3-5303-afb9-01eb34670382', 'USER', 'ACTIVE', 'FIC'),
('a6d5f2b3-4657-5f07-988d-6c4a8521bc03', 'ISSUANCE', 'ACTIVE', 'FIC'),
('a70b44f8-af53-5e40-be47-eb291b673d8f', 'USER', 'ACTIVE', 'FIC'),
('aa3c6ede-2f30-51f7-93b1-4842bcccfc3c', 'USER', 'ACTIVE', 'FIC'),
('bb7da290-438b-5a0a-b31c-3b88ee5d795e', 'USER', 'ACTIVE', 'FIC'),
('d89b8ec8-e8fe-5c44-b5cb-7e3591713f6b', 'USER', 'ACTIVE', 'FIC'),
('f165f28f-5572-58f7-91d8-8e7f1f10ee9a', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('02852544-d57d-5669-9b27-f075a30511f7', 0),
('028867ea-9895-5d2f-a458-0bf14f317288', 0),
('052d6a4d-0a1f-53c1-b8db-f889fc031ad1', 0),
('059cc10a-477f-57b7-aaf8-bdbab04065d8', 0),
('0707126e-736d-5780-8a94-45d66fc0f1b4', 0),
('089e4b17-4374-515b-963e-e529d962e606', 0),
('089f64d8-a1d5-5c20-bf54-b8064775d187', 0),
('0b3ea53f-d40a-566f-8a65-c88504bfb065', 0),
('0bda6ed5-02c6-5ec5-b6dc-563a3f0736dc', 0),
('0fdf594a-70fc-5507-b51a-a326175098aa', 0),
('1939e950-5ae1-5456-b2eb-62e9250f39c4', 0),
('3245d7df-a4af-52ee-9053-9fbb4d4140c1', 0),
('3fe86036-a362-5b03-bac7-9f53a1bc0c05', 0),
('5513b023-2d63-5dbd-a219-eeaf7703270d', 0),
('64757863-a615-55a1-9179-19d3031bb166', 0),
('684a6280-2931-5e68-89af-cfc85c8d3723', 0),
('6b1473c4-aba0-5138-bfda-5744e1917705', 0),
('8e39e793-f2c1-540a-9e64-c23a976b6e44', 0),
('9429082e-afab-5c9c-91ec-699f0895daeb', 0),
('9b5d828a-5ef3-5303-afb9-01eb34670382', 0),
('a6d5f2b3-4657-5f07-988d-6c4a8521bc03', 0),
('a70b44f8-af53-5e40-be47-eb291b673d8f', 0),
('aa3c6ede-2f30-51f7-93b1-4842bcccfc3c', 0),
('bb7da290-438b-5a0a-b31c-3b88ee5d795e', 0),
('d89b8ec8-e8fe-5c44-b5cb-7e3591713f6b', 0),
('f165f28f-5572-58f7-91d8-8e7f1f10ee9a', 0);
SELECT account_id FROM balances WHERE account_id IN ('02852544-d57d-5669-9b27-f075a30511f7','028867ea-9895-5d2f-a458-0bf14f317288','052d6a4d-0a1f-53c1-b8db-f889fc031ad1','059cc10a-477f-57b7-aaf8-bdbab04065d8','0707126e-736d-5780-8a94-45d66fc0f1b4','089e4b17-4374-515b-963e-e529d962e606','089f64d8-a1d5-5c20-bf54-b8064775d187','0b3ea53f-d40a-566f-8a65-c88504bfb065','0bda6ed5-02c6-5ec5-b6dc-563a3f0736dc','0fdf594a-70fc-5507-b51a-a326175098aa','1939e950-5ae1-5456-b2eb-62e9250f39c4','3245d7df-a4af-52ee-9053-9fbb4d4140c1','3fe86036-a362-5b03-bac7-9f53a1bc0c05','5513b023-2d63-5dbd-a219-eeaf7703270d','64757863-a615-55a1-9179-19d3031bb166','684a6280-2931-5e68-89af-cfc85c8d3723','6b1473c4-aba0-5138-bfda-5744e1917705','8e39e793-f2c1-540a-9e64-c23a976b6e44','9429082e-afab-5c9c-91ec-699f0895daeb','9b5d828a-5ef3-5303-afb9-01eb34670382','a6d5f2b3-4657-5f07-988d-6c4a8521bc03','a70b44f8-af53-5e40-be47-eb291b673d8f','aa3c6ede-2f30-51f7-93b1-4842bcccfc3c','bb7da290-438b-5a0a-b31c-3b88ee5d795e','d89b8ec8-e8fe-5c44-b5cb-7e3591713f6b','f165f28f-5572-58f7-91d8-8e7f1f10ee9a') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('09847ecc-e555-5f36-aa15-ffdaf16efd0b', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-0', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', '9b5d828a-5ef3-5303-afb9-01eb34670382', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9b5d828a-5ef3-5303-afb9-01eb34670382';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('09847ecc-e555-5f36-aa15-ffdaf16efd0b', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('09847ecc-e555-5f36-aa15-ffdaf16efd0b', '9b5d828a-5ef3-5303-afb9-01eb34670382', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '09847ecc-e555-5f36-aa15-ffdaf16efd0b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e07dc32e-216a-5569-a392-9b92f99d90b3', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-1', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', '9429082e-afab-5c9c-91ec-699f0895daeb', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9429082e-afab-5c9c-91ec-699f0895daeb';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e07dc32e-216a-5569-a392-9b92f99d90b3', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('e07dc32e-216a-5569-a392-9b92f99d90b3', '9429082e-afab-5c9c-91ec-699f0895daeb', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e07dc32e-216a-5569-a392-9b92f99d90b3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('70248fae-6d38-5b8f-86ae-aea02ca25d08', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-2', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', 'a70b44f8-af53-5e40-be47-eb291b673d8f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a70b44f8-af53-5e40-be47-eb291b673d8f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('70248fae-6d38-5b8f-86ae-aea02ca25d08', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('70248fae-6d38-5b8f-86ae-aea02ca25d08', 'a70b44f8-af53-5e40-be47-eb291b673d8f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '70248fae-6d38-5b8f-86ae-aea02ca25d08';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('349b9cce-68d6-59b3-9698-7d0fdb68706a', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-3', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', 'bb7da290-438b-5a0a-b31c-3b88ee5d795e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'bb7da290-438b-5a0a-b31c-3b88ee5d795e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('349b9cce-68d6-59b3-9698-7d0fdb68706a', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('349b9cce-68d6-59b3-9698-7d0fdb68706a', 'bb7da290-438b-5a0a-b31c-3b88ee5d795e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '349b9cce-68d6-59b3-9698-7d0fdb68706a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9ed9c0cd-aa87-58c3-be01-76db98a1e88a', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-4', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', '3245d7df-a4af-52ee-9053-9fbb4d4140c1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3245d7df-a4af-52ee-9053-9fbb4d4140c1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9ed9c0cd-aa87-58c3-be01-76db98a1e88a', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('9ed9c0cd-aa87-58c3-be01-76db98a1e88a', '3245d7df-a4af-52ee-9053-9fbb4d4140c1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9ed9c0cd-aa87-58c3-be01-76db98a1e88a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7cb44071-401e-5ec3-b610-e1f7445d450d', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-5', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', '089f64d8-a1d5-5c20-bf54-b8064775d187', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '089f64d8-a1d5-5c20-bf54-b8064775d187';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7cb44071-401e-5ec3-b610-e1f7445d450d', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('7cb44071-401e-5ec3-b610-e1f7445d450d', '089f64d8-a1d5-5c20-bf54-b8064775d187', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7cb44071-401e-5ec3-b610-e1f7445d450d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a65b8d07-5603-5387-9d2c-e81e70893d87', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-6', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', '3fe86036-a362-5b03-bac7-9f53a1bc0c05', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3fe86036-a362-5b03-bac7-9f53a1bc0c05';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a65b8d07-5603-5387-9d2c-e81e70893d87', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('a65b8d07-5603-5387-9d2c-e81e70893d87', '3fe86036-a362-5b03-bac7-9f53a1bc0c05', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a65b8d07-5603-5387-9d2c-e81e70893d87';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5cdc6ab5-6081-5355-bada-7f0a4bedc3f1', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-7', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', '6b1473c4-aba0-5138-bfda-5744e1917705', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6b1473c4-aba0-5138-bfda-5744e1917705';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5cdc6ab5-6081-5355-bada-7f0a4bedc3f1', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('5cdc6ab5-6081-5355-bada-7f0a4bedc3f1', '6b1473c4-aba0-5138-bfda-5744e1917705', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5cdc6ab5-6081-5355-bada-7f0a4bedc3f1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f460ed76-d8e7-5203-bc41-0d27f300672c', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-8', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', 'f165f28f-5572-58f7-91d8-8e7f1f10ee9a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f165f28f-5572-58f7-91d8-8e7f1f10ee9a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f460ed76-d8e7-5203-bc41-0d27f300672c', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('f460ed76-d8e7-5203-bc41-0d27f300672c', 'f165f28f-5572-58f7-91d8-8e7f1f10ee9a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f460ed76-d8e7-5203-bc41-0d27f300672c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4e559d86-ef5a-55f7-a3c9-de18144f7ddb', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-9', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', '02852544-d57d-5669-9b27-f075a30511f7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '02852544-d57d-5669-9b27-f075a30511f7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4e559d86-ef5a-55f7-a3c9-de18144f7ddb', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('4e559d86-ef5a-55f7-a3c9-de18144f7ddb', '02852544-d57d-5669-9b27-f075a30511f7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4e559d86-ef5a-55f7-a3c9-de18144f7ddb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('360d7436-20ce-548f-a8e7-ca403232d22b', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-10', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', '64757863-a615-55a1-9179-19d3031bb166', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '64757863-a615-55a1-9179-19d3031bb166';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('360d7436-20ce-548f-a8e7-ca403232d22b', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('360d7436-20ce-548f-a8e7-ca403232d22b', '64757863-a615-55a1-9179-19d3031bb166', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '360d7436-20ce-548f-a8e7-ca403232d22b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1988b6cc-8603-5c11-84a4-37bfe7901271', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-11', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', '1939e950-5ae1-5456-b2eb-62e9250f39c4', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1939e950-5ae1-5456-b2eb-62e9250f39c4';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1988b6cc-8603-5c11-84a4-37bfe7901271', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('1988b6cc-8603-5c11-84a4-37bfe7901271', '1939e950-5ae1-5456-b2eb-62e9250f39c4', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1988b6cc-8603-5c11-84a4-37bfe7901271';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c93819d7-654b-583f-907b-2c627e0d9dc6', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-12', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', '8e39e793-f2c1-540a-9e64-c23a976b6e44', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8e39e793-f2c1-540a-9e64-c23a976b6e44';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c93819d7-654b-583f-907b-2c627e0d9dc6', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('c93819d7-654b-583f-907b-2c627e0d9dc6', '8e39e793-f2c1-540a-9e64-c23a976b6e44', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c93819d7-654b-583f-907b-2c627e0d9dc6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c2f5e711-38dd-559b-8fc8-06bd4e79ab6a', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-13', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', 'd89b8ec8-e8fe-5c44-b5cb-7e3591713f6b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd89b8ec8-e8fe-5c44-b5cb-7e3591713f6b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c2f5e711-38dd-559b-8fc8-06bd4e79ab6a', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('c2f5e711-38dd-559b-8fc8-06bd4e79ab6a', 'd89b8ec8-e8fe-5c44-b5cb-7e3591713f6b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c2f5e711-38dd-559b-8fc8-06bd4e79ab6a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4a52d559-6b12-5fff-b147-32bf181c49c1', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-14', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', '684a6280-2931-5e68-89af-cfc85c8d3723', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '684a6280-2931-5e68-89af-cfc85c8d3723';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4a52d559-6b12-5fff-b147-32bf181c49c1', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('4a52d559-6b12-5fff-b147-32bf181c49c1', '684a6280-2931-5e68-89af-cfc85c8d3723', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4a52d559-6b12-5fff-b147-32bf181c49c1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('bd2aaa08-eb53-5dab-95c8-1aafe077f767', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-15', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', '5513b023-2d63-5dbd-a219-eeaf7703270d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5513b023-2d63-5dbd-a219-eeaf7703270d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('bd2aaa08-eb53-5dab-95c8-1aafe077f767', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('bd2aaa08-eb53-5dab-95c8-1aafe077f767', '5513b023-2d63-5dbd-a219-eeaf7703270d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'bd2aaa08-eb53-5dab-95c8-1aafe077f767';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f8996fae-5414-59bc-92ba-9bf42e7d0e5d', 'benchmark-funding-3b5e7c88-ba83-4f5d-9fe5-b4886c806168-16', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', 'aa3c6ede-2f30-51f7-93b1-4842bcccfc3c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'aa3c6ede-2f30-51f7-93b1-4842bcccfc3c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f8996fae-5414-59bc-92ba-9bf42e7d0e5d', 'a6d5f2b3-4657-5f07-988d-6c4a8521bc03', -1000000000), ('f8996fae-5414-59bc-92ba-9bf42e7d0e5d', 'aa3c6ede-2f30-51f7-93b1-4842bcccfc3c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f8996fae-5414-59bc-92ba-9bf42e7d0e5d';
COMMIT;
