-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('03f1f84d-bac6-5d1d-adf2-c4dd3b3508e5', 'USER', 'ACTIVE', 'FIC'),
('0d69955b-c4af-57d4-9d5c-abaff4d89666', 'USER', 'ACTIVE', 'FIC'),
('128e9ab1-06bd-5edc-9a37-2be566aca0a6', 'USER', 'ACTIVE', 'FIC'),
('24bbbc65-e596-55c8-97b7-624ead3f065e', 'USER', 'ACTIVE', 'FIC'),
('254ddd76-da6b-5645-bdec-408e67af6fa2', 'USER', 'ACTIVE', 'FIC'),
('2d4ea629-a2d4-5059-9d39-56f88c0864d8', 'USER', 'ACTIVE', 'FIC'),
('3e4cfe64-84d0-5206-8f13-7493f390619f', 'USER', 'ACTIVE', 'FIC'),
('40ad1832-f510-5ed8-adc8-5a3d6e14d998', 'USER', 'ACTIVE', 'FIC'),
('40bca3cf-3543-5f78-af48-25a30f269769', 'USER', 'ACTIVE', 'FIC'),
('44f652f8-c206-55d3-9720-0eceae9fa3e6', 'USER', 'ACTIVE', 'FIC'),
('58d8a190-f2e2-51b6-a4aa-c139424b4bbd', 'USER', 'ACTIVE', 'FIC'),
('6e99bb68-555f-5fb8-88a7-0de7e098e753', 'USER', 'ACTIVE', 'FIC'),
('70ac9cfd-5309-508e-adf8-98839f6ef89b', 'USER', 'ACTIVE', 'FIC'),
('7fb778cd-c68c-5212-83f6-5e171050a52d', 'USER', 'ACTIVE', 'FIC'),
('8a2de272-2d88-5d95-9a02-19b1face14dc', 'USER', 'ACTIVE', 'FIC'),
('8b0a88bf-e0ec-529d-9463-2218b92c8bc2', 'USER', 'ACTIVE', 'FIC'),
('8d124af2-b6e9-54e0-8102-116ac9d8667a', 'USER', 'ACTIVE', 'FIC'),
('91c1e908-7481-5883-8842-fa5b4d46a4d2', 'USER', 'ACTIVE', 'FIC'),
('b3c86b11-dc2d-5bdf-aa74-3035f202f00a', 'USER', 'ACTIVE', 'FIC'),
('bd66b99f-2b1f-59ac-b6cd-9ae3f9191965', 'USER', 'ACTIVE', 'FIC'),
('be10011a-9bcf-50e1-8f77-31898cbf1ccf', 'USER', 'ACTIVE', 'FIC'),
('e7f103bb-f471-5b2c-8c09-0b9b4f87dacb', 'USER', 'ACTIVE', 'FIC'),
('eaf2f67e-7bef-532c-96ca-567b6b5af38b', 'USER', 'ACTIVE', 'FIC'),
('f41e5b52-e618-5c5c-81e6-7f535a1a1eae', 'ISSUANCE', 'ACTIVE', 'FIC'),
('fad9250c-b8e0-5af2-8632-049d14e49376', 'USER', 'ACTIVE', 'FIC'),
('fda74c18-29ec-5385-a84c-11619baaeda3', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('03f1f84d-bac6-5d1d-adf2-c4dd3b3508e5', 0),
('0d69955b-c4af-57d4-9d5c-abaff4d89666', 0),
('128e9ab1-06bd-5edc-9a37-2be566aca0a6', 0),
('24bbbc65-e596-55c8-97b7-624ead3f065e', 0),
('254ddd76-da6b-5645-bdec-408e67af6fa2', 0),
('2d4ea629-a2d4-5059-9d39-56f88c0864d8', 0),
('3e4cfe64-84d0-5206-8f13-7493f390619f', 0),
('40ad1832-f510-5ed8-adc8-5a3d6e14d998', 0),
('40bca3cf-3543-5f78-af48-25a30f269769', 0),
('44f652f8-c206-55d3-9720-0eceae9fa3e6', 0),
('58d8a190-f2e2-51b6-a4aa-c139424b4bbd', 0),
('6e99bb68-555f-5fb8-88a7-0de7e098e753', 0),
('70ac9cfd-5309-508e-adf8-98839f6ef89b', 0),
('7fb778cd-c68c-5212-83f6-5e171050a52d', 0),
('8a2de272-2d88-5d95-9a02-19b1face14dc', 0),
('8b0a88bf-e0ec-529d-9463-2218b92c8bc2', 0),
('8d124af2-b6e9-54e0-8102-116ac9d8667a', 0),
('91c1e908-7481-5883-8842-fa5b4d46a4d2', 0),
('b3c86b11-dc2d-5bdf-aa74-3035f202f00a', 0),
('bd66b99f-2b1f-59ac-b6cd-9ae3f9191965', 0),
('be10011a-9bcf-50e1-8f77-31898cbf1ccf', 0),
('e7f103bb-f471-5b2c-8c09-0b9b4f87dacb', 0),
('eaf2f67e-7bef-532c-96ca-567b6b5af38b', 0),
('f41e5b52-e618-5c5c-81e6-7f535a1a1eae', 0),
('fad9250c-b8e0-5af2-8632-049d14e49376', 0),
('fda74c18-29ec-5385-a84c-11619baaeda3', 0);
SELECT account_id FROM balances WHERE account_id IN ('03f1f84d-bac6-5d1d-adf2-c4dd3b3508e5','0d69955b-c4af-57d4-9d5c-abaff4d89666','128e9ab1-06bd-5edc-9a37-2be566aca0a6','24bbbc65-e596-55c8-97b7-624ead3f065e','254ddd76-da6b-5645-bdec-408e67af6fa2','2d4ea629-a2d4-5059-9d39-56f88c0864d8','3e4cfe64-84d0-5206-8f13-7493f390619f','40ad1832-f510-5ed8-adc8-5a3d6e14d998','40bca3cf-3543-5f78-af48-25a30f269769','44f652f8-c206-55d3-9720-0eceae9fa3e6','58d8a190-f2e2-51b6-a4aa-c139424b4bbd','6e99bb68-555f-5fb8-88a7-0de7e098e753','70ac9cfd-5309-508e-adf8-98839f6ef89b','7fb778cd-c68c-5212-83f6-5e171050a52d','8a2de272-2d88-5d95-9a02-19b1face14dc','8b0a88bf-e0ec-529d-9463-2218b92c8bc2','8d124af2-b6e9-54e0-8102-116ac9d8667a','91c1e908-7481-5883-8842-fa5b4d46a4d2','b3c86b11-dc2d-5bdf-aa74-3035f202f00a','bd66b99f-2b1f-59ac-b6cd-9ae3f9191965','be10011a-9bcf-50e1-8f77-31898cbf1ccf','e7f103bb-f471-5b2c-8c09-0b9b4f87dacb','eaf2f67e-7bef-532c-96ca-567b6b5af38b','f41e5b52-e618-5c5c-81e6-7f535a1a1eae','fad9250c-b8e0-5af2-8632-049d14e49376','fda74c18-29ec-5385-a84c-11619baaeda3') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('da506d34-3e01-55ce-bb5c-db076175cea7', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-0', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', '40bca3cf-3543-5f78-af48-25a30f269769', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '40bca3cf-3543-5f78-af48-25a30f269769';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('da506d34-3e01-55ce-bb5c-db076175cea7', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('da506d34-3e01-55ce-bb5c-db076175cea7', '40bca3cf-3543-5f78-af48-25a30f269769', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'da506d34-3e01-55ce-bb5c-db076175cea7';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('129ea07c-824f-51cf-b047-b8e9026f2ca8', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-1', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', '3e4cfe64-84d0-5206-8f13-7493f390619f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3e4cfe64-84d0-5206-8f13-7493f390619f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('129ea07c-824f-51cf-b047-b8e9026f2ca8', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('129ea07c-824f-51cf-b047-b8e9026f2ca8', '3e4cfe64-84d0-5206-8f13-7493f390619f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '129ea07c-824f-51cf-b047-b8e9026f2ca8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c4636b8e-7ba1-5a40-8639-5a783a8f9080', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-2', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', '24bbbc65-e596-55c8-97b7-624ead3f065e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '24bbbc65-e596-55c8-97b7-624ead3f065e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c4636b8e-7ba1-5a40-8639-5a783a8f9080', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('c4636b8e-7ba1-5a40-8639-5a783a8f9080', '24bbbc65-e596-55c8-97b7-624ead3f065e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c4636b8e-7ba1-5a40-8639-5a783a8f9080';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9d5a756c-31ed-50b2-8d53-55c5a7cbc69a', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-3', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', '91c1e908-7481-5883-8842-fa5b4d46a4d2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '91c1e908-7481-5883-8842-fa5b4d46a4d2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9d5a756c-31ed-50b2-8d53-55c5a7cbc69a', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('9d5a756c-31ed-50b2-8d53-55c5a7cbc69a', '91c1e908-7481-5883-8842-fa5b4d46a4d2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9d5a756c-31ed-50b2-8d53-55c5a7cbc69a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d91cafac-0709-52c8-864e-eddb6bf58e40', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-4', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', '128e9ab1-06bd-5edc-9a37-2be566aca0a6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '128e9ab1-06bd-5edc-9a37-2be566aca0a6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d91cafac-0709-52c8-864e-eddb6bf58e40', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('d91cafac-0709-52c8-864e-eddb6bf58e40', '128e9ab1-06bd-5edc-9a37-2be566aca0a6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd91cafac-0709-52c8-864e-eddb6bf58e40';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('209ffb20-62ff-567c-9a9a-9a1a96b6d76f', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-5', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', 'e7f103bb-f471-5b2c-8c09-0b9b4f87dacb', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e7f103bb-f471-5b2c-8c09-0b9b4f87dacb';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('209ffb20-62ff-567c-9a9a-9a1a96b6d76f', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('209ffb20-62ff-567c-9a9a-9a1a96b6d76f', 'e7f103bb-f471-5b2c-8c09-0b9b4f87dacb', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '209ffb20-62ff-567c-9a9a-9a1a96b6d76f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('500e490e-aa57-5a17-85d6-93a23982f000', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-6', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', '8d124af2-b6e9-54e0-8102-116ac9d8667a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8d124af2-b6e9-54e0-8102-116ac9d8667a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('500e490e-aa57-5a17-85d6-93a23982f000', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('500e490e-aa57-5a17-85d6-93a23982f000', '8d124af2-b6e9-54e0-8102-116ac9d8667a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '500e490e-aa57-5a17-85d6-93a23982f000';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a8b17c88-76f7-5a7b-9e8c-f86d6f8f418c', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-7', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', 'bd66b99f-2b1f-59ac-b6cd-9ae3f9191965', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'bd66b99f-2b1f-59ac-b6cd-9ae3f9191965';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a8b17c88-76f7-5a7b-9e8c-f86d6f8f418c', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('a8b17c88-76f7-5a7b-9e8c-f86d6f8f418c', 'bd66b99f-2b1f-59ac-b6cd-9ae3f9191965', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a8b17c88-76f7-5a7b-9e8c-f86d6f8f418c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('321a8a47-c0d7-5eed-be84-15b51f39d501', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-8', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', '6e99bb68-555f-5fb8-88a7-0de7e098e753', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6e99bb68-555f-5fb8-88a7-0de7e098e753';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('321a8a47-c0d7-5eed-be84-15b51f39d501', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('321a8a47-c0d7-5eed-be84-15b51f39d501', '6e99bb68-555f-5fb8-88a7-0de7e098e753', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '321a8a47-c0d7-5eed-be84-15b51f39d501';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5f9ee19e-1506-5282-a475-b09ba9901210', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-9', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', '40ad1832-f510-5ed8-adc8-5a3d6e14d998', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '40ad1832-f510-5ed8-adc8-5a3d6e14d998';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5f9ee19e-1506-5282-a475-b09ba9901210', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('5f9ee19e-1506-5282-a475-b09ba9901210', '40ad1832-f510-5ed8-adc8-5a3d6e14d998', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5f9ee19e-1506-5282-a475-b09ba9901210';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('53b77419-be22-5882-b6b2-8e839e36865e', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-10', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', '03f1f84d-bac6-5d1d-adf2-c4dd3b3508e5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '03f1f84d-bac6-5d1d-adf2-c4dd3b3508e5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('53b77419-be22-5882-b6b2-8e839e36865e', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('53b77419-be22-5882-b6b2-8e839e36865e', '03f1f84d-bac6-5d1d-adf2-c4dd3b3508e5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '53b77419-be22-5882-b6b2-8e839e36865e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5d994a9c-83a9-5735-8c30-f815d0a39c76', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-11', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', '8b0a88bf-e0ec-529d-9463-2218b92c8bc2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8b0a88bf-e0ec-529d-9463-2218b92c8bc2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5d994a9c-83a9-5735-8c30-f815d0a39c76', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('5d994a9c-83a9-5735-8c30-f815d0a39c76', '8b0a88bf-e0ec-529d-9463-2218b92c8bc2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5d994a9c-83a9-5735-8c30-f815d0a39c76';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a5a23586-0b93-5c98-8a1d-0abe4f00d3f8', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-12', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', 'b3c86b11-dc2d-5bdf-aa74-3035f202f00a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b3c86b11-dc2d-5bdf-aa74-3035f202f00a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a5a23586-0b93-5c98-8a1d-0abe4f00d3f8', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('a5a23586-0b93-5c98-8a1d-0abe4f00d3f8', 'b3c86b11-dc2d-5bdf-aa74-3035f202f00a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a5a23586-0b93-5c98-8a1d-0abe4f00d3f8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('10defbc9-4998-5b57-b8de-6d5f4f253762', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-13', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', '58d8a190-f2e2-51b6-a4aa-c139424b4bbd', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '58d8a190-f2e2-51b6-a4aa-c139424b4bbd';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('10defbc9-4998-5b57-b8de-6d5f4f253762', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('10defbc9-4998-5b57-b8de-6d5f4f253762', '58d8a190-f2e2-51b6-a4aa-c139424b4bbd', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '10defbc9-4998-5b57-b8de-6d5f4f253762';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7b0057e0-b63d-55f0-b246-96dbb8035078', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-14', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', '2d4ea629-a2d4-5059-9d39-56f88c0864d8', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2d4ea629-a2d4-5059-9d39-56f88c0864d8';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7b0057e0-b63d-55f0-b246-96dbb8035078', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('7b0057e0-b63d-55f0-b246-96dbb8035078', '2d4ea629-a2d4-5059-9d39-56f88c0864d8', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7b0057e0-b63d-55f0-b246-96dbb8035078';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('87f66bf2-e8d9-5e2d-bba4-047fde37dfc9', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-15', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', 'fad9250c-b8e0-5af2-8632-049d14e49376', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fad9250c-b8e0-5af2-8632-049d14e49376';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('87f66bf2-e8d9-5e2d-bba4-047fde37dfc9', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('87f66bf2-e8d9-5e2d-bba4-047fde37dfc9', 'fad9250c-b8e0-5af2-8632-049d14e49376', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '87f66bf2-e8d9-5e2d-bba4-047fde37dfc9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('16b51440-5d02-517f-8073-3c485ff32359', 'benchmark-funding-4b3f1c8c-f7e7-46cc-bbd0-0069574b6b70-16', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', 'be10011a-9bcf-50e1-8f77-31898cbf1ccf', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'be10011a-9bcf-50e1-8f77-31898cbf1ccf';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('16b51440-5d02-517f-8073-3c485ff32359', 'f41e5b52-e618-5c5c-81e6-7f535a1a1eae', -1000000000), ('16b51440-5d02-517f-8073-3c485ff32359', 'be10011a-9bcf-50e1-8f77-31898cbf1ccf', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '16b51440-5d02-517f-8073-3c485ff32359';
COMMIT;
