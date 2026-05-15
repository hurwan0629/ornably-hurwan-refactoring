-- SELECT * FROM account;

INSERT INTO account (
  account_id,
  account_password_hash,
  account_name,
  account_email,
  account_phone,
  account_role,
  account_event_opt_in
)
VALUES (
  'admin',
  '$2a$12$PHYVXV3TLpXXzQq.rFLEs.hnEoUwRVbNw1keFnFvAPAEGuFKH4p4S',
  '관리자',
  'cchamppang0629@gmail.com',
  '01011111111',
  'ADMIN',
  1
);
