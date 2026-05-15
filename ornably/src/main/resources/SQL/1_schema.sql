CREATE DATABASE IF NOT EXISTS ornably_db
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE ornably_db;

SET NAMES utf8mb4;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS connect_log;
DROP TABLE IF EXISTS orders_item;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS wishlist;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS event;
DROP TABLE IF EXISTS item;
DROP TABLE IF EXISTS account;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE account (
  account_pk INT NOT NULL AUTO_INCREMENT,
  account_id VARCHAR(100) NULL,
  account_password_hash VARCHAR(255) NULL,
  account_name VARCHAR(100) NOT NULL,
  account_email VARCHAR(255) NULL,
  account_phone VARCHAR(30) NULL,
  account_date DATE NOT NULL DEFAULT (CURRENT_DATE),
  account_role VARCHAR(30) NOT NULL DEFAULT 'LOCAL', -- ['LOCAL', 'GOOGLE', 'KAKAO', 'NAVER', 'ONBOARD', 'ADMIN']
  account_event_opt_in BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (account_pk),
  UNIQUE KEY uk_account_id (account_id),
  UNIQUE KEY uk_account_phone (account_phone),
  KEY idx_account_role (account_role),
  KEY idx_account_date (account_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE item (
  item_pk INT NOT NULL AUTO_INCREMENT,
  item_name VARCHAR(255) NOT NULL,
  item_price INT NOT NULL DEFAULT 0,
  item_stock INT NOT NULL DEFAULT 0,
  item_image_url VARCHAR(500) NULL,
  item_description TEXT NULL,
  item_category VARCHAR(100) NOT NULL,
  item_regist_date DATE NOT NULL DEFAULT (CURRENT_DATE),
  PRIMARY KEY (item_pk),
  KEY idx_item_category (item_category),
  KEY idx_item_regist_date (item_regist_date),
  KEY idx_item_name (item_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE event (
  event_pk INT NOT NULL AUTO_INCREMENT,
  event_name VARCHAR(255) NOT NULL,
  event_image_url VARCHAR(500) NULL,
  event_start_date DATE NOT NULL,
  event_end_date DATE NOT NULL,
  event_target_account JSON NOT NULL,
    -- 1. 전체 사용자 이벤트
    -- { "type": "ALL" }
    -- 2. N원 이상 구매 사용자
    -- {
    --   "type": "AMOUNT",
    --   "amount": 50000
    -- }
    -- 2. 특정 날짜 범위 회원가입 사용자 이벤트
    -- {
    --   "type": "JOINED",
    --   "startDate": "2025-12-01",
    --   "endDate": "2025-12-31"
    -- }
    -- 4. 특정 유형 회원
    -- {
    --   "type": "MEMBER_TYPE",
    --   "memberType": ["LOCAL", "GOOGLE", "KAKAO", "NAVER"]
    -- }
  event_target_category JSON NOT NULL, -- ["TREE", "LIGHT", "BALL", "FIGURE", "WREATHS", "ETC"]
  event_discount_rate INT NOT NULL DEFAULT 0,
  event_description TEXT NULL,
  PRIMARY KEY (event_pk),
  KEY idx_event_date (event_start_date, event_end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE address (
  address_pk INT NOT NULL AUTO_INCREMENT,
  account_pk INT NOT NULL,
  address_name VARCHAR(100) NOT NULL,
  address_is_default BOOLEAN NOT NULL DEFAULT FALSE,
  address_postal_code VARCHAR(20) NOT NULL,
  address_region VARCHAR(255) NOT NULL,
  address_detail VARCHAR(255) NOT NULL,
  PRIMARY KEY (address_pk),
  KEY idx_address_account_pk (account_pk),
  CONSTRAINT fk_address_account
    FOREIGN KEY (account_pk) REFERENCES account (account_pk)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cart (
  cart_pk INT NOT NULL AUTO_INCREMENT,
  account_pk INT NOT NULL,
  item_pk INT NOT NULL,
  cart_count INT NOT NULL DEFAULT 1,
  PRIMARY KEY (cart_pk),
  UNIQUE KEY uk_cart_account_item (account_pk, item_pk),
  KEY idx_cart_item_pk (item_pk),
  CONSTRAINT fk_cart_account
    FOREIGN KEY (account_pk) REFERENCES account (account_pk)
    ON DELETE CASCADE,
  CONSTRAINT fk_cart_item
    FOREIGN KEY (item_pk) REFERENCES item (item_pk)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE wishlist (
  wishlist_pk INT NOT NULL AUTO_INCREMENT,
  account_pk INT NOT NULL,
  item_pk INT NOT NULL,
  PRIMARY KEY (wishlist_pk),
  UNIQUE KEY uk_wishlist_account_item (account_pk, item_pk),
  KEY idx_wishlist_item_pk (item_pk),
  CONSTRAINT fk_wishlist_account
    FOREIGN KEY (account_pk) REFERENCES account (account_pk)
    ON DELETE CASCADE,
  CONSTRAINT fk_wishlist_item
    FOREIGN KEY (item_pk) REFERENCES item (item_pk)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE review (
  review_pk INT NOT NULL AUTO_INCREMENT,
  account_pk INT NOT NULL,
  item_pk INT NOT NULL,
  review_title VARCHAR(255) NOT NULL,
  review_content TEXT NOT NULL,
  review_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  review_star INT NOT NULL,
  review_image_url VARCHAR(500) NULL,
  PRIMARY KEY (review_pk),
  UNIQUE KEY uk_review_account_item (account_pk, item_pk),
  KEY idx_review_item_pk (item_pk),
  KEY idx_review_account_pk (account_pk),
  KEY idx_review_date (review_date),
  CONSTRAINT fk_review_account
    FOREIGN KEY (account_pk) REFERENCES account (account_pk)
    ON DELETE CASCADE,
  CONSTRAINT fk_review_item
    FOREIGN KEY (item_pk) REFERENCES item (item_pk)
    ON DELETE CASCADE,
  CONSTRAINT ck_review_star CHECK (review_star BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE orders (
  orders_pk INT NOT NULL AUTO_INCREMENT,
  account_pk INT NOT NULL,
  orders_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  address_name VARCHAR(100) NOT NULL,
  orders_payment_type VARCHAR(50) NOT NULL,
  orders_import_uid VARCHAR(255) NOT NULL,
  orders_message TEXT NULL,
  orders_status VARCHAR(50) NOT NULL DEFAULT '상품 준비중',
  PRIMARY KEY (orders_pk),
  UNIQUE KEY uk_orders_import_uid (orders_import_uid),
  KEY idx_orders_account_pk (account_pk),
  KEY idx_orders_date (orders_date),
  CONSTRAINT fk_orders_account
    FOREIGN KEY (account_pk) REFERENCES account (account_pk)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE orders_item (
  orders_item_pk INT NOT NULL AUTO_INCREMENT,
  orders_pk INT NOT NULL,
  item_pk INT NOT NULL,
  orders_item_count INT NOT NULL,
  orders_item_price INT NOT NULL,
  PRIMARY KEY (orders_item_pk),
  KEY idx_orders_item_orders_pk (orders_pk),
  KEY idx_orders_item_item_pk (item_pk),
  CONSTRAINT fk_orders_item_orders
    FOREIGN KEY (orders_pk) REFERENCES orders (orders_pk)
    ON DELETE CASCADE,
  CONSTRAINT fk_orders_item_item
    FOREIGN KEY (item_pk) REFERENCES item (item_pk)
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE connect_log (
  connect_log_pk INT NOT NULL AUTO_INCREMENT,
  account_pk INT NOT NULL,
  connect_ip VARCHAR(45) NULL,
  connect_device VARCHAR(255) NULL,
  connect_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (connect_log_pk),
  KEY idx_connect_log_account_date (account_pk, connect_date),
  CONSTRAINT fk_connect_log_account
    FOREIGN KEY (account_pk) REFERENCES account (account_pk)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
