-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('084303d1-60bf-51e8-b892-997703ba1846', 'USER', 'ACTIVE', 'FIC'),
('0dfc03ba-7f5e-524c-89d9-4e0869071cf8', 'USER', 'ACTIVE', 'FIC'),
('14cb1f01-fac1-51dd-b3f4-d4ff28460374', 'USER', 'ACTIVE', 'FIC'),
('2c8306cd-b3d2-5576-842c-9c211b335e53', 'USER', 'ACTIVE', 'FIC'),
('46d3c9e3-9def-51ab-8f4f-7b504434e997', 'USER', 'ACTIVE', 'FIC'),
('559fc4a7-ef0e-5b44-9f6c-44356080d242', 'USER', 'ACTIVE', 'FIC'),
('62f7876d-243b-530b-ba9b-5da16e6f4b9e', 'USER', 'ACTIVE', 'FIC'),
('64706e23-e688-5a32-8118-b2121feb918e', 'USER', 'ACTIVE', 'FIC'),
('666b0099-5091-5275-9197-d7a4e6254f92', 'USER', 'ACTIVE', 'FIC'),
('8a2cd755-f735-5fe7-af7a-f918e60433c5', 'USER', 'ACTIVE', 'FIC'),
('8f68ffaa-01e9-5ec2-b343-4334733ceccb', 'USER', 'ACTIVE', 'FIC'),
('911f369e-6fdd-54ff-b773-be2bfd82fa8b', 'USER', 'ACTIVE', 'FIC'),
('91a82fcf-c228-5cb7-8517-15bf894259af', 'USER', 'ACTIVE', 'FIC'),
('96c9d6a5-f50c-54b1-9d05-a8b546cf66c2', 'USER', 'ACTIVE', 'FIC'),
('97921bc8-64e9-5f00-a960-02ec25daefbe', 'USER', 'ACTIVE', 'FIC'),
('9f90f826-bb9f-5de2-b3b8-47bb011ce9e8', 'USER', 'ACTIVE', 'FIC'),
('af4521c4-54b7-51ff-87dc-b2b3c7c98d21', 'USER', 'ACTIVE', 'FIC'),
('b063317a-8fc5-5f45-af24-f4970aa74a15', 'USER', 'ACTIVE', 'FIC'),
('c8090156-1159-5905-abf0-7f7417aa6cc0', 'ISSUANCE', 'ACTIVE', 'FIC'),
('cafd6202-12d2-5f9d-b4fb-ff560e6ae1d7', 'USER', 'ACTIVE', 'FIC'),
('cd3ac0e0-2a0c-5e4e-bb9a-476440802b0c', 'USER', 'ACTIVE', 'FIC'),
('d20c7e4b-6cad-5a2c-8dbc-5470af8b29df', 'USER', 'ACTIVE', 'FIC'),
('d27ea59d-6dc1-53d0-9924-7118584a4eba', 'USER', 'ACTIVE', 'FIC'),
('dc1c68d3-2422-5534-9a26-342bba99434a', 'USER', 'ACTIVE', 'FIC'),
('e3b1e677-afee-5b36-817b-335bc79d1472', 'USER', 'ACTIVE', 'FIC'),
('ec035393-53a5-50d8-932b-6d19e6d20507', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('084303d1-60bf-51e8-b892-997703ba1846', 0),
('0dfc03ba-7f5e-524c-89d9-4e0869071cf8', 0),
('14cb1f01-fac1-51dd-b3f4-d4ff28460374', 0),
('2c8306cd-b3d2-5576-842c-9c211b335e53', 0),
('46d3c9e3-9def-51ab-8f4f-7b504434e997', 0),
('559fc4a7-ef0e-5b44-9f6c-44356080d242', 0),
('62f7876d-243b-530b-ba9b-5da16e6f4b9e', 0),
('64706e23-e688-5a32-8118-b2121feb918e', 0),
('666b0099-5091-5275-9197-d7a4e6254f92', 0),
('8a2cd755-f735-5fe7-af7a-f918e60433c5', 0),
('8f68ffaa-01e9-5ec2-b343-4334733ceccb', 0),
('911f369e-6fdd-54ff-b773-be2bfd82fa8b', 0),
('91a82fcf-c228-5cb7-8517-15bf894259af', 0),
('96c9d6a5-f50c-54b1-9d05-a8b546cf66c2', 0),
('97921bc8-64e9-5f00-a960-02ec25daefbe', 0),
('9f90f826-bb9f-5de2-b3b8-47bb011ce9e8', 0),
('af4521c4-54b7-51ff-87dc-b2b3c7c98d21', 0),
('b063317a-8fc5-5f45-af24-f4970aa74a15', 0),
('c8090156-1159-5905-abf0-7f7417aa6cc0', 0),
('cafd6202-12d2-5f9d-b4fb-ff560e6ae1d7', 0),
('cd3ac0e0-2a0c-5e4e-bb9a-476440802b0c', 0),
('d20c7e4b-6cad-5a2c-8dbc-5470af8b29df', 0),
('d27ea59d-6dc1-53d0-9924-7118584a4eba', 0),
('dc1c68d3-2422-5534-9a26-342bba99434a', 0),
('e3b1e677-afee-5b36-817b-335bc79d1472', 0),
('ec035393-53a5-50d8-932b-6d19e6d20507', 0);
SELECT account_id FROM balances WHERE account_id IN ('084303d1-60bf-51e8-b892-997703ba1846','0dfc03ba-7f5e-524c-89d9-4e0869071cf8','14cb1f01-fac1-51dd-b3f4-d4ff28460374','2c8306cd-b3d2-5576-842c-9c211b335e53','46d3c9e3-9def-51ab-8f4f-7b504434e997','559fc4a7-ef0e-5b44-9f6c-44356080d242','62f7876d-243b-530b-ba9b-5da16e6f4b9e','64706e23-e688-5a32-8118-b2121feb918e','666b0099-5091-5275-9197-d7a4e6254f92','8a2cd755-f735-5fe7-af7a-f918e60433c5','8f68ffaa-01e9-5ec2-b343-4334733ceccb','911f369e-6fdd-54ff-b773-be2bfd82fa8b','91a82fcf-c228-5cb7-8517-15bf894259af','96c9d6a5-f50c-54b1-9d05-a8b546cf66c2','97921bc8-64e9-5f00-a960-02ec25daefbe','9f90f826-bb9f-5de2-b3b8-47bb011ce9e8','af4521c4-54b7-51ff-87dc-b2b3c7c98d21','b063317a-8fc5-5f45-af24-f4970aa74a15','c8090156-1159-5905-abf0-7f7417aa6cc0','cafd6202-12d2-5f9d-b4fb-ff560e6ae1d7','cd3ac0e0-2a0c-5e4e-bb9a-476440802b0c','d20c7e4b-6cad-5a2c-8dbc-5470af8b29df','d27ea59d-6dc1-53d0-9924-7118584a4eba','dc1c68d3-2422-5534-9a26-342bba99434a','e3b1e677-afee-5b36-817b-335bc79d1472','ec035393-53a5-50d8-932b-6d19e6d20507') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3f0dc368-b734-526e-a4b0-c16aca2b74d3', 'benchmark-funding-3352635f-4510-4d68-832a-278de2fb3f34-0', 'c8090156-1159-5905-abf0-7f7417aa6cc0', 'ec035393-53a5-50d8-932b-6d19e6d20507', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c8090156-1159-5905-abf0-7f7417aa6cc0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ec035393-53a5-50d8-932b-6d19e6d20507';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3f0dc368-b734-526e-a4b0-c16aca2b74d3', 'c8090156-1159-5905-abf0-7f7417aa6cc0', -1000000000), ('3f0dc368-b734-526e-a4b0-c16aca2b74d3', 'ec035393-53a5-50d8-932b-6d19e6d20507', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3f0dc368-b734-526e-a4b0-c16aca2b74d3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ed32041d-35a1-5dbd-b0de-fe3fce4a5499', 'benchmark-funding-3352635f-4510-4d68-832a-278de2fb3f34-1', 'c8090156-1159-5905-abf0-7f7417aa6cc0', '8f68ffaa-01e9-5ec2-b343-4334733ceccb', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c8090156-1159-5905-abf0-7f7417aa6cc0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8f68ffaa-01e9-5ec2-b343-4334733ceccb';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ed32041d-35a1-5dbd-b0de-fe3fce4a5499', 'c8090156-1159-5905-abf0-7f7417aa6cc0', -1000000000), ('ed32041d-35a1-5dbd-b0de-fe3fce4a5499', '8f68ffaa-01e9-5ec2-b343-4334733ceccb', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ed32041d-35a1-5dbd-b0de-fe3fce4a5499';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('86d444a4-b5b3-5701-a5a9-b0d6e730056d', 'benchmark-funding-3352635f-4510-4d68-832a-278de2fb3f34-2', 'c8090156-1159-5905-abf0-7f7417aa6cc0', '64706e23-e688-5a32-8118-b2121feb918e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c8090156-1159-5905-abf0-7f7417aa6cc0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '64706e23-e688-5a32-8118-b2121feb918e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('86d444a4-b5b3-5701-a5a9-b0d6e730056d', 'c8090156-1159-5905-abf0-7f7417aa6cc0', -1000000000), ('86d444a4-b5b3-5701-a5a9-b0d6e730056d', '64706e23-e688-5a32-8118-b2121feb918e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '86d444a4-b5b3-5701-a5a9-b0d6e730056d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('cd8d0dd9-e89b-5381-b621-047ccef3ed10', 'benchmark-funding-3352635f-4510-4d68-832a-278de2fb3f34-3', 'c8090156-1159-5905-abf0-7f7417aa6cc0', '911f369e-6fdd-54ff-b773-be2bfd82fa8b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c8090156-1159-5905-abf0-7f7417aa6cc0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '911f369e-6fdd-54ff-b773-be2bfd82fa8b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('cd8d0dd9-e89b-5381-b621-047ccef3ed10', 'c8090156-1159-5905-abf0-7f7417aa6cc0', -1000000000), ('cd8d0dd9-e89b-5381-b621-047ccef3ed10', '911f369e-6fdd-54ff-b773-be2bfd82fa8b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'cd8d0dd9-e89b-5381-b621-047ccef3ed10';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('63ce9bf4-4dbc-5873-8661-86cd64c78dbf', 'benchmark-funding-3352635f-4510-4d68-832a-278de2fb3f34-4', 'c8090156-1159-5905-abf0-7f7417aa6cc0', '14cb1f01-fac1-51dd-b3f4-d4ff28460374', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c8090156-1159-5905-abf0-7f7417aa6cc0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '14cb1f01-fac1-51dd-b3f4-d4ff28460374';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('63ce9bf4-4dbc-5873-8661-86cd64c78dbf', 'c8090156-1159-5905-abf0-7f7417aa6cc0', -1000000000), ('63ce9bf4-4dbc-5873-8661-86cd64c78dbf', '14cb1f01-fac1-51dd-b3f4-d4ff28460374', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '63ce9bf4-4dbc-5873-8661-86cd64c78dbf';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d693f305-7561-5151-a161-490f9ed230b5', 'benchmark-funding-3352635f-4510-4d68-832a-278de2fb3f34-5', 'c8090156-1159-5905-abf0-7f7417aa6cc0', 'cafd6202-12d2-5f9d-b4fb-ff560e6ae1d7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c8090156-1159-5905-abf0-7f7417aa6cc0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'cafd6202-12d2-5f9d-b4fb-ff560e6ae1d7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d693f305-7561-5151-a161-490f9ed230b5', 'c8090156-1159-5905-abf0-7f7417aa6cc0', -1000000000), ('d693f305-7561-5151-a161-490f9ed230b5', 'cafd6202-12d2-5f9d-b4fb-ff560e6ae1d7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd693f305-7561-5151-a161-490f9ed230b5';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('332de878-26b2-55b2-a286-f355d4bb4245', 'benchmark-funding-3352635f-4510-4d68-832a-278de2fb3f34-6', 'c8090156-1159-5905-abf0-7f7417aa6cc0', '8a2cd755-f735-5fe7-af7a-f918e60433c5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c8090156-1159-5905-abf0-7f7417aa6cc0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8a2cd755-f735-5fe7-af7a-f918e60433c5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('332de878-26b2-55b2-a286-f355d4bb4245', 'c8090156-1159-5905-abf0-7f7417aa6cc0', -1000000000), ('332de878-26b2-55b2-a286-f355d4bb4245', '8a2cd755-f735-5fe7-af7a-f918e60433c5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '332de878-26b2-55b2-a286-f355d4bb4245';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8158c35f-a358-5f8e-9f0f-1e08a21026a6', 'benchmark-funding-3352635f-4510-4d68-832a-278de2fb3f34-7', 'c8090156-1159-5905-abf0-7f7417aa6cc0', '084303d1-60bf-51e8-b892-997703ba1846', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c8090156-1159-5905-abf0-7f7417aa6cc0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '084303d1-60bf-51e8-b892-997703ba1846';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8158c35f-a358-5f8e-9f0f-1e08a21026a6', 'c8090156-1159-5905-abf0-7f7417aa6cc0', -1000000000), ('8158c35f-a358-5f8e-9f0f-1e08a21026a6', '084303d1-60bf-51e8-b892-997703ba1846', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8158c35f-a358-5f8e-9f0f-1e08a21026a6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a095ed92-5fef-5734-a143-9e10495251f5', 'benchmark-funding-3352635f-4510-4d68-832a-278de2fb3f34-8', 'c8090156-1159-5905-abf0-7f7417aa6cc0', 'b063317a-8fc5-5f45-af24-f4970aa74a15', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c8090156-1159-5905-abf0-7f7417aa6cc0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b063317a-8fc5-5f45-af24-f4970aa74a15';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a095ed92-5fef-5734-a143-9e10495251f5', 'c8090156-1159-5905-abf0-7f7417aa6cc0', -1000000000), ('a095ed92-5fef-5734-a143-9e10495251f5', 'b063317a-8fc5-5f45-af24-f4970aa74a15', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a095ed92-5fef-5734-a143-9e10495251f5';
COMMIT;
