-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('0cca9a87-5519-58c2-8265-c39d6a51a750', 'USER', 'ACTIVE', 'FIC'),
('1a21fc65-da90-5f70-9085-adb7c7fb4d8b', 'USER', 'ACTIVE', 'FIC'),
('2d07a406-2b36-5537-a1b2-089df3cab3f7', 'USER', 'ACTIVE', 'FIC'),
('3d7367ba-4348-5f33-996c-af5e1e37cc81', 'USER', 'ACTIVE', 'FIC'),
('4a6d0cf9-830d-5c06-9524-e9129d1b3307', 'USER', 'ACTIVE', 'FIC'),
('4f4baec0-d2d9-56b5-9ecb-61979d1a2c72', 'USER', 'ACTIVE', 'FIC'),
('5ba15574-fcb4-531e-b93e-86638ab3b97f', 'USER', 'ACTIVE', 'FIC'),
('5bc38096-e8d9-5a2c-9a21-daa6f078b653', 'USER', 'ACTIVE', 'FIC'),
('621c6a14-31f2-5c26-80bc-77624767bd6f', 'USER', 'ACTIVE', 'FIC'),
('62725d52-92f2-5832-8cc7-a69de3e1c44c', 'USER', 'ACTIVE', 'FIC'),
('6c3d1cfe-d840-51df-93e7-f52acb410f35', 'USER', 'ACTIVE', 'FIC'),
('80649e6d-4091-52e5-9276-ff0ebedc45da', 'USER', 'ACTIVE', 'FIC'),
('aa65a54c-3dd5-5671-ac9e-b08121338327', 'USER', 'ACTIVE', 'FIC'),
('b1609c8b-1e26-5d22-98ae-858d50dfa59e', 'USER', 'ACTIVE', 'FIC'),
('bdf1597a-cc73-5780-b1e2-a65dac75e0f3', 'ISSUANCE', 'ACTIVE', 'FIC'),
('be5ed289-d166-51cf-9f32-234da760e43f', 'USER', 'ACTIVE', 'FIC'),
('c16b107a-675e-5af4-b38d-dba5021fb028', 'USER', 'ACTIVE', 'FIC'),
('cb60b78a-6155-5414-afc5-da9a56a495ce', 'USER', 'ACTIVE', 'FIC'),
('cd99d5ce-32fd-556e-a5ed-c1c8d0fdab3d', 'USER', 'ACTIVE', 'FIC'),
('d5538a33-9b6f-5d4f-9584-f7c84616b2be', 'USER', 'ACTIVE', 'FIC'),
('d916c129-d801-54ab-83c2-36c62af5ed9e', 'USER', 'ACTIVE', 'FIC'),
('dbda8254-6e9c-5c5c-b540-9c74609dc555', 'USER', 'ACTIVE', 'FIC'),
('dd3edb6c-6abd-552f-af74-d31495398c9d', 'USER', 'ACTIVE', 'FIC'),
('df323722-da08-584a-aef9-7b797355427b', 'USER', 'ACTIVE', 'FIC'),
('e46cfd9e-9f76-539b-b840-477cc19aee7c', 'USER', 'ACTIVE', 'FIC'),
('e6966b31-519d-56d9-bf29-8dd2b6b71116', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('0cca9a87-5519-58c2-8265-c39d6a51a750', 0),
('1a21fc65-da90-5f70-9085-adb7c7fb4d8b', 0),
('2d07a406-2b36-5537-a1b2-089df3cab3f7', 0),
('3d7367ba-4348-5f33-996c-af5e1e37cc81', 0),
('4a6d0cf9-830d-5c06-9524-e9129d1b3307', 0),
('4f4baec0-d2d9-56b5-9ecb-61979d1a2c72', 0),
('5ba15574-fcb4-531e-b93e-86638ab3b97f', 0),
('5bc38096-e8d9-5a2c-9a21-daa6f078b653', 0),
('621c6a14-31f2-5c26-80bc-77624767bd6f', 0),
('62725d52-92f2-5832-8cc7-a69de3e1c44c', 0),
('6c3d1cfe-d840-51df-93e7-f52acb410f35', 0),
('80649e6d-4091-52e5-9276-ff0ebedc45da', 0),
('aa65a54c-3dd5-5671-ac9e-b08121338327', 0),
('b1609c8b-1e26-5d22-98ae-858d50dfa59e', 0),
('bdf1597a-cc73-5780-b1e2-a65dac75e0f3', 0),
('be5ed289-d166-51cf-9f32-234da760e43f', 0),
('c16b107a-675e-5af4-b38d-dba5021fb028', 0),
('cb60b78a-6155-5414-afc5-da9a56a495ce', 0),
('cd99d5ce-32fd-556e-a5ed-c1c8d0fdab3d', 0),
('d5538a33-9b6f-5d4f-9584-f7c84616b2be', 0),
('d916c129-d801-54ab-83c2-36c62af5ed9e', 0),
('dbda8254-6e9c-5c5c-b540-9c74609dc555', 0),
('dd3edb6c-6abd-552f-af74-d31495398c9d', 0),
('df323722-da08-584a-aef9-7b797355427b', 0),
('e46cfd9e-9f76-539b-b840-477cc19aee7c', 0),
('e6966b31-519d-56d9-bf29-8dd2b6b71116', 0);
SELECT account_id FROM balances WHERE account_id IN ('0cca9a87-5519-58c2-8265-c39d6a51a750','1a21fc65-da90-5f70-9085-adb7c7fb4d8b','2d07a406-2b36-5537-a1b2-089df3cab3f7','3d7367ba-4348-5f33-996c-af5e1e37cc81','4a6d0cf9-830d-5c06-9524-e9129d1b3307','4f4baec0-d2d9-56b5-9ecb-61979d1a2c72','5ba15574-fcb4-531e-b93e-86638ab3b97f','5bc38096-e8d9-5a2c-9a21-daa6f078b653','621c6a14-31f2-5c26-80bc-77624767bd6f','62725d52-92f2-5832-8cc7-a69de3e1c44c','6c3d1cfe-d840-51df-93e7-f52acb410f35','80649e6d-4091-52e5-9276-ff0ebedc45da','aa65a54c-3dd5-5671-ac9e-b08121338327','b1609c8b-1e26-5d22-98ae-858d50dfa59e','bdf1597a-cc73-5780-b1e2-a65dac75e0f3','be5ed289-d166-51cf-9f32-234da760e43f','c16b107a-675e-5af4-b38d-dba5021fb028','cb60b78a-6155-5414-afc5-da9a56a495ce','cd99d5ce-32fd-556e-a5ed-c1c8d0fdab3d','d5538a33-9b6f-5d4f-9584-f7c84616b2be','d916c129-d801-54ab-83c2-36c62af5ed9e','dbda8254-6e9c-5c5c-b540-9c74609dc555','dd3edb6c-6abd-552f-af74-d31495398c9d','df323722-da08-584a-aef9-7b797355427b','e46cfd9e-9f76-539b-b840-477cc19aee7c','e6966b31-519d-56d9-bf29-8dd2b6b71116') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('038d9781-f417-5c1d-bbe9-277c6f34f8a0', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-0', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', 'cd99d5ce-32fd-556e-a5ed-c1c8d0fdab3d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'cd99d5ce-32fd-556e-a5ed-c1c8d0fdab3d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('038d9781-f417-5c1d-bbe9-277c6f34f8a0', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('038d9781-f417-5c1d-bbe9-277c6f34f8a0', 'cd99d5ce-32fd-556e-a5ed-c1c8d0fdab3d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '038d9781-f417-5c1d-bbe9-277c6f34f8a0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('067510ea-2bd3-51c0-af3e-a658e68b595a', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-1', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', '621c6a14-31f2-5c26-80bc-77624767bd6f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '621c6a14-31f2-5c26-80bc-77624767bd6f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('067510ea-2bd3-51c0-af3e-a658e68b595a', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('067510ea-2bd3-51c0-af3e-a658e68b595a', '621c6a14-31f2-5c26-80bc-77624767bd6f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '067510ea-2bd3-51c0-af3e-a658e68b595a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4eecd609-cea4-54af-a8ff-ba60c3737dd3', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-2', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', 'd916c129-d801-54ab-83c2-36c62af5ed9e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd916c129-d801-54ab-83c2-36c62af5ed9e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4eecd609-cea4-54af-a8ff-ba60c3737dd3', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('4eecd609-cea4-54af-a8ff-ba60c3737dd3', 'd916c129-d801-54ab-83c2-36c62af5ed9e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4eecd609-cea4-54af-a8ff-ba60c3737dd3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('aa96cdf7-d70a-55ef-8332-07014d4b4e29', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-3', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', 'd5538a33-9b6f-5d4f-9584-f7c84616b2be', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd5538a33-9b6f-5d4f-9584-f7c84616b2be';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('aa96cdf7-d70a-55ef-8332-07014d4b4e29', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('aa96cdf7-d70a-55ef-8332-07014d4b4e29', 'd5538a33-9b6f-5d4f-9584-f7c84616b2be', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'aa96cdf7-d70a-55ef-8332-07014d4b4e29';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0a0d51e2-e0c8-56d9-a93f-c8cd670a3fd6', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-4', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', 'aa65a54c-3dd5-5671-ac9e-b08121338327', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'aa65a54c-3dd5-5671-ac9e-b08121338327';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0a0d51e2-e0c8-56d9-a93f-c8cd670a3fd6', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('0a0d51e2-e0c8-56d9-a93f-c8cd670a3fd6', 'aa65a54c-3dd5-5671-ac9e-b08121338327', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0a0d51e2-e0c8-56d9-a93f-c8cd670a3fd6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ea7c9bf5-473c-52e7-8721-1494509c1290', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-5', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', 'dbda8254-6e9c-5c5c-b540-9c74609dc555', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'dbda8254-6e9c-5c5c-b540-9c74609dc555';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ea7c9bf5-473c-52e7-8721-1494509c1290', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('ea7c9bf5-473c-52e7-8721-1494509c1290', 'dbda8254-6e9c-5c5c-b540-9c74609dc555', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ea7c9bf5-473c-52e7-8721-1494509c1290';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a21306e7-882d-516a-8725-1008a6a1474c', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-6', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', 'e46cfd9e-9f76-539b-b840-477cc19aee7c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e46cfd9e-9f76-539b-b840-477cc19aee7c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a21306e7-882d-516a-8725-1008a6a1474c', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('a21306e7-882d-516a-8725-1008a6a1474c', 'e46cfd9e-9f76-539b-b840-477cc19aee7c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a21306e7-882d-516a-8725-1008a6a1474c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4f3cee79-736b-5362-bb15-08839d39d6de', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-7', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', 'be5ed289-d166-51cf-9f32-234da760e43f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'be5ed289-d166-51cf-9f32-234da760e43f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4f3cee79-736b-5362-bb15-08839d39d6de', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('4f3cee79-736b-5362-bb15-08839d39d6de', 'be5ed289-d166-51cf-9f32-234da760e43f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4f3cee79-736b-5362-bb15-08839d39d6de';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e2b59f53-0e7b-5815-8885-e5aa318e11be', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-8', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', '0cca9a87-5519-58c2-8265-c39d6a51a750', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0cca9a87-5519-58c2-8265-c39d6a51a750';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e2b59f53-0e7b-5815-8885-e5aa318e11be', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('e2b59f53-0e7b-5815-8885-e5aa318e11be', '0cca9a87-5519-58c2-8265-c39d6a51a750', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e2b59f53-0e7b-5815-8885-e5aa318e11be';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('20f63f2e-fb94-5020-ad27-505face26925', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-9', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', '1a21fc65-da90-5f70-9085-adb7c7fb4d8b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1a21fc65-da90-5f70-9085-adb7c7fb4d8b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('20f63f2e-fb94-5020-ad27-505face26925', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('20f63f2e-fb94-5020-ad27-505face26925', '1a21fc65-da90-5f70-9085-adb7c7fb4d8b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '20f63f2e-fb94-5020-ad27-505face26925';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9b9b89a0-93b5-5183-b3a3-35159fa0577e', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-10', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', 'b1609c8b-1e26-5d22-98ae-858d50dfa59e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b1609c8b-1e26-5d22-98ae-858d50dfa59e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9b9b89a0-93b5-5183-b3a3-35159fa0577e', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('9b9b89a0-93b5-5183-b3a3-35159fa0577e', 'b1609c8b-1e26-5d22-98ae-858d50dfa59e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9b9b89a0-93b5-5183-b3a3-35159fa0577e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('69c26268-52c4-5792-9dce-ec0d44432a13', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-11', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', 'dd3edb6c-6abd-552f-af74-d31495398c9d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'dd3edb6c-6abd-552f-af74-d31495398c9d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('69c26268-52c4-5792-9dce-ec0d44432a13', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('69c26268-52c4-5792-9dce-ec0d44432a13', 'dd3edb6c-6abd-552f-af74-d31495398c9d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '69c26268-52c4-5792-9dce-ec0d44432a13';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('76deb89b-163f-59a6-aea4-c49e6528d403', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-12', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', '6c3d1cfe-d840-51df-93e7-f52acb410f35', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6c3d1cfe-d840-51df-93e7-f52acb410f35';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('76deb89b-163f-59a6-aea4-c49e6528d403', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('76deb89b-163f-59a6-aea4-c49e6528d403', '6c3d1cfe-d840-51df-93e7-f52acb410f35', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '76deb89b-163f-59a6-aea4-c49e6528d403';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f8466304-e6a7-5244-a88e-00ef849a5d51', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-13', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', 'cb60b78a-6155-5414-afc5-da9a56a495ce', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'cb60b78a-6155-5414-afc5-da9a56a495ce';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f8466304-e6a7-5244-a88e-00ef849a5d51', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('f8466304-e6a7-5244-a88e-00ef849a5d51', 'cb60b78a-6155-5414-afc5-da9a56a495ce', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f8466304-e6a7-5244-a88e-00ef849a5d51';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e8fb7e75-171a-58e4-9975-00bde8dbc7f2', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-14', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', '80649e6d-4091-52e5-9276-ff0ebedc45da', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '80649e6d-4091-52e5-9276-ff0ebedc45da';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e8fb7e75-171a-58e4-9975-00bde8dbc7f2', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('e8fb7e75-171a-58e4-9975-00bde8dbc7f2', '80649e6d-4091-52e5-9276-ff0ebedc45da', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e8fb7e75-171a-58e4-9975-00bde8dbc7f2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f33341e2-5db3-5de9-823a-cce8644916a4', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-15', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', 'c16b107a-675e-5af4-b38d-dba5021fb028', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c16b107a-675e-5af4-b38d-dba5021fb028';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f33341e2-5db3-5de9-823a-cce8644916a4', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('f33341e2-5db3-5de9-823a-cce8644916a4', 'c16b107a-675e-5af4-b38d-dba5021fb028', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f33341e2-5db3-5de9-823a-cce8644916a4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('bfa47860-cb00-549e-b899-69aaf80d973f', 'benchmark-funding-5638cdd6-8ca1-41d0-80e1-1cca69a8f31f-16', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', '2d07a406-2b36-5537-a1b2-089df3cab3f7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2d07a406-2b36-5537-a1b2-089df3cab3f7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('bfa47860-cb00-549e-b899-69aaf80d973f', 'bdf1597a-cc73-5780-b1e2-a65dac75e0f3', -1000000000), ('bfa47860-cb00-549e-b899-69aaf80d973f', '2d07a406-2b36-5537-a1b2-089df3cab3f7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'bfa47860-cb00-549e-b899-69aaf80d973f';
COMMIT;
