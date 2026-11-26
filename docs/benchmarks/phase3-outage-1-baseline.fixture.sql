-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('07fe3041-00ef-57bb-8dd1-8a2b7c42e9e2', 'USER', 'ACTIVE', 'FIC'),
('0b1fa046-1541-5bc4-bdd4-95002fcab47c', 'USER', 'ACTIVE', 'FIC'),
('27e6249e-4777-5dc3-98e2-bb32b044de6c', 'USER', 'ACTIVE', 'FIC'),
('33b3d4f8-c51e-5639-8e82-9856ac438ff4', 'USER', 'ACTIVE', 'FIC'),
('3a560555-f7e3-576d-b54b-22827e5cf019', 'USER', 'ACTIVE', 'FIC'),
('3c08165f-8ee1-5641-b7cd-bede8a24473c', 'USER', 'ACTIVE', 'FIC'),
('3ddfee2b-fb7c-549c-8c25-08ae0509b01e', 'USER', 'ACTIVE', 'FIC'),
('435b8dc1-2f3a-5772-85d4-bcf0089c0244', 'USER', 'ACTIVE', 'FIC'),
('4624d5e1-0458-5078-89ca-15d99668c639', 'USER', 'ACTIVE', 'FIC'),
('4803745b-1f99-5711-9e4c-e74872644b77', 'USER', 'ACTIVE', 'FIC'),
('5595934f-5bdc-5eab-9b12-fe75fd65de5b', 'USER', 'ACTIVE', 'FIC'),
('5ddce7c2-4d5e-519d-b8b4-2758e9dadd35', 'USER', 'ACTIVE', 'FIC'),
('61bd5d01-7d79-5b21-a1ff-17dd69517b8f', 'USER', 'ACTIVE', 'FIC'),
('984b8efb-5cd9-555f-b087-114e69ea827e', 'USER', 'ACTIVE', 'FIC'),
('a73e5f18-1cc2-5555-82b6-79d03015a2c7', 'USER', 'ACTIVE', 'FIC'),
('bc22d0c8-2899-5fc8-96d9-3751056183c1', 'ISSUANCE', 'ACTIVE', 'FIC'),
('c460d13d-548c-5825-a293-4720850abdc7', 'USER', 'ACTIVE', 'FIC'),
('d8fee546-01b9-5780-9c31-708e19536509', 'USER', 'ACTIVE', 'FIC'),
('e356a37b-95b9-534c-8689-5cce7c478a11', 'USER', 'ACTIVE', 'FIC'),
('e539ce6e-20c6-5586-8519-23ed2533ce12', 'USER', 'ACTIVE', 'FIC'),
('eb64ab2d-9f09-5532-886b-866363bb43ef', 'USER', 'ACTIVE', 'FIC'),
('edd33e77-a00e-5d39-82c2-fa685f25edbf', 'USER', 'ACTIVE', 'FIC'),
('ee5a97ac-002e-50ee-bd32-8dc56a2cebec', 'USER', 'ACTIVE', 'FIC'),
('f5518863-4767-5d80-8267-f58b1eb6ad93', 'USER', 'ACTIVE', 'FIC'),
('f7d16665-65ad-5f9e-a070-cddf39d35243', 'USER', 'ACTIVE', 'FIC'),
('fb4bad34-7535-5ac0-9527-da20162182ef', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('07fe3041-00ef-57bb-8dd1-8a2b7c42e9e2', 0),
('0b1fa046-1541-5bc4-bdd4-95002fcab47c', 0),
('27e6249e-4777-5dc3-98e2-bb32b044de6c', 0),
('33b3d4f8-c51e-5639-8e82-9856ac438ff4', 0),
('3a560555-f7e3-576d-b54b-22827e5cf019', 0),
('3c08165f-8ee1-5641-b7cd-bede8a24473c', 0),
('3ddfee2b-fb7c-549c-8c25-08ae0509b01e', 0),
('435b8dc1-2f3a-5772-85d4-bcf0089c0244', 0),
('4624d5e1-0458-5078-89ca-15d99668c639', 0),
('4803745b-1f99-5711-9e4c-e74872644b77', 0),
('5595934f-5bdc-5eab-9b12-fe75fd65de5b', 0),
('5ddce7c2-4d5e-519d-b8b4-2758e9dadd35', 0),
('61bd5d01-7d79-5b21-a1ff-17dd69517b8f', 0),
('984b8efb-5cd9-555f-b087-114e69ea827e', 0),
('a73e5f18-1cc2-5555-82b6-79d03015a2c7', 0),
('bc22d0c8-2899-5fc8-96d9-3751056183c1', 0),
('c460d13d-548c-5825-a293-4720850abdc7', 0),
('d8fee546-01b9-5780-9c31-708e19536509', 0),
('e356a37b-95b9-534c-8689-5cce7c478a11', 0),
('e539ce6e-20c6-5586-8519-23ed2533ce12', 0),
('eb64ab2d-9f09-5532-886b-866363bb43ef', 0),
('edd33e77-a00e-5d39-82c2-fa685f25edbf', 0),
('ee5a97ac-002e-50ee-bd32-8dc56a2cebec', 0),
('f5518863-4767-5d80-8267-f58b1eb6ad93', 0),
('f7d16665-65ad-5f9e-a070-cddf39d35243', 0),
('fb4bad34-7535-5ac0-9527-da20162182ef', 0);
SELECT account_id FROM balances WHERE account_id IN ('07fe3041-00ef-57bb-8dd1-8a2b7c42e9e2','0b1fa046-1541-5bc4-bdd4-95002fcab47c','27e6249e-4777-5dc3-98e2-bb32b044de6c','33b3d4f8-c51e-5639-8e82-9856ac438ff4','3a560555-f7e3-576d-b54b-22827e5cf019','3c08165f-8ee1-5641-b7cd-bede8a24473c','3ddfee2b-fb7c-549c-8c25-08ae0509b01e','435b8dc1-2f3a-5772-85d4-bcf0089c0244','4624d5e1-0458-5078-89ca-15d99668c639','4803745b-1f99-5711-9e4c-e74872644b77','5595934f-5bdc-5eab-9b12-fe75fd65de5b','5ddce7c2-4d5e-519d-b8b4-2758e9dadd35','61bd5d01-7d79-5b21-a1ff-17dd69517b8f','984b8efb-5cd9-555f-b087-114e69ea827e','a73e5f18-1cc2-5555-82b6-79d03015a2c7','bc22d0c8-2899-5fc8-96d9-3751056183c1','c460d13d-548c-5825-a293-4720850abdc7','d8fee546-01b9-5780-9c31-708e19536509','e356a37b-95b9-534c-8689-5cce7c478a11','e539ce6e-20c6-5586-8519-23ed2533ce12','eb64ab2d-9f09-5532-886b-866363bb43ef','edd33e77-a00e-5d39-82c2-fa685f25edbf','ee5a97ac-002e-50ee-bd32-8dc56a2cebec','f5518863-4767-5d80-8267-f58b1eb6ad93','f7d16665-65ad-5f9e-a070-cddf39d35243','fb4bad34-7535-5ac0-9527-da20162182ef') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('65a0e292-9fb4-5901-a307-243796ef4e9c', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-0', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', '07fe3041-00ef-57bb-8dd1-8a2b7c42e9e2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '07fe3041-00ef-57bb-8dd1-8a2b7c42e9e2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('65a0e292-9fb4-5901-a307-243796ef4e9c', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('65a0e292-9fb4-5901-a307-243796ef4e9c', '07fe3041-00ef-57bb-8dd1-8a2b7c42e9e2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '65a0e292-9fb4-5901-a307-243796ef4e9c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0c1e4785-031c-56fb-a400-65ff60bf4a00', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-1', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', 'ee5a97ac-002e-50ee-bd32-8dc56a2cebec', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ee5a97ac-002e-50ee-bd32-8dc56a2cebec';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0c1e4785-031c-56fb-a400-65ff60bf4a00', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('0c1e4785-031c-56fb-a400-65ff60bf4a00', 'ee5a97ac-002e-50ee-bd32-8dc56a2cebec', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0c1e4785-031c-56fb-a400-65ff60bf4a00';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c133d136-bc4d-55cd-a43c-8e2c81ce79d1', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-2', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', '435b8dc1-2f3a-5772-85d4-bcf0089c0244', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '435b8dc1-2f3a-5772-85d4-bcf0089c0244';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c133d136-bc4d-55cd-a43c-8e2c81ce79d1', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('c133d136-bc4d-55cd-a43c-8e2c81ce79d1', '435b8dc1-2f3a-5772-85d4-bcf0089c0244', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c133d136-bc4d-55cd-a43c-8e2c81ce79d1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('29240184-03d6-56c7-9a7f-c4c8d3a5ecc9', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-3', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', 'fb4bad34-7535-5ac0-9527-da20162182ef', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fb4bad34-7535-5ac0-9527-da20162182ef';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('29240184-03d6-56c7-9a7f-c4c8d3a5ecc9', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('29240184-03d6-56c7-9a7f-c4c8d3a5ecc9', 'fb4bad34-7535-5ac0-9527-da20162182ef', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '29240184-03d6-56c7-9a7f-c4c8d3a5ecc9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9a7a5f20-586d-54db-abbc-34ac60402576', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-4', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', 'e539ce6e-20c6-5586-8519-23ed2533ce12', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e539ce6e-20c6-5586-8519-23ed2533ce12';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9a7a5f20-586d-54db-abbc-34ac60402576', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('9a7a5f20-586d-54db-abbc-34ac60402576', 'e539ce6e-20c6-5586-8519-23ed2533ce12', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9a7a5f20-586d-54db-abbc-34ac60402576';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e9881939-02b3-5c91-97eb-a8387123c949', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-5', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', 'd8fee546-01b9-5780-9c31-708e19536509', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd8fee546-01b9-5780-9c31-708e19536509';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e9881939-02b3-5c91-97eb-a8387123c949', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('e9881939-02b3-5c91-97eb-a8387123c949', 'd8fee546-01b9-5780-9c31-708e19536509', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e9881939-02b3-5c91-97eb-a8387123c949';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('29859788-3bd3-5cdf-a901-2bc8d695cc34', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-6', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', 'f5518863-4767-5d80-8267-f58b1eb6ad93', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f5518863-4767-5d80-8267-f58b1eb6ad93';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('29859788-3bd3-5cdf-a901-2bc8d695cc34', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('29859788-3bd3-5cdf-a901-2bc8d695cc34', 'f5518863-4767-5d80-8267-f58b1eb6ad93', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '29859788-3bd3-5cdf-a901-2bc8d695cc34';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('2835873f-f7d4-533f-b31b-61dd72e6e29d', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-7', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', 'eb64ab2d-9f09-5532-886b-866363bb43ef', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'eb64ab2d-9f09-5532-886b-866363bb43ef';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('2835873f-f7d4-533f-b31b-61dd72e6e29d', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('2835873f-f7d4-533f-b31b-61dd72e6e29d', 'eb64ab2d-9f09-5532-886b-866363bb43ef', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '2835873f-f7d4-533f-b31b-61dd72e6e29d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e2e3868b-091f-5227-a5aa-7b6e1b693fa5', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-8', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', '5ddce7c2-4d5e-519d-b8b4-2758e9dadd35', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5ddce7c2-4d5e-519d-b8b4-2758e9dadd35';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e2e3868b-091f-5227-a5aa-7b6e1b693fa5', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('e2e3868b-091f-5227-a5aa-7b6e1b693fa5', '5ddce7c2-4d5e-519d-b8b4-2758e9dadd35', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e2e3868b-091f-5227-a5aa-7b6e1b693fa5';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d7528fc9-fb24-5212-801f-1db56c62b54c', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-9', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', '33b3d4f8-c51e-5639-8e82-9856ac438ff4', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '33b3d4f8-c51e-5639-8e82-9856ac438ff4';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d7528fc9-fb24-5212-801f-1db56c62b54c', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('d7528fc9-fb24-5212-801f-1db56c62b54c', '33b3d4f8-c51e-5639-8e82-9856ac438ff4', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd7528fc9-fb24-5212-801f-1db56c62b54c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7fbd8b34-0e63-591b-9e1c-49c25a5d7c47', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-10', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', '0b1fa046-1541-5bc4-bdd4-95002fcab47c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0b1fa046-1541-5bc4-bdd4-95002fcab47c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7fbd8b34-0e63-591b-9e1c-49c25a5d7c47', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('7fbd8b34-0e63-591b-9e1c-49c25a5d7c47', '0b1fa046-1541-5bc4-bdd4-95002fcab47c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7fbd8b34-0e63-591b-9e1c-49c25a5d7c47';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f4ef841f-f492-5297-b250-5a73228d3eb6', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-11', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', '4624d5e1-0458-5078-89ca-15d99668c639', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4624d5e1-0458-5078-89ca-15d99668c639';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f4ef841f-f492-5297-b250-5a73228d3eb6', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('f4ef841f-f492-5297-b250-5a73228d3eb6', '4624d5e1-0458-5078-89ca-15d99668c639', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f4ef841f-f492-5297-b250-5a73228d3eb6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5daed7eb-2b9e-5cb3-aa96-71610c02bc47', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-12', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', '3a560555-f7e3-576d-b54b-22827e5cf019', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3a560555-f7e3-576d-b54b-22827e5cf019';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5daed7eb-2b9e-5cb3-aa96-71610c02bc47', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('5daed7eb-2b9e-5cb3-aa96-71610c02bc47', '3a560555-f7e3-576d-b54b-22827e5cf019', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5daed7eb-2b9e-5cb3-aa96-71610c02bc47';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7e3b81a2-82c5-50fa-ba50-c27e9748d820', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-13', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', 'a73e5f18-1cc2-5555-82b6-79d03015a2c7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a73e5f18-1cc2-5555-82b6-79d03015a2c7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7e3b81a2-82c5-50fa-ba50-c27e9748d820', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('7e3b81a2-82c5-50fa-ba50-c27e9748d820', 'a73e5f18-1cc2-5555-82b6-79d03015a2c7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7e3b81a2-82c5-50fa-ba50-c27e9748d820';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('13cf62eb-ece0-5a9b-949b-ae8be87c0ce0', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-14', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', 'c460d13d-548c-5825-a293-4720850abdc7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c460d13d-548c-5825-a293-4720850abdc7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('13cf62eb-ece0-5a9b-949b-ae8be87c0ce0', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('13cf62eb-ece0-5a9b-949b-ae8be87c0ce0', 'c460d13d-548c-5825-a293-4720850abdc7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '13cf62eb-ece0-5a9b-949b-ae8be87c0ce0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ef98f12b-e4d8-520d-81a4-b9c2b8c5cf19', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-15', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', '5595934f-5bdc-5eab-9b12-fe75fd65de5b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5595934f-5bdc-5eab-9b12-fe75fd65de5b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ef98f12b-e4d8-520d-81a4-b9c2b8c5cf19', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('ef98f12b-e4d8-520d-81a4-b9c2b8c5cf19', '5595934f-5bdc-5eab-9b12-fe75fd65de5b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ef98f12b-e4d8-520d-81a4-b9c2b8c5cf19';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('81936de2-a402-5600-8ecd-aa0be467dfda', 'benchmark-funding-2f481b4c-8908-4b18-8a88-0fd2d4e20fa6-16', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', 'e356a37b-95b9-534c-8689-5cce7c478a11', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'bc22d0c8-2899-5fc8-96d9-3751056183c1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e356a37b-95b9-534c-8689-5cce7c478a11';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('81936de2-a402-5600-8ecd-aa0be467dfda', 'bc22d0c8-2899-5fc8-96d9-3751056183c1', -1000000000), ('81936de2-a402-5600-8ecd-aa0be467dfda', 'e356a37b-95b9-534c-8689-5cce7c478a11', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '81936de2-a402-5600-8ecd-aa0be467dfda';
COMMIT;
