-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('02fe5d52-db5e-52d8-972e-3cc41bf307bd', 'USER', 'ACTIVE', 'FIC'),
('22574524-814d-561b-b4f2-dedf36f80ac6', 'USER', 'ACTIVE', 'FIC'),
('253592b6-3d15-587c-a8a8-8ba47458b20a', 'USER', 'ACTIVE', 'FIC'),
('2b411fb5-99db-532b-bbbd-6ab7cb9e0a8d', 'USER', 'ACTIVE', 'FIC'),
('33ff3e63-5c3a-56e6-9df8-e3592f490ee2', 'USER', 'ACTIVE', 'FIC'),
('5306320e-691e-5050-b1c8-9de3534e969d', 'USER', 'ACTIVE', 'FIC'),
('601bf377-4460-508e-a807-4f5223b9fd2b', 'USER', 'ACTIVE', 'FIC'),
('64735934-b788-517a-aa8b-f5f63bfc1f0d', 'USER', 'ACTIVE', 'FIC'),
('69498c3b-e8eb-59e2-b6ba-a2adf61b98ce', 'USER', 'ACTIVE', 'FIC'),
('6d8ca648-7a2d-5a32-a93c-70ead0b05b2b', 'USER', 'ACTIVE', 'FIC'),
('72c7fd30-1ed4-5e74-ac0c-8660a15eb3fc', 'USER', 'ACTIVE', 'FIC'),
('7447e1ba-1d5e-5e53-bfe8-22c3a049947b', 'USER', 'ACTIVE', 'FIC'),
('8065771c-ceec-59f7-87bd-f6c5924529a9', 'USER', 'ACTIVE', 'FIC'),
('85fff880-d5d4-5508-bbef-2bc05e3a4610', 'USER', 'ACTIVE', 'FIC'),
('898728aa-4581-53e0-a13d-a7330fec07e5', 'USER', 'ACTIVE', 'FIC'),
('8b8d3d7b-abc7-5630-bbd6-d80e9a32f60c', 'USER', 'ACTIVE', 'FIC'),
('914da527-0a9c-5084-9d4f-3c9b59b0cb54', 'USER', 'ACTIVE', 'FIC'),
('98d1712f-e512-5e10-a427-cb470d0d6ab9', 'USER', 'ACTIVE', 'FIC'),
('9f209b01-1d55-508d-bc37-e502fa3cb598', 'USER', 'ACTIVE', 'FIC'),
('c189e165-af60-5ecd-a5ef-760da096a334', 'USER', 'ACTIVE', 'FIC'),
('c973ccc0-60ed-5ec3-a14e-9f1b03657703', 'USER', 'ACTIVE', 'FIC'),
('dc1c83e1-081e-57ae-b9b8-3074e8114e3a', 'USER', 'ACTIVE', 'FIC'),
('dc9b3092-5995-5d3d-ad21-4a58f786aca6', 'USER', 'ACTIVE', 'FIC'),
('e849ad7e-4f83-5a50-b366-f56a333c25e7', 'USER', 'ACTIVE', 'FIC'),
('eb004651-cde0-5ca3-8728-acaec07c01e7', 'USER', 'ACTIVE', 'FIC'),
('f4d59604-7750-5970-9d97-d411cf45e259', 'ISSUANCE', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('02fe5d52-db5e-52d8-972e-3cc41bf307bd', 0),
('22574524-814d-561b-b4f2-dedf36f80ac6', 0),
('253592b6-3d15-587c-a8a8-8ba47458b20a', 0),
('2b411fb5-99db-532b-bbbd-6ab7cb9e0a8d', 0),
('33ff3e63-5c3a-56e6-9df8-e3592f490ee2', 0),
('5306320e-691e-5050-b1c8-9de3534e969d', 0),
('601bf377-4460-508e-a807-4f5223b9fd2b', 0),
('64735934-b788-517a-aa8b-f5f63bfc1f0d', 0),
('69498c3b-e8eb-59e2-b6ba-a2adf61b98ce', 0),
('6d8ca648-7a2d-5a32-a93c-70ead0b05b2b', 0),
('72c7fd30-1ed4-5e74-ac0c-8660a15eb3fc', 0),
('7447e1ba-1d5e-5e53-bfe8-22c3a049947b', 0),
('8065771c-ceec-59f7-87bd-f6c5924529a9', 0),
('85fff880-d5d4-5508-bbef-2bc05e3a4610', 0),
('898728aa-4581-53e0-a13d-a7330fec07e5', 0),
('8b8d3d7b-abc7-5630-bbd6-d80e9a32f60c', 0),
('914da527-0a9c-5084-9d4f-3c9b59b0cb54', 0),
('98d1712f-e512-5e10-a427-cb470d0d6ab9', 0),
('9f209b01-1d55-508d-bc37-e502fa3cb598', 0),
('c189e165-af60-5ecd-a5ef-760da096a334', 0),
('c973ccc0-60ed-5ec3-a14e-9f1b03657703', 0),
('dc1c83e1-081e-57ae-b9b8-3074e8114e3a', 0),
('dc9b3092-5995-5d3d-ad21-4a58f786aca6', 0),
('e849ad7e-4f83-5a50-b366-f56a333c25e7', 0),
('eb004651-cde0-5ca3-8728-acaec07c01e7', 0),
('f4d59604-7750-5970-9d97-d411cf45e259', 0);
SELECT account_id FROM balances WHERE account_id IN ('02fe5d52-db5e-52d8-972e-3cc41bf307bd','22574524-814d-561b-b4f2-dedf36f80ac6','253592b6-3d15-587c-a8a8-8ba47458b20a','2b411fb5-99db-532b-bbbd-6ab7cb9e0a8d','33ff3e63-5c3a-56e6-9df8-e3592f490ee2','5306320e-691e-5050-b1c8-9de3534e969d','601bf377-4460-508e-a807-4f5223b9fd2b','64735934-b788-517a-aa8b-f5f63bfc1f0d','69498c3b-e8eb-59e2-b6ba-a2adf61b98ce','6d8ca648-7a2d-5a32-a93c-70ead0b05b2b','72c7fd30-1ed4-5e74-ac0c-8660a15eb3fc','7447e1ba-1d5e-5e53-bfe8-22c3a049947b','8065771c-ceec-59f7-87bd-f6c5924529a9','85fff880-d5d4-5508-bbef-2bc05e3a4610','898728aa-4581-53e0-a13d-a7330fec07e5','8b8d3d7b-abc7-5630-bbd6-d80e9a32f60c','914da527-0a9c-5084-9d4f-3c9b59b0cb54','98d1712f-e512-5e10-a427-cb470d0d6ab9','9f209b01-1d55-508d-bc37-e502fa3cb598','c189e165-af60-5ecd-a5ef-760da096a334','c973ccc0-60ed-5ec3-a14e-9f1b03657703','dc1c83e1-081e-57ae-b9b8-3074e8114e3a','dc9b3092-5995-5d3d-ad21-4a58f786aca6','e849ad7e-4f83-5a50-b366-f56a333c25e7','eb004651-cde0-5ca3-8728-acaec07c01e7','f4d59604-7750-5970-9d97-d411cf45e259') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0f844e52-055f-571b-af2d-b9efd569c778', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-0', 'f4d59604-7750-5970-9d97-d411cf45e259', 'c189e165-af60-5ecd-a5ef-760da096a334', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c189e165-af60-5ecd-a5ef-760da096a334';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0f844e52-055f-571b-af2d-b9efd569c778', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('0f844e52-055f-571b-af2d-b9efd569c778', 'c189e165-af60-5ecd-a5ef-760da096a334', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0f844e52-055f-571b-af2d-b9efd569c778';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4058a56e-4eca-52dc-9df7-fd742384882e', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-1', 'f4d59604-7750-5970-9d97-d411cf45e259', '98d1712f-e512-5e10-a427-cb470d0d6ab9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '98d1712f-e512-5e10-a427-cb470d0d6ab9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4058a56e-4eca-52dc-9df7-fd742384882e', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('4058a56e-4eca-52dc-9df7-fd742384882e', '98d1712f-e512-5e10-a427-cb470d0d6ab9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4058a56e-4eca-52dc-9df7-fd742384882e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('99d68b6d-222e-5a71-b3ac-615452ad1664', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-2', 'f4d59604-7750-5970-9d97-d411cf45e259', '6d8ca648-7a2d-5a32-a93c-70ead0b05b2b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6d8ca648-7a2d-5a32-a93c-70ead0b05b2b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('99d68b6d-222e-5a71-b3ac-615452ad1664', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('99d68b6d-222e-5a71-b3ac-615452ad1664', '6d8ca648-7a2d-5a32-a93c-70ead0b05b2b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '99d68b6d-222e-5a71-b3ac-615452ad1664';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('11c5af2a-3eed-5db5-919d-ca23bcdc07e9', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-3', 'f4d59604-7750-5970-9d97-d411cf45e259', '7447e1ba-1d5e-5e53-bfe8-22c3a049947b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7447e1ba-1d5e-5e53-bfe8-22c3a049947b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('11c5af2a-3eed-5db5-919d-ca23bcdc07e9', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('11c5af2a-3eed-5db5-919d-ca23bcdc07e9', '7447e1ba-1d5e-5e53-bfe8-22c3a049947b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '11c5af2a-3eed-5db5-919d-ca23bcdc07e9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1419d224-f728-51c7-b285-910dd1defe9b', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-4', 'f4d59604-7750-5970-9d97-d411cf45e259', '8065771c-ceec-59f7-87bd-f6c5924529a9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8065771c-ceec-59f7-87bd-f6c5924529a9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1419d224-f728-51c7-b285-910dd1defe9b', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('1419d224-f728-51c7-b285-910dd1defe9b', '8065771c-ceec-59f7-87bd-f6c5924529a9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1419d224-f728-51c7-b285-910dd1defe9b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e23923bd-7bb1-5f6c-8871-9ba7b6a13cb3', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-5', 'f4d59604-7750-5970-9d97-d411cf45e259', '9f209b01-1d55-508d-bc37-e502fa3cb598', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9f209b01-1d55-508d-bc37-e502fa3cb598';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e23923bd-7bb1-5f6c-8871-9ba7b6a13cb3', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('e23923bd-7bb1-5f6c-8871-9ba7b6a13cb3', '9f209b01-1d55-508d-bc37-e502fa3cb598', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e23923bd-7bb1-5f6c-8871-9ba7b6a13cb3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('fbc69c64-1f8f-5dc8-a6bd-8d471363c4ba', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-6', 'f4d59604-7750-5970-9d97-d411cf45e259', 'dc1c83e1-081e-57ae-b9b8-3074e8114e3a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'dc1c83e1-081e-57ae-b9b8-3074e8114e3a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('fbc69c64-1f8f-5dc8-a6bd-8d471363c4ba', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('fbc69c64-1f8f-5dc8-a6bd-8d471363c4ba', 'dc1c83e1-081e-57ae-b9b8-3074e8114e3a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'fbc69c64-1f8f-5dc8-a6bd-8d471363c4ba';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('94ba60d9-a67e-5c74-a114-24048dbed31d', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-7', 'f4d59604-7750-5970-9d97-d411cf45e259', 'e849ad7e-4f83-5a50-b366-f56a333c25e7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e849ad7e-4f83-5a50-b366-f56a333c25e7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('94ba60d9-a67e-5c74-a114-24048dbed31d', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('94ba60d9-a67e-5c74-a114-24048dbed31d', 'e849ad7e-4f83-5a50-b366-f56a333c25e7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '94ba60d9-a67e-5c74-a114-24048dbed31d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5e13cd83-70b9-55f3-ad55-f5fb5a20ef64', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-8', 'f4d59604-7750-5970-9d97-d411cf45e259', '8b8d3d7b-abc7-5630-bbd6-d80e9a32f60c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8b8d3d7b-abc7-5630-bbd6-d80e9a32f60c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5e13cd83-70b9-55f3-ad55-f5fb5a20ef64', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('5e13cd83-70b9-55f3-ad55-f5fb5a20ef64', '8b8d3d7b-abc7-5630-bbd6-d80e9a32f60c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5e13cd83-70b9-55f3-ad55-f5fb5a20ef64';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b3d18e79-1c69-560e-be82-96bfab71d7d3', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-9', 'f4d59604-7750-5970-9d97-d411cf45e259', '85fff880-d5d4-5508-bbef-2bc05e3a4610', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '85fff880-d5d4-5508-bbef-2bc05e3a4610';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b3d18e79-1c69-560e-be82-96bfab71d7d3', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('b3d18e79-1c69-560e-be82-96bfab71d7d3', '85fff880-d5d4-5508-bbef-2bc05e3a4610', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b3d18e79-1c69-560e-be82-96bfab71d7d3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c174b512-6de1-5f78-b60b-b7463aa05d2f', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-10', 'f4d59604-7750-5970-9d97-d411cf45e259', '5306320e-691e-5050-b1c8-9de3534e969d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5306320e-691e-5050-b1c8-9de3534e969d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c174b512-6de1-5f78-b60b-b7463aa05d2f', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('c174b512-6de1-5f78-b60b-b7463aa05d2f', '5306320e-691e-5050-b1c8-9de3534e969d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c174b512-6de1-5f78-b60b-b7463aa05d2f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9a76cf1c-7625-5376-bd0a-ec740ef287ca', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-11', 'f4d59604-7750-5970-9d97-d411cf45e259', '02fe5d52-db5e-52d8-972e-3cc41bf307bd', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '02fe5d52-db5e-52d8-972e-3cc41bf307bd';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9a76cf1c-7625-5376-bd0a-ec740ef287ca', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('9a76cf1c-7625-5376-bd0a-ec740ef287ca', '02fe5d52-db5e-52d8-972e-3cc41bf307bd', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9a76cf1c-7625-5376-bd0a-ec740ef287ca';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('2ac994c4-ffc0-5470-8532-ef452bb03c62', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-12', 'f4d59604-7750-5970-9d97-d411cf45e259', '64735934-b788-517a-aa8b-f5f63bfc1f0d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '64735934-b788-517a-aa8b-f5f63bfc1f0d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('2ac994c4-ffc0-5470-8532-ef452bb03c62', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('2ac994c4-ffc0-5470-8532-ef452bb03c62', '64735934-b788-517a-aa8b-f5f63bfc1f0d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '2ac994c4-ffc0-5470-8532-ef452bb03c62';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('936da17c-f7c2-5add-9182-ccf976ebcda1', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-13', 'f4d59604-7750-5970-9d97-d411cf45e259', 'dc9b3092-5995-5d3d-ad21-4a58f786aca6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'dc9b3092-5995-5d3d-ad21-4a58f786aca6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('936da17c-f7c2-5add-9182-ccf976ebcda1', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('936da17c-f7c2-5add-9182-ccf976ebcda1', 'dc9b3092-5995-5d3d-ad21-4a58f786aca6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '936da17c-f7c2-5add-9182-ccf976ebcda1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d9a640c1-7962-5ce7-89c0-0ca8607ee613', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-14', 'f4d59604-7750-5970-9d97-d411cf45e259', '2b411fb5-99db-532b-bbbd-6ab7cb9e0a8d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2b411fb5-99db-532b-bbbd-6ab7cb9e0a8d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d9a640c1-7962-5ce7-89c0-0ca8607ee613', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('d9a640c1-7962-5ce7-89c0-0ca8607ee613', '2b411fb5-99db-532b-bbbd-6ab7cb9e0a8d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd9a640c1-7962-5ce7-89c0-0ca8607ee613';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('45a39457-533c-57da-ac46-3bbb257a0536', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-15', 'f4d59604-7750-5970-9d97-d411cf45e259', '69498c3b-e8eb-59e2-b6ba-a2adf61b98ce', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '69498c3b-e8eb-59e2-b6ba-a2adf61b98ce';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('45a39457-533c-57da-ac46-3bbb257a0536', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('45a39457-533c-57da-ac46-3bbb257a0536', '69498c3b-e8eb-59e2-b6ba-a2adf61b98ce', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '45a39457-533c-57da-ac46-3bbb257a0536';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('90d77062-42d1-5a35-b873-7b4cd81b5729', 'benchmark-funding-9bde520e-9739-443d-bf94-710bc9588bfe-16', 'f4d59604-7750-5970-9d97-d411cf45e259', '72c7fd30-1ed4-5e74-ac0c-8660a15eb3fc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f4d59604-7750-5970-9d97-d411cf45e259';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '72c7fd30-1ed4-5e74-ac0c-8660a15eb3fc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('90d77062-42d1-5a35-b873-7b4cd81b5729', 'f4d59604-7750-5970-9d97-d411cf45e259', -1000000000), ('90d77062-42d1-5a35-b873-7b4cd81b5729', '72c7fd30-1ed4-5e74-ac0c-8660a15eb3fc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '90d77062-42d1-5a35-b873-7b4cd81b5729';
COMMIT;
