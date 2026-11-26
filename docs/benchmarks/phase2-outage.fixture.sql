-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('028ac307-b78c-5290-9c19-5ade19a29a7c', 'USER', 'ACTIVE', 'FIC'),
('0c273849-052b-5ac8-aac2-2da42fa84e96', 'USER', 'ACTIVE', 'FIC'),
('2ab68879-290f-5533-b3e2-198316f32390', 'USER', 'ACTIVE', 'FIC'),
('3a20f9cd-02f8-52d5-927d-b4fa0087ac9d', 'USER', 'ACTIVE', 'FIC'),
('3c94da59-833e-5329-ae54-e0ae16669f13', 'USER', 'ACTIVE', 'FIC'),
('3d4771e2-9c34-529c-aa5d-377c18c9975e', 'USER', 'ACTIVE', 'FIC'),
('4af767a9-14a4-546b-ad18-8bf2480954fa', 'USER', 'ACTIVE', 'FIC'),
('502bfbfc-3999-5185-b137-ef8c0b2001d3', 'USER', 'ACTIVE', 'FIC'),
('53bb9172-17f1-5782-91c5-d70bbab6505b', 'USER', 'ACTIVE', 'FIC'),
('6bbd77a1-8faf-54ab-bcf9-4ca73ddf1c4a', 'USER', 'ACTIVE', 'FIC'),
('76516eb5-a15f-5af0-942c-cc85e45367a0', 'USER', 'ACTIVE', 'FIC'),
('91db17a7-bfb3-50bd-8a14-ba84a9906551', 'USER', 'ACTIVE', 'FIC'),
('9fcb5cd5-305a-5676-ad70-c76304de3594', 'USER', 'ACTIVE', 'FIC'),
('aaeff1d2-cc66-5817-b659-e81a0d56bd97', 'ISSUANCE', 'ACTIVE', 'FIC'),
('b81e291d-b264-5d2e-959a-ad5055df5061', 'USER', 'ACTIVE', 'FIC'),
('ba44d9f4-6b60-54ff-87ab-758dab16c887', 'USER', 'ACTIVE', 'FIC'),
('bf5eecd9-80a9-5fbe-96ce-8bed433d5a9e', 'USER', 'ACTIVE', 'FIC'),
('c2ee92e6-7c06-5548-9d43-f5b55e2dc39f', 'USER', 'ACTIVE', 'FIC'),
('c8ae32e0-22e9-5921-b707-686f86002bd6', 'USER', 'ACTIVE', 'FIC'),
('d59b6481-9f31-5e9a-9c30-387072e9ca19', 'USER', 'ACTIVE', 'FIC'),
('e0f778ad-1f0c-599d-af5d-8f25be83281b', 'USER', 'ACTIVE', 'FIC'),
('e26b2f0f-84f5-56a3-ae4b-196f7714c119', 'USER', 'ACTIVE', 'FIC'),
('e390ac14-ba94-5a60-9dfb-5f26d1353be0', 'USER', 'ACTIVE', 'FIC'),
('eba217b0-2d11-5aba-8ee8-b913ce51b6f0', 'USER', 'ACTIVE', 'FIC'),
('ec210034-45a4-5e1e-8cd3-8b50d6ec396e', 'USER', 'ACTIVE', 'FIC'),
('f8e5cb6e-caf0-59d1-93a7-09362a9ea2ca', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('028ac307-b78c-5290-9c19-5ade19a29a7c', 0),
('0c273849-052b-5ac8-aac2-2da42fa84e96', 0),
('2ab68879-290f-5533-b3e2-198316f32390', 0),
('3a20f9cd-02f8-52d5-927d-b4fa0087ac9d', 0),
('3c94da59-833e-5329-ae54-e0ae16669f13', 0),
('3d4771e2-9c34-529c-aa5d-377c18c9975e', 0),
('4af767a9-14a4-546b-ad18-8bf2480954fa', 0),
('502bfbfc-3999-5185-b137-ef8c0b2001d3', 0),
('53bb9172-17f1-5782-91c5-d70bbab6505b', 0),
('6bbd77a1-8faf-54ab-bcf9-4ca73ddf1c4a', 0),
('76516eb5-a15f-5af0-942c-cc85e45367a0', 0),
('91db17a7-bfb3-50bd-8a14-ba84a9906551', 0),
('9fcb5cd5-305a-5676-ad70-c76304de3594', 0),
('aaeff1d2-cc66-5817-b659-e81a0d56bd97', 0),
('b81e291d-b264-5d2e-959a-ad5055df5061', 0),
('ba44d9f4-6b60-54ff-87ab-758dab16c887', 0),
('bf5eecd9-80a9-5fbe-96ce-8bed433d5a9e', 0),
('c2ee92e6-7c06-5548-9d43-f5b55e2dc39f', 0),
('c8ae32e0-22e9-5921-b707-686f86002bd6', 0),
('d59b6481-9f31-5e9a-9c30-387072e9ca19', 0),
('e0f778ad-1f0c-599d-af5d-8f25be83281b', 0),
('e26b2f0f-84f5-56a3-ae4b-196f7714c119', 0),
('e390ac14-ba94-5a60-9dfb-5f26d1353be0', 0),
('eba217b0-2d11-5aba-8ee8-b913ce51b6f0', 0),
('ec210034-45a4-5e1e-8cd3-8b50d6ec396e', 0),
('f8e5cb6e-caf0-59d1-93a7-09362a9ea2ca', 0);
SELECT account_id FROM balances WHERE account_id IN ('028ac307-b78c-5290-9c19-5ade19a29a7c','0c273849-052b-5ac8-aac2-2da42fa84e96','2ab68879-290f-5533-b3e2-198316f32390','3a20f9cd-02f8-52d5-927d-b4fa0087ac9d','3c94da59-833e-5329-ae54-e0ae16669f13','3d4771e2-9c34-529c-aa5d-377c18c9975e','4af767a9-14a4-546b-ad18-8bf2480954fa','502bfbfc-3999-5185-b137-ef8c0b2001d3','53bb9172-17f1-5782-91c5-d70bbab6505b','6bbd77a1-8faf-54ab-bcf9-4ca73ddf1c4a','76516eb5-a15f-5af0-942c-cc85e45367a0','91db17a7-bfb3-50bd-8a14-ba84a9906551','9fcb5cd5-305a-5676-ad70-c76304de3594','aaeff1d2-cc66-5817-b659-e81a0d56bd97','b81e291d-b264-5d2e-959a-ad5055df5061','ba44d9f4-6b60-54ff-87ab-758dab16c887','bf5eecd9-80a9-5fbe-96ce-8bed433d5a9e','c2ee92e6-7c06-5548-9d43-f5b55e2dc39f','c8ae32e0-22e9-5921-b707-686f86002bd6','d59b6481-9f31-5e9a-9c30-387072e9ca19','e0f778ad-1f0c-599d-af5d-8f25be83281b','e26b2f0f-84f5-56a3-ae4b-196f7714c119','e390ac14-ba94-5a60-9dfb-5f26d1353be0','eba217b0-2d11-5aba-8ee8-b913ce51b6f0','ec210034-45a4-5e1e-8cd3-8b50d6ec396e','f8e5cb6e-caf0-59d1-93a7-09362a9ea2ca') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d282afb3-ab7b-5824-8142-b62cc3eb82fb', 'benchmark-funding-8c6487f7-fb9d-4de1-aeb1-6257498588ab-0', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', 'eba217b0-2d11-5aba-8ee8-b913ce51b6f0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'aaeff1d2-cc66-5817-b659-e81a0d56bd97';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'eba217b0-2d11-5aba-8ee8-b913ce51b6f0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d282afb3-ab7b-5824-8142-b62cc3eb82fb', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', -1000000000), ('d282afb3-ab7b-5824-8142-b62cc3eb82fb', 'eba217b0-2d11-5aba-8ee8-b913ce51b6f0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd282afb3-ab7b-5824-8142-b62cc3eb82fb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('90ff04b1-adee-5524-9384-4d9dda2a216e', 'benchmark-funding-8c6487f7-fb9d-4de1-aeb1-6257498588ab-1', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', 'ec210034-45a4-5e1e-8cd3-8b50d6ec396e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'aaeff1d2-cc66-5817-b659-e81a0d56bd97';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ec210034-45a4-5e1e-8cd3-8b50d6ec396e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('90ff04b1-adee-5524-9384-4d9dda2a216e', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', -1000000000), ('90ff04b1-adee-5524-9384-4d9dda2a216e', 'ec210034-45a4-5e1e-8cd3-8b50d6ec396e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '90ff04b1-adee-5524-9384-4d9dda2a216e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f25a2d83-820b-5ae0-93d7-4439d35bf132', 'benchmark-funding-8c6487f7-fb9d-4de1-aeb1-6257498588ab-2', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', 'e0f778ad-1f0c-599d-af5d-8f25be83281b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'aaeff1d2-cc66-5817-b659-e81a0d56bd97';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e0f778ad-1f0c-599d-af5d-8f25be83281b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f25a2d83-820b-5ae0-93d7-4439d35bf132', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', -1000000000), ('f25a2d83-820b-5ae0-93d7-4439d35bf132', 'e0f778ad-1f0c-599d-af5d-8f25be83281b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f25a2d83-820b-5ae0-93d7-4439d35bf132';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c43a658a-9a0a-5fde-8cd0-6d9c0228ef1b', 'benchmark-funding-8c6487f7-fb9d-4de1-aeb1-6257498588ab-3', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', '53bb9172-17f1-5782-91c5-d70bbab6505b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'aaeff1d2-cc66-5817-b659-e81a0d56bd97';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '53bb9172-17f1-5782-91c5-d70bbab6505b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c43a658a-9a0a-5fde-8cd0-6d9c0228ef1b', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', -1000000000), ('c43a658a-9a0a-5fde-8cd0-6d9c0228ef1b', '53bb9172-17f1-5782-91c5-d70bbab6505b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c43a658a-9a0a-5fde-8cd0-6d9c0228ef1b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('981cebc4-563b-5bdc-862e-7ad8e8512e6d', 'benchmark-funding-8c6487f7-fb9d-4de1-aeb1-6257498588ab-4', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', '3c94da59-833e-5329-ae54-e0ae16669f13', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'aaeff1d2-cc66-5817-b659-e81a0d56bd97';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3c94da59-833e-5329-ae54-e0ae16669f13';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('981cebc4-563b-5bdc-862e-7ad8e8512e6d', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', -1000000000), ('981cebc4-563b-5bdc-862e-7ad8e8512e6d', '3c94da59-833e-5329-ae54-e0ae16669f13', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '981cebc4-563b-5bdc-862e-7ad8e8512e6d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b7d1eb68-205d-5487-9186-0019aa1ee42d', 'benchmark-funding-8c6487f7-fb9d-4de1-aeb1-6257498588ab-5', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', 'c2ee92e6-7c06-5548-9d43-f5b55e2dc39f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'aaeff1d2-cc66-5817-b659-e81a0d56bd97';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c2ee92e6-7c06-5548-9d43-f5b55e2dc39f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b7d1eb68-205d-5487-9186-0019aa1ee42d', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', -1000000000), ('b7d1eb68-205d-5487-9186-0019aa1ee42d', 'c2ee92e6-7c06-5548-9d43-f5b55e2dc39f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b7d1eb68-205d-5487-9186-0019aa1ee42d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5a558cb1-4c11-5b33-a815-4ef1d20494f0', 'benchmark-funding-8c6487f7-fb9d-4de1-aeb1-6257498588ab-6', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', 'd59b6481-9f31-5e9a-9c30-387072e9ca19', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'aaeff1d2-cc66-5817-b659-e81a0d56bd97';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd59b6481-9f31-5e9a-9c30-387072e9ca19';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5a558cb1-4c11-5b33-a815-4ef1d20494f0', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', -1000000000), ('5a558cb1-4c11-5b33-a815-4ef1d20494f0', 'd59b6481-9f31-5e9a-9c30-387072e9ca19', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5a558cb1-4c11-5b33-a815-4ef1d20494f0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0f2fc59b-a69d-55b7-80b9-37c01ddbcf01', 'benchmark-funding-8c6487f7-fb9d-4de1-aeb1-6257498588ab-7', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', '2ab68879-290f-5533-b3e2-198316f32390', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'aaeff1d2-cc66-5817-b659-e81a0d56bd97';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2ab68879-290f-5533-b3e2-198316f32390';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0f2fc59b-a69d-55b7-80b9-37c01ddbcf01', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', -1000000000), ('0f2fc59b-a69d-55b7-80b9-37c01ddbcf01', '2ab68879-290f-5533-b3e2-198316f32390', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0f2fc59b-a69d-55b7-80b9-37c01ddbcf01';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4ab20150-1db8-53fb-95a6-ab78ebf29370', 'benchmark-funding-8c6487f7-fb9d-4de1-aeb1-6257498588ab-8', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', '9fcb5cd5-305a-5676-ad70-c76304de3594', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'aaeff1d2-cc66-5817-b659-e81a0d56bd97';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9fcb5cd5-305a-5676-ad70-c76304de3594';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4ab20150-1db8-53fb-95a6-ab78ebf29370', 'aaeff1d2-cc66-5817-b659-e81a0d56bd97', -1000000000), ('4ab20150-1db8-53fb-95a6-ab78ebf29370', '9fcb5cd5-305a-5676-ad70-c76304de3594', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4ab20150-1db8-53fb-95a6-ab78ebf29370';
COMMIT;
