-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('16e2b145-c6a7-5112-9eb5-2052ee67a0f9', 'USER', 'ACTIVE', 'FIC'),
('23f8170c-fa01-57fe-8823-82129bfe6291', 'USER', 'ACTIVE', 'FIC'),
('314cc6c5-9c4b-538b-a38d-d1ff15bf0dda', 'USER', 'ACTIVE', 'FIC'),
('359a6dca-a7fb-52d3-9c0c-c6c88a668d49', 'USER', 'ACTIVE', 'FIC'),
('3d65134a-c8f0-5cca-bffb-54db73b889c8', 'USER', 'ACTIVE', 'FIC'),
('3f5153e8-9534-5269-a5bb-26f97092ce4d', 'USER', 'ACTIVE', 'FIC'),
('46c65455-591f-5d71-9868-ed27db943dff', 'ISSUANCE', 'ACTIVE', 'FIC'),
('4742c234-8ff5-5128-8012-7130d5ee8434', 'USER', 'ACTIVE', 'FIC'),
('4a7a00f4-be02-58d7-bd8d-e9e1ce10c2b3', 'USER', 'ACTIVE', 'FIC'),
('4e6d4813-275a-524a-9312-ee97ff2f813d', 'USER', 'ACTIVE', 'FIC'),
('519c4404-1193-5b21-9cea-bdb25ab70e35', 'USER', 'ACTIVE', 'FIC'),
('56a2123b-1236-5115-9be5-84cc35ff610d', 'USER', 'ACTIVE', 'FIC'),
('60c7066a-8b12-59cc-b844-a25b8c70483a', 'USER', 'ACTIVE', 'FIC'),
('6d0ef004-2023-59f3-a149-0f76a39b47f4', 'USER', 'ACTIVE', 'FIC'),
('710dd64f-f560-54d6-ac3b-a75a681a9cdc', 'USER', 'ACTIVE', 'FIC'),
('8756f55b-9edf-544a-8e89-51731d7156df', 'USER', 'ACTIVE', 'FIC'),
('87ab648e-765b-553e-baf8-5d83eb64b8d5', 'USER', 'ACTIVE', 'FIC'),
('96a9f8be-1ff0-5b3d-a8bb-92e35ff42249', 'USER', 'ACTIVE', 'FIC'),
('a3441bb0-a931-5288-9a55-a31e7fee338b', 'USER', 'ACTIVE', 'FIC'),
('a7a33203-8208-5f4c-b024-623b6f403732', 'USER', 'ACTIVE', 'FIC'),
('a8524586-1d6c-5a4d-9149-f8b45083b4d7', 'USER', 'ACTIVE', 'FIC'),
('bb60eb52-17b4-58b8-8241-96450d3a91b5', 'USER', 'ACTIVE', 'FIC'),
('bfc6c6de-7ea2-5d75-bcae-30b1ab53c350', 'USER', 'ACTIVE', 'FIC'),
('df7f5bdb-53ba-50fd-ab39-216deb2915ab', 'USER', 'ACTIVE', 'FIC'),
('e49412cd-67a7-5797-96d3-0bf877d0499a', 'USER', 'ACTIVE', 'FIC'),
('fa31c0e7-f09a-53ae-9ad8-97b8997bec15', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('16e2b145-c6a7-5112-9eb5-2052ee67a0f9', 0),
('23f8170c-fa01-57fe-8823-82129bfe6291', 0),
('314cc6c5-9c4b-538b-a38d-d1ff15bf0dda', 0),
('359a6dca-a7fb-52d3-9c0c-c6c88a668d49', 0),
('3d65134a-c8f0-5cca-bffb-54db73b889c8', 0),
('3f5153e8-9534-5269-a5bb-26f97092ce4d', 0),
('46c65455-591f-5d71-9868-ed27db943dff', 0),
('4742c234-8ff5-5128-8012-7130d5ee8434', 0),
('4a7a00f4-be02-58d7-bd8d-e9e1ce10c2b3', 0),
('4e6d4813-275a-524a-9312-ee97ff2f813d', 0),
('519c4404-1193-5b21-9cea-bdb25ab70e35', 0),
('56a2123b-1236-5115-9be5-84cc35ff610d', 0),
('60c7066a-8b12-59cc-b844-a25b8c70483a', 0),
('6d0ef004-2023-59f3-a149-0f76a39b47f4', 0),
('710dd64f-f560-54d6-ac3b-a75a681a9cdc', 0),
('8756f55b-9edf-544a-8e89-51731d7156df', 0),
('87ab648e-765b-553e-baf8-5d83eb64b8d5', 0),
('96a9f8be-1ff0-5b3d-a8bb-92e35ff42249', 0),
('a3441bb0-a931-5288-9a55-a31e7fee338b', 0),
('a7a33203-8208-5f4c-b024-623b6f403732', 0),
('a8524586-1d6c-5a4d-9149-f8b45083b4d7', 0),
('bb60eb52-17b4-58b8-8241-96450d3a91b5', 0),
('bfc6c6de-7ea2-5d75-bcae-30b1ab53c350', 0),
('df7f5bdb-53ba-50fd-ab39-216deb2915ab', 0),
('e49412cd-67a7-5797-96d3-0bf877d0499a', 0),
('fa31c0e7-f09a-53ae-9ad8-97b8997bec15', 0);
SELECT account_id FROM balances WHERE account_id IN ('16e2b145-c6a7-5112-9eb5-2052ee67a0f9','23f8170c-fa01-57fe-8823-82129bfe6291','314cc6c5-9c4b-538b-a38d-d1ff15bf0dda','359a6dca-a7fb-52d3-9c0c-c6c88a668d49','3d65134a-c8f0-5cca-bffb-54db73b889c8','3f5153e8-9534-5269-a5bb-26f97092ce4d','46c65455-591f-5d71-9868-ed27db943dff','4742c234-8ff5-5128-8012-7130d5ee8434','4a7a00f4-be02-58d7-bd8d-e9e1ce10c2b3','4e6d4813-275a-524a-9312-ee97ff2f813d','519c4404-1193-5b21-9cea-bdb25ab70e35','56a2123b-1236-5115-9be5-84cc35ff610d','60c7066a-8b12-59cc-b844-a25b8c70483a','6d0ef004-2023-59f3-a149-0f76a39b47f4','710dd64f-f560-54d6-ac3b-a75a681a9cdc','8756f55b-9edf-544a-8e89-51731d7156df','87ab648e-765b-553e-baf8-5d83eb64b8d5','96a9f8be-1ff0-5b3d-a8bb-92e35ff42249','a3441bb0-a931-5288-9a55-a31e7fee338b','a7a33203-8208-5f4c-b024-623b6f403732','a8524586-1d6c-5a4d-9149-f8b45083b4d7','bb60eb52-17b4-58b8-8241-96450d3a91b5','bfc6c6de-7ea2-5d75-bcae-30b1ab53c350','df7f5bdb-53ba-50fd-ab39-216deb2915ab','e49412cd-67a7-5797-96d3-0bf877d0499a','fa31c0e7-f09a-53ae-9ad8-97b8997bec15') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d815599c-2347-546e-b023-f7ab93449a94', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-0', '46c65455-591f-5d71-9868-ed27db943dff', '8756f55b-9edf-544a-8e89-51731d7156df', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8756f55b-9edf-544a-8e89-51731d7156df';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d815599c-2347-546e-b023-f7ab93449a94', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('d815599c-2347-546e-b023-f7ab93449a94', '8756f55b-9edf-544a-8e89-51731d7156df', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd815599c-2347-546e-b023-f7ab93449a94';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d1318476-5f69-5759-80f6-bf818cba3384', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-1', '46c65455-591f-5d71-9868-ed27db943dff', 'a3441bb0-a931-5288-9a55-a31e7fee338b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a3441bb0-a931-5288-9a55-a31e7fee338b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d1318476-5f69-5759-80f6-bf818cba3384', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('d1318476-5f69-5759-80f6-bf818cba3384', 'a3441bb0-a931-5288-9a55-a31e7fee338b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd1318476-5f69-5759-80f6-bf818cba3384';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5ec366d0-5ccb-50b9-a95b-654ab6b0114a', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-2', '46c65455-591f-5d71-9868-ed27db943dff', '3f5153e8-9534-5269-a5bb-26f97092ce4d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3f5153e8-9534-5269-a5bb-26f97092ce4d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5ec366d0-5ccb-50b9-a95b-654ab6b0114a', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('5ec366d0-5ccb-50b9-a95b-654ab6b0114a', '3f5153e8-9534-5269-a5bb-26f97092ce4d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5ec366d0-5ccb-50b9-a95b-654ab6b0114a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0c35d971-f48b-59aa-86c8-cb0dc3718fb8', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-3', '46c65455-591f-5d71-9868-ed27db943dff', '519c4404-1193-5b21-9cea-bdb25ab70e35', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '519c4404-1193-5b21-9cea-bdb25ab70e35';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0c35d971-f48b-59aa-86c8-cb0dc3718fb8', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('0c35d971-f48b-59aa-86c8-cb0dc3718fb8', '519c4404-1193-5b21-9cea-bdb25ab70e35', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0c35d971-f48b-59aa-86c8-cb0dc3718fb8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5b793216-33e7-516a-9862-2869741050fe', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-4', '46c65455-591f-5d71-9868-ed27db943dff', '4742c234-8ff5-5128-8012-7130d5ee8434', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4742c234-8ff5-5128-8012-7130d5ee8434';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5b793216-33e7-516a-9862-2869741050fe', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('5b793216-33e7-516a-9862-2869741050fe', '4742c234-8ff5-5128-8012-7130d5ee8434', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5b793216-33e7-516a-9862-2869741050fe';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9dfe984c-97aa-58e0-80a9-17bd3dbdcde2', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-5', '46c65455-591f-5d71-9868-ed27db943dff', 'a7a33203-8208-5f4c-b024-623b6f403732', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a7a33203-8208-5f4c-b024-623b6f403732';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9dfe984c-97aa-58e0-80a9-17bd3dbdcde2', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('9dfe984c-97aa-58e0-80a9-17bd3dbdcde2', 'a7a33203-8208-5f4c-b024-623b6f403732', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9dfe984c-97aa-58e0-80a9-17bd3dbdcde2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('79f442bc-8f4d-51f0-8196-98152b41ffc1', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-6', '46c65455-591f-5d71-9868-ed27db943dff', 'e49412cd-67a7-5797-96d3-0bf877d0499a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e49412cd-67a7-5797-96d3-0bf877d0499a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('79f442bc-8f4d-51f0-8196-98152b41ffc1', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('79f442bc-8f4d-51f0-8196-98152b41ffc1', 'e49412cd-67a7-5797-96d3-0bf877d0499a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '79f442bc-8f4d-51f0-8196-98152b41ffc1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('68fb4b1f-447d-5002-b2f7-aa12ebba9987', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-7', '46c65455-591f-5d71-9868-ed27db943dff', 'df7f5bdb-53ba-50fd-ab39-216deb2915ab', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'df7f5bdb-53ba-50fd-ab39-216deb2915ab';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('68fb4b1f-447d-5002-b2f7-aa12ebba9987', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('68fb4b1f-447d-5002-b2f7-aa12ebba9987', 'df7f5bdb-53ba-50fd-ab39-216deb2915ab', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '68fb4b1f-447d-5002-b2f7-aa12ebba9987';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('50fd808b-3bae-5178-ada3-7de64cbe7789', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-8', '46c65455-591f-5d71-9868-ed27db943dff', '96a9f8be-1ff0-5b3d-a8bb-92e35ff42249', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '96a9f8be-1ff0-5b3d-a8bb-92e35ff42249';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('50fd808b-3bae-5178-ada3-7de64cbe7789', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('50fd808b-3bae-5178-ada3-7de64cbe7789', '96a9f8be-1ff0-5b3d-a8bb-92e35ff42249', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '50fd808b-3bae-5178-ada3-7de64cbe7789';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0f15781f-6c37-5773-b3a2-2d25fd65e0be', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-9', '46c65455-591f-5d71-9868-ed27db943dff', '56a2123b-1236-5115-9be5-84cc35ff610d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '56a2123b-1236-5115-9be5-84cc35ff610d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0f15781f-6c37-5773-b3a2-2d25fd65e0be', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('0f15781f-6c37-5773-b3a2-2d25fd65e0be', '56a2123b-1236-5115-9be5-84cc35ff610d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0f15781f-6c37-5773-b3a2-2d25fd65e0be';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d3e95aad-2048-56cd-bb98-93629b75c031', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-10', '46c65455-591f-5d71-9868-ed27db943dff', '4a7a00f4-be02-58d7-bd8d-e9e1ce10c2b3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4a7a00f4-be02-58d7-bd8d-e9e1ce10c2b3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d3e95aad-2048-56cd-bb98-93629b75c031', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('d3e95aad-2048-56cd-bb98-93629b75c031', '4a7a00f4-be02-58d7-bd8d-e9e1ce10c2b3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd3e95aad-2048-56cd-bb98-93629b75c031';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('dbf67005-1d79-548f-af94-7ff48cd36e0e', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-11', '46c65455-591f-5d71-9868-ed27db943dff', '359a6dca-a7fb-52d3-9c0c-c6c88a668d49', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '359a6dca-a7fb-52d3-9c0c-c6c88a668d49';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('dbf67005-1d79-548f-af94-7ff48cd36e0e', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('dbf67005-1d79-548f-af94-7ff48cd36e0e', '359a6dca-a7fb-52d3-9c0c-c6c88a668d49', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'dbf67005-1d79-548f-af94-7ff48cd36e0e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b975dc94-f501-545b-a5cf-8f178512f29e', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-12', '46c65455-591f-5d71-9868-ed27db943dff', '710dd64f-f560-54d6-ac3b-a75a681a9cdc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '710dd64f-f560-54d6-ac3b-a75a681a9cdc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b975dc94-f501-545b-a5cf-8f178512f29e', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('b975dc94-f501-545b-a5cf-8f178512f29e', '710dd64f-f560-54d6-ac3b-a75a681a9cdc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b975dc94-f501-545b-a5cf-8f178512f29e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('65c7bc15-e9cc-538b-bebb-f8e92fdb3f31', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-13', '46c65455-591f-5d71-9868-ed27db943dff', '87ab648e-765b-553e-baf8-5d83eb64b8d5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '87ab648e-765b-553e-baf8-5d83eb64b8d5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('65c7bc15-e9cc-538b-bebb-f8e92fdb3f31', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('65c7bc15-e9cc-538b-bebb-f8e92fdb3f31', '87ab648e-765b-553e-baf8-5d83eb64b8d5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '65c7bc15-e9cc-538b-bebb-f8e92fdb3f31';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5dd16f58-9e71-5242-87fc-6ae4a629793a', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-14', '46c65455-591f-5d71-9868-ed27db943dff', 'a8524586-1d6c-5a4d-9149-f8b45083b4d7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a8524586-1d6c-5a4d-9149-f8b45083b4d7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5dd16f58-9e71-5242-87fc-6ae4a629793a', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('5dd16f58-9e71-5242-87fc-6ae4a629793a', 'a8524586-1d6c-5a4d-9149-f8b45083b4d7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5dd16f58-9e71-5242-87fc-6ae4a629793a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('bf00c352-c510-5430-a514-80597e077600', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-15', '46c65455-591f-5d71-9868-ed27db943dff', 'bfc6c6de-7ea2-5d75-bcae-30b1ab53c350', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'bfc6c6de-7ea2-5d75-bcae-30b1ab53c350';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('bf00c352-c510-5430-a514-80597e077600', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('bf00c352-c510-5430-a514-80597e077600', 'bfc6c6de-7ea2-5d75-bcae-30b1ab53c350', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'bf00c352-c510-5430-a514-80597e077600';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a0b53952-4d25-5574-a02a-c0eee5617f9b', 'benchmark-funding-7e19e376-1884-4836-8d98-b107afbac224-16', '46c65455-591f-5d71-9868-ed27db943dff', '6d0ef004-2023-59f3-a149-0f76a39b47f4', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '46c65455-591f-5d71-9868-ed27db943dff';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6d0ef004-2023-59f3-a149-0f76a39b47f4';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a0b53952-4d25-5574-a02a-c0eee5617f9b', '46c65455-591f-5d71-9868-ed27db943dff', -1000000000), ('a0b53952-4d25-5574-a02a-c0eee5617f9b', '6d0ef004-2023-59f3-a149-0f76a39b47f4', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a0b53952-4d25-5574-a02a-c0eee5617f9b';
COMMIT;
