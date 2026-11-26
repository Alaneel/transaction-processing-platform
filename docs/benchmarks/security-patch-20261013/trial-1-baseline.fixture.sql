-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('052dae7a-c03c-5eee-973b-64b770401969', 'USER', 'ACTIVE', 'FIC'),
('0c5e5563-00e3-5848-8da3-71931e1e494f', 'USER', 'ACTIVE', 'FIC'),
('261ccf5f-bb15-5cfd-9c50-657a7bef5c6b', 'USER', 'ACTIVE', 'FIC'),
('3cd0f284-e885-5320-892c-63feed32ec7f', 'USER', 'ACTIVE', 'FIC'),
('3d697077-7390-57de-815d-3e767845574f', 'USER', 'ACTIVE', 'FIC'),
('40d35a9e-1e45-5ab5-8d70-54f47d066d42', 'USER', 'ACTIVE', 'FIC'),
('4f2422a2-408f-53ef-a247-95ddfc50bc96', 'USER', 'ACTIVE', 'FIC'),
('604302f3-762d-56e6-afd9-323269d9fe59', 'USER', 'ACTIVE', 'FIC'),
('614522bf-6bdc-52ee-8a6c-8e5a1350f2a4', 'USER', 'ACTIVE', 'FIC'),
('6a0e1dab-40b4-5586-9c80-06218f7d5b84', 'USER', 'ACTIVE', 'FIC'),
('6e360b80-9bc9-589c-8ce6-94568a6925df', 'USER', 'ACTIVE', 'FIC'),
('70b0276a-2341-5d07-8b00-0ce82b917cb5', 'USER', 'ACTIVE', 'FIC'),
('77952a7c-c6a4-52e2-a7da-c472eb68fb38', 'USER', 'ACTIVE', 'FIC'),
('862aa3ff-2ad5-5226-9b4f-c25d1fd84324', 'USER', 'ACTIVE', 'FIC'),
('9460e697-eb73-5f3f-b88a-b023ca57ae79', 'USER', 'ACTIVE', 'FIC'),
('a198114b-2444-5e48-952d-971b522763c1', 'USER', 'ACTIVE', 'FIC'),
('a6353ecc-0723-5507-a193-632acbbced6b', 'USER', 'ACTIVE', 'FIC'),
('b18caf49-21b7-5ae5-8107-2acc3b4db3f5', 'USER', 'ACTIVE', 'FIC'),
('c9e2280d-4577-500c-adb2-a47274409a4b', 'ISSUANCE', 'ACTIVE', 'FIC'),
('d177e97c-621a-5bff-bd91-f97cf90c1537', 'USER', 'ACTIVE', 'FIC'),
('dcb38a01-1076-5ae2-84b2-0bfca9efb675', 'USER', 'ACTIVE', 'FIC'),
('e35a5c8b-ae10-5cca-a262-316a93c683a3', 'USER', 'ACTIVE', 'FIC'),
('eb37ee78-f891-503c-aaa4-87db7667cb30', 'USER', 'ACTIVE', 'FIC'),
('f5eb55e1-4422-52fd-b0d5-d1883683c76d', 'USER', 'ACTIVE', 'FIC'),
('fb6ced98-b72a-55e6-bb66-29cf0a703482', 'USER', 'ACTIVE', 'FIC'),
('fea09151-80e2-519a-85f6-9c0820c7fd92', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('052dae7a-c03c-5eee-973b-64b770401969', 0),
('0c5e5563-00e3-5848-8da3-71931e1e494f', 0),
('261ccf5f-bb15-5cfd-9c50-657a7bef5c6b', 0),
('3cd0f284-e885-5320-892c-63feed32ec7f', 0),
('3d697077-7390-57de-815d-3e767845574f', 0),
('40d35a9e-1e45-5ab5-8d70-54f47d066d42', 0),
('4f2422a2-408f-53ef-a247-95ddfc50bc96', 0),
('604302f3-762d-56e6-afd9-323269d9fe59', 0),
('614522bf-6bdc-52ee-8a6c-8e5a1350f2a4', 0),
('6a0e1dab-40b4-5586-9c80-06218f7d5b84', 0),
('6e360b80-9bc9-589c-8ce6-94568a6925df', 0),
('70b0276a-2341-5d07-8b00-0ce82b917cb5', 0),
('77952a7c-c6a4-52e2-a7da-c472eb68fb38', 0),
('862aa3ff-2ad5-5226-9b4f-c25d1fd84324', 0),
('9460e697-eb73-5f3f-b88a-b023ca57ae79', 0),
('a198114b-2444-5e48-952d-971b522763c1', 0),
('a6353ecc-0723-5507-a193-632acbbced6b', 0),
('b18caf49-21b7-5ae5-8107-2acc3b4db3f5', 0),
('c9e2280d-4577-500c-adb2-a47274409a4b', 0),
('d177e97c-621a-5bff-bd91-f97cf90c1537', 0),
('dcb38a01-1076-5ae2-84b2-0bfca9efb675', 0),
('e35a5c8b-ae10-5cca-a262-316a93c683a3', 0),
('eb37ee78-f891-503c-aaa4-87db7667cb30', 0),
('f5eb55e1-4422-52fd-b0d5-d1883683c76d', 0),
('fb6ced98-b72a-55e6-bb66-29cf0a703482', 0),
('fea09151-80e2-519a-85f6-9c0820c7fd92', 0);
SELECT account_id FROM balances WHERE account_id IN ('052dae7a-c03c-5eee-973b-64b770401969','0c5e5563-00e3-5848-8da3-71931e1e494f','261ccf5f-bb15-5cfd-9c50-657a7bef5c6b','3cd0f284-e885-5320-892c-63feed32ec7f','3d697077-7390-57de-815d-3e767845574f','40d35a9e-1e45-5ab5-8d70-54f47d066d42','4f2422a2-408f-53ef-a247-95ddfc50bc96','604302f3-762d-56e6-afd9-323269d9fe59','614522bf-6bdc-52ee-8a6c-8e5a1350f2a4','6a0e1dab-40b4-5586-9c80-06218f7d5b84','6e360b80-9bc9-589c-8ce6-94568a6925df','70b0276a-2341-5d07-8b00-0ce82b917cb5','77952a7c-c6a4-52e2-a7da-c472eb68fb38','862aa3ff-2ad5-5226-9b4f-c25d1fd84324','9460e697-eb73-5f3f-b88a-b023ca57ae79','a198114b-2444-5e48-952d-971b522763c1','a6353ecc-0723-5507-a193-632acbbced6b','b18caf49-21b7-5ae5-8107-2acc3b4db3f5','c9e2280d-4577-500c-adb2-a47274409a4b','d177e97c-621a-5bff-bd91-f97cf90c1537','dcb38a01-1076-5ae2-84b2-0bfca9efb675','e35a5c8b-ae10-5cca-a262-316a93c683a3','eb37ee78-f891-503c-aaa4-87db7667cb30','f5eb55e1-4422-52fd-b0d5-d1883683c76d','fb6ced98-b72a-55e6-bb66-29cf0a703482','fea09151-80e2-519a-85f6-9c0820c7fd92') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3e78dcd1-c32a-50f9-b601-edad5af56c1f', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-0', 'c9e2280d-4577-500c-adb2-a47274409a4b', '614522bf-6bdc-52ee-8a6c-8e5a1350f2a4', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '614522bf-6bdc-52ee-8a6c-8e5a1350f2a4';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3e78dcd1-c32a-50f9-b601-edad5af56c1f', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('3e78dcd1-c32a-50f9-b601-edad5af56c1f', '614522bf-6bdc-52ee-8a6c-8e5a1350f2a4', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3e78dcd1-c32a-50f9-b601-edad5af56c1f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d2271b67-3f1b-56f9-aead-a70ea0e70905', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-1', 'c9e2280d-4577-500c-adb2-a47274409a4b', '40d35a9e-1e45-5ab5-8d70-54f47d066d42', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '40d35a9e-1e45-5ab5-8d70-54f47d066d42';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d2271b67-3f1b-56f9-aead-a70ea0e70905', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('d2271b67-3f1b-56f9-aead-a70ea0e70905', '40d35a9e-1e45-5ab5-8d70-54f47d066d42', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd2271b67-3f1b-56f9-aead-a70ea0e70905';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b1fcce35-5645-54b9-8e7c-b32e497587ea', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-2', 'c9e2280d-4577-500c-adb2-a47274409a4b', 'a6353ecc-0723-5507-a193-632acbbced6b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a6353ecc-0723-5507-a193-632acbbced6b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b1fcce35-5645-54b9-8e7c-b32e497587ea', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('b1fcce35-5645-54b9-8e7c-b32e497587ea', 'a6353ecc-0723-5507-a193-632acbbced6b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b1fcce35-5645-54b9-8e7c-b32e497587ea';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('618e63c9-bb4e-5e50-bcff-6dcbf72c16e0', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-3', 'c9e2280d-4577-500c-adb2-a47274409a4b', 'dcb38a01-1076-5ae2-84b2-0bfca9efb675', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'dcb38a01-1076-5ae2-84b2-0bfca9efb675';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('618e63c9-bb4e-5e50-bcff-6dcbf72c16e0', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('618e63c9-bb4e-5e50-bcff-6dcbf72c16e0', 'dcb38a01-1076-5ae2-84b2-0bfca9efb675', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '618e63c9-bb4e-5e50-bcff-6dcbf72c16e0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('82a936dc-c3b8-57cf-a271-02387f9299b9', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-4', 'c9e2280d-4577-500c-adb2-a47274409a4b', '0c5e5563-00e3-5848-8da3-71931e1e494f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0c5e5563-00e3-5848-8da3-71931e1e494f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('82a936dc-c3b8-57cf-a271-02387f9299b9', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('82a936dc-c3b8-57cf-a271-02387f9299b9', '0c5e5563-00e3-5848-8da3-71931e1e494f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '82a936dc-c3b8-57cf-a271-02387f9299b9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d2efd4e6-bd22-592a-a3c5-abcf54b62a12', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-5', 'c9e2280d-4577-500c-adb2-a47274409a4b', '052dae7a-c03c-5eee-973b-64b770401969', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '052dae7a-c03c-5eee-973b-64b770401969';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d2efd4e6-bd22-592a-a3c5-abcf54b62a12', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('d2efd4e6-bd22-592a-a3c5-abcf54b62a12', '052dae7a-c03c-5eee-973b-64b770401969', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd2efd4e6-bd22-592a-a3c5-abcf54b62a12';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('49e83a61-e4da-5bfd-a8ee-fc0e9dc2869c', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-6', 'c9e2280d-4577-500c-adb2-a47274409a4b', '6a0e1dab-40b4-5586-9c80-06218f7d5b84', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6a0e1dab-40b4-5586-9c80-06218f7d5b84';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('49e83a61-e4da-5bfd-a8ee-fc0e9dc2869c', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('49e83a61-e4da-5bfd-a8ee-fc0e9dc2869c', '6a0e1dab-40b4-5586-9c80-06218f7d5b84', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '49e83a61-e4da-5bfd-a8ee-fc0e9dc2869c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('20e69466-c3f9-5031-8944-6ddf5c029adb', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-7', 'c9e2280d-4577-500c-adb2-a47274409a4b', '604302f3-762d-56e6-afd9-323269d9fe59', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '604302f3-762d-56e6-afd9-323269d9fe59';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('20e69466-c3f9-5031-8944-6ddf5c029adb', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('20e69466-c3f9-5031-8944-6ddf5c029adb', '604302f3-762d-56e6-afd9-323269d9fe59', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '20e69466-c3f9-5031-8944-6ddf5c029adb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('fe21cdfc-3aa3-5baf-8afa-149a00bb8359', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-8', 'c9e2280d-4577-500c-adb2-a47274409a4b', 'fea09151-80e2-519a-85f6-9c0820c7fd92', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fea09151-80e2-519a-85f6-9c0820c7fd92';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('fe21cdfc-3aa3-5baf-8afa-149a00bb8359', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('fe21cdfc-3aa3-5baf-8afa-149a00bb8359', 'fea09151-80e2-519a-85f6-9c0820c7fd92', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'fe21cdfc-3aa3-5baf-8afa-149a00bb8359';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('82b9a928-92b8-591c-bf03-0023ccacd73d', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-9', 'c9e2280d-4577-500c-adb2-a47274409a4b', '4f2422a2-408f-53ef-a247-95ddfc50bc96', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4f2422a2-408f-53ef-a247-95ddfc50bc96';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('82b9a928-92b8-591c-bf03-0023ccacd73d', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('82b9a928-92b8-591c-bf03-0023ccacd73d', '4f2422a2-408f-53ef-a247-95ddfc50bc96', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '82b9a928-92b8-591c-bf03-0023ccacd73d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('63ec2dc3-246b-511f-b702-1fb6f639ccae', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-10', 'c9e2280d-4577-500c-adb2-a47274409a4b', 'd177e97c-621a-5bff-bd91-f97cf90c1537', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd177e97c-621a-5bff-bd91-f97cf90c1537';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('63ec2dc3-246b-511f-b702-1fb6f639ccae', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('63ec2dc3-246b-511f-b702-1fb6f639ccae', 'd177e97c-621a-5bff-bd91-f97cf90c1537', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '63ec2dc3-246b-511f-b702-1fb6f639ccae';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8c4d157f-0c0b-5ed4-a53c-265f79371181', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-11', 'c9e2280d-4577-500c-adb2-a47274409a4b', '261ccf5f-bb15-5cfd-9c50-657a7bef5c6b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '261ccf5f-bb15-5cfd-9c50-657a7bef5c6b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8c4d157f-0c0b-5ed4-a53c-265f79371181', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('8c4d157f-0c0b-5ed4-a53c-265f79371181', '261ccf5f-bb15-5cfd-9c50-657a7bef5c6b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8c4d157f-0c0b-5ed4-a53c-265f79371181';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('252544ca-199d-537f-9476-9232fa350f2d', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-12', 'c9e2280d-4577-500c-adb2-a47274409a4b', 'f5eb55e1-4422-52fd-b0d5-d1883683c76d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f5eb55e1-4422-52fd-b0d5-d1883683c76d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('252544ca-199d-537f-9476-9232fa350f2d', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('252544ca-199d-537f-9476-9232fa350f2d', 'f5eb55e1-4422-52fd-b0d5-d1883683c76d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '252544ca-199d-537f-9476-9232fa350f2d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('514dc0b4-6794-5cc7-8e8e-fc35ea74b2d9', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-13', 'c9e2280d-4577-500c-adb2-a47274409a4b', '70b0276a-2341-5d07-8b00-0ce82b917cb5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '70b0276a-2341-5d07-8b00-0ce82b917cb5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('514dc0b4-6794-5cc7-8e8e-fc35ea74b2d9', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('514dc0b4-6794-5cc7-8e8e-fc35ea74b2d9', '70b0276a-2341-5d07-8b00-0ce82b917cb5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '514dc0b4-6794-5cc7-8e8e-fc35ea74b2d9';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6d5a18f3-841c-579d-82cd-b863fd2ea26a', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-14', 'c9e2280d-4577-500c-adb2-a47274409a4b', 'b18caf49-21b7-5ae5-8107-2acc3b4db3f5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b18caf49-21b7-5ae5-8107-2acc3b4db3f5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6d5a18f3-841c-579d-82cd-b863fd2ea26a', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('6d5a18f3-841c-579d-82cd-b863fd2ea26a', 'b18caf49-21b7-5ae5-8107-2acc3b4db3f5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6d5a18f3-841c-579d-82cd-b863fd2ea26a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('842b0968-4337-5e27-be01-1f7aece998cc', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-15', 'c9e2280d-4577-500c-adb2-a47274409a4b', '9460e697-eb73-5f3f-b88a-b023ca57ae79', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9460e697-eb73-5f3f-b88a-b023ca57ae79';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('842b0968-4337-5e27-be01-1f7aece998cc', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('842b0968-4337-5e27-be01-1f7aece998cc', '9460e697-eb73-5f3f-b88a-b023ca57ae79', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '842b0968-4337-5e27-be01-1f7aece998cc';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8f7ecac5-f8a5-5633-b77c-1ba52b4047c8', 'benchmark-funding-a7d87b9a-6cd6-4cf5-91e0-42ab7631f771-16', 'c9e2280d-4577-500c-adb2-a47274409a4b', 'e35a5c8b-ae10-5cca-a262-316a93c683a3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'c9e2280d-4577-500c-adb2-a47274409a4b';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e35a5c8b-ae10-5cca-a262-316a93c683a3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8f7ecac5-f8a5-5633-b77c-1ba52b4047c8', 'c9e2280d-4577-500c-adb2-a47274409a4b', -1000000000), ('8f7ecac5-f8a5-5633-b77c-1ba52b4047c8', 'e35a5c8b-ae10-5cca-a262-316a93c683a3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8f7ecac5-f8a5-5633-b77c-1ba52b4047c8';
COMMIT;
