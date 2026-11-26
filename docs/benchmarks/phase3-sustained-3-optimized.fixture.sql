-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('0e4bee7c-a805-5fe3-92bb-58aff6a90412', 'USER', 'ACTIVE', 'FIC'),
('154bdc82-f488-5fe1-8b04-6103f37d3270', 'USER', 'ACTIVE', 'FIC'),
('2b01e971-4753-5795-8c9a-2a7815c89d33', 'ISSUANCE', 'ACTIVE', 'FIC'),
('2ded7b43-7a25-5f4a-9f0f-c335d39e8f11', 'USER', 'ACTIVE', 'FIC'),
('31e9f6ca-58dc-5c12-a114-705af4834249', 'USER', 'ACTIVE', 'FIC'),
('42d7cfea-5a15-5d59-aa36-08bad798ee8e', 'USER', 'ACTIVE', 'FIC'),
('45e291d0-3a3f-5555-94c8-ae5c6d80b782', 'USER', 'ACTIVE', 'FIC'),
('595e1d3e-61aa-5d32-acb1-e0e96bd871f9', 'USER', 'ACTIVE', 'FIC'),
('5a852571-abda-5153-bcb4-03bb1296fe9d', 'USER', 'ACTIVE', 'FIC'),
('5d924614-de24-5e28-baba-66b728e60a9a', 'USER', 'ACTIVE', 'FIC'),
('5ef50f2c-b129-5fc6-8f4c-8ee5e31cc669', 'USER', 'ACTIVE', 'FIC'),
('5f73564f-4548-5363-bd38-ce68356f0eb9', 'USER', 'ACTIVE', 'FIC'),
('641c60a5-33a1-54e4-a8f6-1fce1706aac1', 'USER', 'ACTIVE', 'FIC'),
('6ec7ed83-b96d-5a07-b756-37ee5ed4103b', 'USER', 'ACTIVE', 'FIC'),
('7ae30d41-4145-544c-b537-c9fada25a499', 'USER', 'ACTIVE', 'FIC'),
('7e687b5b-2383-5caf-ac37-36c05e86f6b7', 'USER', 'ACTIVE', 'FIC'),
('8f0f84ff-6ba2-506d-8d9b-3be5142d7ff7', 'USER', 'ACTIVE', 'FIC'),
('9c6d0780-cb87-51d4-b4af-ee45f613fb5f', 'USER', 'ACTIVE', 'FIC'),
('b19f9aa1-2aac-5ae9-b6cb-68fa786907a0', 'USER', 'ACTIVE', 'FIC'),
('b8168601-082f-5b91-8eb6-899f0b0c01a9', 'USER', 'ACTIVE', 'FIC'),
('c01a3a27-6f16-51af-ba9f-302b9f351f92', 'USER', 'ACTIVE', 'FIC'),
('d14cd994-1bf2-57d0-8508-0a165316870c', 'USER', 'ACTIVE', 'FIC'),
('d4cdd2e3-0333-50e7-b1ae-ed35d0515b69', 'USER', 'ACTIVE', 'FIC'),
('ec5f8ff9-1b01-559f-a2d1-e81b7fc54d01', 'USER', 'ACTIVE', 'FIC'),
('f19bbd39-19c6-54b8-af04-86f901e1086a', 'USER', 'ACTIVE', 'FIC'),
('f7494743-af25-565a-a43c-02160ced3624', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('0e4bee7c-a805-5fe3-92bb-58aff6a90412', 0),
('154bdc82-f488-5fe1-8b04-6103f37d3270', 0),
('2b01e971-4753-5795-8c9a-2a7815c89d33', 0),
('2ded7b43-7a25-5f4a-9f0f-c335d39e8f11', 0),
('31e9f6ca-58dc-5c12-a114-705af4834249', 0),
('42d7cfea-5a15-5d59-aa36-08bad798ee8e', 0),
('45e291d0-3a3f-5555-94c8-ae5c6d80b782', 0),
('595e1d3e-61aa-5d32-acb1-e0e96bd871f9', 0),
('5a852571-abda-5153-bcb4-03bb1296fe9d', 0),
('5d924614-de24-5e28-baba-66b728e60a9a', 0),
('5ef50f2c-b129-5fc6-8f4c-8ee5e31cc669', 0),
('5f73564f-4548-5363-bd38-ce68356f0eb9', 0),
('641c60a5-33a1-54e4-a8f6-1fce1706aac1', 0),
('6ec7ed83-b96d-5a07-b756-37ee5ed4103b', 0),
('7ae30d41-4145-544c-b537-c9fada25a499', 0),
('7e687b5b-2383-5caf-ac37-36c05e86f6b7', 0),
('8f0f84ff-6ba2-506d-8d9b-3be5142d7ff7', 0),
('9c6d0780-cb87-51d4-b4af-ee45f613fb5f', 0),
('b19f9aa1-2aac-5ae9-b6cb-68fa786907a0', 0),
('b8168601-082f-5b91-8eb6-899f0b0c01a9', 0),
('c01a3a27-6f16-51af-ba9f-302b9f351f92', 0),
('d14cd994-1bf2-57d0-8508-0a165316870c', 0),
('d4cdd2e3-0333-50e7-b1ae-ed35d0515b69', 0),
('ec5f8ff9-1b01-559f-a2d1-e81b7fc54d01', 0),
('f19bbd39-19c6-54b8-af04-86f901e1086a', 0),
('f7494743-af25-565a-a43c-02160ced3624', 0);
SELECT account_id FROM balances WHERE account_id IN ('0e4bee7c-a805-5fe3-92bb-58aff6a90412','154bdc82-f488-5fe1-8b04-6103f37d3270','2b01e971-4753-5795-8c9a-2a7815c89d33','2ded7b43-7a25-5f4a-9f0f-c335d39e8f11','31e9f6ca-58dc-5c12-a114-705af4834249','42d7cfea-5a15-5d59-aa36-08bad798ee8e','45e291d0-3a3f-5555-94c8-ae5c6d80b782','595e1d3e-61aa-5d32-acb1-e0e96bd871f9','5a852571-abda-5153-bcb4-03bb1296fe9d','5d924614-de24-5e28-baba-66b728e60a9a','5ef50f2c-b129-5fc6-8f4c-8ee5e31cc669','5f73564f-4548-5363-bd38-ce68356f0eb9','641c60a5-33a1-54e4-a8f6-1fce1706aac1','6ec7ed83-b96d-5a07-b756-37ee5ed4103b','7ae30d41-4145-544c-b537-c9fada25a499','7e687b5b-2383-5caf-ac37-36c05e86f6b7','8f0f84ff-6ba2-506d-8d9b-3be5142d7ff7','9c6d0780-cb87-51d4-b4af-ee45f613fb5f','b19f9aa1-2aac-5ae9-b6cb-68fa786907a0','b8168601-082f-5b91-8eb6-899f0b0c01a9','c01a3a27-6f16-51af-ba9f-302b9f351f92','d14cd994-1bf2-57d0-8508-0a165316870c','d4cdd2e3-0333-50e7-b1ae-ed35d0515b69','ec5f8ff9-1b01-559f-a2d1-e81b7fc54d01','f19bbd39-19c6-54b8-af04-86f901e1086a','f7494743-af25-565a-a43c-02160ced3624') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('45859eb9-fdb8-5dcd-a02e-10ee3253de20', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-0', '2b01e971-4753-5795-8c9a-2a7815c89d33', 'b8168601-082f-5b91-8eb6-899f0b0c01a9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b8168601-082f-5b91-8eb6-899f0b0c01a9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('45859eb9-fdb8-5dcd-a02e-10ee3253de20', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('45859eb9-fdb8-5dcd-a02e-10ee3253de20', 'b8168601-082f-5b91-8eb6-899f0b0c01a9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '45859eb9-fdb8-5dcd-a02e-10ee3253de20';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1060cd46-68a7-525c-8084-a964e6368258', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-1', '2b01e971-4753-5795-8c9a-2a7815c89d33', '6ec7ed83-b96d-5a07-b756-37ee5ed4103b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6ec7ed83-b96d-5a07-b756-37ee5ed4103b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1060cd46-68a7-525c-8084-a964e6368258', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('1060cd46-68a7-525c-8084-a964e6368258', '6ec7ed83-b96d-5a07-b756-37ee5ed4103b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1060cd46-68a7-525c-8084-a964e6368258';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ceb9a4d6-2450-542e-a6d3-a9299bd1e3db', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-2', '2b01e971-4753-5795-8c9a-2a7815c89d33', 'd4cdd2e3-0333-50e7-b1ae-ed35d0515b69', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd4cdd2e3-0333-50e7-b1ae-ed35d0515b69';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ceb9a4d6-2450-542e-a6d3-a9299bd1e3db', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('ceb9a4d6-2450-542e-a6d3-a9299bd1e3db', 'd4cdd2e3-0333-50e7-b1ae-ed35d0515b69', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ceb9a4d6-2450-542e-a6d3-a9299bd1e3db';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6fc43aa8-1398-5514-bb19-458b37ed5053', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-3', '2b01e971-4753-5795-8c9a-2a7815c89d33', 'f7494743-af25-565a-a43c-02160ced3624', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f7494743-af25-565a-a43c-02160ced3624';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6fc43aa8-1398-5514-bb19-458b37ed5053', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('6fc43aa8-1398-5514-bb19-458b37ed5053', 'f7494743-af25-565a-a43c-02160ced3624', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6fc43aa8-1398-5514-bb19-458b37ed5053';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5a18d8d0-7504-5e8a-bcb4-c3a030f4e228', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-4', '2b01e971-4753-5795-8c9a-2a7815c89d33', '42d7cfea-5a15-5d59-aa36-08bad798ee8e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '42d7cfea-5a15-5d59-aa36-08bad798ee8e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5a18d8d0-7504-5e8a-bcb4-c3a030f4e228', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('5a18d8d0-7504-5e8a-bcb4-c3a030f4e228', '42d7cfea-5a15-5d59-aa36-08bad798ee8e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5a18d8d0-7504-5e8a-bcb4-c3a030f4e228';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f20a6151-2be4-5395-837c-5720e25a5997', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-5', '2b01e971-4753-5795-8c9a-2a7815c89d33', '595e1d3e-61aa-5d32-acb1-e0e96bd871f9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '595e1d3e-61aa-5d32-acb1-e0e96bd871f9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f20a6151-2be4-5395-837c-5720e25a5997', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('f20a6151-2be4-5395-837c-5720e25a5997', '595e1d3e-61aa-5d32-acb1-e0e96bd871f9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f20a6151-2be4-5395-837c-5720e25a5997';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('120f5e0a-9d8b-5ee4-a965-2f69d0e13a35', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-6', '2b01e971-4753-5795-8c9a-2a7815c89d33', '154bdc82-f488-5fe1-8b04-6103f37d3270', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '154bdc82-f488-5fe1-8b04-6103f37d3270';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('120f5e0a-9d8b-5ee4-a965-2f69d0e13a35', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('120f5e0a-9d8b-5ee4-a965-2f69d0e13a35', '154bdc82-f488-5fe1-8b04-6103f37d3270', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '120f5e0a-9d8b-5ee4-a965-2f69d0e13a35';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('02d9c967-b270-52f4-a634-48efaa6aad40', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-7', '2b01e971-4753-5795-8c9a-2a7815c89d33', '7ae30d41-4145-544c-b537-c9fada25a499', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7ae30d41-4145-544c-b537-c9fada25a499';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('02d9c967-b270-52f4-a634-48efaa6aad40', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('02d9c967-b270-52f4-a634-48efaa6aad40', '7ae30d41-4145-544c-b537-c9fada25a499', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '02d9c967-b270-52f4-a634-48efaa6aad40';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ea151570-0388-5bcb-9b88-c64b97edec76', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-8', '2b01e971-4753-5795-8c9a-2a7815c89d33', 'c01a3a27-6f16-51af-ba9f-302b9f351f92', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c01a3a27-6f16-51af-ba9f-302b9f351f92';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ea151570-0388-5bcb-9b88-c64b97edec76', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('ea151570-0388-5bcb-9b88-c64b97edec76', 'c01a3a27-6f16-51af-ba9f-302b9f351f92', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ea151570-0388-5bcb-9b88-c64b97edec76';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6a1bcc9e-07cd-515b-98f8-46f7f1cf8266', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-9', '2b01e971-4753-5795-8c9a-2a7815c89d33', '5ef50f2c-b129-5fc6-8f4c-8ee5e31cc669', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5ef50f2c-b129-5fc6-8f4c-8ee5e31cc669';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6a1bcc9e-07cd-515b-98f8-46f7f1cf8266', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('6a1bcc9e-07cd-515b-98f8-46f7f1cf8266', '5ef50f2c-b129-5fc6-8f4c-8ee5e31cc669', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6a1bcc9e-07cd-515b-98f8-46f7f1cf8266';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ba1383db-ecf6-53ae-b42e-2900da2ab3a6', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-10', '2b01e971-4753-5795-8c9a-2a7815c89d33', '2ded7b43-7a25-5f4a-9f0f-c335d39e8f11', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2ded7b43-7a25-5f4a-9f0f-c335d39e8f11';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ba1383db-ecf6-53ae-b42e-2900da2ab3a6', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('ba1383db-ecf6-53ae-b42e-2900da2ab3a6', '2ded7b43-7a25-5f4a-9f0f-c335d39e8f11', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ba1383db-ecf6-53ae-b42e-2900da2ab3a6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('eade7d1a-714c-53f2-b555-62344ea8aa9d', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-11', '2b01e971-4753-5795-8c9a-2a7815c89d33', 'b19f9aa1-2aac-5ae9-b6cb-68fa786907a0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b19f9aa1-2aac-5ae9-b6cb-68fa786907a0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('eade7d1a-714c-53f2-b555-62344ea8aa9d', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('eade7d1a-714c-53f2-b555-62344ea8aa9d', 'b19f9aa1-2aac-5ae9-b6cb-68fa786907a0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'eade7d1a-714c-53f2-b555-62344ea8aa9d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('667b2bef-7401-504e-a600-d2b29ee01680', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-12', '2b01e971-4753-5795-8c9a-2a7815c89d33', '5f73564f-4548-5363-bd38-ce68356f0eb9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5f73564f-4548-5363-bd38-ce68356f0eb9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('667b2bef-7401-504e-a600-d2b29ee01680', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('667b2bef-7401-504e-a600-d2b29ee01680', '5f73564f-4548-5363-bd38-ce68356f0eb9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '667b2bef-7401-504e-a600-d2b29ee01680';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('84752e73-16ce-579f-85ce-b27abc43840a', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-13', '2b01e971-4753-5795-8c9a-2a7815c89d33', '5d924614-de24-5e28-baba-66b728e60a9a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5d924614-de24-5e28-baba-66b728e60a9a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('84752e73-16ce-579f-85ce-b27abc43840a', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('84752e73-16ce-579f-85ce-b27abc43840a', '5d924614-de24-5e28-baba-66b728e60a9a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '84752e73-16ce-579f-85ce-b27abc43840a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a49e91de-88b9-5139-ade5-9d1256953379', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-14', '2b01e971-4753-5795-8c9a-2a7815c89d33', '9c6d0780-cb87-51d4-b4af-ee45f613fb5f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9c6d0780-cb87-51d4-b4af-ee45f613fb5f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a49e91de-88b9-5139-ade5-9d1256953379', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('a49e91de-88b9-5139-ade5-9d1256953379', '9c6d0780-cb87-51d4-b4af-ee45f613fb5f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a49e91de-88b9-5139-ade5-9d1256953379';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('59ac6d64-4c93-50a5-a3d4-9f480ff25b74', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-15', '2b01e971-4753-5795-8c9a-2a7815c89d33', 'd14cd994-1bf2-57d0-8508-0a165316870c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd14cd994-1bf2-57d0-8508-0a165316870c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('59ac6d64-4c93-50a5-a3d4-9f480ff25b74', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('59ac6d64-4c93-50a5-a3d4-9f480ff25b74', 'd14cd994-1bf2-57d0-8508-0a165316870c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '59ac6d64-4c93-50a5-a3d4-9f480ff25b74';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('15e29f75-9327-5e2b-affb-e47332f63dcf', 'benchmark-funding-f48dc2b3-ace6-4296-98de-397eeb5c79b2-16', '2b01e971-4753-5795-8c9a-2a7815c89d33', '7e687b5b-2383-5caf-ac37-36c05e86f6b7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2b01e971-4753-5795-8c9a-2a7815c89d33';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7e687b5b-2383-5caf-ac37-36c05e86f6b7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('15e29f75-9327-5e2b-affb-e47332f63dcf', '2b01e971-4753-5795-8c9a-2a7815c89d33', -1000000000), ('15e29f75-9327-5e2b-affb-e47332f63dcf', '7e687b5b-2383-5caf-ac37-36c05e86f6b7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '15e29f75-9327-5e2b-affb-e47332f63dcf';
COMMIT;
