-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('03b04056-9781-5330-ab83-aff865366369', 'USER', 'ACTIVE', 'FIC'),
('100df4f3-7854-5d15-8415-729e28e1d694', 'USER', 'ACTIVE', 'FIC'),
('294f3497-dec5-5a3b-aedc-668229c39fff', 'USER', 'ACTIVE', 'FIC'),
('4a7b4ded-b854-5c9a-afad-da3b7d96ebe6', 'USER', 'ACTIVE', 'FIC'),
('4d5fa488-315b-5786-96ba-630dbc326090', 'USER', 'ACTIVE', 'FIC'),
('581eb4b6-8686-597d-b2f4-0c2e59d5b229', 'USER', 'ACTIVE', 'FIC'),
('60cbd3ea-558b-5c15-9e54-0f1d1b7cf27e', 'USER', 'ACTIVE', 'FIC'),
('6a162c42-371f-5f8c-8c09-9601bd3dfc44', 'USER', 'ACTIVE', 'FIC'),
('6afce509-b465-5302-a626-496d197435b0', 'ISSUANCE', 'ACTIVE', 'FIC'),
('70c585af-4904-565c-b2cb-04e31b5321f6', 'USER', 'ACTIVE', 'FIC'),
('772ebad5-1d8f-5600-bbc3-28d6d3c53c49', 'USER', 'ACTIVE', 'FIC'),
('7cf7ad9b-1f88-5556-8aa5-824cdd8d958b', 'USER', 'ACTIVE', 'FIC'),
('85d703fe-d77f-5f32-b7b3-ea2265e6929b', 'USER', 'ACTIVE', 'FIC'),
('8852a95a-66be-5769-acb3-d3984ec6b0a8', 'USER', 'ACTIVE', 'FIC'),
('9208060a-b4e2-52d9-b61a-78921dd79836', 'USER', 'ACTIVE', 'FIC'),
('92bf8557-25a9-5576-9a54-3932ff8597ad', 'USER', 'ACTIVE', 'FIC'),
('9d3dd88a-0e36-5e86-b477-e14aa2b49b1f', 'USER', 'ACTIVE', 'FIC'),
('b7ad679f-a529-5df3-89f8-a1392cd0e2e5', 'USER', 'ACTIVE', 'FIC'),
('bce16286-17ca-512f-b5af-60669957503e', 'USER', 'ACTIVE', 'FIC'),
('c2e30779-0075-503e-b623-b742c4795fb8', 'USER', 'ACTIVE', 'FIC'),
('ccd76c56-244c-5486-8665-c5f785e7aade', 'USER', 'ACTIVE', 'FIC'),
('cebb4ac5-a2ed-5bab-a3c6-693576174d81', 'USER', 'ACTIVE', 'FIC'),
('e0a0a1ff-ed4c-5431-8237-7073a8a72fd1', 'USER', 'ACTIVE', 'FIC'),
('e4eb7511-bf8d-54ae-9b05-653580a0533c', 'USER', 'ACTIVE', 'FIC'),
('f630d9a6-989f-5b9c-998e-b94e11b5d9be', 'USER', 'ACTIVE', 'FIC'),
('fe9d4062-f37e-5ace-ac36-9d5c6e882c41', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('03b04056-9781-5330-ab83-aff865366369', 0),
('100df4f3-7854-5d15-8415-729e28e1d694', 0),
('294f3497-dec5-5a3b-aedc-668229c39fff', 0),
('4a7b4ded-b854-5c9a-afad-da3b7d96ebe6', 0),
('4d5fa488-315b-5786-96ba-630dbc326090', 0),
('581eb4b6-8686-597d-b2f4-0c2e59d5b229', 0),
('60cbd3ea-558b-5c15-9e54-0f1d1b7cf27e', 0),
('6a162c42-371f-5f8c-8c09-9601bd3dfc44', 0),
('6afce509-b465-5302-a626-496d197435b0', 0),
('70c585af-4904-565c-b2cb-04e31b5321f6', 0),
('772ebad5-1d8f-5600-bbc3-28d6d3c53c49', 0),
('7cf7ad9b-1f88-5556-8aa5-824cdd8d958b', 0),
('85d703fe-d77f-5f32-b7b3-ea2265e6929b', 0),
('8852a95a-66be-5769-acb3-d3984ec6b0a8', 0),
('9208060a-b4e2-52d9-b61a-78921dd79836', 0),
('92bf8557-25a9-5576-9a54-3932ff8597ad', 0),
('9d3dd88a-0e36-5e86-b477-e14aa2b49b1f', 0),
('b7ad679f-a529-5df3-89f8-a1392cd0e2e5', 0),
('bce16286-17ca-512f-b5af-60669957503e', 0),
('c2e30779-0075-503e-b623-b742c4795fb8', 0),
('ccd76c56-244c-5486-8665-c5f785e7aade', 0),
('cebb4ac5-a2ed-5bab-a3c6-693576174d81', 0),
('e0a0a1ff-ed4c-5431-8237-7073a8a72fd1', 0),
('e4eb7511-bf8d-54ae-9b05-653580a0533c', 0),
('f630d9a6-989f-5b9c-998e-b94e11b5d9be', 0),
('fe9d4062-f37e-5ace-ac36-9d5c6e882c41', 0);
SELECT account_id FROM balances WHERE account_id IN ('03b04056-9781-5330-ab83-aff865366369','100df4f3-7854-5d15-8415-729e28e1d694','294f3497-dec5-5a3b-aedc-668229c39fff','4a7b4ded-b854-5c9a-afad-da3b7d96ebe6','4d5fa488-315b-5786-96ba-630dbc326090','581eb4b6-8686-597d-b2f4-0c2e59d5b229','60cbd3ea-558b-5c15-9e54-0f1d1b7cf27e','6a162c42-371f-5f8c-8c09-9601bd3dfc44','6afce509-b465-5302-a626-496d197435b0','70c585af-4904-565c-b2cb-04e31b5321f6','772ebad5-1d8f-5600-bbc3-28d6d3c53c49','7cf7ad9b-1f88-5556-8aa5-824cdd8d958b','85d703fe-d77f-5f32-b7b3-ea2265e6929b','8852a95a-66be-5769-acb3-d3984ec6b0a8','9208060a-b4e2-52d9-b61a-78921dd79836','92bf8557-25a9-5576-9a54-3932ff8597ad','9d3dd88a-0e36-5e86-b477-e14aa2b49b1f','b7ad679f-a529-5df3-89f8-a1392cd0e2e5','bce16286-17ca-512f-b5af-60669957503e','c2e30779-0075-503e-b623-b742c4795fb8','ccd76c56-244c-5486-8665-c5f785e7aade','cebb4ac5-a2ed-5bab-a3c6-693576174d81','e0a0a1ff-ed4c-5431-8237-7073a8a72fd1','e4eb7511-bf8d-54ae-9b05-653580a0533c','f630d9a6-989f-5b9c-998e-b94e11b5d9be','fe9d4062-f37e-5ace-ac36-9d5c6e882c41') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('65b4a15a-136e-5ef8-81e6-2230605cd7b1', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-0', '6afce509-b465-5302-a626-496d197435b0', 'fe9d4062-f37e-5ace-ac36-9d5c6e882c41', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fe9d4062-f37e-5ace-ac36-9d5c6e882c41';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('65b4a15a-136e-5ef8-81e6-2230605cd7b1', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('65b4a15a-136e-5ef8-81e6-2230605cd7b1', 'fe9d4062-f37e-5ace-ac36-9d5c6e882c41', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '65b4a15a-136e-5ef8-81e6-2230605cd7b1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('2fbf60ab-de73-57fd-b8c6-e74f7d83a10e', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-1', '6afce509-b465-5302-a626-496d197435b0', '7cf7ad9b-1f88-5556-8aa5-824cdd8d958b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7cf7ad9b-1f88-5556-8aa5-824cdd8d958b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('2fbf60ab-de73-57fd-b8c6-e74f7d83a10e', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('2fbf60ab-de73-57fd-b8c6-e74f7d83a10e', '7cf7ad9b-1f88-5556-8aa5-824cdd8d958b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '2fbf60ab-de73-57fd-b8c6-e74f7d83a10e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('627de686-13e0-5eda-a964-a7203a5c87dd', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-2', '6afce509-b465-5302-a626-496d197435b0', '9d3dd88a-0e36-5e86-b477-e14aa2b49b1f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9d3dd88a-0e36-5e86-b477-e14aa2b49b1f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('627de686-13e0-5eda-a964-a7203a5c87dd', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('627de686-13e0-5eda-a964-a7203a5c87dd', '9d3dd88a-0e36-5e86-b477-e14aa2b49b1f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '627de686-13e0-5eda-a964-a7203a5c87dd';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3379f377-d3e4-59dc-be63-c84a67fcd02d', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-3', '6afce509-b465-5302-a626-496d197435b0', '92bf8557-25a9-5576-9a54-3932ff8597ad', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '92bf8557-25a9-5576-9a54-3932ff8597ad';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3379f377-d3e4-59dc-be63-c84a67fcd02d', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('3379f377-d3e4-59dc-be63-c84a67fcd02d', '92bf8557-25a9-5576-9a54-3932ff8597ad', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3379f377-d3e4-59dc-be63-c84a67fcd02d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('91d425ba-0cf9-5a21-bda1-8c4866cc337f', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-4', '6afce509-b465-5302-a626-496d197435b0', 'bce16286-17ca-512f-b5af-60669957503e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'bce16286-17ca-512f-b5af-60669957503e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('91d425ba-0cf9-5a21-bda1-8c4866cc337f', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('91d425ba-0cf9-5a21-bda1-8c4866cc337f', 'bce16286-17ca-512f-b5af-60669957503e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '91d425ba-0cf9-5a21-bda1-8c4866cc337f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('bef358b1-7b21-5590-b5fd-16799f763508', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-5', '6afce509-b465-5302-a626-496d197435b0', 'e0a0a1ff-ed4c-5431-8237-7073a8a72fd1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e0a0a1ff-ed4c-5431-8237-7073a8a72fd1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('bef358b1-7b21-5590-b5fd-16799f763508', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('bef358b1-7b21-5590-b5fd-16799f763508', 'e0a0a1ff-ed4c-5431-8237-7073a8a72fd1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'bef358b1-7b21-5590-b5fd-16799f763508';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e0313ff9-7c51-5bf4-bd8b-8ecddb6605e6', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-6', '6afce509-b465-5302-a626-496d197435b0', 'e4eb7511-bf8d-54ae-9b05-653580a0533c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e4eb7511-bf8d-54ae-9b05-653580a0533c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e0313ff9-7c51-5bf4-bd8b-8ecddb6605e6', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('e0313ff9-7c51-5bf4-bd8b-8ecddb6605e6', 'e4eb7511-bf8d-54ae-9b05-653580a0533c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e0313ff9-7c51-5bf4-bd8b-8ecddb6605e6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('eac7b2ce-9baa-565e-a061-8e60c9c78770', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-7', '6afce509-b465-5302-a626-496d197435b0', '100df4f3-7854-5d15-8415-729e28e1d694', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '100df4f3-7854-5d15-8415-729e28e1d694';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('eac7b2ce-9baa-565e-a061-8e60c9c78770', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('eac7b2ce-9baa-565e-a061-8e60c9c78770', '100df4f3-7854-5d15-8415-729e28e1d694', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'eac7b2ce-9baa-565e-a061-8e60c9c78770';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ef265bb7-b19e-5646-9e44-21b3e6cae95d', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-8', '6afce509-b465-5302-a626-496d197435b0', 'b7ad679f-a529-5df3-89f8-a1392cd0e2e5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b7ad679f-a529-5df3-89f8-a1392cd0e2e5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ef265bb7-b19e-5646-9e44-21b3e6cae95d', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('ef265bb7-b19e-5646-9e44-21b3e6cae95d', 'b7ad679f-a529-5df3-89f8-a1392cd0e2e5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ef265bb7-b19e-5646-9e44-21b3e6cae95d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e5cc3567-f266-57b0-8c40-37e0c4c5e528', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-9', '6afce509-b465-5302-a626-496d197435b0', 'c2e30779-0075-503e-b623-b742c4795fb8', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c2e30779-0075-503e-b623-b742c4795fb8';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e5cc3567-f266-57b0-8c40-37e0c4c5e528', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('e5cc3567-f266-57b0-8c40-37e0c4c5e528', 'c2e30779-0075-503e-b623-b742c4795fb8', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e5cc3567-f266-57b0-8c40-37e0c4c5e528';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('949aecb3-6b6a-5504-b15b-912741dc7ba1', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-10', '6afce509-b465-5302-a626-496d197435b0', '9208060a-b4e2-52d9-b61a-78921dd79836', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9208060a-b4e2-52d9-b61a-78921dd79836';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('949aecb3-6b6a-5504-b15b-912741dc7ba1', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('949aecb3-6b6a-5504-b15b-912741dc7ba1', '9208060a-b4e2-52d9-b61a-78921dd79836', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '949aecb3-6b6a-5504-b15b-912741dc7ba1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ef7c6960-5649-501e-a2cc-d9fd5e1ded7b', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-11', '6afce509-b465-5302-a626-496d197435b0', 'f630d9a6-989f-5b9c-998e-b94e11b5d9be', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f630d9a6-989f-5b9c-998e-b94e11b5d9be';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ef7c6960-5649-501e-a2cc-d9fd5e1ded7b', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('ef7c6960-5649-501e-a2cc-d9fd5e1ded7b', 'f630d9a6-989f-5b9c-998e-b94e11b5d9be', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ef7c6960-5649-501e-a2cc-d9fd5e1ded7b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('62773d8d-ffa5-5e35-8b50-5ac9df01cfd3', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-12', '6afce509-b465-5302-a626-496d197435b0', 'ccd76c56-244c-5486-8665-c5f785e7aade', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ccd76c56-244c-5486-8665-c5f785e7aade';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('62773d8d-ffa5-5e35-8b50-5ac9df01cfd3', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('62773d8d-ffa5-5e35-8b50-5ac9df01cfd3', 'ccd76c56-244c-5486-8665-c5f785e7aade', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '62773d8d-ffa5-5e35-8b50-5ac9df01cfd3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('15ea447d-455e-5019-a549-342064b6c152', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-13', '6afce509-b465-5302-a626-496d197435b0', '4d5fa488-315b-5786-96ba-630dbc326090', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4d5fa488-315b-5786-96ba-630dbc326090';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('15ea447d-455e-5019-a549-342064b6c152', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('15ea447d-455e-5019-a549-342064b6c152', '4d5fa488-315b-5786-96ba-630dbc326090', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '15ea447d-455e-5019-a549-342064b6c152';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('aa80da9a-d060-5b2a-8278-d3be388c2872', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-14', '6afce509-b465-5302-a626-496d197435b0', '4a7b4ded-b854-5c9a-afad-da3b7d96ebe6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4a7b4ded-b854-5c9a-afad-da3b7d96ebe6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('aa80da9a-d060-5b2a-8278-d3be388c2872', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('aa80da9a-d060-5b2a-8278-d3be388c2872', '4a7b4ded-b854-5c9a-afad-da3b7d96ebe6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'aa80da9a-d060-5b2a-8278-d3be388c2872';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a1fa7d1d-c688-5070-bc9b-79b310b0b019', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-15', '6afce509-b465-5302-a626-496d197435b0', '60cbd3ea-558b-5c15-9e54-0f1d1b7cf27e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '60cbd3ea-558b-5c15-9e54-0f1d1b7cf27e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a1fa7d1d-c688-5070-bc9b-79b310b0b019', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('a1fa7d1d-c688-5070-bc9b-79b310b0b019', '60cbd3ea-558b-5c15-9e54-0f1d1b7cf27e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a1fa7d1d-c688-5070-bc9b-79b310b0b019';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7ba75ba9-0d52-57bb-ae2a-0ef732e3c349', 'benchmark-funding-1ef1a356-5f27-48bb-8235-79b95d48888c-16', '6afce509-b465-5302-a626-496d197435b0', '294f3497-dec5-5a3b-aedc-668229c39fff', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '6afce509-b465-5302-a626-496d197435b0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '294f3497-dec5-5a3b-aedc-668229c39fff';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7ba75ba9-0d52-57bb-ae2a-0ef732e3c349', '6afce509-b465-5302-a626-496d197435b0', -1000000000), ('7ba75ba9-0d52-57bb-ae2a-0ef732e3c349', '294f3497-dec5-5a3b-aedc-668229c39fff', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7ba75ba9-0d52-57bb-ae2a-0ef732e3c349';
COMMIT;
