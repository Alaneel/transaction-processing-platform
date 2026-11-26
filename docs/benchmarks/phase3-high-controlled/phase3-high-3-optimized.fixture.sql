-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('01b4ff60-29ea-5c26-9d26-45696eba07b1', 'USER', 'ACTIVE', 'FIC'),
('01cadbc7-5427-5f5d-8eed-0cd9809ab6cf', 'USER', 'ACTIVE', 'FIC'),
('038363a1-89cf-5065-8cd5-47c937ed231c', 'USER', 'ACTIVE', 'FIC'),
('0450cb24-7361-5d5b-a44e-0c4eda42590f', 'USER', 'ACTIVE', 'FIC'),
('077bc677-e46c-5b18-94cd-b9dcfeb191b5', 'USER', 'ACTIVE', 'FIC'),
('080579f0-b44b-52e4-9a25-5f3651ff1878', 'USER', 'ACTIVE', 'FIC'),
('0970a870-6660-5e25-a752-a884f7fd62f8', 'USER', 'ACTIVE', 'FIC'),
('09804ba7-cb26-5a4d-8a6a-bc317cfef464', 'USER', 'ACTIVE', 'FIC'),
('0bcc37b5-d9c8-558b-95e2-a815c2a08779', 'USER', 'ACTIVE', 'FIC'),
('0f58ccdb-a54d-52bd-a2d4-d90fccd0b418', 'USER', 'ACTIVE', 'FIC'),
('1ed8c6b1-8fb8-5f3c-bf6a-64a4d74f1c87', 'USER', 'ACTIVE', 'FIC'),
('32fc65fe-dfa3-553f-a4a8-551e099186e9', 'USER', 'ACTIVE', 'FIC'),
('3a987c79-e48e-50d4-88f5-6503d7496bcb', 'USER', 'ACTIVE', 'FIC'),
('49f82893-1787-5d20-a15b-d467ff2c5666', 'USER', 'ACTIVE', 'FIC'),
('4d221cef-20ef-5a1e-834c-ec63393104dd', 'USER', 'ACTIVE', 'FIC'),
('5918de59-4c16-5bbe-823d-3f5b0b0b47c9', 'USER', 'ACTIVE', 'FIC'),
('6423eb15-44bb-5674-b2bf-93e6f3d9e009', 'USER', 'ACTIVE', 'FIC'),
('7100ed89-c676-5b18-95f8-12ee7fc84375', 'USER', 'ACTIVE', 'FIC'),
('77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', 'ISSUANCE', 'ACTIVE', 'FIC'),
('9aed3ee7-28df-5331-882f-0060e0723c97', 'USER', 'ACTIVE', 'FIC'),
('9f1a83d9-cb00-544e-b6b7-b7ef90d54cfd', 'USER', 'ACTIVE', 'FIC'),
('a516020f-cdac-5749-ba36-eee1c0b33fbb', 'USER', 'ACTIVE', 'FIC'),
('bf3beb71-7c4d-592f-8f94-af1a3506ec9c', 'USER', 'ACTIVE', 'FIC'),
('d0bf3e6e-3b94-5b7b-a406-8b0df9b2e8aa', 'USER', 'ACTIVE', 'FIC'),
('f76bdd7b-f68a-56f4-b13c-58621a7fec68', 'USER', 'ACTIVE', 'FIC'),
('fd55b218-1539-50ef-aeda-e22da401d9c5', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('01b4ff60-29ea-5c26-9d26-45696eba07b1', 0),
('01cadbc7-5427-5f5d-8eed-0cd9809ab6cf', 0),
('038363a1-89cf-5065-8cd5-47c937ed231c', 0),
('0450cb24-7361-5d5b-a44e-0c4eda42590f', 0),
('077bc677-e46c-5b18-94cd-b9dcfeb191b5', 0),
('080579f0-b44b-52e4-9a25-5f3651ff1878', 0),
('0970a870-6660-5e25-a752-a884f7fd62f8', 0),
('09804ba7-cb26-5a4d-8a6a-bc317cfef464', 0),
('0bcc37b5-d9c8-558b-95e2-a815c2a08779', 0),
('0f58ccdb-a54d-52bd-a2d4-d90fccd0b418', 0),
('1ed8c6b1-8fb8-5f3c-bf6a-64a4d74f1c87', 0),
('32fc65fe-dfa3-553f-a4a8-551e099186e9', 0),
('3a987c79-e48e-50d4-88f5-6503d7496bcb', 0),
('49f82893-1787-5d20-a15b-d467ff2c5666', 0),
('4d221cef-20ef-5a1e-834c-ec63393104dd', 0),
('5918de59-4c16-5bbe-823d-3f5b0b0b47c9', 0),
('6423eb15-44bb-5674-b2bf-93e6f3d9e009', 0),
('7100ed89-c676-5b18-95f8-12ee7fc84375', 0),
('77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', 0),
('9aed3ee7-28df-5331-882f-0060e0723c97', 0),
('9f1a83d9-cb00-544e-b6b7-b7ef90d54cfd', 0),
('a516020f-cdac-5749-ba36-eee1c0b33fbb', 0),
('bf3beb71-7c4d-592f-8f94-af1a3506ec9c', 0),
('d0bf3e6e-3b94-5b7b-a406-8b0df9b2e8aa', 0),
('f76bdd7b-f68a-56f4-b13c-58621a7fec68', 0),
('fd55b218-1539-50ef-aeda-e22da401d9c5', 0);
SELECT account_id FROM balances WHERE account_id IN ('01b4ff60-29ea-5c26-9d26-45696eba07b1','01cadbc7-5427-5f5d-8eed-0cd9809ab6cf','038363a1-89cf-5065-8cd5-47c937ed231c','0450cb24-7361-5d5b-a44e-0c4eda42590f','077bc677-e46c-5b18-94cd-b9dcfeb191b5','080579f0-b44b-52e4-9a25-5f3651ff1878','0970a870-6660-5e25-a752-a884f7fd62f8','09804ba7-cb26-5a4d-8a6a-bc317cfef464','0bcc37b5-d9c8-558b-95e2-a815c2a08779','0f58ccdb-a54d-52bd-a2d4-d90fccd0b418','1ed8c6b1-8fb8-5f3c-bf6a-64a4d74f1c87','32fc65fe-dfa3-553f-a4a8-551e099186e9','3a987c79-e48e-50d4-88f5-6503d7496bcb','49f82893-1787-5d20-a15b-d467ff2c5666','4d221cef-20ef-5a1e-834c-ec63393104dd','5918de59-4c16-5bbe-823d-3f5b0b0b47c9','6423eb15-44bb-5674-b2bf-93e6f3d9e009','7100ed89-c676-5b18-95f8-12ee7fc84375','77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3','9aed3ee7-28df-5331-882f-0060e0723c97','9f1a83d9-cb00-544e-b6b7-b7ef90d54cfd','a516020f-cdac-5749-ba36-eee1c0b33fbb','bf3beb71-7c4d-592f-8f94-af1a3506ec9c','d0bf3e6e-3b94-5b7b-a406-8b0df9b2e8aa','f76bdd7b-f68a-56f4-b13c-58621a7fec68','fd55b218-1539-50ef-aeda-e22da401d9c5') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a96a7b7f-55b5-557b-8895-c838fde17585', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-0', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', '3a987c79-e48e-50d4-88f5-6503d7496bcb', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3a987c79-e48e-50d4-88f5-6503d7496bcb';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a96a7b7f-55b5-557b-8895-c838fde17585', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('a96a7b7f-55b5-557b-8895-c838fde17585', '3a987c79-e48e-50d4-88f5-6503d7496bcb', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a96a7b7f-55b5-557b-8895-c838fde17585';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('111af990-8b3d-5e82-b4ac-05c4adc7b1fb', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-1', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', 'f76bdd7b-f68a-56f4-b13c-58621a7fec68', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f76bdd7b-f68a-56f4-b13c-58621a7fec68';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('111af990-8b3d-5e82-b4ac-05c4adc7b1fb', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('111af990-8b3d-5e82-b4ac-05c4adc7b1fb', 'f76bdd7b-f68a-56f4-b13c-58621a7fec68', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '111af990-8b3d-5e82-b4ac-05c4adc7b1fb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c300eda2-493a-57e8-95ae-c148ee962189', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-2', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', '9aed3ee7-28df-5331-882f-0060e0723c97', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9aed3ee7-28df-5331-882f-0060e0723c97';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c300eda2-493a-57e8-95ae-c148ee962189', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('c300eda2-493a-57e8-95ae-c148ee962189', '9aed3ee7-28df-5331-882f-0060e0723c97', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c300eda2-493a-57e8-95ae-c148ee962189';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('350ecbc4-c501-517a-8937-ce534c11722f', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-3', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', 'bf3beb71-7c4d-592f-8f94-af1a3506ec9c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'bf3beb71-7c4d-592f-8f94-af1a3506ec9c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('350ecbc4-c501-517a-8937-ce534c11722f', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('350ecbc4-c501-517a-8937-ce534c11722f', 'bf3beb71-7c4d-592f-8f94-af1a3506ec9c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '350ecbc4-c501-517a-8937-ce534c11722f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f5578d58-b34d-565e-9d6b-1ad55219e63c', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-4', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', '1ed8c6b1-8fb8-5f3c-bf6a-64a4d74f1c87', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1ed8c6b1-8fb8-5f3c-bf6a-64a4d74f1c87';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f5578d58-b34d-565e-9d6b-1ad55219e63c', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('f5578d58-b34d-565e-9d6b-1ad55219e63c', '1ed8c6b1-8fb8-5f3c-bf6a-64a4d74f1c87', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f5578d58-b34d-565e-9d6b-1ad55219e63c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('226f2296-b0fe-5b40-bb4e-c69dd5a74ed1', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-5', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', '077bc677-e46c-5b18-94cd-b9dcfeb191b5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '077bc677-e46c-5b18-94cd-b9dcfeb191b5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('226f2296-b0fe-5b40-bb4e-c69dd5a74ed1', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('226f2296-b0fe-5b40-bb4e-c69dd5a74ed1', '077bc677-e46c-5b18-94cd-b9dcfeb191b5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '226f2296-b0fe-5b40-bb4e-c69dd5a74ed1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c0cb2495-f03d-550f-b5f5-072f57a1df9b', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-6', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', 'd0bf3e6e-3b94-5b7b-a406-8b0df9b2e8aa', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd0bf3e6e-3b94-5b7b-a406-8b0df9b2e8aa';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c0cb2495-f03d-550f-b5f5-072f57a1df9b', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('c0cb2495-f03d-550f-b5f5-072f57a1df9b', 'd0bf3e6e-3b94-5b7b-a406-8b0df9b2e8aa', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c0cb2495-f03d-550f-b5f5-072f57a1df9b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a3edffb7-062f-5f43-be84-2fba88a0a2c4', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-7', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', '49f82893-1787-5d20-a15b-d467ff2c5666', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '49f82893-1787-5d20-a15b-d467ff2c5666';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a3edffb7-062f-5f43-be84-2fba88a0a2c4', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('a3edffb7-062f-5f43-be84-2fba88a0a2c4', '49f82893-1787-5d20-a15b-d467ff2c5666', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a3edffb7-062f-5f43-be84-2fba88a0a2c4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0c0e5d2a-869f-5335-a488-3476172469a7', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-8', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', 'fd55b218-1539-50ef-aeda-e22da401d9c5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fd55b218-1539-50ef-aeda-e22da401d9c5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0c0e5d2a-869f-5335-a488-3476172469a7', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('0c0e5d2a-869f-5335-a488-3476172469a7', 'fd55b218-1539-50ef-aeda-e22da401d9c5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0c0e5d2a-869f-5335-a488-3476172469a7';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('285d259f-09a3-5bbf-aa37-02c0e9040cf0', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-9', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', '9f1a83d9-cb00-544e-b6b7-b7ef90d54cfd', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9f1a83d9-cb00-544e-b6b7-b7ef90d54cfd';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('285d259f-09a3-5bbf-aa37-02c0e9040cf0', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('285d259f-09a3-5bbf-aa37-02c0e9040cf0', '9f1a83d9-cb00-544e-b6b7-b7ef90d54cfd', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '285d259f-09a3-5bbf-aa37-02c0e9040cf0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6197c059-e614-536e-a3f0-9eb2718cc999', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-10', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', 'a516020f-cdac-5749-ba36-eee1c0b33fbb', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a516020f-cdac-5749-ba36-eee1c0b33fbb';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6197c059-e614-536e-a3f0-9eb2718cc999', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('6197c059-e614-536e-a3f0-9eb2718cc999', 'a516020f-cdac-5749-ba36-eee1c0b33fbb', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6197c059-e614-536e-a3f0-9eb2718cc999';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f5727a05-2c65-504c-92f0-fe09e0125237', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-11', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', '32fc65fe-dfa3-553f-a4a8-551e099186e9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '32fc65fe-dfa3-553f-a4a8-551e099186e9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f5727a05-2c65-504c-92f0-fe09e0125237', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('f5727a05-2c65-504c-92f0-fe09e0125237', '32fc65fe-dfa3-553f-a4a8-551e099186e9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f5727a05-2c65-504c-92f0-fe09e0125237';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('cc26559d-e314-5011-b3fe-7b3cd0b28afc', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-12', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', '5918de59-4c16-5bbe-823d-3f5b0b0b47c9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5918de59-4c16-5bbe-823d-3f5b0b0b47c9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('cc26559d-e314-5011-b3fe-7b3cd0b28afc', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('cc26559d-e314-5011-b3fe-7b3cd0b28afc', '5918de59-4c16-5bbe-823d-3f5b0b0b47c9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'cc26559d-e314-5011-b3fe-7b3cd0b28afc';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6ce2111e-6ca8-5692-897f-b89a52ed3237', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-13', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', '6423eb15-44bb-5674-b2bf-93e6f3d9e009', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6423eb15-44bb-5674-b2bf-93e6f3d9e009';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6ce2111e-6ca8-5692-897f-b89a52ed3237', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('6ce2111e-6ca8-5692-897f-b89a52ed3237', '6423eb15-44bb-5674-b2bf-93e6f3d9e009', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6ce2111e-6ca8-5692-897f-b89a52ed3237';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('400e3f73-231a-57dd-95af-d9488f382c89', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-14', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', '0f58ccdb-a54d-52bd-a2d4-d90fccd0b418', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0f58ccdb-a54d-52bd-a2d4-d90fccd0b418';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('400e3f73-231a-57dd-95af-d9488f382c89', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('400e3f73-231a-57dd-95af-d9488f382c89', '0f58ccdb-a54d-52bd-a2d4-d90fccd0b418', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '400e3f73-231a-57dd-95af-d9488f382c89';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0337a5d7-6716-5b12-b38a-523baa308a8f', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-15', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', '4d221cef-20ef-5a1e-834c-ec63393104dd', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4d221cef-20ef-5a1e-834c-ec63393104dd';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0337a5d7-6716-5b12-b38a-523baa308a8f', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('0337a5d7-6716-5b12-b38a-523baa308a8f', '4d221cef-20ef-5a1e-834c-ec63393104dd', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0337a5d7-6716-5b12-b38a-523baa308a8f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b4d36266-6301-57c0-8ed2-cefff0a9f69e', 'benchmark-funding-d57486ff-73c2-4d4d-b24d-01f7b225511b-16', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', '7100ed89-c676-5b18-95f8-12ee7fc84375', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7100ed89-c676-5b18-95f8-12ee7fc84375';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b4d36266-6301-57c0-8ed2-cefff0a9f69e', '77d03c9e-e4c0-5ee4-b531-f7e192fdd0f3', -1000000000), ('b4d36266-6301-57c0-8ed2-cefff0a9f69e', '7100ed89-c676-5b18-95f8-12ee7fc84375', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b4d36266-6301-57c0-8ed2-cefff0a9f69e';
COMMIT;
