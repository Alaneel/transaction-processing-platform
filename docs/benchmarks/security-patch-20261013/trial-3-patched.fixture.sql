-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('027b0c22-d2a0-5acd-89a1-6c33c127bc28', 'USER', 'ACTIVE', 'FIC'),
('22572f33-631b-5532-9237-ccc936b319ea', 'USER', 'ACTIVE', 'FIC'),
('23dc7c64-6192-552e-b08f-942ce9e567c3', 'USER', 'ACTIVE', 'FIC'),
('2eaec456-3325-5ea7-876d-13d13714efd1', 'ISSUANCE', 'ACTIVE', 'FIC'),
('3b58ca2c-c596-5bc6-a2a4-ef28b2701c44', 'USER', 'ACTIVE', 'FIC'),
('4c3800d1-bb0c-58bf-8fe5-a9847690cb37', 'USER', 'ACTIVE', 'FIC'),
('4efbb0ac-fe11-566b-8382-bdedd904e555', 'USER', 'ACTIVE', 'FIC'),
('53b63f53-17d6-5bfb-b16b-05cbc4a69329', 'USER', 'ACTIVE', 'FIC'),
('5c222566-d1ec-52f4-9305-529ef0e130a5', 'USER', 'ACTIVE', 'FIC'),
('6c19a10a-1826-59c1-9958-27cf088d19cf', 'USER', 'ACTIVE', 'FIC'),
('78727271-95cc-53b0-827a-bcd89c5c5d58', 'USER', 'ACTIVE', 'FIC'),
('79f62ab1-4b28-5feb-956e-2fe5874d1608', 'USER', 'ACTIVE', 'FIC'),
('84bfa4b2-c5e3-54da-b562-93038d871421', 'USER', 'ACTIVE', 'FIC'),
('9ca51c2c-b73f-5f9c-9ea5-276b76545317', 'USER', 'ACTIVE', 'FIC'),
('a255b61d-3bf1-5d09-9a1e-72b501137a09', 'USER', 'ACTIVE', 'FIC'),
('ac71a2c4-c0c1-5ba0-8272-56cde94b5e2d', 'USER', 'ACTIVE', 'FIC'),
('bb2033dd-afba-51c7-8e1d-0178263386fd', 'USER', 'ACTIVE', 'FIC'),
('c427504e-dadf-5e8b-86d7-dc672f59195f', 'USER', 'ACTIVE', 'FIC'),
('c5f2b0b9-d2d4-50b1-afff-ede019ad1c45', 'USER', 'ACTIVE', 'FIC'),
('cc79befc-5900-54de-bf6d-057ac91d3f4b', 'USER', 'ACTIVE', 'FIC'),
('d7185e18-a204-5636-91ff-2da58cc3abc9', 'USER', 'ACTIVE', 'FIC'),
('db13e43d-adf2-508f-94b6-31cc5333fd67', 'USER', 'ACTIVE', 'FIC'),
('dba04f14-dd6d-5583-a252-31bd77c979dc', 'USER', 'ACTIVE', 'FIC'),
('ddf3bec2-a2ae-59b1-8753-289573de7676', 'USER', 'ACTIVE', 'FIC'),
('f59860d9-85e5-599b-80a9-c98858a44cf7', 'USER', 'ACTIVE', 'FIC'),
('ff042dcc-fb62-5b18-b74c-e442ccb1eb61', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('027b0c22-d2a0-5acd-89a1-6c33c127bc28', 0),
('22572f33-631b-5532-9237-ccc936b319ea', 0),
('23dc7c64-6192-552e-b08f-942ce9e567c3', 0),
('2eaec456-3325-5ea7-876d-13d13714efd1', 0),
('3b58ca2c-c596-5bc6-a2a4-ef28b2701c44', 0),
('4c3800d1-bb0c-58bf-8fe5-a9847690cb37', 0),
('4efbb0ac-fe11-566b-8382-bdedd904e555', 0),
('53b63f53-17d6-5bfb-b16b-05cbc4a69329', 0),
('5c222566-d1ec-52f4-9305-529ef0e130a5', 0),
('6c19a10a-1826-59c1-9958-27cf088d19cf', 0),
('78727271-95cc-53b0-827a-bcd89c5c5d58', 0),
('79f62ab1-4b28-5feb-956e-2fe5874d1608', 0),
('84bfa4b2-c5e3-54da-b562-93038d871421', 0),
('9ca51c2c-b73f-5f9c-9ea5-276b76545317', 0),
('a255b61d-3bf1-5d09-9a1e-72b501137a09', 0),
('ac71a2c4-c0c1-5ba0-8272-56cde94b5e2d', 0),
('bb2033dd-afba-51c7-8e1d-0178263386fd', 0),
('c427504e-dadf-5e8b-86d7-dc672f59195f', 0),
('c5f2b0b9-d2d4-50b1-afff-ede019ad1c45', 0),
('cc79befc-5900-54de-bf6d-057ac91d3f4b', 0),
('d7185e18-a204-5636-91ff-2da58cc3abc9', 0),
('db13e43d-adf2-508f-94b6-31cc5333fd67', 0),
('dba04f14-dd6d-5583-a252-31bd77c979dc', 0),
('ddf3bec2-a2ae-59b1-8753-289573de7676', 0),
('f59860d9-85e5-599b-80a9-c98858a44cf7', 0),
('ff042dcc-fb62-5b18-b74c-e442ccb1eb61', 0);
SELECT account_id FROM balances WHERE account_id IN ('027b0c22-d2a0-5acd-89a1-6c33c127bc28','22572f33-631b-5532-9237-ccc936b319ea','23dc7c64-6192-552e-b08f-942ce9e567c3','2eaec456-3325-5ea7-876d-13d13714efd1','3b58ca2c-c596-5bc6-a2a4-ef28b2701c44','4c3800d1-bb0c-58bf-8fe5-a9847690cb37','4efbb0ac-fe11-566b-8382-bdedd904e555','53b63f53-17d6-5bfb-b16b-05cbc4a69329','5c222566-d1ec-52f4-9305-529ef0e130a5','6c19a10a-1826-59c1-9958-27cf088d19cf','78727271-95cc-53b0-827a-bcd89c5c5d58','79f62ab1-4b28-5feb-956e-2fe5874d1608','84bfa4b2-c5e3-54da-b562-93038d871421','9ca51c2c-b73f-5f9c-9ea5-276b76545317','a255b61d-3bf1-5d09-9a1e-72b501137a09','ac71a2c4-c0c1-5ba0-8272-56cde94b5e2d','bb2033dd-afba-51c7-8e1d-0178263386fd','c427504e-dadf-5e8b-86d7-dc672f59195f','c5f2b0b9-d2d4-50b1-afff-ede019ad1c45','cc79befc-5900-54de-bf6d-057ac91d3f4b','d7185e18-a204-5636-91ff-2da58cc3abc9','db13e43d-adf2-508f-94b6-31cc5333fd67','dba04f14-dd6d-5583-a252-31bd77c979dc','ddf3bec2-a2ae-59b1-8753-289573de7676','f59860d9-85e5-599b-80a9-c98858a44cf7','ff042dcc-fb62-5b18-b74c-e442ccb1eb61') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('410cf909-4182-5547-a10a-0ba7bbb85646', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-0', '2eaec456-3325-5ea7-876d-13d13714efd1', 'dba04f14-dd6d-5583-a252-31bd77c979dc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'dba04f14-dd6d-5583-a252-31bd77c979dc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('410cf909-4182-5547-a10a-0ba7bbb85646', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('410cf909-4182-5547-a10a-0ba7bbb85646', 'dba04f14-dd6d-5583-a252-31bd77c979dc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '410cf909-4182-5547-a10a-0ba7bbb85646';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ea92d9ce-17fa-5781-a10a-e4896341b2d4', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-1', '2eaec456-3325-5ea7-876d-13d13714efd1', '84bfa4b2-c5e3-54da-b562-93038d871421', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '84bfa4b2-c5e3-54da-b562-93038d871421';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ea92d9ce-17fa-5781-a10a-e4896341b2d4', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('ea92d9ce-17fa-5781-a10a-e4896341b2d4', '84bfa4b2-c5e3-54da-b562-93038d871421', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ea92d9ce-17fa-5781-a10a-e4896341b2d4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d16753c3-b0fe-532f-9506-3395b984e76e', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-2', '2eaec456-3325-5ea7-876d-13d13714efd1', 'c427504e-dadf-5e8b-86d7-dc672f59195f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c427504e-dadf-5e8b-86d7-dc672f59195f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d16753c3-b0fe-532f-9506-3395b984e76e', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('d16753c3-b0fe-532f-9506-3395b984e76e', 'c427504e-dadf-5e8b-86d7-dc672f59195f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd16753c3-b0fe-532f-9506-3395b984e76e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('710d7162-4aea-56cf-a0b6-ba5f228ae1e3', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-3', '2eaec456-3325-5ea7-876d-13d13714efd1', '23dc7c64-6192-552e-b08f-942ce9e567c3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '23dc7c64-6192-552e-b08f-942ce9e567c3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('710d7162-4aea-56cf-a0b6-ba5f228ae1e3', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('710d7162-4aea-56cf-a0b6-ba5f228ae1e3', '23dc7c64-6192-552e-b08f-942ce9e567c3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '710d7162-4aea-56cf-a0b6-ba5f228ae1e3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('440740bd-b231-5834-9ee8-6b3e2f9c0fce', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-4', '2eaec456-3325-5ea7-876d-13d13714efd1', 'ddf3bec2-a2ae-59b1-8753-289573de7676', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ddf3bec2-a2ae-59b1-8753-289573de7676';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('440740bd-b231-5834-9ee8-6b3e2f9c0fce', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('440740bd-b231-5834-9ee8-6b3e2f9c0fce', 'ddf3bec2-a2ae-59b1-8753-289573de7676', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '440740bd-b231-5834-9ee8-6b3e2f9c0fce';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d1fed193-fc9d-5657-be4c-21ca580250f1', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-5', '2eaec456-3325-5ea7-876d-13d13714efd1', 'd7185e18-a204-5636-91ff-2da58cc3abc9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd7185e18-a204-5636-91ff-2da58cc3abc9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d1fed193-fc9d-5657-be4c-21ca580250f1', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('d1fed193-fc9d-5657-be4c-21ca580250f1', 'd7185e18-a204-5636-91ff-2da58cc3abc9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd1fed193-fc9d-5657-be4c-21ca580250f1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('6689ec72-2b24-5fc3-aa2f-7c5852602bc3', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-6', '2eaec456-3325-5ea7-876d-13d13714efd1', 'c5f2b0b9-d2d4-50b1-afff-ede019ad1c45', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c5f2b0b9-d2d4-50b1-afff-ede019ad1c45';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('6689ec72-2b24-5fc3-aa2f-7c5852602bc3', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('6689ec72-2b24-5fc3-aa2f-7c5852602bc3', 'c5f2b0b9-d2d4-50b1-afff-ede019ad1c45', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '6689ec72-2b24-5fc3-aa2f-7c5852602bc3';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('774cf66b-b0d6-5577-b323-390825beec20', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-7', '2eaec456-3325-5ea7-876d-13d13714efd1', 'cc79befc-5900-54de-bf6d-057ac91d3f4b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'cc79befc-5900-54de-bf6d-057ac91d3f4b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('774cf66b-b0d6-5577-b323-390825beec20', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('774cf66b-b0d6-5577-b323-390825beec20', 'cc79befc-5900-54de-bf6d-057ac91d3f4b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '774cf66b-b0d6-5577-b323-390825beec20';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d517213e-4ead-5eec-8d21-a77d26043694', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-8', '2eaec456-3325-5ea7-876d-13d13714efd1', 'ff042dcc-fb62-5b18-b74c-e442ccb1eb61', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'ff042dcc-fb62-5b18-b74c-e442ccb1eb61';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d517213e-4ead-5eec-8d21-a77d26043694', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('d517213e-4ead-5eec-8d21-a77d26043694', 'ff042dcc-fb62-5b18-b74c-e442ccb1eb61', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd517213e-4ead-5eec-8d21-a77d26043694';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f9c5931f-fa86-5279-8338-a8e62dcbdfe7', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-9', '2eaec456-3325-5ea7-876d-13d13714efd1', '22572f33-631b-5532-9237-ccc936b319ea', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '22572f33-631b-5532-9237-ccc936b319ea';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f9c5931f-fa86-5279-8338-a8e62dcbdfe7', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('f9c5931f-fa86-5279-8338-a8e62dcbdfe7', '22572f33-631b-5532-9237-ccc936b319ea', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f9c5931f-fa86-5279-8338-a8e62dcbdfe7';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3c299249-e53c-52df-b615-0e17675d9431', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-10', '2eaec456-3325-5ea7-876d-13d13714efd1', '79f62ab1-4b28-5feb-956e-2fe5874d1608', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '79f62ab1-4b28-5feb-956e-2fe5874d1608';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3c299249-e53c-52df-b615-0e17675d9431', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('3c299249-e53c-52df-b615-0e17675d9431', '79f62ab1-4b28-5feb-956e-2fe5874d1608', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3c299249-e53c-52df-b615-0e17675d9431';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('77bdef0d-ff4e-5f24-a3b3-00f2daae3425', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-11', '2eaec456-3325-5ea7-876d-13d13714efd1', '3b58ca2c-c596-5bc6-a2a4-ef28b2701c44', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3b58ca2c-c596-5bc6-a2a4-ef28b2701c44';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('77bdef0d-ff4e-5f24-a3b3-00f2daae3425', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('77bdef0d-ff4e-5f24-a3b3-00f2daae3425', '3b58ca2c-c596-5bc6-a2a4-ef28b2701c44', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '77bdef0d-ff4e-5f24-a3b3-00f2daae3425';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('008bf96a-7448-52f4-8b1e-3024b4dd3e26', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-12', '2eaec456-3325-5ea7-876d-13d13714efd1', '53b63f53-17d6-5bfb-b16b-05cbc4a69329', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '53b63f53-17d6-5bfb-b16b-05cbc4a69329';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('008bf96a-7448-52f4-8b1e-3024b4dd3e26', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('008bf96a-7448-52f4-8b1e-3024b4dd3e26', '53b63f53-17d6-5bfb-b16b-05cbc4a69329', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '008bf96a-7448-52f4-8b1e-3024b4dd3e26';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('44b16e10-283a-5c51-85f2-a9923202b6fa', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-13', '2eaec456-3325-5ea7-876d-13d13714efd1', '9ca51c2c-b73f-5f9c-9ea5-276b76545317', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9ca51c2c-b73f-5f9c-9ea5-276b76545317';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('44b16e10-283a-5c51-85f2-a9923202b6fa', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('44b16e10-283a-5c51-85f2-a9923202b6fa', '9ca51c2c-b73f-5f9c-9ea5-276b76545317', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '44b16e10-283a-5c51-85f2-a9923202b6fa';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('20ed8ea6-f636-517a-9bb0-1356699bfa51', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-14', '2eaec456-3325-5ea7-876d-13d13714efd1', 'bb2033dd-afba-51c7-8e1d-0178263386fd', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'bb2033dd-afba-51c7-8e1d-0178263386fd';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('20ed8ea6-f636-517a-9bb0-1356699bfa51', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('20ed8ea6-f636-517a-9bb0-1356699bfa51', 'bb2033dd-afba-51c7-8e1d-0178263386fd', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '20ed8ea6-f636-517a-9bb0-1356699bfa51';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e4486ffe-7769-5209-b470-0786fb20f27b', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-15', '2eaec456-3325-5ea7-876d-13d13714efd1', 'f59860d9-85e5-599b-80a9-c98858a44cf7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f59860d9-85e5-599b-80a9-c98858a44cf7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e4486ffe-7769-5209-b470-0786fb20f27b', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('e4486ffe-7769-5209-b470-0786fb20f27b', 'f59860d9-85e5-599b-80a9-c98858a44cf7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e4486ffe-7769-5209-b470-0786fb20f27b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('592848f5-4669-52b3-a4e6-880b0f933bb4', 'benchmark-funding-0802bfd4-3d3e-4de0-a1f7-0f9cfe966374-16', '2eaec456-3325-5ea7-876d-13d13714efd1', '027b0c22-d2a0-5acd-89a1-6c33c127bc28', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '2eaec456-3325-5ea7-876d-13d13714efd1';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '027b0c22-d2a0-5acd-89a1-6c33c127bc28';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('592848f5-4669-52b3-a4e6-880b0f933bb4', '2eaec456-3325-5ea7-876d-13d13714efd1', -1000000000), ('592848f5-4669-52b3-a4e6-880b0f933bb4', '027b0c22-d2a0-5acd-89a1-6c33c127bc28', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '592848f5-4669-52b3-a4e6-880b0f933bb4';
COMMIT;
