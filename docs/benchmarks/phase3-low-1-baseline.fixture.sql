-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('0405a18c-91a1-5991-92d7-6a66b6426733', 'USER', 'ACTIVE', 'FIC'),
('0e5b5bac-42b3-5cd4-bd93-4889eb26100e', 'USER', 'ACTIVE', 'FIC'),
('10af13d9-98c3-5fe8-81df-2bb83c907e35', 'USER', 'ACTIVE', 'FIC'),
('279c51c1-60c8-5eae-934b-d46244d83e84', 'USER', 'ACTIVE', 'FIC'),
('2de3481b-5d49-5415-88d0-4721b160b5fb', 'ISSUANCE', 'ACTIVE', 'FIC'),
('3b721cb9-8793-5032-aa35-d9fcb4ce3443', 'USER', 'ACTIVE', 'FIC'),
('5857f278-a22a-5b12-935d-bd8d9a1bffd8', 'USER', 'ACTIVE', 'FIC'),
('5ae6ce1a-aeb2-58ef-91a5-413f02b0b928', 'USER', 'ACTIVE', 'FIC'),
('5bb76e5e-6e25-5c88-8cde-313b50df7862', 'USER', 'ACTIVE', 'FIC'),
('60aee68b-99b9-53a7-9c74-3193d76f3cab', 'USER', 'ACTIVE', 'FIC'),
('6bccc7a1-259c-52db-9811-e064c07d214b', 'USER', 'ACTIVE', 'FIC'),
('71d46497-a2dd-56d2-b2b7-76ad17bd9389', 'USER', 'ACTIVE', 'FIC'),
('7b226d3f-c680-5d15-9e9a-85b11cf51205', 'USER', 'ACTIVE', 'FIC'),
('7ccf2d9a-c85d-5c51-9c4f-241ae56b8f07', 'USER', 'ACTIVE', 'FIC'),
('8a22846f-5808-5e6c-b023-3b2c5cc38b8a', 'USER', 'ACTIVE', 'FIC'),
('b0e7b794-593b-5da2-96ff-e07166db9249', 'USER', 'ACTIVE', 'FIC'),
('b84e0e96-375f-5958-86f7-25055eb0a906', 'USER', 'ACTIVE', 'FIC'),
('bfd8ed35-54c9-5633-b97f-972945f54ea1', 'USER', 'ACTIVE', 'FIC'),
('c996b48a-0152-596b-8c73-69c067580d3c', 'USER', 'ACTIVE', 'FIC'),
('cb1d99fa-5d7c-5e13-b784-72fa52bddb5e', 'USER', 'ACTIVE', 'FIC'),
('d713f409-9b51-520d-a64c-e6a453c3827a', 'USER', 'ACTIVE', 'FIC'),
('e279741e-5c8d-5355-bf2a-e248469a3d6d', 'USER', 'ACTIVE', 'FIC'),
('eb16f268-2ce1-5c5f-a011-e3ff09055daf', 'USER', 'ACTIVE', 'FIC'),
('fa359722-2933-574d-8ae6-625edc7cb83c', 'USER', 'ACTIVE', 'FIC'),
('fafcd74a-b7a4-5a77-bc14-730ed4e642a0', 'USER', 'ACTIVE', 'FIC'),
('fedc4325-ca52-59c9-9dae-5e2fcd48b7d6', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('0405a18c-91a1-5991-92d7-6a66b6426733', 0),
('0e5b5bac-42b3-5cd4-bd93-4889eb26100e', 0),
('10af13d9-98c3-5fe8-81df-2bb83c907e35', 0),
('279c51c1-60c8-5eae-934b-d46244d83e84', 0),
('2de3481b-5d49-5415-88d0-4721b160b5fb', 0),
('3b721cb9-8793-5032-aa35-d9fcb4ce3443', 0),
('5857f278-a22a-5b12-935d-bd8d9a1bffd8', 0),
('5ae6ce1a-aeb2-58ef-91a5-413f02b0b928', 0),
('5bb76e5e-6e25-5c88-8cde-313b50df7862', 0),
('60aee68b-99b9-53a7-9c74-3193d76f3cab', 0),
('6bccc7a1-259c-52db-9811-e064c07d214b', 0),
('71d46497-a2dd-56d2-b2b7-76ad17bd9389', 0),
('7b226d3f-c680-5d15-9e9a-85b11cf51205', 0),
('7ccf2d9a-c85d-5c51-9c4f-241ae56b8f07', 0),
('8a22846f-5808-5e6c-b023-3b2c5cc38b8a', 0),
('b0e7b794-593b-5da2-96ff-e07166db9249', 0),
('b84e0e96-375f-5958-86f7-25055eb0a906', 0),
('bfd8ed35-54c9-5633-b97f-972945f54ea1', 0),
('c996b48a-0152-596b-8c73-69c067580d3c', 0),
('cb1d99fa-5d7c-5e13-b784-72fa52bddb5e', 0),
('d713f409-9b51-520d-a64c-e6a453c3827a', 0),
('e279741e-5c8d-5355-bf2a-e248469a3d6d', 0),
('eb16f268-2ce1-5c5f-a011-e3ff09055daf', 0),
('fa359722-2933-574d-8ae6-625edc7cb83c', 0),
('fafcd74a-b7a4-5a77-bc14-730ed4e642a0', 0),
('fedc4325-ca52-59c9-9dae-5e2fcd48b7d6', 0);
SELECT account_id FROM balances WHERE account_id IN ('0405a18c-91a1-5991-92d7-6a66b6426733','0e5b5bac-42b3-5cd4-bd93-4889eb26100e','10af13d9-98c3-5fe8-81df-2bb83c907e35','279c51c1-60c8-5eae-934b-d46244d83e84','2de3481b-5d49-5415-88d0-4721b160b5fb','3b721cb9-8793-5032-aa35-d9fcb4ce3443','5857f278-a22a-5b12-935d-bd8d9a1bffd8','5ae6ce1a-aeb2-58ef-91a5-413f02b0b928','5bb76e5e-6e25-5c88-8cde-313b50df7862','60aee68b-99b9-53a7-9c74-3193d76f3cab','6bccc7a1-259c-52db-9811-e064c07d214b','71d46497-a2dd-56d2-b2b7-76ad17bd9389','7b226d3f-c680-5d15-9e9a-85b11cf51205','7ccf2d9a-c85d-5c51-9c4f-241ae56b8f07','8a22846f-5808-5e6c-b023-3b2c5cc38b8a','b0e7b794-593b-5da2-96ff-e07166db9249','b84e0e96-375f-5958-86f7-25055eb0a906','bfd8ed35-54c9-5633-b97f-972945f54ea1','c996b48a-0152-596b-8c73-69c067580d3c','cb1d99fa-5d7c-5e13-b784-72fa52bddb5e','d713f409-9b51-520d-a64c-e6a453c3827a','e279741e-5c8d-5355-bf2a-e248469a3d6d','eb16f268-2ce1-5c5f-a011-e3ff09055daf','fa359722-2933-574d-8ae6-625edc7cb83c','fafcd74a-b7a4-5a77-bc14-730ed4e642a0','fedc4325-ca52-59c9-9dae-5e2fcd48b7d6') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('cc41f9a0-cfbd-590d-84ef-caf262f38ff9', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-0', '2de3481b-5d49-5415-88d0-4721b160b5fb', 'c996b48a-0152-596b-8c73-69c067580d3c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c996b48a-0152-596b-8c73-69c067580d3c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('cc41f9a0-cfbd-590d-84ef-caf262f38ff9', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('cc41f9a0-cfbd-590d-84ef-caf262f38ff9', 'c996b48a-0152-596b-8c73-69c067580d3c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'cc41f9a0-cfbd-590d-84ef-caf262f38ff9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b6ff22e5-6b15-5cea-af98-4bd647d3d053', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-1', '2de3481b-5d49-5415-88d0-4721b160b5fb', 'b0e7b794-593b-5da2-96ff-e07166db9249', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b0e7b794-593b-5da2-96ff-e07166db9249';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b6ff22e5-6b15-5cea-af98-4bd647d3d053', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('b6ff22e5-6b15-5cea-af98-4bd647d3d053', 'b0e7b794-593b-5da2-96ff-e07166db9249', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b6ff22e5-6b15-5cea-af98-4bd647d3d053';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f3475175-2fe2-5a73-9889-39d4d46491f5', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-2', '2de3481b-5d49-5415-88d0-4721b160b5fb', '5ae6ce1a-aeb2-58ef-91a5-413f02b0b928', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5ae6ce1a-aeb2-58ef-91a5-413f02b0b928';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f3475175-2fe2-5a73-9889-39d4d46491f5', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('f3475175-2fe2-5a73-9889-39d4d46491f5', '5ae6ce1a-aeb2-58ef-91a5-413f02b0b928', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f3475175-2fe2-5a73-9889-39d4d46491f5';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f67d12ad-d08d-5761-94ea-9ece84a54ee2', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-3', '2de3481b-5d49-5415-88d0-4721b160b5fb', '3b721cb9-8793-5032-aa35-d9fcb4ce3443', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3b721cb9-8793-5032-aa35-d9fcb4ce3443';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f67d12ad-d08d-5761-94ea-9ece84a54ee2', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('f67d12ad-d08d-5761-94ea-9ece84a54ee2', '3b721cb9-8793-5032-aa35-d9fcb4ce3443', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f67d12ad-d08d-5761-94ea-9ece84a54ee2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('adaa0ee9-abbc-5131-9ba7-ccd3d27d9300', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-4', '2de3481b-5d49-5415-88d0-4721b160b5fb', '60aee68b-99b9-53a7-9c74-3193d76f3cab', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '60aee68b-99b9-53a7-9c74-3193d76f3cab';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('adaa0ee9-abbc-5131-9ba7-ccd3d27d9300', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('adaa0ee9-abbc-5131-9ba7-ccd3d27d9300', '60aee68b-99b9-53a7-9c74-3193d76f3cab', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'adaa0ee9-abbc-5131-9ba7-ccd3d27d9300';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('57d6e14f-4d51-5194-a189-8b89ef76e30a', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-5', '2de3481b-5d49-5415-88d0-4721b160b5fb', '5bb76e5e-6e25-5c88-8cde-313b50df7862', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5bb76e5e-6e25-5c88-8cde-313b50df7862';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('57d6e14f-4d51-5194-a189-8b89ef76e30a', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('57d6e14f-4d51-5194-a189-8b89ef76e30a', '5bb76e5e-6e25-5c88-8cde-313b50df7862', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '57d6e14f-4d51-5194-a189-8b89ef76e30a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('472c5716-dbea-54fa-a3a5-f9922f2b75ae', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-6', '2de3481b-5d49-5415-88d0-4721b160b5fb', '10af13d9-98c3-5fe8-81df-2bb83c907e35', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '10af13d9-98c3-5fe8-81df-2bb83c907e35';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('472c5716-dbea-54fa-a3a5-f9922f2b75ae', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('472c5716-dbea-54fa-a3a5-f9922f2b75ae', '10af13d9-98c3-5fe8-81df-2bb83c907e35', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '472c5716-dbea-54fa-a3a5-f9922f2b75ae';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('bd46564f-fb87-54a6-86cb-a3ed0180c370', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-7', '2de3481b-5d49-5415-88d0-4721b160b5fb', 'fafcd74a-b7a4-5a77-bc14-730ed4e642a0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fafcd74a-b7a4-5a77-bc14-730ed4e642a0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('bd46564f-fb87-54a6-86cb-a3ed0180c370', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('bd46564f-fb87-54a6-86cb-a3ed0180c370', 'fafcd74a-b7a4-5a77-bc14-730ed4e642a0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'bd46564f-fb87-54a6-86cb-a3ed0180c370';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5a411960-731d-51ce-a20d-af0111e4ae55', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-8', '2de3481b-5d49-5415-88d0-4721b160b5fb', '0405a18c-91a1-5991-92d7-6a66b6426733', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0405a18c-91a1-5991-92d7-6a66b6426733';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5a411960-731d-51ce-a20d-af0111e4ae55', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('5a411960-731d-51ce-a20d-af0111e4ae55', '0405a18c-91a1-5991-92d7-6a66b6426733', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5a411960-731d-51ce-a20d-af0111e4ae55';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0702ea7a-569a-5378-b76b-8bd9bd2c5aee', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-9', '2de3481b-5d49-5415-88d0-4721b160b5fb', '7b226d3f-c680-5d15-9e9a-85b11cf51205', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7b226d3f-c680-5d15-9e9a-85b11cf51205';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0702ea7a-569a-5378-b76b-8bd9bd2c5aee', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('0702ea7a-569a-5378-b76b-8bd9bd2c5aee', '7b226d3f-c680-5d15-9e9a-85b11cf51205', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0702ea7a-569a-5378-b76b-8bd9bd2c5aee';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('65887745-0ad7-5b9f-82d0-75a36eead749', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-10', '2de3481b-5d49-5415-88d0-4721b160b5fb', 'fa359722-2933-574d-8ae6-625edc7cb83c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fa359722-2933-574d-8ae6-625edc7cb83c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('65887745-0ad7-5b9f-82d0-75a36eead749', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('65887745-0ad7-5b9f-82d0-75a36eead749', 'fa359722-2933-574d-8ae6-625edc7cb83c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '65887745-0ad7-5b9f-82d0-75a36eead749';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('965576e5-47bd-5ecb-bfa8-666c2ddd0ebf', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-11', '2de3481b-5d49-5415-88d0-4721b160b5fb', '0e5b5bac-42b3-5cd4-bd93-4889eb26100e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0e5b5bac-42b3-5cd4-bd93-4889eb26100e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('965576e5-47bd-5ecb-bfa8-666c2ddd0ebf', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('965576e5-47bd-5ecb-bfa8-666c2ddd0ebf', '0e5b5bac-42b3-5cd4-bd93-4889eb26100e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '965576e5-47bd-5ecb-bfa8-666c2ddd0ebf';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ce5af444-c670-5165-8a56-10498c1680e1', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-12', '2de3481b-5d49-5415-88d0-4721b160b5fb', 'fedc4325-ca52-59c9-9dae-5e2fcd48b7d6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fedc4325-ca52-59c9-9dae-5e2fcd48b7d6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ce5af444-c670-5165-8a56-10498c1680e1', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('ce5af444-c670-5165-8a56-10498c1680e1', 'fedc4325-ca52-59c9-9dae-5e2fcd48b7d6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ce5af444-c670-5165-8a56-10498c1680e1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6d408f66-7d26-5bd3-b16f-b8e773d06255', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-13', '2de3481b-5d49-5415-88d0-4721b160b5fb', 'cb1d99fa-5d7c-5e13-b784-72fa52bddb5e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'cb1d99fa-5d7c-5e13-b784-72fa52bddb5e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6d408f66-7d26-5bd3-b16f-b8e773d06255', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('6d408f66-7d26-5bd3-b16f-b8e773d06255', 'cb1d99fa-5d7c-5e13-b784-72fa52bddb5e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6d408f66-7d26-5bd3-b16f-b8e773d06255';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a1267093-8733-5a9c-8f9d-9107cedc700b', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-14', '2de3481b-5d49-5415-88d0-4721b160b5fb', '5857f278-a22a-5b12-935d-bd8d9a1bffd8', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5857f278-a22a-5b12-935d-bd8d9a1bffd8';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a1267093-8733-5a9c-8f9d-9107cedc700b', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('a1267093-8733-5a9c-8f9d-9107cedc700b', '5857f278-a22a-5b12-935d-bd8d9a1bffd8', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a1267093-8733-5a9c-8f9d-9107cedc700b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('91d9709a-9d40-5d7a-97d6-fc781f216597', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-15', '2de3481b-5d49-5415-88d0-4721b160b5fb', '279c51c1-60c8-5eae-934b-d46244d83e84', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '279c51c1-60c8-5eae-934b-d46244d83e84';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('91d9709a-9d40-5d7a-97d6-fc781f216597', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('91d9709a-9d40-5d7a-97d6-fc781f216597', '279c51c1-60c8-5eae-934b-d46244d83e84', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '91d9709a-9d40-5d7a-97d6-fc781f216597';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('91eb8efa-2244-5d5a-910d-329d37dd52d5', 'benchmark-funding-6a18f3f4-8569-418c-96d5-dcba8fd45e09-16', '2de3481b-5d49-5415-88d0-4721b160b5fb', '6bccc7a1-259c-52db-9811-e064c07d214b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2de3481b-5d49-5415-88d0-4721b160b5fb';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6bccc7a1-259c-52db-9811-e064c07d214b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('91eb8efa-2244-5d5a-910d-329d37dd52d5', '2de3481b-5d49-5415-88d0-4721b160b5fb', -1000000000), ('91eb8efa-2244-5d5a-910d-329d37dd52d5', '6bccc7a1-259c-52db-9811-e064c07d214b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '91eb8efa-2244-5d5a-910d-329d37dd52d5';
COMMIT;
