?닿납? mysql???ъ슜??蹂??꾨줈?앺듃??援ъ“瑜??섑??닿린 ?꾪빐 留뚮뱾?댁쭊 臾몄꽌?낅땲??

?꾩옱??媛꾨떒?섍쾶 ?쒖옉?섎ŉ ?욎쑝濡?諛쒖쟾?쒗궗 ?덉젙?낅땲??

---

## 2026-05-15 11:31
?꾩옱??諛고룷 ???④퀎?닿린 ?뚮Ц???ъ슂?먮뒗 root留뚯씠 議댁옱?⑸땲??

?댁쟾 媛쒕컻 吏꾪뻾 ???ㅽ궎留? `kevin`???ъ슜?먮줈 李⑷컖?섏??덇린 ?꾨Ц??`kevin@[domain]` ?ъ슜?먮? 異붽??섎ŉ ?ㅽ궎留??대쫫??蹂寃쏀븷 ?덉젙?낅땲??
?꾩옱 USER怨?SCHEMA瑜?蹂寃쏀빐二쇱뿀?듬땲??
```markdown
MySQL Server
|-- root ?ъ슜??
|   |-- 怨꾩젙: root
|   |-- ?⑸룄: DB 珥덇린??愿由ъ슜
|   |-- docker/dev: MYSQL_ROOT_PASSWORD=root1234
|   `-- docker/auto: MYSQL_ROOT_PASSWORD=${DB_ROOT_PASSWORD}
|
|-- kevin ?ъ슜??
|   |-- 怨꾩젙: kevin
|   |-- ?⑸룄: Ornably ?좏뵆由ъ??댁뀡 ?묒냽??
|   |-- docker/dev: MYSQL_USER=kevin, MYSQL_PASSWORD=kevin1234
|   |-- docker/auto: MYSQL_USER=${ORNABLY_DB_USER}, MYSQL_PASSWORD=${ORNABLY_DB_PASSWORD}
|   `-- Spring ?묒냽: DB_USERNAME / DB_PASSWORD
|
`-- ornably_db ?ㅽ궎留?
    |-- ?앹꽦 ?꾩튂: src/main/resources/SQL/1_schema.sql
    |-- Docker 理쒖큹 珥덇린?? MYSQL_DATABASE=ornably_db
    |-- Spring dev ?묒냽: localhost:3306/ornably_db
    |-- Spring docker ?묒냽: mysql:3306/ornably_db
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
