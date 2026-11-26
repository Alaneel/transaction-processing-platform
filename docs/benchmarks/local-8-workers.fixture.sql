-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('1d7c1e51-f543-5acc-9369-9f25c7380a1b', 'USER', 'ACTIVE', 'FIC'),
('1f6257aa-fc11-5e2f-9493-ed4d2059fad8', 'USER', 'ACTIVE', 'FIC'),
('2336a62f-25de-57b1-b84e-69a340224045', 'ISSUANCE', 'ACTIVE', 'FIC'),
('24a78ae9-6ad8-50d9-973b-06410d894618', 'USER', 'ACTIVE', 'FIC'),
('2d9446f3-c5f8-5ab6-963d-6ecd8c3068ee', 'USER', 'ACTIVE', 'FIC'),
('39fd6003-21b6-5b3e-842e-187e92a6ced7', 'USER', 'ACTIVE', 'FIC'),
('3b2c0f3e-b72a-5010-b6d1-5d7429b68217', 'USER', 'ACTIVE', 'FIC'),
('434b1d08-e228-5008-96e1-338731b59a32', 'USER', 'ACTIVE', 'FIC'),
('4ee653dc-a6cb-5fa2-8f02-3dcdeb3b857d', 'USER', 'ACTIVE', 'FIC'),
('54d81459-58f0-59a3-83c6-36fc07d8a523', 'USER', 'ACTIVE', 'FIC'),
('5512dc46-d521-5388-b728-025d9a7edc6c', 'USER', 'ACTIVE', 'FIC'),
('606d39d9-c57c-5d98-b81c-2d54ea776c78', 'USER', 'ACTIVE', 'FIC'),
('65f3ff15-ddc9-5b71-9c0c-52ffc2868d14', 'USER', 'ACTIVE', 'FIC'),
('7b093a65-eab5-5ec3-87e0-6415c67ffbff', 'USER', 'ACTIVE', 'FIC'),
('7d13140b-a42f-541d-81e9-49a7fd617ac9', 'USER', 'ACTIVE', 'FIC'),
('84a04028-f688-5a00-b1d4-5fbb1af37184', 'USER', 'ACTIVE', 'FIC'),
('90603403-0b54-5ad2-885c-552504a4785a', 'USER', 'ACTIVE', 'FIC'),
('97983a14-7fa3-5aa6-b943-0d121c4ff9a6', 'USER', 'ACTIVE', 'FIC'),
('abebb4c3-9b62-5949-b7a9-7dd7e55f0519', 'USER', 'ACTIVE', 'FIC'),
('b29615dc-d792-56e9-9987-3baff55ea3bc', 'USER', 'ACTIVE', 'FIC'),
('bf13cc5c-2bc3-5cb5-9149-233f3df3dd6b', 'USER', 'ACTIVE', 'FIC'),
('c4340514-4e14-513c-bc70-9fef835bc053', 'USER', 'ACTIVE', 'FIC'),
('c4c1478e-e0b9-5523-b8bf-861e5167f9d2', 'USER', 'ACTIVE', 'FIC'),
('c7f61759-0b88-5777-a93f-f5ade0be4d53', 'USER', 'ACTIVE', 'FIC'),
('e884657a-fb5a-590f-8161-702e66d5f236', 'USER', 'ACTIVE', 'FIC'),
('ea1b83f8-6fa7-50da-97dd-ad86d505c650', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('1d7c1e51-f543-5acc-9369-9f25c7380a1b', 0),
('1f6257aa-fc11-5e2f-9493-ed4d2059fad8', 0),
('2336a62f-25de-57b1-b84e-69a340224045', 0),
('24a78ae9-6ad8-50d9-973b-06410d894618', 0),
('2d9446f3-c5f8-5ab6-963d-6ecd8c3068ee', 0),
('39fd6003-21b6-5b3e-842e-187e92a6ced7', 0),
('3b2c0f3e-b72a-5010-b6d1-5d7429b68217', 0),
('434b1d08-e228-5008-96e1-338731b59a32', 0),
('4ee653dc-a6cb-5fa2-8f02-3dcdeb3b857d', 0),
('54d81459-58f0-59a3-83c6-36fc07d8a523', 0),
('5512dc46-d521-5388-b728-025d9a7edc6c', 0),
('606d39d9-c57c-5d98-b81c-2d54ea776c78', 0),
('65f3ff15-ddc9-5b71-9c0c-52ffc2868d14', 0),
('7b093a65-eab5-5ec3-87e0-6415c67ffbff', 0),
('7d13140b-a42f-541d-81e9-49a7fd617ac9', 0),
('84a04028-f688-5a00-b1d4-5fbb1af37184', 0),
('90603403-0b54-5ad2-885c-552504a4785a', 0),
('97983a14-7fa3-5aa6-b943-0d121c4ff9a6', 0),
('abebb4c3-9b62-5949-b7a9-7dd7e55f0519', 0),
('b29615dc-d792-56e9-9987-3baff55ea3bc', 0),
('bf13cc5c-2bc3-5cb5-9149-233f3df3dd6b', 0),
('c4340514-4e14-513c-bc70-9fef835bc053', 0),
('c4c1478e-e0b9-5523-b8bf-861e5167f9d2', 0),
('c7f61759-0b88-5777-a93f-f5ade0be4d53', 0),
('e884657a-fb5a-590f-8161-702e66d5f236', 0),
('ea1b83f8-6fa7-50da-97dd-ad86d505c650', 0);
SELECT account_id FROM balances WHERE account_id IN ('1d7c1e51-f543-5acc-9369-9f25c7380a1b','1f6257aa-fc11-5e2f-9493-ed4d2059fad8','2336a62f-25de-57b1-b84e-69a340224045','24a78ae9-6ad8-50d9-973b-06410d894618','2d9446f3-c5f8-5ab6-963d-6ecd8c3068ee','39fd6003-21b6-5b3e-842e-187e92a6ced7','3b2c0f3e-b72a-5010-b6d1-5d7429b68217','434b1d08-e228-5008-96e1-338731b59a32','4ee653dc-a6cb-5fa2-8f02-3dcdeb3b857d','54d81459-58f0-59a3-83c6-36fc07d8a523','5512dc46-d521-5388-b728-025d9a7edc6c','606d39d9-c57c-5d98-b81c-2d54ea776c78','65f3ff15-ddc9-5b71-9c0c-52ffc2868d14','7b093a65-eab5-5ec3-87e0-6415c67ffbff','7d13140b-a42f-541d-81e9-49a7fd617ac9','84a04028-f688-5a00-b1d4-5fbb1af37184','90603403-0b54-5ad2-885c-552504a4785a','97983a14-7fa3-5aa6-b943-0d121c4ff9a6','abebb4c3-9b62-5949-b7a9-7dd7e55f0519','b29615dc-d792-56e9-9987-3baff55ea3bc','bf13cc5c-2bc3-5cb5-9149-233f3df3dd6b','c4340514-4e14-513c-bc70-9fef835bc053','c4c1478e-e0b9-5523-b8bf-861e5167f9d2','c7f61759-0b88-5777-a93f-f5ade0be4d53','e884657a-fb5a-590f-8161-702e66d5f236','ea1b83f8-6fa7-50da-97dd-ad86d505c650') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7c043840-eb34-5520-9c34-3ba364bfd3fb', 'benchmark-funding-0c23a429-6392-489f-a255-181b521ba3d7-0', '2336a62f-25de-57b1-b84e-69a340224045', 'b29615dc-d792-56e9-9987-3baff55ea3bc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2336a62f-25de-57b1-b84e-69a340224045';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b29615dc-d792-56e9-9987-3baff55ea3bc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7c043840-eb34-5520-9c34-3ba364bfd3fb', '2336a62f-25de-57b1-b84e-69a340224045', -1000000000), ('7c043840-eb34-5520-9c34-3ba364bfd3fb', 'b29615dc-d792-56e9-9987-3baff55ea3bc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7c043840-eb34-5520-9c34-3ba364bfd3fb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('760ed9b9-02d4-5347-989e-7cd68051469b', 'benchmark-funding-0c23a429-6392-489f-a255-181b521ba3d7-1', '2336a62f-25de-57b1-b84e-69a340224045', '39fd6003-21b6-5b3e-842e-187e92a6ced7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2336a62f-25de-57b1-b84e-69a340224045';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '39fd6003-21b6-5b3e-842e-187e92a6ced7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('760ed9b9-02d4-5347-989e-7cd68051469b', '2336a62f-25de-57b1-b84e-69a340224045', -1000000000), ('760ed9b9-02d4-5347-989e-7cd68051469b', '39fd6003-21b6-5b3e-842e-187e92a6ced7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '760ed9b9-02d4-5347-989e-7cd68051469b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('60a85de4-2a13-5b30-b0e2-13240bb91355', 'benchmark-funding-0c23a429-6392-489f-a255-181b521ba3d7-2', '2336a62f-25de-57b1-b84e-69a340224045', '4ee653dc-a6cb-5fa2-8f02-3dcdeb3b857d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2336a62f-25de-57b1-b84e-69a340224045';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4ee653dc-a6cb-5fa2-8f02-3dcdeb3b857d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('60a85de4-2a13-5b30-b0e2-13240bb91355', '2336a62f-25de-57b1-b84e-69a340224045', -1000000000), ('60a85de4-2a13-5b30-b0e2-13240bb91355', '4ee653dc-a6cb-5fa2-8f02-3dcdeb3b857d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '60a85de4-2a13-5b30-b0e2-13240bb91355';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d71f2bb2-6ef2-5585-9acb-95af4271ba4f', 'benchmark-funding-0c23a429-6392-489f-a255-181b521ba3d7-3', '2336a62f-25de-57b1-b84e-69a340224045', '5512dc46-d521-5388-b728-025d9a7edc6c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2336a62f-25de-57b1-b84e-69a340224045';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5512dc46-d521-5388-b728-025d9a7edc6c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d71f2bb2-6ef2-5585-9acb-95af4271ba4f', '2336a62f-25de-57b1-b84e-69a340224045', -1000000000), ('d71f2bb2-6ef2-5585-9acb-95af4271ba4f', '5512dc46-d521-5388-b728-025d9a7edc6c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd71f2bb2-6ef2-5585-9acb-95af4271ba4f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c059516f-9217-5566-abb6-d0c8d0930a59', 'benchmark-funding-0c23a429-6392-489f-a255-181b521ba3d7-4', '2336a62f-25de-57b1-b84e-69a340224045', 'abebb4c3-9b62-5949-b7a9-7dd7e55f0519', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2336a62f-25de-57b1-b84e-69a340224045';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'abebb4c3-9b62-5949-b7a9-7dd7e55f0519';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c059516f-9217-5566-abb6-d0c8d0930a59', '2336a62f-25de-57b1-b84e-69a340224045', -1000000000), ('c059516f-9217-5566-abb6-d0c8d0930a59', 'abebb4c3-9b62-5949-b7a9-7dd7e55f0519', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c059516f-9217-5566-abb6-d0c8d0930a59';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c03c3b29-038d-58bc-b58d-042dd71ca8c8', 'benchmark-funding-0c23a429-6392-489f-a255-181b521ba3d7-5', '2336a62f-25de-57b1-b84e-69a340224045', '90603403-0b54-5ad2-885c-552504a4785a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2336a62f-25de-57b1-b84e-69a340224045';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '90603403-0b54-5ad2-885c-552504a4785a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c03c3b29-038d-58bc-b58d-042dd71ca8c8', '2336a62f-25de-57b1-b84e-69a340224045', -1000000000), ('c03c3b29-038d-58bc-b58d-042dd71ca8c8', '90603403-0b54-5ad2-885c-552504a4785a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c03c3b29-038d-58bc-b58d-042dd71ca8c8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('bd15d961-856c-5c68-b151-c9807edb2999', 'benchmark-funding-0c23a429-6392-489f-a255-181b521ba3d7-6', '2336a62f-25de-57b1-b84e-69a340224045', '606d39d9-c57c-5d98-b81c-2d54ea776c78', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2336a62f-25de-57b1-b84e-69a340224045';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '606d39d9-c57c-5d98-b81c-2d54ea776c78';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('bd15d961-856c-5c68-b151-c9807edb2999', '2336a62f-25de-57b1-b84e-69a340224045', -1000000000), ('bd15d961-856c-5c68-b151-c9807edb2999', '606d39d9-c57c-5d98-b81c-2d54ea776c78', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'bd15d961-856c-5c68-b151-c9807edb2999';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a034acb1-235d-5d31-9870-a1c8eb064887', 'benchmark-funding-0c23a429-6392-489f-a255-181b521ba3d7-7', '2336a62f-25de-57b1-b84e-69a340224045', '1d7c1e51-f543-5acc-9369-9f25c7380a1b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2336a62f-25de-57b1-b84e-69a340224045';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1d7c1e51-f543-5acc-9369-9f25c7380a1b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a034acb1-235d-5d31-9870-a1c8eb064887', '2336a62f-25de-57b1-b84e-69a340224045', -1000000000), ('a034acb1-235d-5d31-9870-a1c8eb064887', '1d7c1e51-f543-5acc-9369-9f25c7380a1b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a034acb1-235d-5d31-9870-a1c8eb064887';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('46538d75-fb34-564c-b519-36581d0a15ad', 'benchmark-funding-0c23a429-6392-489f-a255-181b521ba3d7-8', '2336a62f-25de-57b1-b84e-69a340224045', '3b2c0f3e-b72a-5010-b6d1-5d7429b68217', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2336a62f-25de-57b1-b84e-69a340224045';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3b2c0f3e-b72a-5010-b6d1-5d7429b68217';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('46538d75-fb34-564c-b519-36581d0a15ad', '2336a62f-25de-57b1-b84e-69a340224045', -1000000000), ('46538d75-fb34-564c-b519-36581d0a15ad', '3b2c0f3e-b72a-5010-b6d1-5d7429b68217', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '46538d75-fb34-564c-b519-36581d0a15ad';
COMMIT;
