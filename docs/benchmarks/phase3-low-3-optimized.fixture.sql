-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('05b4d208-a1d0-5a01-82ea-b76ba1ef3771', 'USER', 'ACTIVE', 'FIC'),
('071f641a-d7aa-5bb5-9c1e-995df04c4d2a', 'USER', 'ACTIVE', 'FIC'),
('0e08ef70-523a-5993-90ad-6a18753cdecb', 'USER', 'ACTIVE', 'FIC'),
('113259d6-95b5-5793-93f5-6e88303f2410', 'USER', 'ACTIVE', 'FIC'),
('35132655-b6af-59cd-ae53-bed3706f1a00', 'USER', 'ACTIVE', 'FIC'),
('3a835cd0-70cf-5414-84a9-f5ec3b5fa0bc', 'USER', 'ACTIVE', 'FIC'),
('3a8d3531-666b-5e88-81aa-9cf16dde1dd2', 'USER', 'ACTIVE', 'FIC'),
('4b0039b9-5f90-5ce1-ab8a-79f73371dc32', 'USER', 'ACTIVE', 'FIC'),
('4f2a26ed-ef49-5369-bda4-e0f5c61019ab', 'ISSUANCE', 'ACTIVE', 'FIC'),
('5224e3d1-ae89-5622-b22b-6530eae252ea', 'USER', 'ACTIVE', 'FIC'),
('533e7844-d525-54b1-b95e-244dc7210ed0', 'USER', 'ACTIVE', 'FIC'),
('59d4b5a0-00f2-548e-a14f-21064cf2dc37', 'USER', 'ACTIVE', 'FIC'),
('78d2b4af-0445-59a1-9007-d7fd809ca1d4', 'USER', 'ACTIVE', 'FIC'),
('7b631a9c-4110-5b0f-9194-b38e0063d032', 'USER', 'ACTIVE', 'FIC'),
('80db8a1b-827a-5381-8e65-ac560524eefc', 'USER', 'ACTIVE', 'FIC'),
('9683abb3-253e-58f0-a63e-aa22c8cf0d97', 'USER', 'ACTIVE', 'FIC'),
('b187f2f7-7120-5d7f-83a1-d38a559db9ed', 'USER', 'ACTIVE', 'FIC'),
('b73cfec2-ec1c-5969-a37b-9f62f63b9eb5', 'USER', 'ACTIVE', 'FIC'),
('bf42ce0f-bf0a-5bf2-ae11-44afc7a73c2b', 'USER', 'ACTIVE', 'FIC'),
('c29a33cd-f6cd-5356-9b27-7f99644fca99', 'USER', 'ACTIVE', 'FIC'),
('ce6f2e2b-d178-537b-ad4c-128ee19ce52e', 'USER', 'ACTIVE', 'FIC'),
('deea1ee0-d4cc-5725-b35e-9684944ca596', 'USER', 'ACTIVE', 'FIC'),
('ea14ea9b-fb86-5042-8986-2ad9a240029b', 'USER', 'ACTIVE', 'FIC'),
('eb196d23-44a5-5717-a38f-4e8a1b1a765c', 'USER', 'ACTIVE', 'FIC'),
('ee2174e9-8073-57bf-81dc-edbe2e441b5b', 'USER', 'ACTIVE', 'FIC'),
('f95381bb-8d88-5461-a543-594354a312e8', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('05b4d208-a1d0-5a01-82ea-b76ba1ef3771', 0),
('071f641a-d7aa-5bb5-9c1e-995df04c4d2a', 0),
('0e08ef70-523a-5993-90ad-6a18753cdecb', 0),
('113259d6-95b5-5793-93f5-6e88303f2410', 0),
('35132655-b6af-59cd-ae53-bed3706f1a00', 0),
('3a835cd0-70cf-5414-84a9-f5ec3b5fa0bc', 0),
('3a8d3531-666b-5e88-81aa-9cf16dde1dd2', 0),
('4b0039b9-5f90-5ce1-ab8a-79f73371dc32', 0),
('4f2a26ed-ef49-5369-bda4-e0f5c61019ab', 0),
('5224e3d1-ae89-5622-b22b-6530eae252ea', 0),
('533e7844-d525-54b1-b95e-244dc7210ed0', 0),
('59d4b5a0-00f2-548e-a14f-21064cf2dc37', 0),
('78d2b4af-0445-59a1-9007-d7fd809ca1d4', 0),
('7b631a9c-4110-5b0f-9194-b38e0063d032', 0),
('80db8a1b-827a-5381-8e65-ac560524eefc', 0),
('9683abb3-253e-58f0-a63e-aa22c8cf0d97', 0),
('b187f2f7-7120-5d7f-83a1-d38a559db9ed', 0),
('b73cfec2-ec1c-5969-a37b-9f62f63b9eb5', 0),
('bf42ce0f-bf0a-5bf2-ae11-44afc7a73c2b', 0),
('c29a33cd-f6cd-5356-9b27-7f99644fca99', 0),
('ce6f2e2b-d178-537b-ad4c-128ee19ce52e', 0),
('deea1ee0-d4cc-5725-b35e-9684944ca596', 0),
('ea14ea9b-fb86-5042-8986-2ad9a240029b', 0),
('eb196d23-44a5-5717-a38f-4e8a1b1a765c', 0),
('ee2174e9-8073-57bf-81dc-edbe2e441b5b', 0),
('f95381bb-8d88-5461-a543-594354a312e8', 0);
SELECT account_id FROM balances WHERE account_id IN ('05b4d208-a1d0-5a01-82ea-b76ba1ef3771','071f641a-d7aa-5bb5-9c1e-995df04c4d2a','0e08ef70-523a-5993-90ad-6a18753cdecb','113259d6-95b5-5793-93f5-6e88303f2410','35132655-b6af-59cd-ae53-bed3706f1a00','3a835cd0-70cf-5414-84a9-f5ec3b5fa0bc','3a8d3531-666b-5e88-81aa-9cf16dde1dd2','4b0039b9-5f90-5ce1-ab8a-79f73371dc32','4f2a26ed-ef49-5369-bda4-e0f5c61019ab','5224e3d1-ae89-5622-b22b-6530eae252ea','533e7844-d525-54b1-b95e-244dc7210ed0','59d4b5a0-00f2-548e-a14f-21064cf2dc37','78d2b4af-0445-59a1-9007-d7fd809ca1d4','7b631a9c-4110-5b0f-9194-b38e0063d032','80db8a1b-827a-5381-8e65-ac560524eefc','9683abb3-253e-58f0-a63e-aa22c8cf0d97','b187f2f7-7120-5d7f-83a1-d38a559db9ed','b73cfec2-ec1c-5969-a37b-9f62f63b9eb5','bf42ce0f-bf0a-5bf2-ae11-44afc7a73c2b','c29a33cd-f6cd-5356-9b27-7f99644fca99','ce6f2e2b-d178-537b-ad4c-128ee19ce52e','deea1ee0-d4cc-5725-b35e-9684944ca596','ea14ea9b-fb86-5042-8986-2ad9a240029b','eb196d23-44a5-5717-a38f-4e8a1b1a765c','ee2174e9-8073-57bf-81dc-edbe2e441b5b','f95381bb-8d88-5461-a543-594354a312e8') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('bbdfefe2-6799-5b12-8464-c95d5539e7ad', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-0', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', '113259d6-95b5-5793-93f5-6e88303f2410', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '113259d6-95b5-5793-93f5-6e88303f2410';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('bbdfefe2-6799-5b12-8464-c95d5539e7ad', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('bbdfefe2-6799-5b12-8464-c95d5539e7ad', '113259d6-95b5-5793-93f5-6e88303f2410', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'bbdfefe2-6799-5b12-8464-c95d5539e7ad';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('62849f73-cc56-5442-bc2b-2cfa96faa1af', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-1', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', '0e08ef70-523a-5993-90ad-6a18753cdecb', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0e08ef70-523a-5993-90ad-6a18753cdecb';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('62849f73-cc56-5442-bc2b-2cfa96faa1af', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('62849f73-cc56-5442-bc2b-2cfa96faa1af', '0e08ef70-523a-5993-90ad-6a18753cdecb', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '62849f73-cc56-5442-bc2b-2cfa96faa1af';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('306eb8e0-021c-5a51-9b90-0178fc89dbb4', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-2', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', '78d2b4af-0445-59a1-9007-d7fd809ca1d4', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '78d2b4af-0445-59a1-9007-d7fd809ca1d4';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('306eb8e0-021c-5a51-9b90-0178fc89dbb4', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('306eb8e0-021c-5a51-9b90-0178fc89dbb4', '78d2b4af-0445-59a1-9007-d7fd809ca1d4', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '306eb8e0-021c-5a51-9b90-0178fc89dbb4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a4817376-064c-578b-8c32-87e9492102be', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-3', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', '3a835cd0-70cf-5414-84a9-f5ec3b5fa0bc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3a835cd0-70cf-5414-84a9-f5ec3b5fa0bc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a4817376-064c-578b-8c32-87e9492102be', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('a4817376-064c-578b-8c32-87e9492102be', '3a835cd0-70cf-5414-84a9-f5ec3b5fa0bc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a4817376-064c-578b-8c32-87e9492102be';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('18898203-8a9f-57d1-9752-1de7d0c0f7e2', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-4', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', '3a8d3531-666b-5e88-81aa-9cf16dde1dd2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3a8d3531-666b-5e88-81aa-9cf16dde1dd2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('18898203-8a9f-57d1-9752-1de7d0c0f7e2', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('18898203-8a9f-57d1-9752-1de7d0c0f7e2', '3a8d3531-666b-5e88-81aa-9cf16dde1dd2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '18898203-8a9f-57d1-9752-1de7d0c0f7e2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('91c99c43-a5a6-55f1-a848-10c7f60d4091', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-5', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', 'eb196d23-44a5-5717-a38f-4e8a1b1a765c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'eb196d23-44a5-5717-a38f-4e8a1b1a765c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('91c99c43-a5a6-55f1-a848-10c7f60d4091', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('91c99c43-a5a6-55f1-a848-10c7f60d4091', 'eb196d23-44a5-5717-a38f-4e8a1b1a765c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '91c99c43-a5a6-55f1-a848-10c7f60d4091';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('15dd9383-9926-563a-b0af-e4e35fb6938c', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-6', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', 'bf42ce0f-bf0a-5bf2-ae11-44afc7a73c2b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'bf42ce0f-bf0a-5bf2-ae11-44afc7a73c2b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('15dd9383-9926-563a-b0af-e4e35fb6938c', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('15dd9383-9926-563a-b0af-e4e35fb6938c', 'bf42ce0f-bf0a-5bf2-ae11-44afc7a73c2b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '15dd9383-9926-563a-b0af-e4e35fb6938c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d8b81d3d-2fd4-5e4f-9dfd-070d9b643565', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-7', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', '80db8a1b-827a-5381-8e65-ac560524eefc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '80db8a1b-827a-5381-8e65-ac560524eefc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d8b81d3d-2fd4-5e4f-9dfd-070d9b643565', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('d8b81d3d-2fd4-5e4f-9dfd-070d9b643565', '80db8a1b-827a-5381-8e65-ac560524eefc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd8b81d3d-2fd4-5e4f-9dfd-070d9b643565';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('bc1a4395-0d62-512b-b173-98dc8d7db534', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-8', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', 'ea14ea9b-fb86-5042-8986-2ad9a240029b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ea14ea9b-fb86-5042-8986-2ad9a240029b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('bc1a4395-0d62-512b-b173-98dc8d7db534', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('bc1a4395-0d62-512b-b173-98dc8d7db534', 'ea14ea9b-fb86-5042-8986-2ad9a240029b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'bc1a4395-0d62-512b-b173-98dc8d7db534';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('af7c4ac4-5225-501c-b995-4906b2227a66', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-9', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', '071f641a-d7aa-5bb5-9c1e-995df04c4d2a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '071f641a-d7aa-5bb5-9c1e-995df04c4d2a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('af7c4ac4-5225-501c-b995-4906b2227a66', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('af7c4ac4-5225-501c-b995-4906b2227a66', '071f641a-d7aa-5bb5-9c1e-995df04c4d2a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'af7c4ac4-5225-501c-b995-4906b2227a66';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b68866ad-b904-583b-aaa4-22bb86018151', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-10', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', 'ee2174e9-8073-57bf-81dc-edbe2e441b5b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ee2174e9-8073-57bf-81dc-edbe2e441b5b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b68866ad-b904-583b-aaa4-22bb86018151', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('b68866ad-b904-583b-aaa4-22bb86018151', 'ee2174e9-8073-57bf-81dc-edbe2e441b5b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b68866ad-b904-583b-aaa4-22bb86018151';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('04cf6aa4-d469-53e8-b435-35e8a0bec095', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-11', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', 'c29a33cd-f6cd-5356-9b27-7f99644fca99', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c29a33cd-f6cd-5356-9b27-7f99644fca99';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('04cf6aa4-d469-53e8-b435-35e8a0bec095', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('04cf6aa4-d469-53e8-b435-35e8a0bec095', 'c29a33cd-f6cd-5356-9b27-7f99644fca99', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '04cf6aa4-d469-53e8-b435-35e8a0bec095';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0c7098ad-e312-56b0-9747-bc6a18928d61', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-12', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', '7b631a9c-4110-5b0f-9194-b38e0063d032', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7b631a9c-4110-5b0f-9194-b38e0063d032';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0c7098ad-e312-56b0-9747-bc6a18928d61', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('0c7098ad-e312-56b0-9747-bc6a18928d61', '7b631a9c-4110-5b0f-9194-b38e0063d032', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0c7098ad-e312-56b0-9747-bc6a18928d61';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8e423f1a-0086-5c4d-9359-d0e420916cdb', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-13', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', '59d4b5a0-00f2-548e-a14f-21064cf2dc37', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '59d4b5a0-00f2-548e-a14f-21064cf2dc37';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8e423f1a-0086-5c4d-9359-d0e420916cdb', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('8e423f1a-0086-5c4d-9359-d0e420916cdb', '59d4b5a0-00f2-548e-a14f-21064cf2dc37', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8e423f1a-0086-5c4d-9359-d0e420916cdb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('bdee6e1f-4c34-549d-9ff9-3a3734e5ea6b', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-14', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', '05b4d208-a1d0-5a01-82ea-b76ba1ef3771', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '05b4d208-a1d0-5a01-82ea-b76ba1ef3771';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('bdee6e1f-4c34-549d-9ff9-3a3734e5ea6b', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('bdee6e1f-4c34-549d-9ff9-3a3734e5ea6b', '05b4d208-a1d0-5a01-82ea-b76ba1ef3771', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'bdee6e1f-4c34-549d-9ff9-3a3734e5ea6b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0ad4aea0-d9bc-5768-a586-2cf9f7cb6cd1', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-15', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', '35132655-b6af-59cd-ae53-bed3706f1a00', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '35132655-b6af-59cd-ae53-bed3706f1a00';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0ad4aea0-d9bc-5768-a586-2cf9f7cb6cd1', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('0ad4aea0-d9bc-5768-a586-2cf9f7cb6cd1', '35132655-b6af-59cd-ae53-bed3706f1a00', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0ad4aea0-d9bc-5768-a586-2cf9f7cb6cd1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5879bc57-8c64-5e42-867d-d2009bb45608', 'benchmark-funding-cdbbb13d-e1f5-4b51-82ef-1b06d967c093-16', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', '4b0039b9-5f90-5ce1-ab8a-79f73371dc32', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4f2a26ed-ef49-5369-bda4-e0f5c61019ab';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4b0039b9-5f90-5ce1-ab8a-79f73371dc32';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5879bc57-8c64-5e42-867d-d2009bb45608', '4f2a26ed-ef49-5369-bda4-e0f5c61019ab', -1000000000), ('5879bc57-8c64-5e42-867d-d2009bb45608', '4b0039b9-5f90-5ce1-ab8a-79f73371dc32', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5879bc57-8c64-5e42-867d-d2009bb45608';
COMMIT;
