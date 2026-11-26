-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('09cbf02f-7760-504e-836d-850371637be0', 'USER', 'ACTIVE', 'FIC'),
('1d1ab36f-4ca5-5393-86f7-fd2b62252792', 'USER', 'ACTIVE', 'FIC'),
('23545f92-9d70-5b80-8545-19f954eace8a', 'USER', 'ACTIVE', 'FIC'),
('275411d2-23cf-5e4c-8a7f-982916cfff9f', 'USER', 'ACTIVE', 'FIC'),
('2cb9697d-0237-5e27-ba6a-5e442dac71c3', 'USER', 'ACTIVE', 'FIC'),
('35a2ed78-a327-54b9-a165-faccfc9c74ea', 'USER', 'ACTIVE', 'FIC'),
('38c154a1-b5cb-5a87-8da1-29e92e1f364d', 'USER', 'ACTIVE', 'FIC'),
('4235d9b7-4e8d-5199-a647-fba2e1f62b75', 'USER', 'ACTIVE', 'FIC'),
('4b9279c6-5d66-5ec3-92df-4334da7007ea', 'USER', 'ACTIVE', 'FIC'),
('4ef069bb-e67f-5ccd-a901-b53c158eaacd', 'USER', 'ACTIVE', 'FIC'),
('5e47004e-3c15-58af-b6f7-828202509502', 'ISSUANCE', 'ACTIVE', 'FIC'),
('648cfaa4-5dbc-5e4e-8a13-fb40a0ced734', 'USER', 'ACTIVE', 'FIC'),
('6b3b9755-8a6b-5b3e-8191-9bbb4fa6167c', 'USER', 'ACTIVE', 'FIC'),
('72866f57-8ec3-53a1-b90e-de6e6ab6c11e', 'USER', 'ACTIVE', 'FIC'),
('7888d045-6af3-523b-afb7-5b9620a5ff06', 'USER', 'ACTIVE', 'FIC'),
('80c2e197-d438-51b4-867f-9c886a283c6d', 'USER', 'ACTIVE', 'FIC'),
('b5ff3a45-459a-5364-a417-cc28fa18e48f', 'USER', 'ACTIVE', 'FIC'),
('b9adc7b9-f5ec-5478-b555-3b89bcbfb737', 'USER', 'ACTIVE', 'FIC'),
('c659d573-7fd6-5432-a980-38e0bab7b30a', 'USER', 'ACTIVE', 'FIC'),
('c81aafaf-ea8a-55d0-ad6d-28b6fadaf7a1', 'USER', 'ACTIVE', 'FIC'),
('ddf1660c-9789-5bbb-adee-23e8678feb44', 'USER', 'ACTIVE', 'FIC'),
('e904324c-9496-5af5-b7e0-e2cb11223d4c', 'USER', 'ACTIVE', 'FIC'),
('e91e2199-f968-5262-8044-f3516b1b40e6', 'USER', 'ACTIVE', 'FIC'),
('f4c954a5-673a-5b45-bd80-5c00c823cfe2', 'USER', 'ACTIVE', 'FIC'),
('fcd3cc6d-8ba8-52a4-8788-e515d92638a2', 'USER', 'ACTIVE', 'FIC'),
('fed67eb3-b2a6-506b-ad4d-adb2ba984dc6', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('09cbf02f-7760-504e-836d-850371637be0', 0),
('1d1ab36f-4ca5-5393-86f7-fd2b62252792', 0),
('23545f92-9d70-5b80-8545-19f954eace8a', 0),
('275411d2-23cf-5e4c-8a7f-982916cfff9f', 0),
('2cb9697d-0237-5e27-ba6a-5e442dac71c3', 0),
('35a2ed78-a327-54b9-a165-faccfc9c74ea', 0),
('38c154a1-b5cb-5a87-8da1-29e92e1f364d', 0),
('4235d9b7-4e8d-5199-a647-fba2e1f62b75', 0),
('4b9279c6-5d66-5ec3-92df-4334da7007ea', 0),
('4ef069bb-e67f-5ccd-a901-b53c158eaacd', 0),
('5e47004e-3c15-58af-b6f7-828202509502', 0),
('648cfaa4-5dbc-5e4e-8a13-fb40a0ced734', 0),
('6b3b9755-8a6b-5b3e-8191-9bbb4fa6167c', 0),
('72866f57-8ec3-53a1-b90e-de6e6ab6c11e', 0),
('7888d045-6af3-523b-afb7-5b9620a5ff06', 0),
('80c2e197-d438-51b4-867f-9c886a283c6d', 0),
('b5ff3a45-459a-5364-a417-cc28fa18e48f', 0),
('b9adc7b9-f5ec-5478-b555-3b89bcbfb737', 0),
('c659d573-7fd6-5432-a980-38e0bab7b30a', 0),
('c81aafaf-ea8a-55d0-ad6d-28b6fadaf7a1', 0),
('ddf1660c-9789-5bbb-adee-23e8678feb44', 0),
('e904324c-9496-5af5-b7e0-e2cb11223d4c', 0),
('e91e2199-f968-5262-8044-f3516b1b40e6', 0),
('f4c954a5-673a-5b45-bd80-5c00c823cfe2', 0),
('fcd3cc6d-8ba8-52a4-8788-e515d92638a2', 0),
('fed67eb3-b2a6-506b-ad4d-adb2ba984dc6', 0);
SELECT account_id FROM balances WHERE account_id IN ('09cbf02f-7760-504e-836d-850371637be0','1d1ab36f-4ca5-5393-86f7-fd2b62252792','23545f92-9d70-5b80-8545-19f954eace8a','275411d2-23cf-5e4c-8a7f-982916cfff9f','2cb9697d-0237-5e27-ba6a-5e442dac71c3','35a2ed78-a327-54b9-a165-faccfc9c74ea','38c154a1-b5cb-5a87-8da1-29e92e1f364d','4235d9b7-4e8d-5199-a647-fba2e1f62b75','4b9279c6-5d66-5ec3-92df-4334da7007ea','4ef069bb-e67f-5ccd-a901-b53c158eaacd','5e47004e-3c15-58af-b6f7-828202509502','648cfaa4-5dbc-5e4e-8a13-fb40a0ced734','6b3b9755-8a6b-5b3e-8191-9bbb4fa6167c','72866f57-8ec3-53a1-b90e-de6e6ab6c11e','7888d045-6af3-523b-afb7-5b9620a5ff06','80c2e197-d438-51b4-867f-9c886a283c6d','b5ff3a45-459a-5364-a417-cc28fa18e48f','b9adc7b9-f5ec-5478-b555-3b89bcbfb737','c659d573-7fd6-5432-a980-38e0bab7b30a','c81aafaf-ea8a-55d0-ad6d-28b6fadaf7a1','ddf1660c-9789-5bbb-adee-23e8678feb44','e904324c-9496-5af5-b7e0-e2cb11223d4c','e91e2199-f968-5262-8044-f3516b1b40e6','f4c954a5-673a-5b45-bd80-5c00c823cfe2','fcd3cc6d-8ba8-52a4-8788-e515d92638a2','fed67eb3-b2a6-506b-ad4d-adb2ba984dc6') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1fb48343-8dcc-57de-af45-b4b9604598a4', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-0', '5e47004e-3c15-58af-b6f7-828202509502', '6b3b9755-8a6b-5b3e-8191-9bbb4fa6167c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6b3b9755-8a6b-5b3e-8191-9bbb4fa6167c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1fb48343-8dcc-57de-af45-b4b9604598a4', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('1fb48343-8dcc-57de-af45-b4b9604598a4', '6b3b9755-8a6b-5b3e-8191-9bbb4fa6167c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1fb48343-8dcc-57de-af45-b4b9604598a4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('569ea1b4-e0eb-560a-9c15-0d5c8267d978', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-1', '5e47004e-3c15-58af-b6f7-828202509502', '09cbf02f-7760-504e-836d-850371637be0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '09cbf02f-7760-504e-836d-850371637be0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('569ea1b4-e0eb-560a-9c15-0d5c8267d978', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('569ea1b4-e0eb-560a-9c15-0d5c8267d978', '09cbf02f-7760-504e-836d-850371637be0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '569ea1b4-e0eb-560a-9c15-0d5c8267d978';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('840754f6-7890-5fda-97a8-40dc49ea044e', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-2', '5e47004e-3c15-58af-b6f7-828202509502', '7888d045-6af3-523b-afb7-5b9620a5ff06', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7888d045-6af3-523b-afb7-5b9620a5ff06';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('840754f6-7890-5fda-97a8-40dc49ea044e', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('840754f6-7890-5fda-97a8-40dc49ea044e', '7888d045-6af3-523b-afb7-5b9620a5ff06', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '840754f6-7890-5fda-97a8-40dc49ea044e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ac3294d5-bd56-5981-91d3-e1bc70cf9704', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-3', '5e47004e-3c15-58af-b6f7-828202509502', '38c154a1-b5cb-5a87-8da1-29e92e1f364d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '38c154a1-b5cb-5a87-8da1-29e92e1f364d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ac3294d5-bd56-5981-91d3-e1bc70cf9704', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('ac3294d5-bd56-5981-91d3-e1bc70cf9704', '38c154a1-b5cb-5a87-8da1-29e92e1f364d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ac3294d5-bd56-5981-91d3-e1bc70cf9704';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e136e405-9bac-5a2f-9e55-b62bbe877eab', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-4', '5e47004e-3c15-58af-b6f7-828202509502', '35a2ed78-a327-54b9-a165-faccfc9c74ea', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '35a2ed78-a327-54b9-a165-faccfc9c74ea';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e136e405-9bac-5a2f-9e55-b62bbe877eab', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('e136e405-9bac-5a2f-9e55-b62bbe877eab', '35a2ed78-a327-54b9-a165-faccfc9c74ea', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e136e405-9bac-5a2f-9e55-b62bbe877eab';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('74f1cabd-d752-57ea-8ef6-3628ddb40339', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-5', '5e47004e-3c15-58af-b6f7-828202509502', 'b5ff3a45-459a-5364-a417-cc28fa18e48f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b5ff3a45-459a-5364-a417-cc28fa18e48f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('74f1cabd-d752-57ea-8ef6-3628ddb40339', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('74f1cabd-d752-57ea-8ef6-3628ddb40339', 'b5ff3a45-459a-5364-a417-cc28fa18e48f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '74f1cabd-d752-57ea-8ef6-3628ddb40339';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e23db649-1121-5384-86aa-0ce04dcb9ca8', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-6', '5e47004e-3c15-58af-b6f7-828202509502', '72866f57-8ec3-53a1-b90e-de6e6ab6c11e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '72866f57-8ec3-53a1-b90e-de6e6ab6c11e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e23db649-1121-5384-86aa-0ce04dcb9ca8', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('e23db649-1121-5384-86aa-0ce04dcb9ca8', '72866f57-8ec3-53a1-b90e-de6e6ab6c11e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e23db649-1121-5384-86aa-0ce04dcb9ca8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('34210dd0-61e7-5917-b6fd-245b0101a728', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-7', '5e47004e-3c15-58af-b6f7-828202509502', 'ddf1660c-9789-5bbb-adee-23e8678feb44', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ddf1660c-9789-5bbb-adee-23e8678feb44';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('34210dd0-61e7-5917-b6fd-245b0101a728', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('34210dd0-61e7-5917-b6fd-245b0101a728', 'ddf1660c-9789-5bbb-adee-23e8678feb44', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '34210dd0-61e7-5917-b6fd-245b0101a728';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4d2d45c4-f47d-51b5-a5cd-f461e02f88a4', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-8', '5e47004e-3c15-58af-b6f7-828202509502', '4ef069bb-e67f-5ccd-a901-b53c158eaacd', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4ef069bb-e67f-5ccd-a901-b53c158eaacd';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4d2d45c4-f47d-51b5-a5cd-f461e02f88a4', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('4d2d45c4-f47d-51b5-a5cd-f461e02f88a4', '4ef069bb-e67f-5ccd-a901-b53c158eaacd', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4d2d45c4-f47d-51b5-a5cd-f461e02f88a4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d2c6e044-bbc9-5003-9019-52e366a668c4', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-9', '5e47004e-3c15-58af-b6f7-828202509502', '23545f92-9d70-5b80-8545-19f954eace8a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '23545f92-9d70-5b80-8545-19f954eace8a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d2c6e044-bbc9-5003-9019-52e366a668c4', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('d2c6e044-bbc9-5003-9019-52e366a668c4', '23545f92-9d70-5b80-8545-19f954eace8a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd2c6e044-bbc9-5003-9019-52e366a668c4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3a22a2ef-f9fa-5f18-b4ce-6b80e6e37be8', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-10', '5e47004e-3c15-58af-b6f7-828202509502', 'c81aafaf-ea8a-55d0-ad6d-28b6fadaf7a1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c81aafaf-ea8a-55d0-ad6d-28b6fadaf7a1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3a22a2ef-f9fa-5f18-b4ce-6b80e6e37be8', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('3a22a2ef-f9fa-5f18-b4ce-6b80e6e37be8', 'c81aafaf-ea8a-55d0-ad6d-28b6fadaf7a1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3a22a2ef-f9fa-5f18-b4ce-6b80e6e37be8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('828cdae6-a078-5972-bc8b-accab0ef6f60', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-11', '5e47004e-3c15-58af-b6f7-828202509502', 'e91e2199-f968-5262-8044-f3516b1b40e6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e91e2199-f968-5262-8044-f3516b1b40e6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('828cdae6-a078-5972-bc8b-accab0ef6f60', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('828cdae6-a078-5972-bc8b-accab0ef6f60', 'e91e2199-f968-5262-8044-f3516b1b40e6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '828cdae6-a078-5972-bc8b-accab0ef6f60';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c7dbcce2-88fc-5865-8667-9419d1c01375', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-12', '5e47004e-3c15-58af-b6f7-828202509502', '80c2e197-d438-51b4-867f-9c886a283c6d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '80c2e197-d438-51b4-867f-9c886a283c6d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c7dbcce2-88fc-5865-8667-9419d1c01375', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('c7dbcce2-88fc-5865-8667-9419d1c01375', '80c2e197-d438-51b4-867f-9c886a283c6d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c7dbcce2-88fc-5865-8667-9419d1c01375';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a3ecc52f-cb1d-587a-a996-edfb5aba5fca', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-13', '5e47004e-3c15-58af-b6f7-828202509502', 'fed67eb3-b2a6-506b-ad4d-adb2ba984dc6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fed67eb3-b2a6-506b-ad4d-adb2ba984dc6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a3ecc52f-cb1d-587a-a996-edfb5aba5fca', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('a3ecc52f-cb1d-587a-a996-edfb5aba5fca', 'fed67eb3-b2a6-506b-ad4d-adb2ba984dc6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a3ecc52f-cb1d-587a-a996-edfb5aba5fca';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('2282c3da-b378-5817-8ca2-70ae023363a5', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-14', '5e47004e-3c15-58af-b6f7-828202509502', '275411d2-23cf-5e4c-8a7f-982916cfff9f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '275411d2-23cf-5e4c-8a7f-982916cfff9f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('2282c3da-b378-5817-8ca2-70ae023363a5', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('2282c3da-b378-5817-8ca2-70ae023363a5', '275411d2-23cf-5e4c-8a7f-982916cfff9f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '2282c3da-b378-5817-8ca2-70ae023363a5';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c99304ac-d020-51a3-bfd8-6a28ca5bd0fc', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-15', '5e47004e-3c15-58af-b6f7-828202509502', '4235d9b7-4e8d-5199-a647-fba2e1f62b75', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4235d9b7-4e8d-5199-a647-fba2e1f62b75';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c99304ac-d020-51a3-bfd8-6a28ca5bd0fc', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('c99304ac-d020-51a3-bfd8-6a28ca5bd0fc', '4235d9b7-4e8d-5199-a647-fba2e1f62b75', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c99304ac-d020-51a3-bfd8-6a28ca5bd0fc';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('721b92e4-a545-5e70-9a6e-56686859b857', 'benchmark-funding-86d49c25-61b6-4759-8929-06669a9e545c-16', '5e47004e-3c15-58af-b6f7-828202509502', 'b9adc7b9-f5ec-5478-b555-3b89bcbfb737', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '5e47004e-3c15-58af-b6f7-828202509502';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b9adc7b9-f5ec-5478-b555-3b89bcbfb737';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('721b92e4-a545-5e70-9a6e-56686859b857', '5e47004e-3c15-58af-b6f7-828202509502', -1000000000), ('721b92e4-a545-5e70-9a6e-56686859b857', 'b9adc7b9-f5ec-5478-b555-3b89bcbfb737', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '721b92e4-a545-5e70-9a6e-56686859b857';
COMMIT;
