-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('03bc04b9-2816-5633-adf4-ba0ef1b55cd8', 'USER', 'ACTIVE', 'FIC'),
('122a7f35-6e24-5203-83af-df61f27b9e83', 'USER', 'ACTIVE', 'FIC'),
('1381eac2-3670-59aa-95a7-dc7beaba1db1', 'USER', 'ACTIVE', 'FIC'),
('1b244072-398c-5d69-a07a-83be492fcd51', 'USER', 'ACTIVE', 'FIC'),
('1ffb855b-f43d-5809-8743-ed813a44735c', 'USER', 'ACTIVE', 'FIC'),
('22443a41-d4f4-5169-a11c-c0587c43729a', 'USER', 'ACTIVE', 'FIC'),
('274b31f1-c63b-5e9d-9a26-fb9d4998db85', 'USER', 'ACTIVE', 'FIC'),
('36b51e36-9b9c-5ede-9c69-9e5714696159', 'USER', 'ACTIVE', 'FIC'),
('39d70e22-cc76-5bfa-9827-930453457cc5', 'USER', 'ACTIVE', 'FIC'),
('3a20afbd-1738-5b1d-8b02-0f153bfb7c92', 'USER', 'ACTIVE', 'FIC'),
('3a364332-eff1-5390-8ad7-d6e563477aaf', 'USER', 'ACTIVE', 'FIC'),
('4721cd96-ccd9-55af-b9c9-c81703e31b8d', 'ISSUANCE', 'ACTIVE', 'FIC'),
('4805aa68-f435-5d58-a2b1-2fd3ce210406', 'USER', 'ACTIVE', 'FIC'),
('50392d10-7c56-5508-ab49-ceeb8739378a', 'USER', 'ACTIVE', 'FIC'),
('577fccff-7340-56df-a932-2c8aa80fbe3e', 'USER', 'ACTIVE', 'FIC'),
('5b19e40e-0ffc-5895-b79f-da21bacdd392', 'USER', 'ACTIVE', 'FIC'),
('5d27fc96-afbb-5687-b6f9-a0251fbf68db', 'USER', 'ACTIVE', 'FIC'),
('640d80ec-fd4d-5e51-bd30-7fe36a84fc7d', 'USER', 'ACTIVE', 'FIC'),
('69ed5dd1-6b03-5711-8392-4ceca8e01e8e', 'USER', 'ACTIVE', 'FIC'),
('6fcac232-289b-5086-8c27-52f114ffc0b1', 'USER', 'ACTIVE', 'FIC'),
('734ea41d-6a7b-5f6e-a07c-2f7adbf6e816', 'USER', 'ACTIVE', 'FIC'),
('83753e3d-997b-518a-9427-1dec10c09942', 'USER', 'ACTIVE', 'FIC'),
('8f742b80-ac73-550a-8419-7aa9dd0d79fe', 'USER', 'ACTIVE', 'FIC'),
('ae37f001-b707-5940-ba5d-061d55bd35d2', 'USER', 'ACTIVE', 'FIC'),
('edc87966-9ae2-553e-88f3-f1c4432b1807', 'USER', 'ACTIVE', 'FIC'),
('f383f898-f55e-5f66-8c3c-8b485eb20db3', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('03bc04b9-2816-5633-adf4-ba0ef1b55cd8', 0),
('122a7f35-6e24-5203-83af-df61f27b9e83', 0),
('1381eac2-3670-59aa-95a7-dc7beaba1db1', 0),
('1b244072-398c-5d69-a07a-83be492fcd51', 0),
('1ffb855b-f43d-5809-8743-ed813a44735c', 0),
('22443a41-d4f4-5169-a11c-c0587c43729a', 0),
('274b31f1-c63b-5e9d-9a26-fb9d4998db85', 0),
('36b51e36-9b9c-5ede-9c69-9e5714696159', 0),
('39d70e22-cc76-5bfa-9827-930453457cc5', 0),
('3a20afbd-1738-5b1d-8b02-0f153bfb7c92', 0),
('3a364332-eff1-5390-8ad7-d6e563477aaf', 0),
('4721cd96-ccd9-55af-b9c9-c81703e31b8d', 0),
('4805aa68-f435-5d58-a2b1-2fd3ce210406', 0),
('50392d10-7c56-5508-ab49-ceeb8739378a', 0),
('577fccff-7340-56df-a932-2c8aa80fbe3e', 0),
('5b19e40e-0ffc-5895-b79f-da21bacdd392', 0),
('5d27fc96-afbb-5687-b6f9-a0251fbf68db', 0),
('640d80ec-fd4d-5e51-bd30-7fe36a84fc7d', 0),
('69ed5dd1-6b03-5711-8392-4ceca8e01e8e', 0),
('6fcac232-289b-5086-8c27-52f114ffc0b1', 0),
('734ea41d-6a7b-5f6e-a07c-2f7adbf6e816', 0),
('83753e3d-997b-518a-9427-1dec10c09942', 0),
('8f742b80-ac73-550a-8419-7aa9dd0d79fe', 0),
('ae37f001-b707-5940-ba5d-061d55bd35d2', 0),
('edc87966-9ae2-553e-88f3-f1c4432b1807', 0),
('f383f898-f55e-5f66-8c3c-8b485eb20db3', 0);
SELECT account_id FROM balances WHERE account_id IN ('03bc04b9-2816-5633-adf4-ba0ef1b55cd8','122a7f35-6e24-5203-83af-df61f27b9e83','1381eac2-3670-59aa-95a7-dc7beaba1db1','1b244072-398c-5d69-a07a-83be492fcd51','1ffb855b-f43d-5809-8743-ed813a44735c','22443a41-d4f4-5169-a11c-c0587c43729a','274b31f1-c63b-5e9d-9a26-fb9d4998db85','36b51e36-9b9c-5ede-9c69-9e5714696159','39d70e22-cc76-5bfa-9827-930453457cc5','3a20afbd-1738-5b1d-8b02-0f153bfb7c92','3a364332-eff1-5390-8ad7-d6e563477aaf','4721cd96-ccd9-55af-b9c9-c81703e31b8d','4805aa68-f435-5d58-a2b1-2fd3ce210406','50392d10-7c56-5508-ab49-ceeb8739378a','577fccff-7340-56df-a932-2c8aa80fbe3e','5b19e40e-0ffc-5895-b79f-da21bacdd392','5d27fc96-afbb-5687-b6f9-a0251fbf68db','640d80ec-fd4d-5e51-bd30-7fe36a84fc7d','69ed5dd1-6b03-5711-8392-4ceca8e01e8e','6fcac232-289b-5086-8c27-52f114ffc0b1','734ea41d-6a7b-5f6e-a07c-2f7adbf6e816','83753e3d-997b-518a-9427-1dec10c09942','8f742b80-ac73-550a-8419-7aa9dd0d79fe','ae37f001-b707-5940-ba5d-061d55bd35d2','edc87966-9ae2-553e-88f3-f1c4432b1807','f383f898-f55e-5f66-8c3c-8b485eb20db3') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('fc77411f-7a61-5790-98da-9c3f941936d9', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-0', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', '3a20afbd-1738-5b1d-8b02-0f153bfb7c92', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3a20afbd-1738-5b1d-8b02-0f153bfb7c92';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('fc77411f-7a61-5790-98da-9c3f941936d9', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('fc77411f-7a61-5790-98da-9c3f941936d9', '3a20afbd-1738-5b1d-8b02-0f153bfb7c92', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'fc77411f-7a61-5790-98da-9c3f941936d9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e2b6e867-55ea-5352-9f2f-e55ded8bb6d9', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-1', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', '4805aa68-f435-5d58-a2b1-2fd3ce210406', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4805aa68-f435-5d58-a2b1-2fd3ce210406';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e2b6e867-55ea-5352-9f2f-e55ded8bb6d9', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('e2b6e867-55ea-5352-9f2f-e55ded8bb6d9', '4805aa68-f435-5d58-a2b1-2fd3ce210406', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e2b6e867-55ea-5352-9f2f-e55ded8bb6d9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9e63d0bd-39b0-5ee9-89f0-0fd0b04063bf', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-2', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', '274b31f1-c63b-5e9d-9a26-fb9d4998db85', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '274b31f1-c63b-5e9d-9a26-fb9d4998db85';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9e63d0bd-39b0-5ee9-89f0-0fd0b04063bf', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('9e63d0bd-39b0-5ee9-89f0-0fd0b04063bf', '274b31f1-c63b-5e9d-9a26-fb9d4998db85', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9e63d0bd-39b0-5ee9-89f0-0fd0b04063bf';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7586ae08-2aee-53b2-b6d0-fb2df4e413f2', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-3', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', '22443a41-d4f4-5169-a11c-c0587c43729a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '22443a41-d4f4-5169-a11c-c0587c43729a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7586ae08-2aee-53b2-b6d0-fb2df4e413f2', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('7586ae08-2aee-53b2-b6d0-fb2df4e413f2', '22443a41-d4f4-5169-a11c-c0587c43729a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7586ae08-2aee-53b2-b6d0-fb2df4e413f2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8e04849a-08a2-5f78-ba6f-7b7ebe4f51fc', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-4', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', '6fcac232-289b-5086-8c27-52f114ffc0b1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6fcac232-289b-5086-8c27-52f114ffc0b1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8e04849a-08a2-5f78-ba6f-7b7ebe4f51fc', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('8e04849a-08a2-5f78-ba6f-7b7ebe4f51fc', '6fcac232-289b-5086-8c27-52f114ffc0b1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8e04849a-08a2-5f78-ba6f-7b7ebe4f51fc';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b2063812-64fd-581d-9a65-24e26b5a4638', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-5', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', '640d80ec-fd4d-5e51-bd30-7fe36a84fc7d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '640d80ec-fd4d-5e51-bd30-7fe36a84fc7d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b2063812-64fd-581d-9a65-24e26b5a4638', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('b2063812-64fd-581d-9a65-24e26b5a4638', '640d80ec-fd4d-5e51-bd30-7fe36a84fc7d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b2063812-64fd-581d-9a65-24e26b5a4638';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('95ee11d2-3370-557f-a006-54fca0341066', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-6', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', '1381eac2-3670-59aa-95a7-dc7beaba1db1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1381eac2-3670-59aa-95a7-dc7beaba1db1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('95ee11d2-3370-557f-a006-54fca0341066', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('95ee11d2-3370-557f-a006-54fca0341066', '1381eac2-3670-59aa-95a7-dc7beaba1db1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '95ee11d2-3370-557f-a006-54fca0341066';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('2926cea8-159e-5140-ac93-7c8c6898723a', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-7', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', '39d70e22-cc76-5bfa-9827-930453457cc5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '39d70e22-cc76-5bfa-9827-930453457cc5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('2926cea8-159e-5140-ac93-7c8c6898723a', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('2926cea8-159e-5140-ac93-7c8c6898723a', '39d70e22-cc76-5bfa-9827-930453457cc5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '2926cea8-159e-5140-ac93-7c8c6898723a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e5a4f24b-322f-5bfb-a0f5-7e01d16234d1', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-8', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', 'f383f898-f55e-5f66-8c3c-8b485eb20db3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f383f898-f55e-5f66-8c3c-8b485eb20db3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e5a4f24b-322f-5bfb-a0f5-7e01d16234d1', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('e5a4f24b-322f-5bfb-a0f5-7e01d16234d1', 'f383f898-f55e-5f66-8c3c-8b485eb20db3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e5a4f24b-322f-5bfb-a0f5-7e01d16234d1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('10414849-cec4-5dff-a9dd-6db311198f74', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-9', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', '83753e3d-997b-518a-9427-1dec10c09942', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '83753e3d-997b-518a-9427-1dec10c09942';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('10414849-cec4-5dff-a9dd-6db311198f74', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('10414849-cec4-5dff-a9dd-6db311198f74', '83753e3d-997b-518a-9427-1dec10c09942', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '10414849-cec4-5dff-a9dd-6db311198f74';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e37119be-8979-5cb3-a98e-8b555c78eab1', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-10', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', '03bc04b9-2816-5633-adf4-ba0ef1b55cd8', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '03bc04b9-2816-5633-adf4-ba0ef1b55cd8';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e37119be-8979-5cb3-a98e-8b555c78eab1', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('e37119be-8979-5cb3-a98e-8b555c78eab1', '03bc04b9-2816-5633-adf4-ba0ef1b55cd8', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e37119be-8979-5cb3-a98e-8b555c78eab1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4dec03d6-41d4-5884-bb23-808a825dafc6', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-11', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', '50392d10-7c56-5508-ab49-ceeb8739378a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '50392d10-7c56-5508-ab49-ceeb8739378a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4dec03d6-41d4-5884-bb23-808a825dafc6', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('4dec03d6-41d4-5884-bb23-808a825dafc6', '50392d10-7c56-5508-ab49-ceeb8739378a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4dec03d6-41d4-5884-bb23-808a825dafc6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d68f32e6-173a-58be-86ea-76081bd89af5', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-12', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', '36b51e36-9b9c-5ede-9c69-9e5714696159', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '36b51e36-9b9c-5ede-9c69-9e5714696159';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d68f32e6-173a-58be-86ea-76081bd89af5', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('d68f32e6-173a-58be-86ea-76081bd89af5', '36b51e36-9b9c-5ede-9c69-9e5714696159', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd68f32e6-173a-58be-86ea-76081bd89af5';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8c327783-a2c0-5b38-90a2-8e9de970728f', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-13', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', 'ae37f001-b707-5940-ba5d-061d55bd35d2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ae37f001-b707-5940-ba5d-061d55bd35d2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8c327783-a2c0-5b38-90a2-8e9de970728f', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('8c327783-a2c0-5b38-90a2-8e9de970728f', 'ae37f001-b707-5940-ba5d-061d55bd35d2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8c327783-a2c0-5b38-90a2-8e9de970728f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6cdcb499-56c0-5892-bd5d-9d50d4e7b3cb', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-14', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', '3a364332-eff1-5390-8ad7-d6e563477aaf', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3a364332-eff1-5390-8ad7-d6e563477aaf';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6cdcb499-56c0-5892-bd5d-9d50d4e7b3cb', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('6cdcb499-56c0-5892-bd5d-9d50d4e7b3cb', '3a364332-eff1-5390-8ad7-d6e563477aaf', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6cdcb499-56c0-5892-bd5d-9d50d4e7b3cb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5e9ce86c-c399-5a01-8ac3-d395b725b26c', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-15', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', '69ed5dd1-6b03-5711-8392-4ceca8e01e8e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '69ed5dd1-6b03-5711-8392-4ceca8e01e8e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5e9ce86c-c399-5a01-8ac3-d395b725b26c', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('5e9ce86c-c399-5a01-8ac3-d395b725b26c', '69ed5dd1-6b03-5711-8392-4ceca8e01e8e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5e9ce86c-c399-5a01-8ac3-d395b725b26c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('887a971d-8f82-5633-b394-16c6678a165e', 'benchmark-funding-23fd460b-2567-4b9b-a5a7-77942676c7e5-16', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', 'edc87966-9ae2-553e-88f3-f1c4432b1807', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '4721cd96-ccd9-55af-b9c9-c81703e31b8d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'edc87966-9ae2-553e-88f3-f1c4432b1807';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('887a971d-8f82-5633-b394-16c6678a165e', '4721cd96-ccd9-55af-b9c9-c81703e31b8d', -1000000000), ('887a971d-8f82-5633-b394-16c6678a165e', 'edc87966-9ae2-553e-88f3-f1c4432b1807', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '887a971d-8f82-5633-b394-16c6678a165e';
COMMIT;
