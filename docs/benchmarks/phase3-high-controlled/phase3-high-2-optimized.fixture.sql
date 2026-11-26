-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('001af0e2-6eb1-5522-bac6-e0fbef194041', 'USER', 'ACTIVE', 'FIC'),
('015aafe7-f416-54a0-b3a0-fa61c36b49ef', 'USER', 'ACTIVE', 'FIC'),
('04401094-93f7-5593-968a-8e8663109805', 'USER', 'ACTIVE', 'FIC'),
('048cd03b-48d5-58dc-b51c-254c505b179f', 'ISSUANCE', 'ACTIVE', 'FIC'),
('07e26bdc-c2d3-5b28-9db4-26dae5e4d072', 'USER', 'ACTIVE', 'FIC'),
('08f7f4b7-97f7-527c-91b1-60c0ef30cf02', 'USER', 'ACTIVE', 'FIC'),
('0924b2a0-6ab1-50b8-a515-d1cdab09ccf3', 'USER', 'ACTIVE', 'FIC'),
('096288a6-b1c4-5456-8153-053beea3f717', 'USER', 'ACTIVE', 'FIC'),
('0a70fd32-4c1d-5a90-ad75-6d141fd570df', 'USER', 'ACTIVE', 'FIC'),
('0ad8fc8c-a558-58fe-9d4c-e7795a48cbe5', 'USER', 'ACTIVE', 'FIC'),
('0c4abb40-8be4-5f01-b33b-3fecd7f0680a', 'USER', 'ACTIVE', 'FIC'),
('131490fc-825a-503a-8767-63b899d8d4e0', 'USER', 'ACTIVE', 'FIC'),
('23bb7be4-18a6-570e-a67d-1ead5c56082c', 'USER', 'ACTIVE', 'FIC'),
('25102c6b-d150-5ecd-a1d5-a8d45a482818', 'USER', 'ACTIVE', 'FIC'),
('35c368a7-2740-577c-bcaa-3d8e017cdc32', 'USER', 'ACTIVE', 'FIC'),
('4f37fe71-4997-51fe-9c4d-6fb300799d96', 'USER', 'ACTIVE', 'FIC'),
('58e86faa-3154-5fc3-b9a3-bf32bd761f08', 'USER', 'ACTIVE', 'FIC'),
('69d7c743-0062-54e6-b6fd-6c76adbbad7e', 'USER', 'ACTIVE', 'FIC'),
('78ab3aae-0d60-5197-81e2-babfd0b572a9', 'USER', 'ACTIVE', 'FIC'),
('92ea6643-c67e-5be2-af0e-f1167124b86a', 'USER', 'ACTIVE', 'FIC'),
('a1f717b4-3e97-578f-80f3-5bdb8346a39d', 'USER', 'ACTIVE', 'FIC'),
('b47094d5-d263-5510-8d68-c6c72de100db', 'USER', 'ACTIVE', 'FIC'),
('c4d89533-cd77-51d2-bab0-d0fb8ba711d7', 'USER', 'ACTIVE', 'FIC'),
('d6d87fe7-8ec2-5e57-bb7a-4a1b568316ab', 'USER', 'ACTIVE', 'FIC'),
('f579ee43-07af-57f2-9aaa-3e3556c28795', 'USER', 'ACTIVE', 'FIC'),
('fe9e2333-1d52-5a0e-a4c1-237f59834964', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('001af0e2-6eb1-5522-bac6-e0fbef194041', 0),
('015aafe7-f416-54a0-b3a0-fa61c36b49ef', 0),
('04401094-93f7-5593-968a-8e8663109805', 0),
('048cd03b-48d5-58dc-b51c-254c505b179f', 0),
('07e26bdc-c2d3-5b28-9db4-26dae5e4d072', 0),
('08f7f4b7-97f7-527c-91b1-60c0ef30cf02', 0),
('0924b2a0-6ab1-50b8-a515-d1cdab09ccf3', 0),
('096288a6-b1c4-5456-8153-053beea3f717', 0),
('0a70fd32-4c1d-5a90-ad75-6d141fd570df', 0),
('0ad8fc8c-a558-58fe-9d4c-e7795a48cbe5', 0),
('0c4abb40-8be4-5f01-b33b-3fecd7f0680a', 0),
('131490fc-825a-503a-8767-63b899d8d4e0', 0),
('23bb7be4-18a6-570e-a67d-1ead5c56082c', 0),
('25102c6b-d150-5ecd-a1d5-a8d45a482818', 0),
('35c368a7-2740-577c-bcaa-3d8e017cdc32', 0),
('4f37fe71-4997-51fe-9c4d-6fb300799d96', 0),
('58e86faa-3154-5fc3-b9a3-bf32bd761f08', 0),
('69d7c743-0062-54e6-b6fd-6c76adbbad7e', 0),
('78ab3aae-0d60-5197-81e2-babfd0b572a9', 0),
('92ea6643-c67e-5be2-af0e-f1167124b86a', 0),
('a1f717b4-3e97-578f-80f3-5bdb8346a39d', 0),
('b47094d5-d263-5510-8d68-c6c72de100db', 0),
('c4d89533-cd77-51d2-bab0-d0fb8ba711d7', 0),
('d6d87fe7-8ec2-5e57-bb7a-4a1b568316ab', 0),
('f579ee43-07af-57f2-9aaa-3e3556c28795', 0),
('fe9e2333-1d52-5a0e-a4c1-237f59834964', 0);
SELECT account_id FROM balances WHERE account_id IN ('001af0e2-6eb1-5522-bac6-e0fbef194041','015aafe7-f416-54a0-b3a0-fa61c36b49ef','04401094-93f7-5593-968a-8e8663109805','048cd03b-48d5-58dc-b51c-254c505b179f','07e26bdc-c2d3-5b28-9db4-26dae5e4d072','08f7f4b7-97f7-527c-91b1-60c0ef30cf02','0924b2a0-6ab1-50b8-a515-d1cdab09ccf3','096288a6-b1c4-5456-8153-053beea3f717','0a70fd32-4c1d-5a90-ad75-6d141fd570df','0ad8fc8c-a558-58fe-9d4c-e7795a48cbe5','0c4abb40-8be4-5f01-b33b-3fecd7f0680a','131490fc-825a-503a-8767-63b899d8d4e0','23bb7be4-18a6-570e-a67d-1ead5c56082c','25102c6b-d150-5ecd-a1d5-a8d45a482818','35c368a7-2740-577c-bcaa-3d8e017cdc32','4f37fe71-4997-51fe-9c4d-6fb300799d96','58e86faa-3154-5fc3-b9a3-bf32bd761f08','69d7c743-0062-54e6-b6fd-6c76adbbad7e','78ab3aae-0d60-5197-81e2-babfd0b572a9','92ea6643-c67e-5be2-af0e-f1167124b86a','a1f717b4-3e97-578f-80f3-5bdb8346a39d','b47094d5-d263-5510-8d68-c6c72de100db','c4d89533-cd77-51d2-bab0-d0fb8ba711d7','d6d87fe7-8ec2-5e57-bb7a-4a1b568316ab','f579ee43-07af-57f2-9aaa-3e3556c28795','fe9e2333-1d52-5a0e-a4c1-237f59834964') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f5997432-34e8-59ef-9408-2bfbeb04265e', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-0', '048cd03b-48d5-58dc-b51c-254c505b179f', 'b47094d5-d263-5510-8d68-c6c72de100db', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b47094d5-d263-5510-8d68-c6c72de100db';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f5997432-34e8-59ef-9408-2bfbeb04265e', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('f5997432-34e8-59ef-9408-2bfbeb04265e', 'b47094d5-d263-5510-8d68-c6c72de100db', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f5997432-34e8-59ef-9408-2bfbeb04265e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('68ad7e52-9f80-536b-bcb0-1de408e0b794', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-1', '048cd03b-48d5-58dc-b51c-254c505b179f', '69d7c743-0062-54e6-b6fd-6c76adbbad7e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '69d7c743-0062-54e6-b6fd-6c76adbbad7e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('68ad7e52-9f80-536b-bcb0-1de408e0b794', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('68ad7e52-9f80-536b-bcb0-1de408e0b794', '69d7c743-0062-54e6-b6fd-6c76adbbad7e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '68ad7e52-9f80-536b-bcb0-1de408e0b794';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('391bd657-0816-5e70-a15c-dcef82f1e616', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-2', '048cd03b-48d5-58dc-b51c-254c505b179f', '23bb7be4-18a6-570e-a67d-1ead5c56082c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '23bb7be4-18a6-570e-a67d-1ead5c56082c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('391bd657-0816-5e70-a15c-dcef82f1e616', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('391bd657-0816-5e70-a15c-dcef82f1e616', '23bb7be4-18a6-570e-a67d-1ead5c56082c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '391bd657-0816-5e70-a15c-dcef82f1e616';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6b0a669d-a53a-5acd-b37c-d785b6d1e7a8', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-3', '048cd03b-48d5-58dc-b51c-254c505b179f', 'a1f717b4-3e97-578f-80f3-5bdb8346a39d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a1f717b4-3e97-578f-80f3-5bdb8346a39d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6b0a669d-a53a-5acd-b37c-d785b6d1e7a8', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('6b0a669d-a53a-5acd-b37c-d785b6d1e7a8', 'a1f717b4-3e97-578f-80f3-5bdb8346a39d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6b0a669d-a53a-5acd-b37c-d785b6d1e7a8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c55b73d0-8a2a-5fe8-9e05-452d9a2642eb', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-4', '048cd03b-48d5-58dc-b51c-254c505b179f', '78ab3aae-0d60-5197-81e2-babfd0b572a9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '78ab3aae-0d60-5197-81e2-babfd0b572a9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c55b73d0-8a2a-5fe8-9e05-452d9a2642eb', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('c55b73d0-8a2a-5fe8-9e05-452d9a2642eb', '78ab3aae-0d60-5197-81e2-babfd0b572a9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c55b73d0-8a2a-5fe8-9e05-452d9a2642eb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6130a962-e621-5c96-9b16-7a675dae344d', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-5', '048cd03b-48d5-58dc-b51c-254c505b179f', '08f7f4b7-97f7-527c-91b1-60c0ef30cf02', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '08f7f4b7-97f7-527c-91b1-60c0ef30cf02';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6130a962-e621-5c96-9b16-7a675dae344d', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('6130a962-e621-5c96-9b16-7a675dae344d', '08f7f4b7-97f7-527c-91b1-60c0ef30cf02', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6130a962-e621-5c96-9b16-7a675dae344d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('48806f3a-f57f-5bc3-971b-429b2615cb3a', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-6', '048cd03b-48d5-58dc-b51c-254c505b179f', 'd6d87fe7-8ec2-5e57-bb7a-4a1b568316ab', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd6d87fe7-8ec2-5e57-bb7a-4a1b568316ab';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('48806f3a-f57f-5bc3-971b-429b2615cb3a', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('48806f3a-f57f-5bc3-971b-429b2615cb3a', 'd6d87fe7-8ec2-5e57-bb7a-4a1b568316ab', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '48806f3a-f57f-5bc3-971b-429b2615cb3a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1caefff3-e053-508c-b267-0c2cd904eaf7', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-7', '048cd03b-48d5-58dc-b51c-254c505b179f', 'c4d89533-cd77-51d2-bab0-d0fb8ba711d7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c4d89533-cd77-51d2-bab0-d0fb8ba711d7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1caefff3-e053-508c-b267-0c2cd904eaf7', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('1caefff3-e053-508c-b267-0c2cd904eaf7', 'c4d89533-cd77-51d2-bab0-d0fb8ba711d7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1caefff3-e053-508c-b267-0c2cd904eaf7';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('cac020c8-2710-54b4-8317-40aa7b1ce399', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-8', '048cd03b-48d5-58dc-b51c-254c505b179f', 'fe9e2333-1d52-5a0e-a4c1-237f59834964', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fe9e2333-1d52-5a0e-a4c1-237f59834964';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('cac020c8-2710-54b4-8317-40aa7b1ce399', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('cac020c8-2710-54b4-8317-40aa7b1ce399', 'fe9e2333-1d52-5a0e-a4c1-237f59834964', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'cac020c8-2710-54b4-8317-40aa7b1ce399';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e2585f11-b870-5de7-b946-494a730ae274', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-9', '048cd03b-48d5-58dc-b51c-254c505b179f', '92ea6643-c67e-5be2-af0e-f1167124b86a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '92ea6643-c67e-5be2-af0e-f1167124b86a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e2585f11-b870-5de7-b946-494a730ae274', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('e2585f11-b870-5de7-b946-494a730ae274', '92ea6643-c67e-5be2-af0e-f1167124b86a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e2585f11-b870-5de7-b946-494a730ae274';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('856c2c27-6f7c-5c4c-ad7d-bac3ae43bab2', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-10', '048cd03b-48d5-58dc-b51c-254c505b179f', '58e86faa-3154-5fc3-b9a3-bf32bd761f08', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '58e86faa-3154-5fc3-b9a3-bf32bd761f08';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('856c2c27-6f7c-5c4c-ad7d-bac3ae43bab2', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('856c2c27-6f7c-5c4c-ad7d-bac3ae43bab2', '58e86faa-3154-5fc3-b9a3-bf32bd761f08', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '856c2c27-6f7c-5c4c-ad7d-bac3ae43bab2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('44acb397-643c-5732-8c07-b5084c1c4a34', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-11', '048cd03b-48d5-58dc-b51c-254c505b179f', 'f579ee43-07af-57f2-9aaa-3e3556c28795', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f579ee43-07af-57f2-9aaa-3e3556c28795';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('44acb397-643c-5732-8c07-b5084c1c4a34', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('44acb397-643c-5732-8c07-b5084c1c4a34', 'f579ee43-07af-57f2-9aaa-3e3556c28795', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '44acb397-643c-5732-8c07-b5084c1c4a34';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6c4a4a4d-68f4-5125-9838-8e606f55196a', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-12', '048cd03b-48d5-58dc-b51c-254c505b179f', '0ad8fc8c-a558-58fe-9d4c-e7795a48cbe5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0ad8fc8c-a558-58fe-9d4c-e7795a48cbe5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6c4a4a4d-68f4-5125-9838-8e606f55196a', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('6c4a4a4d-68f4-5125-9838-8e606f55196a', '0ad8fc8c-a558-58fe-9d4c-e7795a48cbe5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6c4a4a4d-68f4-5125-9838-8e606f55196a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a7c04aaf-6cf3-5900-8086-bb8ffdb4b928', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-13', '048cd03b-48d5-58dc-b51c-254c505b179f', '131490fc-825a-503a-8767-63b899d8d4e0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '131490fc-825a-503a-8767-63b899d8d4e0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a7c04aaf-6cf3-5900-8086-bb8ffdb4b928', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('a7c04aaf-6cf3-5900-8086-bb8ffdb4b928', '131490fc-825a-503a-8767-63b899d8d4e0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a7c04aaf-6cf3-5900-8086-bb8ffdb4b928';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a8fc7ffd-a2da-5bd6-a3b5-3c62048864b0', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-14', '048cd03b-48d5-58dc-b51c-254c505b179f', '25102c6b-d150-5ecd-a1d5-a8d45a482818', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '25102c6b-d150-5ecd-a1d5-a8d45a482818';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a8fc7ffd-a2da-5bd6-a3b5-3c62048864b0', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('a8fc7ffd-a2da-5bd6-a3b5-3c62048864b0', '25102c6b-d150-5ecd-a1d5-a8d45a482818', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a8fc7ffd-a2da-5bd6-a3b5-3c62048864b0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('37ca0d4c-90e7-5655-9e56-e80f7167f8b6', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-15', '048cd03b-48d5-58dc-b51c-254c505b179f', '4f37fe71-4997-51fe-9c4d-6fb300799d96', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4f37fe71-4997-51fe-9c4d-6fb300799d96';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('37ca0d4c-90e7-5655-9e56-e80f7167f8b6', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('37ca0d4c-90e7-5655-9e56-e80f7167f8b6', '4f37fe71-4997-51fe-9c4d-6fb300799d96', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '37ca0d4c-90e7-5655-9e56-e80f7167f8b6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('172b1ed6-2917-5563-9203-37883f7addc9', 'benchmark-funding-f7219973-f6d6-442c-b480-3db35d6d2e80-16', '048cd03b-48d5-58dc-b51c-254c505b179f', '35c368a7-2740-577c-bcaa-3d8e017cdc32', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '048cd03b-48d5-58dc-b51c-254c505b179f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '35c368a7-2740-577c-bcaa-3d8e017cdc32';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('172b1ed6-2917-5563-9203-37883f7addc9', '048cd03b-48d5-58dc-b51c-254c505b179f', -1000000000), ('172b1ed6-2917-5563-9203-37883f7addc9', '35c368a7-2740-577c-bcaa-3d8e017cdc32', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '172b1ed6-2917-5563-9203-37883f7addc9';
COMMIT;
