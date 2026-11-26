-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('0f1aa58f-90bc-5491-8fc4-ad9f1022fd52', 'USER', 'ACTIVE', 'FIC'),
('2649244f-d75d-5d66-8504-d7cc0fabfba2', 'USER', 'ACTIVE', 'FIC'),
('2ad58dce-0375-5f8d-b9ce-040df43456b1', 'USER', 'ACTIVE', 'FIC'),
('2b5bcbbb-4975-57ee-8c5c-56155c17de94', 'USER', 'ACTIVE', 'FIC'),
('2cec6de0-957d-5792-8c83-5fbcd43b8137', 'USER', 'ACTIVE', 'FIC'),
('2cf9212e-e47a-5686-91da-bc4bc52744c7', 'USER', 'ACTIVE', 'FIC'),
('34b19709-d5a7-5b1b-8e80-360e1b47c147', 'USER', 'ACTIVE', 'FIC'),
('378eec92-b0d3-5ac8-98c4-526a25d09bd4', 'USER', 'ACTIVE', 'FIC'),
('46e6d595-e4e7-516f-a068-f177e073a688', 'USER', 'ACTIVE', 'FIC'),
('55efb011-7788-5433-9107-a35b36830199', 'USER', 'ACTIVE', 'FIC'),
('661ae3d2-5d2e-5cc7-bbcf-f7e6b86173e9', 'USER', 'ACTIVE', 'FIC'),
('6896da40-b238-564d-828d-974a3ef26805', 'USER', 'ACTIVE', 'FIC'),
('78b7c605-642c-5e38-8f43-bbff99873df8', 'USER', 'ACTIVE', 'FIC'),
('9903b0a2-1f46-5fbd-ae15-d19b2486abe3', 'USER', 'ACTIVE', 'FIC'),
('a35423ca-efa6-5972-b38d-ab7a19ae689d', 'USER', 'ACTIVE', 'FIC'),
('a67fe5e9-2dc3-57a7-89de-dae23412465d', 'USER', 'ACTIVE', 'FIC'),
('a8b4bad8-0094-5ff8-a5ba-931650e5fe28', 'USER', 'ACTIVE', 'FIC'),
('b356d707-5335-5cd2-8e40-d8d1a50b55ef', 'USER', 'ACTIVE', 'FIC'),
('b9232a22-32ca-5660-91e8-b857488e3761', 'USER', 'ACTIVE', 'FIC'),
('c0c5d1cc-562d-592b-92c7-136b19cfc062', 'USER', 'ACTIVE', 'FIC'),
('c50d85da-eb1a-5a9b-bc62-539b8f2c9da7', 'USER', 'ACTIVE', 'FIC'),
('ccb9f3db-8b26-5d1a-8a52-11721f0f6d4f', 'USER', 'ACTIVE', 'FIC'),
('d7b3d2c8-81d4-596c-b065-9cc17e902193', 'ISSUANCE', 'ACTIVE', 'FIC'),
('e98b955b-0fbc-50ad-98da-6847533b4bd9', 'USER', 'ACTIVE', 'FIC'),
('edb5885c-b5f3-5f44-9dc3-67755e47e316', 'USER', 'ACTIVE', 'FIC'),
('fa0a963a-d5ec-5116-a7ed-ac027ac36d3d', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('0f1aa58f-90bc-5491-8fc4-ad9f1022fd52', 0),
('2649244f-d75d-5d66-8504-d7cc0fabfba2', 0),
('2ad58dce-0375-5f8d-b9ce-040df43456b1', 0),
('2b5bcbbb-4975-57ee-8c5c-56155c17de94', 0),
('2cec6de0-957d-5792-8c83-5fbcd43b8137', 0),
('2cf9212e-e47a-5686-91da-bc4bc52744c7', 0),
('34b19709-d5a7-5b1b-8e80-360e1b47c147', 0),
('378eec92-b0d3-5ac8-98c4-526a25d09bd4', 0),
('46e6d595-e4e7-516f-a068-f177e073a688', 0),
('55efb011-7788-5433-9107-a35b36830199', 0),
('661ae3d2-5d2e-5cc7-bbcf-f7e6b86173e9', 0),
('6896da40-b238-564d-828d-974a3ef26805', 0),
('78b7c605-642c-5e38-8f43-bbff99873df8', 0),
('9903b0a2-1f46-5fbd-ae15-d19b2486abe3', 0),
('a35423ca-efa6-5972-b38d-ab7a19ae689d', 0),
('a67fe5e9-2dc3-57a7-89de-dae23412465d', 0),
('a8b4bad8-0094-5ff8-a5ba-931650e5fe28', 0),
('b356d707-5335-5cd2-8e40-d8d1a50b55ef', 0),
('b9232a22-32ca-5660-91e8-b857488e3761', 0),
('c0c5d1cc-562d-592b-92c7-136b19cfc062', 0),
('c50d85da-eb1a-5a9b-bc62-539b8f2c9da7', 0),
('ccb9f3db-8b26-5d1a-8a52-11721f0f6d4f', 0),
('d7b3d2c8-81d4-596c-b065-9cc17e902193', 0),
('e98b955b-0fbc-50ad-98da-6847533b4bd9', 0),
('edb5885c-b5f3-5f44-9dc3-67755e47e316', 0),
('fa0a963a-d5ec-5116-a7ed-ac027ac36d3d', 0);
SELECT account_id FROM balances WHERE account_id IN ('0f1aa58f-90bc-5491-8fc4-ad9f1022fd52','2649244f-d75d-5d66-8504-d7cc0fabfba2','2ad58dce-0375-5f8d-b9ce-040df43456b1','2b5bcbbb-4975-57ee-8c5c-56155c17de94','2cec6de0-957d-5792-8c83-5fbcd43b8137','2cf9212e-e47a-5686-91da-bc4bc52744c7','34b19709-d5a7-5b1b-8e80-360e1b47c147','378eec92-b0d3-5ac8-98c4-526a25d09bd4','46e6d595-e4e7-516f-a068-f177e073a688','55efb011-7788-5433-9107-a35b36830199','661ae3d2-5d2e-5cc7-bbcf-f7e6b86173e9','6896da40-b238-564d-828d-974a3ef26805','78b7c605-642c-5e38-8f43-bbff99873df8','9903b0a2-1f46-5fbd-ae15-d19b2486abe3','a35423ca-efa6-5972-b38d-ab7a19ae689d','a67fe5e9-2dc3-57a7-89de-dae23412465d','a8b4bad8-0094-5ff8-a5ba-931650e5fe28','b356d707-5335-5cd2-8e40-d8d1a50b55ef','b9232a22-32ca-5660-91e8-b857488e3761','c0c5d1cc-562d-592b-92c7-136b19cfc062','c50d85da-eb1a-5a9b-bc62-539b8f2c9da7','ccb9f3db-8b26-5d1a-8a52-11721f0f6d4f','d7b3d2c8-81d4-596c-b065-9cc17e902193','e98b955b-0fbc-50ad-98da-6847533b4bd9','edb5885c-b5f3-5f44-9dc3-67755e47e316','fa0a963a-d5ec-5116-a7ed-ac027ac36d3d') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3986b854-f2fd-5ecb-b99f-e243ae5e0ed3', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-0', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', '2cf9212e-e47a-5686-91da-bc4bc52744c7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2cf9212e-e47a-5686-91da-bc4bc52744c7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3986b854-f2fd-5ecb-b99f-e243ae5e0ed3', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('3986b854-f2fd-5ecb-b99f-e243ae5e0ed3', '2cf9212e-e47a-5686-91da-bc4bc52744c7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3986b854-f2fd-5ecb-b99f-e243ae5e0ed3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8e4d3729-f633-5baf-a98b-2eeb794bd876', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-1', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', '9903b0a2-1f46-5fbd-ae15-d19b2486abe3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9903b0a2-1f46-5fbd-ae15-d19b2486abe3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8e4d3729-f633-5baf-a98b-2eeb794bd876', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('8e4d3729-f633-5baf-a98b-2eeb794bd876', '9903b0a2-1f46-5fbd-ae15-d19b2486abe3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8e4d3729-f633-5baf-a98b-2eeb794bd876';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('31176e2a-886d-5aeb-9b33-8307c25b6ec8', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-2', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', '2b5bcbbb-4975-57ee-8c5c-56155c17de94', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2b5bcbbb-4975-57ee-8c5c-56155c17de94';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('31176e2a-886d-5aeb-9b33-8307c25b6ec8', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('31176e2a-886d-5aeb-9b33-8307c25b6ec8', '2b5bcbbb-4975-57ee-8c5c-56155c17de94', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '31176e2a-886d-5aeb-9b33-8307c25b6ec8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('97af2fd2-4c54-5b8f-9c84-ceca1cd7d9e7', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-3', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', '661ae3d2-5d2e-5cc7-bbcf-f7e6b86173e9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '661ae3d2-5d2e-5cc7-bbcf-f7e6b86173e9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('97af2fd2-4c54-5b8f-9c84-ceca1cd7d9e7', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('97af2fd2-4c54-5b8f-9c84-ceca1cd7d9e7', '661ae3d2-5d2e-5cc7-bbcf-f7e6b86173e9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '97af2fd2-4c54-5b8f-9c84-ceca1cd7d9e7';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e1ac49a6-e69c-58c2-8dda-d73a71e55c32', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-4', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', '0f1aa58f-90bc-5491-8fc4-ad9f1022fd52', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0f1aa58f-90bc-5491-8fc4-ad9f1022fd52';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e1ac49a6-e69c-58c2-8dda-d73a71e55c32', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('e1ac49a6-e69c-58c2-8dda-d73a71e55c32', '0f1aa58f-90bc-5491-8fc4-ad9f1022fd52', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e1ac49a6-e69c-58c2-8dda-d73a71e55c32';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6eb4e95d-93bc-5acf-84f8-a912f5bbbe27', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-5', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', '2cec6de0-957d-5792-8c83-5fbcd43b8137', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2cec6de0-957d-5792-8c83-5fbcd43b8137';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6eb4e95d-93bc-5acf-84f8-a912f5bbbe27', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('6eb4e95d-93bc-5acf-84f8-a912f5bbbe27', '2cec6de0-957d-5792-8c83-5fbcd43b8137', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6eb4e95d-93bc-5acf-84f8-a912f5bbbe27';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('815b03d5-4a73-5892-aff4-5d56879bf982', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-6', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', '55efb011-7788-5433-9107-a35b36830199', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '55efb011-7788-5433-9107-a35b36830199';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('815b03d5-4a73-5892-aff4-5d56879bf982', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('815b03d5-4a73-5892-aff4-5d56879bf982', '55efb011-7788-5433-9107-a35b36830199', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '815b03d5-4a73-5892-aff4-5d56879bf982';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c4e25ac1-930c-585a-a86b-fd9fae44dfdf', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-7', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', '2ad58dce-0375-5f8d-b9ce-040df43456b1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2ad58dce-0375-5f8d-b9ce-040df43456b1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c4e25ac1-930c-585a-a86b-fd9fae44dfdf', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('c4e25ac1-930c-585a-a86b-fd9fae44dfdf', '2ad58dce-0375-5f8d-b9ce-040df43456b1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c4e25ac1-930c-585a-a86b-fd9fae44dfdf';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('202ebe13-d5d5-5928-bfcf-ca88de22eefb', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-8', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', '6896da40-b238-564d-828d-974a3ef26805', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6896da40-b238-564d-828d-974a3ef26805';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('202ebe13-d5d5-5928-bfcf-ca88de22eefb', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('202ebe13-d5d5-5928-bfcf-ca88de22eefb', '6896da40-b238-564d-828d-974a3ef26805', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '202ebe13-d5d5-5928-bfcf-ca88de22eefb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('70f85706-cd96-519c-983a-db4087b7670d', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-9', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', '34b19709-d5a7-5b1b-8e80-360e1b47c147', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '34b19709-d5a7-5b1b-8e80-360e1b47c147';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('70f85706-cd96-519c-983a-db4087b7670d', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('70f85706-cd96-519c-983a-db4087b7670d', '34b19709-d5a7-5b1b-8e80-360e1b47c147', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '70f85706-cd96-519c-983a-db4087b7670d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8a28ba62-2218-54ba-9b50-34193a7c1210', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-10', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', '78b7c605-642c-5e38-8f43-bbff99873df8', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '78b7c605-642c-5e38-8f43-bbff99873df8';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8a28ba62-2218-54ba-9b50-34193a7c1210', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('8a28ba62-2218-54ba-9b50-34193a7c1210', '78b7c605-642c-5e38-8f43-bbff99873df8', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8a28ba62-2218-54ba-9b50-34193a7c1210';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4ea0003e-4f75-5ff1-95b8-98812be7e5f3', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-11', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', '378eec92-b0d3-5ac8-98c4-526a25d09bd4', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '378eec92-b0d3-5ac8-98c4-526a25d09bd4';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4ea0003e-4f75-5ff1-95b8-98812be7e5f3', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('4ea0003e-4f75-5ff1-95b8-98812be7e5f3', '378eec92-b0d3-5ac8-98c4-526a25d09bd4', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4ea0003e-4f75-5ff1-95b8-98812be7e5f3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('88122237-8fac-58fb-a09e-15141d87c6d9', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-12', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', 'b356d707-5335-5cd2-8e40-d8d1a50b55ef', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b356d707-5335-5cd2-8e40-d8d1a50b55ef';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('88122237-8fac-58fb-a09e-15141d87c6d9', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('88122237-8fac-58fb-a09e-15141d87c6d9', 'b356d707-5335-5cd2-8e40-d8d1a50b55ef', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '88122237-8fac-58fb-a09e-15141d87c6d9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('05b766c5-4d5f-53f1-8982-b0ff67797361', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-13', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', 'a35423ca-efa6-5972-b38d-ab7a19ae689d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a35423ca-efa6-5972-b38d-ab7a19ae689d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('05b766c5-4d5f-53f1-8982-b0ff67797361', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('05b766c5-4d5f-53f1-8982-b0ff67797361', 'a35423ca-efa6-5972-b38d-ab7a19ae689d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '05b766c5-4d5f-53f1-8982-b0ff67797361';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e6e52ce9-fdaf-55ba-8652-d636ccc6434f', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-14', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', '46e6d595-e4e7-516f-a068-f177e073a688', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '46e6d595-e4e7-516f-a068-f177e073a688';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e6e52ce9-fdaf-55ba-8652-d636ccc6434f', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('e6e52ce9-fdaf-55ba-8652-d636ccc6434f', '46e6d595-e4e7-516f-a068-f177e073a688', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e6e52ce9-fdaf-55ba-8652-d636ccc6434f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('04af29bb-16e9-554b-a767-9eff9e31a20a', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-15', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', 'c50d85da-eb1a-5a9b-bc62-539b8f2c9da7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c50d85da-eb1a-5a9b-bc62-539b8f2c9da7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('04af29bb-16e9-554b-a767-9eff9e31a20a', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('04af29bb-16e9-554b-a767-9eff9e31a20a', 'c50d85da-eb1a-5a9b-bc62-539b8f2c9da7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '04af29bb-16e9-554b-a767-9eff9e31a20a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('15cb60e7-6017-597b-b012-2ef8b86ce31c', 'benchmark-funding-dacf4532-bf10-4210-9b17-fcd4e0372b08-16', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', 'b9232a22-32ca-5660-91e8-b857488e3761', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'd7b3d2c8-81d4-596c-b065-9cc17e902193';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b9232a22-32ca-5660-91e8-b857488e3761';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('15cb60e7-6017-597b-b012-2ef8b86ce31c', 'd7b3d2c8-81d4-596c-b065-9cc17e902193', -1000000000), ('15cb60e7-6017-597b-b012-2ef8b86ce31c', 'b9232a22-32ca-5660-91e8-b857488e3761', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '15cb60e7-6017-597b-b012-2ef8b86ce31c';
COMMIT;
