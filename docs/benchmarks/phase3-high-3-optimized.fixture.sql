-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('16eb8083-afb7-5ad1-9c63-682012574f0a', 'USER', 'ACTIVE', 'FIC'),
('1f3f0913-7d7a-5eea-a98a-4922ecf55590', 'USER', 'ACTIVE', 'FIC'),
('1f747410-7b58-57d7-a410-8de52cecc1f6', 'USER', 'ACTIVE', 'FIC'),
('2a3a9a1b-c3fe-5a2c-9ca3-4b51b8b5f084', 'USER', 'ACTIVE', 'FIC'),
('3299ee40-212b-5048-ab2d-b6befa356cdc', 'ISSUANCE', 'ACTIVE', 'FIC'),
('3a01c7ca-2c77-54b5-ad65-96a52691f7d3', 'USER', 'ACTIVE', 'FIC'),
('3f553089-7f42-593d-a87a-bf75a062d368', 'USER', 'ACTIVE', 'FIC'),
('43f84b12-fd78-5eb5-97c8-c3d55607594b', 'USER', 'ACTIVE', 'FIC'),
('5f06ed9d-b9b7-5f1b-9f12-2fe33894d235', 'USER', 'ACTIVE', 'FIC'),
('6e908c15-091c-5c19-bf88-7cf3a3441b10', 'USER', 'ACTIVE', 'FIC'),
('736f68ae-abee-5b56-821b-44c67945fbe8', 'USER', 'ACTIVE', 'FIC'),
('76e4e4c1-b32a-505e-bf35-91488d205bca', 'USER', 'ACTIVE', 'FIC'),
('7a976539-1550-5b5d-bc34-463c6488675d', 'USER', 'ACTIVE', 'FIC'),
('8345acb3-f469-5c02-b087-b27eabc8510f', 'USER', 'ACTIVE', 'FIC'),
('97994d20-3fa9-52d3-8eeb-d4f630c3a907', 'USER', 'ACTIVE', 'FIC'),
('9c1e9264-6b0c-5b02-9cda-710f8edbbbc5', 'USER', 'ACTIVE', 'FIC'),
('a63ea751-05d9-5e9b-8a94-1a0f4842dbc6', 'USER', 'ACTIVE', 'FIC'),
('a6a92ff8-51be-56f4-9e59-0466ab1f6bca', 'USER', 'ACTIVE', 'FIC'),
('b85f870e-9a68-52f6-88c5-d2474d18144a', 'USER', 'ACTIVE', 'FIC'),
('cba2d97c-38dc-5e58-96a2-bd38b3b71ad5', 'USER', 'ACTIVE', 'FIC'),
('dfe683d8-c3ee-5338-b267-c40fed5e44a2', 'USER', 'ACTIVE', 'FIC'),
('ec36f637-9dc4-5eb8-90fc-8bf2f846c5e9', 'USER', 'ACTIVE', 'FIC'),
('f6c37b7d-bb48-55e7-a443-6e26cb29ca92', 'USER', 'ACTIVE', 'FIC'),
('f8162930-4f24-5c6f-96e0-422d8e5150a3', 'USER', 'ACTIVE', 'FIC'),
('fd06a840-987f-53ea-ab46-fcafd110ddc5', 'USER', 'ACTIVE', 'FIC'),
('fe7b884c-4f17-565a-b10f-0ccae567e58e', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('16eb8083-afb7-5ad1-9c63-682012574f0a', 0),
('1f3f0913-7d7a-5eea-a98a-4922ecf55590', 0),
('1f747410-7b58-57d7-a410-8de52cecc1f6', 0),
('2a3a9a1b-c3fe-5a2c-9ca3-4b51b8b5f084', 0),
('3299ee40-212b-5048-ab2d-b6befa356cdc', 0),
('3a01c7ca-2c77-54b5-ad65-96a52691f7d3', 0),
('3f553089-7f42-593d-a87a-bf75a062d368', 0),
('43f84b12-fd78-5eb5-97c8-c3d55607594b', 0),
('5f06ed9d-b9b7-5f1b-9f12-2fe33894d235', 0),
('6e908c15-091c-5c19-bf88-7cf3a3441b10', 0),
('736f68ae-abee-5b56-821b-44c67945fbe8', 0),
('76e4e4c1-b32a-505e-bf35-91488d205bca', 0),
('7a976539-1550-5b5d-bc34-463c6488675d', 0),
('8345acb3-f469-5c02-b087-b27eabc8510f', 0),
('97994d20-3fa9-52d3-8eeb-d4f630c3a907', 0),
('9c1e9264-6b0c-5b02-9cda-710f8edbbbc5', 0),
('a63ea751-05d9-5e9b-8a94-1a0f4842dbc6', 0),
('a6a92ff8-51be-56f4-9e59-0466ab1f6bca', 0),
('b85f870e-9a68-52f6-88c5-d2474d18144a', 0),
('cba2d97c-38dc-5e58-96a2-bd38b3b71ad5', 0),
('dfe683d8-c3ee-5338-b267-c40fed5e44a2', 0),
('ec36f637-9dc4-5eb8-90fc-8bf2f846c5e9', 0),
('f6c37b7d-bb48-55e7-a443-6e26cb29ca92', 0),
('f8162930-4f24-5c6f-96e0-422d8e5150a3', 0),
('fd06a840-987f-53ea-ab46-fcafd110ddc5', 0),
('fe7b884c-4f17-565a-b10f-0ccae567e58e', 0);
SELECT account_id FROM balances WHERE account_id IN ('16eb8083-afb7-5ad1-9c63-682012574f0a','1f3f0913-7d7a-5eea-a98a-4922ecf55590','1f747410-7b58-57d7-a410-8de52cecc1f6','2a3a9a1b-c3fe-5a2c-9ca3-4b51b8b5f084','3299ee40-212b-5048-ab2d-b6befa356cdc','3a01c7ca-2c77-54b5-ad65-96a52691f7d3','3f553089-7f42-593d-a87a-bf75a062d368','43f84b12-fd78-5eb5-97c8-c3d55607594b','5f06ed9d-b9b7-5f1b-9f12-2fe33894d235','6e908c15-091c-5c19-bf88-7cf3a3441b10','736f68ae-abee-5b56-821b-44c67945fbe8','76e4e4c1-b32a-505e-bf35-91488d205bca','7a976539-1550-5b5d-bc34-463c6488675d','8345acb3-f469-5c02-b087-b27eabc8510f','97994d20-3fa9-52d3-8eeb-d4f630c3a907','9c1e9264-6b0c-5b02-9cda-710f8edbbbc5','a63ea751-05d9-5e9b-8a94-1a0f4842dbc6','a6a92ff8-51be-56f4-9e59-0466ab1f6bca','b85f870e-9a68-52f6-88c5-d2474d18144a','cba2d97c-38dc-5e58-96a2-bd38b3b71ad5','dfe683d8-c3ee-5338-b267-c40fed5e44a2','ec36f637-9dc4-5eb8-90fc-8bf2f846c5e9','f6c37b7d-bb48-55e7-a443-6e26cb29ca92','f8162930-4f24-5c6f-96e0-422d8e5150a3','fd06a840-987f-53ea-ab46-fcafd110ddc5','fe7b884c-4f17-565a-b10f-0ccae567e58e') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7b423fc8-3e37-5a3b-b499-c5b8c78ddfda', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-0', '3299ee40-212b-5048-ab2d-b6befa356cdc', 'a63ea751-05d9-5e9b-8a94-1a0f4842dbc6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a63ea751-05d9-5e9b-8a94-1a0f4842dbc6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7b423fc8-3e37-5a3b-b499-c5b8c78ddfda', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('7b423fc8-3e37-5a3b-b499-c5b8c78ddfda', 'a63ea751-05d9-5e9b-8a94-1a0f4842dbc6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7b423fc8-3e37-5a3b-b499-c5b8c78ddfda';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('590d4ba4-eecc-5f35-96a1-49e40c5be989', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-1', '3299ee40-212b-5048-ab2d-b6befa356cdc', '1f747410-7b58-57d7-a410-8de52cecc1f6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1f747410-7b58-57d7-a410-8de52cecc1f6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('590d4ba4-eecc-5f35-96a1-49e40c5be989', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('590d4ba4-eecc-5f35-96a1-49e40c5be989', '1f747410-7b58-57d7-a410-8de52cecc1f6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '590d4ba4-eecc-5f35-96a1-49e40c5be989';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5a5912c7-0ba5-5c53-b7fa-9833224c5971', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-2', '3299ee40-212b-5048-ab2d-b6befa356cdc', 'cba2d97c-38dc-5e58-96a2-bd38b3b71ad5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'cba2d97c-38dc-5e58-96a2-bd38b3b71ad5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5a5912c7-0ba5-5c53-b7fa-9833224c5971', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('5a5912c7-0ba5-5c53-b7fa-9833224c5971', 'cba2d97c-38dc-5e58-96a2-bd38b3b71ad5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5a5912c7-0ba5-5c53-b7fa-9833224c5971';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b869125a-5039-5f31-a64b-ba4f3cb55659', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-3', '3299ee40-212b-5048-ab2d-b6befa356cdc', 'b85f870e-9a68-52f6-88c5-d2474d18144a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b85f870e-9a68-52f6-88c5-d2474d18144a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b869125a-5039-5f31-a64b-ba4f3cb55659', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('b869125a-5039-5f31-a64b-ba4f3cb55659', 'b85f870e-9a68-52f6-88c5-d2474d18144a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b869125a-5039-5f31-a64b-ba4f3cb55659';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('47843d96-b06b-5498-83c2-55dcd02c9aa1', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-4', '3299ee40-212b-5048-ab2d-b6befa356cdc', '5f06ed9d-b9b7-5f1b-9f12-2fe33894d235', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5f06ed9d-b9b7-5f1b-9f12-2fe33894d235';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('47843d96-b06b-5498-83c2-55dcd02c9aa1', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('47843d96-b06b-5498-83c2-55dcd02c9aa1', '5f06ed9d-b9b7-5f1b-9f12-2fe33894d235', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '47843d96-b06b-5498-83c2-55dcd02c9aa1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f679fef0-f12c-5930-a6cd-e9d9a10408b8', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-5', '3299ee40-212b-5048-ab2d-b6befa356cdc', '7a976539-1550-5b5d-bc34-463c6488675d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7a976539-1550-5b5d-bc34-463c6488675d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f679fef0-f12c-5930-a6cd-e9d9a10408b8', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('f679fef0-f12c-5930-a6cd-e9d9a10408b8', '7a976539-1550-5b5d-bc34-463c6488675d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f679fef0-f12c-5930-a6cd-e9d9a10408b8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('786a8c14-5faa-50d4-a0bc-eacbf71ee24d', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-6', '3299ee40-212b-5048-ab2d-b6befa356cdc', 'fd06a840-987f-53ea-ab46-fcafd110ddc5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fd06a840-987f-53ea-ab46-fcafd110ddc5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('786a8c14-5faa-50d4-a0bc-eacbf71ee24d', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('786a8c14-5faa-50d4-a0bc-eacbf71ee24d', 'fd06a840-987f-53ea-ab46-fcafd110ddc5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '786a8c14-5faa-50d4-a0bc-eacbf71ee24d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('fced9930-44a2-5063-bc3b-c4d5ff3f5b6a', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-7', '3299ee40-212b-5048-ab2d-b6befa356cdc', '9c1e9264-6b0c-5b02-9cda-710f8edbbbc5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9c1e9264-6b0c-5b02-9cda-710f8edbbbc5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('fced9930-44a2-5063-bc3b-c4d5ff3f5b6a', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('fced9930-44a2-5063-bc3b-c4d5ff3f5b6a', '9c1e9264-6b0c-5b02-9cda-710f8edbbbc5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'fced9930-44a2-5063-bc3b-c4d5ff3f5b6a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8b05b1d6-3817-53ae-a4ed-ff2b5dfa0da0', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-8', '3299ee40-212b-5048-ab2d-b6befa356cdc', '43f84b12-fd78-5eb5-97c8-c3d55607594b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '43f84b12-fd78-5eb5-97c8-c3d55607594b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8b05b1d6-3817-53ae-a4ed-ff2b5dfa0da0', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('8b05b1d6-3817-53ae-a4ed-ff2b5dfa0da0', '43f84b12-fd78-5eb5-97c8-c3d55607594b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8b05b1d6-3817-53ae-a4ed-ff2b5dfa0da0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5c712c50-7e05-50d3-b4af-f434dc885bc3', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-9', '3299ee40-212b-5048-ab2d-b6befa356cdc', 'dfe683d8-c3ee-5338-b267-c40fed5e44a2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'dfe683d8-c3ee-5338-b267-c40fed5e44a2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5c712c50-7e05-50d3-b4af-f434dc885bc3', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('5c712c50-7e05-50d3-b4af-f434dc885bc3', 'dfe683d8-c3ee-5338-b267-c40fed5e44a2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5c712c50-7e05-50d3-b4af-f434dc885bc3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('69a16c2d-3aff-501f-b19a-52f0fd1fc740', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-10', '3299ee40-212b-5048-ab2d-b6befa356cdc', '76e4e4c1-b32a-505e-bf35-91488d205bca', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '76e4e4c1-b32a-505e-bf35-91488d205bca';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('69a16c2d-3aff-501f-b19a-52f0fd1fc740', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('69a16c2d-3aff-501f-b19a-52f0fd1fc740', '76e4e4c1-b32a-505e-bf35-91488d205bca', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '69a16c2d-3aff-501f-b19a-52f0fd1fc740';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9b439817-b390-5a6e-8161-47b0eb543c23', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-11', '3299ee40-212b-5048-ab2d-b6befa356cdc', 'f8162930-4f24-5c6f-96e0-422d8e5150a3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f8162930-4f24-5c6f-96e0-422d8e5150a3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9b439817-b390-5a6e-8161-47b0eb543c23', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('9b439817-b390-5a6e-8161-47b0eb543c23', 'f8162930-4f24-5c6f-96e0-422d8e5150a3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9b439817-b390-5a6e-8161-47b0eb543c23';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('88256267-1d14-5763-b034-ac40889f8b08', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-12', '3299ee40-212b-5048-ab2d-b6befa356cdc', 'ec36f637-9dc4-5eb8-90fc-8bf2f846c5e9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ec36f637-9dc4-5eb8-90fc-8bf2f846c5e9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('88256267-1d14-5763-b034-ac40889f8b08', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('88256267-1d14-5763-b034-ac40889f8b08', 'ec36f637-9dc4-5eb8-90fc-8bf2f846c5e9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '88256267-1d14-5763-b034-ac40889f8b08';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('10306a10-1031-5e2f-9a53-9dff22de7096', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-13', '3299ee40-212b-5048-ab2d-b6befa356cdc', '736f68ae-abee-5b56-821b-44c67945fbe8', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '736f68ae-abee-5b56-821b-44c67945fbe8';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('10306a10-1031-5e2f-9a53-9dff22de7096', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('10306a10-1031-5e2f-9a53-9dff22de7096', '736f68ae-abee-5b56-821b-44c67945fbe8', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '10306a10-1031-5e2f-9a53-9dff22de7096';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('054f0030-cc51-554f-8c48-7ede022a0601', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-14', '3299ee40-212b-5048-ab2d-b6befa356cdc', '6e908c15-091c-5c19-bf88-7cf3a3441b10', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6e908c15-091c-5c19-bf88-7cf3a3441b10';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('054f0030-cc51-554f-8c48-7ede022a0601', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('054f0030-cc51-554f-8c48-7ede022a0601', '6e908c15-091c-5c19-bf88-7cf3a3441b10', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '054f0030-cc51-554f-8c48-7ede022a0601';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6292592f-9774-552b-a6ef-ee50cf3642b0', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-15', '3299ee40-212b-5048-ab2d-b6befa356cdc', '1f3f0913-7d7a-5eea-a98a-4922ecf55590', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1f3f0913-7d7a-5eea-a98a-4922ecf55590';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6292592f-9774-552b-a6ef-ee50cf3642b0', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('6292592f-9774-552b-a6ef-ee50cf3642b0', '1f3f0913-7d7a-5eea-a98a-4922ecf55590', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6292592f-9774-552b-a6ef-ee50cf3642b0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5c5a64f2-d120-563f-82f7-073b9671e9c9', 'benchmark-funding-9dd755a4-f564-4811-911b-e3b09b0967a0-16', '3299ee40-212b-5048-ab2d-b6befa356cdc', 'fe7b884c-4f17-565a-b10f-0ccae567e58e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '3299ee40-212b-5048-ab2d-b6befa356cdc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fe7b884c-4f17-565a-b10f-0ccae567e58e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5c5a64f2-d120-563f-82f7-073b9671e9c9', '3299ee40-212b-5048-ab2d-b6befa356cdc', -1000000000), ('5c5a64f2-d120-563f-82f7-073b9671e9c9', 'fe7b884c-4f17-565a-b10f-0ccae567e58e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5c5a64f2-d120-563f-82f7-073b9671e9c9';
COMMIT;
