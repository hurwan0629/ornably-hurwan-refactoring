-- SELECT * FROM ACCOUNT;

INSERT INTO ACCOUNT(
                    ACCOUNT_ID,
                    ACCOUNT_PASSWORD_HASH,
                    ACCOUNT_NAME,
                    ACCOUNT_EMAIL,
                    ACCOUNT_PHONE,
                    ACCOUNT_ROLE,
                    ACCOUNT_EVENT_OPT_IN)
VALUES ('admin',
        '$2a$12$PHYVXV3TLpXXzQq.rFLEs.hnEoUwRVbNw1keFnFvAPAEGuFKH4p4S',
        '관리자',
        'cchamppang0629@gmail.com',
        '01011111111',
        'ADMIN',
        1);