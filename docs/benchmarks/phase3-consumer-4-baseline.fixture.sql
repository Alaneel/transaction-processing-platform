-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('0ff113f5-33a7-54b7-b132-0b91ae9df789', 'ISSUANCE', 'ACTIVE', 'FIC'),
('1b93f222-4dbe-5237-be00-b90df72b585f', 'USER', 'ACTIVE', 'FIC'),
('236703ff-e8fd-5b16-8f1b-b7698e33ff61', 'USER', 'ACTIVE', 'FIC'),
('2850ac50-9d4e-5a38-b508-b4e1c648d6e8', 'USER', 'ACTIVE', 'FIC'),
('3231a62e-a091-52e2-b844-0a2d82417f7d', 'USER', 'ACTIVE', 'FIC'),
('4884311b-79fa-5916-aec5-22ab0abebd25', 'USER', 'ACTIVE', 'FIC'),
('4bd9e172-44c5-5ba7-8d62-d3cba7132d7a', 'USER', 'ACTIVE', 'FIC'),
('5104aa37-1df9-591c-84ab-c093905cc080', 'USER', 'ACTIVE', 'FIC'),
('55818629-3ed1-5b4d-aeba-66da2eb1b9ef', 'USER', 'ACTIVE', 'FIC'),
('606772f8-0692-57a9-ab10-73075809a7c4', 'USER', 'ACTIVE', 'FIC'),
('6516da9e-e205-5875-80ff-49596127333e', 'USER', 'ACTIVE', 'FIC'),
('657260af-291e-5998-a845-b10fd023a81f', 'USER', 'ACTIVE', 'FIC'),
('6772f4dd-3e3e-50a1-8af3-b1062536f90b', 'USER', 'ACTIVE', 'FIC'),
('89671998-f37a-5e77-bcfb-3693dc9cdc33', 'USER', 'ACTIVE', 'FIC'),
('8f87bbae-3e68-5a82-a7eb-52395cd5d6d5', 'USER', 'ACTIVE', 'FIC'),
('94b674b2-4002-52fb-9551-39c003f40c2b', 'USER', 'ACTIVE', 'FIC'),
('af469436-703d-5ef8-a1df-660bf5c78f32', 'USER', 'ACTIVE', 'FIC'),
('b107ed9d-1e20-5683-aae2-c8de9d0fc367', 'USER', 'ACTIVE', 'FIC'),
('b2af6138-2e3e-5917-a544-5333335e426f', 'USER', 'ACTIVE', 'FIC'),
('bb8684e6-02d3-557f-9f9b-728d360bd69b', 'USER', 'ACTIVE', 'FIC'),
('bf5e24ce-a7e7-5b38-b19c-6e32ac9d88af', 'USER', 'ACTIVE', 'FIC'),
('c32c7ce1-3968-50e8-b187-061d52e17e77', 'USER', 'ACTIVE', 'FIC'),
('db4bf26a-5b0b-57ba-a524-fbae8b5b4460', 'USER', 'ACTIVE', 'FIC'),
('ddfbb725-40b5-573b-9b00-81997f65e628', 'USER', 'ACTIVE', 'FIC'),
('f5930435-6f34-5b43-b794-6b2316298baf', 'USER', 'ACTIVE', 'FIC'),
('f6638dd2-b86b-5865-bbfd-5c5717cddcf2', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('0ff113f5-33a7-54b7-b132-0b91ae9df789', 0),
('1b93f222-4dbe-5237-be00-b90df72b585f', 0),
('236703ff-e8fd-5b16-8f1b-b7698e33ff61', 0),
('2850ac50-9d4e-5a38-b508-b4e1c648d6e8', 0),
('3231a62e-a091-52e2-b844-0a2d82417f7d', 0),
('4884311b-79fa-5916-aec5-22ab0abebd25', 0),
('4bd9e172-44c5-5ba7-8d62-d3cba7132d7a', 0),
('5104aa37-1df9-591c-84ab-c093905cc080', 0),
('55818629-3ed1-5b4d-aeba-66da2eb1b9ef', 0),
('606772f8-0692-57a9-ab10-73075809a7c4', 0),
('6516da9e-e205-5875-80ff-49596127333e', 0),
('657260af-291e-5998-a845-b10fd023a81f', 0),
('6772f4dd-3e3e-50a1-8af3-b1062536f90b', 0),
('89671998-f37a-5e77-bcfb-3693dc9cdc33', 0),
('8f87bbae-3e68-5a82-a7eb-52395cd5d6d5', 0),
('94b674b2-4002-52fb-9551-39c003f40c2b', 0),
('af469436-703d-5ef8-a1df-660bf5c78f32', 0),
('b107ed9d-1e20-5683-aae2-c8de9d0fc367', 0),
('b2af6138-2e3e-5917-a544-5333335e426f', 0),
('bb8684e6-02d3-557f-9f9b-728d360bd69b', 0),
('bf5e24ce-a7e7-5b38-b19c-6e32ac9d88af', 0),
('c32c7ce1-3968-50e8-b187-061d52e17e77', 0),
('db4bf26a-5b0b-57ba-a524-fbae8b5b4460', 0),
('ddfbb725-40b5-573b-9b00-81997f65e628', 0),
('f5930435-6f34-5b43-b794-6b2316298baf', 0),
('f6638dd2-b86b-5865-bbfd-5c5717cddcf2', 0);
SELECT account_id FROM balances WHERE account_id IN ('0ff113f5-33a7-54b7-b132-0b91ae9df789','1b93f222-4dbe-5237-be00-b90df72b585f','236703ff-e8fd-5b16-8f1b-b7698e33ff61','2850ac50-9d4e-5a38-b508-b4e1c648d6e8','3231a62e-a091-52e2-b844-0a2d82417f7d','4884311b-79fa-5916-aec5-22ab0abebd25','4bd9e172-44c5-5ba7-8d62-d3cba7132d7a','5104aa37-1df9-591c-84ab-c093905cc080','55818629-3ed1-5b4d-aeba-66da2eb1b9ef','606772f8-0692-57a9-ab10-73075809a7c4','6516da9e-e205-5875-80ff-49596127333e','657260af-291e-5998-a845-b10fd023a81f','6772f4dd-3e3e-50a1-8af3-b1062536f90b','89671998-f37a-5e77-bcfb-3693dc9cdc33','8f87bbae-3e68-5a82-a7eb-52395cd5d6d5','94b674b2-4002-52fb-9551-39c003f40c2b','af469436-703d-5ef8-a1df-660bf5c78f32','b107ed9d-1e20-5683-aae2-c8de9d0fc367','b2af6138-2e3e-5917-a544-5333335e426f','bb8684e6-02d3-557f-9f9b-728d360bd69b','bf5e24ce-a7e7-5b38-b19c-6e32ac9d88af','c32c7ce1-3968-50e8-b187-061d52e17e77','db4bf26a-5b0b-57ba-a524-fbae8b5b4460','ddfbb725-40b5-573b-9b00-81997f65e628','f5930435-6f34-5b43-b794-6b2316298baf','f6638dd2-b86b-5865-bbfd-5c5717cddcf2') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d0458c10-c65a-59fd-bf3d-3c2ee8b4dfd6', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-0', '0ff113f5-33a7-54b7-b132-0b91ae9df789', '1b93f222-4dbe-5237-be00-b90df72b585f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1b93f222-4dbe-5237-be00-b90df72b585f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d0458c10-c65a-59fd-bf3d-3c2ee8b4dfd6', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('d0458c10-c65a-59fd-bf3d-3c2ee8b4dfd6', '1b93f222-4dbe-5237-be00-b90df72b585f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd0458c10-c65a-59fd-bf3d-3c2ee8b4dfd6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5061ac85-c386-5af0-8fdb-28917c452d0e', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-1', '0ff113f5-33a7-54b7-b132-0b91ae9df789', '5104aa37-1df9-591c-84ab-c093905cc080', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5104aa37-1df9-591c-84ab-c093905cc080';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5061ac85-c386-5af0-8fdb-28917c452d0e', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('5061ac85-c386-5af0-8fdb-28917c452d0e', '5104aa37-1df9-591c-84ab-c093905cc080', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5061ac85-c386-5af0-8fdb-28917c452d0e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('79a4283d-f6c5-53fe-8082-07970dbfa934', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-2', '0ff113f5-33a7-54b7-b132-0b91ae9df789', '6772f4dd-3e3e-50a1-8af3-b1062536f90b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6772f4dd-3e3e-50a1-8af3-b1062536f90b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('79a4283d-f6c5-53fe-8082-07970dbfa934', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('79a4283d-f6c5-53fe-8082-07970dbfa934', '6772f4dd-3e3e-50a1-8af3-b1062536f90b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '79a4283d-f6c5-53fe-8082-07970dbfa934';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ec376c0c-0b6b-5cc5-b0a5-6a5eb33bf94a', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-3', '0ff113f5-33a7-54b7-b132-0b91ae9df789', 'af469436-703d-5ef8-a1df-660bf5c78f32', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'af469436-703d-5ef8-a1df-660bf5c78f32';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ec376c0c-0b6b-5cc5-b0a5-6a5eb33bf94a', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('ec376c0c-0b6b-5cc5-b0a5-6a5eb33bf94a', 'af469436-703d-5ef8-a1df-660bf5c78f32', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ec376c0c-0b6b-5cc5-b0a5-6a5eb33bf94a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('53e2168b-6a8e-5a8c-b92c-0cedcbd21139', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-4', '0ff113f5-33a7-54b7-b132-0b91ae9df789', '2850ac50-9d4e-5a38-b508-b4e1c648d6e8', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2850ac50-9d4e-5a38-b508-b4e1c648d6e8';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('53e2168b-6a8e-5a8c-b92c-0cedcbd21139', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('53e2168b-6a8e-5a8c-b92c-0cedcbd21139', '2850ac50-9d4e-5a38-b508-b4e1c648d6e8', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '53e2168b-6a8e-5a8c-b92c-0cedcbd21139';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5f98b24c-7534-56c5-be2b-ad506a2ebed9', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-5', '0ff113f5-33a7-54b7-b132-0b91ae9df789', 'c32c7ce1-3968-50e8-b187-061d52e17e77', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c32c7ce1-3968-50e8-b187-061d52e17e77';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5f98b24c-7534-56c5-be2b-ad506a2ebed9', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('5f98b24c-7534-56c5-be2b-ad506a2ebed9', 'c32c7ce1-3968-50e8-b187-061d52e17e77', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5f98b24c-7534-56c5-be2b-ad506a2ebed9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c58288cf-35b9-5f38-9211-13764b47e8fb', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-6', '0ff113f5-33a7-54b7-b132-0b91ae9df789', 'ddfbb725-40b5-573b-9b00-81997f65e628', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ddfbb725-40b5-573b-9b00-81997f65e628';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c58288cf-35b9-5f38-9211-13764b47e8fb', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('c58288cf-35b9-5f38-9211-13764b47e8fb', 'ddfbb725-40b5-573b-9b00-81997f65e628', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c58288cf-35b9-5f38-9211-13764b47e8fb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5eb0aca6-06d2-5c4d-ad8f-94c895cc526c', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-7', '0ff113f5-33a7-54b7-b132-0b91ae9df789', '3231a62e-a091-52e2-b844-0a2d82417f7d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3231a62e-a091-52e2-b844-0a2d82417f7d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5eb0aca6-06d2-5c4d-ad8f-94c895cc526c', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('5eb0aca6-06d2-5c4d-ad8f-94c895cc526c', '3231a62e-a091-52e2-b844-0a2d82417f7d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5eb0aca6-06d2-5c4d-ad8f-94c895cc526c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b7006804-1113-53c7-86b4-93cde55fc37a', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-8', '0ff113f5-33a7-54b7-b132-0b91ae9df789', '94b674b2-4002-52fb-9551-39c003f40c2b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '94b674b2-4002-52fb-9551-39c003f40c2b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b7006804-1113-53c7-86b4-93cde55fc37a', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('b7006804-1113-53c7-86b4-93cde55fc37a', '94b674b2-4002-52fb-9551-39c003f40c2b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b7006804-1113-53c7-86b4-93cde55fc37a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a3d11a3b-44ab-56cf-b099-736f15198dc6', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-9', '0ff113f5-33a7-54b7-b132-0b91ae9df789', '4bd9e172-44c5-5ba7-8d62-d3cba7132d7a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4bd9e172-44c5-5ba7-8d62-d3cba7132d7a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a3d11a3b-44ab-56cf-b099-736f15198dc6', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('a3d11a3b-44ab-56cf-b099-736f15198dc6', '4bd9e172-44c5-5ba7-8d62-d3cba7132d7a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a3d11a3b-44ab-56cf-b099-736f15198dc6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a6f43198-7de4-5d3e-a727-dadf39f3e91f', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-10', '0ff113f5-33a7-54b7-b132-0b91ae9df789', 'bf5e24ce-a7e7-5b38-b19c-6e32ac9d88af', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'bf5e24ce-a7e7-5b38-b19c-6e32ac9d88af';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a6f43198-7de4-5d3e-a727-dadf39f3e91f', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('a6f43198-7de4-5d3e-a727-dadf39f3e91f', 'bf5e24ce-a7e7-5b38-b19c-6e32ac9d88af', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a6f43198-7de4-5d3e-a727-dadf39f3e91f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c64cd1e6-ab87-5187-8b62-600f4366040d', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-11', '0ff113f5-33a7-54b7-b132-0b91ae9df789', '8f87bbae-3e68-5a82-a7eb-52395cd5d6d5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8f87bbae-3e68-5a82-a7eb-52395cd5d6d5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c64cd1e6-ab87-5187-8b62-600f4366040d', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('c64cd1e6-ab87-5187-8b62-600f4366040d', '8f87bbae-3e68-5a82-a7eb-52395cd5d6d5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c64cd1e6-ab87-5187-8b62-600f4366040d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('da6705c9-bd93-5fd2-9380-c3413404ecc3', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-12', '0ff113f5-33a7-54b7-b132-0b91ae9df789', '4884311b-79fa-5916-aec5-22ab0abebd25', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4884311b-79fa-5916-aec5-22ab0abebd25';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('da6705c9-bd93-5fd2-9380-c3413404ecc3', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('da6705c9-bd93-5fd2-9380-c3413404ecc3', '4884311b-79fa-5916-aec5-22ab0abebd25', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'da6705c9-bd93-5fd2-9380-c3413404ecc3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f851bf90-6f75-587d-b5e3-55b7f4f02b8f', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-13', '0ff113f5-33a7-54b7-b132-0b91ae9df789', '606772f8-0692-57a9-ab10-73075809a7c4', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '606772f8-0692-57a9-ab10-73075809a7c4';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f851bf90-6f75-587d-b5e3-55b7f4f02b8f', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('f851bf90-6f75-587d-b5e3-55b7f4f02b8f', '606772f8-0692-57a9-ab10-73075809a7c4', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f851bf90-6f75-587d-b5e3-55b7f4f02b8f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9d536d69-33fe-51e1-9516-3a165ef79b7a', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-14', '0ff113f5-33a7-54b7-b132-0b91ae9df789', '657260af-291e-5998-a845-b10fd023a81f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '657260af-291e-5998-a845-b10fd023a81f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9d536d69-33fe-51e1-9516-3a165ef79b7a', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('9d536d69-33fe-51e1-9516-3a165ef79b7a', '657260af-291e-5998-a845-b10fd023a81f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9d536d69-33fe-51e1-9516-3a165ef79b7a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5fdf318c-8fe9-505a-b3cf-cb18cc58f978', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-15', '0ff113f5-33a7-54b7-b132-0b91ae9df789', '236703ff-e8fd-5b16-8f1b-b7698e33ff61', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '236703ff-e8fd-5b16-8f1b-b7698e33ff61';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5fdf318c-8fe9-505a-b3cf-cb18cc58f978', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('5fdf318c-8fe9-505a-b3cf-cb18cc58f978', '236703ff-e8fd-5b16-8f1b-b7698e33ff61', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5fdf318c-8fe9-505a-b3cf-cb18cc58f978';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7430c770-39f5-5a29-abad-a81baebf767a', 'benchmark-funding-639574d6-9bd5-462b-8cd1-440d30acc545-16', '0ff113f5-33a7-54b7-b132-0b91ae9df789', 'f5930435-6f34-5b43-b794-6b2316298baf', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0ff113f5-33a7-54b7-b132-0b91ae9df789';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f5930435-6f34-5b43-b794-6b2316298baf';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7430c770-39f5-5a29-abad-a81baebf767a', '0ff113f5-33a7-54b7-b132-0b91ae9df789', -1000000000), ('7430c770-39f5-5a29-abad-a81baebf767a', 'f5930435-6f34-5b43-b794-6b2316298baf', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7430c770-39f5-5a29-abad-a81baebf767a';
COMMIT;
