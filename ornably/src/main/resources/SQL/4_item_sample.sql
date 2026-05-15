USE ornably_db;

SET NAMES utf8mb4;

-- Item sample data.
-- This file avoids fixed primary keys and does not overwrite existing items.
-- Each item is inserted only when the same item_name does not already exist.
--
-- Item samples
-- - 클래식 그린 트리 / TREE / 129000
-- - 스노우 파인 트리 / TREE / 159000
-- - 웜 화이트 LED 전구 / LIGHT / 24900
-- - 별빛 커튼 조명 / LIGHT / 35900
-- - 레드 글라스 오너먼트 볼 / BALL / 18900
-- - 골드 믹스 오너먼트 볼 / BALL / 22900
-- - 산타 세라믹 피규어 / FIGURE / 32900
-- - 우드 루돌프 피규어 / FIGURE / 27900
-- - 노르딕 도어 리스 / WREATHS / 46900
-- - 베리 포인트 리스 / WREATHS / 52900
-- - 크리스마스 테이블 러너 / ETC / 19900
-- - 선물 포장 리본 세트 / ETC / 9900

START TRANSACTION;

INSERT INTO item (
  item_name,
  item_price,
  item_stock,
  item_image_url,
  item_description,
  item_category,
  item_regist_date
)
SELECT
  '클래식 그린 트리',
  129000,
  35,
  '/images/item/classic-green-tree.jpg',
  '거실과 매장 디스플레이에 어울리는 기본형 그린 트리입니다.',
  'TREE',
  '2026-01-02'
WHERE NOT EXISTS (
  SELECT 1 FROM item WHERE item_name = '클래식 그린 트리'
);

INSERT INTO item (
  item_name,
  item_price,
  item_stock,
  item_image_url,
  item_description,
  item_category,
  item_regist_date
)
SELECT
  '스노우 파인 트리',
  159000,
  22,
  '/images/item/snow-pine-tree.jpg',
  '눈이 내려앉은 듯한 질감의 프리미엄 파인 트리입니다.',
  'TREE',
  '2026-01-04'
WHERE NOT EXISTS (
  SELECT 1 FROM item WHERE item_name = '스노우 파인 트리'
);

INSERT INTO item (
  item_name,
  item_price,
  item_stock,
  item_image_url,
  item_description,
  item_category,
  item_regist_date
)
SELECT
  '웜 화이트 LED 전구',
  24900,
  120,
  '/images/item/warm-white-led.jpg',
  '따뜻한 색감으로 트리와 벽면 장식에 모두 쓰기 좋은 LED 전구입니다.',
  'LIGHT',
  '2026-01-06'
WHERE NOT EXISTS (
  SELECT 1 FROM item WHERE item_name = '웜 화이트 LED 전구'
);

INSERT INTO item (
  item_name,
  item_price,
  item_stock,
  item_image_url,
  item_description,
  item_category,
  item_regist_date
)
SELECT
  '별빛 커튼 조명',
  35900,
  68,
  '/images/item/star-curtain-light.jpg',
  '창가나 포토존에 걸기 좋은 별 모양 커튼 조명입니다.',
  'LIGHT',
  '2026-01-08'
WHERE NOT EXISTS (
  SELECT 1 FROM item WHERE item_name = '별빛 커튼 조명'
);

INSERT INTO item (
  item_name,
  item_price,
  item_stock,
  item_image_url,
  item_description,
  item_category,
  item_regist_date
)
SELECT
  '레드 글라스 오너먼트 볼',
  18900,
  90,
  '/images/item/red-glass-ball.jpg',
  '클래식한 레드 컬러의 유리 오너먼트 볼 세트입니다.',
  'BALL',
  '2026-01-10'
WHERE NOT EXISTS (
  SELECT 1 FROM item WHERE item_name = '레드 글라스 오너먼트 볼'
);

INSERT INTO item (
  item_name,
  item_price,
  item_stock,
  item_image_url,
  item_description,
  item_category,
  item_regist_date
)
SELECT
  '골드 믹스 오너먼트 볼',
  22900,
  75,
  '/images/item/gold-mix-ball.jpg',
  '무광과 유광 골드 볼을 섞은 트리 장식 세트입니다.',
  'BALL',
  '2026-01-12'
WHERE NOT EXISTS (
  SELECT 1 FROM item WHERE item_name = '골드 믹스 오너먼트 볼'
);

INSERT INTO item (
  item_name,
  item_price,
  item_stock,
  item_image_url,
  item_description,
  item_category,
  item_regist_date
)
SELECT
  '산타 세라믹 피규어',
  32900,
  44,
  '/images/item/santa-ceramic-figure.jpg',
  '선반과 테이블 위에 올려두기 좋은 세라믹 산타 피규어입니다.',
  'FIGURE',
  '2026-01-14'
WHERE NOT EXISTS (
  SELECT 1 FROM item WHERE item_name = '산타 세라믹 피규어'
);

INSERT INTO item (
  item_name,
  item_price,
  item_stock,
  item_image_url,
  item_description,
  item_category,
  item_regist_date
)
SELECT
  '우드 루돌프 피규어',
  27900,
  58,
  '/images/item/wood-rudolph-figure.jpg',
  '내추럴한 목재 질감이 돋보이는 루돌프 피규어입니다.',
  'FIGURE',
  '2026-01-16'
WHERE NOT EXISTS (
  SELECT 1 FROM item WHERE item_name = '우드 루돌프 피규어'
);

INSERT INTO item (
  item_name,
  item_price,
  item_stock,
  item_image_url,
  item_description,
  item_category,
  item_regist_date
)
SELECT
  '노르딕 도어 리스',
  46900,
  30,
  '/images/item/nordic-door-wreath.jpg',
  '현관문과 벽면 장식에 어울리는 차분한 노르딕 스타일 리스입니다.',
  'WREATHS',
  '2026-01-18'
WHERE NOT EXISTS (
  SELECT 1 FROM item WHERE item_name = '노르딕 도어 리스'
);

INSERT INTO item (
  item_name,
  item_price,
  item_stock,
  item_image_url,
  item_description,
  item_category,
  item_regist_date
)
SELECT
  '베리 포인트 리스',
  52900,
  26,
  '/images/item/berry-point-wreath.jpg',
  '레드 베리 장식이 포인트인 풍성한 크리스마스 리스입니다.',
  'WREATHS',
  '2026-01-20'
WHERE NOT EXISTS (
  SELECT 1 FROM item WHERE item_name = '베리 포인트 리스'
);

INSERT INTO item (
  item_name,
  item_price,
  item_stock,
  item_image_url,
  item_description,
  item_category,
  item_regist_date
)
SELECT
  '크리스마스 테이블 러너',
  19900,
  84,
  '/images/item/christmas-table-runner.jpg',
  '식탁과 콘솔 위 분위기를 잡아주는 패브릭 테이블 러너입니다.',
  'ETC',
  '2026-01-22'
WHERE NOT EXISTS (
  SELECT 1 FROM item WHERE item_name = '크리스마스 테이블 러너'
);

INSERT INTO item (
  item_name,
  item_price,
  item_stock,
  item_image_url,
  item_description,
  item_category,
  item_regist_date
)
SELECT
  '선물 포장 리본 세트',
  9900,
  150,
  '/images/item/gift-ribbon-set.jpg',
  '선물 포장과 트리 장식에 함께 쓸 수 있는 리본 세트입니다.',
  'ETC',
  '2026-01-24'
WHERE NOT EXISTS (
  SELECT 1 FROM item WHERE item_name = '선물 포장 리본 세트'
);

COMMIT;
