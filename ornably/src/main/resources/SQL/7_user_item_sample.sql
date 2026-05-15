USE ornably_db;
SET NAMES utf8mb4;
-- User cart, wishlist, and item-detail sample data.
-- Run order:
-- 1. 3_account_sample.sql
-- 2. 4_item_sample.sql
-- 3. 5_event_sample.sql
-- 4. 7_user_item_sample.sql
--
-- This file avoids fixed primary keys and does not overwrite existing rows.
-- It uses account.account_id and item.item_name to find FK values.
--
-- Cart samples
-- - local_user01: 클래식 그린 트리 x1, 웜 화이트 LED 전구 x2, 레드 글라스 오너먼트 볼 x3
-- - local_user02: 별빛 커튼 조명 x1, 노르딕 도어 리스 x1
-- - local_user03: 스노우 파인 트리 x1, 골드 믹스 오너먼트 볼 x2
--
-- Wishlist samples
-- - local_user01: 별빛 커튼 조명, 노르딕 도어 리스, 선물 포장 리본 세트
-- - local_user02: 클래식 그린 트리, 산타 세라믹 피규어
-- - local_user03: 베리 포인트 리스, 크리스마스 테이블 러너
-- - local_user04: 스노우 파인 트리, 웜 화이트 LED 전구
--
-- Item-detail samples are represented by review rows for detail pages.

START TRANSACTION;

INSERT INTO cart (account_pk, item_pk, cart_count)
SELECT a.account_pk, i.item_pk, 1
FROM account a
JOIN item i ON i.item_name = '클래식 그린 트리'
WHERE a.account_id = 'local_user01'
  AND NOT EXISTS (
    SELECT 1 FROM cart c WHERE c.account_pk = a.account_pk AND c.item_pk = i.item_pk
  );

INSERT INTO cart (account_pk, item_pk, cart_count)
SELECT a.account_pk, i.item_pk, 2
FROM account a
JOIN item i ON i.item_name = '웜 화이트 LED 전구'
WHERE a.account_id = 'local_user01'
  AND NOT EXISTS (
    SELECT 1 FROM cart c WHERE c.account_pk = a.account_pk AND c.item_pk = i.item_pk
  );

INSERT INTO cart (account_pk, item_pk, cart_count)
SELECT a.account_pk, i.item_pk, 3
FROM account a
JOIN item i ON i.item_name = '레드 글라스 오너먼트 볼'
WHERE a.account_id = 'local_user01'
  AND NOT EXISTS (
    SELECT 1 FROM cart c WHERE c.account_pk = a.account_pk AND c.item_pk = i.item_pk
  );

INSERT INTO cart (account_pk, item_pk, cart_count)
SELECT a.account_pk, i.item_pk, 1
FROM account a
JOIN item i ON i.item_name = '별빛 커튼 조명'
WHERE a.account_id = 'local_user02'
  AND NOT EXISTS (
    SELECT 1 FROM cart c WHERE c.account_pk = a.account_pk AND c.item_pk = i.item_pk
  );

INSERT INTO cart (account_pk, item_pk, cart_count)
SELECT a.account_pk, i.item_pk, 1
FROM account a
JOIN item i ON i.item_name = '노르딕 도어 리스'
WHERE a.account_id = 'local_user02'
  AND NOT EXISTS (
    SELECT 1 FROM cart c WHERE c.account_pk = a.account_pk AND c.item_pk = i.item_pk
  );

INSERT INTO cart (account_pk, item_pk, cart_count)
SELECT a.account_pk, i.item_pk, 1
FROM account a
JOIN item i ON i.item_name = '스노우 파인 트리'
WHERE a.account_id = 'local_user03'
  AND NOT EXISTS (
    SELECT 1 FROM cart c WHERE c.account_pk = a.account_pk AND c.item_pk = i.item_pk
  );

INSERT INTO cart (account_pk, item_pk, cart_count)
SELECT a.account_pk, i.item_pk, 2
FROM account a
JOIN item i ON i.item_name = '골드 믹스 오너먼트 볼'
WHERE a.account_id = 'local_user03'
  AND NOT EXISTS (
    SELECT 1 FROM cart c WHERE c.account_pk = a.account_pk AND c.item_pk = i.item_pk
  );

INSERT INTO wishlist (account_pk, item_pk)
SELECT a.account_pk, i.item_pk
FROM account a
JOIN item i ON i.item_name = '별빛 커튼 조명'
WHERE a.account_id = 'local_user01'
  AND NOT EXISTS (
    SELECT 1 FROM wishlist w WHERE w.account_pk = a.account_pk AND w.item_pk = i.item_pk
  );

INSERT INTO wishlist (account_pk, item_pk)
SELECT a.account_pk, i.item_pk
FROM account a
JOIN item i ON i.item_name = '노르딕 도어 리스'
WHERE a.account_id = 'local_user01'
  AND NOT EXISTS (
    SELECT 1 FROM wishlist w WHERE w.account_pk = a.account_pk AND w.item_pk = i.item_pk
  );

INSERT INTO wishlist (account_pk, item_pk)
SELECT a.account_pk, i.item_pk
FROM account a
JOIN item i ON i.item_name = '선물 포장 리본 세트'
WHERE a.account_id = 'local_user01'
  AND NOT EXISTS (
    SELECT 1 FROM wishlist w WHERE w.account_pk = a.account_pk AND w.item_pk = i.item_pk
  );

INSERT INTO wishlist (account_pk, item_pk)
SELECT a.account_pk, i.item_pk
FROM account a
JOIN item i ON i.item_name = '클래식 그린 트리'
WHERE a.account_id = 'local_user02'
  AND NOT EXISTS (
    SELECT 1 FROM wishlist w WHERE w.account_pk = a.account_pk AND w.item_pk = i.item_pk
  );

INSERT INTO wishlist (account_pk, item_pk)
SELECT a.account_pk, i.item_pk
FROM account a
JOIN item i ON i.item_name = '산타 세라믹 피규어'
WHERE a.account_id = 'local_user02'
  AND NOT EXISTS (
    SELECT 1 FROM wishlist w WHERE w.account_pk = a.account_pk AND w.item_pk = i.item_pk
  );

INSERT INTO wishlist (account_pk, item_pk)
SELECT a.account_pk, i.item_pk
FROM account a
JOIN item i ON i.item_name = '베리 포인트 리스'
WHERE a.account_id = 'local_user03'
  AND NOT EXISTS (
    SELECT 1 FROM wishlist w WHERE w.account_pk = a.account_pk AND w.item_pk = i.item_pk
  );

INSERT INTO wishlist (account_pk, item_pk)
SELECT a.account_pk, i.item_pk
FROM account a
JOIN item i ON i.item_name = '크리스마스 테이블 러너'
WHERE a.account_id = 'local_user03'
  AND NOT EXISTS (
    SELECT 1 FROM wishlist w WHERE w.account_pk = a.account_pk AND w.item_pk = i.item_pk
  );

INSERT INTO wishlist (account_pk, item_pk)
SELECT a.account_pk, i.item_pk
FROM account a
JOIN item i ON i.item_name = '스노우 파인 트리'
WHERE a.account_id = 'local_user04'
  AND NOT EXISTS (
    SELECT 1 FROM wishlist w WHERE w.account_pk = a.account_pk AND w.item_pk = i.item_pk
  );

INSERT INTO wishlist (account_pk, item_pk)
SELECT a.account_pk, i.item_pk
FROM account a
JOIN item i ON i.item_name = '웜 화이트 LED 전구'
WHERE a.account_id = 'local_user04'
  AND NOT EXISTS (
    SELECT 1 FROM wishlist w WHERE w.account_pk = a.account_pk AND w.item_pk = i.item_pk
  );

INSERT INTO review (
  account_pk,
  item_pk,
  review_title,
  review_content,
  review_star,
  review_image_url
)
SELECT
  a.account_pk,
  i.item_pk,
  '거실 분위기가 확 살아났어요',
  '크기도 적당하고 가지가 풍성해서 장식하기 좋았습니다.',
  5,
  NULL
FROM account a
JOIN item i ON i.item_name = '클래식 그린 트리'
WHERE a.account_id = 'local_user02'
  AND NOT EXISTS (
    SELECT 1 FROM review r WHERE r.account_pk = a.account_pk AND r.item_pk = i.item_pk
  );

INSERT INTO review (
  account_pk,
  item_pk,
  review_title,
  review_content,
  review_star,
  review_image_url
)
SELECT
  a.account_pk,
  i.item_pk,
  '조명이 따뜻해서 좋아요',
  '색감이 노랗게 과하지 않고 트리에 감았을 때 자연스럽습니다.',
  4,
  NULL
FROM account a
JOIN item i ON i.item_name = '웜 화이트 LED 전구'
WHERE a.account_id = 'local_user03'
  AND NOT EXISTS (
    SELECT 1 FROM review r WHERE r.account_pk = a.account_pk AND r.item_pk = i.item_pk
  );

INSERT INTO review (
  account_pk,
  item_pk,
  review_title,
  review_content,
  review_star,
  review_image_url
)
SELECT
  a.account_pk,
  i.item_pk,
  '사진보다 실물이 더 예쁩니다',
  '창가에 걸어두니 저녁에 분위기가 좋고 밝기도 충분합니다.',
  5,
  NULL
FROM account a
JOIN item i ON i.item_name = '별빛 커튼 조명'
WHERE a.account_id = 'local_user04'
  AND NOT EXISTS (
    SELECT 1 FROM review r WHERE r.account_pk = a.account_pk AND r.item_pk = i.item_pk
  );

INSERT INTO review (
  account_pk,
  item_pk,
  review_title,
  review_content,
  review_star,
  review_image_url
)
SELECT
  a.account_pk,
  i.item_pk,
  '색 조합이 고급스러워요',
  '골드 톤이 너무 번쩍이지 않고 다른 장식과 잘 어울립니다.',
  4,
  NULL
FROM account a
JOIN item i ON i.item_name = '골드 믹스 오너먼트 볼'
WHERE a.account_id = 'local_user05'
  AND NOT EXISTS (
    SELECT 1 FROM review r WHERE r.account_pk = a.account_pk AND r.item_pk = i.item_pk
  );

INSERT INTO review (
  account_pk,
  item_pk,
  review_title,
  review_content,
  review_star,
  review_image_url
)
SELECT
  a.account_pk,
  i.item_pk,
  '문 앞 장식으로 딱입니다',
  '리스가 가볍고 색감이 차분해서 오래 걸어두기 좋습니다.',
  5,
  NULL
FROM account a
JOIN item i ON i.item_name = '노르딕 도어 리스'
WHERE a.account_id = 'local_user06'
  AND NOT EXISTS (
    SELECT 1 FROM review r WHERE r.account_pk = a.account_pk AND r.item_pk = i.item_pk
  );

INSERT INTO review (
  account_pk,
  item_pk,
  review_title,
  review_content,
  review_star,
  review_image_url
)
SELECT
  a.account_pk,
  i.item_pk,
  '포장 마감용으로 좋습니다',
  '색이 다양해서 선물 포장마다 다르게 쓰기 편했습니다.',
  4,
  NULL
FROM account a
JOIN item i ON i.item_name = '선물 포장 리본 세트'
WHERE a.account_id = 'local_user01'
  AND NOT EXISTS (
    SELECT 1 FROM review r WHERE r.account_pk = a.account_pk AND r.item_pk = i.item_pk
  );

COMMIT;
