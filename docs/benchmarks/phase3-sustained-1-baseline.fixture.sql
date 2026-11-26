-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('17bf1a85-6692-52fa-83fc-41c07f4d7b2d', 'USER', 'ACTIVE', 'FIC'),
('1fafccc5-39ff-55fa-91c0-61227da6f7d3', 'USER', 'ACTIVE', 'FIC'),
('254d8d7a-b2da-5749-bbea-eae1d9df36ad', 'USER', 'ACTIVE', 'FIC'),
('305cb7a0-5c1a-5d00-994b-45ea52892f7f', 'USER', 'ACTIVE', 'FIC'),
('345563c6-5206-5bf0-acb3-1a50e8b3cc9c', 'USER', 'ACTIVE', 'FIC'),
('45545cfb-8009-56ad-b771-519b956f795c', 'ISSUANCE', 'ACTIVE', 'FIC'),
('4867ac38-3ded-5f1b-bc71-1aeadea8d53d', 'USER', 'ACTIVE', 'FIC'),
('51902502-14bc-58fc-83a9-cf8cf9d9f51b', 'USER', 'ACTIVE', 'FIC'),
('53b7e32c-8ad0-5fb6-aab6-230ef181c9e8', 'USER', 'ACTIVE', 'FIC'),
('593f6217-0881-5f81-808d-d340398ff105', 'USER', 'ACTIVE', 'FIC'),
('76e3a54c-306a-54e2-894c-02df4afe2511', 'USER', 'ACTIVE', 'FIC'),
('899b7ca1-8218-5c0f-b287-44922fe14aca', 'USER', 'ACTIVE', 'FIC'),
('8fb9963a-a516-5210-b9ae-d2b8541af501', 'USER', 'ACTIVE', 'FIC'),
('9b05d328-76b7-5da7-a2d2-5de0ca715da2', 'USER', 'ACTIVE', 'FIC'),
('a29ed0dc-c95e-5730-a382-d683aa26d582', 'USER', 'ACTIVE', 'FIC'),
('bcc065d9-a8d4-5d39-852a-0466ab3257cc', 'USER', 'ACTIVE', 'FIC'),
('cea821f8-4569-5872-90a2-aa7466aad539', 'USER', 'ACTIVE', 'FIC'),
('d1631663-5c9a-5b9b-a6df-256b4f0876ec', 'USER', 'ACTIVE', 'FIC'),
('dc3f2fa5-90a5-5521-9271-afdf0a461656', 'USER', 'ACTIVE', 'FIC'),
('de743960-e8a6-5e70-94d7-477faf725c22', 'USER', 'ACTIVE', 'FIC'),
('e5a55a34-f3a8-579e-9d4d-2b8ef28a6519', 'USER', 'ACTIVE', 'FIC'),
('e746b281-c429-53df-885a-f42a3d5e1b59', 'USER', 'ACTIVE', 'FIC'),
('e9661ce9-4ab8-512a-b5c9-82e2f5b9a9c6', 'USER', 'ACTIVE', 'FIC'),
('ebf8cbe5-6755-5218-94e2-e16394e36d51', 'USER', 'ACTIVE', 'FIC'),
('fb98b7bf-146f-568e-93a2-6b453df5a571', 'USER', 'ACTIVE', 'FIC'),
('fdaaa657-7299-5f37-85a2-bdc9555acde0', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('17bf1a85-6692-52fa-83fc-41c07f4d7b2d', 0),
('1fafccc5-39ff-55fa-91c0-61227da6f7d3', 0),
('254d8d7a-b2da-5749-bbea-eae1d9df36ad', 0),
('305cb7a0-5c1a-5d00-994b-45ea52892f7f', 0),
('345563c6-5206-5bf0-acb3-1a50e8b3cc9c', 0),
('45545cfb-8009-56ad-b771-519b956f795c', 0),
('4867ac38-3ded-5f1b-bc71-1aeadea8d53d', 0),
('51902502-14bc-58fc-83a9-cf8cf9d9f51b', 0),
('53b7e32c-8ad0-5fb6-aab6-230ef181c9e8', 0),
('593f6217-0881-5f81-808d-d340398ff105', 0),
('76e3a54c-306a-54e2-894c-02df4afe2511', 0),
('899b7ca1-8218-5c0f-b287-44922fe14aca', 0),
('8fb9963a-a516-5210-b9ae-d2b8541af501', 0),
('9b05d328-76b7-5da7-a2d2-5de0ca715da2', 0),
('a29ed0dc-c95e-5730-a382-d683aa26d582', 0),
('bcc065d9-a8d4-5d39-852a-0466ab3257cc', 0),
('cea821f8-4569-5872-90a2-aa7466aad539', 0),
('d1631663-5c9a-5b9b-a6df-256b4f0876ec', 0),
('dc3f2fa5-90a5-5521-9271-afdf0a461656', 0),
('de743960-e8a6-5e70-94d7-477faf725c22', 0),
('e5a55a34-f3a8-579e-9d4d-2b8ef28a6519', 0),
('e746b281-c429-53df-885a-f42a3d5e1b59', 0),
('e9661ce9-4ab8-512a-b5c9-82e2f5b9a9c6', 0),
('ebf8cbe5-6755-5218-94e2-e16394e36d51', 0),
('fb98b7bf-146f-568e-93a2-6b453df5a571', 0),
('fdaaa657-7299-5f37-85a2-bdc9555acde0', 0);
SELECT account_id FROM balances WHERE account_id IN ('17bf1a85-6692-52fa-83fc-41c07f4d7b2d','1fafccc5-39ff-55fa-91c0-61227da6f7d3','254d8d7a-b2da-5749-bbea-eae1d9df36ad','305cb7a0-5c1a-5d00-994b-45ea52892f7f','345563c6-5206-5bf0-acb3-1a50e8b3cc9c','45545cfb-8009-56ad-b771-519b956f795c','4867ac38-3ded-5f1b-bc71-1aeadea8d53d','51902502-14bc-58fc-83a9-cf8cf9d9f51b','53b7e32c-8ad0-5fb6-aab6-230ef181c9e8','593f6217-0881-5f81-808d-d340398ff105','76e3a54c-306a-54e2-894c-02df4afe2511','899b7ca1-8218-5c0f-b287-44922fe14aca','8fb9963a-a516-5210-b9ae-d2b8541af501','9b05d328-76b7-5da7-a2d2-5de0ca715da2','a29ed0dc-c95e-5730-a382-d683aa26d582','bcc065d9-a8d4-5d39-852a-0466ab3257cc','cea821f8-4569-5872-90a2-aa7466aad539','d1631663-5c9a-5b9b-a6df-256b4f0876ec','dc3f2fa5-90a5-5521-9271-afdf0a461656','de743960-e8a6-5e70-94d7-477faf725c22','e5a55a34-f3a8-579e-9d4d-2b8ef28a6519','e746b281-c429-53df-885a-f42a3d5e1b59','e9661ce9-4ab8-512a-b5c9-82e2f5b9a9c6','ebf8cbe5-6755-5218-94e2-e16394e36d51','fb98b7bf-146f-568e-93a2-6b453df5a571','fdaaa657-7299-5f37-85a2-bdc9555acde0') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('71d4aa4d-724e-5e88-bac2-30f8142bf010', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-0', '45545cfb-8009-56ad-b771-519b956f795c', '345563c6-5206-5bf0-acb3-1a50e8b3cc9c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '345563c6-5206-5bf0-acb3-1a50e8b3cc9c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('71d4aa4d-724e-5e88-bac2-30f8142bf010', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('71d4aa4d-724e-5e88-bac2-30f8142bf010', '345563c6-5206-5bf0-acb3-1a50e8b3cc9c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '71d4aa4d-724e-5e88-bac2-30f8142bf010';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('33c1584b-95c4-5623-ae66-99c3258257f6', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-1', '45545cfb-8009-56ad-b771-519b956f795c', 'bcc065d9-a8d4-5d39-852a-0466ab3257cc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'bcc065d9-a8d4-5d39-852a-0466ab3257cc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('33c1584b-95c4-5623-ae66-99c3258257f6', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('33c1584b-95c4-5623-ae66-99c3258257f6', 'bcc065d9-a8d4-5d39-852a-0466ab3257cc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '33c1584b-95c4-5623-ae66-99c3258257f6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a90ec357-3490-5808-a1a9-18fb62928794', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-2', '45545cfb-8009-56ad-b771-519b956f795c', '17bf1a85-6692-52fa-83fc-41c07f4d7b2d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '17bf1a85-6692-52fa-83fc-41c07f4d7b2d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a90ec357-3490-5808-a1a9-18fb62928794', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('a90ec357-3490-5808-a1a9-18fb62928794', '17bf1a85-6692-52fa-83fc-41c07f4d7b2d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a90ec357-3490-5808-a1a9-18fb62928794';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('be94182d-cc40-5577-8d69-787913b096a5', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-3', '45545cfb-8009-56ad-b771-519b956f795c', 'de743960-e8a6-5e70-94d7-477faf725c22', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'de743960-e8a6-5e70-94d7-477faf725c22';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('be94182d-cc40-5577-8d69-787913b096a5', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('be94182d-cc40-5577-8d69-787913b096a5', 'de743960-e8a6-5e70-94d7-477faf725c22', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'be94182d-cc40-5577-8d69-787913b096a5';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ed3cb5d8-71bd-5485-88ac-15cefe32f701', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-4', '45545cfb-8009-56ad-b771-519b956f795c', '305cb7a0-5c1a-5d00-994b-45ea52892f7f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '305cb7a0-5c1a-5d00-994b-45ea52892f7f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ed3cb5d8-71bd-5485-88ac-15cefe32f701', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('ed3cb5d8-71bd-5485-88ac-15cefe32f701', '305cb7a0-5c1a-5d00-994b-45ea52892f7f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ed3cb5d8-71bd-5485-88ac-15cefe32f701';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ee93bd21-c01d-569f-adbd-0fd609577df2', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-5', '45545cfb-8009-56ad-b771-519b956f795c', '593f6217-0881-5f81-808d-d340398ff105', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '593f6217-0881-5f81-808d-d340398ff105';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ee93bd21-c01d-569f-adbd-0fd609577df2', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('ee93bd21-c01d-569f-adbd-0fd609577df2', '593f6217-0881-5f81-808d-d340398ff105', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ee93bd21-c01d-569f-adbd-0fd609577df2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5c75c271-1a2a-58b6-87bc-4843f8828355', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-6', '45545cfb-8009-56ad-b771-519b956f795c', 'cea821f8-4569-5872-90a2-aa7466aad539', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'cea821f8-4569-5872-90a2-aa7466aad539';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5c75c271-1a2a-58b6-87bc-4843f8828355', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('5c75c271-1a2a-58b6-87bc-4843f8828355', 'cea821f8-4569-5872-90a2-aa7466aad539', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5c75c271-1a2a-58b6-87bc-4843f8828355';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d6c6bc05-a5ab-5f5f-b779-341534a0b1ac', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-7', '45545cfb-8009-56ad-b771-519b956f795c', 'd1631663-5c9a-5b9b-a6df-256b4f0876ec', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd1631663-5c9a-5b9b-a6df-256b4f0876ec';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d6c6bc05-a5ab-5f5f-b779-341534a0b1ac', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('d6c6bc05-a5ab-5f5f-b779-341534a0b1ac', 'd1631663-5c9a-5b9b-a6df-256b4f0876ec', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd6c6bc05-a5ab-5f5f-b779-341534a0b1ac';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('fcd7879b-2c4b-523a-92ac-28a682234494', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-8', '45545cfb-8009-56ad-b771-519b956f795c', '9b05d328-76b7-5da7-a2d2-5de0ca715da2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9b05d328-76b7-5da7-a2d2-5de0ca715da2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('fcd7879b-2c4b-523a-92ac-28a682234494', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('fcd7879b-2c4b-523a-92ac-28a682234494', '9b05d328-76b7-5da7-a2d2-5de0ca715da2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'fcd7879b-2c4b-523a-92ac-28a682234494';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('65bb253f-1e05-575c-a5bd-e35b480dea13', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-9', '45545cfb-8009-56ad-b771-519b956f795c', '254d8d7a-b2da-5749-bbea-eae1d9df36ad', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '254d8d7a-b2da-5749-bbea-eae1d9df36ad';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('65bb253f-1e05-575c-a5bd-e35b480dea13', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('65bb253f-1e05-575c-a5bd-e35b480dea13', '254d8d7a-b2da-5749-bbea-eae1d9df36ad', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '65bb253f-1e05-575c-a5bd-e35b480dea13';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9bf35995-b67b-5bf8-80ea-3d332cc22dfe', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-10', '45545cfb-8009-56ad-b771-519b956f795c', '8fb9963a-a516-5210-b9ae-d2b8541af501', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8fb9963a-a516-5210-b9ae-d2b8541af501';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9bf35995-b67b-5bf8-80ea-3d332cc22dfe', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('9bf35995-b67b-5bf8-80ea-3d332cc22dfe', '8fb9963a-a516-5210-b9ae-d2b8541af501', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9bf35995-b67b-5bf8-80ea-3d332cc22dfe';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('566304db-bebc-599b-b87d-66e1d1514a53', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-11', '45545cfb-8009-56ad-b771-519b956f795c', 'e5a55a34-f3a8-579e-9d4d-2b8ef28a6519', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e5a55a34-f3a8-579e-9d4d-2b8ef28a6519';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('566304db-bebc-599b-b87d-66e1d1514a53', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('566304db-bebc-599b-b87d-66e1d1514a53', 'e5a55a34-f3a8-579e-9d4d-2b8ef28a6519', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '566304db-bebc-599b-b87d-66e1d1514a53';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('340aff34-3f49-5889-b6ea-84e1560538c2', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-12', '45545cfb-8009-56ad-b771-519b956f795c', '51902502-14bc-58fc-83a9-cf8cf9d9f51b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '51902502-14bc-58fc-83a9-cf8cf9d9f51b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('340aff34-3f49-5889-b6ea-84e1560538c2', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('340aff34-3f49-5889-b6ea-84e1560538c2', '51902502-14bc-58fc-83a9-cf8cf9d9f51b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '340aff34-3f49-5889-b6ea-84e1560538c2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e4d3e429-9039-56ad-9f83-4a30cdce00ac', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-13', '45545cfb-8009-56ad-b771-519b956f795c', 'ebf8cbe5-6755-5218-94e2-e16394e36d51', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ebf8cbe5-6755-5218-94e2-e16394e36d51';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e4d3e429-9039-56ad-9f83-4a30cdce00ac', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('e4d3e429-9039-56ad-9f83-4a30cdce00ac', 'ebf8cbe5-6755-5218-94e2-e16394e36d51', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e4d3e429-9039-56ad-9f83-4a30cdce00ac';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('96e560eb-5b71-5e37-8f2b-84d34060d61e', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-14', '45545cfb-8009-56ad-b771-519b956f795c', '76e3a54c-306a-54e2-894c-02df4afe2511', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '76e3a54c-306a-54e2-894c-02df4afe2511';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('96e560eb-5b71-5e37-8f2b-84d34060d61e', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('96e560eb-5b71-5e37-8f2b-84d34060d61e', '76e3a54c-306a-54e2-894c-02df4afe2511', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '96e560eb-5b71-5e37-8f2b-84d34060d61e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('55af9dee-ea52-5a45-985e-3f699b32a0df', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-15', '45545cfb-8009-56ad-b771-519b956f795c', 'fdaaa657-7299-5f37-85a2-bdc9555acde0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fdaaa657-7299-5f37-85a2-bdc9555acde0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('55af9dee-ea52-5a45-985e-3f699b32a0df', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('55af9dee-ea52-5a45-985e-3f699b32a0df', 'fdaaa657-7299-5f37-85a2-bdc9555acde0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '55af9dee-ea52-5a45-985e-3f699b32a0df';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('edcc1625-7cc9-5f9a-956a-be511dea63c4', 'benchmark-funding-87194790-3808-4152-8fe4-d14c670c4760-16', '45545cfb-8009-56ad-b771-519b956f795c', '1fafccc5-39ff-55fa-91c0-61227da6f7d3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '45545cfb-8009-56ad-b771-519b956f795c';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1fafccc5-39ff-55fa-91c0-61227da6f7d3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('edcc1625-7cc9-5f9a-956a-be511dea63c4', '45545cfb-8009-56ad-b771-519b956f795c', -1000000000), ('edcc1625-7cc9-5f9a-956a-be511dea63c4', '1fafccc5-39ff-55fa-91c0-61227da6f7d3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'edcc1625-7cc9-5f9a-956a-be511dea63c4';
COMMIT;
