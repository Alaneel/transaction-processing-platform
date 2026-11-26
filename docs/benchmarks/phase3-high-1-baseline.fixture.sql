-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('0e32a81c-64ff-5406-8ae9-07f616f3a86e', 'USER', 'ACTIVE', 'FIC'),
('152695b7-aa5b-5e51-b12c-ebe1b803506e', 'USER', 'ACTIVE', 'FIC'),
('16e461e7-a6dc-5a34-92cf-fa433d8466e2', 'USER', 'ACTIVE', 'FIC'),
('1b701d8f-f088-52e7-bc78-e604440f34d3', 'USER', 'ACTIVE', 'FIC'),
('2231c836-b3bb-530d-a868-a345c1f75414', 'USER', 'ACTIVE', 'FIC'),
('3c029e76-9a3c-5536-a6b8-c9aba8a68e1e', 'USER', 'ACTIVE', 'FIC'),
('45fe6a0f-d902-53ac-8e16-abfa736e65ca', 'USER', 'ACTIVE', 'FIC'),
('49289927-dbc3-59d3-b4a6-cb17ad263443', 'USER', 'ACTIVE', 'FIC'),
('4b2aec73-5173-5acc-9f62-63b4097a8ed9', 'USER', 'ACTIVE', 'FIC'),
('69393649-8231-50fa-81e3-887a95eccf26', 'USER', 'ACTIVE', 'FIC'),
('76d65ecd-0117-5aa5-a684-2cea663aed86', 'USER', 'ACTIVE', 'FIC'),
('a1d2b552-8ce4-5758-ab30-76583ec5a5f8', 'USER', 'ACTIVE', 'FIC'),
('a30a7721-1282-5617-a2de-051c060dd557', 'USER', 'ACTIVE', 'FIC'),
('a31d84c6-4084-54f4-8e37-2424fac44963', 'USER', 'ACTIVE', 'FIC'),
('a54500a4-b677-52ab-a384-86e8c6fd1539', 'USER', 'ACTIVE', 'FIC'),
('a6975669-77b5-5c44-a434-8fa4830a9f49', 'USER', 'ACTIVE', 'FIC'),
('aa6b7ab8-554c-5da5-b9e5-93640c9df4e1', 'USER', 'ACTIVE', 'FIC'),
('b28145f2-519a-52e0-9712-5f48dca56ed3', 'ISSUANCE', 'ACTIVE', 'FIC'),
('d83b2e33-81bd-55a2-b0cf-cd0102b7febe', 'USER', 'ACTIVE', 'FIC'),
('e154ebe4-611a-55d1-9fd2-3d9be3d98081', 'USER', 'ACTIVE', 'FIC'),
('e41fa48c-5f56-5464-9b33-1ed5e60921e1', 'USER', 'ACTIVE', 'FIC'),
('e9a5a5ee-3ae1-567e-b7fc-0607889362de', 'USER', 'ACTIVE', 'FIC'),
('efb84ff8-c880-5b50-a93c-71f49be760c7', 'USER', 'ACTIVE', 'FIC'),
('f40cff9e-53ca-5a0c-9694-a71d58c01de7', 'USER', 'ACTIVE', 'FIC'),
('f56a7d29-42ed-5a30-9a3d-48d993f20721', 'USER', 'ACTIVE', 'FIC'),
('feda56d4-4540-5cfb-a872-af63379db7d9', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('0e32a81c-64ff-5406-8ae9-07f616f3a86e', 0),
('152695b7-aa5b-5e51-b12c-ebe1b803506e', 0),
('16e461e7-a6dc-5a34-92cf-fa433d8466e2', 0),
('1b701d8f-f088-52e7-bc78-e604440f34d3', 0),
('2231c836-b3bb-530d-a868-a345c1f75414', 0),
('3c029e76-9a3c-5536-a6b8-c9aba8a68e1e', 0),
('45fe6a0f-d902-53ac-8e16-abfa736e65ca', 0),
('49289927-dbc3-59d3-b4a6-cb17ad263443', 0),
('4b2aec73-5173-5acc-9f62-63b4097a8ed9', 0),
('69393649-8231-50fa-81e3-887a95eccf26', 0),
('76d65ecd-0117-5aa5-a684-2cea663aed86', 0),
('a1d2b552-8ce4-5758-ab30-76583ec5a5f8', 0),
('a30a7721-1282-5617-a2de-051c060dd557', 0),
('a31d84c6-4084-54f4-8e37-2424fac44963', 0),
('a54500a4-b677-52ab-a384-86e8c6fd1539', 0),
('a6975669-77b5-5c44-a434-8fa4830a9f49', 0),
('aa6b7ab8-554c-5da5-b9e5-93640c9df4e1', 0),
('b28145f2-519a-52e0-9712-5f48dca56ed3', 0),
('d83b2e33-81bd-55a2-b0cf-cd0102b7febe', 0),
('e154ebe4-611a-55d1-9fd2-3d9be3d98081', 0),
('e41fa48c-5f56-5464-9b33-1ed5e60921e1', 0),
('e9a5a5ee-3ae1-567e-b7fc-0607889362de', 0),
('efb84ff8-c880-5b50-a93c-71f49be760c7', 0),
('f40cff9e-53ca-5a0c-9694-a71d58c01de7', 0),
('f56a7d29-42ed-5a30-9a3d-48d993f20721', 0),
('feda56d4-4540-5cfb-a872-af63379db7d9', 0);
SELECT account_id FROM balances WHERE account_id IN ('0e32a81c-64ff-5406-8ae9-07f616f3a86e','152695b7-aa5b-5e51-b12c-ebe1b803506e','16e461e7-a6dc-5a34-92cf-fa433d8466e2','1b701d8f-f088-52e7-bc78-e604440f34d3','2231c836-b3bb-530d-a868-a345c1f75414','3c029e76-9a3c-5536-a6b8-c9aba8a68e1e','45fe6a0f-d902-53ac-8e16-abfa736e65ca','49289927-dbc3-59d3-b4a6-cb17ad263443','4b2aec73-5173-5acc-9f62-63b4097a8ed9','69393649-8231-50fa-81e3-887a95eccf26','76d65ecd-0117-5aa5-a684-2cea663aed86','a1d2b552-8ce4-5758-ab30-76583ec5a5f8','a30a7721-1282-5617-a2de-051c060dd557','a31d84c6-4084-54f4-8e37-2424fac44963','a54500a4-b677-52ab-a384-86e8c6fd1539','a6975669-77b5-5c44-a434-8fa4830a9f49','aa6b7ab8-554c-5da5-b9e5-93640c9df4e1','b28145f2-519a-52e0-9712-5f48dca56ed3','d83b2e33-81bd-55a2-b0cf-cd0102b7febe','e154ebe4-611a-55d1-9fd2-3d9be3d98081','e41fa48c-5f56-5464-9b33-1ed5e60921e1','e9a5a5ee-3ae1-567e-b7fc-0607889362de','efb84ff8-c880-5b50-a93c-71f49be760c7','f40cff9e-53ca-5a0c-9694-a71d58c01de7','f56a7d29-42ed-5a30-9a3d-48d993f20721','feda56d4-4540-5cfb-a872-af63379db7d9') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f1409d93-81d2-55fe-8740-fa61958510b0', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-0', 'b28145f2-519a-52e0-9712-5f48dca56ed3', '76d65ecd-0117-5aa5-a684-2cea663aed86', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '76d65ecd-0117-5aa5-a684-2cea663aed86';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f1409d93-81d2-55fe-8740-fa61958510b0', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('f1409d93-81d2-55fe-8740-fa61958510b0', '76d65ecd-0117-5aa5-a684-2cea663aed86', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f1409d93-81d2-55fe-8740-fa61958510b0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f66b53b7-b412-599d-9ca3-cc7d24ae8bc1', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-1', 'b28145f2-519a-52e0-9712-5f48dca56ed3', 'a54500a4-b677-52ab-a384-86e8c6fd1539', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a54500a4-b677-52ab-a384-86e8c6fd1539';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f66b53b7-b412-599d-9ca3-cc7d24ae8bc1', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('f66b53b7-b412-599d-9ca3-cc7d24ae8bc1', 'a54500a4-b677-52ab-a384-86e8c6fd1539', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f66b53b7-b412-599d-9ca3-cc7d24ae8bc1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('713c4394-a33e-591f-aacb-10c36cb0f479', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-2', 'b28145f2-519a-52e0-9712-5f48dca56ed3', 'a31d84c6-4084-54f4-8e37-2424fac44963', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a31d84c6-4084-54f4-8e37-2424fac44963';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('713c4394-a33e-591f-aacb-10c36cb0f479', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('713c4394-a33e-591f-aacb-10c36cb0f479', 'a31d84c6-4084-54f4-8e37-2424fac44963', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '713c4394-a33e-591f-aacb-10c36cb0f479';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f2d1060d-ced9-58f7-aca7-b4b69a20a66e', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-3', 'b28145f2-519a-52e0-9712-5f48dca56ed3', '3c029e76-9a3c-5536-a6b8-c9aba8a68e1e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3c029e76-9a3c-5536-a6b8-c9aba8a68e1e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f2d1060d-ced9-58f7-aca7-b4b69a20a66e', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('f2d1060d-ced9-58f7-aca7-b4b69a20a66e', '3c029e76-9a3c-5536-a6b8-c9aba8a68e1e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f2d1060d-ced9-58f7-aca7-b4b69a20a66e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f53d6f35-0682-561a-8067-49494c59f5e4', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-4', 'b28145f2-519a-52e0-9712-5f48dca56ed3', 'e9a5a5ee-3ae1-567e-b7fc-0607889362de', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e9a5a5ee-3ae1-567e-b7fc-0607889362de';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f53d6f35-0682-561a-8067-49494c59f5e4', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('f53d6f35-0682-561a-8067-49494c59f5e4', 'e9a5a5ee-3ae1-567e-b7fc-0607889362de', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f53d6f35-0682-561a-8067-49494c59f5e4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5d184566-928d-5fbe-9b3f-adebc6c5f50a', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-5', 'b28145f2-519a-52e0-9712-5f48dca56ed3', 'a1d2b552-8ce4-5758-ab30-76583ec5a5f8', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a1d2b552-8ce4-5758-ab30-76583ec5a5f8';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5d184566-928d-5fbe-9b3f-adebc6c5f50a', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('5d184566-928d-5fbe-9b3f-adebc6c5f50a', 'a1d2b552-8ce4-5758-ab30-76583ec5a5f8', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5d184566-928d-5fbe-9b3f-adebc6c5f50a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9ae521f3-fb61-50b0-bde3-4c15e9eb92cb', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-6', 'b28145f2-519a-52e0-9712-5f48dca56ed3', '69393649-8231-50fa-81e3-887a95eccf26', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '69393649-8231-50fa-81e3-887a95eccf26';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9ae521f3-fb61-50b0-bde3-4c15e9eb92cb', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('9ae521f3-fb61-50b0-bde3-4c15e9eb92cb', '69393649-8231-50fa-81e3-887a95eccf26', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9ae521f3-fb61-50b0-bde3-4c15e9eb92cb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('52885ee2-21e2-52f5-845c-dd6bc7c22f17', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-7', 'b28145f2-519a-52e0-9712-5f48dca56ed3', '45fe6a0f-d902-53ac-8e16-abfa736e65ca', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '45fe6a0f-d902-53ac-8e16-abfa736e65ca';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('52885ee2-21e2-52f5-845c-dd6bc7c22f17', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('52885ee2-21e2-52f5-845c-dd6bc7c22f17', '45fe6a0f-d902-53ac-8e16-abfa736e65ca', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '52885ee2-21e2-52f5-845c-dd6bc7c22f17';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ec31f9e8-8254-59da-8695-a2aa0a3a4cc9', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-8', 'b28145f2-519a-52e0-9712-5f48dca56ed3', '0e32a81c-64ff-5406-8ae9-07f616f3a86e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0e32a81c-64ff-5406-8ae9-07f616f3a86e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ec31f9e8-8254-59da-8695-a2aa0a3a4cc9', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('ec31f9e8-8254-59da-8695-a2aa0a3a4cc9', '0e32a81c-64ff-5406-8ae9-07f616f3a86e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ec31f9e8-8254-59da-8695-a2aa0a3a4cc9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d6a523f1-e100-5005-a2e0-0fb79ae937a8', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-9', 'b28145f2-519a-52e0-9712-5f48dca56ed3', 'a6975669-77b5-5c44-a434-8fa4830a9f49', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a6975669-77b5-5c44-a434-8fa4830a9f49';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d6a523f1-e100-5005-a2e0-0fb79ae937a8', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('d6a523f1-e100-5005-a2e0-0fb79ae937a8', 'a6975669-77b5-5c44-a434-8fa4830a9f49', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd6a523f1-e100-5005-a2e0-0fb79ae937a8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5b029e60-3c3e-5a1e-af92-2437b446a02b', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-10', 'b28145f2-519a-52e0-9712-5f48dca56ed3', 'e154ebe4-611a-55d1-9fd2-3d9be3d98081', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e154ebe4-611a-55d1-9fd2-3d9be3d98081';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5b029e60-3c3e-5a1e-af92-2437b446a02b', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('5b029e60-3c3e-5a1e-af92-2437b446a02b', 'e154ebe4-611a-55d1-9fd2-3d9be3d98081', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5b029e60-3c3e-5a1e-af92-2437b446a02b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7254b31f-c3eb-5acd-a943-9c47df60cfed', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-11', 'b28145f2-519a-52e0-9712-5f48dca56ed3', 'd83b2e33-81bd-55a2-b0cf-cd0102b7febe', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd83b2e33-81bd-55a2-b0cf-cd0102b7febe';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7254b31f-c3eb-5acd-a943-9c47df60cfed', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('7254b31f-c3eb-5acd-a943-9c47df60cfed', 'd83b2e33-81bd-55a2-b0cf-cd0102b7febe', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7254b31f-c3eb-5acd-a943-9c47df60cfed';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ebdc02a2-60cf-5b9d-a307-37bcabe85ec5', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-12', 'b28145f2-519a-52e0-9712-5f48dca56ed3', '49289927-dbc3-59d3-b4a6-cb17ad263443', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '49289927-dbc3-59d3-b4a6-cb17ad263443';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ebdc02a2-60cf-5b9d-a307-37bcabe85ec5', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('ebdc02a2-60cf-5b9d-a307-37bcabe85ec5', '49289927-dbc3-59d3-b4a6-cb17ad263443', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ebdc02a2-60cf-5b9d-a307-37bcabe85ec5';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d64efcc9-e5ea-582a-af2c-c40ccd2a3f42', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-13', 'b28145f2-519a-52e0-9712-5f48dca56ed3', '1b701d8f-f088-52e7-bc78-e604440f34d3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1b701d8f-f088-52e7-bc78-e604440f34d3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d64efcc9-e5ea-582a-af2c-c40ccd2a3f42', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('d64efcc9-e5ea-582a-af2c-c40ccd2a3f42', '1b701d8f-f088-52e7-bc78-e604440f34d3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd64efcc9-e5ea-582a-af2c-c40ccd2a3f42';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('faac8e8a-954b-51d7-bcf2-25ee9e9b2ad6', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-14', 'b28145f2-519a-52e0-9712-5f48dca56ed3', 'a30a7721-1282-5617-a2de-051c060dd557', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a30a7721-1282-5617-a2de-051c060dd557';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('faac8e8a-954b-51d7-bcf2-25ee9e9b2ad6', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('faac8e8a-954b-51d7-bcf2-25ee9e9b2ad6', 'a30a7721-1282-5617-a2de-051c060dd557', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'faac8e8a-954b-51d7-bcf2-25ee9e9b2ad6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('fbe63b59-0676-5bea-a767-2fe8f6a3b38c', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-15', 'b28145f2-519a-52e0-9712-5f48dca56ed3', '2231c836-b3bb-530d-a868-a345c1f75414', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2231c836-b3bb-530d-a868-a345c1f75414';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('fbe63b59-0676-5bea-a767-2fe8f6a3b38c', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('fbe63b59-0676-5bea-a767-2fe8f6a3b38c', '2231c836-b3bb-530d-a868-a345c1f75414', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'fbe63b59-0676-5bea-a767-2fe8f6a3b38c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7476bd1a-fd9b-5eca-b84a-9495ac355b6e', 'benchmark-funding-032f3d54-a0e6-4200-b9c2-361e12df921d-16', 'b28145f2-519a-52e0-9712-5f48dca56ed3', '16e461e7-a6dc-5a34-92cf-fa433d8466e2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'b28145f2-519a-52e0-9712-5f48dca56ed3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '16e461e7-a6dc-5a34-92cf-fa433d8466e2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7476bd1a-fd9b-5eca-b84a-9495ac355b6e', 'b28145f2-519a-52e0-9712-5f48dca56ed3', -1000000000), ('7476bd1a-fd9b-5eca-b84a-9495ac355b6e', '16e461e7-a6dc-5a34-92cf-fa433d8466e2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7476bd1a-fd9b-5eca-b84a-9495ac355b6e';
COMMIT;
