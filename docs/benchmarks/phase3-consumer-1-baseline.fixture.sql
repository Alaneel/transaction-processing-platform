-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('086d3ac9-2413-593c-a437-b2033e76dde0', 'USER', 'ACTIVE', 'FIC'),
('13d97c04-367b-5991-8adb-d528b738cee1', 'USER', 'ACTIVE', 'FIC'),
('13e11be7-bff5-5c00-b629-67faaf729ccd', 'USER', 'ACTIVE', 'FIC'),
('33409c92-15a4-5903-a7f0-5e59ce2b6305', 'USER', 'ACTIVE', 'FIC'),
('50a71dd5-1336-58e2-aae2-bf27018303fa', 'ISSUANCE', 'ACTIVE', 'FIC'),
('5abae0b2-b8c3-50b6-ab38-cf1a205b4833', 'USER', 'ACTIVE', 'FIC'),
('5eefb9fc-1cbe-52de-98ee-4c89d2e2ddb4', 'USER', 'ACTIVE', 'FIC'),
('64a2f794-5a36-55c4-8d8c-2bbf7a226923', 'USER', 'ACTIVE', 'FIC'),
('652c63f1-5145-5c4a-a7e7-dd893d4fa4fc', 'USER', 'ACTIVE', 'FIC'),
('67b2bf5a-fcc3-5a68-8643-dd27a397636b', 'USER', 'ACTIVE', 'FIC'),
('7458cf2c-e67d-5da1-9501-c7e52a468784', 'USER', 'ACTIVE', 'FIC'),
('76ebaada-9c94-5bb3-8fd6-6fb358011293', 'USER', 'ACTIVE', 'FIC'),
('7b3b2dfe-fef7-56c8-a553-ba42dd006178', 'USER', 'ACTIVE', 'FIC'),
('8f4c661e-367f-5452-a17c-3999491ab206', 'USER', 'ACTIVE', 'FIC'),
('8fa1d725-d755-52ca-b435-7c12949914dd', 'USER', 'ACTIVE', 'FIC'),
('90c3f3f9-90d2-5cfc-a947-798dc0f36eee', 'USER', 'ACTIVE', 'FIC'),
('9b363002-d08b-59f7-b8b6-232980f77eab', 'USER', 'ACTIVE', 'FIC'),
('b1f846e1-2e7b-5766-b4fe-6bd9f4ac37b0', 'USER', 'ACTIVE', 'FIC'),
('c1d8a79c-9311-5998-9fbd-6f9c498eebc5', 'USER', 'ACTIVE', 'FIC'),
('c4c5d666-89b6-5f55-9582-b4773fac14a2', 'USER', 'ACTIVE', 'FIC'),
('d9afee14-8bf1-57ea-bc7d-b726a8ea04e5', 'USER', 'ACTIVE', 'FIC'),
('db135697-6b4e-5ce2-aa6d-a515df913e98', 'USER', 'ACTIVE', 'FIC'),
('dd1225f6-a03e-5484-9770-43aefc2310d9', 'USER', 'ACTIVE', 'FIC'),
('dff898fa-3daf-513c-9044-293249ed475a', 'USER', 'ACTIVE', 'FIC'),
('e6070f3a-c9dc-548c-994f-3c60c6c13732', 'USER', 'ACTIVE', 'FIC'),
('ff1872d6-3055-5d00-865d-3e35a7cc9a08', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('086d3ac9-2413-593c-a437-b2033e76dde0', 0),
('13d97c04-367b-5991-8adb-d528b738cee1', 0),
('13e11be7-bff5-5c00-b629-67faaf729ccd', 0),
('33409c92-15a4-5903-a7f0-5e59ce2b6305', 0),
('50a71dd5-1336-58e2-aae2-bf27018303fa', 0),
('5abae0b2-b8c3-50b6-ab38-cf1a205b4833', 0),
('5eefb9fc-1cbe-52de-98ee-4c89d2e2ddb4', 0),
('64a2f794-5a36-55c4-8d8c-2bbf7a226923', 0),
('652c63f1-5145-5c4a-a7e7-dd893d4fa4fc', 0),
('67b2bf5a-fcc3-5a68-8643-dd27a397636b', 0),
('7458cf2c-e67d-5da1-9501-c7e52a468784', 0),
('76ebaada-9c94-5bb3-8fd6-6fb358011293', 0),
('7b3b2dfe-fef7-56c8-a553-ba42dd006178', 0),
('8f4c661e-367f-5452-a17c-3999491ab206', 0),
('8fa1d725-d755-52ca-b435-7c12949914dd', 0),
('90c3f3f9-90d2-5cfc-a947-798dc0f36eee', 0),
('9b363002-d08b-59f7-b8b6-232980f77eab', 0),
('b1f846e1-2e7b-5766-b4fe-6bd9f4ac37b0', 0),
('c1d8a79c-9311-5998-9fbd-6f9c498eebc5', 0),
('c4c5d666-89b6-5f55-9582-b4773fac14a2', 0),
('d9afee14-8bf1-57ea-bc7d-b726a8ea04e5', 0),
('db135697-6b4e-5ce2-aa6d-a515df913e98', 0),
('dd1225f6-a03e-5484-9770-43aefc2310d9', 0),
('dff898fa-3daf-513c-9044-293249ed475a', 0),
('e6070f3a-c9dc-548c-994f-3c60c6c13732', 0),
('ff1872d6-3055-5d00-865d-3e35a7cc9a08', 0);
SELECT account_id FROM balances WHERE account_id IN ('086d3ac9-2413-593c-a437-b2033e76dde0','13d97c04-367b-5991-8adb-d528b738cee1','13e11be7-bff5-5c00-b629-67faaf729ccd','33409c92-15a4-5903-a7f0-5e59ce2b6305','50a71dd5-1336-58e2-aae2-bf27018303fa','5abae0b2-b8c3-50b6-ab38-cf1a205b4833','5eefb9fc-1cbe-52de-98ee-4c89d2e2ddb4','64a2f794-5a36-55c4-8d8c-2bbf7a226923','652c63f1-5145-5c4a-a7e7-dd893d4fa4fc','67b2bf5a-fcc3-5a68-8643-dd27a397636b','7458cf2c-e67d-5da1-9501-c7e52a468784','76ebaada-9c94-5bb3-8fd6-6fb358011293','7b3b2dfe-fef7-56c8-a553-ba42dd006178','8f4c661e-367f-5452-a17c-3999491ab206','8fa1d725-d755-52ca-b435-7c12949914dd','90c3f3f9-90d2-5cfc-a947-798dc0f36eee','9b363002-d08b-59f7-b8b6-232980f77eab','b1f846e1-2e7b-5766-b4fe-6bd9f4ac37b0','c1d8a79c-9311-5998-9fbd-6f9c498eebc5','c4c5d666-89b6-5f55-9582-b4773fac14a2','d9afee14-8bf1-57ea-bc7d-b726a8ea04e5','db135697-6b4e-5ce2-aa6d-a515df913e98','dd1225f6-a03e-5484-9770-43aefc2310d9','dff898fa-3daf-513c-9044-293249ed475a','e6070f3a-c9dc-548c-994f-3c60c6c13732','ff1872d6-3055-5d00-865d-3e35a7cc9a08') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('67646acc-f670-5371-be78-398dc2121c3c', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-0', '50a71dd5-1336-58e2-aae2-bf27018303fa', '13d97c04-367b-5991-8adb-d528b738cee1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '13d97c04-367b-5991-8adb-d528b738cee1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('67646acc-f670-5371-be78-398dc2121c3c', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('67646acc-f670-5371-be78-398dc2121c3c', '13d97c04-367b-5991-8adb-d528b738cee1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '67646acc-f670-5371-be78-398dc2121c3c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('555ff7fc-efa9-541c-8c37-2ad7c2e8018c', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-1', '50a71dd5-1336-58e2-aae2-bf27018303fa', 'ff1872d6-3055-5d00-865d-3e35a7cc9a08', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ff1872d6-3055-5d00-865d-3e35a7cc9a08';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('555ff7fc-efa9-541c-8c37-2ad7c2e8018c', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('555ff7fc-efa9-541c-8c37-2ad7c2e8018c', 'ff1872d6-3055-5d00-865d-3e35a7cc9a08', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '555ff7fc-efa9-541c-8c37-2ad7c2e8018c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('982888b8-c4f4-58cc-b78b-59dba1fa4683', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-2', '50a71dd5-1336-58e2-aae2-bf27018303fa', '086d3ac9-2413-593c-a437-b2033e76dde0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '086d3ac9-2413-593c-a437-b2033e76dde0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('982888b8-c4f4-58cc-b78b-59dba1fa4683', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('982888b8-c4f4-58cc-b78b-59dba1fa4683', '086d3ac9-2413-593c-a437-b2033e76dde0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '982888b8-c4f4-58cc-b78b-59dba1fa4683';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9e84cf89-f080-5721-8834-18eb993a78e4', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-3', '50a71dd5-1336-58e2-aae2-bf27018303fa', '76ebaada-9c94-5bb3-8fd6-6fb358011293', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '76ebaada-9c94-5bb3-8fd6-6fb358011293';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9e84cf89-f080-5721-8834-18eb993a78e4', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('9e84cf89-f080-5721-8834-18eb993a78e4', '76ebaada-9c94-5bb3-8fd6-6fb358011293', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9e84cf89-f080-5721-8834-18eb993a78e4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5aa80f8e-6426-5af1-8ef9-0c8fb5cc0895', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-4', '50a71dd5-1336-58e2-aae2-bf27018303fa', '652c63f1-5145-5c4a-a7e7-dd893d4fa4fc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '652c63f1-5145-5c4a-a7e7-dd893d4fa4fc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5aa80f8e-6426-5af1-8ef9-0c8fb5cc0895', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('5aa80f8e-6426-5af1-8ef9-0c8fb5cc0895', '652c63f1-5145-5c4a-a7e7-dd893d4fa4fc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5aa80f8e-6426-5af1-8ef9-0c8fb5cc0895';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8b146c9a-083b-5b1f-8b31-9efe71c1d9e8', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-5', '50a71dd5-1336-58e2-aae2-bf27018303fa', 'c1d8a79c-9311-5998-9fbd-6f9c498eebc5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c1d8a79c-9311-5998-9fbd-6f9c498eebc5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8b146c9a-083b-5b1f-8b31-9efe71c1d9e8', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('8b146c9a-083b-5b1f-8b31-9efe71c1d9e8', 'c1d8a79c-9311-5998-9fbd-6f9c498eebc5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8b146c9a-083b-5b1f-8b31-9efe71c1d9e8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('305f7e3b-af04-5fd7-b716-78ec987aff37', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-6', '50a71dd5-1336-58e2-aae2-bf27018303fa', '9b363002-d08b-59f7-b8b6-232980f77eab', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9b363002-d08b-59f7-b8b6-232980f77eab';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('305f7e3b-af04-5fd7-b716-78ec987aff37', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('305f7e3b-af04-5fd7-b716-78ec987aff37', '9b363002-d08b-59f7-b8b6-232980f77eab', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '305f7e3b-af04-5fd7-b716-78ec987aff37';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e2500dd2-7eff-5a22-954c-4c8b84de4234', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-7', '50a71dd5-1336-58e2-aae2-bf27018303fa', '5eefb9fc-1cbe-52de-98ee-4c89d2e2ddb4', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5eefb9fc-1cbe-52de-98ee-4c89d2e2ddb4';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e2500dd2-7eff-5a22-954c-4c8b84de4234', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('e2500dd2-7eff-5a22-954c-4c8b84de4234', '5eefb9fc-1cbe-52de-98ee-4c89d2e2ddb4', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e2500dd2-7eff-5a22-954c-4c8b84de4234';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a2e7662e-1709-58c2-9ffd-666ff433a8a7', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-8', '50a71dd5-1336-58e2-aae2-bf27018303fa', '64a2f794-5a36-55c4-8d8c-2bbf7a226923', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '64a2f794-5a36-55c4-8d8c-2bbf7a226923';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a2e7662e-1709-58c2-9ffd-666ff433a8a7', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('a2e7662e-1709-58c2-9ffd-666ff433a8a7', '64a2f794-5a36-55c4-8d8c-2bbf7a226923', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a2e7662e-1709-58c2-9ffd-666ff433a8a7';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('129b910b-3235-5874-b0d5-56b0416eabdf', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-9', '50a71dd5-1336-58e2-aae2-bf27018303fa', '8f4c661e-367f-5452-a17c-3999491ab206', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8f4c661e-367f-5452-a17c-3999491ab206';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('129b910b-3235-5874-b0d5-56b0416eabdf', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('129b910b-3235-5874-b0d5-56b0416eabdf', '8f4c661e-367f-5452-a17c-3999491ab206', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '129b910b-3235-5874-b0d5-56b0416eabdf';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ea9f1493-aff4-5a85-b4d5-b0b28f24011a', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-10', '50a71dd5-1336-58e2-aae2-bf27018303fa', 'b1f846e1-2e7b-5766-b4fe-6bd9f4ac37b0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b1f846e1-2e7b-5766-b4fe-6bd9f4ac37b0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ea9f1493-aff4-5a85-b4d5-b0b28f24011a', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('ea9f1493-aff4-5a85-b4d5-b0b28f24011a', 'b1f846e1-2e7b-5766-b4fe-6bd9f4ac37b0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ea9f1493-aff4-5a85-b4d5-b0b28f24011a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d9faa953-94a3-5a04-a351-bc640b5121d7', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-11', '50a71dd5-1336-58e2-aae2-bf27018303fa', '90c3f3f9-90d2-5cfc-a947-798dc0f36eee', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '90c3f3f9-90d2-5cfc-a947-798dc0f36eee';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d9faa953-94a3-5a04-a351-bc640b5121d7', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('d9faa953-94a3-5a04-a351-bc640b5121d7', '90c3f3f9-90d2-5cfc-a947-798dc0f36eee', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd9faa953-94a3-5a04-a351-bc640b5121d7';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b85feb0f-9698-59a1-bce8-3056a01142bc', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-12', '50a71dd5-1336-58e2-aae2-bf27018303fa', 'd9afee14-8bf1-57ea-bc7d-b726a8ea04e5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd9afee14-8bf1-57ea-bc7d-b726a8ea04e5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b85feb0f-9698-59a1-bce8-3056a01142bc', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('b85feb0f-9698-59a1-bce8-3056a01142bc', 'd9afee14-8bf1-57ea-bc7d-b726a8ea04e5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b85feb0f-9698-59a1-bce8-3056a01142bc';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b5268e69-7cd2-594d-bcf2-a9f9ad72b04c', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-13', '50a71dd5-1336-58e2-aae2-bf27018303fa', '7b3b2dfe-fef7-56c8-a553-ba42dd006178', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7b3b2dfe-fef7-56c8-a553-ba42dd006178';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b5268e69-7cd2-594d-bcf2-a9f9ad72b04c', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('b5268e69-7cd2-594d-bcf2-a9f9ad72b04c', '7b3b2dfe-fef7-56c8-a553-ba42dd006178', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b5268e69-7cd2-594d-bcf2-a9f9ad72b04c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('618d11b2-b7e7-524b-8a44-f85d25ec915a', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-14', '50a71dd5-1336-58e2-aae2-bf27018303fa', 'c4c5d666-89b6-5f55-9582-b4773fac14a2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c4c5d666-89b6-5f55-9582-b4773fac14a2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('618d11b2-b7e7-524b-8a44-f85d25ec915a', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('618d11b2-b7e7-524b-8a44-f85d25ec915a', 'c4c5d666-89b6-5f55-9582-b4773fac14a2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '618d11b2-b7e7-524b-8a44-f85d25ec915a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7d966e1f-83cd-5faf-860a-b8b5fb360b82', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-15', '50a71dd5-1336-58e2-aae2-bf27018303fa', '33409c92-15a4-5903-a7f0-5e59ce2b6305', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '33409c92-15a4-5903-a7f0-5e59ce2b6305';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7d966e1f-83cd-5faf-860a-b8b5fb360b82', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('7d966e1f-83cd-5faf-860a-b8b5fb360b82', '33409c92-15a4-5903-a7f0-5e59ce2b6305', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7d966e1f-83cd-5faf-860a-b8b5fb360b82';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ec263507-52c5-5005-a653-e5203de896a8', 'benchmark-funding-ac56074f-9954-4d2e-b1a0-f22ae52699e7-16', '50a71dd5-1336-58e2-aae2-bf27018303fa', '67b2bf5a-fcc3-5a68-8643-dd27a397636b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '50a71dd5-1336-58e2-aae2-bf27018303fa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '67b2bf5a-fcc3-5a68-8643-dd27a397636b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ec263507-52c5-5005-a653-e5203de896a8', '50a71dd5-1336-58e2-aae2-bf27018303fa', -1000000000), ('ec263507-52c5-5005-a653-e5203de896a8', '67b2bf5a-fcc3-5a68-8643-dd27a397636b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ec263507-52c5-5005-a653-e5203de896a8';
COMMIT;
