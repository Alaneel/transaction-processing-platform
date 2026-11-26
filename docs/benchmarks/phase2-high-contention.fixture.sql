-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('02dae563-19e0-5d6a-885c-7fd730a043d3', 'USER', 'ACTIVE', 'FIC'),
('0c77d263-8aa8-54a6-b440-26b25f6b580c', 'USER', 'ACTIVE', 'FIC'),
('2652050a-b819-5e80-858a-8fab7ec4d12c', 'USER', 'ACTIVE', 'FIC'),
('28ef6752-8bae-536b-82a2-7966155b0608', 'USER', 'ACTIVE', 'FIC'),
('2900e09e-43d3-5751-9f98-b6ba08ef3e11', 'USER', 'ACTIVE', 'FIC'),
('374b6fa5-d19c-55b6-a89e-bffcdb75e649', 'USER', 'ACTIVE', 'FIC'),
('42b34902-f625-547b-9067-5aa9eefffeb3', 'USER', 'ACTIVE', 'FIC'),
('4425ee51-0ec3-5796-bc9c-45a9b5b4b313', 'USER', 'ACTIVE', 'FIC'),
('4cd5d605-59db-5d10-b337-e4771bdadc21', 'USER', 'ACTIVE', 'FIC'),
('559afee3-fd57-55e2-a607-c9bca77b42fa', 'USER', 'ACTIVE', 'FIC'),
('63ed1ab9-aa9d-5331-9e36-11fb66526d9e', 'USER', 'ACTIVE', 'FIC'),
('74c0a06d-79de-57fe-a7e3-29f30566b276', 'USER', 'ACTIVE', 'FIC'),
('848c3dfb-fe73-57da-9573-a2d90fe5aa13', 'USER', 'ACTIVE', 'FIC'),
('88411f09-c2f1-5703-8b7d-aea35ed6bd18', 'USER', 'ACTIVE', 'FIC'),
('8ea4da3a-3d92-5063-b9e6-5c064ff261c5', 'USER', 'ACTIVE', 'FIC'),
('a24905e8-73aa-5174-8b36-eef707f47e2a', 'ISSUANCE', 'ACTIVE', 'FIC'),
('b88d8ada-7b75-5719-9043-342bdf3388c8', 'USER', 'ACTIVE', 'FIC'),
('c6af6288-b344-5633-a269-ca34d579c7a7', 'USER', 'ACTIVE', 'FIC'),
('caebae25-cf4b-5996-8387-37aef5f27907', 'USER', 'ACTIVE', 'FIC'),
('d1ee3e28-4f46-57f2-8216-d66eac508b6d', 'USER', 'ACTIVE', 'FIC'),
('d39e0043-c2af-5ddb-80a8-86d4392310a1', 'USER', 'ACTIVE', 'FIC'),
('d5fc2484-e3f2-5b51-ad06-02d311296252', 'USER', 'ACTIVE', 'FIC'),
('e95ca693-73fb-5a9d-96f4-107b498e9b7a', 'USER', 'ACTIVE', 'FIC'),
('f5ec1dc4-2cc5-5f5f-931d-5b814d826c00', 'USER', 'ACTIVE', 'FIC'),
('f7a757a9-3926-5c41-b81a-4758bcd2127f', 'USER', 'ACTIVE', 'FIC'),
('fb0980eb-4ae7-58b0-9757-c42e4b5b7245', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('02dae563-19e0-5d6a-885c-7fd730a043d3', 0),
('0c77d263-8aa8-54a6-b440-26b25f6b580c', 0),
('2652050a-b819-5e80-858a-8fab7ec4d12c', 0),
('28ef6752-8bae-536b-82a2-7966155b0608', 0),
('2900e09e-43d3-5751-9f98-b6ba08ef3e11', 0),
('374b6fa5-d19c-55b6-a89e-bffcdb75e649', 0),
('42b34902-f625-547b-9067-5aa9eefffeb3', 0),
('4425ee51-0ec3-5796-bc9c-45a9b5b4b313', 0),
('4cd5d605-59db-5d10-b337-e4771bdadc21', 0),
('559afee3-fd57-55e2-a607-c9bca77b42fa', 0),
('63ed1ab9-aa9d-5331-9e36-11fb66526d9e', 0),
('74c0a06d-79de-57fe-a7e3-29f30566b276', 0),
('848c3dfb-fe73-57da-9573-a2d90fe5aa13', 0),
('88411f09-c2f1-5703-8b7d-aea35ed6bd18', 0),
('8ea4da3a-3d92-5063-b9e6-5c064ff261c5', 0),
('a24905e8-73aa-5174-8b36-eef707f47e2a', 0),
('b88d8ada-7b75-5719-9043-342bdf3388c8', 0),
('c6af6288-b344-5633-a269-ca34d579c7a7', 0),
('caebae25-cf4b-5996-8387-37aef5f27907', 0),
('d1ee3e28-4f46-57f2-8216-d66eac508b6d', 0),
('d39e0043-c2af-5ddb-80a8-86d4392310a1', 0),
('d5fc2484-e3f2-5b51-ad06-02d311296252', 0),
('e95ca693-73fb-5a9d-96f4-107b498e9b7a', 0),
('f5ec1dc4-2cc5-5f5f-931d-5b814d826c00', 0),
('f7a757a9-3926-5c41-b81a-4758bcd2127f', 0),
('fb0980eb-4ae7-58b0-9757-c42e4b5b7245', 0);
SELECT account_id FROM balances WHERE account_id IN ('02dae563-19e0-5d6a-885c-7fd730a043d3','0c77d263-8aa8-54a6-b440-26b25f6b580c','2652050a-b819-5e80-858a-8fab7ec4d12c','28ef6752-8bae-536b-82a2-7966155b0608','2900e09e-43d3-5751-9f98-b6ba08ef3e11','374b6fa5-d19c-55b6-a89e-bffcdb75e649','42b34902-f625-547b-9067-5aa9eefffeb3','4425ee51-0ec3-5796-bc9c-45a9b5b4b313','4cd5d605-59db-5d10-b337-e4771bdadc21','559afee3-fd57-55e2-a607-c9bca77b42fa','63ed1ab9-aa9d-5331-9e36-11fb66526d9e','74c0a06d-79de-57fe-a7e3-29f30566b276','848c3dfb-fe73-57da-9573-a2d90fe5aa13','88411f09-c2f1-5703-8b7d-aea35ed6bd18','8ea4da3a-3d92-5063-b9e6-5c064ff261c5','a24905e8-73aa-5174-8b36-eef707f47e2a','b88d8ada-7b75-5719-9043-342bdf3388c8','c6af6288-b344-5633-a269-ca34d579c7a7','caebae25-cf4b-5996-8387-37aef5f27907','d1ee3e28-4f46-57f2-8216-d66eac508b6d','d39e0043-c2af-5ddb-80a8-86d4392310a1','d5fc2484-e3f2-5b51-ad06-02d311296252','e95ca693-73fb-5a9d-96f4-107b498e9b7a','f5ec1dc4-2cc5-5f5f-931d-5b814d826c00','f7a757a9-3926-5c41-b81a-4758bcd2127f','fb0980eb-4ae7-58b0-9757-c42e4b5b7245') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a19d40b8-7b11-551f-a9ad-9cdb904212e2', 'benchmark-funding-bb8e0761-2bbf-4ed5-8864-97b45b134e58-0', 'a24905e8-73aa-5174-8b36-eef707f47e2a', 'd39e0043-c2af-5ddb-80a8-86d4392310a1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a24905e8-73aa-5174-8b36-eef707f47e2a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd39e0043-c2af-5ddb-80a8-86d4392310a1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a19d40b8-7b11-551f-a9ad-9cdb904212e2', 'a24905e8-73aa-5174-8b36-eef707f47e2a', -1000000000), ('a19d40b8-7b11-551f-a9ad-9cdb904212e2', 'd39e0043-c2af-5ddb-80a8-86d4392310a1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a19d40b8-7b11-551f-a9ad-9cdb904212e2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a0013597-2808-5674-beb6-cee9beb07d6e', 'benchmark-funding-bb8e0761-2bbf-4ed5-8864-97b45b134e58-1', 'a24905e8-73aa-5174-8b36-eef707f47e2a', 'd1ee3e28-4f46-57f2-8216-d66eac508b6d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a24905e8-73aa-5174-8b36-eef707f47e2a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd1ee3e28-4f46-57f2-8216-d66eac508b6d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a0013597-2808-5674-beb6-cee9beb07d6e', 'a24905e8-73aa-5174-8b36-eef707f47e2a', -1000000000), ('a0013597-2808-5674-beb6-cee9beb07d6e', 'd1ee3e28-4f46-57f2-8216-d66eac508b6d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a0013597-2808-5674-beb6-cee9beb07d6e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('936e6585-dafa-5718-a513-68fa069c99be', 'benchmark-funding-bb8e0761-2bbf-4ed5-8864-97b45b134e58-2', 'a24905e8-73aa-5174-8b36-eef707f47e2a', '374b6fa5-d19c-55b6-a89e-bffcdb75e649', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a24905e8-73aa-5174-8b36-eef707f47e2a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '374b6fa5-d19c-55b6-a89e-bffcdb75e649';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('936e6585-dafa-5718-a513-68fa069c99be', 'a24905e8-73aa-5174-8b36-eef707f47e2a', -1000000000), ('936e6585-dafa-5718-a513-68fa069c99be', '374b6fa5-d19c-55b6-a89e-bffcdb75e649', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '936e6585-dafa-5718-a513-68fa069c99be';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a6831455-47eb-5171-9c5f-ec3c662798ca', 'benchmark-funding-bb8e0761-2bbf-4ed5-8864-97b45b134e58-3', 'a24905e8-73aa-5174-8b36-eef707f47e2a', '0c77d263-8aa8-54a6-b440-26b25f6b580c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a24905e8-73aa-5174-8b36-eef707f47e2a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0c77d263-8aa8-54a6-b440-26b25f6b580c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a6831455-47eb-5171-9c5f-ec3c662798ca', 'a24905e8-73aa-5174-8b36-eef707f47e2a', -1000000000), ('a6831455-47eb-5171-9c5f-ec3c662798ca', '0c77d263-8aa8-54a6-b440-26b25f6b580c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a6831455-47eb-5171-9c5f-ec3c662798ca';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1d6c32e9-2385-5381-8fe9-1af9249c113e', 'benchmark-funding-bb8e0761-2bbf-4ed5-8864-97b45b134e58-4', 'a24905e8-73aa-5174-8b36-eef707f47e2a', 'b88d8ada-7b75-5719-9043-342bdf3388c8', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a24905e8-73aa-5174-8b36-eef707f47e2a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b88d8ada-7b75-5719-9043-342bdf3388c8';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1d6c32e9-2385-5381-8fe9-1af9249c113e', 'a24905e8-73aa-5174-8b36-eef707f47e2a', -1000000000), ('1d6c32e9-2385-5381-8fe9-1af9249c113e', 'b88d8ada-7b75-5719-9043-342bdf3388c8', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1d6c32e9-2385-5381-8fe9-1af9249c113e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ad94b45f-9d33-5ef0-b8f5-d988f0f5f716', 'benchmark-funding-bb8e0761-2bbf-4ed5-8864-97b45b134e58-5', 'a24905e8-73aa-5174-8b36-eef707f47e2a', '74c0a06d-79de-57fe-a7e3-29f30566b276', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a24905e8-73aa-5174-8b36-eef707f47e2a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '74c0a06d-79de-57fe-a7e3-29f30566b276';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ad94b45f-9d33-5ef0-b8f5-d988f0f5f716', 'a24905e8-73aa-5174-8b36-eef707f47e2a', -1000000000), ('ad94b45f-9d33-5ef0-b8f5-d988f0f5f716', '74c0a06d-79de-57fe-a7e3-29f30566b276', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ad94b45f-9d33-5ef0-b8f5-d988f0f5f716';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0d989a0b-32d8-582f-9626-1205537076cb', 'benchmark-funding-bb8e0761-2bbf-4ed5-8864-97b45b134e58-6', 'a24905e8-73aa-5174-8b36-eef707f47e2a', 'd5fc2484-e3f2-5b51-ad06-02d311296252', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a24905e8-73aa-5174-8b36-eef707f47e2a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd5fc2484-e3f2-5b51-ad06-02d311296252';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0d989a0b-32d8-582f-9626-1205537076cb', 'a24905e8-73aa-5174-8b36-eef707f47e2a', -1000000000), ('0d989a0b-32d8-582f-9626-1205537076cb', 'd5fc2484-e3f2-5b51-ad06-02d311296252', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0d989a0b-32d8-582f-9626-1205537076cb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('96468420-aa38-5cd2-a67b-8050e2f9249d', 'benchmark-funding-bb8e0761-2bbf-4ed5-8864-97b45b134e58-7', 'a24905e8-73aa-5174-8b36-eef707f47e2a', '4425ee51-0ec3-5796-bc9c-45a9b5b4b313', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a24905e8-73aa-5174-8b36-eef707f47e2a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4425ee51-0ec3-5796-bc9c-45a9b5b4b313';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('96468420-aa38-5cd2-a67b-8050e2f9249d', 'a24905e8-73aa-5174-8b36-eef707f47e2a', -1000000000), ('96468420-aa38-5cd2-a67b-8050e2f9249d', '4425ee51-0ec3-5796-bc9c-45a9b5b4b313', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '96468420-aa38-5cd2-a67b-8050e2f9249d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('608c05b4-7bc0-5bc4-97c9-94d1f898222f', 'benchmark-funding-bb8e0761-2bbf-4ed5-8864-97b45b134e58-8', 'a24905e8-73aa-5174-8b36-eef707f47e2a', '28ef6752-8bae-536b-82a2-7966155b0608', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a24905e8-73aa-5174-8b36-eef707f47e2a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '28ef6752-8bae-536b-82a2-7966155b0608';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('608c05b4-7bc0-5bc4-97c9-94d1f898222f', 'a24905e8-73aa-5174-8b36-eef707f47e2a', -1000000000), ('608c05b4-7bc0-5bc4-97c9-94d1f898222f', '28ef6752-8bae-536b-82a2-7966155b0608', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '608c05b4-7bc0-5bc4-97c9-94d1f898222f';
COMMIT;
