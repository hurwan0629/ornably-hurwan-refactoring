package bugsandwich.ornably.account;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class AccountRepository {
	@Autowired // 의존주입
    private JdbcTemplate jdbcTemplate;

	// 로그인
	private static final String LOGIN =
		    "SELECT " +
		    "account_pk   AS accountPk, " +
		    "account_id   AS accountId, " +
		    "account_name AS accountName, " +
		    "account_role AS accountRole, " +
		    "account_password_hash AS accountPasswordHash " +
		    "FROM account " +
		    "WHERE account_id = ? ";


	// 회원가입
	private static final String ACCOUNT_JOIN = 
		    "INSERT INTO account (account_id, account_password_hash, account_name, account_email, account_phone, account_event_opt_in, account_role) " +
		    "VALUES (?, ?, ?, ?, ?, IFNULL(?, FALSE), ?)";


	// 회원 탈퇴
	private static final String UPDATE_SIGN_OUT = 
		    "UPDATE account " +
		    "SET account_id = NULL " + // ID만 NULL로 변경 나머지는 보존
		    "WHERE account_pk = ?";

	// 탈퇴 전 비밀번호 확인
	private static final String SELECT_CHECK_PASSWORD_BY_PK =
		    "SELECT " +
		    "account_password_hash AS accountPasswordHash " +
		    "FROM account " +
		    "WHERE account_pk = ? ";

	// 마이페이지 조회
	private static final String SELECT_MY_PAGE =
		    "SELECT " +
		    "a.account_id    AS accountId, " +
		    "a.account_name  AS accountName, " +
		    "a.account_email AS accountEmail, " +
		    "a.account_phone AS accountPhone, " +
		    "a.account_date  AS accountDate, " +
		    "IFNULL(SUM(oi.orders_item_count * oi.orders_item_price), 0) AS accountTotalAmount " +
		    "FROM account a " +
		    "LEFT JOIN orders o ON a.account_pk = o.account_pk " +
		    "LEFT JOIN orders_item oi ON o.orders_pk = oi.orders_pk " +
		    "WHERE a.account_pk = ? " +
		    "GROUP BY a.account_id, a.account_name, a.account_email, a.account_phone, a.account_date";


	// 아이디 중복 확인
	private static final String SELECT_CHECK_LOGIN_ID = 
		    "SELECT COUNT(*) " +
		    "FROM account " +
		    "WHERE account_id = ?";

	// 폰번호 중복 확인
	private static final String SELECT_CHECK_LOGIN_PHONE = 
		    "SELECT COUNT(*) " +
		    "FROM account " +
		    "WHERE account_phone = ?";
	
	// 회원 아이디로 회원 PK 찾기
	private static final String SELECT_ACCOUNT_PK_BY_ACCOUNT_ID =
		    "SELECT account_pk AS accountPk " +
		    "FROM account " +
		    "WHERE account_id = ?";

	// 계정 1명 조회
	private static final String SELECT_ORNABLY_USER_BY_ACCOUNT_ID =
		    "SELECT " +
		    "    account_pk 	AS accountPk, " +
		    "    account_name 	AS accountName, " +
		    "    account_id 	AS accountId, " +
		    "    account_password_hash AS accountPasswordHash, " +
		    "    account_role 	AS accountRole " +
		    "FROM account " +
		    "WHERE account_id = ?";

	
	
    // ==============
 	//   관리자 쿼리문
 	// ==============
 	
	// 관리자 회원 검색
	private static final String SELECT_ALL_ROLE_USER_ACCOUNT_BY_ADMIN_SEARCH =
		    "WITH acct AS ( " +
		    "  SELECT " +
		    "    A.account_pk   AS accountPk, " +
		    "	 A.account_id 	AS accountId, " +
		    "    A.account_name AS accountName, " +
		    "    A.account_date AS accountDate, " +
		    "    A.account_role AS accountRole, " +
		    "    COALESCE(SUM(OI.orders_item_count * OI.orders_item_price), 0) AS accountTotalAmount " +
		    "  FROM account A " +
		    "  LEFT JOIN orders O " +
		    "    ON A.account_pk = O.account_pk " +
		    "  LEFT JOIN orders_item OI " +
		    "    ON O.orders_pk = OI.orders_pk " +
		    "  WHERE A.account_role != 'ADMIN' " +
		    "  GROUP BY " +
		    "    A.account_pk, A.account_name, A.account_date, A.account_role " +
		    ") " +
		    "SELECT " +
		    "  acct.accountPk, " +
		    "  acct.accountId, " +
		    "  acct.accountName, " +
		    "  acct.accountDate, " +
		    "  acct.accountRole, " +
		    "  acct.accountTotalAmount " +
		    "FROM acct " +
		    "WHERE ( ? IS NULL OR acct.accountPk = ? ) " +
		    "  AND ( ? IS NULL OR acct.accountName LIKE CONCAT('%', ?, '%') ) " +
		    "  AND ( ? IS NULL OR acct.accountDate >= ? ) " +
		    "  AND ( ? IS NULL OR acct.accountDate <= ? ) " +
		    "  AND ( ? IS NULL OR acct.accountRole = ? ) " +
		    "  AND ( ? IS NULL OR acct.accountTotalAmount >= ? ) " +
		    "  AND ( ? IS NULL OR acct.accountTotalAmount <= ? ) " +
		    "ORDER BY acct.accountDate DESC";
	/*
	    "SELECT " +
	    "    a.ACCOUNT_PK   AS accountPk, " +
	    "    a.ACCOUNT_NAME AS accountName, " +
	    "    a.ACCOUNT_DATE AS accountDate, " +
	    "    a.ACCOUNT_ROLE AS accountRole, " +
	    "    IFNULL(SUM(oi.ORDERS_ITEM_COUNT * oi.ORDERS_ITEM_PRICE), 0) AS accountTotalAmount " +
	    "FROM ACCOUNT a " +
	    "LEFT JOIN ORDERS o ON a.ACCOUNT_PK = o.ACCOUNT_PK " +
	    "LEFT JOIN ORDERS_ITEM oi ON o.ORDERS_PK = oi.ORDERS_PK " +
	    "WHERE ( ? IS NULL OR a.ACCOUNT_PK = ? ) " +
	    "  AND ( ? IS NULL OR a.ACCOUNT_NAME LIKE CONCAT('%', ?, '%') ) " +
	    "  AND ( ? IS NULL OR a.ACCOUNT_DATE >= ? ) " +
	    "  AND ( ? IS NULL OR a.ACCOUNT_DATE <= ? ) " +
	    "  AND ( ? IS NULL OR a.ACCOUNT_ROLE = ? ) " +
	    "GROUP BY a.ACCOUNT_PK, a.ACCOUNT_NAME, a.ACCOUNT_DATE, a.ACCOUNT_ROLE " +
	    
	    // 총 구매금액으로 범위 지정
	    "HAVING ( ? IS NULL OR accountTotalAmount >= ? ) " +
	    "   AND ( ? IS NULL OR accountTotalAmount <= ? ) " +
	    "ORDER BY a.ACCOUNT_DATE DESC";
	*/

	// 관리자 회원 정보 조회
	private static final String SELECT_ADMIN_ACCOUNT_INFO_BY_ACCOUNT_PK =
	    "SELECT " +
	    "    a.account_pk           AS accountPk, " +
	    "    a.account_id           AS accountId, " +
	    "    a.account_name         AS accountName, " +
	    "    a.account_date         AS accountDate, " +
	    "    a.account_role         AS accountRole, " +
	    "    a.account_event_opt_in AS accountEventOptIn, " +
	    "    IFNULL(SUM(oi.orders_item_count * oi.orders_item_price), 0) AS accountTotalAmount " +
	    "FROM account a " +
	    "LEFT JOIN orders o ON a.account_pk = o.account_pk " +
	    "LEFT JOIN orders_item oi ON o.orders_pk = oi.orders_pk " +
	    "WHERE a.account_pk = ? " +
	    "GROUP BY " +
	    "    a.account_pk, " +
	    "    a.account_id, " +
	    "    a.account_name, " +
	    "    a.account_date, " +
	    "    a.account_role, " +
	    "    a.account_event_opt_in";

	
    private static final String SELECT_ACCOUNT_EMAIL_EVENT_OPTIN =
            "SELECT a.account_email AS accountEmail " +
            "FROM account a " +
            "WHERE a.account_email IS NOT NULL " +      // 이메일 존재
            "AND a.account_id IS NOT NULL " +           // 탈퇴 회원 제외
            "AND a.account_event_opt_in = 1";           // 이벤트 수신 동의
   
   
	
	
	
	
	
    public List<AccountDTO> selectAll(AccountDTO accountDTO){
        System.out.println("[로그] AccountRepository의 selectAll 시작");
        
        if("SELECT_ALL_ROLE_USER_ACCOUNT_BY_ADMIN_SEARCH".equals(accountDTO.getCondition())) {
           System.out.println("[로그] selectAll의 SELECT_ALL_ROLE_USER_ACCOUNT_BY_ADMIN_SEARCH");
           return jdbcTemplate.query(
              SELECT_ALL_ROLE_USER_ACCOUNT_BY_ADMIN_SEARCH,
              new BeanPropertyRowMapper<>(AccountDTO.class),

              // WHERE ACCOUNT_PK
              accountDTO.getAccountPk(),
              accountDTO.getAccountPk(),

              // WHERE ACCOUNT_NAME
              accountDTO.getAccountName(),
              accountDTO.getAccountName(),

              // WHERE ACCOUNT_DATE >=
              accountDTO.getAccountJoinStartDate(),
              accountDTO.getAccountJoinStartDate(),

              // WHERE ACCOUNT_DATE <=
              accountDTO.getAccountJoinEndDate(),
              accountDTO.getAccountJoinEndDate(),

              // WHERE ACCOUNT_ROLE
              accountDTO.getAccountRole(),
              accountDTO.getAccountRole(),

              // HAVING accountTotalAmount >=
              accountDTO.getAccountTotalAmountMin(),
              accountDTO.getAccountTotalAmountMin(),

              // HAVING accountTotalAmount <=
              accountDTO.getAccountTotalAmountMax(),
              accountDTO.getAccountTotalAmountMax()
           );
        } else if("SELECT_ACCOUNT_EMAIL_EVENT_OPTIN".equals(accountDTO.getCondition())) {
           return jdbcTemplate.query(SELECT_ACCOUNT_EMAIL_EVENT_OPTIN, new BeanPropertyRowMapper<>(AccountDTO.class));
        }
        System.out.println("[로그][경고] AccountDAO의 selectAll_condition 없음");
          return null;
     }

	
	
    public AccountDTO selectOne(AccountDTO accountDTO) {
		
		
    	// 마이페이지 조회
        if ("SELECT_MY_PAGE".equals(accountDTO.getCondition())) {
    		
    		
    		return jdbcTemplate.queryForObject(
        		SELECT_MY_PAGE,
    		    new BeanPropertyRowMapper<>(AccountDTO.class),
    		    accountDTO.getAccountPk()
    		);
        } 
        
        // 탈퇴 전 비밀번호 확인
        else if ("SELECT_CHECK_PASSWORD_BY_PK".equals(accountDTO.getCondition())) {
    		
    		
    		return jdbcTemplate.queryForObject(
        		SELECT_CHECK_PASSWORD_BY_PK,
        		new BeanPropertyRowMapper<>(AccountDTO.class), 
                accountDTO.getAccountPk()
            );
        } 
        
        // 로그인
        else if ("LOGIN".equals(accountDTO.getCondition())) {
    		
    		
    		return jdbcTemplate.queryForObject(
        		LOGIN,
        		new BeanPropertyRowMapper<>(AccountDTO.class), 
                accountDTO.getAccountId()
            );
        } 
        
        // 아이디 중복 확인
        else if ("SELECT_CHECK_LOGIN_ID".equals(accountDTO.getCondition())) {
    		
    		
        	Integer result = jdbcTemplate.queryForObject(
        		SELECT_CHECK_LOGIN_ID,
        		Integer.class,
        	    accountDTO.getAccountId()
        	);
        	return (result != null && result > 0) ? new AccountDTO() : null;
        } 
        
        // 폰 번호 중복 확인
        else if ("SELECT_CHECK_LOGIN_PHONE".equals(accountDTO.getCondition())) {
    		
    		
        	Integer result = jdbcTemplate.queryForObject(
        		SELECT_CHECK_LOGIN_PHONE,
        		Integer.class,
        	    accountDTO.getAccountPhone()
        	);
        	return (result != null && result > 0) ? new AccountDTO() : null;
        } 
        
        // 아이디로 PK 조회 (주문, 장바구니, 주소 등 FK 연결용)
        else if ("SELECT_ACCOUNT_PK_BY_ACCOUNT_ID".equals(accountDTO.getCondition())) {
    		
    		

        	List<AccountDTO> list = jdbcTemplate.query(
        		SELECT_ACCOUNT_PK_BY_ACCOUNT_ID,
        		new BeanPropertyRowMapper<>(AccountDTO.class),
                accountDTO.getAccountId()
            );
        	return list.isEmpty() ? null : list.get(0);
        }
        
        // 계정 1명 조회
        else if("SELECT_ORNABLY_USER_BY_ACCOUNT_ID".equals(accountDTO.getCondition())) {
        	
    		
        	List<AccountDTO> list =  jdbcTemplate.query(
       			SELECT_ORNABLY_USER_BY_ACCOUNT_ID,
    			new BeanPropertyRowMapper<>(AccountDTO.class),
    			accountDTO.getAccountId()
    		);
        	return list.isEmpty() ? null : list.get(0);
        }
        
        // 관리자 회원 정보 조회
        else if("SELECT_ADMIN_ACCOUNT_INFO_BY_ACCOUNT_PK".equals(accountDTO.getCondition())) {
        	
    		
        	return jdbcTemplate.queryForObject(
    			SELECT_ADMIN_ACCOUNT_INFO_BY_ACCOUNT_PK,
    			new BeanPropertyRowMapper<>(AccountDTO.class),
    			accountDTO.getAccountPk()
        	);
        }
		
        return null;
    }
    

    public boolean insert(AccountDTO accountDTO) {
		
    	int result = 0;
    	
    	// 회원 가입
		if("ACCOUNT_JOIN".equals(accountDTO.getCondition())) {
        	
			result = jdbcTemplate.update(
				ACCOUNT_JOIN,
			    accountDTO.getAccountId(),
			    accountDTO.getAccountPasswordHash(),
			    accountDTO.getAccountName(),
			    accountDTO.getAccountEmail(),
			    accountDTO.getAccountPhone(),
			    accountDTO.getAccountEventOptIn(),
			    accountDTO.getAccountRole()
			);
		}
		else {
        	
        }
        return result > 0;
    }
    

    public boolean update(AccountDTO accountDTO) {
		
		int result = 0;
		
    	// 회원 탈퇴
        if ("UPDATE_SIGN_OUT".equals(accountDTO.getCondition())) {
    		
    		
             result = jdbcTemplate.update(
        		UPDATE_SIGN_OUT, 
        		accountDTO.getAccountPk()
        	);
        }
        else {
        	
        }
        return result > 0;
    }
    
    private boolean delete(AccountDTO accountDTO) {
    		return false;
    }
}