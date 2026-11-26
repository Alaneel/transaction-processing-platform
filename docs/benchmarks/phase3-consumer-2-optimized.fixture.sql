-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('00e56b54-449c-5e88-9d18-fa6d4b3c9639', 'USER', 'ACTIVE', 'FIC'),
('08dd610d-67f0-5e14-9f58-bd855003ff48', 'USER', 'ACTIVE', 'FIC'),
('1486ff75-25fe-5b5e-b162-51d664b1094a', 'USER', 'ACTIVE', 'FIC'),
('1a16fe2e-a48b-5f5c-bb76-00cc70fc89db', 'USER', 'ACTIVE', 'FIC'),
('257e121d-1c43-5645-a1a6-5b1f69052add', 'USER', 'ACTIVE', 'FIC'),
('311f459b-ac01-5975-b101-c526597e3d3a', 'USER', 'ACTIVE', 'FIC'),
('3193ec1b-71eb-5aed-b64d-9ce6ecf9186f', 'USER', 'ACTIVE', 'FIC'),
('32c0bf3a-47fd-5a59-83c4-0e07028dee64', 'USER', 'ACTIVE', 'FIC'),
('43c8ed4f-261a-57f3-8c6b-a0464f768515', 'USER', 'ACTIVE', 'FIC'),
('54296d48-44f5-54e0-badd-4bda1f8cb375', 'USER', 'ACTIVE', 'FIC'),
('5b4ea34f-af34-5f07-9080-a2d3afc0a070', 'USER', 'ACTIVE', 'FIC'),
('5f233f7d-f72f-5264-8da2-a7222ebffeec', 'USER', 'ACTIVE', 'FIC'),
('7a9461ca-0b43-52c6-b67b-40fe348cf2ae', 'USER', 'ACTIVE', 'FIC'),
('7c3ebde4-0a49-5a6d-956b-a953605748c0', 'USER', 'ACTIVE', 'FIC'),
('7f6b0d16-04bc-50a0-91e7-80a6f7c1339b', 'USER', 'ACTIVE', 'FIC'),
('87dccb55-09bf-5cee-944d-94fa5d4dd3b8', 'USER', 'ACTIVE', 'FIC'),
('8b6844d4-ee2f-58dd-8c43-421219883b6a', 'USER', 'ACTIVE', 'FIC'),
('9195c6e0-8989-545a-887f-07cfd0c3f163', 'USER', 'ACTIVE', 'FIC'),
('993d1a86-0cec-54ab-be56-0ecda2b09920', 'USER', 'ACTIVE', 'FIC'),
('a0f00390-cf6c-592f-84cd-bc859fc3e35e', 'USER', 'ACTIVE', 'FIC'),
('a2bcfc7f-becb-5d95-90de-ca1a17ccf329', 'USER', 'ACTIVE', 'FIC'),
('a45639c1-5cc8-5822-bf2d-9f84685efbbb', 'USER', 'ACTIVE', 'FIC'),
('b08d6b96-b018-5705-980a-935cec47a279', 'USER', 'ACTIVE', 'FIC'),
('b11c8975-52ce-5146-8f21-b6b28a7db4e3', 'USER', 'ACTIVE', 'FIC'),
('debed4f0-51ba-5192-bf3b-a5d73d9e6e71', 'USER', 'ACTIVE', 'FIC'),
('eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', 'ISSUANCE', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('00e56b54-449c-5e88-9d18-fa6d4b3c9639', 0),
('08dd610d-67f0-5e14-9f58-bd855003ff48', 0),
('1486ff75-25fe-5b5e-b162-51d664b1094a', 0),
('1a16fe2e-a48b-5f5c-bb76-00cc70fc89db', 0),
('257e121d-1c43-5645-a1a6-5b1f69052add', 0),
('311f459b-ac01-5975-b101-c526597e3d3a', 0),
('3193ec1b-71eb-5aed-b64d-9ce6ecf9186f', 0),
('32c0bf3a-47fd-5a59-83c4-0e07028dee64', 0),
('43c8ed4f-261a-57f3-8c6b-a0464f768515', 0),
('54296d48-44f5-54e0-badd-4bda1f8cb375', 0),
('5b4ea34f-af34-5f07-9080-a2d3afc0a070', 0),
('5f233f7d-f72f-5264-8da2-a7222ebffeec', 0),
('7a9461ca-0b43-52c6-b67b-40fe348cf2ae', 0),
('7c3ebde4-0a49-5a6d-956b-a953605748c0', 0),
('7f6b0d16-04bc-50a0-91e7-80a6f7c1339b', 0),
('87dccb55-09bf-5cee-944d-94fa5d4dd3b8', 0),
('8b6844d4-ee2f-58dd-8c43-421219883b6a', 0),
('9195c6e0-8989-545a-887f-07cfd0c3f163', 0),
('993d1a86-0cec-54ab-be56-0ecda2b09920', 0),
('a0f00390-cf6c-592f-84cd-bc859fc3e35e', 0),
('a2bcfc7f-becb-5d95-90de-ca1a17ccf329', 0),
('a45639c1-5cc8-5822-bf2d-9f84685efbbb', 0),
('b08d6b96-b018-5705-980a-935cec47a279', 0),
('b11c8975-52ce-5146-8f21-b6b28a7db4e3', 0),
('debed4f0-51ba-5192-bf3b-a5d73d9e6e71', 0),
('eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', 0);
SELECT account_id FROM balances WHERE account_id IN ('00e56b54-449c-5e88-9d18-fa6d4b3c9639','08dd610d-67f0-5e14-9f58-bd855003ff48','1486ff75-25fe-5b5e-b162-51d664b1094a','1a16fe2e-a48b-5f5c-bb76-00cc70fc89db','257e121d-1c43-5645-a1a6-5b1f69052add','311f459b-ac01-5975-b101-c526597e3d3a','3193ec1b-71eb-5aed-b64d-9ce6ecf9186f','32c0bf3a-47fd-5a59-83c4-0e07028dee64','43c8ed4f-261a-57f3-8c6b-a0464f768515','54296d48-44f5-54e0-badd-4bda1f8cb375','5b4ea34f-af34-5f07-9080-a2d3afc0a070','5f233f7d-f72f-5264-8da2-a7222ebffeec','7a9461ca-0b43-52c6-b67b-40fe348cf2ae','7c3ebde4-0a49-5a6d-956b-a953605748c0','7f6b0d16-04bc-50a0-91e7-80a6f7c1339b','87dccb55-09bf-5cee-944d-94fa5d4dd3b8','8b6844d4-ee2f-58dd-8c43-421219883b6a','9195c6e0-8989-545a-887f-07cfd0c3f163','993d1a86-0cec-54ab-be56-0ecda2b09920','a0f00390-cf6c-592f-84cd-bc859fc3e35e','a2bcfc7f-becb-5d95-90de-ca1a17ccf329','a45639c1-5cc8-5822-bf2d-9f84685efbbb','b08d6b96-b018-5705-980a-935cec47a279','b11c8975-52ce-5146-8f21-b6b28a7db4e3','debed4f0-51ba-5192-bf3b-a5d73d9e6e71','eec759d6-1c09-5bce-82ec-cc0d7b4a42d6') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a5de6094-a583-5a63-b671-5119dbcb3ded', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-0', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', 'b11c8975-52ce-5146-8f21-b6b28a7db4e3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b11c8975-52ce-5146-8f21-b6b28a7db4e3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a5de6094-a583-5a63-b671-5119dbcb3ded', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('a5de6094-a583-5a63-b671-5119dbcb3ded', 'b11c8975-52ce-5146-8f21-b6b28a7db4e3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a5de6094-a583-5a63-b671-5119dbcb3ded';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('63a266d6-e48d-5ef5-8454-60a0acc6db8a', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-1', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', '1a16fe2e-a48b-5f5c-bb76-00cc70fc89db', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1a16fe2e-a48b-5f5c-bb76-00cc70fc89db';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('63a266d6-e48d-5ef5-8454-60a0acc6db8a', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('63a266d6-e48d-5ef5-8454-60a0acc6db8a', '1a16fe2e-a48b-5f5c-bb76-00cc70fc89db', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '63a266d6-e48d-5ef5-8454-60a0acc6db8a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('388aecc5-7544-5240-820f-50216e233746', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-2', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', '9195c6e0-8989-545a-887f-07cfd0c3f163', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9195c6e0-8989-545a-887f-07cfd0c3f163';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('388aecc5-7544-5240-820f-50216e233746', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('388aecc5-7544-5240-820f-50216e233746', '9195c6e0-8989-545a-887f-07cfd0c3f163', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '388aecc5-7544-5240-820f-50216e233746';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ecab9e3f-f7c0-5af2-bf11-a00e7ee910e0', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-3', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', 'a2bcfc7f-becb-5d95-90de-ca1a17ccf329', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a2bcfc7f-becb-5d95-90de-ca1a17ccf329';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ecab9e3f-f7c0-5af2-bf11-a00e7ee910e0', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('ecab9e3f-f7c0-5af2-bf11-a00e7ee910e0', 'a2bcfc7f-becb-5d95-90de-ca1a17ccf329', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ecab9e3f-f7c0-5af2-bf11-a00e7ee910e0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a0fed8d4-7f12-55cd-9dca-9e050b0ead77', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-4', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', 'b08d6b96-b018-5705-980a-935cec47a279', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b08d6b96-b018-5705-980a-935cec47a279';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a0fed8d4-7f12-55cd-9dca-9e050b0ead77', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('a0fed8d4-7f12-55cd-9dca-9e050b0ead77', 'b08d6b96-b018-5705-980a-935cec47a279', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a0fed8d4-7f12-55cd-9dca-9e050b0ead77';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f1be3edb-a017-502b-95d5-5866d84000a3', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-5', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', '7c3ebde4-0a49-5a6d-956b-a953605748c0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7c3ebde4-0a49-5a6d-956b-a953605748c0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f1be3edb-a017-502b-95d5-5866d84000a3', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('f1be3edb-a017-502b-95d5-5866d84000a3', '7c3ebde4-0a49-5a6d-956b-a953605748c0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f1be3edb-a017-502b-95d5-5866d84000a3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3a6a1128-8a80-587c-998e-47fd5b8cb232', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-6', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', '54296d48-44f5-54e0-badd-4bda1f8cb375', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '54296d48-44f5-54e0-badd-4bda1f8cb375';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3a6a1128-8a80-587c-998e-47fd5b8cb232', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('3a6a1128-8a80-587c-998e-47fd5b8cb232', '54296d48-44f5-54e0-badd-4bda1f8cb375', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3a6a1128-8a80-587c-998e-47fd5b8cb232';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('94679466-72c8-5625-bd80-825cb4ad3a3d', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-7', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', '7f6b0d16-04bc-50a0-91e7-80a6f7c1339b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7f6b0d16-04bc-50a0-91e7-80a6f7c1339b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('94679466-72c8-5625-bd80-825cb4ad3a3d', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('94679466-72c8-5625-bd80-825cb4ad3a3d', '7f6b0d16-04bc-50a0-91e7-80a6f7c1339b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '94679466-72c8-5625-bd80-825cb4ad3a3d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b9f735c7-7de5-5c23-aab7-243fd1a64871', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-8', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', 'a0f00390-cf6c-592f-84cd-bc859fc3e35e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a0f00390-cf6c-592f-84cd-bc859fc3e35e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b9f735c7-7de5-5c23-aab7-243fd1a64871', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('b9f735c7-7de5-5c23-aab7-243fd1a64871', 'a0f00390-cf6c-592f-84cd-bc859fc3e35e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b9f735c7-7de5-5c23-aab7-243fd1a64871';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('fd388209-d2cf-5f02-a394-d9ab14c91321', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-9', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', '87dccb55-09bf-5cee-944d-94fa5d4dd3b8', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '87dccb55-09bf-5cee-944d-94fa5d4dd3b8';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('fd388209-d2cf-5f02-a394-d9ab14c91321', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('fd388209-d2cf-5f02-a394-d9ab14c91321', '87dccb55-09bf-5cee-944d-94fa5d4dd3b8', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'fd388209-d2cf-5f02-a394-d9ab14c91321';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8b85624a-70b1-580c-9e86-8ce4a8ead135', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-10', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', '7a9461ca-0b43-52c6-b67b-40fe348cf2ae', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7a9461ca-0b43-52c6-b67b-40fe348cf2ae';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8b85624a-70b1-580c-9e86-8ce4a8ead135', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('8b85624a-70b1-580c-9e86-8ce4a8ead135', '7a9461ca-0b43-52c6-b67b-40fe348cf2ae', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8b85624a-70b1-580c-9e86-8ce4a8ead135';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5eca3093-1c66-57af-934b-a478f8a12b49', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-11', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', 'debed4f0-51ba-5192-bf3b-a5d73d9e6e71', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'debed4f0-51ba-5192-bf3b-a5d73d9e6e71';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5eca3093-1c66-57af-934b-a478f8a12b49', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('5eca3093-1c66-57af-934b-a478f8a12b49', 'debed4f0-51ba-5192-bf3b-a5d73d9e6e71', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5eca3093-1c66-57af-934b-a478f8a12b49';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1d905fd2-4ed4-53b8-b0cb-398a5a316879', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-12', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', '311f459b-ac01-5975-b101-c526597e3d3a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '311f459b-ac01-5975-b101-c526597e3d3a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1d905fd2-4ed4-53b8-b0cb-398a5a316879', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('1d905fd2-4ed4-53b8-b0cb-398a5a316879', '311f459b-ac01-5975-b101-c526597e3d3a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1d905fd2-4ed4-53b8-b0cb-398a5a316879';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('31fc0465-c00b-5db4-814d-96d7688ccba9', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-13', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', '32c0bf3a-47fd-5a59-83c4-0e07028dee64', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '32c0bf3a-47fd-5a59-83c4-0e07028dee64';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('31fc0465-c00b-5db4-814d-96d7688ccba9', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('31fc0465-c00b-5db4-814d-96d7688ccba9', '32c0bf3a-47fd-5a59-83c4-0e07028dee64', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '31fc0465-c00b-5db4-814d-96d7688ccba9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('691dc1fb-fa9c-56e3-832c-f1ef3314b03c', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-14', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', '1486ff75-25fe-5b5e-b162-51d664b1094a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1486ff75-25fe-5b5e-b162-51d664b1094a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('691dc1fb-fa9c-56e3-832c-f1ef3314b03c', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('691dc1fb-fa9c-56e3-832c-f1ef3314b03c', '1486ff75-25fe-5b5e-b162-51d664b1094a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '691dc1fb-fa9c-56e3-832c-f1ef3314b03c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('541640a0-10ee-5ba6-94c4-201dadf14eb4', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-15', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', '3193ec1b-71eb-5aed-b64d-9ce6ecf9186f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3193ec1b-71eb-5aed-b64d-9ce6ecf9186f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('541640a0-10ee-5ba6-94c4-201dadf14eb4', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('541640a0-10ee-5ba6-94c4-201dadf14eb4', '3193ec1b-71eb-5aed-b64d-9ce6ecf9186f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '541640a0-10ee-5ba6-94c4-201dadf14eb4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('171e93d9-9275-52ce-8fe9-7594c4578f4c', 'benchmark-funding-ed0ae3c6-0e05-4965-913b-909f3412c9a3-16', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', '8b6844d4-ee2f-58dd-8c43-421219883b6a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8b6844d4-ee2f-58dd-8c43-421219883b6a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('171e93d9-9275-52ce-8fe9-7594c4578f4c', 'eec759d6-1c09-5bce-82ec-cc0d7b4a42d6', -1000000000), ('171e93d9-9275-52ce-8fe9-7594c4578f4c', '8b6844d4-ee2f-58dd-8c43-421219883b6a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '171e93d9-9275-52ce-8fe9-7594c4578f4c';
COMMIT;
