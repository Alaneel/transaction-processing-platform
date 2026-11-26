-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('0ca461f2-f8aa-542f-875c-f71f4ee7bf68', 'USER', 'ACTIVE', 'FIC'),
('1354dba7-ab9e-5a00-9014-6db1ecbe3eec', 'USER', 'ACTIVE', 'FIC'),
('2fe77afa-a647-5b0d-9a87-1b37dd047b78', 'USER', 'ACTIVE', 'FIC'),
('321d8a5c-1d5c-50bd-be0a-73b40b355cf1', 'USER', 'ACTIVE', 'FIC'),
('34629f3b-daef-5b5e-a9a4-c573e4787539', 'USER', 'ACTIVE', 'FIC'),
('3c0ec3c8-2580-5dcf-8831-c9b21f321361', 'USER', 'ACTIVE', 'FIC'),
('41a080df-3c20-5a6f-8b29-42429d6422b1', 'USER', 'ACTIVE', 'FIC'),
('54fae743-04e4-580f-b0ce-7797671efa04', 'ISSUANCE', 'ACTIVE', 'FIC'),
('55cd06ce-e396-59cb-9ad9-ae162a2c4ab5', 'USER', 'ACTIVE', 'FIC'),
('5b883f5f-bdcc-5874-93d3-91d68f034fcc', 'USER', 'ACTIVE', 'FIC'),
('625fccfe-982c-52c3-bab7-497f04cb8b4c', 'USER', 'ACTIVE', 'FIC'),
('6648c668-849b-5332-8da2-e14f747503e1', 'USER', 'ACTIVE', 'FIC'),
('6840f428-a44a-50b0-b65a-556d94410364', 'USER', 'ACTIVE', 'FIC'),
('8b0acf90-71f2-54ee-bdfb-8a37fe70d285', 'USER', 'ACTIVE', 'FIC'),
('9204240b-ea49-5280-80c0-0630d378a361', 'USER', 'ACTIVE', 'FIC'),
('a28009e9-7985-593c-be5a-2ed4aeb65909', 'USER', 'ACTIVE', 'FIC'),
('ace16e69-f5d0-58e5-acee-b51245216a54', 'USER', 'ACTIVE', 'FIC'),
('c29e4a87-8ec5-56fe-a22e-663d0c2d5687', 'USER', 'ACTIVE', 'FIC'),
('cd244eb0-3df6-55c8-9ff9-91d7e59cae3a', 'USER', 'ACTIVE', 'FIC'),
('d73a6dab-4986-5bd7-a322-80bcc7806519', 'USER', 'ACTIVE', 'FIC'),
('e380efc3-07c7-5150-bfd1-5a3ea15b5659', 'USER', 'ACTIVE', 'FIC'),
('f00da5e7-c19a-595e-b3dd-4a7640b87db9', 'USER', 'ACTIVE', 'FIC'),
('f05eec80-8b0a-5381-a577-16b82da79869', 'USER', 'ACTIVE', 'FIC'),
('f9a2dc89-1257-576f-930a-bf0154dcfe50', 'USER', 'ACTIVE', 'FIC'),
('fc18457d-5e40-545f-83bc-38aa9f25de68', 'USER', 'ACTIVE', 'FIC'),
('fc9a50d4-5d45-5a98-b441-e7fe107c754d', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('0ca461f2-f8aa-542f-875c-f71f4ee7bf68', 0),
('1354dba7-ab9e-5a00-9014-6db1ecbe3eec', 0),
('2fe77afa-a647-5b0d-9a87-1b37dd047b78', 0),
('321d8a5c-1d5c-50bd-be0a-73b40b355cf1', 0),
('34629f3b-daef-5b5e-a9a4-c573e4787539', 0),
('3c0ec3c8-2580-5dcf-8831-c9b21f321361', 0),
('41a080df-3c20-5a6f-8b29-42429d6422b1', 0),
('54fae743-04e4-580f-b0ce-7797671efa04', 0),
('55cd06ce-e396-59cb-9ad9-ae162a2c4ab5', 0),
('5b883f5f-bdcc-5874-93d3-91d68f034fcc', 0),
('625fccfe-982c-52c3-bab7-497f04cb8b4c', 0),
('6648c668-849b-5332-8da2-e14f747503e1', 0),
('6840f428-a44a-50b0-b65a-556d94410364', 0),
('8b0acf90-71f2-54ee-bdfb-8a37fe70d285', 0),
('9204240b-ea49-5280-80c0-0630d378a361', 0),
('a28009e9-7985-593c-be5a-2ed4aeb65909', 0),
('ace16e69-f5d0-58e5-acee-b51245216a54', 0),
('c29e4a87-8ec5-56fe-a22e-663d0c2d5687', 0),
('cd244eb0-3df6-55c8-9ff9-91d7e59cae3a', 0),
('d73a6dab-4986-5bd7-a322-80bcc7806519', 0),
('e380efc3-07c7-5150-bfd1-5a3ea15b5659', 0),
('f00da5e7-c19a-595e-b3dd-4a7640b87db9', 0),
('f05eec80-8b0a-5381-a577-16b82da79869', 0),
('f9a2dc89-1257-576f-930a-bf0154dcfe50', 0),
('fc18457d-5e40-545f-83bc-38aa9f25de68', 0),
('fc9a50d4-5d45-5a98-b441-e7fe107c754d', 0);
SELECT account_id FROM balances WHERE account_id IN ('0ca461f2-f8aa-542f-875c-f71f4ee7bf68','1354dba7-ab9e-5a00-9014-6db1ecbe3eec','2fe77afa-a647-5b0d-9a87-1b37dd047b78','321d8a5c-1d5c-50bd-be0a-73b40b355cf1','34629f3b-daef-5b5e-a9a4-c573e4787539','3c0ec3c8-2580-5dcf-8831-c9b21f321361','41a080df-3c20-5a6f-8b29-42429d6422b1','54fae743-04e4-580f-b0ce-7797671efa04','55cd06ce-e396-59cb-9ad9-ae162a2c4ab5','5b883f5f-bdcc-5874-93d3-91d68f034fcc','625fccfe-982c-52c3-bab7-497f04cb8b4c','6648c668-849b-5332-8da2-e14f747503e1','6840f428-a44a-50b0-b65a-556d94410364','8b0acf90-71f2-54ee-bdfb-8a37fe70d285','9204240b-ea49-5280-80c0-0630d378a361','a28009e9-7985-593c-be5a-2ed4aeb65909','ace16e69-f5d0-58e5-acee-b51245216a54','c29e4a87-8ec5-56fe-a22e-663d0c2d5687','cd244eb0-3df6-55c8-9ff9-91d7e59cae3a','d73a6dab-4986-5bd7-a322-80bcc7806519','e380efc3-07c7-5150-bfd1-5a3ea15b5659','f00da5e7-c19a-595e-b3dd-4a7640b87db9','f05eec80-8b0a-5381-a577-16b82da79869','f9a2dc89-1257-576f-930a-bf0154dcfe50','fc18457d-5e40-545f-83bc-38aa9f25de68','fc9a50d4-5d45-5a98-b441-e7fe107c754d') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7fa9a401-96ff-5883-8ed6-e5e52b779dd3', 'benchmark-funding-ad1a75ce-2b25-46da-8705-849ad3006ba3-0', '54fae743-04e4-580f-b0ce-7797671efa04', 'd73a6dab-4986-5bd7-a322-80bcc7806519', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '54fae743-04e4-580f-b0ce-7797671efa04';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd73a6dab-4986-5bd7-a322-80bcc7806519';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7fa9a401-96ff-5883-8ed6-e5e52b779dd3', '54fae743-04e4-580f-b0ce-7797671efa04', -1000000000), ('7fa9a401-96ff-5883-8ed6-e5e52b779dd3', 'd73a6dab-4986-5bd7-a322-80bcc7806519', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7fa9a401-96ff-5883-8ed6-e5e52b779dd3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9d645817-1e34-5316-a7c0-bae02fc5e2c3', 'benchmark-funding-ad1a75ce-2b25-46da-8705-849ad3006ba3-1', '54fae743-04e4-580f-b0ce-7797671efa04', '6840f428-a44a-50b0-b65a-556d94410364', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '54fae743-04e4-580f-b0ce-7797671efa04';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6840f428-a44a-50b0-b65a-556d94410364';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9d645817-1e34-5316-a7c0-bae02fc5e2c3', '54fae743-04e4-580f-b0ce-7797671efa04', -1000000000), ('9d645817-1e34-5316-a7c0-bae02fc5e2c3', '6840f428-a44a-50b0-b65a-556d94410364', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9d645817-1e34-5316-a7c0-bae02fc5e2c3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('50ea7ec4-f65f-580d-a60a-c47beeb58394', 'benchmark-funding-ad1a75ce-2b25-46da-8705-849ad3006ba3-2', '54fae743-04e4-580f-b0ce-7797671efa04', '0ca461f2-f8aa-542f-875c-f71f4ee7bf68', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '54fae743-04e4-580f-b0ce-7797671efa04';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0ca461f2-f8aa-542f-875c-f71f4ee7bf68';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('50ea7ec4-f65f-580d-a60a-c47beeb58394', '54fae743-04e4-580f-b0ce-7797671efa04', -1000000000), ('50ea7ec4-f65f-580d-a60a-c47beeb58394', '0ca461f2-f8aa-542f-875c-f71f4ee7bf68', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '50ea7ec4-f65f-580d-a60a-c47beeb58394';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d72d62b6-dc7a-5730-abac-545de0eb3873', 'benchmark-funding-ad1a75ce-2b25-46da-8705-849ad3006ba3-3', '54fae743-04e4-580f-b0ce-7797671efa04', '3c0ec3c8-2580-5dcf-8831-c9b21f321361', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '54fae743-04e4-580f-b0ce-7797671efa04';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3c0ec3c8-2580-5dcf-8831-c9b21f321361';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d72d62b6-dc7a-5730-abac-545de0eb3873', '54fae743-04e4-580f-b0ce-7797671efa04', -1000000000), ('d72d62b6-dc7a-5730-abac-545de0eb3873', '3c0ec3c8-2580-5dcf-8831-c9b21f321361', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd72d62b6-dc7a-5730-abac-545de0eb3873';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('2179e64d-13e4-5470-9231-1d264f1ff001', 'benchmark-funding-ad1a75ce-2b25-46da-8705-849ad3006ba3-4', '54fae743-04e4-580f-b0ce-7797671efa04', 'f9a2dc89-1257-576f-930a-bf0154dcfe50', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '54fae743-04e4-580f-b0ce-7797671efa04';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f9a2dc89-1257-576f-930a-bf0154dcfe50';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('2179e64d-13e4-5470-9231-1d264f1ff001', '54fae743-04e4-580f-b0ce-7797671efa04', -1000000000), ('2179e64d-13e4-5470-9231-1d264f1ff001', 'f9a2dc89-1257-576f-930a-bf0154dcfe50', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '2179e64d-13e4-5470-9231-1d264f1ff001';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1163ad25-d934-548e-828d-4cd0ed644a80', 'benchmark-funding-ad1a75ce-2b25-46da-8705-849ad3006ba3-5', '54fae743-04e4-580f-b0ce-7797671efa04', 'fc9a50d4-5d45-5a98-b441-e7fe107c754d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '54fae743-04e4-580f-b0ce-7797671efa04';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fc9a50d4-5d45-5a98-b441-e7fe107c754d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1163ad25-d934-548e-828d-4cd0ed644a80', '54fae743-04e4-580f-b0ce-7797671efa04', -1000000000), ('1163ad25-d934-548e-828d-4cd0ed644a80', 'fc9a50d4-5d45-5a98-b441-e7fe107c754d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1163ad25-d934-548e-828d-4cd0ed644a80';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('716c133f-b35a-51a7-b7da-a5df8b50a1f1', 'benchmark-funding-ad1a75ce-2b25-46da-8705-849ad3006ba3-6', '54fae743-04e4-580f-b0ce-7797671efa04', '55cd06ce-e396-59cb-9ad9-ae162a2c4ab5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '54fae743-04e4-580f-b0ce-7797671efa04';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '55cd06ce-e396-59cb-9ad9-ae162a2c4ab5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('716c133f-b35a-51a7-b7da-a5df8b50a1f1', '54fae743-04e4-580f-b0ce-7797671efa04', -1000000000), ('716c133f-b35a-51a7-b7da-a5df8b50a1f1', '55cd06ce-e396-59cb-9ad9-ae162a2c4ab5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '716c133f-b35a-51a7-b7da-a5df8b50a1f1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('638390b7-3ca5-5042-bfd7-4b430e64287b', 'benchmark-funding-ad1a75ce-2b25-46da-8705-849ad3006ba3-7', '54fae743-04e4-580f-b0ce-7797671efa04', '1354dba7-ab9e-5a00-9014-6db1ecbe3eec', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '54fae743-04e4-580f-b0ce-7797671efa04';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1354dba7-ab9e-5a00-9014-6db1ecbe3eec';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('638390b7-3ca5-5042-bfd7-4b430e64287b', '54fae743-04e4-580f-b0ce-7797671efa04', -1000000000), ('638390b7-3ca5-5042-bfd7-4b430e64287b', '1354dba7-ab9e-5a00-9014-6db1ecbe3eec', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '638390b7-3ca5-5042-bfd7-4b430e64287b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('45e1f4d1-418d-5f49-9fa0-b0b237abc4f7', 'benchmark-funding-ad1a75ce-2b25-46da-8705-849ad3006ba3-8', '54fae743-04e4-580f-b0ce-7797671efa04', '5b883f5f-bdcc-5874-93d3-91d68f034fcc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '54fae743-04e4-580f-b0ce-7797671efa04';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5b883f5f-bdcc-5874-93d3-91d68f034fcc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('45e1f4d1-418d-5f49-9fa0-b0b237abc4f7', '54fae743-04e4-580f-b0ce-7797671efa04', -1000000000), ('45e1f4d1-418d-5f49-9fa0-b0b237abc4f7', '5b883f5f-bdcc-5874-93d3-91d68f034fcc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '45e1f4d1-418d-5f49-9fa0-b0b237abc4f7';
COMMIT;
