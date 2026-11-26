-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', 'ISSUANCE', 'ACTIVE', 'FIC'),
('1f76a11c-5630-5dd3-b5cb-28aea1f624f5', 'USER', 'ACTIVE', 'FIC'),
('2da770ae-3919-5f23-8666-4235ae87dd88', 'USER', 'ACTIVE', 'FIC'),
('3977a143-0420-5f81-843a-85b6f6665df9', 'USER', 'ACTIVE', 'FIC'),
('475c7bfe-464d-5eda-8baa-9f7e818f32c0', 'USER', 'ACTIVE', 'FIC'),
('4939b2c7-6c54-519e-b828-f00a1bab1590', 'USER', 'ACTIVE', 'FIC'),
('51fa331b-011f-5a37-8e1c-2792280cafe2', 'USER', 'ACTIVE', 'FIC'),
('5b223d49-dacf-5858-9840-3a56ceaf1b52', 'USER', 'ACTIVE', 'FIC'),
('654d8b39-6be9-55c7-ae75-68537217ff60', 'USER', 'ACTIVE', 'FIC'),
('6ce0bce3-7565-5216-ac83-34ed0ec2329e', 'USER', 'ACTIVE', 'FIC'),
('6fdbcfb7-44ba-50d8-bcca-021cd36be9c8', 'USER', 'ACTIVE', 'FIC'),
('71e53f93-441a-5733-a962-9f366844ad7e', 'USER', 'ACTIVE', 'FIC'),
('8bf0d029-6e95-565a-819d-fffdd49c078f', 'USER', 'ACTIVE', 'FIC'),
('8e80369a-98a6-5ac8-b7ca-58080f6af2d2', 'USER', 'ACTIVE', 'FIC'),
('9d2e0063-3596-52fc-a35e-3a925d125192', 'USER', 'ACTIVE', 'FIC'),
('a0b567d0-7f81-5b3a-96ad-863120b2ab94', 'USER', 'ACTIVE', 'FIC'),
('a57952f6-6ccc-522a-b7b8-4866c71ed36a', 'USER', 'ACTIVE', 'FIC'),
('a9da997a-426e-5346-a3d2-8022e95d37d6', 'USER', 'ACTIVE', 'FIC'),
('b1fa2f1d-d281-5bca-8fe0-169ce64f788c', 'USER', 'ACTIVE', 'FIC'),
('b60c15e0-f8db-52bb-bce5-f297fc748e16', 'USER', 'ACTIVE', 'FIC'),
('bec67ae3-dbf9-57ab-9e87-18ef7eebe7c8', 'USER', 'ACTIVE', 'FIC'),
('cb836987-cd7a-5027-a8e6-cd0da797d0d0', 'USER', 'ACTIVE', 'FIC'),
('d24e841d-33a6-504c-a6c4-c61d5d6e76fb', 'USER', 'ACTIVE', 'FIC'),
('f51f189d-d8b6-537e-bd27-8dc7c3ea0106', 'USER', 'ACTIVE', 'FIC'),
('f5fba63f-1d26-570e-870c-9531b4cfddc0', 'USER', 'ACTIVE', 'FIC'),
('fbe9d20a-153a-50f2-bb93-25f41e6e52ea', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', 0),
('1f76a11c-5630-5dd3-b5cb-28aea1f624f5', 0),
('2da770ae-3919-5f23-8666-4235ae87dd88', 0),
('3977a143-0420-5f81-843a-85b6f6665df9', 0),
('475c7bfe-464d-5eda-8baa-9f7e818f32c0', 0),
('4939b2c7-6c54-519e-b828-f00a1bab1590', 0),
('51fa331b-011f-5a37-8e1c-2792280cafe2', 0),
('5b223d49-dacf-5858-9840-3a56ceaf1b52', 0),
('654d8b39-6be9-55c7-ae75-68537217ff60', 0),
('6ce0bce3-7565-5216-ac83-34ed0ec2329e', 0),
('6fdbcfb7-44ba-50d8-bcca-021cd36be9c8', 0),
('71e53f93-441a-5733-a962-9f366844ad7e', 0),
('8bf0d029-6e95-565a-819d-fffdd49c078f', 0),
('8e80369a-98a6-5ac8-b7ca-58080f6af2d2', 0),
('9d2e0063-3596-52fc-a35e-3a925d125192', 0),
('a0b567d0-7f81-5b3a-96ad-863120b2ab94', 0),
('a57952f6-6ccc-522a-b7b8-4866c71ed36a', 0),
('a9da997a-426e-5346-a3d2-8022e95d37d6', 0),
('b1fa2f1d-d281-5bca-8fe0-169ce64f788c', 0),
('b60c15e0-f8db-52bb-bce5-f297fc748e16', 0),
('bec67ae3-dbf9-57ab-9e87-18ef7eebe7c8', 0),
('cb836987-cd7a-5027-a8e6-cd0da797d0d0', 0),
('d24e841d-33a6-504c-a6c4-c61d5d6e76fb', 0),
('f51f189d-d8b6-537e-bd27-8dc7c3ea0106', 0),
('f5fba63f-1d26-570e-870c-9531b4cfddc0', 0),
('fbe9d20a-153a-50f2-bb93-25f41e6e52ea', 0);
SELECT account_id FROM balances WHERE account_id IN ('10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8','1f76a11c-5630-5dd3-b5cb-28aea1f624f5','2da770ae-3919-5f23-8666-4235ae87dd88','3977a143-0420-5f81-843a-85b6f6665df9','475c7bfe-464d-5eda-8baa-9f7e818f32c0','4939b2c7-6c54-519e-b828-f00a1bab1590','51fa331b-011f-5a37-8e1c-2792280cafe2','5b223d49-dacf-5858-9840-3a56ceaf1b52','654d8b39-6be9-55c7-ae75-68537217ff60','6ce0bce3-7565-5216-ac83-34ed0ec2329e','6fdbcfb7-44ba-50d8-bcca-021cd36be9c8','71e53f93-441a-5733-a962-9f366844ad7e','8bf0d029-6e95-565a-819d-fffdd49c078f','8e80369a-98a6-5ac8-b7ca-58080f6af2d2','9d2e0063-3596-52fc-a35e-3a925d125192','a0b567d0-7f81-5b3a-96ad-863120b2ab94','a57952f6-6ccc-522a-b7b8-4866c71ed36a','a9da997a-426e-5346-a3d2-8022e95d37d6','b1fa2f1d-d281-5bca-8fe0-169ce64f788c','b60c15e0-f8db-52bb-bce5-f297fc748e16','bec67ae3-dbf9-57ab-9e87-18ef7eebe7c8','cb836987-cd7a-5027-a8e6-cd0da797d0d0','d24e841d-33a6-504c-a6c4-c61d5d6e76fb','f51f189d-d8b6-537e-bd27-8dc7c3ea0106','f5fba63f-1d26-570e-870c-9531b4cfddc0','fbe9d20a-153a-50f2-bb93-25f41e6e52ea') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('2afb5312-1311-5dc9-8c78-1b80299677b8', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-0', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', '475c7bfe-464d-5eda-8baa-9f7e818f32c0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '475c7bfe-464d-5eda-8baa-9f7e818f32c0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('2afb5312-1311-5dc9-8c78-1b80299677b8', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('2afb5312-1311-5dc9-8c78-1b80299677b8', '475c7bfe-464d-5eda-8baa-9f7e818f32c0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '2afb5312-1311-5dc9-8c78-1b80299677b8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b01a24b1-93f6-5648-b23a-16f4deeb9475', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-1', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', '6fdbcfb7-44ba-50d8-bcca-021cd36be9c8', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6fdbcfb7-44ba-50d8-bcca-021cd36be9c8';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b01a24b1-93f6-5648-b23a-16f4deeb9475', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('b01a24b1-93f6-5648-b23a-16f4deeb9475', '6fdbcfb7-44ba-50d8-bcca-021cd36be9c8', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b01a24b1-93f6-5648-b23a-16f4deeb9475';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('14c3a2b6-63c9-5de8-96d7-5c2de3f8bce0', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-2', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', '9d2e0063-3596-52fc-a35e-3a925d125192', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9d2e0063-3596-52fc-a35e-3a925d125192';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('14c3a2b6-63c9-5de8-96d7-5c2de3f8bce0', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('14c3a2b6-63c9-5de8-96d7-5c2de3f8bce0', '9d2e0063-3596-52fc-a35e-3a925d125192', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '14c3a2b6-63c9-5de8-96d7-5c2de3f8bce0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7371052d-de46-5e1b-a0cf-adf294009a91', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-3', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', 'a9da997a-426e-5346-a3d2-8022e95d37d6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a9da997a-426e-5346-a3d2-8022e95d37d6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7371052d-de46-5e1b-a0cf-adf294009a91', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('7371052d-de46-5e1b-a0cf-adf294009a91', 'a9da997a-426e-5346-a3d2-8022e95d37d6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7371052d-de46-5e1b-a0cf-adf294009a91';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('375e2863-32ba-5563-9236-ddacd20c2bf4', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-4', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', '8bf0d029-6e95-565a-819d-fffdd49c078f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8bf0d029-6e95-565a-819d-fffdd49c078f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('375e2863-32ba-5563-9236-ddacd20c2bf4', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('375e2863-32ba-5563-9236-ddacd20c2bf4', '8bf0d029-6e95-565a-819d-fffdd49c078f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '375e2863-32ba-5563-9236-ddacd20c2bf4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('64aa1712-e9cd-5830-9400-15053346fac6', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-5', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', '6ce0bce3-7565-5216-ac83-34ed0ec2329e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6ce0bce3-7565-5216-ac83-34ed0ec2329e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('64aa1712-e9cd-5830-9400-15053346fac6', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('64aa1712-e9cd-5830-9400-15053346fac6', '6ce0bce3-7565-5216-ac83-34ed0ec2329e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '64aa1712-e9cd-5830-9400-15053346fac6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('70074539-0fad-5f8d-90c5-5a897ba62d5f', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-6', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', 'fbe9d20a-153a-50f2-bb93-25f41e6e52ea', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fbe9d20a-153a-50f2-bb93-25f41e6e52ea';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('70074539-0fad-5f8d-90c5-5a897ba62d5f', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('70074539-0fad-5f8d-90c5-5a897ba62d5f', 'fbe9d20a-153a-50f2-bb93-25f41e6e52ea', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '70074539-0fad-5f8d-90c5-5a897ba62d5f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('83e8c3a4-63fe-5262-b2b6-d69faf3e54c6', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-7', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', '5b223d49-dacf-5858-9840-3a56ceaf1b52', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5b223d49-dacf-5858-9840-3a56ceaf1b52';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('83e8c3a4-63fe-5262-b2b6-d69faf3e54c6', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('83e8c3a4-63fe-5262-b2b6-d69faf3e54c6', '5b223d49-dacf-5858-9840-3a56ceaf1b52', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '83e8c3a4-63fe-5262-b2b6-d69faf3e54c6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('147bf714-e335-5177-a12a-140fc55c2a47', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-8', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', 'cb836987-cd7a-5027-a8e6-cd0da797d0d0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'cb836987-cd7a-5027-a8e6-cd0da797d0d0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('147bf714-e335-5177-a12a-140fc55c2a47', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('147bf714-e335-5177-a12a-140fc55c2a47', 'cb836987-cd7a-5027-a8e6-cd0da797d0d0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '147bf714-e335-5177-a12a-140fc55c2a47';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('318a313b-8b60-5025-afa2-d03ad0c41f62', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-9', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', 'f5fba63f-1d26-570e-870c-9531b4cfddc0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f5fba63f-1d26-570e-870c-9531b4cfddc0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('318a313b-8b60-5025-afa2-d03ad0c41f62', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('318a313b-8b60-5025-afa2-d03ad0c41f62', 'f5fba63f-1d26-570e-870c-9531b4cfddc0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '318a313b-8b60-5025-afa2-d03ad0c41f62';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8f700792-00d6-5616-9a03-3108d4704cf4', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-10', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', '51fa331b-011f-5a37-8e1c-2792280cafe2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '51fa331b-011f-5a37-8e1c-2792280cafe2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8f700792-00d6-5616-9a03-3108d4704cf4', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('8f700792-00d6-5616-9a03-3108d4704cf4', '51fa331b-011f-5a37-8e1c-2792280cafe2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8f700792-00d6-5616-9a03-3108d4704cf4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1f4ae1c5-2c1a-51d5-958a-07f0df4c0549', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-11', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', 'b60c15e0-f8db-52bb-bce5-f297fc748e16', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b60c15e0-f8db-52bb-bce5-f297fc748e16';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1f4ae1c5-2c1a-51d5-958a-07f0df4c0549', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('1f4ae1c5-2c1a-51d5-958a-07f0df4c0549', 'b60c15e0-f8db-52bb-bce5-f297fc748e16', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1f4ae1c5-2c1a-51d5-958a-07f0df4c0549';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5ca6c96f-d6d6-568b-931a-48a876215fa4', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-12', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', 'd24e841d-33a6-504c-a6c4-c61d5d6e76fb', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd24e841d-33a6-504c-a6c4-c61d5d6e76fb';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5ca6c96f-d6d6-568b-931a-48a876215fa4', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('5ca6c96f-d6d6-568b-931a-48a876215fa4', 'd24e841d-33a6-504c-a6c4-c61d5d6e76fb', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5ca6c96f-d6d6-568b-931a-48a876215fa4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('79ce44ea-ae03-5b7e-a9fa-bd5dc8fdbf4e', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-13', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', '2da770ae-3919-5f23-8666-4235ae87dd88', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2da770ae-3919-5f23-8666-4235ae87dd88';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('79ce44ea-ae03-5b7e-a9fa-bd5dc8fdbf4e', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('79ce44ea-ae03-5b7e-a9fa-bd5dc8fdbf4e', '2da770ae-3919-5f23-8666-4235ae87dd88', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '79ce44ea-ae03-5b7e-a9fa-bd5dc8fdbf4e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('06dcc375-9c42-5f3c-bb2e-9fbdcfab1403', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-14', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', '3977a143-0420-5f81-843a-85b6f6665df9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3977a143-0420-5f81-843a-85b6f6665df9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('06dcc375-9c42-5f3c-bb2e-9fbdcfab1403', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('06dcc375-9c42-5f3c-bb2e-9fbdcfab1403', '3977a143-0420-5f81-843a-85b6f6665df9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '06dcc375-9c42-5f3c-bb2e-9fbdcfab1403';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1a4d9317-dc92-5555-bdb7-67695f005aff', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-15', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', 'b1fa2f1d-d281-5bca-8fe0-169ce64f788c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b1fa2f1d-d281-5bca-8fe0-169ce64f788c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1a4d9317-dc92-5555-bdb7-67695f005aff', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('1a4d9317-dc92-5555-bdb7-67695f005aff', 'b1fa2f1d-d281-5bca-8fe0-169ce64f788c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1a4d9317-dc92-5555-bdb7-67695f005aff';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5d10e97c-5c94-5103-83b6-608c78c29926', 'benchmark-funding-d70fec4e-8248-48ad-973f-3120b75ebb44-16', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', 'f51f189d-d8b6-537e-bd27-8dc7c3ea0106', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f51f189d-d8b6-537e-bd27-8dc7c3ea0106';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5d10e97c-5c94-5103-83b6-608c78c29926', '10f0fc46-2607-5f62-b3b2-80b0cfc0a2a8', -1000000000), ('5d10e97c-5c94-5103-83b6-608c78c29926', 'f51f189d-d8b6-537e-bd27-8dc7c3ea0106', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5d10e97c-5c94-5103-83b6-608c78c29926';
COMMIT;
