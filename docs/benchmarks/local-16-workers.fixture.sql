-- Isolated benchmark fixture. Run using the migration owner on a development database.
-- Reusing this fixture intentionally fails instead of mutating prior financial history.
BEGIN;
INSERT INTO accounts (id, kind, status, unit) VALUES
('03647be3-0f8c-55a4-a5ad-e17a237e0513', 'USER', 'ACTIVE', 'FIC'),
('08fe0053-1197-5675-80d3-f73717e88a25', 'USER', 'ACTIVE', 'FIC'),
('0accc2cf-476c-5b33-8d01-36542b48a02a', 'USER', 'ACTIVE', 'FIC'),
('0c23aa01-d4d8-5433-b541-ccad26536aaa', 'ISSUANCE', 'ACTIVE', 'FIC'),
('106a3596-f3da-56d3-90c8-b02b52d6b7b1', 'USER', 'ACTIVE', 'FIC'),
('1504118b-a57b-591d-874a-6507625e958a', 'USER', 'ACTIVE', 'FIC'),
('16c3849e-549e-5fda-93ce-d9bc3aec0545', 'USER', 'ACTIVE', 'FIC'),
('18bce2c1-7ccb-54e6-af4a-3d8ad684b809', 'USER', 'ACTIVE', 'FIC'),
('19eaae0c-12d7-533d-adea-77a3a30cf9e0', 'USER', 'ACTIVE', 'FIC'),
('20be7c42-fb14-57ef-aba7-11f45cd25d95', 'USER', 'ACTIVE', 'FIC'),
('2628bd77-2030-5ae7-8a9e-8aff574ed4cd', 'USER', 'ACTIVE', 'FIC'),
('2c378e4e-bfb2-590c-b39a-b28f2dc63f13', 'USER', 'ACTIVE', 'FIC'),
('34ed74dd-fab2-5122-ad37-79d7a24797db', 'USER', 'ACTIVE', 'FIC'),
('3505eb8b-e90e-5106-8dcc-2a3b46d7430a', 'USER', 'ACTIVE', 'FIC'),
('3bfec6d2-f548-503d-bda2-859c01b52fa4', 'USER', 'ACTIVE', 'FIC'),
('3f54303c-fdef-5ad6-aece-7ae0ba20a0d9', 'USER', 'ACTIVE', 'FIC'),
('428d2643-9cd1-5cb4-a88d-c97a4bb5133e', 'USER', 'ACTIVE', 'FIC'),
('443f60bf-147c-5059-9ba0-117bda0f764d', 'USER', 'ACTIVE', 'FIC'),
('4dfdbbe9-1357-5777-944c-7d2ae2e2e662', 'USER', 'ACTIVE', 'FIC'),
('516c290f-df8e-5e49-bbb0-4a825bbe9a2e', 'USER', 'ACTIVE', 'FIC'),
('546829e7-8be6-50b2-b875-aaae42904cb6', 'USER', 'ACTIVE', 'FIC'),
('56960191-06e7-53d1-b546-791ece2ab6c4', 'USER', 'ACTIVE', 'FIC'),
('56cff8ae-884a-5521-b0c7-98c2ddc7b06f', 'USER', 'ACTIVE', 'FIC'),
('5ae0cb68-e132-5a1e-a4d0-e4cffe7696bc', 'USER', 'ACTIVE', 'FIC'),
('5e7fa689-7961-5268-9b80-bd21db5565ed', 'USER', 'ACTIVE', 'FIC'),
('616d91f2-8b9d-5315-8888-2c723226beff', 'USER', 'ACTIVE', 'FIC'),
('625d38aa-9ff5-53fe-bfb7-df55c698abac', 'USER', 'ACTIVE', 'FIC'),
('6414afd3-1fea-5232-8718-f160f8a16eb8', 'USER', 'ACTIVE', 'FIC'),
('6a44f0f5-c616-505c-a23c-c7739d70a809', 'USER', 'ACTIVE', 'FIC'),
('7bab3fb0-f05c-51fc-972f-77bca015f00e', 'USER', 'ACTIVE', 'FIC'),
('870f3535-cfee-5a5d-b49d-03439c57d048', 'USER', 'ACTIVE', 'FIC'),
('8aa1d593-dff3-5789-8668-d24d7686816f', 'USER', 'ACTIVE', 'FIC'),
('91fb27cf-a752-59c1-9d55-c617c59d01e0', 'USER', 'ACTIVE', 'FIC'),
('97033b94-1602-5e0c-a4ba-7f24a64c2c4a', 'USER', 'ACTIVE', 'FIC'),
('adbd268d-6abc-5af1-b6b1-cdef54cf92b7', 'USER', 'ACTIVE', 'FIC'),
('aeb64fc4-4b84-5bb1-861f-c6ed78d7fb31', 'USER', 'ACTIVE', 'FIC'),
('af27ae3f-44f2-5f91-acb6-42f8e8587976', 'USER', 'ACTIVE', 'FIC'),
('b79ce17c-256f-5982-bec9-aebc84c068b6', 'USER', 'ACTIVE', 'FIC'),
('bbace786-dce9-5b01-a991-44d5cac4ca3a', 'USER', 'ACTIVE', 'FIC'),
('c25b5034-c648-5a8d-ab54-37328372a28a', 'USER', 'ACTIVE', 'FIC'),
('cf90ce99-040c-5dc4-aff9-490eebdfebb7', 'USER', 'ACTIVE', 'FIC'),
('d31e5bf9-3a2b-5392-8aa6-5d90b6f72328', 'USER', 'ACTIVE', 'FIC'),
('d42700e6-5f6c-5b8c-9de5-538fe10f84ea', 'USER', 'ACTIVE', 'FIC'),
('d5d9e09e-1d3c-5d01-8884-73efbcc45edf', 'USER', 'ACTIVE', 'FIC'),
('d735e8ec-eb57-5210-9f81-0a403daa59cd', 'USER', 'ACTIVE', 'FIC'),
('e77d4b9f-63d4-5291-95f1-0e2202832c8b', 'USER', 'ACTIVE', 'FIC'),
('e8f4fdaf-fae2-5cd7-9067-c03c7ddbb123', 'USER', 'ACTIVE', 'FIC'),
('eb1272e6-3fbf-527d-8c6f-587e5394cbae', 'USER', 'ACTIVE', 'FIC'),
('f04f10b2-d926-568f-b310-1329158155dd', 'USER', 'ACTIVE', 'FIC'),
('f26e7c5d-213e-5359-86f3-c3d8dfedc8a1', 'USER', 'ACTIVE', 'FIC');
INSERT INTO balances (account_id, amount) VALUES
('03647be3-0f8c-55a4-a5ad-e17a237e0513', 0),
('08fe0053-1197-5675-80d3-f73717e88a25', 0),
('0accc2cf-476c-5b33-8d01-36542b48a02a', 0),
('0c23aa01-d4d8-5433-b541-ccad26536aaa', 0),
('106a3596-f3da-56d3-90c8-b02b52d6b7b1', 0),
('1504118b-a57b-591d-874a-6507625e958a', 0),
('16c3849e-549e-5fda-93ce-d9bc3aec0545', 0),
('18bce2c1-7ccb-54e6-af4a-3d8ad684b809', 0),
('19eaae0c-12d7-533d-adea-77a3a30cf9e0', 0),
('20be7c42-fb14-57ef-aba7-11f45cd25d95', 0),
('2628bd77-2030-5ae7-8a9e-8aff574ed4cd', 0),
('2c378e4e-bfb2-590c-b39a-b28f2dc63f13', 0),
('34ed74dd-fab2-5122-ad37-79d7a24797db', 0),
('3505eb8b-e90e-5106-8dcc-2a3b46d7430a', 0),
('3bfec6d2-f548-503d-bda2-859c01b52fa4', 0),
('3f54303c-fdef-5ad6-aece-7ae0ba20a0d9', 0),
('428d2643-9cd1-5cb4-a88d-c97a4bb5133e', 0),
('443f60bf-147c-5059-9ba0-117bda0f764d', 0),
('4dfdbbe9-1357-5777-944c-7d2ae2e2e662', 0),
('516c290f-df8e-5e49-bbb0-4a825bbe9a2e', 0),
('546829e7-8be6-50b2-b875-aaae42904cb6', 0),
('56960191-06e7-53d1-b546-791ece2ab6c4', 0),
('56cff8ae-884a-5521-b0c7-98c2ddc7b06f', 0),
('5ae0cb68-e132-5a1e-a4d0-e4cffe7696bc', 0),
('5e7fa689-7961-5268-9b80-bd21db5565ed', 0),
('616d91f2-8b9d-5315-8888-2c723226beff', 0),
('625d38aa-9ff5-53fe-bfb7-df55c698abac', 0),
('6414afd3-1fea-5232-8718-f160f8a16eb8', 0),
('6a44f0f5-c616-505c-a23c-c7739d70a809', 0),
('7bab3fb0-f05c-51fc-972f-77bca015f00e', 0),
('870f3535-cfee-5a5d-b49d-03439c57d048', 0),
('8aa1d593-dff3-5789-8668-d24d7686816f', 0),
('91fb27cf-a752-59c1-9d55-c617c59d01e0', 0),
('97033b94-1602-5e0c-a4ba-7f24a64c2c4a', 0),
('adbd268d-6abc-5af1-b6b1-cdef54cf92b7', 0),
('aeb64fc4-4b84-5bb1-861f-c6ed78d7fb31', 0),
('af27ae3f-44f2-5f91-acb6-42f8e8587976', 0),
('b79ce17c-256f-5982-bec9-aebc84c068b6', 0),
('bbace786-dce9-5b01-a991-44d5cac4ca3a', 0),
('c25b5034-c648-5a8d-ab54-37328372a28a', 0),
('cf90ce99-040c-5dc4-aff9-490eebdfebb7', 0),
('d31e5bf9-3a2b-5392-8aa6-5d90b6f72328', 0),
('d42700e6-5f6c-5b8c-9de5-538fe10f84ea', 0),
('d5d9e09e-1d3c-5d01-8884-73efbcc45edf', 0),
('d735e8ec-eb57-5210-9f81-0a403daa59cd', 0),
('e77d4b9f-63d4-5291-95f1-0e2202832c8b', 0),
('e8f4fdaf-fae2-5cd7-9067-c03c7ddbb123', 0),
('eb1272e6-3fbf-527d-8c6f-587e5394cbae', 0),
('f04f10b2-d926-568f-b310-1329158155dd', 0),
('f26e7c5d-213e-5359-86f3-c3d8dfedc8a1', 0);
SELECT account_id FROM balances WHERE account_id IN ('03647be3-0f8c-55a4-a5ad-e17a237e0513','08fe0053-1197-5675-80d3-f73717e88a25','0accc2cf-476c-5b33-8d01-36542b48a02a','0c23aa01-d4d8-5433-b541-ccad26536aaa','106a3596-f3da-56d3-90c8-b02b52d6b7b1','1504118b-a57b-591d-874a-6507625e958a','16c3849e-549e-5fda-93ce-d9bc3aec0545','18bce2c1-7ccb-54e6-af4a-3d8ad684b809','19eaae0c-12d7-533d-adea-77a3a30cf9e0','20be7c42-fb14-57ef-aba7-11f45cd25d95','2628bd77-2030-5ae7-8a9e-8aff574ed4cd','2c378e4e-bfb2-590c-b39a-b28f2dc63f13','34ed74dd-fab2-5122-ad37-79d7a24797db','3505eb8b-e90e-5106-8dcc-2a3b46d7430a','3bfec6d2-f548-503d-bda2-859c01b52fa4','3f54303c-fdef-5ad6-aece-7ae0ba20a0d9','428d2643-9cd1-5cb4-a88d-c97a4bb5133e','443f60bf-147c-5059-9ba0-117bda0f764d','4dfdbbe9-1357-5777-944c-7d2ae2e2e662','516c290f-df8e-5e49-bbb0-4a825bbe9a2e','546829e7-8be6-50b2-b875-aaae42904cb6','56960191-06e7-53d1-b546-791ece2ab6c4','56cff8ae-884a-5521-b0c7-98c2ddc7b06f','5ae0cb68-e132-5a1e-a4d0-e4cffe7696bc','5e7fa689-7961-5268-9b80-bd21db5565ed','616d91f2-8b9d-5315-8888-2c723226beff','625d38aa-9ff5-53fe-bfb7-df55c698abac','6414afd3-1fea-5232-8718-f160f8a16eb8','6a44f0f5-c616-505c-a23c-c7739d70a809','7bab3fb0-f05c-51fc-972f-77bca015f00e','870f3535-cfee-5a5d-b49d-03439c57d048','8aa1d593-dff3-5789-8668-d24d7686816f','91fb27cf-a752-59c1-9d55-c617c59d01e0','97033b94-1602-5e0c-a4ba-7f24a64c2c4a','adbd268d-6abc-5af1-b6b1-cdef54cf92b7','aeb64fc4-4b84-5bb1-861f-c6ed78d7fb31','af27ae3f-44f2-5f91-acb6-42f8e8587976','b79ce17c-256f-5982-bec9-aebc84c068b6','bbace786-dce9-5b01-a991-44d5cac4ca3a','c25b5034-c648-5a8d-ab54-37328372a28a','cf90ce99-040c-5dc4-aff9-490eebdfebb7','d31e5bf9-3a2b-5392-8aa6-5d90b6f72328','d42700e6-5f6c-5b8c-9de5-538fe10f84ea','d5d9e09e-1d3c-5d01-8884-73efbcc45edf','d735e8ec-eb57-5210-9f81-0a403daa59cd','e77d4b9f-63d4-5291-95f1-0e2202832c8b','e8f4fdaf-fae2-5cd7-9067-c03c7ddbb123','eb1272e6-3fbf-527d-8c6f-587e5394cbae','f04f10b2-d926-568f-b310-1329158155dd','f26e7c5d-213e-5359-86f3-c3d8dfedc8a1') ORDER BY account_id FOR UPDATE;
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('eb0cff81-8c4b-5abf-af42-fcaa5d032757', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-0', '0c23aa01-d4d8-5433-b541-ccad26536aaa', '5ae0cb68-e132-5a1e-a4d0-e4cffe7696bc', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '5ae0cb68-e132-5a1e-a4d0-e4cffe7696bc';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('eb0cff81-8c4b-5abf-af42-fcaa5d032757', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('eb0cff81-8c4b-5abf-af42-fcaa5d032757', '5ae0cb68-e132-5a1e-a4d0-e4cffe7696bc', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'eb0cff81-8c4b-5abf-af42-fcaa5d032757';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d49280aa-9baa-5680-bdf0-d35b9987729d', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-1', '0c23aa01-d4d8-5433-b541-ccad26536aaa', '4dfdbbe9-1357-5777-944c-7d2ae2e2e662', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '4dfdbbe9-1357-5777-944c-7d2ae2e2e662';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d49280aa-9baa-5680-bdf0-d35b9987729d', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('d49280aa-9baa-5680-bdf0-d35b9987729d', '4dfdbbe9-1357-5777-944c-7d2ae2e2e662', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd49280aa-9baa-5680-bdf0-d35b9987729d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('d06098bf-2a18-55f9-a652-b7a99db1bd9a', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-2', '0c23aa01-d4d8-5433-b541-ccad26536aaa', '03647be3-0f8c-55a4-a5ad-e17a237e0513', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '03647be3-0f8c-55a4-a5ad-e17a237e0513';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('d06098bf-2a18-55f9-a652-b7a99db1bd9a', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('d06098bf-2a18-55f9-a652-b7a99db1bd9a', '03647be3-0f8c-55a4-a5ad-e17a237e0513', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'd06098bf-2a18-55f9-a652-b7a99db1bd9a';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('94fc49e7-2c74-513a-9abd-8f8be05d5b61', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-3', '0c23aa01-d4d8-5433-b541-ccad26536aaa', 'aeb64fc4-4b84-5bb1-861f-c6ed78d7fb31', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'aeb64fc4-4b84-5bb1-861f-c6ed78d7fb31';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('94fc49e7-2c74-513a-9abd-8f8be05d5b61', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('94fc49e7-2c74-513a-9abd-8f8be05d5b61', 'aeb64fc4-4b84-5bb1-861f-c6ed78d7fb31', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '94fc49e7-2c74-513a-9abd-8f8be05d5b61';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('593884ae-2a76-5fd3-8c40-3eca497a5ff1', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-4', '0c23aa01-d4d8-5433-b541-ccad26536aaa', '616d91f2-8b9d-5315-8888-2c723226beff', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '616d91f2-8b9d-5315-8888-2c723226beff';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('593884ae-2a76-5fd3-8c40-3eca497a5ff1', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('593884ae-2a76-5fd3-8c40-3eca497a5ff1', '616d91f2-8b9d-5315-8888-2c723226beff', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '593884ae-2a76-5fd3-8c40-3eca497a5ff1';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('7eae1f36-4ac5-5306-8457-27ca43f3a4e5', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-5', '0c23aa01-d4d8-5433-b541-ccad26536aaa', '106a3596-f3da-56d3-90c8-b02b52d6b7b1', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '106a3596-f3da-56d3-90c8-b02b52d6b7b1';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('7eae1f36-4ac5-5306-8457-27ca43f3a4e5', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('7eae1f36-4ac5-5306-8457-27ca43f3a4e5', '106a3596-f3da-56d3-90c8-b02b52d6b7b1', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '7eae1f36-4ac5-5306-8457-27ca43f3a4e5';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a0c28ae6-6f2b-55e2-bed2-a179c8589c73', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-6', '0c23aa01-d4d8-5433-b541-ccad26536aaa', '516c290f-df8e-5e49-bbb0-4a825bbe9a2e', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '516c290f-df8e-5e49-bbb0-4a825bbe9a2e';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a0c28ae6-6f2b-55e2-bed2-a179c8589c73', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('a0c28ae6-6f2b-55e2-bed2-a179c8589c73', '516c290f-df8e-5e49-bbb0-4a825bbe9a2e', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a0c28ae6-6f2b-55e2-bed2-a179c8589c73';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('0463953e-f968-53b1-8b81-b8f8d2c70fe2', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-7', '0c23aa01-d4d8-5433-b541-ccad26536aaa', '0accc2cf-476c-5b33-8d01-36542b48a02a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '0accc2cf-476c-5b33-8d01-36542b48a02a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('0463953e-f968-53b1-8b81-b8f8d2c70fe2', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('0463953e-f968-53b1-8b81-b8f8d2c70fe2', '0accc2cf-476c-5b33-8d01-36542b48a02a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '0463953e-f968-53b1-8b81-b8f8d2c70fe2';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('934339a6-6025-5d29-b293-e4c1e448f3f4', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-8', '0c23aa01-d4d8-5433-b541-ccad26536aaa', 'e8f4fdaf-fae2-5cd7-9067-c03c7ddbb123', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'e8f4fdaf-fae2-5cd7-9067-c03c7ddbb123';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('934339a6-6025-5d29-b293-e4c1e448f3f4', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('934339a6-6025-5d29-b293-e4c1e448f3f4', 'e8f4fdaf-fae2-5cd7-9067-c03c7ddbb123', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '934339a6-6025-5d29-b293-e4c1e448f3f4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('fc3edc40-bf6f-50a8-8d46-0000b5e7e137', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-9', '0c23aa01-d4d8-5433-b541-ccad26536aaa', 'd735e8ec-eb57-5210-9f81-0a403daa59cd', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'd735e8ec-eb57-5210-9f81-0a403daa59cd';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('fc3edc40-bf6f-50a8-8d46-0000b5e7e137', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('fc3edc40-bf6f-50a8-8d46-0000b5e7e137', 'd735e8ec-eb57-5210-9f81-0a403daa59cd', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'fc3edc40-bf6f-50a8-8d46-0000b5e7e137';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('88b3eb83-8b2a-5e69-95f4-28705539981f', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-10', '0c23aa01-d4d8-5433-b541-ccad26536aaa', 'c25b5034-c648-5a8d-ab54-37328372a28a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'c25b5034-c648-5a8d-ab54-37328372a28a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('88b3eb83-8b2a-5e69-95f4-28705539981f', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('88b3eb83-8b2a-5e69-95f4-28705539981f', 'c25b5034-c648-5a8d-ab54-37328372a28a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '88b3eb83-8b2a-5e69-95f4-28705539981f';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('1abc4e66-b6c6-5a5c-b7b1-b3b5123e24d4', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-11', '0c23aa01-d4d8-5433-b541-ccad26536aaa', '56cff8ae-884a-5521-b0c7-98c2ddc7b06f', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '56cff8ae-884a-5521-b0c7-98c2ddc7b06f';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('1abc4e66-b6c6-5a5c-b7b1-b3b5123e24d4', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('1abc4e66-b6c6-5a5c-b7b1-b3b5123e24d4', '56cff8ae-884a-5521-b0c7-98c2ddc7b06f', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '1abc4e66-b6c6-5a5c-b7b1-b3b5123e24d4';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('629421bb-72c1-578c-9f88-5743949b959d', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-12', '0c23aa01-d4d8-5433-b541-ccad26536aaa', '19eaae0c-12d7-533d-adea-77a3a30cf9e0', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '19eaae0c-12d7-533d-adea-77a3a30cf9e0';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('629421bb-72c1-578c-9f88-5743949b959d', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('629421bb-72c1-578c-9f88-5743949b959d', '19eaae0c-12d7-533d-adea-77a3a30cf9e0', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '629421bb-72c1-578c-9f88-5743949b959d';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('31c83c02-5d95-53bf-a3fb-a31fed382eeb', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-13', '0c23aa01-d4d8-5433-b541-ccad26536aaa', '443f60bf-147c-5059-9ba0-117bda0f764d', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '443f60bf-147c-5059-9ba0-117bda0f764d';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('31c83c02-5d95-53bf-a3fb-a31fed382eeb', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('31c83c02-5d95-53bf-a3fb-a31fed382eeb', '443f60bf-147c-5059-9ba0-117bda0f764d', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '31c83c02-5d95-53bf-a3fb-a31fed382eeb';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('2418d9a3-457e-5f4c-90e6-53e2708e9920', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-14', '0c23aa01-d4d8-5433-b541-ccad26536aaa', 'bbace786-dce9-5b01-a991-44d5cac4ca3a', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'bbace786-dce9-5b01-a991-44d5cac4ca3a';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('2418d9a3-457e-5f4c-90e6-53e2708e9920', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('2418d9a3-457e-5f4c-90e6-53e2708e9920', 'bbace786-dce9-5b01-a991-44d5cac4ca3a', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = '2418d9a3-457e-5f4c-90e6-53e2708e9920';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('a4baa0c7-887f-5cd7-9b33-e4d78fa8f6ae', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-15', '0c23aa01-d4d8-5433-b541-ccad26536aaa', '3f54303c-fdef-5ad6-aece-7ae0ba20a0d9', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = '3f54303c-fdef-5ad6-aece-7ae0ba20a0d9';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('a4baa0c7-887f-5cd7-9b33-e4d78fa8f6ae', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('a4baa0c7-887f-5cd7-9b33-e4d78fa8f6ae', '3f54303c-fdef-5ad6-aece-7ae0ba20a0d9', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'a4baa0c7-887f-5cd7-9b33-e4d78fa8f6ae';
INSERT INTO transfers (id, idempotency_key, source_account_id, destination_account_id, amount, unit, status) VALUES ('f674fc21-5947-5dbd-8950-6857f63b4913', 'benchmark-funding-ab606de1-3a18-4f76-b2bc-3c05c0e33bbf-16', '0c23aa01-d4d8-5433-b541-ccad26536aaa', 'adbd268d-6abc-5af1-b6b1-cdef54cf92b7', 1000000000, 'FIC', 'PROCESSING');
UPDATE balances SET amount = amount - 1000000000 WHERE account_id = '0c23aa01-d4d8-5433-b541-ccad26536aaa';
UPDATE balances SET amount = amount + 1000000000 WHERE account_id = 'adbd268d-6abc-5af1-b6b1-cdef54cf92b7';
INSERT INTO ledger_entries (transfer_id, account_id, delta) VALUES ('f674fc21-5947-5dbd-8950-6857f63b4913', '0c23aa01-d4d8-5433-b541-ccad26536aaa', -1000000000), ('f674fc21-5947-5dbd-8950-6857f63b4913', 'adbd268d-6abc-5af1-b6b1-cdef54cf92b7', 1000000000);
UPDATE transfers SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE id = 'f674fc21-5947-5dbd-8950-6857f63b4913';
COMMIT;
