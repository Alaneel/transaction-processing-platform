-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('0f7b071c-1f62-5741-ae7c-26be4ad37a9b', 'USER', 'ACTIVE', 'FIC'),
('1cc8e712-53f5-593e-aa22-6a3b85bf1538', 'USER', 'ACTIVE', 'FIC'),
('348d5402-3d4a-5da7-9e81-9a1162a84ff3', 'USER', 'ACTIVE', 'FIC'),
('3665cf13-601e-56b3-b794-310449a64003', 'USER', 'ACTIVE', 'FIC'),
('4a23b01c-d81c-5c66-b118-420be0eb3c36', 'USER', 'ACTIVE', 'FIC'),
('4bf918ab-971a-50d9-8ed3-27d605909211', 'USER', 'ACTIVE', 'FIC'),
('594b909e-5b4b-5f68-9b15-1b554dd715be', 'USER', 'ACTIVE', 'FIC'),
('61378bab-c7d0-548a-b331-9099546ea074', 'ISSUANCE', 'ACTIVE', 'FIC'),
('68457373-2ae4-56ac-9206-67232159f1d1', 'USER', 'ACTIVE', 'FIC'),
('71d973ca-7699-580a-ad54-36277d5d2d79', 'USER', 'ACTIVE', 'FIC'),
('77363822-abd9-571d-b48b-30b7dc5ecc73', 'USER', 'ACTIVE', 'FIC'),
('7de6f4cf-6690-5ba4-9816-78b32bcae21f', 'USER', 'ACTIVE', 'FIC'),
('7ded5543-74e8-515e-b3d2-96c16c1f3c1b', 'USER', 'ACTIVE', 'FIC'),
('8c1160ac-2cb6-5a98-86e3-6550e47ac78a', 'USER', 'ACTIVE', 'FIC'),
('93b9dfec-8dde-5916-94f7-287139c90085', 'USER', 'ACTIVE', 'FIC'),
('b088827d-1f43-581b-8745-d9a14e95bdbb', 'USER', 'ACTIVE', 'FIC'),
('b2d64e61-a895-5496-92f5-fa1f9c497d5d', 'USER', 'ACTIVE', 'FIC'),
('b7612dc1-a43c-50c1-8029-1c05629ee7c9', 'USER', 'ACTIVE', 'FIC'),
('c540debf-69ef-5127-a70b-5b3294d16afe', 'USER', 'ACTIVE', 'FIC'),
('cbc68ebf-3f1f-5b9e-880a-70bd490c42bd', 'USER', 'ACTIVE', 'FIC'),
('e0877c98-7a37-5bcd-90d2-7dccd8de0b2f', 'USER', 'ACTIVE', 'FIC'),
('e648d127-1a93-5b95-a949-490e15188d33', 'USER', 'ACTIVE', 'FIC'),
('f28cfe92-f611-5049-8f2b-953db9e42219', 'USER', 'ACTIVE', 'FIC'),
('f4a4a700-7f7d-5a0a-9263-d9e1da4584bd', 'USER', 'ACTIVE', 'FIC'),
('f7527d8a-1030-5e2c-83cd-f7d747ef784b', 'USER', 'ACTIVE', 'FIC'),
('fa87994a-8ffa-5cb5-bef9-a02615b0c446', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('0f7b071c-1f62-5741-ae7c-26be4ad37a9b', 0),
('1cc8e712-53f5-593e-aa22-6a3b85bf1538', 0),
('348d5402-3d4a-5da7-9e81-9a1162a84ff3', 0),
('3665cf13-601e-56b3-b794-310449a64003', 0),
('4a23b01c-d81c-5c66-b118-420be0eb3c36', 0),
('4bf918ab-971a-50d9-8ed3-27d605909211', 0),
('594b909e-5b4b-5f68-9b15-1b554dd715be', 0),
('61378bab-c7d0-548a-b331-9099546ea074', 0),
('68457373-2ae4-56ac-9206-67232159f1d1', 0),
('71d973ca-7699-580a-ad54-36277d5d2d79', 0),
('77363822-abd9-571d-b48b-30b7dc5ecc73', 0),
('7de6f4cf-6690-5ba4-9816-78b32bcae21f', 0),
('7ded5543-74e8-515e-b3d2-96c16c1f3c1b', 0),
('8c1160ac-2cb6-5a98-86e3-6550e47ac78a', 0),
('93b9dfec-8dde-5916-94f7-287139c90085', 0),
('b088827d-1f43-581b-8745-d9a14e95bdbb', 0),
('b2d64e61-a895-5496-92f5-fa1f9c497d5d', 0),
('b7612dc1-a43c-50c1-8029-1c05629ee7c9', 0),
('c540debf-69ef-5127-a70b-5b3294d16afe', 0),
('cbc68ebf-3f1f-5b9e-880a-70bd490c42bd', 0),
('e0877c98-7a37-5bcd-90d2-7dccd8de0b2f', 0),
('e648d127-1a93-5b95-a949-490e15188d33', 0),
('f28cfe92-f611-5049-8f2b-953db9e42219', 0),
('f4a4a700-7f7d-5a0a-9263-d9e1da4584bd', 0),
('f7527d8a-1030-5e2c-83cd-f7d747ef784b', 0),
('fa87994a-8ffa-5cb5-bef9-a02615b0c446', 0);
SELECT account_id FROM balances WHERE account_id IN ('0f7b071c-1f62-5741-ae7c-26be4ad37a9b','1cc8e712-53f5-593e-aa22-6a3b85bf1538','348d5402-3d4a-5da7-9e81-9a1162a84ff3','3665cf13-601e-56b3-b794-310449a64003','4a23b01c-d81c-5c66-b118-420be0eb3c36','4bf918ab-971a-50d9-8ed3-27d605909211','594b909e-5b4b-5f68-9b15-1b554dd715be','61378bab-c7d0-548a-b331-9099546ea074','68457373-2ae4-56ac-9206-67232159f1d1','71d973ca-7699-580a-ad54-36277d5d2d79','77363822-abd9-571d-b48b-30b7dc5ecc73','7de6f4cf-6690-5ba4-9816-78b32bcae21f','7ded5543-74e8-515e-b3d2-96c16c1f3c1b','8c1160ac-2cb6-5a98-86e3-6550e47ac78a','93b9dfec-8dde-5916-94f7-287139c90085','b088827d-1f43-581b-8745-d9a14e95bdbb','b2d64e61-a895-5496-92f5-fa1f9c497d5d','b7612dc1-a43c-50c1-8029-1c05629ee7c9','c540debf-69ef-5127-a70b-5b3294d16afe','cbc68ebf-3f1f-5b9e-880a-70bd490c42bd','e0877c98-7a37-5bcd-90d2-7dccd8de0b2f','e648d127-1a93-5b95-a949-490e15188d33','f28cfe92-f611-5049-8f2b-953db9e42219','f4a4a700-7f7d-5a0a-9263-d9e1da4584bd','f7527d8a-1030-5e2c-83cd-f7d747ef784b','fa87994a-8ffa-5cb5-bef9-a02615b0c446') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7d55fec4-3479-56c1-9703-28ef30fe79c1', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-0', '61378bab-c7d0-548a-b331-9099546ea074', '4a23b01c-d81c-5c66-b118-420be0eb3c36', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4a23b01c-d81c-5c66-b118-420be0eb3c36';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7d55fec4-3479-56c1-9703-28ef30fe79c1', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('7d55fec4-3479-56c1-9703-28ef30fe79c1', '4a23b01c-d81c-5c66-b118-420be0eb3c36', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7d55fec4-3479-56c1-9703-28ef30fe79c1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5e3a089b-c283-5e0c-af11-2d8b4e908a5c', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-1', '61378bab-c7d0-548a-b331-9099546ea074', 'fa87994a-8ffa-5cb5-bef9-a02615b0c446', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fa87994a-8ffa-5cb5-bef9-a02615b0c446';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5e3a089b-c283-5e0c-af11-2d8b4e908a5c', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('5e3a089b-c283-5e0c-af11-2d8b4e908a5c', 'fa87994a-8ffa-5cb5-bef9-a02615b0c446', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5e3a089b-c283-5e0c-af11-2d8b4e908a5c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('dfaa2f91-165f-5366-8180-78e970b97234', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-2', '61378bab-c7d0-548a-b331-9099546ea074', 'b088827d-1f43-581b-8745-d9a14e95bdbb', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b088827d-1f43-581b-8745-d9a14e95bdbb';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('dfaa2f91-165f-5366-8180-78e970b97234', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('dfaa2f91-165f-5366-8180-78e970b97234', 'b088827d-1f43-581b-8745-d9a14e95bdbb', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'dfaa2f91-165f-5366-8180-78e970b97234';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a646e3f9-2ba3-5d39-9c4a-2d23afdd7048', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-3', '61378bab-c7d0-548a-b331-9099546ea074', '0f7b071c-1f62-5741-ae7c-26be4ad37a9b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0f7b071c-1f62-5741-ae7c-26be4ad37a9b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a646e3f9-2ba3-5d39-9c4a-2d23afdd7048', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('a646e3f9-2ba3-5d39-9c4a-2d23afdd7048', '0f7b071c-1f62-5741-ae7c-26be4ad37a9b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a646e3f9-2ba3-5d39-9c4a-2d23afdd7048';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('359373b9-36ec-5ea6-8b1f-0bf15fd5d72b', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-4', '61378bab-c7d0-548a-b331-9099546ea074', 'e648d127-1a93-5b95-a949-490e15188d33', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e648d127-1a93-5b95-a949-490e15188d33';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('359373b9-36ec-5ea6-8b1f-0bf15fd5d72b', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('359373b9-36ec-5ea6-8b1f-0bf15fd5d72b', 'e648d127-1a93-5b95-a949-490e15188d33', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '359373b9-36ec-5ea6-8b1f-0bf15fd5d72b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d5fc1cdf-1718-5d91-a07e-f72960866d0e', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-5', '61378bab-c7d0-548a-b331-9099546ea074', 'b7612dc1-a43c-50c1-8029-1c05629ee7c9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b7612dc1-a43c-50c1-8029-1c05629ee7c9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d5fc1cdf-1718-5d91-a07e-f72960866d0e', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('d5fc1cdf-1718-5d91-a07e-f72960866d0e', 'b7612dc1-a43c-50c1-8029-1c05629ee7c9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd5fc1cdf-1718-5d91-a07e-f72960866d0e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('24b64939-835f-5841-88eb-b6993fc9e938', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-6', '61378bab-c7d0-548a-b331-9099546ea074', 'f28cfe92-f611-5049-8f2b-953db9e42219', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f28cfe92-f611-5049-8f2b-953db9e42219';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('24b64939-835f-5841-88eb-b6993fc9e938', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('24b64939-835f-5841-88eb-b6993fc9e938', 'f28cfe92-f611-5049-8f2b-953db9e42219', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '24b64939-835f-5841-88eb-b6993fc9e938';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('04465008-e343-5140-99d2-f156a53bd180', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-7', '61378bab-c7d0-548a-b331-9099546ea074', 'b2d64e61-a895-5496-92f5-fa1f9c497d5d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b2d64e61-a895-5496-92f5-fa1f9c497d5d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('04465008-e343-5140-99d2-f156a53bd180', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('04465008-e343-5140-99d2-f156a53bd180', 'b2d64e61-a895-5496-92f5-fa1f9c497d5d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '04465008-e343-5140-99d2-f156a53bd180';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('594b681a-247a-502c-95f0-24ee8fb582f9', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-8', '61378bab-c7d0-548a-b331-9099546ea074', '7de6f4cf-6690-5ba4-9816-78b32bcae21f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7de6f4cf-6690-5ba4-9816-78b32bcae21f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('594b681a-247a-502c-95f0-24ee8fb582f9', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('594b681a-247a-502c-95f0-24ee8fb582f9', '7de6f4cf-6690-5ba4-9816-78b32bcae21f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '594b681a-247a-502c-95f0-24ee8fb582f9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1edd9e8e-25fd-53f6-b951-3a0b8a758b47', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-9', '61378bab-c7d0-548a-b331-9099546ea074', '71d973ca-7699-580a-ad54-36277d5d2d79', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '71d973ca-7699-580a-ad54-36277d5d2d79';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1edd9e8e-25fd-53f6-b951-3a0b8a758b47', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('1edd9e8e-25fd-53f6-b951-3a0b8a758b47', '71d973ca-7699-580a-ad54-36277d5d2d79', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1edd9e8e-25fd-53f6-b951-3a0b8a758b47';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('27934fe0-f4ce-5d80-ac7e-2c27525b2539', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-10', '61378bab-c7d0-548a-b331-9099546ea074', '348d5402-3d4a-5da7-9e81-9a1162a84ff3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '348d5402-3d4a-5da7-9e81-9a1162a84ff3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('27934fe0-f4ce-5d80-ac7e-2c27525b2539', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('27934fe0-f4ce-5d80-ac7e-2c27525b2539', '348d5402-3d4a-5da7-9e81-9a1162a84ff3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '27934fe0-f4ce-5d80-ac7e-2c27525b2539';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('bab2712d-89bf-5e6f-924d-5f1e3cd60787', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-11', '61378bab-c7d0-548a-b331-9099546ea074', '77363822-abd9-571d-b48b-30b7dc5ecc73', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '77363822-abd9-571d-b48b-30b7dc5ecc73';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('bab2712d-89bf-5e6f-924d-5f1e3cd60787', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('bab2712d-89bf-5e6f-924d-5f1e3cd60787', '77363822-abd9-571d-b48b-30b7dc5ecc73', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'bab2712d-89bf-5e6f-924d-5f1e3cd60787';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f81e8d61-46d3-58f8-b13c-937f4b3af982', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-12', '61378bab-c7d0-548a-b331-9099546ea074', '594b909e-5b4b-5f68-9b15-1b554dd715be', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '594b909e-5b4b-5f68-9b15-1b554dd715be';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f81e8d61-46d3-58f8-b13c-937f4b3af982', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('f81e8d61-46d3-58f8-b13c-937f4b3af982', '594b909e-5b4b-5f68-9b15-1b554dd715be', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f81e8d61-46d3-58f8-b13c-937f4b3af982';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('709997c1-e365-55b5-b8b2-f965c7e2328f', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-13', '61378bab-c7d0-548a-b331-9099546ea074', 'f7527d8a-1030-5e2c-83cd-f7d747ef784b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f7527d8a-1030-5e2c-83cd-f7d747ef784b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('709997c1-e365-55b5-b8b2-f965c7e2328f', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('709997c1-e365-55b5-b8b2-f965c7e2328f', 'f7527d8a-1030-5e2c-83cd-f7d747ef784b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '709997c1-e365-55b5-b8b2-f965c7e2328f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ab0d827b-4eeb-5c2b-ad2c-3c90dad45c9c', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-14', '61378bab-c7d0-548a-b331-9099546ea074', 'cbc68ebf-3f1f-5b9e-880a-70bd490c42bd', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'cbc68ebf-3f1f-5b9e-880a-70bd490c42bd';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ab0d827b-4eeb-5c2b-ad2c-3c90dad45c9c', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('ab0d827b-4eeb-5c2b-ad2c-3c90dad45c9c', 'cbc68ebf-3f1f-5b9e-880a-70bd490c42bd', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ab0d827b-4eeb-5c2b-ad2c-3c90dad45c9c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8581a7a1-0551-56f6-96b2-1fc18449f566', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-15', '61378bab-c7d0-548a-b331-9099546ea074', '3665cf13-601e-56b3-b794-310449a64003', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3665cf13-601e-56b3-b794-310449a64003';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8581a7a1-0551-56f6-96b2-1fc18449f566', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('8581a7a1-0551-56f6-96b2-1fc18449f566', '3665cf13-601e-56b3-b794-310449a64003', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8581a7a1-0551-56f6-96b2-1fc18449f566';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('aa0e03c8-9607-5cd3-a533-217a249d806b', 'benchmark-funding-6ca8608a-6095-47cd-85a2-7f3553270339-16', '61378bab-c7d0-548a-b331-9099546ea074', '1cc8e712-53f5-593e-aa22-6a3b85bf1538', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '61378bab-c7d0-548a-b331-9099546ea074';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1cc8e712-53f5-593e-aa22-6a3b85bf1538';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('aa0e03c8-9607-5cd3-a533-217a249d806b', '61378bab-c7d0-548a-b331-9099546ea074', -1000000000), ('aa0e03c8-9607-5cd3-a533-217a249d806b', '1cc8e712-53f5-593e-aa22-6a3b85bf1538', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'aa0e03c8-9607-5cd3-a533-217a249d806b';
COMMIT;
