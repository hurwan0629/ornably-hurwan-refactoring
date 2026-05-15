# Docker ?ㅽ뻾 援ъ“

## ?꾩껜 ?몃━

```text
docker/
|-- dev/
|   `-- docker-compose.yml
|       |-- MySQL + Redis留??ㅽ뻾
|       |-- MySQL ?ы듃 怨좎젙: 3306:3306
|       |-- Redis ?ы듃 怨좎젙: 6379:6379
|       `-- Spring Boot ?깆? 濡쒖뺄?먯꽌 ?ㅽ뻾
|
`-- auto/
    |-- docker-compose.yml
    |   |-- MySQL + Redis + App ?ㅽ뻾
    |   |-- app.env_file=.env.docker
    |   `-- app 而⑦뀒?대꼫??.env.docker 媛믪쓣 Spring properties??二쇱엯
    |
    |-- docker-compose.override.yml
    |   |-- docker compose ?ㅽ뻾 ???먮룞 蹂묓빀
    |   |-- .env 媛믪쓣 ?ъ슜??MySQL 怨꾩젙/root password 移섑솚
    |   |-- MySQL ?ы듃 怨듦컻: 3306:3306
    |   |-- Redis ?ы듃 怨듦컻: 6379:6379
    |   `-- App ?ы듃 怨듦컻: 8088:8080
    |
    |-- .env
    |   `-- docker-compose.yml / override.yml??${...} 移섑솚??
    |
    `-- .env.docker
        `-- app 而⑦뀒?대꼫 ?섍꼍蹂??二쇱엯??
```

## dev + 濡쒖뺄 ?ㅽ뻾

```text
?ㅽ뻾 ?먮쫫
`-- docker/dev/docker-compose.yml
    |-- mysql
    |   |-- MYSQL_USER=kevin
    |   |-- MYSQL_PASSWORD=kevin1234
    |   |-- MYSQL_ROOT_PASSWORD=root1234
    |   |-- MYSQL_DATABASE=ornably_db
    |   |-- 3306:3306
    |   `-- docker/data媛 鍮꾩뼱 ?덉쑝硫?1_schema.sql, 2_sample.sql ?먮룞 ?ㅽ뻾
    |
    `-- redis
        `-- 6379:6379

濡쒖뺄 Spring
`-- application.properties
    `-- spring.profiles.default=dev
        `-- application-dev.properties
            |-- DB: localhost:3306/ornably_db
            |-- DB user/password 湲곕낯媛? kevin / kevin1234
            `-- Redis: localhost:6379
```

## auto ?꾩껜 Docker ?ㅽ뻾

```text
compose 蹂묓빀 ?먮쫫
`-- docker/auto/docker-compose.yml
    `-- docker/auto/docker-compose.override.yml
        `-- ???뚯씪??媛숈? ?쒕퉬???대쫫 湲곗??쇰줈 蹂묓빀??

MySQL ?섍꼍蹂??
`-- docker/auto/.env
    |-- DB_ROOT_PASSWORD
    |   `-- MYSQL_ROOT_PASSWORD
    |
    |-- ORNABLY_DB_USER
    |   `-- MYSQL_USER
    |
    `-- ORNABLY_DB_PASSWORD
        `-- MYSQL_PASSWORD

App ?섍꼍蹂??
`-- docker/auto/.env.docker
    |-- SPRING_PROFILES_ACTIVE=docker
    |   `-- application-docker.properties ?ъ슜
    |
    |-- DB_USERNAME
    |   `-- spring.datasource.username
    |
    |-- DB_PASSWORD
    |   `-- spring.datasource.password
    |
    |-- DB_OPTIONS
    |   `-- spring.datasource.url??query option
    |
    |-- SERVER_ORIGIN
    |   `-- server.origin
    |
    `-- RESOURCE_PATH
        `-- resource.path

application-docker.properties
`-- app 而⑦뀒?대꼫 ?대? Spring ?ㅼ젙
    |-- DB: mysql:3306/ornably_db
    |-- Redis: redis:6379
    `-- DB 怨꾩젙: .env.docker??DB_USERNAME / DB_PASSWORD
```

## DB 珥덇린??

```text
docker/data 鍮꾩뼱 ?덉쓬
`-- MySQL 理쒖큹 ?쒖옉
    |-- 1_schema.sql ?ㅽ뻾
    |   `-- ornably_db ?앹꽦 諛??뚯씠釉??앹꽦
    |
    `-- 2_sample.sql ?ㅽ뻾
        `-- 珥덇린 ?곗씠??insert

docker/data ?대? 議댁옱
`-- 1_schema.sql / 2_sample.sql ?먮룞 ?ъ떎??????
```

## ?듭떖 二쇱쓽?ы빆

```text
.env
`-- compose ?뚯씪??${...} 移섑솚??
    `-- app 而⑦뀒?대꼫???먮룞 二쇱엯?섎뒗 ?뚯씪 ?꾨떂

.env.docker
`-- app 而⑦뀒?대꼫 env_file
    `-- Spring??${...} properties 媛믪쑝濡??ъ슜??

MYSQL_DATABASE=ornably_db
`-- MySQL 理쒖큹 ?앹꽦 DB ?대쫫
    `-- app ?묒냽 URL? application-docker.properties媛 寃곗젙

怨꾩젙 ?뺥빀??
|-- .env: ORNABLY_DB_USER == .env.docker: DB_USERNAME
`-- .env: ORNABLY_DB_PASSWORD == .env.docker: DB_PASSWORD
```
