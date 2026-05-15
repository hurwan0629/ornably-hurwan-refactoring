이곳은 mysql을 사용한 본 프로젝트의 구조를 나타내기 위해 만들어진 문서입니다.

현재는 간단하게 시작하며 앞으로 발전시킬 예정입니다.

---

## 2026-05-15 11:31
현재는 배포 전 단계이기 때문에 사요자는 root만이 존재합니다.

이전 개발 진행 시 스키마, `kevin`을 사용자로 착각하였었기 떄문에 `kevin@[domain]` 사용자를 추가하며 스키마 이름을 변경할 예정입니다.
현재 USER과 SCHEMA를 변경해주었습니다.
```markdown
MySQL Server
|-- root 사용자
|   |-- 계정: root
|   |-- 용도: DB 초기화/관리용
|   |-- docker/dev: MYSQL_ROOT_PASSWORD=root1234
|   `-- docker/auto: MYSQL_ROOT_PASSWORD=${DB_ROOT_PASSWORD}
|
|-- kevin 사용자
|   |-- 계정: kevin
|   |-- 용도: Ornably 애플리케이션 접속용
|   |-- docker/dev: MYSQL_USER=kevin, MYSQL_PASSWORD=kevin1234
|   |-- docker/auto: MYSQL_USER=${ORNABLY_DB_USER}, MYSQL_PASSWORD=${ORNABLY_DB_PASSWORD}
|   `-- Spring 접속: DB_USERNAME / DB_PASSWORD
|
`-- ornably_db 스키마
    |-- 생성 위치: src/main/resources/SQL/schema.sql
    |-- Docker 최초 초기화: MYSQL_DATABASE=ornably_db
    |-- Spring dev 접속: localhost:3306/ornably_db
    |-- Spring docker 접속: mysql:3306/ornably_db
    |
    |-- account
    |   `-- sample admin
    |       |-- account_id: admin
    |       `-- password: Admin1234!@
    |-- item
    |-- event
    |-- address
    |-- cart
    |-- wishlist
    |-- review
    |-- orders
    |-- orders_item
    `-- connect_log
```
