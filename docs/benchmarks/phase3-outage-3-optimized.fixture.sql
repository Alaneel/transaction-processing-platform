-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('12fcedd1-1d2d-53e9-b9ec-b7b32cdaa46d', 'USER', 'ACTIVE', 'FIC'),
('23aef856-5941-518e-91fe-c852094f6c1f', 'USER', 'ACTIVE', 'FIC'),
('28e8d74d-6396-5f97-a1f2-a70aef26ed96', 'USER', 'ACTIVE', 'FIC'),
('37af31f2-b5d8-582f-80cd-c9bee7f0f052', 'USER', 'ACTIVE', 'FIC'),
('3fff3844-fdd1-53db-b8f3-680183255fbc', 'USER', 'ACTIVE', 'FIC'),
('452c9d79-8592-5b4e-9c12-7c07ba9dbdb6', 'USER', 'ACTIVE', 'FIC'),
('4c7dff57-3680-5095-9364-4706a2f4eeb5', 'USER', 'ACTIVE', 'FIC'),
('4d44f37d-f810-54bb-aa7d-5cc8d48202f0', 'USER', 'ACTIVE', 'FIC'),
('536bb777-19cb-5c7f-b0be-76e2f5275b61', 'USER', 'ACTIVE', 'FIC'),
('604da22e-ec54-515e-be1e-d4284d4e9dd0', 'USER', 'ACTIVE', 'FIC'),
('61e1721e-31be-56b2-b769-35fceaf245f5', 'USER', 'ACTIVE', 'FIC'),
('69e705b0-6ede-56aa-aa3f-daa0ccc828f3', 'USER', 'ACTIVE', 'FIC'),
('700f28cc-ae06-52bf-b761-32820c6b651d', 'USER', 'ACTIVE', 'FIC'),
('726abb7c-5bc4-51be-a998-5e7c58c32428', 'USER', 'ACTIVE', 'FIC'),
('750cc20c-8e24-5577-9f3f-d6e06f57466b', 'USER', 'ACTIVE', 'FIC'),
('7b60879a-4fd9-51bf-9704-362e9a3992e1', 'USER', 'ACTIVE', 'FIC'),
('7f176683-3fc9-5477-b995-1e5dd249736a', 'USER', 'ACTIVE', 'FIC'),
('896142d5-6227-5703-b0da-262c87f7525a', 'USER', 'ACTIVE', 'FIC'),
('89b628e6-50dd-561d-84ec-ae6e31a85647', 'USER', 'ACTIVE', 'FIC'),
('9d3aa681-821b-5fac-8713-57532f54d1fc', 'USER', 'ACTIVE', 'FIC'),
('ae7d554e-35f0-53de-81ed-95d9a1f056a3', 'ISSUANCE', 'ACTIVE', 'FIC'),
('b656aa2d-cf18-5ead-ba04-129faba17c06', 'USER', 'ACTIVE', 'FIC'),
('c9c617bc-f032-541a-90e4-da72bd341617', 'USER', 'ACTIVE', 'FIC'),
('e1291052-3e1e-55c3-92cd-7e729ea5151a', 'USER', 'ACTIVE', 'FIC'),
('f2c2deba-e670-5242-b4f9-8e2046119520', 'USER', 'ACTIVE', 'FIC'),
('f84ab732-f803-5fb9-9ad0-55e1ff7ce523', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('12fcedd1-1d2d-53e9-b9ec-b7b32cdaa46d', 0),
('23aef856-5941-518e-91fe-c852094f6c1f', 0),
('28e8d74d-6396-5f97-a1f2-a70aef26ed96', 0),
('37af31f2-b5d8-582f-80cd-c9bee7f0f052', 0),
('3fff3844-fdd1-53db-b8f3-680183255fbc', 0),
('452c9d79-8592-5b4e-9c12-7c07ba9dbdb6', 0),
('4c7dff57-3680-5095-9364-4706a2f4eeb5', 0),
('4d44f37d-f810-54bb-aa7d-5cc8d48202f0', 0),
('536bb777-19cb-5c7f-b0be-76e2f5275b61', 0),
('604da22e-ec54-515e-be1e-d4284d4e9dd0', 0),
('61e1721e-31be-56b2-b769-35fceaf245f5', 0),
('69e705b0-6ede-56aa-aa3f-daa0ccc828f3', 0),
('700f28cc-ae06-52bf-b761-32820c6b651d', 0),
('726abb7c-5bc4-51be-a998-5e7c58c32428', 0),
('750cc20c-8e24-5577-9f3f-d6e06f57466b', 0),
('7b60879a-4fd9-51bf-9704-362e9a3992e1', 0),
('7f176683-3fc9-5477-b995-1e5dd249736a', 0),
('896142d5-6227-5703-b0da-262c87f7525a', 0),
('89b628e6-50dd-561d-84ec-ae6e31a85647', 0),
('9d3aa681-821b-5fac-8713-57532f54d1fc', 0),
('ae7d554e-35f0-53de-81ed-95d9a1f056a3', 0),
('b656aa2d-cf18-5ead-ba04-129faba17c06', 0),
('c9c617bc-f032-541a-90e4-da72bd341617', 0),
('e1291052-3e1e-55c3-92cd-7e729ea5151a', 0),
('f2c2deba-e670-5242-b4f9-8e2046119520', 0),
('f84ab732-f803-5fb9-9ad0-55e1ff7ce523', 0);
SELECT account_id FROM balances WHERE account_id IN ('12fcedd1-1d2d-53e9-b9ec-b7b32cdaa46d','23aef856-5941-518e-91fe-c852094f6c1f','28e8d74d-6396-5f97-a1f2-a70aef26ed96','37af31f2-b5d8-582f-80cd-c9bee7f0f052','3fff3844-fdd1-53db-b8f3-680183255fbc','452c9d79-8592-5b4e-9c12-7c07ba9dbdb6','4c7dff57-3680-5095-9364-4706a2f4eeb5','4d44f37d-f810-54bb-aa7d-5cc8d48202f0','536bb777-19cb-5c7f-b0be-76e2f5275b61','604da22e-ec54-515e-be1e-d4284d4e9dd0','61e1721e-31be-56b2-b769-35fceaf245f5','69e705b0-6ede-56aa-aa3f-daa0ccc828f3','700f28cc-ae06-52bf-b761-32820c6b651d','726abb7c-5bc4-51be-a998-5e7c58c32428','750cc20c-8e24-5577-9f3f-d6e06f57466b','7b60879a-4fd9-51bf-9704-362e9a3992e1','7f176683-3fc9-5477-b995-1e5dd249736a','896142d5-6227-5703-b0da-262c87f7525a','89b628e6-50dd-561d-84ec-ae6e31a85647','9d3aa681-821b-5fac-8713-57532f54d1fc','ae7d554e-35f0-53de-81ed-95d9a1f056a3','b656aa2d-cf18-5ead-ba04-129faba17c06','c9c617bc-f032-541a-90e4-da72bd341617','e1291052-3e1e-55c3-92cd-7e729ea5151a','f2c2deba-e670-5242-b4f9-8e2046119520','f84ab732-f803-5fb9-9ad0-55e1ff7ce523') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('efa500b9-e684-539c-a440-a6214d9855da', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-0', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', '28e8d74d-6396-5f97-a1f2-a70aef26ed96', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '28e8d74d-6396-5f97-a1f2-a70aef26ed96';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('efa500b9-e684-539c-a440-a6214d9855da', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('efa500b9-e684-539c-a440-a6214d9855da', '28e8d74d-6396-5f97-a1f2-a70aef26ed96', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'efa500b9-e684-539c-a440-a6214d9855da';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5970c6a0-b860-5665-b58c-9104be88dea1', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-1', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', 'f2c2deba-e670-5242-b4f9-8e2046119520', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f2c2deba-e670-5242-b4f9-8e2046119520';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5970c6a0-b860-5665-b58c-9104be88dea1', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('5970c6a0-b860-5665-b58c-9104be88dea1', 'f2c2deba-e670-5242-b4f9-8e2046119520', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5970c6a0-b860-5665-b58c-9104be88dea1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6e5e8d9e-78ba-5601-9fa3-ba5ab4474668', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-2', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', '726abb7c-5bc4-51be-a998-5e7c58c32428', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '726abb7c-5bc4-51be-a998-5e7c58c32428';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6e5e8d9e-78ba-5601-9fa3-ba5ab4474668', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('6e5e8d9e-78ba-5601-9fa3-ba5ab4474668', '726abb7c-5bc4-51be-a998-5e7c58c32428', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6e5e8d9e-78ba-5601-9fa3-ba5ab4474668';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('eef42122-52a1-59f9-a96b-938a43cbbb61', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-3', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', '3fff3844-fdd1-53db-b8f3-680183255fbc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3fff3844-fdd1-53db-b8f3-680183255fbc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('eef42122-52a1-59f9-a96b-938a43cbbb61', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('eef42122-52a1-59f9-a96b-938a43cbbb61', '3fff3844-fdd1-53db-b8f3-680183255fbc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'eef42122-52a1-59f9-a96b-938a43cbbb61';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('90fe4145-4351-5744-84e7-dc7482d2cef4', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-4', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', 'e1291052-3e1e-55c3-92cd-7e729ea5151a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e1291052-3e1e-55c3-92cd-7e729ea5151a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('90fe4145-4351-5744-84e7-dc7482d2cef4', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('90fe4145-4351-5744-84e7-dc7482d2cef4', 'e1291052-3e1e-55c3-92cd-7e729ea5151a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '90fe4145-4351-5744-84e7-dc7482d2cef4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f59ca7a6-db01-5c26-a329-af8ccda30d42', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-5', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', '536bb777-19cb-5c7f-b0be-76e2f5275b61', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '536bb777-19cb-5c7f-b0be-76e2f5275b61';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f59ca7a6-db01-5c26-a329-af8ccda30d42', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('f59ca7a6-db01-5c26-a329-af8ccda30d42', '536bb777-19cb-5c7f-b0be-76e2f5275b61', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f59ca7a6-db01-5c26-a329-af8ccda30d42';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('66569ac2-1540-5728-8748-d8dc634c688b', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-6', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', '69e705b0-6ede-56aa-aa3f-daa0ccc828f3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '69e705b0-6ede-56aa-aa3f-daa0ccc828f3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('66569ac2-1540-5728-8748-d8dc634c688b', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('66569ac2-1540-5728-8748-d8dc634c688b', '69e705b0-6ede-56aa-aa3f-daa0ccc828f3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '66569ac2-1540-5728-8748-d8dc634c688b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('afeba157-ef1d-5d11-9a89-6007706346a1', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-7', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', '89b628e6-50dd-561d-84ec-ae6e31a85647', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '89b628e6-50dd-561d-84ec-ae6e31a85647';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('afeba157-ef1d-5d11-9a89-6007706346a1', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('afeba157-ef1d-5d11-9a89-6007706346a1', '89b628e6-50dd-561d-84ec-ae6e31a85647', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'afeba157-ef1d-5d11-9a89-6007706346a1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('17b4b017-fc62-5bf7-93d7-7429bc8a37b7', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-8', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', '12fcedd1-1d2d-53e9-b9ec-b7b32cdaa46d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '12fcedd1-1d2d-53e9-b9ec-b7b32cdaa46d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('17b4b017-fc62-5bf7-93d7-7429bc8a37b7', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('17b4b017-fc62-5bf7-93d7-7429bc8a37b7', '12fcedd1-1d2d-53e9-b9ec-b7b32cdaa46d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '17b4b017-fc62-5bf7-93d7-7429bc8a37b7';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b4f5e7d6-bf14-56ec-acb9-5d1086c209fa', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-9', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', '604da22e-ec54-515e-be1e-d4284d4e9dd0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '604da22e-ec54-515e-be1e-d4284d4e9dd0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b4f5e7d6-bf14-56ec-acb9-5d1086c209fa', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('b4f5e7d6-bf14-56ec-acb9-5d1086c209fa', '604da22e-ec54-515e-be1e-d4284d4e9dd0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b4f5e7d6-bf14-56ec-acb9-5d1086c209fa';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d41e94f9-a92f-5ca1-9adc-c7d4eb8821f9', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-10', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', '700f28cc-ae06-52bf-b761-32820c6b651d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '700f28cc-ae06-52bf-b761-32820c6b651d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d41e94f9-a92f-5ca1-9adc-c7d4eb8821f9', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('d41e94f9-a92f-5ca1-9adc-c7d4eb8821f9', '700f28cc-ae06-52bf-b761-32820c6b651d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd41e94f9-a92f-5ca1-9adc-c7d4eb8821f9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('30e3837d-4a1a-5187-8676-7c78834a6c07', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-11', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', '4c7dff57-3680-5095-9364-4706a2f4eeb5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4c7dff57-3680-5095-9364-4706a2f4eeb5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('30e3837d-4a1a-5187-8676-7c78834a6c07', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('30e3837d-4a1a-5187-8676-7c78834a6c07', '4c7dff57-3680-5095-9364-4706a2f4eeb5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '30e3837d-4a1a-5187-8676-7c78834a6c07';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('cb746f18-fbdb-5efa-96a6-8458f9381003', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-12', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', '4d44f37d-f810-54bb-aa7d-5cc8d48202f0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4d44f37d-f810-54bb-aa7d-5cc8d48202f0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('cb746f18-fbdb-5efa-96a6-8458f9381003', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('cb746f18-fbdb-5efa-96a6-8458f9381003', '4d44f37d-f810-54bb-aa7d-5cc8d48202f0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'cb746f18-fbdb-5efa-96a6-8458f9381003';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ac071f0c-6eb7-5025-9677-41776c4e6c43', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-13', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', '9d3aa681-821b-5fac-8713-57532f54d1fc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9d3aa681-821b-5fac-8713-57532f54d1fc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ac071f0c-6eb7-5025-9677-41776c4e6c43', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('ac071f0c-6eb7-5025-9677-41776c4e6c43', '9d3aa681-821b-5fac-8713-57532f54d1fc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ac071f0c-6eb7-5025-9677-41776c4e6c43';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f1c7e85b-c967-5d36-bf51-49a6bc962555', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-14', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', '452c9d79-8592-5b4e-9c12-7c07ba9dbdb6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '452c9d79-8592-5b4e-9c12-7c07ba9dbdb6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f1c7e85b-c967-5d36-bf51-49a6bc962555', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('f1c7e85b-c967-5d36-bf51-49a6bc962555', '452c9d79-8592-5b4e-9c12-7c07ba9dbdb6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f1c7e85b-c967-5d36-bf51-49a6bc962555';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('23a09448-6fb7-5687-beb6-1fd67e24b4cf', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-15', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', '61e1721e-31be-56b2-b769-35fceaf245f5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '61e1721e-31be-56b2-b769-35fceaf245f5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('23a09448-6fb7-5687-beb6-1fd67e24b4cf', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('23a09448-6fb7-5687-beb6-1fd67e24b4cf', '61e1721e-31be-56b2-b769-35fceaf245f5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '23a09448-6fb7-5687-beb6-1fd67e24b4cf';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('bbcb8c51-d556-5a4a-9dd8-1761b62d57fb', 'benchmark-funding-08aef645-21e3-40fb-80c4-6161b84901fa-16', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', '7b60879a-4fd9-51bf-9704-362e9a3992e1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'ae7d554e-35f0-53de-81ed-95d9a1f056a3';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7b60879a-4fd9-51bf-9704-362e9a3992e1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('bbcb8c51-d556-5a4a-9dd8-1761b62d57fb', 'ae7d554e-35f0-53de-81ed-95d9a1f056a3', -1000000000), ('bbcb8c51-d556-5a4a-9dd8-1761b62d57fb', '7b60879a-4fd9-51bf-9704-362e9a3992e1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'bbcb8c51-d556-5a4a-9dd8-1761b62d57fb';
COMMIT;
