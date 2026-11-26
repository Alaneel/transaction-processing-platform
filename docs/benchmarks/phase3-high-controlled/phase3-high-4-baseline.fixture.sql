-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('007694ae-50d4-597f-879c-82ee9ed10277', 'USER', 'ACTIVE', 'FIC'),
('01af4fd0-dc92-5744-846f-835b01f09ac3', 'USER', 'ACTIVE', 'FIC'),
('06aa9a58-0561-5615-8c4e-4e5c4dad6a56', 'USER', 'ACTIVE', 'FIC'),
('0ab277da-0cc6-5ae0-9e73-e20ca33d2a7c', 'USER', 'ACTIVE', 'FIC'),
('0d4f905e-e8ca-50cf-9185-fc919b580680', 'USER', 'ACTIVE', 'FIC'),
('0eadffcb-4302-5d22-a86e-7fda52c2fd2b', 'USER', 'ACTIVE', 'FIC'),
('0efc420d-27da-5271-a3f6-7e1d0f17c321', 'USER', 'ACTIVE', 'FIC'),
('0fb184bb-ba06-5267-8766-0beeea87e6ed', 'USER', 'ACTIVE', 'FIC'),
('1aabb329-48cf-5add-81c3-d5372bc11007', 'USER', 'ACTIVE', 'FIC'),
('4063480e-c1f9-5d2d-9f5a-2074f022e207', 'USER', 'ACTIVE', 'FIC'),
('44289b6e-639b-5a1f-8b74-f55ee29f53a2', 'USER', 'ACTIVE', 'FIC'),
('668c6f32-de97-591c-93cf-f204a45c9e10', 'USER', 'ACTIVE', 'FIC'),
('77d42779-54ba-5bb7-85fe-b4f9787204b3', 'USER', 'ACTIVE', 'FIC'),
('910699f8-c8ba-5322-8cc7-2de83bd86e7c', 'ISSUANCE', 'ACTIVE', 'FIC'),
('93ea4153-1c51-5640-b46b-fa846e931d02', 'USER', 'ACTIVE', 'FIC'),
('99bbeee3-2240-5137-beef-be2d5a8b7d63', 'USER', 'ACTIVE', 'FIC'),
('a44c10f9-b7a5-5b64-9d47-eeeae81a2213', 'USER', 'ACTIVE', 'FIC'),
('a727b9f3-2ba9-5d5e-8937-fe82feefc904', 'USER', 'ACTIVE', 'FIC'),
('b0323274-a9ce-5ed8-a0b1-6817889283d4', 'USER', 'ACTIVE', 'FIC'),
('bbfff85b-f69a-521f-80ee-6683d3c502bc', 'USER', 'ACTIVE', 'FIC'),
('cd854171-92ad-5b72-9e4f-ef2b68f6b0ae', 'USER', 'ACTIVE', 'FIC'),
('ceb8cb5a-83f2-5bf4-87c3-abaa50848c86', 'USER', 'ACTIVE', 'FIC'),
('dc0376b4-bbcf-5bcf-bf1b-84c19431eea5', 'USER', 'ACTIVE', 'FIC'),
('f1ee7950-4fb5-572c-aea7-8f4374242427', 'USER', 'ACTIVE', 'FIC'),
('f8e3215a-e7dd-5518-84d0-64c77553802a', 'USER', 'ACTIVE', 'FIC'),
('ff5c04d6-65bf-5dde-877b-c46c7848bd25', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('007694ae-50d4-597f-879c-82ee9ed10277', 0),
('01af4fd0-dc92-5744-846f-835b01f09ac3', 0),
('06aa9a58-0561-5615-8c4e-4e5c4dad6a56', 0),
('0ab277da-0cc6-5ae0-9e73-e20ca33d2a7c', 0),
('0d4f905e-e8ca-50cf-9185-fc919b580680', 0),
('0eadffcb-4302-5d22-a86e-7fda52c2fd2b', 0),
('0efc420d-27da-5271-a3f6-7e1d0f17c321', 0),
('0fb184bb-ba06-5267-8766-0beeea87e6ed', 0),
('1aabb329-48cf-5add-81c3-d5372bc11007', 0),
('4063480e-c1f9-5d2d-9f5a-2074f022e207', 0),
('44289b6e-639b-5a1f-8b74-f55ee29f53a2', 0),
('668c6f32-de97-591c-93cf-f204a45c9e10', 0),
('77d42779-54ba-5bb7-85fe-b4f9787204b3', 0),
('910699f8-c8ba-5322-8cc7-2de83bd86e7c', 0),
('93ea4153-1c51-5640-b46b-fa846e931d02', 0),
('99bbeee3-2240-5137-beef-be2d5a8b7d63', 0),
('a44c10f9-b7a5-5b64-9d47-eeeae81a2213', 0),
('a727b9f3-2ba9-5d5e-8937-fe82feefc904', 0),
('b0323274-a9ce-5ed8-a0b1-6817889283d4', 0),
('bbfff85b-f69a-521f-80ee-6683d3c502bc', 0),
('cd854171-92ad-5b72-9e4f-ef2b68f6b0ae', 0),
('ceb8cb5a-83f2-5bf4-87c3-abaa50848c86', 0),
('dc0376b4-bbcf-5bcf-bf1b-84c19431eea5', 0),
('f1ee7950-4fb5-572c-aea7-8f4374242427', 0),
('f8e3215a-e7dd-5518-84d0-64c77553802a', 0),
('ff5c04d6-65bf-5dde-877b-c46c7848bd25', 0);
SELECT account_id FROM balances WHERE account_id IN ('007694ae-50d4-597f-879c-82ee9ed10277','01af4fd0-dc92-5744-846f-835b01f09ac3','06aa9a58-0561-5615-8c4e-4e5c4dad6a56','0ab277da-0cc6-5ae0-9e73-e20ca33d2a7c','0d4f905e-e8ca-50cf-9185-fc919b580680','0eadffcb-4302-5d22-a86e-7fda52c2fd2b','0efc420d-27da-5271-a3f6-7e1d0f17c321','0fb184bb-ba06-5267-8766-0beeea87e6ed','1aabb329-48cf-5add-81c3-d5372bc11007','4063480e-c1f9-5d2d-9f5a-2074f022e207','44289b6e-639b-5a1f-8b74-f55ee29f53a2','668c6f32-de97-591c-93cf-f204a45c9e10','77d42779-54ba-5bb7-85fe-b4f9787204b3','910699f8-c8ba-5322-8cc7-2de83bd86e7c','93ea4153-1c51-5640-b46b-fa846e931d02','99bbeee3-2240-5137-beef-be2d5a8b7d63','a44c10f9-b7a5-5b64-9d47-eeeae81a2213','a727b9f3-2ba9-5d5e-8937-fe82feefc904','b0323274-a9ce-5ed8-a0b1-6817889283d4','bbfff85b-f69a-521f-80ee-6683d3c502bc','cd854171-92ad-5b72-9e4f-ef2b68f6b0ae','ceb8cb5a-83f2-5bf4-87c3-abaa50848c86','dc0376b4-bbcf-5bcf-bf1b-84c19431eea5','f1ee7950-4fb5-572c-aea7-8f4374242427','f8e3215a-e7dd-5518-84d0-64c77553802a','ff5c04d6-65bf-5dde-877b-c46c7848bd25') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c89a7b75-52f2-52f6-8a84-cd04ff0e59ce', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-0', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', 'dc0376b4-bbcf-5bcf-bf1b-84c19431eea5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'dc0376b4-bbcf-5bcf-bf1b-84c19431eea5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c89a7b75-52f2-52f6-8a84-cd04ff0e59ce', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('c89a7b75-52f2-52f6-8a84-cd04ff0e59ce', 'dc0376b4-bbcf-5bcf-bf1b-84c19431eea5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c89a7b75-52f2-52f6-8a84-cd04ff0e59ce';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('842228e8-056a-5691-aec1-19dc0850694e', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-1', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', '4063480e-c1f9-5d2d-9f5a-2074f022e207', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4063480e-c1f9-5d2d-9f5a-2074f022e207';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('842228e8-056a-5691-aec1-19dc0850694e', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('842228e8-056a-5691-aec1-19dc0850694e', '4063480e-c1f9-5d2d-9f5a-2074f022e207', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '842228e8-056a-5691-aec1-19dc0850694e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('cd72d711-3c18-5041-b1a0-cad2c063d8ea', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-2', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', '99bbeee3-2240-5137-beef-be2d5a8b7d63', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '99bbeee3-2240-5137-beef-be2d5a8b7d63';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('cd72d711-3c18-5041-b1a0-cad2c063d8ea', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('cd72d711-3c18-5041-b1a0-cad2c063d8ea', '99bbeee3-2240-5137-beef-be2d5a8b7d63', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'cd72d711-3c18-5041-b1a0-cad2c063d8ea';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('814277ef-15a6-51c2-8925-a867cf4468c7', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-3', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', 'a44c10f9-b7a5-5b64-9d47-eeeae81a2213', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a44c10f9-b7a5-5b64-9d47-eeeae81a2213';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('814277ef-15a6-51c2-8925-a867cf4468c7', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('814277ef-15a6-51c2-8925-a867cf4468c7', 'a44c10f9-b7a5-5b64-9d47-eeeae81a2213', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '814277ef-15a6-51c2-8925-a867cf4468c7';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('68651cca-9ea8-56f8-9171-7c45763d3aff', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-4', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', '1aabb329-48cf-5add-81c3-d5372bc11007', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1aabb329-48cf-5add-81c3-d5372bc11007';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('68651cca-9ea8-56f8-9171-7c45763d3aff', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('68651cca-9ea8-56f8-9171-7c45763d3aff', '1aabb329-48cf-5add-81c3-d5372bc11007', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '68651cca-9ea8-56f8-9171-7c45763d3aff';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4bb232a3-3499-552a-9196-1744a9aacb22', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-5', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', '77d42779-54ba-5bb7-85fe-b4f9787204b3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '77d42779-54ba-5bb7-85fe-b4f9787204b3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4bb232a3-3499-552a-9196-1744a9aacb22', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('4bb232a3-3499-552a-9196-1744a9aacb22', '77d42779-54ba-5bb7-85fe-b4f9787204b3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4bb232a3-3499-552a-9196-1744a9aacb22';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9797f2fa-4a31-5f53-babb-43e73f77c29d', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-6', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', 'ceb8cb5a-83f2-5bf4-87c3-abaa50848c86', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ceb8cb5a-83f2-5bf4-87c3-abaa50848c86';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9797f2fa-4a31-5f53-babb-43e73f77c29d', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('9797f2fa-4a31-5f53-babb-43e73f77c29d', 'ceb8cb5a-83f2-5bf4-87c3-abaa50848c86', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9797f2fa-4a31-5f53-babb-43e73f77c29d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('15544f35-c329-5e6c-86fb-258cad5cf6d7', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-7', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', 'cd854171-92ad-5b72-9e4f-ef2b68f6b0ae', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'cd854171-92ad-5b72-9e4f-ef2b68f6b0ae';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('15544f35-c329-5e6c-86fb-258cad5cf6d7', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('15544f35-c329-5e6c-86fb-258cad5cf6d7', 'cd854171-92ad-5b72-9e4f-ef2b68f6b0ae', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '15544f35-c329-5e6c-86fb-258cad5cf6d7';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('709304da-e7d4-587f-88f2-89dd9cb8a682', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-8', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', 'f1ee7950-4fb5-572c-aea7-8f4374242427', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f1ee7950-4fb5-572c-aea7-8f4374242427';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('709304da-e7d4-587f-88f2-89dd9cb8a682', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('709304da-e7d4-587f-88f2-89dd9cb8a682', 'f1ee7950-4fb5-572c-aea7-8f4374242427', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '709304da-e7d4-587f-88f2-89dd9cb8a682';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('54e90095-81c5-5d9d-ac63-9d5a69fb33c7', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-9', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', '44289b6e-639b-5a1f-8b74-f55ee29f53a2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '44289b6e-639b-5a1f-8b74-f55ee29f53a2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('54e90095-81c5-5d9d-ac63-9d5a69fb33c7', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('54e90095-81c5-5d9d-ac63-9d5a69fb33c7', '44289b6e-639b-5a1f-8b74-f55ee29f53a2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '54e90095-81c5-5d9d-ac63-9d5a69fb33c7';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('69db6755-f2f7-5d25-90fd-5b9b655575ec', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-10', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', 'b0323274-a9ce-5ed8-a0b1-6817889283d4', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b0323274-a9ce-5ed8-a0b1-6817889283d4';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('69db6755-f2f7-5d25-90fd-5b9b655575ec', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('69db6755-f2f7-5d25-90fd-5b9b655575ec', 'b0323274-a9ce-5ed8-a0b1-6817889283d4', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '69db6755-f2f7-5d25-90fd-5b9b655575ec';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('484241bd-01c3-5e18-9bf9-0ec912cf6b3e', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-11', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', 'ff5c04d6-65bf-5dde-877b-c46c7848bd25', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ff5c04d6-65bf-5dde-877b-c46c7848bd25';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('484241bd-01c3-5e18-9bf9-0ec912cf6b3e', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('484241bd-01c3-5e18-9bf9-0ec912cf6b3e', 'ff5c04d6-65bf-5dde-877b-c46c7848bd25', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '484241bd-01c3-5e18-9bf9-0ec912cf6b3e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('db5849a2-4136-51ae-99c1-fb9ac84655f1', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-12', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', '93ea4153-1c51-5640-b46b-fa846e931d02', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '93ea4153-1c51-5640-b46b-fa846e931d02';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('db5849a2-4136-51ae-99c1-fb9ac84655f1', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('db5849a2-4136-51ae-99c1-fb9ac84655f1', '93ea4153-1c51-5640-b46b-fa846e931d02', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'db5849a2-4136-51ae-99c1-fb9ac84655f1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('40d49d84-4011-5e9b-b94d-2990f14eaf88', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-13', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', 'a727b9f3-2ba9-5d5e-8937-fe82feefc904', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a727b9f3-2ba9-5d5e-8937-fe82feefc904';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('40d49d84-4011-5e9b-b94d-2990f14eaf88', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('40d49d84-4011-5e9b-b94d-2990f14eaf88', 'a727b9f3-2ba9-5d5e-8937-fe82feefc904', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '40d49d84-4011-5e9b-b94d-2990f14eaf88';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('385afdf8-bfc0-5943-babf-93dc7a2dbfc8', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-14', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', 'bbfff85b-f69a-521f-80ee-6683d3c502bc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'bbfff85b-f69a-521f-80ee-6683d3c502bc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('385afdf8-bfc0-5943-babf-93dc7a2dbfc8', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('385afdf8-bfc0-5943-babf-93dc7a2dbfc8', 'bbfff85b-f69a-521f-80ee-6683d3c502bc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '385afdf8-bfc0-5943-babf-93dc7a2dbfc8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('75bb20c7-a9ef-5ed0-88fa-c62c3a0280aa', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-15', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', 'f8e3215a-e7dd-5518-84d0-64c77553802a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f8e3215a-e7dd-5518-84d0-64c77553802a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('75bb20c7-a9ef-5ed0-88fa-c62c3a0280aa', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('75bb20c7-a9ef-5ed0-88fa-c62c3a0280aa', 'f8e3215a-e7dd-5518-84d0-64c77553802a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '75bb20c7-a9ef-5ed0-88fa-c62c3a0280aa';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7a4130a3-c636-5e57-907d-946c14b66f81', 'benchmark-funding-f7aaa5c2-06fe-40e5-aea9-1bc377576ccd-16', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', '668c6f32-de97-591c-93cf-f204a45c9e10', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '910699f8-c8ba-5322-8cc7-2de83bd86e7c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '668c6f32-de97-591c-93cf-f204a45c9e10';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7a4130a3-c636-5e57-907d-946c14b66f81', '910699f8-c8ba-5322-8cc7-2de83bd86e7c', -1000000000), ('7a4130a3-c636-5e57-907d-946c14b66f81', '668c6f32-de97-591c-93cf-f204a45c9e10', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7a4130a3-c636-5e57-907d-946c14b66f81';
COMMIT;
