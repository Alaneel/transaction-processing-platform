-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('1e3fff09-4feb-5478-ab5b-5ff6c991d323', 'USER', 'ACTIVE', 'FIC'),
('2b636843-058a-5778-a75e-e1911c5a0d9c', 'USER', 'ACTIVE', 'FIC'),
('46b19eba-9057-5579-bd61-fcf3a1b52d7e', 'USER', 'ACTIVE', 'FIC'),
('54b050c8-9011-547e-9273-6fb7ec206304', 'USER', 'ACTIVE', 'FIC'),
('5c8e5798-a217-58c7-bc6c-210dd81259fd', 'USER', 'ACTIVE', 'FIC'),
('6036a18e-a644-561b-97b8-5c121754b89e', 'USER', 'ACTIVE', 'FIC'),
('65966c8c-a738-5591-a372-ca0a1701ced2', 'USER', 'ACTIVE', 'FIC'),
('6bc7ddf9-4b29-5ab6-8dfc-58a6dde94fc0', 'USER', 'ACTIVE', 'FIC'),
('746bda9d-0153-57ba-8e5a-a39fd11952e5', 'USER', 'ACTIVE', 'FIC'),
('84ebdfff-4c26-5176-8580-e01324121786', 'USER', 'ACTIVE', 'FIC'),
('98e2d790-cba3-543a-80dc-54097c5c667e', 'USER', 'ACTIVE', 'FIC'),
('9dbe942a-4d51-5672-93f4-a700c1476c4a', 'USER', 'ACTIVE', 'FIC'),
('a6094172-8bf4-5944-8b0d-0562aea5d7d6', 'USER', 'ACTIVE', 'FIC'),
('a85f2553-f3d0-5bf4-a355-dd2a29058ceb', 'USER', 'ACTIVE', 'FIC'),
('ae801d07-6fcd-562e-8488-fdaff0cdde04', 'USER', 'ACTIVE', 'FIC'),
('b3b3a695-bd1a-59e0-9f93-17e28928b3bb', 'USER', 'ACTIVE', 'FIC'),
('bb034412-d1e5-5423-b992-5197708cfac5', 'USER', 'ACTIVE', 'FIC'),
('c22121a8-f634-5dba-be90-a7d0fc7ec1b6', 'USER', 'ACTIVE', 'FIC'),
('de2b4699-dfd5-5d17-ab8b-7dc7887130f3', 'USER', 'ACTIVE', 'FIC'),
('e1f020d4-3a48-51ac-a4a9-ee3677b8c909', 'USER', 'ACTIVE', 'FIC'),
('e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', 'ISSUANCE', 'ACTIVE', 'FIC'),
('e43b4d35-ab85-58cf-884e-40d8ba5d4e9e', 'USER', 'ACTIVE', 'FIC'),
('e8842f3c-7e26-52bc-8d01-2166c5ff388e', 'USER', 'ACTIVE', 'FIC'),
('f05c4317-6619-5d5b-9de2-00530155dc3a', 'USER', 'ACTIVE', 'FIC'),
('f274c279-1050-5cf5-9227-44c97466e664', 'USER', 'ACTIVE', 'FIC'),
('fbe00f39-28bc-5d6b-9d11-da8fa0631f5e', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('1e3fff09-4feb-5478-ab5b-5ff6c991d323', 0),
('2b636843-058a-5778-a75e-e1911c5a0d9c', 0),
('46b19eba-9057-5579-bd61-fcf3a1b52d7e', 0),
('54b050c8-9011-547e-9273-6fb7ec206304', 0),
('5c8e5798-a217-58c7-bc6c-210dd81259fd', 0),
('6036a18e-a644-561b-97b8-5c121754b89e', 0),
('65966c8c-a738-5591-a372-ca0a1701ced2', 0),
('6bc7ddf9-4b29-5ab6-8dfc-58a6dde94fc0', 0),
('746bda9d-0153-57ba-8e5a-a39fd11952e5', 0),
('84ebdfff-4c26-5176-8580-e01324121786', 0),
('98e2d790-cba3-543a-80dc-54097c5c667e', 0),
('9dbe942a-4d51-5672-93f4-a700c1476c4a', 0),
('a6094172-8bf4-5944-8b0d-0562aea5d7d6', 0),
('a85f2553-f3d0-5bf4-a355-dd2a29058ceb', 0),
('ae801d07-6fcd-562e-8488-fdaff0cdde04', 0),
('b3b3a695-bd1a-59e0-9f93-17e28928b3bb', 0),
('bb034412-d1e5-5423-b992-5197708cfac5', 0),
('c22121a8-f634-5dba-be90-a7d0fc7ec1b6', 0),
('de2b4699-dfd5-5d17-ab8b-7dc7887130f3', 0),
('e1f020d4-3a48-51ac-a4a9-ee3677b8c909', 0),
('e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', 0),
('e43b4d35-ab85-58cf-884e-40d8ba5d4e9e', 0),
('e8842f3c-7e26-52bc-8d01-2166c5ff388e', 0),
('f05c4317-6619-5d5b-9de2-00530155dc3a', 0),
('f274c279-1050-5cf5-9227-44c97466e664', 0),
('fbe00f39-28bc-5d6b-9d11-da8fa0631f5e', 0);
SELECT account_id FROM balances WHERE account_id IN ('1e3fff09-4feb-5478-ab5b-5ff6c991d323','2b636843-058a-5778-a75e-e1911c5a0d9c','46b19eba-9057-5579-bd61-fcf3a1b52d7e','54b050c8-9011-547e-9273-6fb7ec206304','5c8e5798-a217-58c7-bc6c-210dd81259fd','6036a18e-a644-561b-97b8-5c121754b89e','65966c8c-a738-5591-a372-ca0a1701ced2','6bc7ddf9-4b29-5ab6-8dfc-58a6dde94fc0','746bda9d-0153-57ba-8e5a-a39fd11952e5','84ebdfff-4c26-5176-8580-e01324121786','98e2d790-cba3-543a-80dc-54097c5c667e','9dbe942a-4d51-5672-93f4-a700c1476c4a','a6094172-8bf4-5944-8b0d-0562aea5d7d6','a85f2553-f3d0-5bf4-a355-dd2a29058ceb','ae801d07-6fcd-562e-8488-fdaff0cdde04','b3b3a695-bd1a-59e0-9f93-17e28928b3bb','bb034412-d1e5-5423-b992-5197708cfac5','c22121a8-f634-5dba-be90-a7d0fc7ec1b6','de2b4699-dfd5-5d17-ab8b-7dc7887130f3','e1f020d4-3a48-51ac-a4a9-ee3677b8c909','e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5','e43b4d35-ab85-58cf-884e-40d8ba5d4e9e','e8842f3c-7e26-52bc-8d01-2166c5ff388e','f05c4317-6619-5d5b-9de2-00530155dc3a','f274c279-1050-5cf5-9227-44c97466e664','fbe00f39-28bc-5d6b-9d11-da8fa0631f5e') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d8b0686f-920b-5324-b66d-551411680e78', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-0', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', 'c22121a8-f634-5dba-be90-a7d0fc7ec1b6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c22121a8-f634-5dba-be90-a7d0fc7ec1b6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d8b0686f-920b-5324-b66d-551411680e78', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('d8b0686f-920b-5324-b66d-551411680e78', 'c22121a8-f634-5dba-be90-a7d0fc7ec1b6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd8b0686f-920b-5324-b66d-551411680e78';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('54637696-afd0-52f2-b718-efadf86bb48e', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-1', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', 'f05c4317-6619-5d5b-9de2-00530155dc3a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f05c4317-6619-5d5b-9de2-00530155dc3a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('54637696-afd0-52f2-b718-efadf86bb48e', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('54637696-afd0-52f2-b718-efadf86bb48e', 'f05c4317-6619-5d5b-9de2-00530155dc3a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '54637696-afd0-52f2-b718-efadf86bb48e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e70c3ff2-9917-52e9-99e0-29cd7671e91a', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-2', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', '1e3fff09-4feb-5478-ab5b-5ff6c991d323', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1e3fff09-4feb-5478-ab5b-5ff6c991d323';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e70c3ff2-9917-52e9-99e0-29cd7671e91a', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('e70c3ff2-9917-52e9-99e0-29cd7671e91a', '1e3fff09-4feb-5478-ab5b-5ff6c991d323', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e70c3ff2-9917-52e9-99e0-29cd7671e91a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a8c4d95c-d3e8-5521-a0a4-fdf43e8c91b0', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-3', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', 'fbe00f39-28bc-5d6b-9d11-da8fa0631f5e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fbe00f39-28bc-5d6b-9d11-da8fa0631f5e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a8c4d95c-d3e8-5521-a0a4-fdf43e8c91b0', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('a8c4d95c-d3e8-5521-a0a4-fdf43e8c91b0', 'fbe00f39-28bc-5d6b-9d11-da8fa0631f5e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a8c4d95c-d3e8-5521-a0a4-fdf43e8c91b0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('206bb883-5ebe-5236-be2c-e8ade3365152', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-4', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', '9dbe942a-4d51-5672-93f4-a700c1476c4a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9dbe942a-4d51-5672-93f4-a700c1476c4a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('206bb883-5ebe-5236-be2c-e8ade3365152', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('206bb883-5ebe-5236-be2c-e8ade3365152', '9dbe942a-4d51-5672-93f4-a700c1476c4a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '206bb883-5ebe-5236-be2c-e8ade3365152';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9a6fb5b5-77ac-562e-b0b7-0b800a4e49a2', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-5', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', 'e43b4d35-ab85-58cf-884e-40d8ba5d4e9e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e43b4d35-ab85-58cf-884e-40d8ba5d4e9e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9a6fb5b5-77ac-562e-b0b7-0b800a4e49a2', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('9a6fb5b5-77ac-562e-b0b7-0b800a4e49a2', 'e43b4d35-ab85-58cf-884e-40d8ba5d4e9e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9a6fb5b5-77ac-562e-b0b7-0b800a4e49a2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ad8fe104-c80c-5da8-9a2b-d9a139a1303e', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-6', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', 'a85f2553-f3d0-5bf4-a355-dd2a29058ceb', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a85f2553-f3d0-5bf4-a355-dd2a29058ceb';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ad8fe104-c80c-5da8-9a2b-d9a139a1303e', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('ad8fe104-c80c-5da8-9a2b-d9a139a1303e', 'a85f2553-f3d0-5bf4-a355-dd2a29058ceb', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ad8fe104-c80c-5da8-9a2b-d9a139a1303e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9e7cfa33-e32b-5780-8630-e250c9610761', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-7', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', 'ae801d07-6fcd-562e-8488-fdaff0cdde04', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ae801d07-6fcd-562e-8488-fdaff0cdde04';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9e7cfa33-e32b-5780-8630-e250c9610761', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('9e7cfa33-e32b-5780-8630-e250c9610761', 'ae801d07-6fcd-562e-8488-fdaff0cdde04', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9e7cfa33-e32b-5780-8630-e250c9610761';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3d27c484-4e17-59c3-acbe-2739138b1795', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-8', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', 'e8842f3c-7e26-52bc-8d01-2166c5ff388e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e8842f3c-7e26-52bc-8d01-2166c5ff388e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3d27c484-4e17-59c3-acbe-2739138b1795', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('3d27c484-4e17-59c3-acbe-2739138b1795', 'e8842f3c-7e26-52bc-8d01-2166c5ff388e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3d27c484-4e17-59c3-acbe-2739138b1795';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('01b10302-c1a0-5809-a404-7b2170c103e2', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-9', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', 'de2b4699-dfd5-5d17-ab8b-7dc7887130f3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'de2b4699-dfd5-5d17-ab8b-7dc7887130f3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('01b10302-c1a0-5809-a404-7b2170c103e2', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('01b10302-c1a0-5809-a404-7b2170c103e2', 'de2b4699-dfd5-5d17-ab8b-7dc7887130f3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '01b10302-c1a0-5809-a404-7b2170c103e2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('36c50780-8e60-5c1e-80ca-4e946d25297d', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-10', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', '65966c8c-a738-5591-a372-ca0a1701ced2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '65966c8c-a738-5591-a372-ca0a1701ced2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('36c50780-8e60-5c1e-80ca-4e946d25297d', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('36c50780-8e60-5c1e-80ca-4e946d25297d', '65966c8c-a738-5591-a372-ca0a1701ced2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '36c50780-8e60-5c1e-80ca-4e946d25297d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('57d02c11-2c21-583a-91a9-be09997063cb', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-11', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', 'b3b3a695-bd1a-59e0-9f93-17e28928b3bb', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b3b3a695-bd1a-59e0-9f93-17e28928b3bb';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('57d02c11-2c21-583a-91a9-be09997063cb', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('57d02c11-2c21-583a-91a9-be09997063cb', 'b3b3a695-bd1a-59e0-9f93-17e28928b3bb', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '57d02c11-2c21-583a-91a9-be09997063cb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c2a4d28d-fbf0-5310-9141-ba8016833159', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-12', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', 'bb034412-d1e5-5423-b992-5197708cfac5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'bb034412-d1e5-5423-b992-5197708cfac5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c2a4d28d-fbf0-5310-9141-ba8016833159', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('c2a4d28d-fbf0-5310-9141-ba8016833159', 'bb034412-d1e5-5423-b992-5197708cfac5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c2a4d28d-fbf0-5310-9141-ba8016833159';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f7477bfb-6f19-51dd-b87f-6064e512a7aa', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-13', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', 'a6094172-8bf4-5944-8b0d-0562aea5d7d6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a6094172-8bf4-5944-8b0d-0562aea5d7d6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f7477bfb-6f19-51dd-b87f-6064e512a7aa', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('f7477bfb-6f19-51dd-b87f-6064e512a7aa', 'a6094172-8bf4-5944-8b0d-0562aea5d7d6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f7477bfb-6f19-51dd-b87f-6064e512a7aa';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5feb8872-df45-54bc-83f6-4d230e64fa97', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-14', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', '6bc7ddf9-4b29-5ab6-8dfc-58a6dde94fc0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6bc7ddf9-4b29-5ab6-8dfc-58a6dde94fc0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5feb8872-df45-54bc-83f6-4d230e64fa97', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('5feb8872-df45-54bc-83f6-4d230e64fa97', '6bc7ddf9-4b29-5ab6-8dfc-58a6dde94fc0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5feb8872-df45-54bc-83f6-4d230e64fa97';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6375fdce-ca95-5c51-bbe3-9404cedd9ad8', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-15', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', '5c8e5798-a217-58c7-bc6c-210dd81259fd', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5c8e5798-a217-58c7-bc6c-210dd81259fd';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6375fdce-ca95-5c51-bbe3-9404cedd9ad8', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('6375fdce-ca95-5c51-bbe3-9404cedd9ad8', '5c8e5798-a217-58c7-bc6c-210dd81259fd', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6375fdce-ca95-5c51-bbe3-9404cedd9ad8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('255812c0-314a-57ff-b3b6-1e59f6355e47', 'benchmark-funding-788ba1de-a327-45f9-b437-b09ff2f1d2b8-16', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', '746bda9d-0153-57ba-8e5a-a39fd11952e5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '746bda9d-0153-57ba-8e5a-a39fd11952e5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('255812c0-314a-57ff-b3b6-1e59f6355e47', 'e3c7145b-ff0e-5c77-94b5-3efbc8fcf5a5', -1000000000), ('255812c0-314a-57ff-b3b6-1e59f6355e47', '746bda9d-0153-57ba-8e5a-a39fd11952e5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '255812c0-314a-57ff-b3b6-1e59f6355e47';
COMMIT;
