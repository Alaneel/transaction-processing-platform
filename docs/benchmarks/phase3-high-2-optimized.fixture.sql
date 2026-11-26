-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('034b26ca-cafb-584b-9035-cfd0ec26a7ac', 'USER', 'ACTIVE', 'FIC'),
('064498ef-19b7-54ff-9155-fc146aad790a', 'USER', 'ACTIVE', 'FIC'),
('0bea1eb3-db0b-5b33-88ea-a51cd7df6dd2', 'USER', 'ACTIVE', 'FIC'),
('0e096a8d-2193-5abe-addb-4e1e51f30790', 'USER', 'ACTIVE', 'FIC'),
('4970ea60-e404-5fdc-bb7f-4620ea889ae3', 'USER', 'ACTIVE', 'FIC'),
('553c520f-2991-5a97-9d92-1eb2bbe028f3', 'USER', 'ACTIVE', 'FIC'),
('6263300b-0d3f-5cc6-a70d-06cde368b8a5', 'USER', 'ACTIVE', 'FIC'),
('62bda01c-65dc-50e6-ac89-1f793f7ed1b9', 'USER', 'ACTIVE', 'FIC'),
('6d2f84e3-b629-57a0-9027-8d7e7063d473', 'USER', 'ACTIVE', 'FIC'),
('7a31da4d-ecaf-5ae4-a32a-1f8c28cda93e', 'USER', 'ACTIVE', 'FIC'),
('89507405-83a1-5640-a6cd-fced1f2cfd20', 'USER', 'ACTIVE', 'FIC'),
('8a09d725-e4bd-56f1-9665-a45c4b099fe3', 'USER', 'ACTIVE', 'FIC'),
('99685b06-112c-5e48-afa7-88b11596e5f5', 'USER', 'ACTIVE', 'FIC'),
('a4876f5b-fe0f-53af-9760-cd9d461d3f51', 'USER', 'ACTIVE', 'FIC'),
('a4a3f7ce-81e4-5f49-bcf8-d1f10a7ef014', 'USER', 'ACTIVE', 'FIC'),
('ae2db29c-957e-5791-b1fe-384bdbee1ba6', 'USER', 'ACTIVE', 'FIC'),
('aedea2bc-fd8e-579c-a889-ee4182c79a8d', 'USER', 'ACTIVE', 'FIC'),
('bb82680d-0239-5d3f-8956-bbfe23853aab', 'USER', 'ACTIVE', 'FIC'),
('bff5d0ab-4730-531f-8de2-703b8ac66d68', 'USER', 'ACTIVE', 'FIC'),
('c2d782e8-2fd4-5803-a77d-8095e2ae072a', 'USER', 'ACTIVE', 'FIC'),
('dfe60281-2127-5433-bbf5-250bc693813b', 'USER', 'ACTIVE', 'FIC'),
('e355d5ff-eece-508f-8cf7-a212d9124c94', 'USER', 'ACTIVE', 'FIC'),
('eb20576a-93da-583e-a737-db377581404e', 'USER', 'ACTIVE', 'FIC'),
('eb6b41ad-b149-50ff-9545-16750ab98e5d', 'ISSUANCE', 'ACTIVE', 'FIC'),
('f1179411-3e30-5ddf-a17d-c5561c6c7bd8', 'USER', 'ACTIVE', 'FIC'),
('f54a5581-2879-53f9-9e0c-d1a1110baf42', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('034b26ca-cafb-584b-9035-cfd0ec26a7ac', 0),
('064498ef-19b7-54ff-9155-fc146aad790a', 0),
('0bea1eb3-db0b-5b33-88ea-a51cd7df6dd2', 0),
('0e096a8d-2193-5abe-addb-4e1e51f30790', 0),
('4970ea60-e404-5fdc-bb7f-4620ea889ae3', 0),
('553c520f-2991-5a97-9d92-1eb2bbe028f3', 0),
('6263300b-0d3f-5cc6-a70d-06cde368b8a5', 0),
('62bda01c-65dc-50e6-ac89-1f793f7ed1b9', 0),
('6d2f84e3-b629-57a0-9027-8d7e7063d473', 0),
('7a31da4d-ecaf-5ae4-a32a-1f8c28cda93e', 0),
('89507405-83a1-5640-a6cd-fced1f2cfd20', 0),
('8a09d725-e4bd-56f1-9665-a45c4b099fe3', 0),
('99685b06-112c-5e48-afa7-88b11596e5f5', 0),
('a4876f5b-fe0f-53af-9760-cd9d461d3f51', 0),
('a4a3f7ce-81e4-5f49-bcf8-d1f10a7ef014', 0),
('ae2db29c-957e-5791-b1fe-384bdbee1ba6', 0),
('aedea2bc-fd8e-579c-a889-ee4182c79a8d', 0),
('bb82680d-0239-5d3f-8956-bbfe23853aab', 0),
('bff5d0ab-4730-531f-8de2-703b8ac66d68', 0),
('c2d782e8-2fd4-5803-a77d-8095e2ae072a', 0),
('dfe60281-2127-5433-bbf5-250bc693813b', 0),
('e355d5ff-eece-508f-8cf7-a212d9124c94', 0),
('eb20576a-93da-583e-a737-db377581404e', 0),
('eb6b41ad-b149-50ff-9545-16750ab98e5d', 0),
('f1179411-3e30-5ddf-a17d-c5561c6c7bd8', 0),
('f54a5581-2879-53f9-9e0c-d1a1110baf42', 0);
SELECT account_id FROM balances WHERE account_id IN ('034b26ca-cafb-584b-9035-cfd0ec26a7ac','064498ef-19b7-54ff-9155-fc146aad790a','0bea1eb3-db0b-5b33-88ea-a51cd7df6dd2','0e096a8d-2193-5abe-addb-4e1e51f30790','4970ea60-e404-5fdc-bb7f-4620ea889ae3','553c520f-2991-5a97-9d92-1eb2bbe028f3','6263300b-0d3f-5cc6-a70d-06cde368b8a5','62bda01c-65dc-50e6-ac89-1f793f7ed1b9','6d2f84e3-b629-57a0-9027-8d7e7063d473','7a31da4d-ecaf-5ae4-a32a-1f8c28cda93e','89507405-83a1-5640-a6cd-fced1f2cfd20','8a09d725-e4bd-56f1-9665-a45c4b099fe3','99685b06-112c-5e48-afa7-88b11596e5f5','a4876f5b-fe0f-53af-9760-cd9d461d3f51','a4a3f7ce-81e4-5f49-bcf8-d1f10a7ef014','ae2db29c-957e-5791-b1fe-384bdbee1ba6','aedea2bc-fd8e-579c-a889-ee4182c79a8d','bb82680d-0239-5d3f-8956-bbfe23853aab','bff5d0ab-4730-531f-8de2-703b8ac66d68','c2d782e8-2fd4-5803-a77d-8095e2ae072a','dfe60281-2127-5433-bbf5-250bc693813b','e355d5ff-eece-508f-8cf7-a212d9124c94','eb20576a-93da-583e-a737-db377581404e','eb6b41ad-b149-50ff-9545-16750ab98e5d','f1179411-3e30-5ddf-a17d-c5561c6c7bd8','f54a5581-2879-53f9-9e0c-d1a1110baf42') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c9c6d527-3c39-5fe3-bc8f-58b3042bcab2', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-0', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', 'a4876f5b-fe0f-53af-9760-cd9d461d3f51', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a4876f5b-fe0f-53af-9760-cd9d461d3f51';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c9c6d527-3c39-5fe3-bc8f-58b3042bcab2', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('c9c6d527-3c39-5fe3-bc8f-58b3042bcab2', 'a4876f5b-fe0f-53af-9760-cd9d461d3f51', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c9c6d527-3c39-5fe3-bc8f-58b3042bcab2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3d52a0a2-5a14-599c-ac0a-007a79fa6ff8', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-1', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', '8a09d725-e4bd-56f1-9665-a45c4b099fe3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8a09d725-e4bd-56f1-9665-a45c4b099fe3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3d52a0a2-5a14-599c-ac0a-007a79fa6ff8', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('3d52a0a2-5a14-599c-ac0a-007a79fa6ff8', '8a09d725-e4bd-56f1-9665-a45c4b099fe3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3d52a0a2-5a14-599c-ac0a-007a79fa6ff8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9165f6b9-2903-5a33-88f4-0810897e33af', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-2', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', '4970ea60-e404-5fdc-bb7f-4620ea889ae3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4970ea60-e404-5fdc-bb7f-4620ea889ae3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9165f6b9-2903-5a33-88f4-0810897e33af', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('9165f6b9-2903-5a33-88f4-0810897e33af', '4970ea60-e404-5fdc-bb7f-4620ea889ae3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9165f6b9-2903-5a33-88f4-0810897e33af';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('dcc3c11c-8102-5d97-8cbb-24cfeb7b6af6', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-3', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', '6263300b-0d3f-5cc6-a70d-06cde368b8a5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6263300b-0d3f-5cc6-a70d-06cde368b8a5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('dcc3c11c-8102-5d97-8cbb-24cfeb7b6af6', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('dcc3c11c-8102-5d97-8cbb-24cfeb7b6af6', '6263300b-0d3f-5cc6-a70d-06cde368b8a5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'dcc3c11c-8102-5d97-8cbb-24cfeb7b6af6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0b241171-c8ee-56d4-a142-3e6dd7c8ece2', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-4', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', 'e355d5ff-eece-508f-8cf7-a212d9124c94', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e355d5ff-eece-508f-8cf7-a212d9124c94';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0b241171-c8ee-56d4-a142-3e6dd7c8ece2', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('0b241171-c8ee-56d4-a142-3e6dd7c8ece2', 'e355d5ff-eece-508f-8cf7-a212d9124c94', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0b241171-c8ee-56d4-a142-3e6dd7c8ece2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3d491d26-6d74-58ae-8160-c075fd51c299', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-5', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', '99685b06-112c-5e48-afa7-88b11596e5f5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '99685b06-112c-5e48-afa7-88b11596e5f5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3d491d26-6d74-58ae-8160-c075fd51c299', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('3d491d26-6d74-58ae-8160-c075fd51c299', '99685b06-112c-5e48-afa7-88b11596e5f5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3d491d26-6d74-58ae-8160-c075fd51c299';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3b08e310-866d-52e4-b209-f25e8096c8ec', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-6', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', 'f54a5581-2879-53f9-9e0c-d1a1110baf42', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f54a5581-2879-53f9-9e0c-d1a1110baf42';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3b08e310-866d-52e4-b209-f25e8096c8ec', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('3b08e310-866d-52e4-b209-f25e8096c8ec', 'f54a5581-2879-53f9-9e0c-d1a1110baf42', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3b08e310-866d-52e4-b209-f25e8096c8ec';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('db44d861-5a96-54fd-af1d-5d65231846fd', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-7', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', '064498ef-19b7-54ff-9155-fc146aad790a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '064498ef-19b7-54ff-9155-fc146aad790a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('db44d861-5a96-54fd-af1d-5d65231846fd', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('db44d861-5a96-54fd-af1d-5d65231846fd', '064498ef-19b7-54ff-9155-fc146aad790a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'db44d861-5a96-54fd-af1d-5d65231846fd';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4594d291-999b-59a9-89e4-d8ef5678b447', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-8', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', '0e096a8d-2193-5abe-addb-4e1e51f30790', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0e096a8d-2193-5abe-addb-4e1e51f30790';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4594d291-999b-59a9-89e4-d8ef5678b447', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('4594d291-999b-59a9-89e4-d8ef5678b447', '0e096a8d-2193-5abe-addb-4e1e51f30790', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4594d291-999b-59a9-89e4-d8ef5678b447';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('33d4abdc-166f-5972-8302-633b5b3569ff', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-9', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', '553c520f-2991-5a97-9d92-1eb2bbe028f3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '553c520f-2991-5a97-9d92-1eb2bbe028f3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('33d4abdc-166f-5972-8302-633b5b3569ff', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('33d4abdc-166f-5972-8302-633b5b3569ff', '553c520f-2991-5a97-9d92-1eb2bbe028f3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '33d4abdc-166f-5972-8302-633b5b3569ff';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6d06ac4e-f652-5c1f-9cf8-29a963b68433', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-10', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', 'c2d782e8-2fd4-5803-a77d-8095e2ae072a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c2d782e8-2fd4-5803-a77d-8095e2ae072a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6d06ac4e-f652-5c1f-9cf8-29a963b68433', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('6d06ac4e-f652-5c1f-9cf8-29a963b68433', 'c2d782e8-2fd4-5803-a77d-8095e2ae072a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6d06ac4e-f652-5c1f-9cf8-29a963b68433';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b6657bbc-c3ad-5769-92a7-7a4f784003ac', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-11', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', 'bff5d0ab-4730-531f-8de2-703b8ac66d68', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'bff5d0ab-4730-531f-8de2-703b8ac66d68';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b6657bbc-c3ad-5769-92a7-7a4f784003ac', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('b6657bbc-c3ad-5769-92a7-7a4f784003ac', 'bff5d0ab-4730-531f-8de2-703b8ac66d68', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b6657bbc-c3ad-5769-92a7-7a4f784003ac';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e5704eca-c41b-5064-b1fb-b7bb69d874dd', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-12', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', 'aedea2bc-fd8e-579c-a889-ee4182c79a8d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'aedea2bc-fd8e-579c-a889-ee4182c79a8d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e5704eca-c41b-5064-b1fb-b7bb69d874dd', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('e5704eca-c41b-5064-b1fb-b7bb69d874dd', 'aedea2bc-fd8e-579c-a889-ee4182c79a8d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e5704eca-c41b-5064-b1fb-b7bb69d874dd';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ef23d17e-1355-510d-9307-5624948ad71d', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-13', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', 'eb20576a-93da-583e-a737-db377581404e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'eb20576a-93da-583e-a737-db377581404e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ef23d17e-1355-510d-9307-5624948ad71d', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('ef23d17e-1355-510d-9307-5624948ad71d', 'eb20576a-93da-583e-a737-db377581404e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ef23d17e-1355-510d-9307-5624948ad71d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('251d78b1-9f17-50d8-9992-ceb577f92098', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-14', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', 'a4a3f7ce-81e4-5f49-bcf8-d1f10a7ef014', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a4a3f7ce-81e4-5f49-bcf8-d1f10a7ef014';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('251d78b1-9f17-50d8-9992-ceb577f92098', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('251d78b1-9f17-50d8-9992-ceb577f92098', 'a4a3f7ce-81e4-5f49-bcf8-d1f10a7ef014', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '251d78b1-9f17-50d8-9992-ceb577f92098';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('34ab4afe-b0e4-5edc-9082-0c5d007cee07', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-15', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', '0bea1eb3-db0b-5b33-88ea-a51cd7df6dd2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0bea1eb3-db0b-5b33-88ea-a51cd7df6dd2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('34ab4afe-b0e4-5edc-9082-0c5d007cee07', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('34ab4afe-b0e4-5edc-9082-0c5d007cee07', '0bea1eb3-db0b-5b33-88ea-a51cd7df6dd2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '34ab4afe-b0e4-5edc-9082-0c5d007cee07';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7e820511-ab4f-516c-a578-8555a1fd9cd7', 'benchmark-funding-a80c7dd6-7ebd-46d1-9621-add21955108e-16', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', '62bda01c-65dc-50e6-ac89-1f793f7ed1b9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'eb6b41ad-b149-50ff-9545-16750ab98e5d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '62bda01c-65dc-50e6-ac89-1f793f7ed1b9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7e820511-ab4f-516c-a578-8555a1fd9cd7', 'eb6b41ad-b149-50ff-9545-16750ab98e5d', -1000000000), ('7e820511-ab4f-516c-a578-8555a1fd9cd7', '62bda01c-65dc-50e6-ac89-1f793f7ed1b9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7e820511-ab4f-516c-a578-8555a1fd9cd7';
COMMIT;
