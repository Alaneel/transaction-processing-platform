-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('015e7e72-7334-541f-bce4-3c97dd82c41f', 'USER', 'ACTIVE', 'FIC'),
('01afc2eb-b637-5f77-a006-350cc94a06e0', 'USER', 'ACTIVE', 'FIC'),
('0b9b2431-d8da-56ce-9179-7d73ffc9b3cf', 'USER', 'ACTIVE', 'FIC'),
('19eab3a5-d72d-5ba1-b285-9226a23f987b', 'USER', 'ACTIVE', 'FIC'),
('1e6d843f-8a86-5cb1-9e53-bc4a9482a390', 'USER', 'ACTIVE', 'FIC'),
('2cffa5b6-17aa-5729-bac1-03f4190bc7cf', 'USER', 'ACTIVE', 'FIC'),
('2f196b85-38a9-5ea6-a0e8-b4a8650d4103', 'USER', 'ACTIVE', 'FIC'),
('3dea363e-5319-5ddc-ab43-f811944ef5b2', 'USER', 'ACTIVE', 'FIC'),
('444078f3-3015-5ed0-b0f6-532e9d27dded', 'USER', 'ACTIVE', 'FIC'),
('464254cd-23f6-5fd9-8df9-5158a4a7a848', 'USER', 'ACTIVE', 'FIC'),
('50da6c7d-05de-5a66-a9f0-c2edc89f3f01', 'USER', 'ACTIVE', 'FIC'),
('5e85e424-5f35-501b-957b-339fa83fbe96', 'USER', 'ACTIVE', 'FIC'),
('6ee3f8c2-6851-5ce1-a845-ea5a2102abcb', 'USER', 'ACTIVE', 'FIC'),
('731a22c2-257f-58fa-a54c-5d50c5487764', 'USER', 'ACTIVE', 'FIC'),
('74613972-b39a-56d1-bc31-1fd66581b60f', 'USER', 'ACTIVE', 'FIC'),
('79ac5b27-562b-57bc-8ec5-58b52e4f3c36', 'USER', 'ACTIVE', 'FIC'),
('7ac24651-635c-5a90-ab73-a99041efb0aa', 'USER', 'ACTIVE', 'FIC'),
('83ad450e-3377-54d4-b898-574c0f75d1c3', 'USER', 'ACTIVE', 'FIC'),
('8e75b310-aa76-546f-b9ea-2c8f8f82ecc8', 'USER', 'ACTIVE', 'FIC'),
('9be52258-f12a-5a43-878c-345265316c0d', 'ISSUANCE', 'ACTIVE', 'FIC'),
('a0afc0b3-3503-5bad-87ea-fe2d4cf85e47', 'USER', 'ACTIVE', 'FIC'),
('ab96c5e2-9662-51f7-9fbc-72fd1542a09f', 'USER', 'ACTIVE', 'FIC'),
('cfce5104-a2b3-50e9-a643-052130b8ac4a', 'USER', 'ACTIVE', 'FIC'),
('d3310883-61c7-54f6-b58f-c5a89a9afb76', 'USER', 'ACTIVE', 'FIC'),
('d9a083fb-68fa-5ed7-a633-13faca7ae8d9', 'USER', 'ACTIVE', 'FIC'),
('e6effa3b-dbba-5dae-b558-60fe5546bb63', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('015e7e72-7334-541f-bce4-3c97dd82c41f', 0),
('01afc2eb-b637-5f77-a006-350cc94a06e0', 0),
('0b9b2431-d8da-56ce-9179-7d73ffc9b3cf', 0),
('19eab3a5-d72d-5ba1-b285-9226a23f987b', 0),
('1e6d843f-8a86-5cb1-9e53-bc4a9482a390', 0),
('2cffa5b6-17aa-5729-bac1-03f4190bc7cf', 0),
('2f196b85-38a9-5ea6-a0e8-b4a8650d4103', 0),
('3dea363e-5319-5ddc-ab43-f811944ef5b2', 0),
('444078f3-3015-5ed0-b0f6-532e9d27dded', 0),
('464254cd-23f6-5fd9-8df9-5158a4a7a848', 0),
('50da6c7d-05de-5a66-a9f0-c2edc89f3f01', 0),
('5e85e424-5f35-501b-957b-339fa83fbe96', 0),
('6ee3f8c2-6851-5ce1-a845-ea5a2102abcb', 0),
('731a22c2-257f-58fa-a54c-5d50c5487764', 0),
('74613972-b39a-56d1-bc31-1fd66581b60f', 0),
('79ac5b27-562b-57bc-8ec5-58b52e4f3c36', 0),
('7ac24651-635c-5a90-ab73-a99041efb0aa', 0),
('83ad450e-3377-54d4-b898-574c0f75d1c3', 0),
('8e75b310-aa76-546f-b9ea-2c8f8f82ecc8', 0),
('9be52258-f12a-5a43-878c-345265316c0d', 0),
('a0afc0b3-3503-5bad-87ea-fe2d4cf85e47', 0),
('ab96c5e2-9662-51f7-9fbc-72fd1542a09f', 0),
('cfce5104-a2b3-50e9-a643-052130b8ac4a', 0),
('d3310883-61c7-54f6-b58f-c5a89a9afb76', 0),
('d9a083fb-68fa-5ed7-a633-13faca7ae8d9', 0),
('e6effa3b-dbba-5dae-b558-60fe5546bb63', 0);
SELECT account_id FROM balances WHERE account_id IN ('015e7e72-7334-541f-bce4-3c97dd82c41f','01afc2eb-b637-5f77-a006-350cc94a06e0','0b9b2431-d8da-56ce-9179-7d73ffc9b3cf','19eab3a5-d72d-5ba1-b285-9226a23f987b','1e6d843f-8a86-5cb1-9e53-bc4a9482a390','2cffa5b6-17aa-5729-bac1-03f4190bc7cf','2f196b85-38a9-5ea6-a0e8-b4a8650d4103','3dea363e-5319-5ddc-ab43-f811944ef5b2','444078f3-3015-5ed0-b0f6-532e9d27dded','464254cd-23f6-5fd9-8df9-5158a4a7a848','50da6c7d-05de-5a66-a9f0-c2edc89f3f01','5e85e424-5f35-501b-957b-339fa83fbe96','6ee3f8c2-6851-5ce1-a845-ea5a2102abcb','731a22c2-257f-58fa-a54c-5d50c5487764','74613972-b39a-56d1-bc31-1fd66581b60f','79ac5b27-562b-57bc-8ec5-58b52e4f3c36','7ac24651-635c-5a90-ab73-a99041efb0aa','83ad450e-3377-54d4-b898-574c0f75d1c3','8e75b310-aa76-546f-b9ea-2c8f8f82ecc8','9be52258-f12a-5a43-878c-345265316c0d','a0afc0b3-3503-5bad-87ea-fe2d4cf85e47','ab96c5e2-9662-51f7-9fbc-72fd1542a09f','cfce5104-a2b3-50e9-a643-052130b8ac4a','d3310883-61c7-54f6-b58f-c5a89a9afb76','d9a083fb-68fa-5ed7-a633-13faca7ae8d9','e6effa3b-dbba-5dae-b558-60fe5546bb63') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3b36f991-fabb-5219-89b3-a6b211fdc79c', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-0', '9be52258-f12a-5a43-878c-345265316c0d', 'e6effa3b-dbba-5dae-b558-60fe5546bb63', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e6effa3b-dbba-5dae-b558-60fe5546bb63';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3b36f991-fabb-5219-89b3-a6b211fdc79c', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('3b36f991-fabb-5219-89b3-a6b211fdc79c', 'e6effa3b-dbba-5dae-b558-60fe5546bb63', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3b36f991-fabb-5219-89b3-a6b211fdc79c';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f4970092-c23d-56e6-8407-0a8e23517216', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-1', '9be52258-f12a-5a43-878c-345265316c0d', 'd3310883-61c7-54f6-b58f-c5a89a9afb76', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd3310883-61c7-54f6-b58f-c5a89a9afb76';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f4970092-c23d-56e6-8407-0a8e23517216', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('f4970092-c23d-56e6-8407-0a8e23517216', 'd3310883-61c7-54f6-b58f-c5a89a9afb76', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f4970092-c23d-56e6-8407-0a8e23517216';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('34b55cc3-9870-5029-909e-42824d3649a6', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-2', '9be52258-f12a-5a43-878c-345265316c0d', '01afc2eb-b637-5f77-a006-350cc94a06e0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '01afc2eb-b637-5f77-a006-350cc94a06e0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('34b55cc3-9870-5029-909e-42824d3649a6', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('34b55cc3-9870-5029-909e-42824d3649a6', '01afc2eb-b637-5f77-a006-350cc94a06e0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '34b55cc3-9870-5029-909e-42824d3649a6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('b0ce5449-43fc-5d48-8c3c-e8fec755bba6', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-3', '9be52258-f12a-5a43-878c-345265316c0d', 'cfce5104-a2b3-50e9-a643-052130b8ac4a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'cfce5104-a2b3-50e9-a643-052130b8ac4a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('b0ce5449-43fc-5d48-8c3c-e8fec755bba6', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('b0ce5449-43fc-5d48-8c3c-e8fec755bba6', 'cfce5104-a2b3-50e9-a643-052130b8ac4a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'b0ce5449-43fc-5d48-8c3c-e8fec755bba6';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('5c7fa7a0-2325-5456-9b6f-3675715eff1b', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-4', '9be52258-f12a-5a43-878c-345265316c0d', '6ee3f8c2-6851-5ce1-a845-ea5a2102abcb', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '6ee3f8c2-6851-5ce1-a845-ea5a2102abcb';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('5c7fa7a0-2325-5456-9b6f-3675715eff1b', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('5c7fa7a0-2325-5456-9b6f-3675715eff1b', '6ee3f8c2-6851-5ce1-a845-ea5a2102abcb', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '5c7fa7a0-2325-5456-9b6f-3675715eff1b';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9859baee-5e9a-5fcb-b723-4bb71fead898', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-5', '9be52258-f12a-5a43-878c-345265316c0d', '2f196b85-38a9-5ea6-a0e8-b4a8650d4103', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2f196b85-38a9-5ea6-a0e8-b4a8650d4103';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9859baee-5e9a-5fcb-b723-4bb71fead898', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('9859baee-5e9a-5fcb-b723-4bb71fead898', '2f196b85-38a9-5ea6-a0e8-b4a8650d4103', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9859baee-5e9a-5fcb-b723-4bb71fead898';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1e2bc592-13c5-534c-b351-eab58ac729da', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-6', '9be52258-f12a-5a43-878c-345265316c0d', '50da6c7d-05de-5a66-a9f0-c2edc89f3f01', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '50da6c7d-05de-5a66-a9f0-c2edc89f3f01';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1e2bc592-13c5-534c-b351-eab58ac729da', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('1e2bc592-13c5-534c-b351-eab58ac729da', '50da6c7d-05de-5a66-a9f0-c2edc89f3f01', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1e2bc592-13c5-534c-b351-eab58ac729da';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d48cc8aa-c8c4-5cec-a5f2-b5c036f00b99', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-7', '9be52258-f12a-5a43-878c-345265316c0d', '2cffa5b6-17aa-5729-bac1-03f4190bc7cf', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '2cffa5b6-17aa-5729-bac1-03f4190bc7cf';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d48cc8aa-c8c4-5cec-a5f2-b5c036f00b99', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('d48cc8aa-c8c4-5cec-a5f2-b5c036f00b99', '2cffa5b6-17aa-5729-bac1-03f4190bc7cf', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd48cc8aa-c8c4-5cec-a5f2-b5c036f00b99';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9e2248f5-3760-573b-845f-c9ac415ea790', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-8', '9be52258-f12a-5a43-878c-345265316c0d', '1e6d843f-8a86-5cb1-9e53-bc4a9482a390', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '1e6d843f-8a86-5cb1-9e53-bc4a9482a390';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9e2248f5-3760-573b-845f-c9ac415ea790', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('9e2248f5-3760-573b-845f-c9ac415ea790', '1e6d843f-8a86-5cb1-9e53-bc4a9482a390', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9e2248f5-3760-573b-845f-c9ac415ea790';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f1df460b-c179-5e87-bcd9-cc14685c80e0', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-9', '9be52258-f12a-5a43-878c-345265316c0d', '3dea363e-5319-5ddc-ab43-f811944ef5b2', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3dea363e-5319-5ddc-ab43-f811944ef5b2';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f1df460b-c179-5e87-bcd9-cc14685c80e0', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('f1df460b-c179-5e87-bcd9-cc14685c80e0', '3dea363e-5319-5ddc-ab43-f811944ef5b2', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f1df460b-c179-5e87-bcd9-cc14685c80e0';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('9578ebdc-b7a5-50ab-849e-34db02d08285', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-10', '9be52258-f12a-5a43-878c-345265316c0d', '464254cd-23f6-5fd9-8df9-5158a4a7a848', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '464254cd-23f6-5fd9-8df9-5158a4a7a848';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('9578ebdc-b7a5-50ab-849e-34db02d08285', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('9578ebdc-b7a5-50ab-849e-34db02d08285', '464254cd-23f6-5fd9-8df9-5158a4a7a848', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '9578ebdc-b7a5-50ab-849e-34db02d08285';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('94ec7a4c-635e-584a-a465-b4174ad26f61', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-11', '9be52258-f12a-5a43-878c-345265316c0d', '7ac24651-635c-5a90-ab73-a99041efb0aa', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '7ac24651-635c-5a90-ab73-a99041efb0aa';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('94ec7a4c-635e-584a-a465-b4174ad26f61', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('94ec7a4c-635e-584a-a465-b4174ad26f61', '7ac24651-635c-5a90-ab73-a99041efb0aa', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '94ec7a4c-635e-584a-a465-b4174ad26f61';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('fdfb6c88-ca87-50d4-a3fe-0486c54261dc', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-12', '9be52258-f12a-5a43-878c-345265316c0d', '0b9b2431-d8da-56ce-9179-7d73ffc9b3cf', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0b9b2431-d8da-56ce-9179-7d73ffc9b3cf';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('fdfb6c88-ca87-50d4-a3fe-0486c54261dc', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('fdfb6c88-ca87-50d4-a3fe-0486c54261dc', '0b9b2431-d8da-56ce-9179-7d73ffc9b3cf', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'fdfb6c88-ca87-50d4-a3fe-0486c54261dc';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('3af3aa65-8fd4-5f3f-bdc5-62c3cf8741ff', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-13', '9be52258-f12a-5a43-878c-345265316c0d', '83ad450e-3377-54d4-b898-574c0f75d1c3', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '83ad450e-3377-54d4-b898-574c0f75d1c3';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('3af3aa65-8fd4-5f3f-bdc5-62c3cf8741ff', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('3af3aa65-8fd4-5f3f-bdc5-62c3cf8741ff', '83ad450e-3377-54d4-b898-574c0f75d1c3', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '3af3aa65-8fd4-5f3f-bdc5-62c3cf8741ff';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('49592fbb-c5d0-5b58-b564-616b7bbb183d', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-14', '9be52258-f12a-5a43-878c-345265316c0d', '79ac5b27-562b-57bc-8ec5-58b52e4f3c36', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '79ac5b27-562b-57bc-8ec5-58b52e4f3c36';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('49592fbb-c5d0-5b58-b564-616b7bbb183d', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('49592fbb-c5d0-5b58-b564-616b7bbb183d', '79ac5b27-562b-57bc-8ec5-58b52e4f3c36', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '49592fbb-c5d0-5b58-b564-616b7bbb183d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('42cf42fa-9d0e-5a3e-b426-c38ac91a1dad', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-15', '9be52258-f12a-5a43-878c-345265316c0d', 'd9a083fb-68fa-5ed7-a633-13faca7ae8d9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd9a083fb-68fa-5ed7-a633-13faca7ae8d9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('42cf42fa-9d0e-5a3e-b426-c38ac91a1dad', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('42cf42fa-9d0e-5a3e-b426-c38ac91a1dad', 'd9a083fb-68fa-5ed7-a633-13faca7ae8d9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '42cf42fa-9d0e-5a3e-b426-c38ac91a1dad';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('57a5d215-4634-56c6-830a-be6d07cb1b6c', 'benchmark-funding-8f5e7247-feaa-4b63-86cb-2b492c83c90d-16', '9be52258-f12a-5a43-878c-345265316c0d', 'a0afc0b3-3503-5bad-87ea-fe2d4cf85e47', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '9be52258-f12a-5a43-878c-345265316c0d';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'a0afc0b3-3503-5bad-87ea-fe2d4cf85e47';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('57a5d215-4634-56c6-830a-be6d07cb1b6c', '9be52258-f12a-5a43-878c-345265316c0d', -1000000000), ('57a5d215-4634-56c6-830a-be6d07cb1b6c', 'a0afc0b3-3503-5bad-87ea-fe2d4cf85e47', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '57a5d215-4634-56c6-830a-be6d07cb1b6c';
COMMIT;
