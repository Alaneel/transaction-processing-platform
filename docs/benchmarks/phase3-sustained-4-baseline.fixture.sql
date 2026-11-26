-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('18319d9f-7624-51d5-a13c-d44438595c82', 'USER', 'ACTIVE', 'FIC'),
('1978fcbd-bec4-5614-b729-33a96fd1ae5d', 'USER', 'ACTIVE', 'FIC'),
('197a2868-f7ab-53e4-9583-fc22023e4a56', 'USER', 'ACTIVE', 'FIC'),
('1a424e25-b3f9-5152-b433-aa688745d8e2', 'USER', 'ACTIVE', 'FIC'),
('2060a723-f0f0-5e21-88e2-7a98568ddaae', 'USER', 'ACTIVE', 'FIC'),
('22031e81-1462-5057-81ac-1d67f42be177', 'USER', 'ACTIVE', 'FIC'),
('2da7e1aa-3428-54a3-80d1-42fa36a82e42', 'USER', 'ACTIVE', 'FIC'),
('32c8553a-a7f1-5c37-8beb-0619f9a74ef6', 'USER', 'ACTIVE', 'FIC'),
('34a0a1d6-d7d5-51c3-996d-5e0f80fb18f8', 'USER', 'ACTIVE', 'FIC'),
('3716dfc4-641e-5aa0-bb55-45a2cc053f54', 'USER', 'ACTIVE', 'FIC'),
('4811f47e-72f7-51f8-96ec-d65fa459e853', 'USER', 'ACTIVE', 'FIC'),
('637e2bd7-e6de-53e3-99da-ede0de3ca720', 'USER', 'ACTIVE', 'FIC'),
('72cadf8a-4cf9-5e96-b27e-afb70d87d8d6', 'USER', 'ACTIVE', 'FIC'),
('8f0f0d13-1438-59a8-ae3e-ebba53b8fc30', 'USER', 'ACTIVE', 'FIC'),
('9075d826-70b8-52a3-8c2f-86e90b269f5f', 'USER', 'ACTIVE', 'FIC'),
('9301575f-6ecc-5efc-a7d7-03b1d17b7ecd', 'USER', 'ACTIVE', 'FIC'),
('9ba1e3bb-c64e-5ba4-a109-22a3e06d863f', 'USER', 'ACTIVE', 'FIC'),
('9c7b21b1-ceca-5438-abfc-1a6666c70d5e', 'USER', 'ACTIVE', 'FIC'),
('9e68cb82-e4cc-5cf1-917a-874fd711af32', 'USER', 'ACTIVE', 'FIC'),
('a1b8039b-3e78-5315-a9d4-02e49ca82d54', 'ISSUANCE', 'ACTIVE', 'FIC'),
('b34cf8da-f0b8-5823-9399-04ea247f796f', 'USER', 'ACTIVE', 'FIC'),
('c458a1bc-ef9a-55b8-81d5-a6e3dff88f7d', 'USER', 'ACTIVE', 'FIC'),
('c7ba1b3a-8918-5f8c-b0f1-81420e93fa21', 'USER', 'ACTIVE', 'FIC'),
('eaaee1cd-ea90-5153-9230-75f1eae9fbf0', 'USER', 'ACTIVE', 'FIC'),
('f8fb97dc-13e4-5fc1-b14c-b415ff89ccff', 'USER', 'ACTIVE', 'FIC'),
('fd888060-cd21-550a-b679-b198eb07bf6b', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('18319d9f-7624-51d5-a13c-d44438595c82', 0),
('1978fcbd-bec4-5614-b729-33a96fd1ae5d', 0),
('197a2868-f7ab-53e4-9583-fc22023e4a56', 0),
('1a424e25-b3f9-5152-b433-aa688745d8e2', 0),
('2060a723-f0f0-5e21-88e2-7a98568ddaae', 0),
('22031e81-1462-5057-81ac-1d67f42be177', 0),
('2da7e1aa-3428-54a3-80d1-42fa36a82e42', 0),
('32c8553a-a7f1-5c37-8beb-0619f9a74ef6', 0),
('34a0a1d6-d7d5-51c3-996d-5e0f80fb18f8', 0),
('3716dfc4-641e-5aa0-bb55-45a2cc053f54', 0),
('4811f47e-72f7-51f8-96ec-d65fa459e853', 0),
('637e2bd7-e6de-53e3-99da-ede0de3ca720', 0),
('72cadf8a-4cf9-5e96-b27e-afb70d87d8d6', 0),
('8f0f0d13-1438-59a8-ae3e-ebba53b8fc30', 0),
('9075d826-70b8-52a3-8c2f-86e90b269f5f', 0),
('9301575f-6ecc-5efc-a7d7-03b1d17b7ecd', 0),
('9ba1e3bb-c64e-5ba4-a109-22a3e06d863f', 0),
('9c7b21b1-ceca-5438-abfc-1a6666c70d5e', 0),
('9e68cb82-e4cc-5cf1-917a-874fd711af32', 0),
('a1b8039b-3e78-5315-a9d4-02e49ca82d54', 0),
('b34cf8da-f0b8-5823-9399-04ea247f796f', 0),
('c458a1bc-ef9a-55b8-81d5-a6e3dff88f7d', 0),
('c7ba1b3a-8918-5f8c-b0f1-81420e93fa21', 0),
('eaaee1cd-ea90-5153-9230-75f1eae9fbf0', 0),
('f8fb97dc-13e4-5fc1-b14c-b415ff89ccff', 0),
('fd888060-cd21-550a-b679-b198eb07bf6b', 0);
SELECT account_id FROM balances WHERE account_id IN ('18319d9f-7624-51d5-a13c-d44438595c82','1978fcbd-bec4-5614-b729-33a96fd1ae5d','197a2868-f7ab-53e4-9583-fc22023e4a56','1a424e25-b3f9-5152-b433-aa688745d8e2','2060a723-f0f0-5e21-88e2-7a98568ddaae','22031e81-1462-5057-81ac-1d67f42be177','2da7e1aa-3428-54a3-80d1-42fa36a82e42','32c8553a-a7f1-5c37-8beb-0619f9a74ef6','34a0a1d6-d7d5-51c3-996d-5e0f80fb18f8','3716dfc4-641e-5aa0-bb55-45a2cc053f54','4811f47e-72f7-51f8-96ec-d65fa459e853','637e2bd7-e6de-53e3-99da-ede0de3ca720','72cadf8a-4cf9-5e96-b27e-afb70d87d8d6','8f0f0d13-1438-59a8-ae3e-ebba53b8fc30','9075d826-70b8-52a3-8c2f-86e90b269f5f','9301575f-6ecc-5efc-a7d7-03b1d17b7ecd','9ba1e3bb-c64e-5ba4-a109-22a3e06d863f','9c7b21b1-ceca-5438-abfc-1a6666c70d5e','9e68cb82-e4cc-5cf1-917a-874fd711af32','a1b8039b-3e78-5315-a9d4-02e49ca82d54','b34cf8da-f0b8-5823-9399-04ea247f796f','c458a1bc-ef9a-55b8-81d5-a6e3dff88f7d','c7ba1b3a-8918-5f8c-b0f1-81420e93fa21','eaaee1cd-ea90-5153-9230-75f1eae9fbf0','f8fb97dc-13e4-5fc1-b14c-b415ff89ccff','fd888060-cd21-550a-b679-b198eb07bf6b') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5b93fc14-8aaf-53df-91d9-2f5ca31d726d', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-0', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', 'c458a1bc-ef9a-55b8-81d5-a6e3dff88f7d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c458a1bc-ef9a-55b8-81d5-a6e3dff88f7d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5b93fc14-8aaf-53df-91d9-2f5ca31d726d', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('5b93fc14-8aaf-53df-91d9-2f5ca31d726d', 'c458a1bc-ef9a-55b8-81d5-a6e3dff88f7d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5b93fc14-8aaf-53df-91d9-2f5ca31d726d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('ca4ca35b-a6b3-5d51-afad-30e86b5f8d1e', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-1', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', '4811f47e-72f7-51f8-96ec-d65fa459e853', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4811f47e-72f7-51f8-96ec-d65fa459e853';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('ca4ca35b-a6b3-5d51-afad-30e86b5f8d1e', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('ca4ca35b-a6b3-5d51-afad-30e86b5f8d1e', '4811f47e-72f7-51f8-96ec-d65fa459e853', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'ca4ca35b-a6b3-5d51-afad-30e86b5f8d1e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b3fb1865-c82c-5997-9dc1-7e8aec6404f8', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-2', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', '18319d9f-7624-51d5-a13c-d44438595c82', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '18319d9f-7624-51d5-a13c-d44438595c82';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b3fb1865-c82c-5997-9dc1-7e8aec6404f8', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('b3fb1865-c82c-5997-9dc1-7e8aec6404f8', '18319d9f-7624-51d5-a13c-d44438595c82', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b3fb1865-c82c-5997-9dc1-7e8aec6404f8';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('608ee9c1-51a0-5ab8-b7b1-a8b0ce8ddba6', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-3', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', '34a0a1d6-d7d5-51c3-996d-5e0f80fb18f8', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '34a0a1d6-d7d5-51c3-996d-5e0f80fb18f8';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('608ee9c1-51a0-5ab8-b7b1-a8b0ce8ddba6', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('608ee9c1-51a0-5ab8-b7b1-a8b0ce8ddba6', '34a0a1d6-d7d5-51c3-996d-5e0f80fb18f8', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '608ee9c1-51a0-5ab8-b7b1-a8b0ce8ddba6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('43325604-5935-5308-9e33-59d439bc92df', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-4', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', '9e68cb82-e4cc-5cf1-917a-874fd711af32', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9e68cb82-e4cc-5cf1-917a-874fd711af32';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('43325604-5935-5308-9e33-59d439bc92df', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('43325604-5935-5308-9e33-59d439bc92df', '9e68cb82-e4cc-5cf1-917a-874fd711af32', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '43325604-5935-5308-9e33-59d439bc92df';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('675f8807-a94b-5599-8689-4eca4304c456', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-5', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', '22031e81-1462-5057-81ac-1d67f42be177', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '22031e81-1462-5057-81ac-1d67f42be177';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('675f8807-a94b-5599-8689-4eca4304c456', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('675f8807-a94b-5599-8689-4eca4304c456', '22031e81-1462-5057-81ac-1d67f42be177', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '675f8807-a94b-5599-8689-4eca4304c456';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('741f1315-82ad-5bbe-be03-4e5d167688d0', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-6', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', 'b34cf8da-f0b8-5823-9399-04ea247f796f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'b34cf8da-f0b8-5823-9399-04ea247f796f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('741f1315-82ad-5bbe-be03-4e5d167688d0', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('741f1315-82ad-5bbe-be03-4e5d167688d0', 'b34cf8da-f0b8-5823-9399-04ea247f796f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '741f1315-82ad-5bbe-be03-4e5d167688d0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('fd1f4fa2-0531-55c6-8910-80bd4c63ff3d', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-7', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', '197a2868-f7ab-53e4-9583-fc22023e4a56', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '197a2868-f7ab-53e4-9583-fc22023e4a56';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('fd1f4fa2-0531-55c6-8910-80bd4c63ff3d', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('fd1f4fa2-0531-55c6-8910-80bd4c63ff3d', '197a2868-f7ab-53e4-9583-fc22023e4a56', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'fd1f4fa2-0531-55c6-8910-80bd4c63ff3d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a5550954-88e6-533a-8d53-4a25f59734a1', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-8', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', '2060a723-f0f0-5e21-88e2-7a98568ddaae', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2060a723-f0f0-5e21-88e2-7a98568ddaae';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a5550954-88e6-533a-8d53-4a25f59734a1', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('a5550954-88e6-533a-8d53-4a25f59734a1', '2060a723-f0f0-5e21-88e2-7a98568ddaae', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a5550954-88e6-533a-8d53-4a25f59734a1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1c9862f7-101d-5443-b9bf-5e2eef1377d4', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-9', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', '9ba1e3bb-c64e-5ba4-a109-22a3e06d863f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9ba1e3bb-c64e-5ba4-a109-22a3e06d863f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1c9862f7-101d-5443-b9bf-5e2eef1377d4', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('1c9862f7-101d-5443-b9bf-5e2eef1377d4', '9ba1e3bb-c64e-5ba4-a109-22a3e06d863f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1c9862f7-101d-5443-b9bf-5e2eef1377d4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('fd956f4e-b557-5de2-b4bf-0d292ebb9582', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-10', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', '9301575f-6ecc-5efc-a7d7-03b1d17b7ecd', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '9301575f-6ecc-5efc-a7d7-03b1d17b7ecd';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('fd956f4e-b557-5de2-b4bf-0d292ebb9582', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('fd956f4e-b557-5de2-b4bf-0d292ebb9582', '9301575f-6ecc-5efc-a7d7-03b1d17b7ecd', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'fd956f4e-b557-5de2-b4bf-0d292ebb9582';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8d5e057a-1f97-5f10-9292-c27fedb2ebd6', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-11', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', '2da7e1aa-3428-54a3-80d1-42fa36a82e42', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2da7e1aa-3428-54a3-80d1-42fa36a82e42';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8d5e057a-1f97-5f10-9292-c27fedb2ebd6', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('8d5e057a-1f97-5f10-9292-c27fedb2ebd6', '2da7e1aa-3428-54a3-80d1-42fa36a82e42', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8d5e057a-1f97-5f10-9292-c27fedb2ebd6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('8a18a404-a99b-5683-b3b0-d6696694e2ba', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-12', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', '1978fcbd-bec4-5614-b729-33a96fd1ae5d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1978fcbd-bec4-5614-b729-33a96fd1ae5d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('8a18a404-a99b-5683-b3b0-d6696694e2ba', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('8a18a404-a99b-5683-b3b0-d6696694e2ba', '1978fcbd-bec4-5614-b729-33a96fd1ae5d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '8a18a404-a99b-5683-b3b0-d6696694e2ba';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('db41c0cc-18c2-5bce-b910-abdebbd6d609', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-13', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', 'eaaee1cd-ea90-5153-9230-75f1eae9fbf0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'eaaee1cd-ea90-5153-9230-75f1eae9fbf0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('db41c0cc-18c2-5bce-b910-abdebbd6d609', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('db41c0cc-18c2-5bce-b910-abdebbd6d609', 'eaaee1cd-ea90-5153-9230-75f1eae9fbf0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'db41c0cc-18c2-5bce-b910-abdebbd6d609';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('745c7d05-ddfd-53c1-a55a-09a53459539e', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-14', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', 'fd888060-cd21-550a-b679-b198eb07bf6b', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'fd888060-cd21-550a-b679-b198eb07bf6b';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('745c7d05-ddfd-53c1-a55a-09a53459539e', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('745c7d05-ddfd-53c1-a55a-09a53459539e', 'fd888060-cd21-550a-b679-b198eb07bf6b', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '745c7d05-ddfd-53c1-a55a-09a53459539e';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('e00093c1-0237-5831-98b3-6d0b70948f07', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-15', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', '8f0f0d13-1438-59a8-ae3e-ebba53b8fc30', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '8f0f0d13-1438-59a8-ae3e-ebba53b8fc30';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('e00093c1-0237-5831-98b3-6d0b70948f07', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('e00093c1-0237-5831-98b3-6d0b70948f07', '8f0f0d13-1438-59a8-ae3e-ebba53b8fc30', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'e00093c1-0237-5831-98b3-6d0b70948f07';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('32b5adc1-9283-55e2-9904-96cae6054f56', 'benchmark-funding-af200143-e5c1-491a-a229-bbc97a298f5f-16', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', 'f8fb97dc-13e4-5fc1-b14c-b415ff89ccff', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = 'a1b8039b-3e78-5315-a9d4-02e49ca82d54';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'f8fb97dc-13e4-5fc1-b14c-b415ff89ccff';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('32b5adc1-9283-55e2-9904-96cae6054f56', 'a1b8039b-3e78-5315-a9d4-02e49ca82d54', -1000000000), ('32b5adc1-9283-55e2-9904-96cae6054f56', 'f8fb97dc-13e4-5fc1-b14c-b415ff89ccff', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '32b5adc1-9283-55e2-9904-96cae6054f56';
COMMIT;
