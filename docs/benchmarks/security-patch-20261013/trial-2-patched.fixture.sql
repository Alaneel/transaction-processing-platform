-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', 'ISSUANCE', 'ACTIVE', 'FIC'),
('14b2a56b-4f61-503b-83b1-afd27943e569', 'USER', 'ACTIVE', 'FIC'),
('1b431cd2-f229-588a-95c2-fec3cba610a6', 'USER', 'ACTIVE', 'FIC'),
('1ba2a6d5-9aa6-5852-9beb-969d065c66c1', 'USER', 'ACTIVE', 'FIC'),
('2004973c-79f5-5862-995c-5fa22def5956', 'USER', 'ACTIVE', 'FIC'),
('273c2742-4d00-5cac-acf1-456634cc2510', 'USER', 'ACTIVE', 'FIC'),
('319c3063-474d-50e8-a625-e17d5ea62cdf', 'USER', 'ACTIVE', 'FIC'),
('35d53941-e427-52be-a23c-1d02968a5e87', 'USER', 'ACTIVE', 'FIC'),
('38bbb523-a9d0-5a0d-bc5b-2cb3ed819fd5', 'USER', 'ACTIVE', 'FIC'),
('4530c034-e04a-5cd6-ab91-17df4a3b0508', 'USER', 'ACTIVE', 'FIC'),
('56777a2f-ddf5-57ac-bdb8-3a3c280da71a', 'USER', 'ACTIVE', 'FIC'),
('59bf184e-f0a2-5e78-b49a-a86a304d6879', 'USER', 'ACTIVE', 'FIC'),
('61e1b27d-ee1b-5f9c-ae5f-a1f201634c98', 'USER', 'ACTIVE', 'FIC'),
('631022d6-2019-568e-b9a0-88e242f82799', 'USER', 'ACTIVE', 'FIC'),
('71e30572-6c48-57d0-9503-ec6efdcb7d59', 'USER', 'ACTIVE', 'FIC'),
('7c316839-8152-560d-9727-e63ccba3b86a', 'USER', 'ACTIVE', 'FIC'),
('7cb501cb-d149-5cdc-a7df-871c5983d717', 'USER', 'ACTIVE', 'FIC'),
('8b3b0213-3ec9-54a3-8df8-fb8d2ddd0ea9', 'USER', 'ACTIVE', 'FIC'),
('8cc10e81-6c8f-5943-b8fa-9c109ce754ba', 'USER', 'ACTIVE', 'FIC'),
('9a01a1ed-1ddd-5606-b4fc-6feb53880fc0', 'USER', 'ACTIVE', 'FIC'),
('a08eabb6-9e5d-576e-826c-310fb37e45d8', 'USER', 'ACTIVE', 'FIC'),
('d2082275-b7c3-5952-8fd8-2dd4bcca27e9', 'USER', 'ACTIVE', 'FIC'),
('d35894d6-d68c-5b46-8d29-0ea9879d49fe', 'USER', 'ACTIVE', 'FIC'),
('ed021b23-5476-5623-9f5a-ad7cd6accb36', 'USER', 'ACTIVE', 'FIC'),
('f4e5d0c6-6e96-505c-948c-b818d2254141', 'USER', 'ACTIVE', 'FIC'),
('f8bff5b3-abca-57c8-b472-01610d6e220b', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', 0),
('14b2a56b-4f61-503b-83b1-afd27943e569', 0),
('1b431cd2-f229-588a-95c2-fec3cba610a6', 0),
('1ba2a6d5-9aa6-5852-9beb-969d065c66c1', 0),
('2004973c-79f5-5862-995c-5fa22def5956', 0),
('273c2742-4d00-5cac-acf1-456634cc2510', 0),
('319c3063-474d-50e8-a625-e17d5ea62cdf', 0),
('35d53941-e427-52be-a23c-1d02968a5e87', 0),
('38bbb523-a9d0-5a0d-bc5b-2cb3ed819fd5', 0),
('4530c034-e04a-5cd6-ab91-17df4a3b0508', 0),
('56777a2f-ddf5-57ac-bdb8-3a3c280da71a', 0),
('59bf184e-f0a2-5e78-b49a-a86a304d6879', 0),
('61e1b27d-ee1b-5f9c-ae5f-a1f201634c98', 0),
('631022d6-2019-568e-b9a0-88e242f82799', 0),
('71e30572-6c48-57d0-9503-ec6efdcb7d59', 0),
('7c316839-8152-560d-9727-e63ccba3b86a', 0),
('7cb501cb-d149-5cdc-a7df-871c5983d717', 0),
('8b3b0213-3ec9-54a3-8df8-fb8d2ddd0ea9', 0),
('8cc10e81-6c8f-5943-b8fa-9c109ce754ba', 0),
('9a01a1ed-1ddd-5606-b4fc-6feb53880fc0', 0),
('a08eabb6-9e5d-576e-826c-310fb37e45d8', 0),
('d2082275-b7c3-5952-8fd8-2dd4bcca27e9', 0),
('d35894d6-d68c-5b46-8d29-0ea9879d49fe', 0),
('ed021b23-5476-5623-9f5a-ad7cd6accb36', 0),
('f4e5d0c6-6e96-505c-948c-b818d2254141', 0),
('f8bff5b3-abca-57c8-b472-01610d6e220b', 0);
SELECT account_id FROM balances WHERE account_id IN ('0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0','14b2a56b-4f61-503b-83b1-afd27943e569','1b431cd2-f229-588a-95c2-fec3cba610a6','1ba2a6d5-9aa6-5852-9beb-969d065c66c1','2004973c-79f5-5862-995c-5fa22def5956','273c2742-4d00-5cac-acf1-456634cc2510','319c3063-474d-50e8-a625-e17d5ea62cdf','35d53941-e427-52be-a23c-1d02968a5e87','38bbb523-a9d0-5a0d-bc5b-2cb3ed819fd5','4530c034-e04a-5cd6-ab91-17df4a3b0508','56777a2f-ddf5-57ac-bdb8-3a3c280da71a','59bf184e-f0a2-5e78-b49a-a86a304d6879','61e1b27d-ee1b-5f9c-ae5f-a1f201634c98','631022d6-2019-568e-b9a0-88e242f82799','71e30572-6c48-57d0-9503-ec6efdcb7d59','7c316839-8152-560d-9727-e63ccba3b86a','7cb501cb-d149-5cdc-a7df-871c5983d717','8b3b0213-3ec9-54a3-8df8-fb8d2ddd0ea9','8cc10e81-6c8f-5943-b8fa-9c109ce754ba','9a01a1ed-1ddd-5606-b4fc-6feb53880fc0','a08eabb6-9e5d-576e-826c-310fb37e45d8','d2082275-b7c3-5952-8fd8-2dd4bcca27e9','d35894d6-d68c-5b46-8d29-0ea9879d49fe','ed021b23-5476-5623-9f5a-ad7cd6accb36','f4e5d0c6-6e96-505c-948c-b818d2254141','f8bff5b3-abca-57c8-b472-01610d6e220b') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('97f99503-5807-562f-abac-e9eec2ebef32', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-0', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', '4530c034-e04a-5cd6-ab91-17df4a3b0508', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4530c034-e04a-5cd6-ab91-17df4a3b0508';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('97f99503-5807-562f-abac-e9eec2ebef32', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('97f99503-5807-562f-abac-e9eec2ebef32', '4530c034-e04a-5cd6-ab91-17df4a3b0508', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '97f99503-5807-562f-abac-e9eec2ebef32';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('82e02d7c-ea98-521d-a9ee-521d7e23b1a2', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-1', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', 'd35894d6-d68c-5b46-8d29-0ea9879d49fe', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd35894d6-d68c-5b46-8d29-0ea9879d49fe';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('82e02d7c-ea98-521d-a9ee-521d7e23b1a2', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('82e02d7c-ea98-521d-a9ee-521d7e23b1a2', 'd35894d6-d68c-5b46-8d29-0ea9879d49fe', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '82e02d7c-ea98-521d-a9ee-521d7e23b1a2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4e53efa9-250a-51ce-87a2-f4d1b3a47130', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-2', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', '56777a2f-ddf5-57ac-bdb8-3a3c280da71a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '56777a2f-ddf5-57ac-bdb8-3a3c280da71a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4e53efa9-250a-51ce-87a2-f4d1b3a47130', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('4e53efa9-250a-51ce-87a2-f4d1b3a47130', '56777a2f-ddf5-57ac-bdb8-3a3c280da71a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4e53efa9-250a-51ce-87a2-f4d1b3a47130';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('153fb72a-293d-592b-8cb7-eebc1f780824', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-3', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', '61e1b27d-ee1b-5f9c-ae5f-a1f201634c98', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '61e1b27d-ee1b-5f9c-ae5f-a1f201634c98';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('153fb72a-293d-592b-8cb7-eebc1f780824', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('153fb72a-293d-592b-8cb7-eebc1f780824', '61e1b27d-ee1b-5f9c-ae5f-a1f201634c98', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '153fb72a-293d-592b-8cb7-eebc1f780824';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c767d767-471e-5990-a137-c12b7ff64237', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-4', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', '38bbb523-a9d0-5a0d-bc5b-2cb3ed819fd5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '38bbb523-a9d0-5a0d-bc5b-2cb3ed819fd5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c767d767-471e-5990-a137-c12b7ff64237', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('c767d767-471e-5990-a137-c12b7ff64237', '38bbb523-a9d0-5a0d-bc5b-2cb3ed819fd5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c767d767-471e-5990-a137-c12b7ff64237';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4b3f608e-aba3-5d11-aa23-d89b7f1fe5cc', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-5', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', '8cc10e81-6c8f-5943-b8fa-9c109ce754ba', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8cc10e81-6c8f-5943-b8fa-9c109ce754ba';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4b3f608e-aba3-5d11-aa23-d89b7f1fe5cc', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('4b3f608e-aba3-5d11-aa23-d89b7f1fe5cc', '8cc10e81-6c8f-5943-b8fa-9c109ce754ba', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4b3f608e-aba3-5d11-aa23-d89b7f1fe5cc';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c775684d-bba5-5e14-b663-dac9e37dd560', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-6', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', '71e30572-6c48-57d0-9503-ec6efdcb7d59', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '71e30572-6c48-57d0-9503-ec6efdcb7d59';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c775684d-bba5-5e14-b663-dac9e37dd560', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('c775684d-bba5-5e14-b663-dac9e37dd560', '71e30572-6c48-57d0-9503-ec6efdcb7d59', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c775684d-bba5-5e14-b663-dac9e37dd560';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('07b63e39-dbb4-5e71-beb3-fdb49ee7b844', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-7', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', 'ed021b23-5476-5623-9f5a-ad7cd6accb36', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ed021b23-5476-5623-9f5a-ad7cd6accb36';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('07b63e39-dbb4-5e71-beb3-fdb49ee7b844', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('07b63e39-dbb4-5e71-beb3-fdb49ee7b844', 'ed021b23-5476-5623-9f5a-ad7cd6accb36', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '07b63e39-dbb4-5e71-beb3-fdb49ee7b844';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('211bd33a-1f13-5dd6-ae22-8204f9fb0bd0', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-8', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', '14b2a56b-4f61-503b-83b1-afd27943e569', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '14b2a56b-4f61-503b-83b1-afd27943e569';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('211bd33a-1f13-5dd6-ae22-8204f9fb0bd0', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('211bd33a-1f13-5dd6-ae22-8204f9fb0bd0', '14b2a56b-4f61-503b-83b1-afd27943e569', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '211bd33a-1f13-5dd6-ae22-8204f9fb0bd0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0569cf90-f7a2-5fcf-ab50-f7d00ab7cb56', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-9', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', 'd2082275-b7c3-5952-8fd8-2dd4bcca27e9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd2082275-b7c3-5952-8fd8-2dd4bcca27e9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0569cf90-f7a2-5fcf-ab50-f7d00ab7cb56', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('0569cf90-f7a2-5fcf-ab50-f7d00ab7cb56', 'd2082275-b7c3-5952-8fd8-2dd4bcca27e9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0569cf90-f7a2-5fcf-ab50-f7d00ab7cb56';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('fe89386e-b81a-5e23-971c-31613cf4cdc6', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-10', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', '319c3063-474d-50e8-a625-e17d5ea62cdf', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '319c3063-474d-50e8-a625-e17d5ea62cdf';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('fe89386e-b81a-5e23-971c-31613cf4cdc6', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('fe89386e-b81a-5e23-971c-31613cf4cdc6', '319c3063-474d-50e8-a625-e17d5ea62cdf', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'fe89386e-b81a-5e23-971c-31613cf4cdc6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('bc1edf3c-45f7-5ef7-8690-c7b2460c60b1', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-11', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', '631022d6-2019-568e-b9a0-88e242f82799', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '631022d6-2019-568e-b9a0-88e242f82799';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('bc1edf3c-45f7-5ef7-8690-c7b2460c60b1', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('bc1edf3c-45f7-5ef7-8690-c7b2460c60b1', '631022d6-2019-568e-b9a0-88e242f82799', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'bc1edf3c-45f7-5ef7-8690-c7b2460c60b1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('2ee4c21e-645c-56c6-8e30-ce55d32a0885', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-12', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', 'f8bff5b3-abca-57c8-b472-01610d6e220b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f8bff5b3-abca-57c8-b472-01610d6e220b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('2ee4c21e-645c-56c6-8e30-ce55d32a0885', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('2ee4c21e-645c-56c6-8e30-ce55d32a0885', 'f8bff5b3-abca-57c8-b472-01610d6e220b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '2ee4c21e-645c-56c6-8e30-ce55d32a0885';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('255c51e9-e9af-5f04-ba30-50a8acb160a9', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-13', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', '1b431cd2-f229-588a-95c2-fec3cba610a6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1b431cd2-f229-588a-95c2-fec3cba610a6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('255c51e9-e9af-5f04-ba30-50a8acb160a9', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('255c51e9-e9af-5f04-ba30-50a8acb160a9', '1b431cd2-f229-588a-95c2-fec3cba610a6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '255c51e9-e9af-5f04-ba30-50a8acb160a9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6a46028c-3539-5f7c-9529-93b68fb4fa6e', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-14', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', '7c316839-8152-560d-9727-e63ccba3b86a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7c316839-8152-560d-9727-e63ccba3b86a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6a46028c-3539-5f7c-9529-93b68fb4fa6e', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('6a46028c-3539-5f7c-9529-93b68fb4fa6e', '7c316839-8152-560d-9727-e63ccba3b86a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6a46028c-3539-5f7c-9529-93b68fb4fa6e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8a46f229-dfc8-5257-aec1-9255599b173e', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-15', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', '8b3b0213-3ec9-54a3-8df8-fb8d2ddd0ea9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8b3b0213-3ec9-54a3-8df8-fb8d2ddd0ea9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8a46f229-dfc8-5257-aec1-9255599b173e', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('8a46f229-dfc8-5257-aec1-9255599b173e', '8b3b0213-3ec9-54a3-8df8-fb8d2ddd0ea9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8a46f229-dfc8-5257-aec1-9255599b173e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d3a3958f-0b0c-5b59-970c-eec06a0a33f2', 'benchmark-funding-3c009ec7-0e50-4864-b96e-8904ff38fc02-16', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', '2004973c-79f5-5862-995c-5fa22def5956', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2004973c-79f5-5862-995c-5fa22def5956';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d3a3958f-0b0c-5b59-970c-eec06a0a33f2', '0d9fd614-cb4a-5a9a-99b4-cdb773cc9ad0', -1000000000), ('d3a3958f-0b0c-5b59-970c-eec06a0a33f2', '2004973c-79f5-5862-995c-5fa22def5956', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd3a3958f-0b0c-5b59-970c-eec06a0a33f2';
COMMIT;
