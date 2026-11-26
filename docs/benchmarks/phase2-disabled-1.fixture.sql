-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('01da87b9-7ac1-521d-9c3b-35574ece4921', 'ISSUANCE', 'ACTIVE', 'FIC'),
('079e6668-65cd-5fac-9ead-20db5bd6a7bc', 'USER', 'ACTIVE', 'FIC'),
('23585ef8-62c8-5e49-8983-4165c825b950', 'USER', 'ACTIVE', 'FIC'),
('2f274c82-274f-588a-b0da-b3ef246e3e07', 'USER', 'ACTIVE', 'FIC'),
('31772cbf-43fc-54e9-87d1-490aa55bbfd2', 'USER', 'ACTIVE', 'FIC'),
('41cd4a18-4290-5649-81c8-175285f16ab0', 'USER', 'ACTIVE', 'FIC'),
('47a0ecde-c6c9-50e7-b7ac-f539179cb210', 'USER', 'ACTIVE', 'FIC'),
('4b8233f2-3178-5a3c-b440-efece349720d', 'USER', 'ACTIVE', 'FIC'),
('4fdd5517-1d6d-5b79-9942-8145fed43714', 'USER', 'ACTIVE', 'FIC'),
('5d4e5e81-ac1e-5847-a005-17ec30366284', 'USER', 'ACTIVE', 'FIC'),
('68223078-08c9-5ee7-9673-fcab4c2f15ce', 'USER', 'ACTIVE', 'FIC'),
('6911e03a-e496-548c-886d-e622fff6e9c4', 'USER', 'ACTIVE', 'FIC'),
('6faabb0c-3396-5459-9094-aa731b6a7d53', 'USER', 'ACTIVE', 'FIC'),
('9fb9f1e6-497f-5a0c-9fd5-f76316cc92b3', 'USER', 'ACTIVE', 'FIC'),
('ad2291cc-01c4-52f2-a824-4bbfbac38a25', 'USER', 'ACTIVE', 'FIC'),
('b3299d9f-9ddf-5fc0-b7e6-aa5f143612b9', 'USER', 'ACTIVE', 'FIC'),
('ba6d2f6a-79dc-5b52-91e0-58408cc162ea', 'USER', 'ACTIVE', 'FIC'),
('c3e46fcb-0d07-58ed-9308-8e4a32144a78', 'USER', 'ACTIVE', 'FIC'),
('c6657310-bebd-514c-a5d9-e393047bea67', 'USER', 'ACTIVE', 'FIC'),
('d197fab2-2aa8-5112-ba3e-b110db53808c', 'USER', 'ACTIVE', 'FIC'),
('d5c99b90-a444-5a2b-b0a6-254295d3e2ca', 'USER', 'ACTIVE', 'FIC'),
('d8cd123c-51bf-5ccb-bc2b-7d3273efccbd', 'USER', 'ACTIVE', 'FIC'),
('da49b19b-5c90-5fad-8248-6195d76c422a', 'USER', 'ACTIVE', 'FIC'),
('e283a634-9568-59d5-b53e-1c8e2a7d82f2', 'USER', 'ACTIVE', 'FIC'),
('e85f70a4-d09d-5ee3-b237-4b3dc31b48dc', 'USER', 'ACTIVE', 'FIC'),
('fe07c0a8-34ee-5d7d-941c-6ea1eed9c565', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('01da87b9-7ac1-521d-9c3b-35574ece4921', 0),
('079e6668-65cd-5fac-9ead-20db5bd6a7bc', 0),
('23585ef8-62c8-5e49-8983-4165c825b950', 0),
('2f274c82-274f-588a-b0da-b3ef246e3e07', 0),
('31772cbf-43fc-54e9-87d1-490aa55bbfd2', 0),
('41cd4a18-4290-5649-81c8-175285f16ab0', 0),
('47a0ecde-c6c9-50e7-b7ac-f539179cb210', 0),
('4b8233f2-3178-5a3c-b440-efece349720d', 0),
('4fdd5517-1d6d-5b79-9942-8145fed43714', 0),
('5d4e5e81-ac1e-5847-a005-17ec30366284', 0),
('68223078-08c9-5ee7-9673-fcab4c2f15ce', 0),
('6911e03a-e496-548c-886d-e622fff6e9c4', 0),
('6faabb0c-3396-5459-9094-aa731b6a7d53', 0),
('9fb9f1e6-497f-5a0c-9fd5-f76316cc92b3', 0),
('ad2291cc-01c4-52f2-a824-4bbfbac38a25', 0),
('b3299d9f-9ddf-5fc0-b7e6-aa5f143612b9', 0),
('ba6d2f6a-79dc-5b52-91e0-58408cc162ea', 0),
('c3e46fcb-0d07-58ed-9308-8e4a32144a78', 0),
('c6657310-bebd-514c-a5d9-e393047bea67', 0),
('d197fab2-2aa8-5112-ba3e-b110db53808c', 0),
('d5c99b90-a444-5a2b-b0a6-254295d3e2ca', 0),
('d8cd123c-51bf-5ccb-bc2b-7d3273efccbd', 0),
('da49b19b-5c90-5fad-8248-6195d76c422a', 0),
('e283a634-9568-59d5-b53e-1c8e2a7d82f2', 0),
('e85f70a4-d09d-5ee3-b237-4b3dc31b48dc', 0),
('fe07c0a8-34ee-5d7d-941c-6ea1eed9c565', 0);
SELECT account_id FROM balances WHERE account_id IN ('01da87b9-7ac1-521d-9c3b-35574ece4921','079e6668-65cd-5fac-9ead-20db5bd6a7bc','23585ef8-62c8-5e49-8983-4165c825b950','2f274c82-274f-588a-b0da-b3ef246e3e07','31772cbf-43fc-54e9-87d1-490aa55bbfd2','41cd4a18-4290-5649-81c8-175285f16ab0','47a0ecde-c6c9-50e7-b7ac-f539179cb210','4b8233f2-3178-5a3c-b440-efece349720d','4fdd5517-1d6d-5b79-9942-8145fed43714','5d4e5e81-ac1e-5847-a005-17ec30366284','68223078-08c9-5ee7-9673-fcab4c2f15ce','6911e03a-e496-548c-886d-e622fff6e9c4','6faabb0c-3396-5459-9094-aa731b6a7d53','9fb9f1e6-497f-5a0c-9fd5-f76316cc92b3','ad2291cc-01c4-52f2-a824-4bbfbac38a25','b3299d9f-9ddf-5fc0-b7e6-aa5f143612b9','ba6d2f6a-79dc-5b52-91e0-58408cc162ea','c3e46fcb-0d07-58ed-9308-8e4a32144a78','c6657310-bebd-514c-a5d9-e393047bea67','d197fab2-2aa8-5112-ba3e-b110db53808c','d5c99b90-a444-5a2b-b0a6-254295d3e2ca','d8cd123c-51bf-5ccb-bc2b-7d3273efccbd','da49b19b-5c90-5fad-8248-6195d76c422a','e283a634-9568-59d5-b53e-1c8e2a7d82f2','e85f70a4-d09d-5ee3-b237-4b3dc31b48dc','fe07c0a8-34ee-5d7d-941c-6ea1eed9c565') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1e89c234-70c4-5b63-a98d-c17e5350faab', 'benchmark-funding-427ec503-84f3-4496-b6ae-127e1ee41441-0', '01da87b9-7ac1-521d-9c3b-35574ece4921', 'ba6d2f6a-79dc-5b52-91e0-58408cc162ea', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '01da87b9-7ac1-521d-9c3b-35574ece4921';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ba6d2f6a-79dc-5b52-91e0-58408cc162ea';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1e89c234-70c4-5b63-a98d-c17e5350faab', '01da87b9-7ac1-521d-9c3b-35574ece4921', -1000000000), ('1e89c234-70c4-5b63-a98d-c17e5350faab', 'ba6d2f6a-79dc-5b52-91e0-58408cc162ea', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1e89c234-70c4-5b63-a98d-c17e5350faab';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('430cb63d-9e34-5c93-881e-9a188a9c4acd', 'benchmark-funding-427ec503-84f3-4496-b6ae-127e1ee41441-1', '01da87b9-7ac1-521d-9c3b-35574ece4921', '9fb9f1e6-497f-5a0c-9fd5-f76316cc92b3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '01da87b9-7ac1-521d-9c3b-35574ece4921';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9fb9f1e6-497f-5a0c-9fd5-f76316cc92b3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('430cb63d-9e34-5c93-881e-9a188a9c4acd', '01da87b9-7ac1-521d-9c3b-35574ece4921', -1000000000), ('430cb63d-9e34-5c93-881e-9a188a9c4acd', '9fb9f1e6-497f-5a0c-9fd5-f76316cc92b3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '430cb63d-9e34-5c93-881e-9a188a9c4acd';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5fcd94b9-c115-50cd-bc43-e6052ba8d478', 'benchmark-funding-427ec503-84f3-4496-b6ae-127e1ee41441-2', '01da87b9-7ac1-521d-9c3b-35574ece4921', 'd8cd123c-51bf-5ccb-bc2b-7d3273efccbd', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '01da87b9-7ac1-521d-9c3b-35574ece4921';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd8cd123c-51bf-5ccb-bc2b-7d3273efccbd';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5fcd94b9-c115-50cd-bc43-e6052ba8d478', '01da87b9-7ac1-521d-9c3b-35574ece4921', -1000000000), ('5fcd94b9-c115-50cd-bc43-e6052ba8d478', 'd8cd123c-51bf-5ccb-bc2b-7d3273efccbd', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5fcd94b9-c115-50cd-bc43-e6052ba8d478';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('bce4206a-825d-59c4-9e48-5e5207d0b34d', 'benchmark-funding-427ec503-84f3-4496-b6ae-127e1ee41441-3', '01da87b9-7ac1-521d-9c3b-35574ece4921', '4b8233f2-3178-5a3c-b440-efece349720d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '01da87b9-7ac1-521d-9c3b-35574ece4921';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4b8233f2-3178-5a3c-b440-efece349720d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('bce4206a-825d-59c4-9e48-5e5207d0b34d', '01da87b9-7ac1-521d-9c3b-35574ece4921', -1000000000), ('bce4206a-825d-59c4-9e48-5e5207d0b34d', '4b8233f2-3178-5a3c-b440-efece349720d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'bce4206a-825d-59c4-9e48-5e5207d0b34d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c7fa896d-0324-58b8-9b2a-7953e2967f77', 'benchmark-funding-427ec503-84f3-4496-b6ae-127e1ee41441-4', '01da87b9-7ac1-521d-9c3b-35574ece4921', 'e283a634-9568-59d5-b53e-1c8e2a7d82f2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '01da87b9-7ac1-521d-9c3b-35574ece4921';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e283a634-9568-59d5-b53e-1c8e2a7d82f2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c7fa896d-0324-58b8-9b2a-7953e2967f77', '01da87b9-7ac1-521d-9c3b-35574ece4921', -1000000000), ('c7fa896d-0324-58b8-9b2a-7953e2967f77', 'e283a634-9568-59d5-b53e-1c8e2a7d82f2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c7fa896d-0324-58b8-9b2a-7953e2967f77';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e4d9aae6-08cd-5ebc-b50b-0fc1df24c044', 'benchmark-funding-427ec503-84f3-4496-b6ae-127e1ee41441-5', '01da87b9-7ac1-521d-9c3b-35574ece4921', 'b3299d9f-9ddf-5fc0-b7e6-aa5f143612b9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '01da87b9-7ac1-521d-9c3b-35574ece4921';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b3299d9f-9ddf-5fc0-b7e6-aa5f143612b9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e4d9aae6-08cd-5ebc-b50b-0fc1df24c044', '01da87b9-7ac1-521d-9c3b-35574ece4921', -1000000000), ('e4d9aae6-08cd-5ebc-b50b-0fc1df24c044', 'b3299d9f-9ddf-5fc0-b7e6-aa5f143612b9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e4d9aae6-08cd-5ebc-b50b-0fc1df24c044';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c5a7faeb-d317-5b95-b74b-d0376ef63225', 'benchmark-funding-427ec503-84f3-4496-b6ae-127e1ee41441-6', '01da87b9-7ac1-521d-9c3b-35574ece4921', 'ad2291cc-01c4-52f2-a824-4bbfbac38a25', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '01da87b9-7ac1-521d-9c3b-35574ece4921';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ad2291cc-01c4-52f2-a824-4bbfbac38a25';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c5a7faeb-d317-5b95-b74b-d0376ef63225', '01da87b9-7ac1-521d-9c3b-35574ece4921', -1000000000), ('c5a7faeb-d317-5b95-b74b-d0376ef63225', 'ad2291cc-01c4-52f2-a824-4bbfbac38a25', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c5a7faeb-d317-5b95-b74b-d0376ef63225';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('65efe11a-df8a-5989-a119-a3c35d6a4a6c', 'benchmark-funding-427ec503-84f3-4496-b6ae-127e1ee41441-7', '01da87b9-7ac1-521d-9c3b-35574ece4921', 'fe07c0a8-34ee-5d7d-941c-6ea1eed9c565', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '01da87b9-7ac1-521d-9c3b-35574ece4921';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fe07c0a8-34ee-5d7d-941c-6ea1eed9c565';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('65efe11a-df8a-5989-a119-a3c35d6a4a6c', '01da87b9-7ac1-521d-9c3b-35574ece4921', -1000000000), ('65efe11a-df8a-5989-a119-a3c35d6a4a6c', 'fe07c0a8-34ee-5d7d-941c-6ea1eed9c565', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '65efe11a-df8a-5989-a119-a3c35d6a4a6c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('67857d13-8b7a-5ad4-a995-cf39e62d6e82', 'benchmark-funding-427ec503-84f3-4496-b6ae-127e1ee41441-8', '01da87b9-7ac1-521d-9c3b-35574ece4921', '47a0ecde-c6c9-50e7-b7ac-f539179cb210', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '01da87b9-7ac1-521d-9c3b-35574ece4921';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '47a0ecde-c6c9-50e7-b7ac-f539179cb210';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('67857d13-8b7a-5ad4-a995-cf39e62d6e82', '01da87b9-7ac1-521d-9c3b-35574ece4921', -1000000000), ('67857d13-8b7a-5ad4-a995-cf39e62d6e82', '47a0ecde-c6c9-50e7-b7ac-f539179cb210', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '67857d13-8b7a-5ad4-a995-cf39e62d6e82';
COMMIT;
