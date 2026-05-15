USE ornably_db;
SET NAMES utf8mb4;
-- Local account/address sample data.
-- This file avoids fixed primary keys and does not overwrite existing accounts.
-- If an account_id already exists, the account row is left as-is.
-- A default address is inserted only when that account has no default address.
--
-- Login samples
-- - name: 김민준 / id: local_user01 / password: 1234 / email: minjun.kim@example.com
-- - name: 이서연 / id: local_user02 / password: 1234 / email: seoyeon.lee@example.com
-- - name: 박지훈 / id: local_user03 / password: 1234 / email: jihoon.park@example.com
-- - name: 최하린 / id: local_user04 / password: 1234 / email: harin.choi@example.com
-- - name: 정도윤 / id: local_user05 / password: 1234 / email: doyoon.jung@example.com
-- - name: 한유나 / id: local_user06 / password: 1234 / email: yuna.han@example.com
--
-- BCrypt password hash for every sample account:
-- $2a$12$PHYVXV3TLpXXzQq.rFLEs.hnEoUwRVbNw1keFnFvAPAEGuFKH4p4S

START TRANSACTION;

INSERT INTO account (
  account_id,
  account_password_hash,
  account_name,
  account_email,
  account_phone,
  account_date,
  account_role,
  account_event_opt_in
)
SELECT
  'local_user01',
  '$2a$12$PHYVXV3TLpXXzQq.rFLEs.hnEoUwRVbNw1keFnFvAPAEGuFKH4p4S',
  '김민준',
  'minjun.kim@example.com',
  '01020010001',
  '2026-01-05',
  'LOCAL',
  1
WHERE NOT EXISTS (
  SELECT 1 FROM account WHERE account_id = 'local_user01'
);

INSERT INTO account (
  account_id,
  account_password_hash,
  account_name,
  account_email,
  account_phone,
  account_date,
  account_role,
  account_event_opt_in
)
SELECT
  'local_user02',
  '$2a$12$PHYVXV3TLpXXzQq.rFLEs.hnEoUwRVbNw1keFnFvAPAEGuFKH4p4S',
  '이서연',
  'seoyeon.lee@example.com',
  '01020010002',
  '2026-01-12',
  'LOCAL',
  0
WHERE NOT EXISTS (
  SELECT 1 FROM account WHERE account_id = 'local_user02'
);

INSERT INTO account (
  account_id,
  account_password_hash,
  account_name,
  account_email,
  account_phone,
  account_date,
  account_role,
  account_event_opt_in
)
SELECT
  'local_user03',
  '$2a$12$PHYVXV3TLpXXzQq.rFLEs.hnEoUwRVbNw1keFnFvAPAEGuFKH4p4S',
  '박지훈',
  'jihoon.park@example.com',
  '01020010003',
  '2026-02-03',
  'LOCAL',
  1
WHERE NOT EXISTS (
  SELECT 1 FROM account WHERE account_id = 'local_user03'
);

INSERT INTO account (
  account_id,
  account_password_hash,
  account_name,
  account_email,
  account_phone,
  account_date,
  account_role,
  account_event_opt_in
)
SELECT
  'local_user04',
  '$2a$12$PHYVXV3TLpXXzQq.rFLEs.hnEoUwRVbNw1keFnFvAPAEGuFKH4p4S',
  '최하린',
  'harin.choi@example.com',
  '01020010004',
  '2026-02-19',
  'LOCAL',
  1
WHERE NOT EXISTS (
  SELECT 1 FROM account WHERE account_id = 'local_user04'
);

INSERT INTO account (
  account_id,
  account_password_hash,
  account_name,
  account_email,
  account_phone,
  account_date,
  account_role,
  account_event_opt_in
)
SELECT
  'local_user05',
  '$2a$12$PHYVXV3TLpXXzQq.rFLEs.hnEoUwRVbNw1keFnFvAPAEGuFKH4p4S',
  '정도윤',
  'doyoon.jung@example.com',
  '01020010005',
  '2026-03-07',
  'LOCAL',
  0
WHERE NOT EXISTS (
  SELECT 1 FROM account WHERE account_id = 'local_user05'
);

INSERT INTO account (
  account_id,
  account_password_hash,
  account_name,
  account_email,
  account_phone,
  account_date,
  account_role,
  account_event_opt_in
)
SELECT
  'local_user06',
  '$2a$12$PHYVXV3TLpXXzQq.rFLEs.hnEoUwRVbNw1keFnFvAPAEGuFKH4p4S',
  '한유나',
  'yuna.han@example.com',
  '01020010006',
  '2026-03-21',
  'LOCAL',
  1
WHERE NOT EXISTS (
  SELECT 1 FROM account WHERE account_id = 'local_user06'
);

INSERT INTO address (
  account_pk,
  address_name,
  address_is_default,
  address_postal_code,
  address_region,
  address_detail
)
SELECT
  a.account_pk,
  '집',
  1,
  '06236',
  '서울특별시 강남구 테헤란로 152',
  '1203호'
FROM account a
WHERE a.account_id = 'local_user01'
  AND NOT EXISTS (
    SELECT 1
    FROM address ad
    WHERE ad.account_pk = a.account_pk
      AND ad.address_is_default = 1
  );

INSERT INTO address (
  account_pk,
  address_name,
  address_is_default,
  address_postal_code,
  address_region,
  address_detail
)
SELECT
  a.account_pk,
  '집',
  1,
  '04524',
  '서울특별시 중구 세종대로 110',
  '본관 3층'
FROM account a
WHERE a.account_id = 'local_user02'
  AND NOT EXISTS (
    SELECT 1
    FROM address ad
    WHERE ad.account_pk = a.account_pk
      AND ad.address_is_default = 1
  );

INSERT INTO address (
  account_pk,
  address_name,
  address_is_default,
  address_postal_code,
  address_region,
  address_detail
)
SELECT
  a.account_pk,
  '집',
  1,
  '13529',
  '경기도 성남시 분당구 판교역로 235',
  'A동 801호'
FROM account a
WHERE a.account_id = 'local_user03'
  AND NOT EXISTS (
    SELECT 1
    FROM address ad
    WHERE ad.account_pk = a.account_pk
      AND ad.address_is_default = 1
  );

INSERT INTO address (
  account_pk,
  address_name,
  address_is_default,
  address_postal_code,
  address_region,
  address_detail
)
SELECT
  a.account_pk,
  '집',
  1,
  '48058',
  '부산광역시 해운대구 센텀중앙로 97',
  '2105호'
FROM account a
WHERE a.account_id = 'local_user04'
  AND NOT EXISTS (
    SELECT 1
    FROM address ad
    WHERE ad.account_pk = a.account_pk
      AND ad.address_is_default = 1
  );

INSERT INTO address (
  account_pk,
  address_name,
  address_is_default,
  address_postal_code,
  address_region,
  address_detail
)
SELECT
  a.account_pk,
  '집',
  1,
  '35229',
  '대전광역시 서구 둔산로 100',
  '402호'
FROM account a
WHERE a.account_id = 'local_user05'
  AND NOT EXISTS (
    SELECT 1
    FROM address ad
    WHERE ad.account_pk = a.account_pk
      AND ad.address_is_default = 1
  );

INSERT INTO address (
  account_pk,
  address_name,
  address_is_default,
  address_postal_code,
  address_region,
  address_detail
)
SELECT
  a.account_pk,
  '집',
  1,
  '41911',
  '대구광역시 중구 달구벌대로 2095',
  '1501호'
FROM account a
WHERE a.account_id = 'local_user06'
  AND NOT EXISTS (
    SELECT 1
    FROM address ad
    WHERE ad.account_pk = a.account_pk
      AND ad.address_is_default = 1
  );

COMMIT;
