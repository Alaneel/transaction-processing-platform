-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('0082b89c-7b1d-533c-b40b-ecf06b0ad16d', 'USER', 'ACTIVE', 'FIC'),
('014db50f-3a83-548b-90c4-5d1d4ac563a1', 'USER', 'ACTIVE', 'FIC'),
('14580a3f-b0b7-526a-aeed-c13d471d6ad5', 'USER', 'ACTIVE', 'FIC'),
('2205206a-cd22-5fcd-94c8-dca754ac1e9e', 'USER', 'ACTIVE', 'FIC'),
('23a8b578-01bf-50ed-8cef-62290a83b7a3', 'USER', 'ACTIVE', 'FIC'),
('2b8aa6a7-6339-5eb4-aaca-833c547851b6', 'USER', 'ACTIVE', 'FIC'),
('2d985aca-a871-58ed-a11c-8199609de3cf', 'USER', 'ACTIVE', 'FIC'),
('349672cf-ce64-5c77-9ee2-926ecb1f52cc', 'USER', 'ACTIVE', 'FIC'),
('4b4a2bfe-f9d6-5835-83de-07afc40406e0', 'USER', 'ACTIVE', 'FIC'),
('4fe423e9-449d-54f6-ac6a-2ea8ef700234', 'USER', 'ACTIVE', 'FIC'),
('60726455-c816-5878-a6ac-797fb702ffea', 'USER', 'ACTIVE', 'FIC'),
('631b9d8c-946e-525a-b6ba-27699f61246d', 'USER', 'ACTIVE', 'FIC'),
('6c1157e2-77b3-5fa4-b30b-ed3fe5ad4d06', 'USER', 'ACTIVE', 'FIC'),
('7c648bdd-6bfb-5121-867d-6f24a85472c3', 'USER', 'ACTIVE', 'FIC'),
('82ad394c-bba1-518c-9200-9fc6ca97859b', 'USER', 'ACTIVE', 'FIC'),
('8630ee7b-a671-577c-8c46-95da800dfaac', 'USER', 'ACTIVE', 'FIC'),
('87b09e3c-30f5-5a34-84a6-3b9ecbf2dcac', 'USER', 'ACTIVE', 'FIC'),
('8b5a09d2-b457-5e89-8e76-3002f8d98f01', 'USER', 'ACTIVE', 'FIC'),
('8cf6b51b-b868-58aa-a73f-f93b652aa2a7', 'USER', 'ACTIVE', 'FIC'),
('8f098187-d374-5bed-89d5-7ce6f65d7dc4', 'USER', 'ACTIVE', 'FIC'),
('9fc1723c-bcf7-5116-8ca3-b3a9bd46cf37', 'USER', 'ACTIVE', 'FIC'),
('adaa96d3-f93a-54a8-864e-f871bce5a748', 'USER', 'ACTIVE', 'FIC'),
('c61b540d-2a97-5020-baad-047ff8b986d8', 'USER', 'ACTIVE', 'FIC'),
('ddda3f25-3095-55bd-a02d-c2413d37c5be', 'ISSUANCE', 'ACTIVE', 'FIC'),
('dea5e26e-cc3f-5802-802f-56ef73a2cbaf', 'USER', 'ACTIVE', 'FIC'),
('ef74c2bc-bfaf-51e1-a4bc-e8f6e62ac2d7', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('0082b89c-7b1d-533c-b40b-ecf06b0ad16d', 0),
('014db50f-3a83-548b-90c4-5d1d4ac563a1', 0),
('14580a3f-b0b7-526a-aeed-c13d471d6ad5', 0),
('2205206a-cd22-5fcd-94c8-dca754ac1e9e', 0),
('23a8b578-01bf-50ed-8cef-62290a83b7a3', 0),
('2b8aa6a7-6339-5eb4-aaca-833c547851b6', 0),
('2d985aca-a871-58ed-a11c-8199609de3cf', 0),
('349672cf-ce64-5c77-9ee2-926ecb1f52cc', 0),
('4b4a2bfe-f9d6-5835-83de-07afc40406e0', 0),
('4fe423e9-449d-54f6-ac6a-2ea8ef700234', 0),
('60726455-c816-5878-a6ac-797fb702ffea', 0),
('631b9d8c-946e-525a-b6ba-27699f61246d', 0),
('6c1157e2-77b3-5fa4-b30b-ed3fe5ad4d06', 0),
('7c648bdd-6bfb-5121-867d-6f24a85472c3', 0),
('82ad394c-bba1-518c-9200-9fc6ca97859b', 0),
('8630ee7b-a671-577c-8c46-95da800dfaac', 0),
('87b09e3c-30f5-5a34-84a6-3b9ecbf2dcac', 0),
('8b5a09d2-b457-5e89-8e76-3002f8d98f01', 0),
('8cf6b51b-b868-58aa-a73f-f93b652aa2a7', 0),
('8f098187-d374-5bed-89d5-7ce6f65d7dc4', 0),
('9fc1723c-bcf7-5116-8ca3-b3a9bd46cf37', 0),
('adaa96d3-f93a-54a8-864e-f871bce5a748', 0),
('c61b540d-2a97-5020-baad-047ff8b986d8', 0),
('ddda3f25-3095-55bd-a02d-c2413d37c5be', 0),
('dea5e26e-cc3f-5802-802f-56ef73a2cbaf', 0),
('ef74c2bc-bfaf-51e1-a4bc-e8f6e62ac2d7', 0);
SELECT account_id FROM balances WHERE account_id IN ('0082b89c-7b1d-533c-b40b-ecf06b0ad16d','014db50f-3a83-548b-90c4-5d1d4ac563a1','14580a3f-b0b7-526a-aeed-c13d471d6ad5','2205206a-cd22-5fcd-94c8-dca754ac1e9e','23a8b578-01bf-50ed-8cef-62290a83b7a3','2b8aa6a7-6339-5eb4-aaca-833c547851b6','2d985aca-a871-58ed-a11c-8199609de3cf','349672cf-ce64-5c77-9ee2-926ecb1f52cc','4b4a2bfe-f9d6-5835-83de-07afc40406e0','4fe423e9-449d-54f6-ac6a-2ea8ef700234','60726455-c816-5878-a6ac-797fb702ffea','631b9d8c-946e-525a-b6ba-27699f61246d','6c1157e2-77b3-5fa4-b30b-ed3fe5ad4d06','7c648bdd-6bfb-5121-867d-6f24a85472c3','82ad394c-bba1-518c-9200-9fc6ca97859b','8630ee7b-a671-577c-8c46-95da800dfaac','87b09e3c-30f5-5a34-84a6-3b9ecbf2dcac','8b5a09d2-b457-5e89-8e76-3002f8d98f01','8cf6b51b-b868-58aa-a73f-f93b652aa2a7','8f098187-d374-5bed-89d5-7ce6f65d7dc4','9fc1723c-bcf7-5116-8ca3-b3a9bd46cf37','adaa96d3-f93a-54a8-864e-f871bce5a748','c61b540d-2a97-5020-baad-047ff8b986d8','ddda3f25-3095-55bd-a02d-c2413d37c5be','dea5e26e-cc3f-5802-802f-56ef73a2cbaf','ef74c2bc-bfaf-51e1-a4bc-e8f6e62ac2d7') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b82fdbc3-ec9f-5bf8-a461-e9028ec069f9', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-0', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', '6c1157e2-77b3-5fa4-b30b-ed3fe5ad4d06', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6c1157e2-77b3-5fa4-b30b-ed3fe5ad4d06';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b82fdbc3-ec9f-5bf8-a461-e9028ec069f9', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('b82fdbc3-ec9f-5bf8-a461-e9028ec069f9', '6c1157e2-77b3-5fa4-b30b-ed3fe5ad4d06', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b82fdbc3-ec9f-5bf8-a461-e9028ec069f9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('02b55365-0b68-5ea5-84d9-4b2dd2a35ee6', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-1', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', '2205206a-cd22-5fcd-94c8-dca754ac1e9e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2205206a-cd22-5fcd-94c8-dca754ac1e9e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('02b55365-0b68-5ea5-84d9-4b2dd2a35ee6', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('02b55365-0b68-5ea5-84d9-4b2dd2a35ee6', '2205206a-cd22-5fcd-94c8-dca754ac1e9e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '02b55365-0b68-5ea5-84d9-4b2dd2a35ee6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('49e62062-0bb1-5335-b9f7-d95e35557b90', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-2', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', '014db50f-3a83-548b-90c4-5d1d4ac563a1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '014db50f-3a83-548b-90c4-5d1d4ac563a1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('49e62062-0bb1-5335-b9f7-d95e35557b90', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('49e62062-0bb1-5335-b9f7-d95e35557b90', '014db50f-3a83-548b-90c4-5d1d4ac563a1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '49e62062-0bb1-5335-b9f7-d95e35557b90';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b4a1bfa3-be00-57e9-bbb0-772a4bff87e1', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-3', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', '23a8b578-01bf-50ed-8cef-62290a83b7a3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '23a8b578-01bf-50ed-8cef-62290a83b7a3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b4a1bfa3-be00-57e9-bbb0-772a4bff87e1', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('b4a1bfa3-be00-57e9-bbb0-772a4bff87e1', '23a8b578-01bf-50ed-8cef-62290a83b7a3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b4a1bfa3-be00-57e9-bbb0-772a4bff87e1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7e6f4301-3039-530e-bb72-880d84e28204', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-4', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', '8630ee7b-a671-577c-8c46-95da800dfaac', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8630ee7b-a671-577c-8c46-95da800dfaac';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7e6f4301-3039-530e-bb72-880d84e28204', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('7e6f4301-3039-530e-bb72-880d84e28204', '8630ee7b-a671-577c-8c46-95da800dfaac', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7e6f4301-3039-530e-bb72-880d84e28204';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5d27995b-0545-54ed-832f-effbf96fb4d9', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-5', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', 'ef74c2bc-bfaf-51e1-a4bc-e8f6e62ac2d7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ef74c2bc-bfaf-51e1-a4bc-e8f6e62ac2d7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5d27995b-0545-54ed-832f-effbf96fb4d9', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('5d27995b-0545-54ed-832f-effbf96fb4d9', 'ef74c2bc-bfaf-51e1-a4bc-e8f6e62ac2d7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5d27995b-0545-54ed-832f-effbf96fb4d9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6c170433-c48b-5626-85bb-38bd86e5f9b1', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-6', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', '0082b89c-7b1d-533c-b40b-ecf06b0ad16d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0082b89c-7b1d-533c-b40b-ecf06b0ad16d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6c170433-c48b-5626-85bb-38bd86e5f9b1', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('6c170433-c48b-5626-85bb-38bd86e5f9b1', '0082b89c-7b1d-533c-b40b-ecf06b0ad16d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6c170433-c48b-5626-85bb-38bd86e5f9b1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('58b6b8b7-673b-5c03-968b-fb669734aac8', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-7', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', '14580a3f-b0b7-526a-aeed-c13d471d6ad5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '14580a3f-b0b7-526a-aeed-c13d471d6ad5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('58b6b8b7-673b-5c03-968b-fb669734aac8', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('58b6b8b7-673b-5c03-968b-fb669734aac8', '14580a3f-b0b7-526a-aeed-c13d471d6ad5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '58b6b8b7-673b-5c03-968b-fb669734aac8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b2d908f6-f3b8-56f9-90a7-d3affb7dc43d', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-8', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', '4fe423e9-449d-54f6-ac6a-2ea8ef700234', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4fe423e9-449d-54f6-ac6a-2ea8ef700234';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b2d908f6-f3b8-56f9-90a7-d3affb7dc43d', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('b2d908f6-f3b8-56f9-90a7-d3affb7dc43d', '4fe423e9-449d-54f6-ac6a-2ea8ef700234', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b2d908f6-f3b8-56f9-90a7-d3affb7dc43d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d53d9af4-cb3f-50b8-8729-16b4b7f152ac', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-9', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', '349672cf-ce64-5c77-9ee2-926ecb1f52cc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '349672cf-ce64-5c77-9ee2-926ecb1f52cc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d53d9af4-cb3f-50b8-8729-16b4b7f152ac', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('d53d9af4-cb3f-50b8-8729-16b4b7f152ac', '349672cf-ce64-5c77-9ee2-926ecb1f52cc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd53d9af4-cb3f-50b8-8729-16b4b7f152ac';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('05c3d80f-7335-5451-ba21-bcf3b39d20e7', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-10', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', '631b9d8c-946e-525a-b6ba-27699f61246d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '631b9d8c-946e-525a-b6ba-27699f61246d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('05c3d80f-7335-5451-ba21-bcf3b39d20e7', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('05c3d80f-7335-5451-ba21-bcf3b39d20e7', '631b9d8c-946e-525a-b6ba-27699f61246d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '05c3d80f-7335-5451-ba21-bcf3b39d20e7';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b43296a1-6be4-548a-ad93-519a62fc9012', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-11', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', '8f098187-d374-5bed-89d5-7ce6f65d7dc4', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8f098187-d374-5bed-89d5-7ce6f65d7dc4';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b43296a1-6be4-548a-ad93-519a62fc9012', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('b43296a1-6be4-548a-ad93-519a62fc9012', '8f098187-d374-5bed-89d5-7ce6f65d7dc4', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b43296a1-6be4-548a-ad93-519a62fc9012';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('67a6806f-0e94-5f4c-b35a-2b966c0927f5', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-12', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', '87b09e3c-30f5-5a34-84a6-3b9ecbf2dcac', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '87b09e3c-30f5-5a34-84a6-3b9ecbf2dcac';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('67a6806f-0e94-5f4c-b35a-2b966c0927f5', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('67a6806f-0e94-5f4c-b35a-2b966c0927f5', '87b09e3c-30f5-5a34-84a6-3b9ecbf2dcac', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '67a6806f-0e94-5f4c-b35a-2b966c0927f5';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7ae8e35e-1113-5566-a4c3-69ac3659f605', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-13', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', 'c61b540d-2a97-5020-baad-047ff8b986d8', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c61b540d-2a97-5020-baad-047ff8b986d8';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7ae8e35e-1113-5566-a4c3-69ac3659f605', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('7ae8e35e-1113-5566-a4c3-69ac3659f605', 'c61b540d-2a97-5020-baad-047ff8b986d8', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7ae8e35e-1113-5566-a4c3-69ac3659f605';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d46f3a67-ecea-52aa-87b8-893b5e466f3c', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-14', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', '8b5a09d2-b457-5e89-8e76-3002f8d98f01', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8b5a09d2-b457-5e89-8e76-3002f8d98f01';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d46f3a67-ecea-52aa-87b8-893b5e466f3c', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('d46f3a67-ecea-52aa-87b8-893b5e466f3c', '8b5a09d2-b457-5e89-8e76-3002f8d98f01', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd46f3a67-ecea-52aa-87b8-893b5e466f3c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('dd503472-932c-5cdc-b153-4e8ef7dbd289', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-15', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', '2d985aca-a871-58ed-a11c-8199609de3cf', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2d985aca-a871-58ed-a11c-8199609de3cf';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('dd503472-932c-5cdc-b153-4e8ef7dbd289', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('dd503472-932c-5cdc-b153-4e8ef7dbd289', '2d985aca-a871-58ed-a11c-8199609de3cf', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'dd503472-932c-5cdc-b153-4e8ef7dbd289';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a171b57c-ee64-57ba-bd17-ec15f29961b7', 'benchmark-funding-0029ae65-0ba6-4ca2-9730-6f2da5564d2f-16', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', 'adaa96d3-f93a-54a8-864e-f871bce5a748', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ddda3f25-3095-55bd-a02d-c2413d37c5be';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'adaa96d3-f93a-54a8-864e-f871bce5a748';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a171b57c-ee64-57ba-bd17-ec15f29961b7', 'ddda3f25-3095-55bd-a02d-c2413d37c5be', -1000000000), ('a171b57c-ee64-57ba-bd17-ec15f29961b7', 'adaa96d3-f93a-54a8-864e-f871bce5a748', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a171b57c-ee64-57ba-bd17-ec15f29961b7';
COMMIT;
