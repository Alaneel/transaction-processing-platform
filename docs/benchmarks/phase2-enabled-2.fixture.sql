-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('0ea61366-52f7-5dcc-ac83-9353e8e4ed9f', 'USER', 'ACTIVE', 'FIC'),
('1241a25b-c732-5496-b799-4b4f7ce5cdb3', 'USER', 'ACTIVE', 'FIC'),
('1a198d19-0428-5a11-aa87-c57130a962d3', 'USER', 'ACTIVE', 'FIC'),
('330190d2-4acd-5b53-943a-1c411c365877', 'USER', 'ACTIVE', 'FIC'),
('44c92041-c474-5e0d-8ca2-389fc314663d', 'USER', 'ACTIVE', 'FIC'),
('451228fb-d48e-50e9-b4e1-536d42580481', 'USER', 'ACTIVE', 'FIC'),
('45205b2e-b803-58c6-86f4-e06a2875d422', 'USER', 'ACTIVE', 'FIC'),
('4a5d7400-fc7f-590d-810e-1803c6d3287c', 'USER', 'ACTIVE', 'FIC'),
('4ac1518e-3847-51c5-abb3-23ff449bae84', 'USER', 'ACTIVE', 'FIC'),
('5e7d1048-fc9e-56d8-b04f-f0d5becb2bf7', 'USER', 'ACTIVE', 'FIC'),
('65d2cd74-1800-5978-bc88-852f07cc0acc', 'ISSUANCE', 'ACTIVE', 'FIC'),
('90444bd0-b092-566a-8d1d-51dcb75b2726', 'USER', 'ACTIVE', 'FIC'),
('9531e114-7942-5540-a86e-ea14be935212', 'USER', 'ACTIVE', 'FIC'),
('96fe041b-e7e1-50f1-b9ed-f2456222d870', 'USER', 'ACTIVE', 'FIC'),
('989fe6ec-f226-5267-ba0c-79e771e45ab4', 'USER', 'ACTIVE', 'FIC'),
('991a90e0-891e-5d82-b492-06120dbe6898', 'USER', 'ACTIVE', 'FIC'),
('9c079a16-7e64-542b-868c-854433b57ad7', 'USER', 'ACTIVE', 'FIC'),
('b9a336e7-38d4-5bb0-a1e4-66e64c33f5a7', 'USER', 'ACTIVE', 'FIC'),
('c595becc-653d-5e53-863d-9a99a9110501', 'USER', 'ACTIVE', 'FIC'),
('cd5d393b-b9f3-5838-b4fd-c2ecdf1fe31f', 'USER', 'ACTIVE', 'FIC'),
('d5be09df-58c8-5044-a810-fe032f0491ad', 'USER', 'ACTIVE', 'FIC'),
('d8877a01-3b02-5cf3-96f3-a032f336648b', 'USER', 'ACTIVE', 'FIC'),
('e385d4b8-4c02-5dc3-878b-8371f0af8c69', 'USER', 'ACTIVE', 'FIC'),
('e4c8c5c9-a627-55f2-a2df-bf57b3fbdf2d', 'USER', 'ACTIVE', 'FIC'),
('e6b4ff60-1b29-5686-868b-ed0e55db451f', 'USER', 'ACTIVE', 'FIC'),
('edd0ba87-6662-548e-9157-19a346bda73c', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('0ea61366-52f7-5dcc-ac83-9353e8e4ed9f', 0),
('1241a25b-c732-5496-b799-4b4f7ce5cdb3', 0),
('1a198d19-0428-5a11-aa87-c57130a962d3', 0),
('330190d2-4acd-5b53-943a-1c411c365877', 0),
('44c92041-c474-5e0d-8ca2-389fc314663d', 0),
('451228fb-d48e-50e9-b4e1-536d42580481', 0),
('45205b2e-b803-58c6-86f4-e06a2875d422', 0),
('4a5d7400-fc7f-590d-810e-1803c6d3287c', 0),
('4ac1518e-3847-51c5-abb3-23ff449bae84', 0),
('5e7d1048-fc9e-56d8-b04f-f0d5becb2bf7', 0),
('65d2cd74-1800-5978-bc88-852f07cc0acc', 0),
('90444bd0-b092-566a-8d1d-51dcb75b2726', 0),
('9531e114-7942-5540-a86e-ea14be935212', 0),
('96fe041b-e7e1-50f1-b9ed-f2456222d870', 0),
('989fe6ec-f226-5267-ba0c-79e771e45ab4', 0),
('991a90e0-891e-5d82-b492-06120dbe6898', 0),
('9c079a16-7e64-542b-868c-854433b57ad7', 0),
('b9a336e7-38d4-5bb0-a1e4-66e64c33f5a7', 0),
('c595becc-653d-5e53-863d-9a99a9110501', 0),
('cd5d393b-b9f3-5838-b4fd-c2ecdf1fe31f', 0),
('d5be09df-58c8-5044-a810-fe032f0491ad', 0),
('d8877a01-3b02-5cf3-96f3-a032f336648b', 0),
('e385d4b8-4c02-5dc3-878b-8371f0af8c69', 0),
('e4c8c5c9-a627-55f2-a2df-bf57b3fbdf2d', 0),
('e6b4ff60-1b29-5686-868b-ed0e55db451f', 0),
('edd0ba87-6662-548e-9157-19a346bda73c', 0);
SELECT account_id FROM balances WHERE account_id IN ('0ea61366-52f7-5dcc-ac83-9353e8e4ed9f','1241a25b-c732-5496-b799-4b4f7ce5cdb3','1a198d19-0428-5a11-aa87-c57130a962d3','330190d2-4acd-5b53-943a-1c411c365877','44c92041-c474-5e0d-8ca2-389fc314663d','451228fb-d48e-50e9-b4e1-536d42580481','45205b2e-b803-58c6-86f4-e06a2875d422','4a5d7400-fc7f-590d-810e-1803c6d3287c','4ac1518e-3847-51c5-abb3-23ff449bae84','5e7d1048-fc9e-56d8-b04f-f0d5becb2bf7','65d2cd74-1800-5978-bc88-852f07cc0acc','90444bd0-b092-566a-8d1d-51dcb75b2726','9531e114-7942-5540-a86e-ea14be935212','96fe041b-e7e1-50f1-b9ed-f2456222d870','989fe6ec-f226-5267-ba0c-79e771e45ab4','991a90e0-891e-5d82-b492-06120dbe6898','9c079a16-7e64-542b-868c-854433b57ad7','b9a336e7-38d4-5bb0-a1e4-66e64c33f5a7','c595becc-653d-5e53-863d-9a99a9110501','cd5d393b-b9f3-5838-b4fd-c2ecdf1fe31f','d5be09df-58c8-5044-a810-fe032f0491ad','d8877a01-3b02-5cf3-96f3-a032f336648b','e385d4b8-4c02-5dc3-878b-8371f0af8c69','e4c8c5c9-a627-55f2-a2df-bf57b3fbdf2d','e6b4ff60-1b29-5686-868b-ed0e55db451f','edd0ba87-6662-548e-9157-19a346bda73c') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('10edd9d3-db75-51dc-909a-fc359097f487', 'benchmark-funding-990f8880-f6cd-45c4-8fdd-75d3f3706fe0-0', '65d2cd74-1800-5978-bc88-852f07cc0acc', '90444bd0-b092-566a-8d1d-51dcb75b2726', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '65d2cd74-1800-5978-bc88-852f07cc0acc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '90444bd0-b092-566a-8d1d-51dcb75b2726';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('10edd9d3-db75-51dc-909a-fc359097f487', '65d2cd74-1800-5978-bc88-852f07cc0acc', -1000000000), ('10edd9d3-db75-51dc-909a-fc359097f487', '90444bd0-b092-566a-8d1d-51dcb75b2726', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '10edd9d3-db75-51dc-909a-fc359097f487';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('51cd76f7-395d-5fa9-85de-e9b0fb188df2', 'benchmark-funding-990f8880-f6cd-45c4-8fdd-75d3f3706fe0-1', '65d2cd74-1800-5978-bc88-852f07cc0acc', '5e7d1048-fc9e-56d8-b04f-f0d5becb2bf7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '65d2cd74-1800-5978-bc88-852f07cc0acc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5e7d1048-fc9e-56d8-b04f-f0d5becb2bf7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('51cd76f7-395d-5fa9-85de-e9b0fb188df2', '65d2cd74-1800-5978-bc88-852f07cc0acc', -1000000000), ('51cd76f7-395d-5fa9-85de-e9b0fb188df2', '5e7d1048-fc9e-56d8-b04f-f0d5becb2bf7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '51cd76f7-395d-5fa9-85de-e9b0fb188df2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0da59d47-27bf-5aac-aa10-84d8448c540e', 'benchmark-funding-990f8880-f6cd-45c4-8fdd-75d3f3706fe0-2', '65d2cd74-1800-5978-bc88-852f07cc0acc', 'cd5d393b-b9f3-5838-b4fd-c2ecdf1fe31f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '65d2cd74-1800-5978-bc88-852f07cc0acc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'cd5d393b-b9f3-5838-b4fd-c2ecdf1fe31f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0da59d47-27bf-5aac-aa10-84d8448c540e', '65d2cd74-1800-5978-bc88-852f07cc0acc', -1000000000), ('0da59d47-27bf-5aac-aa10-84d8448c540e', 'cd5d393b-b9f3-5838-b4fd-c2ecdf1fe31f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0da59d47-27bf-5aac-aa10-84d8448c540e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0ee9d793-15bd-56d2-baaf-fed97c40b40b', 'benchmark-funding-990f8880-f6cd-45c4-8fdd-75d3f3706fe0-3', '65d2cd74-1800-5978-bc88-852f07cc0acc', '330190d2-4acd-5b53-943a-1c411c365877', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '65d2cd74-1800-5978-bc88-852f07cc0acc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '330190d2-4acd-5b53-943a-1c411c365877';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0ee9d793-15bd-56d2-baaf-fed97c40b40b', '65d2cd74-1800-5978-bc88-852f07cc0acc', -1000000000), ('0ee9d793-15bd-56d2-baaf-fed97c40b40b', '330190d2-4acd-5b53-943a-1c411c365877', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0ee9d793-15bd-56d2-baaf-fed97c40b40b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b640c868-718e-505f-b1ae-4a90d1581b86', 'benchmark-funding-990f8880-f6cd-45c4-8fdd-75d3f3706fe0-4', '65d2cd74-1800-5978-bc88-852f07cc0acc', 'e4c8c5c9-a627-55f2-a2df-bf57b3fbdf2d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '65d2cd74-1800-5978-bc88-852f07cc0acc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e4c8c5c9-a627-55f2-a2df-bf57b3fbdf2d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b640c868-718e-505f-b1ae-4a90d1581b86', '65d2cd74-1800-5978-bc88-852f07cc0acc', -1000000000), ('b640c868-718e-505f-b1ae-4a90d1581b86', 'e4c8c5c9-a627-55f2-a2df-bf57b3fbdf2d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b640c868-718e-505f-b1ae-4a90d1581b86';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a1dd4cc0-19be-518e-b98d-257f7ac6849b', 'benchmark-funding-990f8880-f6cd-45c4-8fdd-75d3f3706fe0-5', '65d2cd74-1800-5978-bc88-852f07cc0acc', 'e385d4b8-4c02-5dc3-878b-8371f0af8c69', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '65d2cd74-1800-5978-bc88-852f07cc0acc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e385d4b8-4c02-5dc3-878b-8371f0af8c69';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a1dd4cc0-19be-518e-b98d-257f7ac6849b', '65d2cd74-1800-5978-bc88-852f07cc0acc', -1000000000), ('a1dd4cc0-19be-518e-b98d-257f7ac6849b', 'e385d4b8-4c02-5dc3-878b-8371f0af8c69', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a1dd4cc0-19be-518e-b98d-257f7ac6849b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('01082fca-3718-5dfa-88d9-75c0518f6290', 'benchmark-funding-990f8880-f6cd-45c4-8fdd-75d3f3706fe0-6', '65d2cd74-1800-5978-bc88-852f07cc0acc', '1241a25b-c732-5496-b799-4b4f7ce5cdb3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '65d2cd74-1800-5978-bc88-852f07cc0acc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1241a25b-c732-5496-b799-4b4f7ce5cdb3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('01082fca-3718-5dfa-88d9-75c0518f6290', '65d2cd74-1800-5978-bc88-852f07cc0acc', -1000000000), ('01082fca-3718-5dfa-88d9-75c0518f6290', '1241a25b-c732-5496-b799-4b4f7ce5cdb3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '01082fca-3718-5dfa-88d9-75c0518f6290';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('2bbe2220-744f-57bb-bae7-afcf93f651a8', 'benchmark-funding-990f8880-f6cd-45c4-8fdd-75d3f3706fe0-7', '65d2cd74-1800-5978-bc88-852f07cc0acc', 'c595becc-653d-5e53-863d-9a99a9110501', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '65d2cd74-1800-5978-bc88-852f07cc0acc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c595becc-653d-5e53-863d-9a99a9110501';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('2bbe2220-744f-57bb-bae7-afcf93f651a8', '65d2cd74-1800-5978-bc88-852f07cc0acc', -1000000000), ('2bbe2220-744f-57bb-bae7-afcf93f651a8', 'c595becc-653d-5e53-863d-9a99a9110501', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '2bbe2220-744f-57bb-bae7-afcf93f651a8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4fb2c368-a601-5384-a9d3-780af166a2d3', 'benchmark-funding-990f8880-f6cd-45c4-8fdd-75d3f3706fe0-8', '65d2cd74-1800-5978-bc88-852f07cc0acc', '96fe041b-e7e1-50f1-b9ed-f2456222d870', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '65d2cd74-1800-5978-bc88-852f07cc0acc';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '96fe041b-e7e1-50f1-b9ed-f2456222d870';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4fb2c368-a601-5384-a9d3-780af166a2d3', '65d2cd74-1800-5978-bc88-852f07cc0acc', -1000000000), ('4fb2c368-a601-5384-a9d3-780af166a2d3', '96fe041b-e7e1-50f1-b9ed-f2456222d870', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4fb2c368-a601-5384-a9d3-780af166a2d3';
COMMIT;
