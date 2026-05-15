USE ornably_db;
SET NAMES utf8mb4;
-- Event sample data.
-- This file avoids fixed primary keys and does not overwrite existing events.
-- Each target-account type is represented once: ALL, AMOUNT, JOINED, MEMBER_TYPE.
--
-- Event samples
-- - name: 전 상품 웰컴 할인 / target: ALL / category: TREE,LIGHT,BALL / discount: 10%
-- - name: 5만원 이상 구매 고객 감사 할인 / target: AMOUNT 50000 / category: FIGURE,WREATHS / discount: 15%
-- - name: 2026년 1분기 가입 고객 할인 / target: JOINED 2026-01-01~2026-03-31 / category: TREE,ETC / discount: 12%
-- - name: 로컬 회원 전용 조명 할인 / target: MEMBER_TYPE LOCAL / category: LIGHT / discount: 20%
-- - name: 종료된 전체 사용자 할인 / target: ALL / category: ETC / discount: 5%

START TRANSACTION;

INSERT INTO event (
  event_name,
  event_image_url,
  event_start_date,
  event_end_date,
  event_target_account,
  event_target_category,
  event_discount_rate,
  event_description
)
SELECT
  '전 상품 웰컴 할인',
  '/images/event/welcome-all.jpg',
  DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY),
  DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY),
  JSON_OBJECT('type', 'ALL'),
  JSON_ARRAY('TREE', 'LIGHT', 'BALL'),
  10,
  '모든 사용자에게 적용되는 기본 진행 이벤트입니다.'
WHERE NOT EXISTS (
  SELECT 1 FROM event WHERE event_name = '전 상품 웰컴 할인'
);

INSERT INTO event (
  event_name,
  event_image_url,
  event_start_date,
  event_end_date,
  event_target_account,
  event_target_category,
  event_discount_rate,
  event_description
)
SELECT
  '5만원 이상 구매 고객 감사 할인',
  '/images/event/amount-50000.jpg',
  DATE_SUB(CURRENT_DATE, INTERVAL 3 DAY),
  DATE_ADD(CURRENT_DATE, INTERVAL 45 DAY),
  JSON_OBJECT('type', 'AMOUNT', 'amount', 50000),
  JSON_ARRAY('FIGURE', 'WREATHS'),
  15,
  '누적 구매 금액이 5만원 이상인 사용자에게 적용되는 이벤트입니다.'
WHERE NOT EXISTS (
  SELECT 1 FROM event WHERE event_name = '5만원 이상 구매 고객 감사 할인'
);

INSERT INTO event (
  event_name,
  event_image_url,
  event_start_date,
  event_end_date,
  event_target_account,
  event_target_category,
  event_discount_rate,
  event_description
)
SELECT
  '2026년 1분기 가입 고객 할인',
  '/images/event/joined-2026-q1.jpg',
  DATE_SUB(CURRENT_DATE, INTERVAL 1 DAY),
  DATE_ADD(CURRENT_DATE, INTERVAL 60 DAY),
  JSON_OBJECT(
    'type', 'JOINED',
    'startDate', '2026-01-01',
    'endDate', '2026-03-31'
  ),
  JSON_ARRAY('TREE', 'ETC'),
  12,
  '2026년 1분기에 가입한 사용자에게 적용되는 이벤트입니다.'
WHERE NOT EXISTS (
  SELECT 1 FROM event WHERE event_name = '2026년 1분기 가입 고객 할인'
);

INSERT INTO event (
  event_name,
  event_image_url,
  event_start_date,
  event_end_date,
  event_target_account,
  event_target_category,
  event_discount_rate,
  event_description
)
SELECT
  '로컬 회원 전용 조명 할인',
  '/images/event/local-light.jpg',
  DATE_SUB(CURRENT_DATE, INTERVAL 5 DAY),
  DATE_ADD(CURRENT_DATE, INTERVAL 20 DAY),
  JSON_OBJECT(
    'type', 'MEMBER_TYPE',
    'memberType', JSON_ARRAY('LOCAL')
  ),
  JSON_ARRAY('LIGHT'),
  20,
  '폼 로그인으로 가입한 LOCAL 회원에게 적용되는 조명 카테고리 이벤트입니다.'
WHERE NOT EXISTS (
  SELECT 1 FROM event WHERE event_name = '로컬 회원 전용 조명 할인'
);

INSERT INTO event (
  event_name,
  event_image_url,
  event_start_date,
  event_end_date,
  event_target_account,
  event_target_category,
  event_discount_rate,
  event_description
)
SELECT
  '종료된 전체 사용자 할인',
  '/images/event/ended-all.jpg',
  DATE_SUB(CURRENT_DATE, INTERVAL 60 DAY),
  DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY),
  JSON_OBJECT('type', 'ALL'),
  JSON_ARRAY('ETC'),
  5,
  '종료된 이벤트 표시와 필터링 확인용 샘플입니다.'
WHERE NOT EXISTS (
  SELECT 1 FROM event WHERE event_name = '종료된 전체 사용자 할인'
);

COMMIT;
