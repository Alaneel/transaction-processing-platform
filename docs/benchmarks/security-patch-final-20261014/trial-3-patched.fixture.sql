-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('10618153-841c-5baf-8b8b-c27971bf76e1', 'USER', 'ACTIVE', 'FIC'),
('2981ad8a-19e8-5a61-a8d7-88de5e550c76', 'USER', 'ACTIVE', 'FIC'),
('4673aaeb-05b7-57d5-9573-521a9e8d8a5d', 'USER', 'ACTIVE', 'FIC'),
('500fb47e-94e8-56da-8cf7-6c4d90b03645', 'USER', 'ACTIVE', 'FIC'),
('5b4ca09a-05df-5013-8bf4-a0937e694428', 'USER', 'ACTIVE', 'FIC'),
('621955d3-68b6-5435-b38f-a1c9c0f4643f', 'USER', 'ACTIVE', 'FIC'),
('65fbd80a-a1fc-5424-bab9-fb8a1f11db63', 'USER', 'ACTIVE', 'FIC'),
('7d185609-744a-5221-a801-28f1e95de4cc', 'USER', 'ACTIVE', 'FIC'),
('7e5d4b92-4cb1-5be8-9f9a-311b90df54a1', 'USER', 'ACTIVE', 'FIC'),
('84e4e95f-0989-5c1c-b1ed-b3b37dacd60e', 'USER', 'ACTIVE', 'FIC'),
('93077799-f27e-50b2-8689-8335db89088f', 'USER', 'ACTIVE', 'FIC'),
('94449144-9809-5d5d-a17c-6ab27fad417d', 'USER', 'ACTIVE', 'FIC'),
('94a1b8f8-795e-57a7-ac38-697d8e2d8ca1', 'USER', 'ACTIVE', 'FIC'),
('9a75c030-0198-5b2c-91a8-f28e64f3e004', 'USER', 'ACTIVE', 'FIC'),
('a48ff3ba-0d60-5edc-92ea-204b5023d3fe', 'ISSUANCE', 'ACTIVE', 'FIC'),
('a8353245-9e4d-5d15-acb6-f54d299663cd', 'USER', 'ACTIVE', 'FIC'),
('af5b0c29-8e4a-5961-8506-fa026bb8c13c', 'USER', 'ACTIVE', 'FIC'),
('b1a6123c-da55-5740-9a1f-473b151962c6', 'USER', 'ACTIVE', 'FIC'),
('c11928d7-c5ba-5df8-a4a3-7e29dcc926d6', 'USER', 'ACTIVE', 'FIC'),
('d458700d-4f85-56af-b854-bfa416b3c1f9', 'USER', 'ACTIVE', 'FIC'),
('d525c14b-9aa2-5bcf-8fd8-f9a679f4fa67', 'USER', 'ACTIVE', 'FIC'),
('e170bc1c-e44f-51ca-8321-ff0406ae6964', 'USER', 'ACTIVE', 'FIC'),
('e33263c0-34cd-5504-a892-3578929839b0', 'USER', 'ACTIVE', 'FIC'),
('e52cbfbb-c899-5905-a0af-000b4d1f883c', 'USER', 'ACTIVE', 'FIC'),
('f508c2aa-91dd-5dd4-87c8-39e1ad8b8143', 'USER', 'ACTIVE', 'FIC'),
('f86bc681-e201-50a5-8f32-9971e163e65c', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('10618153-841c-5baf-8b8b-c27971bf76e1', 0),
('2981ad8a-19e8-5a61-a8d7-88de5e550c76', 0),
('4673aaeb-05b7-57d5-9573-521a9e8d8a5d', 0),
('500fb47e-94e8-56da-8cf7-6c4d90b03645', 0),
('5b4ca09a-05df-5013-8bf4-a0937e694428', 0),
('621955d3-68b6-5435-b38f-a1c9c0f4643f', 0),
('65fbd80a-a1fc-5424-bab9-fb8a1f11db63', 0),
('7d185609-744a-5221-a801-28f1e95de4cc', 0),
('7e5d4b92-4cb1-5be8-9f9a-311b90df54a1', 0),
('84e4e95f-0989-5c1c-b1ed-b3b37dacd60e', 0),
('93077799-f27e-50b2-8689-8335db89088f', 0),
('94449144-9809-5d5d-a17c-6ab27fad417d', 0),
('94a1b8f8-795e-57a7-ac38-697d8e2d8ca1', 0),
('9a75c030-0198-5b2c-91a8-f28e64f3e004', 0),
('a48ff3ba-0d60-5edc-92ea-204b5023d3fe', 0),
('a8353245-9e4d-5d15-acb6-f54d299663cd', 0),
('af5b0c29-8e4a-5961-8506-fa026bb8c13c', 0),
('b1a6123c-da55-5740-9a1f-473b151962c6', 0),
('c11928d7-c5ba-5df8-a4a3-7e29dcc926d6', 0),
('d458700d-4f85-56af-b854-bfa416b3c1f9', 0),
('d525c14b-9aa2-5bcf-8fd8-f9a679f4fa67', 0),
('e170bc1c-e44f-51ca-8321-ff0406ae6964', 0),
('e33263c0-34cd-5504-a892-3578929839b0', 0),
('e52cbfbb-c899-5905-a0af-000b4d1f883c', 0),
('f508c2aa-91dd-5dd4-87c8-39e1ad8b8143', 0),
('f86bc681-e201-50a5-8f32-9971e163e65c', 0);
SELECT account_id FROM balances WHERE account_id IN ('10618153-841c-5baf-8b8b-c27971bf76e1','2981ad8a-19e8-5a61-a8d7-88de5e550c76','4673aaeb-05b7-57d5-9573-521a9e8d8a5d','500fb47e-94e8-56da-8cf7-6c4d90b03645','5b4ca09a-05df-5013-8bf4-a0937e694428','621955d3-68b6-5435-b38f-a1c9c0f4643f','65fbd80a-a1fc-5424-bab9-fb8a1f11db63','7d185609-744a-5221-a801-28f1e95de4cc','7e5d4b92-4cb1-5be8-9f9a-311b90df54a1','84e4e95f-0989-5c1c-b1ed-b3b37dacd60e','93077799-f27e-50b2-8689-8335db89088f','94449144-9809-5d5d-a17c-6ab27fad417d','94a1b8f8-795e-57a7-ac38-697d8e2d8ca1','9a75c030-0198-5b2c-91a8-f28e64f3e004','a48ff3ba-0d60-5edc-92ea-204b5023d3fe','a8353245-9e4d-5d15-acb6-f54d299663cd','af5b0c29-8e4a-5961-8506-fa026bb8c13c','b1a6123c-da55-5740-9a1f-473b151962c6','c11928d7-c5ba-5df8-a4a3-7e29dcc926d6','d458700d-4f85-56af-b854-bfa416b3c1f9','d525c14b-9aa2-5bcf-8fd8-f9a679f4fa67','e170bc1c-e44f-51ca-8321-ff0406ae6964','e33263c0-34cd-5504-a892-3578929839b0','e52cbfbb-c899-5905-a0af-000b4d1f883c','f508c2aa-91dd-5dd4-87c8-39e1ad8b8143','f86bc681-e201-50a5-8f32-9971e163e65c') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7e551ae0-004d-5da6-b773-fe2b2db6903f', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-0', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', '94449144-9809-5d5d-a17c-6ab27fad417d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '94449144-9809-5d5d-a17c-6ab27fad417d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7e551ae0-004d-5da6-b773-fe2b2db6903f', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('7e551ae0-004d-5da6-b773-fe2b2db6903f', '94449144-9809-5d5d-a17c-6ab27fad417d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7e551ae0-004d-5da6-b773-fe2b2db6903f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9d0a30cb-cf93-534e-9197-a1ce877d8645', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-1', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', '2981ad8a-19e8-5a61-a8d7-88de5e550c76', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2981ad8a-19e8-5a61-a8d7-88de5e550c76';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9d0a30cb-cf93-534e-9197-a1ce877d8645', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('9d0a30cb-cf93-534e-9197-a1ce877d8645', '2981ad8a-19e8-5a61-a8d7-88de5e550c76', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9d0a30cb-cf93-534e-9197-a1ce877d8645';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('46e02ce9-10ae-5afa-ac24-ea861bbf64b0', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-2', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', '7e5d4b92-4cb1-5be8-9f9a-311b90df54a1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7e5d4b92-4cb1-5be8-9f9a-311b90df54a1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('46e02ce9-10ae-5afa-ac24-ea861bbf64b0', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('46e02ce9-10ae-5afa-ac24-ea861bbf64b0', '7e5d4b92-4cb1-5be8-9f9a-311b90df54a1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '46e02ce9-10ae-5afa-ac24-ea861bbf64b0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8b896540-94af-515b-b6cf-43868f24813e', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-3', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', '84e4e95f-0989-5c1c-b1ed-b3b37dacd60e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '84e4e95f-0989-5c1c-b1ed-b3b37dacd60e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8b896540-94af-515b-b6cf-43868f24813e', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('8b896540-94af-515b-b6cf-43868f24813e', '84e4e95f-0989-5c1c-b1ed-b3b37dacd60e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8b896540-94af-515b-b6cf-43868f24813e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c51b9452-843e-57ee-80e3-2453260119af', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-4', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', 'b1a6123c-da55-5740-9a1f-473b151962c6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b1a6123c-da55-5740-9a1f-473b151962c6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c51b9452-843e-57ee-80e3-2453260119af', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('c51b9452-843e-57ee-80e3-2453260119af', 'b1a6123c-da55-5740-9a1f-473b151962c6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c51b9452-843e-57ee-80e3-2453260119af';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('822c9c03-5dcc-535b-b50e-3d46dcd16e6f', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-5', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', '7d185609-744a-5221-a801-28f1e95de4cc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7d185609-744a-5221-a801-28f1e95de4cc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('822c9c03-5dcc-535b-b50e-3d46dcd16e6f', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('822c9c03-5dcc-535b-b50e-3d46dcd16e6f', '7d185609-744a-5221-a801-28f1e95de4cc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '822c9c03-5dcc-535b-b50e-3d46dcd16e6f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d2abd364-2655-52aa-8f06-2bc871195078', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-6', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', 'e52cbfbb-c899-5905-a0af-000b4d1f883c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e52cbfbb-c899-5905-a0af-000b4d1f883c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d2abd364-2655-52aa-8f06-2bc871195078', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('d2abd364-2655-52aa-8f06-2bc871195078', 'e52cbfbb-c899-5905-a0af-000b4d1f883c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd2abd364-2655-52aa-8f06-2bc871195078';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b8fded72-7e53-5e03-b7af-a21085276ee8', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-7', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', '93077799-f27e-50b2-8689-8335db89088f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '93077799-f27e-50b2-8689-8335db89088f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b8fded72-7e53-5e03-b7af-a21085276ee8', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('b8fded72-7e53-5e03-b7af-a21085276ee8', '93077799-f27e-50b2-8689-8335db89088f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b8fded72-7e53-5e03-b7af-a21085276ee8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c00849ff-1f36-59c0-839b-c52e01067737', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-8', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', 'af5b0c29-8e4a-5961-8506-fa026bb8c13c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'af5b0c29-8e4a-5961-8506-fa026bb8c13c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c00849ff-1f36-59c0-839b-c52e01067737', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('c00849ff-1f36-59c0-839b-c52e01067737', 'af5b0c29-8e4a-5961-8506-fa026bb8c13c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c00849ff-1f36-59c0-839b-c52e01067737';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('228a21f6-7365-5947-a3d3-1b372e35455b', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-9', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', 'c11928d7-c5ba-5df8-a4a3-7e29dcc926d6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c11928d7-c5ba-5df8-a4a3-7e29dcc926d6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('228a21f6-7365-5947-a3d3-1b372e35455b', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('228a21f6-7365-5947-a3d3-1b372e35455b', 'c11928d7-c5ba-5df8-a4a3-7e29dcc926d6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '228a21f6-7365-5947-a3d3-1b372e35455b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('49f50ffc-86d0-5740-83b3-0552730e5002', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-10', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', '65fbd80a-a1fc-5424-bab9-fb8a1f11db63', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '65fbd80a-a1fc-5424-bab9-fb8a1f11db63';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('49f50ffc-86d0-5740-83b3-0552730e5002', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('49f50ffc-86d0-5740-83b3-0552730e5002', '65fbd80a-a1fc-5424-bab9-fb8a1f11db63', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '49f50ffc-86d0-5740-83b3-0552730e5002';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e9dc26ae-840a-5cf8-87b8-85e9c99ff67c', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-11', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', '5b4ca09a-05df-5013-8bf4-a0937e694428', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5b4ca09a-05df-5013-8bf4-a0937e694428';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e9dc26ae-840a-5cf8-87b8-85e9c99ff67c', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('e9dc26ae-840a-5cf8-87b8-85e9c99ff67c', '5b4ca09a-05df-5013-8bf4-a0937e694428', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e9dc26ae-840a-5cf8-87b8-85e9c99ff67c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('2af281dd-5e16-5379-afa9-0d3ede96520e', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-12', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', '500fb47e-94e8-56da-8cf7-6c4d90b03645', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '500fb47e-94e8-56da-8cf7-6c4d90b03645';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('2af281dd-5e16-5379-afa9-0d3ede96520e', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('2af281dd-5e16-5379-afa9-0d3ede96520e', '500fb47e-94e8-56da-8cf7-6c4d90b03645', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '2af281dd-5e16-5379-afa9-0d3ede96520e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e4ea3455-e14b-5d4f-873d-9aa811fd24cc', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-13', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', '94a1b8f8-795e-57a7-ac38-697d8e2d8ca1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '94a1b8f8-795e-57a7-ac38-697d8e2d8ca1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e4ea3455-e14b-5d4f-873d-9aa811fd24cc', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('e4ea3455-e14b-5d4f-873d-9aa811fd24cc', '94a1b8f8-795e-57a7-ac38-697d8e2d8ca1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e4ea3455-e14b-5d4f-873d-9aa811fd24cc';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('500a9bf1-fa10-57e2-ba38-c117fd0ac362', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-14', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', 'f508c2aa-91dd-5dd4-87c8-39e1ad8b8143', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f508c2aa-91dd-5dd4-87c8-39e1ad8b8143';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('500a9bf1-fa10-57e2-ba38-c117fd0ac362', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('500a9bf1-fa10-57e2-ba38-c117fd0ac362', 'f508c2aa-91dd-5dd4-87c8-39e1ad8b8143', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '500a9bf1-fa10-57e2-ba38-c117fd0ac362';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e28ac7a2-1d57-5d5a-ae96-ce8bf9a8c19b', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-15', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', '10618153-841c-5baf-8b8b-c27971bf76e1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '10618153-841c-5baf-8b8b-c27971bf76e1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e28ac7a2-1d57-5d5a-ae96-ce8bf9a8c19b', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('e28ac7a2-1d57-5d5a-ae96-ce8bf9a8c19b', '10618153-841c-5baf-8b8b-c27971bf76e1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e28ac7a2-1d57-5d5a-ae96-ce8bf9a8c19b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3db08536-fdfe-5d44-8227-e135fbff4162', 'benchmark-funding-07c1e52a-8050-41f1-87e2-37a003a27e22-16', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', '621955d3-68b6-5435-b38f-a1c9c0f4643f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '621955d3-68b6-5435-b38f-a1c9c0f4643f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3db08536-fdfe-5d44-8227-e135fbff4162', 'a48ff3ba-0d60-5edc-92ea-204b5023d3fe', -1000000000), ('3db08536-fdfe-5d44-8227-e135fbff4162', '621955d3-68b6-5435-b38f-a1c9c0f4643f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3db08536-fdfe-5d44-8227-e135fbff4162';
COMMIT;
