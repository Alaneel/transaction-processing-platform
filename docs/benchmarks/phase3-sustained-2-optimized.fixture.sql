-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('034b7061-2ebc-5282-abe8-12d7514673b8', 'ISSUANCE', 'ACTIVE', 'FIC'),
('054563f9-9e53-550b-aec1-87503bf93683', 'USER', 'ACTIVE', 'FIC'),
('0629a846-731a-5b30-8c94-c18b9db3915c', 'USER', 'ACTIVE', 'FIC'),
('0a03f0a6-dbf3-510b-a321-c402d5739cb4', 'USER', 'ACTIVE', 'FIC'),
('16195917-6309-51aa-b5dc-5e79de299a92', 'USER', 'ACTIVE', 'FIC'),
('246b6fb3-9c54-5a64-9183-a99037815a2c', 'USER', 'ACTIVE', 'FIC'),
('2f15f891-bfbb-5afa-acc9-3cf92621783b', 'USER', 'ACTIVE', 'FIC'),
('4bf48ab6-2007-5533-aa7b-c88a83fc86a3', 'USER', 'ACTIVE', 'FIC'),
('4ed579aa-98b4-54d3-8bb5-9355e2ee9222', 'USER', 'ACTIVE', 'FIC'),
('532b21fe-73e7-5b90-87f2-d8b7e3a64454', 'USER', 'ACTIVE', 'FIC'),
('5d5c1342-b846-573d-aa9f-a423e944fe25', 'USER', 'ACTIVE', 'FIC'),
('6547675a-ee4b-58fc-b441-2909adc70b7e', 'USER', 'ACTIVE', 'FIC'),
('70c95468-7c32-5016-adac-52446e3fa88f', 'USER', 'ACTIVE', 'FIC'),
('81b27e7e-6137-565e-8b0d-945bd06b9119', 'USER', 'ACTIVE', 'FIC'),
('833e6e7b-8b96-52b0-9f40-4e2d630875e6', 'USER', 'ACTIVE', 'FIC'),
('9132abaa-4845-55f0-b653-ad9be57f6bbd', 'USER', 'ACTIVE', 'FIC'),
('9262479a-70bc-5126-9dd4-0b53771e50ff', 'USER', 'ACTIVE', 'FIC'),
('9bc739dd-ef5c-515b-8eaf-2a66a8b4571d', 'USER', 'ACTIVE', 'FIC'),
('a082150f-b810-5457-b539-972721a97a27', 'USER', 'ACTIVE', 'FIC'),
('a70be25a-4ca2-5b98-8533-09a1675958ff', 'USER', 'ACTIVE', 'FIC'),
('cb965099-378d-5a03-85f7-17b243fc9ed8', 'USER', 'ACTIVE', 'FIC'),
('e5128dc8-259a-532a-807b-84ff273001a1', 'USER', 'ACTIVE', 'FIC'),
('e60502cc-791a-5970-8b1b-c80ecfa493c6', 'USER', 'ACTIVE', 'FIC'),
('eca23307-0fde-5f09-b7a1-fa93383f2adf', 'USER', 'ACTIVE', 'FIC'),
('ed91e5be-c692-5f6c-b25b-66926e4cc933', 'USER', 'ACTIVE', 'FIC'),
('ed9bd16d-cc4b-5031-82f9-16754623a621', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('034b7061-2ebc-5282-abe8-12d7514673b8', 0),
('054563f9-9e53-550b-aec1-87503bf93683', 0),
('0629a846-731a-5b30-8c94-c18b9db3915c', 0),
('0a03f0a6-dbf3-510b-a321-c402d5739cb4', 0),
('16195917-6309-51aa-b5dc-5e79de299a92', 0),
('246b6fb3-9c54-5a64-9183-a99037815a2c', 0),
('2f15f891-bfbb-5afa-acc9-3cf92621783b', 0),
('4bf48ab6-2007-5533-aa7b-c88a83fc86a3', 0),
('4ed579aa-98b4-54d3-8bb5-9355e2ee9222', 0),
('532b21fe-73e7-5b90-87f2-d8b7e3a64454', 0),
('5d5c1342-b846-573d-aa9f-a423e944fe25', 0),
('6547675a-ee4b-58fc-b441-2909adc70b7e', 0),
('70c95468-7c32-5016-adac-52446e3fa88f', 0),
('81b27e7e-6137-565e-8b0d-945bd06b9119', 0),
('833e6e7b-8b96-52b0-9f40-4e2d630875e6', 0),
('9132abaa-4845-55f0-b653-ad9be57f6bbd', 0),
('9262479a-70bc-5126-9dd4-0b53771e50ff', 0),
('9bc739dd-ef5c-515b-8eaf-2a66a8b4571d', 0),
('a082150f-b810-5457-b539-972721a97a27', 0),
('a70be25a-4ca2-5b98-8533-09a1675958ff', 0),
('cb965099-378d-5a03-85f7-17b243fc9ed8', 0),
('e5128dc8-259a-532a-807b-84ff273001a1', 0),
('e60502cc-791a-5970-8b1b-c80ecfa493c6', 0),
('eca23307-0fde-5f09-b7a1-fa93383f2adf', 0),
('ed91e5be-c692-5f6c-b25b-66926e4cc933', 0),
('ed9bd16d-cc4b-5031-82f9-16754623a621', 0);
SELECT account_id FROM balances WHERE account_id IN ('034b7061-2ebc-5282-abe8-12d7514673b8','054563f9-9e53-550b-aec1-87503bf93683','0629a846-731a-5b30-8c94-c18b9db3915c','0a03f0a6-dbf3-510b-a321-c402d5739cb4','16195917-6309-51aa-b5dc-5e79de299a92','246b6fb3-9c54-5a64-9183-a99037815a2c','2f15f891-bfbb-5afa-acc9-3cf92621783b','4bf48ab6-2007-5533-aa7b-c88a83fc86a3','4ed579aa-98b4-54d3-8bb5-9355e2ee9222','532b21fe-73e7-5b90-87f2-d8b7e3a64454','5d5c1342-b846-573d-aa9f-a423e944fe25','6547675a-ee4b-58fc-b441-2909adc70b7e','70c95468-7c32-5016-adac-52446e3fa88f','81b27e7e-6137-565e-8b0d-945bd06b9119','833e6e7b-8b96-52b0-9f40-4e2d630875e6','9132abaa-4845-55f0-b653-ad9be57f6bbd','9262479a-70bc-5126-9dd4-0b53771e50ff','9bc739dd-ef5c-515b-8eaf-2a66a8b4571d','a082150f-b810-5457-b539-972721a97a27','a70be25a-4ca2-5b98-8533-09a1675958ff','cb965099-378d-5a03-85f7-17b243fc9ed8','e5128dc8-259a-532a-807b-84ff273001a1','e60502cc-791a-5970-8b1b-c80ecfa493c6','eca23307-0fde-5f09-b7a1-fa93383f2adf','ed91e5be-c692-5f6c-b25b-66926e4cc933','ed9bd16d-cc4b-5031-82f9-16754623a621') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('66b97505-249c-50c3-8044-9f6e43a6fc8b', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-0', '034b7061-2ebc-5282-abe8-12d7514673b8', '81b27e7e-6137-565e-8b0d-945bd06b9119', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '81b27e7e-6137-565e-8b0d-945bd06b9119';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('66b97505-249c-50c3-8044-9f6e43a6fc8b', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('66b97505-249c-50c3-8044-9f6e43a6fc8b', '81b27e7e-6137-565e-8b0d-945bd06b9119', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '66b97505-249c-50c3-8044-9f6e43a6fc8b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ee1314b6-0954-56be-8d13-73cac38b44bd', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-1', '034b7061-2ebc-5282-abe8-12d7514673b8', 'cb965099-378d-5a03-85f7-17b243fc9ed8', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'cb965099-378d-5a03-85f7-17b243fc9ed8';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ee1314b6-0954-56be-8d13-73cac38b44bd', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('ee1314b6-0954-56be-8d13-73cac38b44bd', 'cb965099-378d-5a03-85f7-17b243fc9ed8', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ee1314b6-0954-56be-8d13-73cac38b44bd';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7b531314-28d0-5322-9b7f-ddcc2c18dbbe', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-2', '034b7061-2ebc-5282-abe8-12d7514673b8', 'a082150f-b810-5457-b539-972721a97a27', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a082150f-b810-5457-b539-972721a97a27';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7b531314-28d0-5322-9b7f-ddcc2c18dbbe', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('7b531314-28d0-5322-9b7f-ddcc2c18dbbe', 'a082150f-b810-5457-b539-972721a97a27', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7b531314-28d0-5322-9b7f-ddcc2c18dbbe';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('087ae6e9-6733-59f3-a895-73c9df7beff2', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-3', '034b7061-2ebc-5282-abe8-12d7514673b8', '246b6fb3-9c54-5a64-9183-a99037815a2c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '246b6fb3-9c54-5a64-9183-a99037815a2c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('087ae6e9-6733-59f3-a895-73c9df7beff2', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('087ae6e9-6733-59f3-a895-73c9df7beff2', '246b6fb3-9c54-5a64-9183-a99037815a2c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '087ae6e9-6733-59f3-a895-73c9df7beff2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('243c4818-91bf-5c2c-99de-2216802fdc36', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-4', '034b7061-2ebc-5282-abe8-12d7514673b8', 'e5128dc8-259a-532a-807b-84ff273001a1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e5128dc8-259a-532a-807b-84ff273001a1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('243c4818-91bf-5c2c-99de-2216802fdc36', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('243c4818-91bf-5c2c-99de-2216802fdc36', 'e5128dc8-259a-532a-807b-84ff273001a1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '243c4818-91bf-5c2c-99de-2216802fdc36';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7816b529-a3a6-52c2-b8a1-b03cd2af4eeb', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-5', '034b7061-2ebc-5282-abe8-12d7514673b8', '2f15f891-bfbb-5afa-acc9-3cf92621783b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2f15f891-bfbb-5afa-acc9-3cf92621783b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7816b529-a3a6-52c2-b8a1-b03cd2af4eeb', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('7816b529-a3a6-52c2-b8a1-b03cd2af4eeb', '2f15f891-bfbb-5afa-acc9-3cf92621783b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7816b529-a3a6-52c2-b8a1-b03cd2af4eeb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('471279d3-cd80-550d-be4f-52c803391f18', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-6', '034b7061-2ebc-5282-abe8-12d7514673b8', 'eca23307-0fde-5f09-b7a1-fa93383f2adf', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'eca23307-0fde-5f09-b7a1-fa93383f2adf';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('471279d3-cd80-550d-be4f-52c803391f18', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('471279d3-cd80-550d-be4f-52c803391f18', 'eca23307-0fde-5f09-b7a1-fa93383f2adf', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '471279d3-cd80-550d-be4f-52c803391f18';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5a63ed87-4868-5ebf-adf9-c902e40614cb', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-7', '034b7061-2ebc-5282-abe8-12d7514673b8', 'e60502cc-791a-5970-8b1b-c80ecfa493c6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e60502cc-791a-5970-8b1b-c80ecfa493c6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5a63ed87-4868-5ebf-adf9-c902e40614cb', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('5a63ed87-4868-5ebf-adf9-c902e40614cb', 'e60502cc-791a-5970-8b1b-c80ecfa493c6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5a63ed87-4868-5ebf-adf9-c902e40614cb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('eb3f3236-66d2-58d2-85da-473bc3b5f8b4', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-8', '034b7061-2ebc-5282-abe8-12d7514673b8', '9262479a-70bc-5126-9dd4-0b53771e50ff', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9262479a-70bc-5126-9dd4-0b53771e50ff';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('eb3f3236-66d2-58d2-85da-473bc3b5f8b4', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('eb3f3236-66d2-58d2-85da-473bc3b5f8b4', '9262479a-70bc-5126-9dd4-0b53771e50ff', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'eb3f3236-66d2-58d2-85da-473bc3b5f8b4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('42fd6ec6-a9ed-58f0-aacf-10bbd88655e1', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-9', '034b7061-2ebc-5282-abe8-12d7514673b8', '9132abaa-4845-55f0-b653-ad9be57f6bbd', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9132abaa-4845-55f0-b653-ad9be57f6bbd';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('42fd6ec6-a9ed-58f0-aacf-10bbd88655e1', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('42fd6ec6-a9ed-58f0-aacf-10bbd88655e1', '9132abaa-4845-55f0-b653-ad9be57f6bbd', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '42fd6ec6-a9ed-58f0-aacf-10bbd88655e1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6ef05111-3b7d-5ce4-800e-42c9a023b098', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-10', '034b7061-2ebc-5282-abe8-12d7514673b8', '70c95468-7c32-5016-adac-52446e3fa88f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '70c95468-7c32-5016-adac-52446e3fa88f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6ef05111-3b7d-5ce4-800e-42c9a023b098', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('6ef05111-3b7d-5ce4-800e-42c9a023b098', '70c95468-7c32-5016-adac-52446e3fa88f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6ef05111-3b7d-5ce4-800e-42c9a023b098';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3f783873-dedc-5266-bf41-ff491eee1a29', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-11', '034b7061-2ebc-5282-abe8-12d7514673b8', 'ed91e5be-c692-5f6c-b25b-66926e4cc933', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ed91e5be-c692-5f6c-b25b-66926e4cc933';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3f783873-dedc-5266-bf41-ff491eee1a29', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('3f783873-dedc-5266-bf41-ff491eee1a29', 'ed91e5be-c692-5f6c-b25b-66926e4cc933', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3f783873-dedc-5266-bf41-ff491eee1a29';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f2a3d02d-5658-505a-bcbf-5f9e66647171', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-12', '034b7061-2ebc-5282-abe8-12d7514673b8', '0629a846-731a-5b30-8c94-c18b9db3915c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0629a846-731a-5b30-8c94-c18b9db3915c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f2a3d02d-5658-505a-bcbf-5f9e66647171', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('f2a3d02d-5658-505a-bcbf-5f9e66647171', '0629a846-731a-5b30-8c94-c18b9db3915c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f2a3d02d-5658-505a-bcbf-5f9e66647171';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('68a19056-42bc-5bbf-96bc-911005f223c1', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-13', '034b7061-2ebc-5282-abe8-12d7514673b8', '9bc739dd-ef5c-515b-8eaf-2a66a8b4571d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9bc739dd-ef5c-515b-8eaf-2a66a8b4571d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('68a19056-42bc-5bbf-96bc-911005f223c1', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('68a19056-42bc-5bbf-96bc-911005f223c1', '9bc739dd-ef5c-515b-8eaf-2a66a8b4571d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '68a19056-42bc-5bbf-96bc-911005f223c1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c5369b8b-47c9-5cd1-98e9-1c6adc0251ec', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-14', '034b7061-2ebc-5282-abe8-12d7514673b8', '4ed579aa-98b4-54d3-8bb5-9355e2ee9222', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4ed579aa-98b4-54d3-8bb5-9355e2ee9222';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c5369b8b-47c9-5cd1-98e9-1c6adc0251ec', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('c5369b8b-47c9-5cd1-98e9-1c6adc0251ec', '4ed579aa-98b4-54d3-8bb5-9355e2ee9222', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c5369b8b-47c9-5cd1-98e9-1c6adc0251ec';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('161fedac-9cfd-52ca-8d98-b850f42eb11d', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-15', '034b7061-2ebc-5282-abe8-12d7514673b8', '833e6e7b-8b96-52b0-9f40-4e2d630875e6', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '833e6e7b-8b96-52b0-9f40-4e2d630875e6';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('161fedac-9cfd-52ca-8d98-b850f42eb11d', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('161fedac-9cfd-52ca-8d98-b850f42eb11d', '833e6e7b-8b96-52b0-9f40-4e2d630875e6', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '161fedac-9cfd-52ca-8d98-b850f42eb11d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('34539e50-b75d-507a-826b-7b1853cba4ab', 'benchmark-funding-b2aaa506-217e-49cf-984f-076ce91d98b5-16', '034b7061-2ebc-5282-abe8-12d7514673b8', '054563f9-9e53-550b-aec1-87503bf93683', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '034b7061-2ebc-5282-abe8-12d7514673b8';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '054563f9-9e53-550b-aec1-87503bf93683';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('34539e50-b75d-507a-826b-7b1853cba4ab', '034b7061-2ebc-5282-abe8-12d7514673b8', -1000000000), ('34539e50-b75d-507a-826b-7b1853cba4ab', '054563f9-9e53-550b-aec1-87503bf93683', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '34539e50-b75d-507a-826b-7b1853cba4ab';
COMMIT;
