USE ornably_db;
SET NAMES utf8mb4;
-- Order and order-detail sample data.
-- In this schema, order detail is stored in orders_item.
--
-- Run order:
-- 1. 3_account_sample.sql
-- 2. 4_item_sample.sql
-- 3. 6_order_sample.sql
--
-- This file avoids fixed primary keys and does not overwrite existing orders.
-- orders_import_uid is used as the stable natural key for each sample order.
--
-- Order samples
-- - local_user01 / sample-imp-local-user01-001 / 클래식 그린 트리 x1, 웜 화이트 LED 전구 x2
-- - local_user01 / sample-imp-local-user01-002 / 선물 포장 리본 세트 x4
-- - local_user02 / sample-imp-local-user02-001 / 별빛 커튼 조명 x1, 노르딕 도어 리스 x1
-- - local_user03 / sample-imp-local-user03-001 / 스노우 파인 트리 x1, 골드 믹스 오너먼트 볼 x2
-- - local_user04 / sample-imp-local-user04-001 / 산타 세라믹 피규어 x1, 레드 글라스 오너먼트 볼 x2
-- - local_user05 / sample-imp-local-user05-001 / 베리 포인트 리스 x1, 크리스마스 테이블 러너 x1

START TRANSACTION;

INSERT INTO orders (
  account_pk,
  orders_date,
  address_name,
  orders_payment_type,
  orders_import_uid,
  orders_message,
  orders_status
)
SELECT
  a.account_pk,
  '2026-02-01 10:15:00',
  '집',
  'CARD',
  'sample-imp-local-user01-001',
  '문 앞에 놓아주세요.',
  '배송 완료'
FROM account a
WHERE a.account_id = 'local_user01'
  AND NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.orders_import_uid = 'sample-imp-local-user01-001'
  );

INSERT INTO orders (
  account_pk,
  orders_date,
  address_name,
  orders_payment_type,
  orders_import_uid,
  orders_message,
  orders_status
)
SELECT
  a.account_pk,
  '2026-02-08 14:40:00',
  '집',
  'CARD',
  'sample-imp-local-user01-002',
  '부재 시 경비실에 맡겨주세요.',
  '상품 준비중'
FROM account a
WHERE a.account_id = 'local_user01'
  AND NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.orders_import_uid = 'sample-imp-local-user01-002'
  );

INSERT INTO orders (
  account_pk,
  orders_date,
  address_name,
  orders_payment_type,
  orders_import_uid,
  orders_message,
  orders_status
)
SELECT
  a.account_pk,
  '2026-02-11 19:05:00',
  '집',
  'KAKAOPAY',
  'sample-imp-local-user02-001',
  '배송 전 연락 부탁드립니다.',
  '배송중'
FROM account a
WHERE a.account_id = 'local_user02'
  AND NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.orders_import_uid = 'sample-imp-local-user02-001'
  );

INSERT INTO orders (
  account_pk,
  orders_date,
  address_name,
  orders_payment_type,
  orders_import_uid,
  orders_message,
  orders_status
)
SELECT
  a.account_pk,
  '2026-02-18 09:30:00',
  '집',
  'CARD',
  'sample-imp-local-user03-001',
  NULL,
  '배송 완료'
FROM account a
WHERE a.account_id = 'local_user03'
  AND NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.orders_import_uid = 'sample-imp-local-user03-001'
  );

INSERT INTO orders (
  account_pk,
  orders_date,
  address_name,
  orders_payment_type,
  orders_import_uid,
  orders_message,
  orders_status
)
SELECT
  a.account_pk,
  '2026-03-03 16:20:00',
  '집',
  'CARD',
  'sample-imp-local-user04-001',
  '선물용이라 포장 상태 확인 부탁드립니다.',
  '배송 완료'
FROM account a
WHERE a.account_id = 'local_user04'
  AND NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.orders_import_uid = 'sample-imp-local-user04-001'
  );

INSERT INTO orders (
  account_pk,
  orders_date,
  address_name,
  orders_payment_type,
  orders_import_uid,
  orders_message,
  orders_status
)
SELECT
  a.account_pk,
  '2026-03-12 11:10:00',
  '집',
  'CARD',
  'sample-imp-local-user05-001',
  NULL,
  '상품 준비중'
FROM account a
WHERE a.account_id = 'local_user05'
  AND NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.orders_import_uid = 'sample-imp-local-user05-001'
  );

INSERT INTO orders_item (
  orders_pk,
  item_pk,
  orders_item_count,
  orders_item_price
)
SELECT o.orders_pk, i.item_pk, 1, 129000
FROM orders o
JOIN item i ON i.item_name = '클래식 그린 트리'
WHERE o.orders_import_uid = 'sample-imp-local-user01-001'
  AND NOT EXISTS (
    SELECT 1 FROM orders_item oi WHERE oi.orders_pk = o.orders_pk AND oi.item_pk = i.item_pk
  );

INSERT INTO orders_item (
  orders_pk,
  item_pk,
  orders_item_count,
  orders_item_price
)
SELECT o.orders_pk, i.item_pk, 2, 24900
FROM orders o
JOIN item i ON i.item_name = '웜 화이트 LED 전구'
WHERE o.orders_import_uid = 'sample-imp-local-user01-001'
  AND NOT EXISTS (
    SELECT 1 FROM orders_item oi WHERE oi.orders_pk = o.orders_pk AND oi.item_pk = i.item_pk
  );

INSERT INTO orders_item (
  orders_pk,
  item_pk,
  orders_item_count,
  orders_item_price
)
SELECT o.orders_pk, i.item_pk, 4, 9900
FROM orders o
JOIN item i ON i.item_name = '선물 포장 리본 세트'
WHERE o.orders_import_uid = 'sample-imp-local-user01-002'
  AND NOT EXISTS (
    SELECT 1 FROM orders_item oi WHERE oi.orders_pk = o.orders_pk AND oi.item_pk = i.item_pk
  );

INSERT INTO orders_item (
  orders_pk,
  item_pk,
  orders_item_count,
  orders_item_price
)
SELECT o.orders_pk, i.item_pk, 1, 35900
FROM orders o
JOIN item i ON i.item_name = '별빛 커튼 조명'
WHERE o.orders_import_uid = 'sample-imp-local-user02-001'
  AND NOT EXISTS (
    SELECT 1 FROM orders_item oi WHERE oi.orders_pk = o.orders_pk AND oi.item_pk = i.item_pk
  );

INSERT INTO orders_item (
  orders_pk,
  item_pk,
  orders_item_count,
  orders_item_price
)
SELECT o.orders_pk, i.item_pk, 1, 46900
FROM orders o
JOIN item i ON i.item_name = '노르딕 도어 리스'
WHERE o.orders_import_uid = 'sample-imp-local-user02-001'
  AND NOT EXISTS (
    SELECT 1 FROM orders_item oi WHERE oi.orders_pk = o.orders_pk AND oi.item_pk = i.item_pk
  );

INSERT INTO orders_item (
  orders_pk,
  item_pk,
  orders_item_count,
  orders_item_price
)
SELECT o.orders_pk, i.item_pk, 1, 159000
FROM orders o
JOIN item i ON i.item_name = '스노우 파인 트리'
WHERE o.orders_import_uid = 'sample-imp-local-user03-001'
  AND NOT EXISTS (
    SELECT 1 FROM orders_item oi WHERE oi.orders_pk = o.orders_pk AND oi.item_pk = i.item_pk
  );

INSERT INTO orders_item (
  orders_pk,
  item_pk,
  orders_item_count,
  orders_item_price
)
SELECT o.orders_pk, i.item_pk, 2, 22900
FROM orders o
JOIN item i ON i.item_name = '골드 믹스 오너먼트 볼'
WHERE o.orders_import_uid = 'sample-imp-local-user03-001'
  AND NOT EXISTS (
    SELECT 1 FROM orders_item oi WHERE oi.orders_pk = o.orders_pk AND oi.item_pk = i.item_pk
  );

INSERT INTO orders_item (
  orders_pk,
  item_pk,
  orders_item_count,
  orders_item_price
)
SELECT o.orders_pk, i.item_pk, 1, 32900
FROM orders o
JOIN item i ON i.item_name = '산타 세라믹 피규어'
WHERE o.orders_import_uid = 'sample-imp-local-user04-001'
  AND NOT EXISTS (
    SELECT 1 FROM orders_item oi WHERE oi.orders_pk = o.orders_pk AND oi.item_pk = i.item_pk
  );

INSERT INTO orders_item (
  orders_pk,
  item_pk,
  orders_item_count,
  orders_item_price
)
SELECT o.orders_pk, i.item_pk, 2, 18900
FROM orders o
JOIN item i ON i.item_name = '레드 글라스 오너먼트 볼'
WHERE o.orders_import_uid = 'sample-imp-local-user04-001'
  AND NOT EXISTS (
    SELECT 1 FROM orders_item oi WHERE oi.orders_pk = o.orders_pk AND oi.item_pk = i.item_pk
  );

INSERT INTO orders_item (
  orders_pk,
  item_pk,
  orders_item_count,
  orders_item_price
)
SELECT o.orders_pk, i.item_pk, 1, 52900
FROM orders o
JOIN item i ON i.item_name = '베리 포인트 리스'
WHERE o.orders_import_uid = 'sample-imp-local-user05-001'
  AND NOT EXISTS (
    SELECT 1 FROM orders_item oi WHERE oi.orders_pk = o.orders_pk AND oi.item_pk = i.item_pk
  );

INSERT INTO orders_item (
  orders_pk,
  item_pk,
  orders_item_count,
  orders_item_price
)
SELECT o.orders_pk, i.item_pk, 1, 19900
FROM orders o
JOIN item i ON i.item_name = '크리스마스 테이블 러너'
WHERE o.orders_import_uid = 'sample-imp-local-user05-001'
  AND NOT EXISTS (
    SELECT 1 FROM orders_item oi WHERE oi.orders_pk = o.orders_pk AND oi.item_pk = i.item_pk
  );

COMMIT;
