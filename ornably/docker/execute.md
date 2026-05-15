# Docker 실행 구조

## 전체 트리

```text
docker/
|-- dev/
|   `-- docker-compose.yml
|       |-- MySQL + Redis만 실행
|       |-- MySQL 포트 고정: 3306:3306
|       |-- Redis 포트 고정: 6379:6379
|       `-- Spring Boot 앱은 로컬에서 실행
|
`-- auto/
    |-- docker-compose.yml
    |   |-- MySQL + Redis + App 실행
    |   |-- app.env_file=.env.docker
    |   `-- app 컨테이너는 .env.docker 값을 Spring properties에 주입
    |
    |-- docker-compose.override.yml
    |   |-- docker compose 실행 시 자동 병합
    |   |-- .env 값을 사용해 MySQL 계정/root password 치환
    |   |-- MySQL 포트 공개: 3306:3306
    |   |-- Redis 포트 공개: 6379:6379
    |   `-- App 포트 공개: 8088:8080
    |
    |-- .env
    |   `-- docker-compose.yml / override.yml의 ${...} 치환용
    |
    `-- .env.docker
        `-- app 컨테이너 환경변수 주입용
```

## dev + 로컬 실행

```text
실행 흐름
`-- docker/dev/docker-compose.yml
    |-- mysql
    |   |-- MYSQL_USER=kevin
    |   |-- MYSQL_PASSWORD=kevin1234
    |   |-- MYSQL_ROOT_PASSWORD=root1234
    |   |-- MYSQL_DATABASE=ornably_db
    |   |-- 3306:3306
    |   `-- docker/data가 비어 있으면 schema.sql, sample.sql 자동 실행
    |
    `-- redis
        `-- 6379:6379

로컬 Spring
`-- application.properties
    `-- spring.profiles.default=dev
        `-- application-dev.properties
            |-- DB: localhost:3306/ornably_db
            |-- DB user/password 기본값: kevin / kevin1234
            `-- Redis: localhost:6379
```

## auto 전체 Docker 실행

```text
compose 병합 흐름
`-- docker/auto/docker-compose.yml
    `-- docker/auto/docker-compose.override.yml
        `-- 두 파일이 같은 서비스 이름 기준으로 병합됨

MySQL 환경변수
`-- docker/auto/.env
    |-- DB_ROOT_PASSWORD
    |   `-- MYSQL_ROOT_PASSWORD
    |
    |-- ORNABLY_DB_USER
    |   `-- MYSQL_USER
    |
    `-- ORNABLY_DB_PASSWORD
        `-- MYSQL_PASSWORD

App 환경변수
`-- docker/auto/.env.docker
    |-- SPRING_PROFILES_ACTIVE=docker
    |   `-- application-docker.properties 사용
    |
    |-- DB_USERNAME
    |   `-- spring.datasource.username
    |
    |-- DB_PASSWORD
    |   `-- spring.datasource.password
    |
    |-- DB_OPTIONS
    |   `-- spring.datasource.url의 query option
    |
    |-- SERVER_ORIGIN
    |   `-- server.origin
    |
    `-- RESOURCE_PATH
        `-- resource.path

application-docker.properties
`-- app 컨테이너 내부 Spring 설정
    |-- DB: mysql:3306/ornably_db
    |-- Redis: redis:6379
    `-- DB 계정: .env.docker의 DB_USERNAME / DB_PASSWORD
```

## DB 초기화

```text
docker/data 비어 있음
`-- MySQL 최초 시작
    |-- schema.sql 실행
    |   `-- ornably_db 생성 및 테이블 생성
    |
    `-- sample.sql 실행
        `-- 초기 데이터 insert

docker/data 이미 존재
`-- schema.sql / sample.sql 자동 재실행 안 됨
```

## 핵심 주의사항

```text
.env
`-- compose 파일의 ${...} 치환용
    `-- app 컨테이너에 자동 주입되는 파일 아님

.env.docker
`-- app 컨테이너 env_file
    `-- Spring의 ${...} properties 값으로 사용됨

MYSQL_DATABASE=ornably_db
`-- MySQL 최초 생성 DB 이름
    `-- app 접속 URL은 application-docker.properties가 결정

계정 정합성
|-- .env: ORNABLY_DB_USER == .env.docker: DB_USERNAME
`-- .env: ORNABLY_DB_PASSWORD == .env.docker: DB_PASSWORD
```
