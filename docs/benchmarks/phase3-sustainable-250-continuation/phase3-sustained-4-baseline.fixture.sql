-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('075834ef-937f-5141-9ddc-ef34745a85bc', 'USER', 'ACTIVE', 'FIC'),
('0e76fe0a-fb9c-5571-adc7-3b6d84af0c58', 'USER', 'ACTIVE', 'FIC'),
('10c81fc1-a9e1-56b9-b179-566830ee1dec', 'USER', 'ACTIVE', 'FIC'),
('14146139-6ee5-508b-b4af-5a2568e65b46', 'USER', 'ACTIVE', 'FIC'),
('19e40f91-d28b-5aa0-84cb-e858c62c09a7', 'USER', 'ACTIVE', 'FIC'),
('214a1552-ab4f-506d-b61b-3114f422384a', 'USER', 'ACTIVE', 'FIC'),
('2328fa34-7fb8-52f6-afa6-b04acfddf947', 'USER', 'ACTIVE', 'FIC'),
('323e611c-d88b-5309-894f-e26409fd7d5b', 'USER', 'ACTIVE', 'FIC'),
('434703aa-07a4-5b09-b1fd-e9bb62dbe92a', 'USER', 'ACTIVE', 'FIC'),
('5ff7143a-8ba7-5e24-b10b-ba283c0177bc', 'USER', 'ACTIVE', 'FIC'),
('61839988-0257-52c0-b0d5-15c70c62a17a', 'USER', 'ACTIVE', 'FIC'),
('6ed794dc-3fe2-56d9-93d5-e80bfab39ca4', 'USER', 'ACTIVE', 'FIC'),
('797d9fac-fcdf-5318-af13-4f081ce1f97d', 'USER', 'ACTIVE', 'FIC'),
('962745d4-0953-512d-b1a9-c7297f42192a', 'ISSUANCE', 'ACTIVE', 'FIC'),
('aec1df36-a1e3-56c2-abc0-cf99e02b6cba', 'USER', 'ACTIVE', 'FIC'),
('be087b2d-ff07-5636-81ea-faa02a16ad39', 'USER', 'ACTIVE', 'FIC'),
('c579ee10-f4ca-5fa2-82d6-3347ab1f2af7', 'USER', 'ACTIVE', 'FIC'),
('d0056078-9fef-5c66-a8c7-68056e8dfd33', 'USER', 'ACTIVE', 'FIC'),
('d16c11a0-30e7-5c7f-ae9d-51d6de1aec7f', 'USER', 'ACTIVE', 'FIC'),
('d6be0255-1161-5ef4-8e46-16ef556b505d', 'USER', 'ACTIVE', 'FIC'),
('dbfdb9a6-8eab-5e90-a4cf-1df9bcc6baa3', 'USER', 'ACTIVE', 'FIC'),
('ea002559-2054-5e22-8519-5886543a40a9', 'USER', 'ACTIVE', 'FIC'),
('ed5243ac-6056-555a-b482-aeddabd939c5', 'USER', 'ACTIVE', 'FIC'),
('ed99e6ba-9d1d-53d9-8561-f52f9183026c', 'USER', 'ACTIVE', 'FIC'),
('eda00b06-7ac9-5656-be73-759ac07002de', 'USER', 'ACTIVE', 'FIC'),
('f78cc214-1dbe-5635-a314-15eccea16f4e', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('075834ef-937f-5141-9ddc-ef34745a85bc', 0),
('0e76fe0a-fb9c-5571-adc7-3b6d84af0c58', 0),
('10c81fc1-a9e1-56b9-b179-566830ee1dec', 0),
('14146139-6ee5-508b-b4af-5a2568e65b46', 0),
('19e40f91-d28b-5aa0-84cb-e858c62c09a7', 0),
('214a1552-ab4f-506d-b61b-3114f422384a', 0),
('2328fa34-7fb8-52f6-afa6-b04acfddf947', 0),
('323e611c-d88b-5309-894f-e26409fd7d5b', 0),
('434703aa-07a4-5b09-b1fd-e9bb62dbe92a', 0),
('5ff7143a-8ba7-5e24-b10b-ba283c0177bc', 0),
('61839988-0257-52c0-b0d5-15c70c62a17a', 0),
('6ed794dc-3fe2-56d9-93d5-e80bfab39ca4', 0),
('797d9fac-fcdf-5318-af13-4f081ce1f97d', 0),
('962745d4-0953-512d-b1a9-c7297f42192a', 0),
('aec1df36-a1e3-56c2-abc0-cf99e02b6cba', 0),
('be087b2d-ff07-5636-81ea-faa02a16ad39', 0),
('c579ee10-f4ca-5fa2-82d6-3347ab1f2af7', 0),
('d0056078-9fef-5c66-a8c7-68056e8dfd33', 0),
('d16c11a0-30e7-5c7f-ae9d-51d6de1aec7f', 0),
('d6be0255-1161-5ef4-8e46-16ef556b505d', 0),
('dbfdb9a6-8eab-5e90-a4cf-1df9bcc6baa3', 0),
('ea002559-2054-5e22-8519-5886543a40a9', 0),
('ed5243ac-6056-555a-b482-aeddabd939c5', 0),
('ed99e6ba-9d1d-53d9-8561-f52f9183026c', 0),
('eda00b06-7ac9-5656-be73-759ac07002de', 0),
('f78cc214-1dbe-5635-a314-15eccea16f4e', 0);
SELECT account_id FROM balances WHERE account_id IN ('075834ef-937f-5141-9ddc-ef34745a85bc','0e76fe0a-fb9c-5571-adc7-3b6d84af0c58','10c81fc1-a9e1-56b9-b179-566830ee1dec','14146139-6ee5-508b-b4af-5a2568e65b46','19e40f91-d28b-5aa0-84cb-e858c62c09a7','214a1552-ab4f-506d-b61b-3114f422384a','2328fa34-7fb8-52f6-afa6-b04acfddf947','323e611c-d88b-5309-894f-e26409fd7d5b','434703aa-07a4-5b09-b1fd-e9bb62dbe92a','5ff7143a-8ba7-5e24-b10b-ba283c0177bc','61839988-0257-52c0-b0d5-15c70c62a17a','6ed794dc-3fe2-56d9-93d5-e80bfab39ca4','797d9fac-fcdf-5318-af13-4f081ce1f97d','962745d4-0953-512d-b1a9-c7297f42192a','aec1df36-a1e3-56c2-abc0-cf99e02b6cba','be087b2d-ff07-5636-81ea-faa02a16ad39','c579ee10-f4ca-5fa2-82d6-3347ab1f2af7','d0056078-9fef-5c66-a8c7-68056e8dfd33','d16c11a0-30e7-5c7f-ae9d-51d6de1aec7f','d6be0255-1161-5ef4-8e46-16ef556b505d','dbfdb9a6-8eab-5e90-a4cf-1df9bcc6baa3','ea002559-2054-5e22-8519-5886543a40a9','ed5243ac-6056-555a-b482-aeddabd939c5','ed99e6ba-9d1d-53d9-8561-f52f9183026c','eda00b06-7ac9-5656-be73-759ac07002de','f78cc214-1dbe-5635-a314-15eccea16f4e') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9b88b21c-9051-5e93-ace4-29ab09c9130c', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-0', '962745d4-0953-512d-b1a9-c7297f42192a', '10c81fc1-a9e1-56b9-b179-566830ee1dec', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '10c81fc1-a9e1-56b9-b179-566830ee1dec';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9b88b21c-9051-5e93-ace4-29ab09c9130c', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('9b88b21c-9051-5e93-ace4-29ab09c9130c', '10c81fc1-a9e1-56b9-b179-566830ee1dec', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9b88b21c-9051-5e93-ace4-29ab09c9130c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('bd4d63bc-44c0-52b5-b548-d2cd5b52c1a0', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-1', '962745d4-0953-512d-b1a9-c7297f42192a', 'be087b2d-ff07-5636-81ea-faa02a16ad39', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'be087b2d-ff07-5636-81ea-faa02a16ad39';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('bd4d63bc-44c0-52b5-b548-d2cd5b52c1a0', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('bd4d63bc-44c0-52b5-b548-d2cd5b52c1a0', 'be087b2d-ff07-5636-81ea-faa02a16ad39', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'bd4d63bc-44c0-52b5-b548-d2cd5b52c1a0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4d7cae5d-44fe-5c19-9280-d6431bd906b5', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-2', '962745d4-0953-512d-b1a9-c7297f42192a', 'ed5243ac-6056-555a-b482-aeddabd939c5', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ed5243ac-6056-555a-b482-aeddabd939c5';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4d7cae5d-44fe-5c19-9280-d6431bd906b5', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('4d7cae5d-44fe-5c19-9280-d6431bd906b5', 'ed5243ac-6056-555a-b482-aeddabd939c5', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4d7cae5d-44fe-5c19-9280-d6431bd906b5';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0f7ef8e4-b328-5734-a115-83435a0a361d', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-3', '962745d4-0953-512d-b1a9-c7297f42192a', '14146139-6ee5-508b-b4af-5a2568e65b46', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '14146139-6ee5-508b-b4af-5a2568e65b46';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0f7ef8e4-b328-5734-a115-83435a0a361d', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('0f7ef8e4-b328-5734-a115-83435a0a361d', '14146139-6ee5-508b-b4af-5a2568e65b46', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0f7ef8e4-b328-5734-a115-83435a0a361d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0b56fa19-7f95-5b97-8b56-93165d60915d', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-4', '962745d4-0953-512d-b1a9-c7297f42192a', '5ff7143a-8ba7-5e24-b10b-ba283c0177bc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5ff7143a-8ba7-5e24-b10b-ba283c0177bc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0b56fa19-7f95-5b97-8b56-93165d60915d', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('0b56fa19-7f95-5b97-8b56-93165d60915d', '5ff7143a-8ba7-5e24-b10b-ba283c0177bc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0b56fa19-7f95-5b97-8b56-93165d60915d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c344256d-9122-54f1-93d9-6860832180fb', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-5', '962745d4-0953-512d-b1a9-c7297f42192a', 'f78cc214-1dbe-5635-a314-15eccea16f4e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f78cc214-1dbe-5635-a314-15eccea16f4e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c344256d-9122-54f1-93d9-6860832180fb', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('c344256d-9122-54f1-93d9-6860832180fb', 'f78cc214-1dbe-5635-a314-15eccea16f4e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c344256d-9122-54f1-93d9-6860832180fb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('c12ffec7-d4a5-5751-90df-934eb319e79b', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-6', '962745d4-0953-512d-b1a9-c7297f42192a', '6ed794dc-3fe2-56d9-93d5-e80bfab39ca4', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6ed794dc-3fe2-56d9-93d5-e80bfab39ca4';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('c12ffec7-d4a5-5751-90df-934eb319e79b', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('c12ffec7-d4a5-5751-90df-934eb319e79b', '6ed794dc-3fe2-56d9-93d5-e80bfab39ca4', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'c12ffec7-d4a5-5751-90df-934eb319e79b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3ac22155-cb5c-542e-ad30-3f9d5effb8ff', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-7', '962745d4-0953-512d-b1a9-c7297f42192a', 'd6be0255-1161-5ef4-8e46-16ef556b505d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd6be0255-1161-5ef4-8e46-16ef556b505d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3ac22155-cb5c-542e-ad30-3f9d5effb8ff', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('3ac22155-cb5c-542e-ad30-3f9d5effb8ff', 'd6be0255-1161-5ef4-8e46-16ef556b505d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3ac22155-cb5c-542e-ad30-3f9d5effb8ff';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5afce5a0-be81-5d63-892e-321e531f45bf', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-8', '962745d4-0953-512d-b1a9-c7297f42192a', '797d9fac-fcdf-5318-af13-4f081ce1f97d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '797d9fac-fcdf-5318-af13-4f081ce1f97d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5afce5a0-be81-5d63-892e-321e531f45bf', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('5afce5a0-be81-5d63-892e-321e531f45bf', '797d9fac-fcdf-5318-af13-4f081ce1f97d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5afce5a0-be81-5d63-892e-321e531f45bf';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('4a340aff-5e96-59c8-999f-2b775cbc0a85', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-9', '962745d4-0953-512d-b1a9-c7297f42192a', 'ed99e6ba-9d1d-53d9-8561-f52f9183026c', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ed99e6ba-9d1d-53d9-8561-f52f9183026c';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('4a340aff-5e96-59c8-999f-2b775cbc0a85', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('4a340aff-5e96-59c8-999f-2b775cbc0a85', 'ed99e6ba-9d1d-53d9-8561-f52f9183026c', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '4a340aff-5e96-59c8-999f-2b775cbc0a85';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('cdf2255f-c274-513b-ab65-282f11320848', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-10', '962745d4-0953-512d-b1a9-c7297f42192a', 'd16c11a0-30e7-5c7f-ae9d-51d6de1aec7f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd16c11a0-30e7-5c7f-ae9d-51d6de1aec7f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('cdf2255f-c274-513b-ab65-282f11320848', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('cdf2255f-c274-513b-ab65-282f11320848', 'd16c11a0-30e7-5c7f-ae9d-51d6de1aec7f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'cdf2255f-c274-513b-ab65-282f11320848';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0713e5ca-3dc9-595a-b5bf-f189c185316e', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-11', '962745d4-0953-512d-b1a9-c7297f42192a', 'dbfdb9a6-8eab-5e90-a4cf-1df9bcc6baa3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'dbfdb9a6-8eab-5e90-a4cf-1df9bcc6baa3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0713e5ca-3dc9-595a-b5bf-f189c185316e', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('0713e5ca-3dc9-595a-b5bf-f189c185316e', 'dbfdb9a6-8eab-5e90-a4cf-1df9bcc6baa3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0713e5ca-3dc9-595a-b5bf-f189c185316e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8460b7b0-50c5-5368-afd4-a5fef81f2825', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-12', '962745d4-0953-512d-b1a9-c7297f42192a', '214a1552-ab4f-506d-b61b-3114f422384a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '214a1552-ab4f-506d-b61b-3114f422384a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8460b7b0-50c5-5368-afd4-a5fef81f2825', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('8460b7b0-50c5-5368-afd4-a5fef81f2825', '214a1552-ab4f-506d-b61b-3114f422384a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8460b7b0-50c5-5368-afd4-a5fef81f2825';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8a665612-211e-5bbb-ad90-ed8be7e4310f', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-13', '962745d4-0953-512d-b1a9-c7297f42192a', '075834ef-937f-5141-9ddc-ef34745a85bc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '075834ef-937f-5141-9ddc-ef34745a85bc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8a665612-211e-5bbb-ad90-ed8be7e4310f', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('8a665612-211e-5bbb-ad90-ed8be7e4310f', '075834ef-937f-5141-9ddc-ef34745a85bc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8a665612-211e-5bbb-ad90-ed8be7e4310f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3eba2bfb-8e68-5113-a410-71204ca1b8ba', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-14', '962745d4-0953-512d-b1a9-c7297f42192a', '19e40f91-d28b-5aa0-84cb-e858c62c09a7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '19e40f91-d28b-5aa0-84cb-e858c62c09a7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3eba2bfb-8e68-5113-a410-71204ca1b8ba', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('3eba2bfb-8e68-5113-a410-71204ca1b8ba', '19e40f91-d28b-5aa0-84cb-e858c62c09a7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3eba2bfb-8e68-5113-a410-71204ca1b8ba';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e2f7e810-f4ab-5031-84ed-fb54a6a76ca7', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-15', '962745d4-0953-512d-b1a9-c7297f42192a', 'd0056078-9fef-5c66-a8c7-68056e8dfd33', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd0056078-9fef-5c66-a8c7-68056e8dfd33';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e2f7e810-f4ab-5031-84ed-fb54a6a76ca7', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('e2f7e810-f4ab-5031-84ed-fb54a6a76ca7', 'd0056078-9fef-5c66-a8c7-68056e8dfd33', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e2f7e810-f4ab-5031-84ed-fb54a6a76ca7';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ca038a60-91ae-552f-8479-18017fa8fe96', 'benchmark-funding-5f0eb9f6-b6d3-48bb-9ea0-61a4491844c5-16', '962745d4-0953-512d-b1a9-c7297f42192a', '323e611c-d88b-5309-894f-e26409fd7d5b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '962745d4-0953-512d-b1a9-c7297f42192a';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '323e611c-d88b-5309-894f-e26409fd7d5b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ca038a60-91ae-552f-8479-18017fa8fe96', '962745d4-0953-512d-b1a9-c7297f42192a', -1000000000), ('ca038a60-91ae-552f-8479-18017fa8fe96', '323e611c-d88b-5309-894f-e26409fd7d5b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ca038a60-91ae-552f-8479-18017fa8fe96';
COMMIT;
