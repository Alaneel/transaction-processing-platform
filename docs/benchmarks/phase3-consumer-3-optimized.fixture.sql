-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('0c2bd5d2-733d-59bc-83ff-e00cf95d9988', 'USER', 'ACTIVE', 'FIC'),
('17921608-65a4-5e14-a188-421e043d6e3f', 'USER', 'ACTIVE', 'FIC'),
('1a5e3f63-f241-5eab-920e-3d0dfbe28e30', 'USER', 'ACTIVE', 'FIC'),
('1b28474b-564b-5d2e-b8bf-99b89251673f', 'ISSUANCE', 'ACTIVE', 'FIC'),
('1ef07b59-c609-5bc3-b936-d9924da78c2e', 'USER', 'ACTIVE', 'FIC'),
('220110bd-73b8-547a-abd1-dd1365032b98', 'USER', 'ACTIVE', 'FIC'),
('297e0460-e12a-50a9-841f-d13fd2bad7dc', 'USER', 'ACTIVE', 'FIC'),
('305b3a08-06a4-52dd-96df-9aedaef90e31', 'USER', 'ACTIVE', 'FIC'),
('3c343f41-546a-5e89-bcf4-5f056e5588e9', 'USER', 'ACTIVE', 'FIC'),
('45642254-e4a9-57e7-930e-0245f2421b15', 'USER', 'ACTIVE', 'FIC'),
('4e8c90a2-e449-5f0a-9cb6-dc031f166ac0', 'USER', 'ACTIVE', 'FIC'),
('547bac1b-5df4-5848-8124-543336eb7287', 'USER', 'ACTIVE', 'FIC'),
('55c54d15-851b-5ff8-b914-ed65a727d8a7', 'USER', 'ACTIVE', 'FIC'),
('6ad99a99-a951-5e57-b982-5b02fc70a1a2', 'USER', 'ACTIVE', 'FIC'),
('6e80d0f4-fc69-562e-8494-0ae6b973ed76', 'USER', 'ACTIVE', 'FIC'),
('6f79594a-9e93-5c87-8dba-2585e09d2be0', 'USER', 'ACTIVE', 'FIC'),
('6fca0488-1832-50eb-a78e-69d8377e88a3', 'USER', 'ACTIVE', 'FIC'),
('7cb603f9-9bb5-5d1d-9af2-9df887b1df59', 'USER', 'ACTIVE', 'FIC'),
('9bea0dee-4831-58d0-9ae0-5c2a4005ff53', 'USER', 'ACTIVE', 'FIC'),
('a2b0bbdd-689e-5e0d-8484-713ad321d887', 'USER', 'ACTIVE', 'FIC'),
('a86176ff-8494-50be-bbca-add482eeb224', 'USER', 'ACTIVE', 'FIC'),
('cdb2a2bb-9e8d-55e5-868d-9ae35e8a4712', 'USER', 'ACTIVE', 'FIC'),
('df85de48-f0d7-53f0-b16a-bcc4af8f3b3e', 'USER', 'ACTIVE', 'FIC'),
('e4c5a3f0-5fef-533e-9be1-9157f3f2af11', 'USER', 'ACTIVE', 'FIC'),
('e7dfa321-aa5e-5798-905f-e2130c4bf040', 'USER', 'ACTIVE', 'FIC'),
('ec813bbc-c1c7-55c3-b520-e0af87e7c382', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('0c2bd5d2-733d-59bc-83ff-e00cf95d9988', 0),
('17921608-65a4-5e14-a188-421e043d6e3f', 0),
('1a5e3f63-f241-5eab-920e-3d0dfbe28e30', 0),
('1b28474b-564b-5d2e-b8bf-99b89251673f', 0),
('1ef07b59-c609-5bc3-b936-d9924da78c2e', 0),
('220110bd-73b8-547a-abd1-dd1365032b98', 0),
('297e0460-e12a-50a9-841f-d13fd2bad7dc', 0),
('305b3a08-06a4-52dd-96df-9aedaef90e31', 0),
('3c343f41-546a-5e89-bcf4-5f056e5588e9', 0),
('45642254-e4a9-57e7-930e-0245f2421b15', 0),
('4e8c90a2-e449-5f0a-9cb6-dc031f166ac0', 0),
('547bac1b-5df4-5848-8124-543336eb7287', 0),
('55c54d15-851b-5ff8-b914-ed65a727d8a7', 0),
('6ad99a99-a951-5e57-b982-5b02fc70a1a2', 0),
('6e80d0f4-fc69-562e-8494-0ae6b973ed76', 0),
('6f79594a-9e93-5c87-8dba-2585e09d2be0', 0),
('6fca0488-1832-50eb-a78e-69d8377e88a3', 0),
('7cb603f9-9bb5-5d1d-9af2-9df887b1df59', 0),
('9bea0dee-4831-58d0-9ae0-5c2a4005ff53', 0),
('a2b0bbdd-689e-5e0d-8484-713ad321d887', 0),
('a86176ff-8494-50be-bbca-add482eeb224', 0),
('cdb2a2bb-9e8d-55e5-868d-9ae35e8a4712', 0),
('df85de48-f0d7-53f0-b16a-bcc4af8f3b3e', 0),
('e4c5a3f0-5fef-533e-9be1-9157f3f2af11', 0),
('e7dfa321-aa5e-5798-905f-e2130c4bf040', 0),
('ec813bbc-c1c7-55c3-b520-e0af87e7c382', 0);
SELECT account_id FROM balances WHERE account_id IN ('0c2bd5d2-733d-59bc-83ff-e00cf95d9988','17921608-65a4-5e14-a188-421e043d6e3f','1a5e3f63-f241-5eab-920e-3d0dfbe28e30','1b28474b-564b-5d2e-b8bf-99b89251673f','1ef07b59-c609-5bc3-b936-d9924da78c2e','220110bd-73b8-547a-abd1-dd1365032b98','297e0460-e12a-50a9-841f-d13fd2bad7dc','305b3a08-06a4-52dd-96df-9aedaef90e31','3c343f41-546a-5e89-bcf4-5f056e5588e9','45642254-e4a9-57e7-930e-0245f2421b15','4e8c90a2-e449-5f0a-9cb6-dc031f166ac0','547bac1b-5df4-5848-8124-543336eb7287','55c54d15-851b-5ff8-b914-ed65a727d8a7','6ad99a99-a951-5e57-b982-5b02fc70a1a2','6e80d0f4-fc69-562e-8494-0ae6b973ed76','6f79594a-9e93-5c87-8dba-2585e09d2be0','6fca0488-1832-50eb-a78e-69d8377e88a3','7cb603f9-9bb5-5d1d-9af2-9df887b1df59','9bea0dee-4831-58d0-9ae0-5c2a4005ff53','a2b0bbdd-689e-5e0d-8484-713ad321d887','a86176ff-8494-50be-bbca-add482eeb224','cdb2a2bb-9e8d-55e5-868d-9ae35e8a4712','df85de48-f0d7-53f0-b16a-bcc4af8f3b3e','e4c5a3f0-5fef-533e-9be1-9157f3f2af11','e7dfa321-aa5e-5798-905f-e2130c4bf040','ec813bbc-c1c7-55c3-b520-e0af87e7c382') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a2603d74-35f6-567c-a150-c729d911a2a7', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-0', '1b28474b-564b-5d2e-b8bf-99b89251673f', 'a86176ff-8494-50be-bbca-add482eeb224', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a86176ff-8494-50be-bbca-add482eeb224';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a2603d74-35f6-567c-a150-c729d911a2a7', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('a2603d74-35f6-567c-a150-c729d911a2a7', 'a86176ff-8494-50be-bbca-add482eeb224', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a2603d74-35f6-567c-a150-c729d911a2a7';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('be9ed870-7bbc-528f-beb3-7c424c209b84', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-1', '1b28474b-564b-5d2e-b8bf-99b89251673f', '6f79594a-9e93-5c87-8dba-2585e09d2be0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6f79594a-9e93-5c87-8dba-2585e09d2be0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('be9ed870-7bbc-528f-beb3-7c424c209b84', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('be9ed870-7bbc-528f-beb3-7c424c209b84', '6f79594a-9e93-5c87-8dba-2585e09d2be0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'be9ed870-7bbc-528f-beb3-7c424c209b84';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c9a66c43-4bf2-5743-be8e-ea350520017e', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-2', '1b28474b-564b-5d2e-b8bf-99b89251673f', '297e0460-e12a-50a9-841f-d13fd2bad7dc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '297e0460-e12a-50a9-841f-d13fd2bad7dc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c9a66c43-4bf2-5743-be8e-ea350520017e', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('c9a66c43-4bf2-5743-be8e-ea350520017e', '297e0460-e12a-50a9-841f-d13fd2bad7dc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c9a66c43-4bf2-5743-be8e-ea350520017e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1ba8fe59-7787-5f74-a23b-acdd89752573', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-3', '1b28474b-564b-5d2e-b8bf-99b89251673f', '0c2bd5d2-733d-59bc-83ff-e00cf95d9988', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0c2bd5d2-733d-59bc-83ff-e00cf95d9988';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1ba8fe59-7787-5f74-a23b-acdd89752573', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('1ba8fe59-7787-5f74-a23b-acdd89752573', '0c2bd5d2-733d-59bc-83ff-e00cf95d9988', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1ba8fe59-7787-5f74-a23b-acdd89752573';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e9b03362-e556-5477-9fa0-fed7e6775ea0', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-4', '1b28474b-564b-5d2e-b8bf-99b89251673f', '17921608-65a4-5e14-a188-421e043d6e3f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '17921608-65a4-5e14-a188-421e043d6e3f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e9b03362-e556-5477-9fa0-fed7e6775ea0', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('e9b03362-e556-5477-9fa0-fed7e6775ea0', '17921608-65a4-5e14-a188-421e043d6e3f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e9b03362-e556-5477-9fa0-fed7e6775ea0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('bc5bf36b-db1f-5dd8-a53f-93eff8201159', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-5', '1b28474b-564b-5d2e-b8bf-99b89251673f', '305b3a08-06a4-52dd-96df-9aedaef90e31', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '305b3a08-06a4-52dd-96df-9aedaef90e31';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('bc5bf36b-db1f-5dd8-a53f-93eff8201159', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('bc5bf36b-db1f-5dd8-a53f-93eff8201159', '305b3a08-06a4-52dd-96df-9aedaef90e31', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'bc5bf36b-db1f-5dd8-a53f-93eff8201159';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('598ce508-96b1-5679-9898-e663109eee8e', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-6', '1b28474b-564b-5d2e-b8bf-99b89251673f', '6fca0488-1832-50eb-a78e-69d8377e88a3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6fca0488-1832-50eb-a78e-69d8377e88a3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('598ce508-96b1-5679-9898-e663109eee8e', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('598ce508-96b1-5679-9898-e663109eee8e', '6fca0488-1832-50eb-a78e-69d8377e88a3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '598ce508-96b1-5679-9898-e663109eee8e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4b6001f1-c4b0-5dfa-aa40-dc4a5e006bc2', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-7', '1b28474b-564b-5d2e-b8bf-99b89251673f', 'e4c5a3f0-5fef-533e-9be1-9157f3f2af11', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e4c5a3f0-5fef-533e-9be1-9157f3f2af11';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4b6001f1-c4b0-5dfa-aa40-dc4a5e006bc2', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('4b6001f1-c4b0-5dfa-aa40-dc4a5e006bc2', 'e4c5a3f0-5fef-533e-9be1-9157f3f2af11', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4b6001f1-c4b0-5dfa-aa40-dc4a5e006bc2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('031eb278-36bf-5ef6-aa8f-094064e4db37', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-8', '1b28474b-564b-5d2e-b8bf-99b89251673f', '6ad99a99-a951-5e57-b982-5b02fc70a1a2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6ad99a99-a951-5e57-b982-5b02fc70a1a2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('031eb278-36bf-5ef6-aa8f-094064e4db37', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('031eb278-36bf-5ef6-aa8f-094064e4db37', '6ad99a99-a951-5e57-b982-5b02fc70a1a2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '031eb278-36bf-5ef6-aa8f-094064e4db37';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e7d59c44-e039-59a5-a2ed-000898b73de3', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-9', '1b28474b-564b-5d2e-b8bf-99b89251673f', 'cdb2a2bb-9e8d-55e5-868d-9ae35e8a4712', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'cdb2a2bb-9e8d-55e5-868d-9ae35e8a4712';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e7d59c44-e039-59a5-a2ed-000898b73de3', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('e7d59c44-e039-59a5-a2ed-000898b73de3', 'cdb2a2bb-9e8d-55e5-868d-9ae35e8a4712', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e7d59c44-e039-59a5-a2ed-000898b73de3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('362f4d98-c513-502b-bcff-567cada8e0ff', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-10', '1b28474b-564b-5d2e-b8bf-99b89251673f', '3c343f41-546a-5e89-bcf4-5f056e5588e9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3c343f41-546a-5e89-bcf4-5f056e5588e9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('362f4d98-c513-502b-bcff-567cada8e0ff', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('362f4d98-c513-502b-bcff-567cada8e0ff', '3c343f41-546a-5e89-bcf4-5f056e5588e9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '362f4d98-c513-502b-bcff-567cada8e0ff';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('63b9817d-7ac5-57e0-9d09-83fd5a317913', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-11', '1b28474b-564b-5d2e-b8bf-99b89251673f', '45642254-e4a9-57e7-930e-0245f2421b15', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '45642254-e4a9-57e7-930e-0245f2421b15';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('63b9817d-7ac5-57e0-9d09-83fd5a317913', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('63b9817d-7ac5-57e0-9d09-83fd5a317913', '45642254-e4a9-57e7-930e-0245f2421b15', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '63b9817d-7ac5-57e0-9d09-83fd5a317913';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c8f2f835-d5a2-5e95-92c8-89ea596adcd5', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-12', '1b28474b-564b-5d2e-b8bf-99b89251673f', 'df85de48-f0d7-53f0-b16a-bcc4af8f3b3e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'df85de48-f0d7-53f0-b16a-bcc4af8f3b3e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c8f2f835-d5a2-5e95-92c8-89ea596adcd5', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('c8f2f835-d5a2-5e95-92c8-89ea596adcd5', 'df85de48-f0d7-53f0-b16a-bcc4af8f3b3e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c8f2f835-d5a2-5e95-92c8-89ea596adcd5';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('588cb47c-8ded-545d-bae6-1235e1fcf854', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-13', '1b28474b-564b-5d2e-b8bf-99b89251673f', '547bac1b-5df4-5848-8124-543336eb7287', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '547bac1b-5df4-5848-8124-543336eb7287';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('588cb47c-8ded-545d-bae6-1235e1fcf854', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('588cb47c-8ded-545d-bae6-1235e1fcf854', '547bac1b-5df4-5848-8124-543336eb7287', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '588cb47c-8ded-545d-bae6-1235e1fcf854';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('27fbfc64-b80d-50d3-bdbf-ccd2d158f7e3', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-14', '1b28474b-564b-5d2e-b8bf-99b89251673f', 'ec813bbc-c1c7-55c3-b520-e0af87e7c382', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ec813bbc-c1c7-55c3-b520-e0af87e7c382';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('27fbfc64-b80d-50d3-bdbf-ccd2d158f7e3', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('27fbfc64-b80d-50d3-bdbf-ccd2d158f7e3', 'ec813bbc-c1c7-55c3-b520-e0af87e7c382', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '27fbfc64-b80d-50d3-bdbf-ccd2d158f7e3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('40b31177-f3ab-5e20-811d-b795e129c6ad', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-15', '1b28474b-564b-5d2e-b8bf-99b89251673f', 'a2b0bbdd-689e-5e0d-8484-713ad321d887', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a2b0bbdd-689e-5e0d-8484-713ad321d887';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('40b31177-f3ab-5e20-811d-b795e129c6ad', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('40b31177-f3ab-5e20-811d-b795e129c6ad', 'a2b0bbdd-689e-5e0d-8484-713ad321d887', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '40b31177-f3ab-5e20-811d-b795e129c6ad';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('89bd5536-b705-5c50-bdb7-bbd8ee1c82aa', 'benchmark-funding-54b4355d-ad4d-413a-98d7-b6308a2e53b5-16', '1b28474b-564b-5d2e-b8bf-99b89251673f', '9bea0dee-4831-58d0-9ae0-5c2a4005ff53', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '1b28474b-564b-5d2e-b8bf-99b89251673f';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9bea0dee-4831-58d0-9ae0-5c2a4005ff53';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('89bd5536-b705-5c50-bdb7-bbd8ee1c82aa', '1b28474b-564b-5d2e-b8bf-99b89251673f', -1000000000), ('89bd5536-b705-5c50-bdb7-bbd8ee1c82aa', '9bea0dee-4831-58d0-9ae0-5c2a4005ff53', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '89bd5536-b705-5c50-bdb7-bbd8ee1c82aa';
COMMIT;
