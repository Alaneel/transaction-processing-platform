-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('06f1c2ce-fc17-5072-82e8-2833070adf81', 'USER', 'ACTIVE', 'FIC'),
('1ba70568-13ec-5a7d-9c82-9fee274f1f5a', 'USER', 'ACTIVE', 'FIC'),
('1fc3612e-4c73-5f67-bac6-6bb38464b62a', 'USER', 'ACTIVE', 'FIC'),
('3a061da5-62bc-5ebd-a95d-ceda282e8513', 'USER', 'ACTIVE', 'FIC'),
('48335461-91bf-512e-ba58-6b6baec3f93f', 'USER', 'ACTIVE', 'FIC'),
('63775c79-bfc6-5e2a-b598-c97fc43c71b1', 'USER', 'ACTIVE', 'FIC'),
('7834ce82-23db-5535-9759-a8de81c5913b', 'USER', 'ACTIVE', 'FIC'),
('87a7cf38-7714-57a5-96c0-db770854bea5', 'USER', 'ACTIVE', 'FIC'),
('90df0326-5c82-53a9-a346-5c2174551970', 'USER', 'ACTIVE', 'FIC'),
('93664e83-957a-584f-b593-1eac51811194', 'USER', 'ACTIVE', 'FIC'),
('9371dc6e-1a1a-527d-94b2-e2978891c94c', 'USER', 'ACTIVE', 'FIC'),
('9665c7cf-438e-5d91-abc1-effc495e9de1', 'USER', 'ACTIVE', 'FIC'),
('98598ad7-a2ee-5ce0-9fb0-e110588c1313', 'ISSUANCE', 'ACTIVE', 'FIC'),
('a0b9b753-9ded-58d6-af5f-e2bb42b3a0b1', 'USER', 'ACTIVE', 'FIC'),
('a39b950b-7b03-52e0-b6ee-dc1c51387ff7', 'USER', 'ACTIVE', 'FIC'),
('a54adb45-a824-5d0e-bc7e-230b945dcc3a', 'USER', 'ACTIVE', 'FIC'),
('aab03168-47a0-5f06-a15a-0f689e433df3', 'USER', 'ACTIVE', 'FIC'),
('af934dae-497d-5782-a915-0695a31d613e', 'USER', 'ACTIVE', 'FIC'),
('b6c6ea0e-23a3-569e-8be2-e9d864dc414f', 'USER', 'ACTIVE', 'FIC'),
('c8aa4eab-80c2-5af5-b844-3bc4cd24f62b', 'USER', 'ACTIVE', 'FIC'),
('c8e7f661-02ae-5fc0-9244-ea57fad21a36', 'USER', 'ACTIVE', 'FIC'),
('caee3802-9803-59a1-b55b-320da10319e6', 'USER', 'ACTIVE', 'FIC'),
('ce7e8d0a-f79d-593f-ba32-45505cde6f06', 'USER', 'ACTIVE', 'FIC'),
('db7fde3a-dae9-5e14-8c8c-85f3b505cc69', 'USER', 'ACTIVE', 'FIC'),
('f877a2ad-b229-5cc3-b977-f3736332a433', 'USER', 'ACTIVE', 'FIC'),
('fdfaee31-c91e-5631-803c-8c5d85567154', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('06f1c2ce-fc17-5072-82e8-2833070adf81', 0),
('1ba70568-13ec-5a7d-9c82-9fee274f1f5a', 0),
('1fc3612e-4c73-5f67-bac6-6bb38464b62a', 0),
('3a061da5-62bc-5ebd-a95d-ceda282e8513', 0),
('48335461-91bf-512e-ba58-6b6baec3f93f', 0),
('63775c79-bfc6-5e2a-b598-c97fc43c71b1', 0),
('7834ce82-23db-5535-9759-a8de81c5913b', 0),
('87a7cf38-7714-57a5-96c0-db770854bea5', 0),
('90df0326-5c82-53a9-a346-5c2174551970', 0),
('93664e83-957a-584f-b593-1eac51811194', 0),
('9371dc6e-1a1a-527d-94b2-e2978891c94c', 0),
('9665c7cf-438e-5d91-abc1-effc495e9de1', 0),
('98598ad7-a2ee-5ce0-9fb0-e110588c1313', 0),
('a0b9b753-9ded-58d6-af5f-e2bb42b3a0b1', 0),
('a39b950b-7b03-52e0-b6ee-dc1c51387ff7', 0),
('a54adb45-a824-5d0e-bc7e-230b945dcc3a', 0),
('aab03168-47a0-5f06-a15a-0f689e433df3', 0),
('af934dae-497d-5782-a915-0695a31d613e', 0),
('b6c6ea0e-23a3-569e-8be2-e9d864dc414f', 0),
('c8aa4eab-80c2-5af5-b844-3bc4cd24f62b', 0),
('c8e7f661-02ae-5fc0-9244-ea57fad21a36', 0),
('caee3802-9803-59a1-b55b-320da10319e6', 0),
('ce7e8d0a-f79d-593f-ba32-45505cde6f06', 0),
('db7fde3a-dae9-5e14-8c8c-85f3b505cc69', 0),
('f877a2ad-b229-5cc3-b977-f3736332a433', 0),
('fdfaee31-c91e-5631-803c-8c5d85567154', 0);
SELECT account_id FROM balances WHERE account_id IN ('06f1c2ce-fc17-5072-82e8-2833070adf81','1ba70568-13ec-5a7d-9c82-9fee274f1f5a','1fc3612e-4c73-5f67-bac6-6bb38464b62a','3a061da5-62bc-5ebd-a95d-ceda282e8513','48335461-91bf-512e-ba58-6b6baec3f93f','63775c79-bfc6-5e2a-b598-c97fc43c71b1','7834ce82-23db-5535-9759-a8de81c5913b','87a7cf38-7714-57a5-96c0-db770854bea5','90df0326-5c82-53a9-a346-5c2174551970','93664e83-957a-584f-b593-1eac51811194','9371dc6e-1a1a-527d-94b2-e2978891c94c','9665c7cf-438e-5d91-abc1-effc495e9de1','98598ad7-a2ee-5ce0-9fb0-e110588c1313','a0b9b753-9ded-58d6-af5f-e2bb42b3a0b1','a39b950b-7b03-52e0-b6ee-dc1c51387ff7','a54adb45-a824-5d0e-bc7e-230b945dcc3a','aab03168-47a0-5f06-a15a-0f689e433df3','af934dae-497d-5782-a915-0695a31d613e','b6c6ea0e-23a3-569e-8be2-e9d864dc414f','c8aa4eab-80c2-5af5-b844-3bc4cd24f62b','c8e7f661-02ae-5fc0-9244-ea57fad21a36','caee3802-9803-59a1-b55b-320da10319e6','ce7e8d0a-f79d-593f-ba32-45505cde6f06','db7fde3a-dae9-5e14-8c8c-85f3b505cc69','f877a2ad-b229-5cc3-b977-f3736332a433','fdfaee31-c91e-5631-803c-8c5d85567154') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7f8c7030-0389-55b7-8acd-3717e43d89f2', 'benchmark-funding-c200345a-22f3-43d7-826a-c86fc688dde2-0', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', 'aab03168-47a0-5f06-a15a-0f689e433df3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '98598ad7-a2ee-5ce0-9fb0-e110588c1313';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'aab03168-47a0-5f06-a15a-0f689e433df3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7f8c7030-0389-55b7-8acd-3717e43d89f2', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', -1000000000), ('7f8c7030-0389-55b7-8acd-3717e43d89f2', 'aab03168-47a0-5f06-a15a-0f689e433df3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7f8c7030-0389-55b7-8acd-3717e43d89f2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('cf48bffb-d622-5624-b33c-ad1a17e9ecf5', 'benchmark-funding-c200345a-22f3-43d7-826a-c86fc688dde2-1', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', '63775c79-bfc6-5e2a-b598-c97fc43c71b1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '98598ad7-a2ee-5ce0-9fb0-e110588c1313';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '63775c79-bfc6-5e2a-b598-c97fc43c71b1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('cf48bffb-d622-5624-b33c-ad1a17e9ecf5', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', -1000000000), ('cf48bffb-d622-5624-b33c-ad1a17e9ecf5', '63775c79-bfc6-5e2a-b598-c97fc43c71b1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'cf48bffb-d622-5624-b33c-ad1a17e9ecf5';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9ff719da-8ffa-5f6b-afd4-df9eba1ac531', 'benchmark-funding-c200345a-22f3-43d7-826a-c86fc688dde2-2', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', '93664e83-957a-584f-b593-1eac51811194', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '98598ad7-a2ee-5ce0-9fb0-e110588c1313';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '93664e83-957a-584f-b593-1eac51811194';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9ff719da-8ffa-5f6b-afd4-df9eba1ac531', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', -1000000000), ('9ff719da-8ffa-5f6b-afd4-df9eba1ac531', '93664e83-957a-584f-b593-1eac51811194', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9ff719da-8ffa-5f6b-afd4-df9eba1ac531';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('2c09c26d-a6c7-5288-97f3-d0ee8e25ba46', 'benchmark-funding-c200345a-22f3-43d7-826a-c86fc688dde2-3', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', '1ba70568-13ec-5a7d-9c82-9fee274f1f5a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '98598ad7-a2ee-5ce0-9fb0-e110588c1313';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1ba70568-13ec-5a7d-9c82-9fee274f1f5a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('2c09c26d-a6c7-5288-97f3-d0ee8e25ba46', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', -1000000000), ('2c09c26d-a6c7-5288-97f3-d0ee8e25ba46', '1ba70568-13ec-5a7d-9c82-9fee274f1f5a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '2c09c26d-a6c7-5288-97f3-d0ee8e25ba46';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('09c3630c-deb9-5413-b245-9c998c16ad6a', 'benchmark-funding-c200345a-22f3-43d7-826a-c86fc688dde2-4', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', 'db7fde3a-dae9-5e14-8c8c-85f3b505cc69', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '98598ad7-a2ee-5ce0-9fb0-e110588c1313';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'db7fde3a-dae9-5e14-8c8c-85f3b505cc69';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('09c3630c-deb9-5413-b245-9c998c16ad6a', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', -1000000000), ('09c3630c-deb9-5413-b245-9c998c16ad6a', 'db7fde3a-dae9-5e14-8c8c-85f3b505cc69', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '09c3630c-deb9-5413-b245-9c998c16ad6a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('88d2c138-85b2-5b64-9d98-92417ed88423', 'benchmark-funding-c200345a-22f3-43d7-826a-c86fc688dde2-5', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', '9371dc6e-1a1a-527d-94b2-e2978891c94c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '98598ad7-a2ee-5ce0-9fb0-e110588c1313';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9371dc6e-1a1a-527d-94b2-e2978891c94c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('88d2c138-85b2-5b64-9d98-92417ed88423', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', -1000000000), ('88d2c138-85b2-5b64-9d98-92417ed88423', '9371dc6e-1a1a-527d-94b2-e2978891c94c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '88d2c138-85b2-5b64-9d98-92417ed88423';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a13d9275-9fe6-580a-9651-ad4c494cafc0', 'benchmark-funding-c200345a-22f3-43d7-826a-c86fc688dde2-6', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', '1fc3612e-4c73-5f67-bac6-6bb38464b62a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '98598ad7-a2ee-5ce0-9fb0-e110588c1313';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1fc3612e-4c73-5f67-bac6-6bb38464b62a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a13d9275-9fe6-580a-9651-ad4c494cafc0', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', -1000000000), ('a13d9275-9fe6-580a-9651-ad4c494cafc0', '1fc3612e-4c73-5f67-bac6-6bb38464b62a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a13d9275-9fe6-580a-9651-ad4c494cafc0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4f1e9bbe-313e-5369-808e-a9f2a5678899', 'benchmark-funding-c200345a-22f3-43d7-826a-c86fc688dde2-7', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', '9665c7cf-438e-5d91-abc1-effc495e9de1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '98598ad7-a2ee-5ce0-9fb0-e110588c1313';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9665c7cf-438e-5d91-abc1-effc495e9de1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4f1e9bbe-313e-5369-808e-a9f2a5678899', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', -1000000000), ('4f1e9bbe-313e-5369-808e-a9f2a5678899', '9665c7cf-438e-5d91-abc1-effc495e9de1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4f1e9bbe-313e-5369-808e-a9f2a5678899';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e37b5ff1-2aed-5d1f-9071-e290454c8a52', 'benchmark-funding-c200345a-22f3-43d7-826a-c86fc688dde2-8', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', 'a0b9b753-9ded-58d6-af5f-e2bb42b3a0b1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '98598ad7-a2ee-5ce0-9fb0-e110588c1313';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a0b9b753-9ded-58d6-af5f-e2bb42b3a0b1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e37b5ff1-2aed-5d1f-9071-e290454c8a52', '98598ad7-a2ee-5ce0-9fb0-e110588c1313', -1000000000), ('e37b5ff1-2aed-5d1f-9071-e290454c8a52', 'a0b9b753-9ded-58d6-af5f-e2bb42b3a0b1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e37b5ff1-2aed-5d1f-9071-e290454c8a52';
COMMIT;
