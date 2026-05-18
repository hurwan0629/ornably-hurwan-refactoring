unzip -o -j ./app.war \
  'WEB-INF/classes/SQL/1_schema.sql' \
  'WEB-INF/classes/SQL/2_sample.sql' \
  'WEB-INF/classes/SQL/3_account_sample.sql' \
  'WEB-INF/classes/SQL/4_item_sample.sql' \
  'WEB-INF/classes/SQL/5_event_sample.sql' \
  'WEB-INF/classes/SQL/6_order_sample.sql' \
  'WEB-INF/classes/SQL/7_user_item_sample.sql' \
  -d ./SQL