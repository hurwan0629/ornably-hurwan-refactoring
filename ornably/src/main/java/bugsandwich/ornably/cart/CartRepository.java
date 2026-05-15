package bugsandwich.ornably.cart;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class CartRepository {
	@Autowired // 의존 주입
	private JdbcTemplate jdbcTemplate;
	
	// 회원 장바구니 목록 조회 (상품 정보 JOIN)
	// 장바구니 조회 (사용자 대상 이벤트 조건 반영 + 아이템별 최대할인율 적용)
	private static final String SELECT_ALL_CART =
	    "WITH "
	  + "acct AS ( "
	  + "  SELECT "
	  + "    a.account_pk AS accountPk, "
	  + "    DATE(a.account_date) AS joinedDate, "
	  + "    a.account_role AS accountRole, "
	  + "    IFNULL(SUM(oi.orders_item_price * oi.orders_item_count), 0) AS totalAmount "
	  + "  FROM account a "
	  + "  LEFT JOIN orders o ON o.account_pk = a.account_pk "
	  + "  LEFT JOIN orders_item oi ON oi.orders_pk = o.orders_pk "
	  + "  WHERE a.account_pk = ? "
	  + "  GROUP BY a.account_pk, DATE(a.account_date), a.account_role "
	  + "), "
	  + "cart_items AS ( "
	  + "  SELECT "
	  + "    c.cart_pk AS cartPk, "
	  + "    c.item_pk AS itemPk, "
	  + "    c.cart_count AS cartCount "
	  + "  FROM cart c "
	  + "  WHERE c.account_pk = ? "
	  + "), "
	  + "event_max AS ( "
	  + "  SELECT "
	  + "    ci.itemPk AS itemPk, "
	  + "    MAX(IFNULL(e.event_discount_rate, 0)) AS maxDiscountRate "
	  + "  FROM cart_items ci "
	  + "  JOIN item i ON i.item_pk = ci.itemPk "
	  + "  JOIN event e "
	  + "    ON JSON_CONTAINS(e.event_target_category, JSON_QUOTE(i.item_category)) "
	  + "   AND CURRENT_DATE BETWEEN e.event_start_date AND e.event_end_date "
	  + "  LEFT JOIN acct a ON 1 = 1 "
	  + "  WHERE ( "
	  + "    (a.accountPk IS NULL AND (e.event_target_account->>'$.type') = 'ALL') "
	  + "    OR "
	  + "    (a.accountPk IS NOT NULL AND ( "
	  + "         (e.event_target_account->>'$.type') = 'ALL' "
	  + "      OR ( "
	  + "         (e.event_target_account->>'$.type') = 'AMOUNT' "
	  + "         AND a.totalAmount >= CAST(e.event_target_account->>'$.amount' AS UNSIGNED) "
	  + "      ) "
	  + "      OR ( "
	  + "         (e.event_target_account->>'$.type') = 'JOINED' "
	  + "         AND a.joinedDate BETWEEN "
	  + "             STR_TO_DATE(e.event_target_account->>'$.startDate', '%Y-%m-%d') "
	  + "             AND STR_TO_DATE(e.event_target_account->>'$.endDate', '%Y-%m-%d') "
	  + "      ) "
	  + "      OR ( "
	  + "         (e.event_target_account->>'$.type') = 'MEMBER_TYPE' "
	  + "         AND JSON_CONTAINS( "
	  + "               JSON_EXTRACT(e.event_target_account, '$.memberType'), "
	  + "               JSON_QUOTE(a.accountRole) "
	  + "             ) "
	  + "      ) "
	  + "    )) "
	  + "  ) "
	  + "  GROUP BY ci.itemPk "
	  + ") "
	  + "SELECT "
	  + "  ci.cartPk AS cartPk, "
	  + "  i.item_pk AS itemPk, "
	  + "  i.item_image_url AS itemImageUrl, "
	  + "  i.item_name AS itemName, "
	  + "  i.item_price AS itemPrice, "
	  + "  IFNULL(em.maxDiscountRate, 0) AS itemDiscountRate, "
	  + "  CASE "
	  + "    WHEN IFNULL(em.maxDiscountRate, 0) > 0 "
	  + "      THEN ROUND(i.item_price * (1 - IFNULL(em.maxDiscountRate, 0) / 100), 0) "
	  + "    ELSE i.item_price "
	  + "  END AS itemDiscountPrice, "
	  + "  ci.cartCount AS cartCount "
	  + "FROM cart_items ci "
	  + "JOIN item i ON i.item_pk = ci.itemPk "
	  + "LEFT JOIN event_max em ON em.itemPk = i.item_pk "
	  + "ORDER BY ci.cartPk DESC ";

		    
	
	
	// 장바구니 상품 추가 (중복 시 수량 증가, 최대 99 제한)
	private static final String INSERT_CART_OR_UPDATE =
		    "INSERT INTO cart (account_pk, item_pk, cart_count) " +
		    "VALUES (?, ?, ?) " +
		    "ON DUPLICATE KEY UPDATE " +
		    "cart_count = LEAST(cart_count + VALUES(cart_count), 99)";

	
	// 장바구니 상품 개수 직접 변경
	private static final String UPDATE_CART_ITEM_COUNT =
	    "UPDATE cart " +
	    "SET cart_count = LEAST(?, 99) " +
	    "WHERE cart_pk = ? AND account_pk = ?";


	// 장바구니 상품 개수 증가
	private static final String ADD_CART_ITEM_COUNT =
	    "UPDATE cart " +
	    "SET cart_count = LEAST(cart_count + ?, 99) " +
	    "WHERE cart_pk = ? AND account_pk = ?";

	
	// 장바구니 상품 1개 삭제
	private static final String DELETE_CART_ITEM =
		    "DELETE FROM cart " +
		    "WHERE cart_pk = ? AND account_pk = ?";
	
	
	// 결제 완료 시 회원 장바구니 전체 삭제
	private static final String DELETE_CART_BY_ACCOUNT_PK =
		    "DELETE FROM cart " +
		    "WHERE account_pk = ?";
	

	
	
	public List<CartDTO> selectAll(CartDTO cartDTO){
		
		
		// 사용자의 장바구니 목록 조회
	    if ("SELECT_ALL_CART".equals(cartDTO.getCondition())) {
			
			return jdbcTemplate.query(
				SELECT_ALL_CART,
				new BeanPropertyRowMapper<>(CartDTO.class),
				cartDTO.getAccountPk(),
				cartDTO.getAccountPk()
			);
		}
		
		return null;
	}
	
	
	private CartDTO selectOne(CartDTO cartDTO) {
		return null;
	}
	
	
	public boolean insert(CartDTO cartDTO) {
		
		int result = 0;
		
		// 장바구니 추가 (이미 같은 상품 존재 시 개수만 증가)
		if ("INSERT_CART_OR_UPDATE".equals(cartDTO.getCondition())) {
			
			result = jdbcTemplate.update(
				INSERT_CART_OR_UPDATE, 
				cartDTO.getAccountPk(),
		        cartDTO.getItemPk(),
		        cartDTO.getCartCount()
		    );
		}
		else {
        	
        }
		return result > 0;
	}
	
	
	public boolean update(CartDTO cartDTO) {
	    
	    int result = 0;

	    // 장바구니 상품 개수 직접 변경
	    if ("UPDATE_CART_ITEM_COUNT".equals(cartDTO.getCondition())) {
			
	        result = jdbcTemplate.update(
	            UPDATE_CART_ITEM_COUNT,
	            cartDTO.getCartNewCount(),
	            cartDTO.getCartPk(),
	            cartDTO.getAccountPk()
	        );
	    }
	    
	    // 장바구니 상품 개수 증가
	    else if ("ADD_CART_ITEM_COUNT".equals(cartDTO.getCondition())) {
			
	        result = jdbcTemplate.update(
	            ADD_CART_ITEM_COUNT,
	            cartDTO.getCartCount(),
	            cartDTO.getCartPk(),
	            cartDTO.getAccountPk()
	        );
	    }
		else {
        	
        }
	    return result > 0;
	}
	
	public boolean delete(CartDTO cartDTO) {
		
		
		int result = 0;

		// 회원 장바구니 전체 삭제
		if ("DELETE_CART_BY_ACCOUNT_PK".equals(cartDTO.getCondition())) {
			
			result = jdbcTemplate.update(
				DELETE_CART_BY_ACCOUNT_PK,
				cartDTO.getAccountPk()
			);
		}
		
		// 장바구니 항목 1개만 삭제 : X 버튼 클릭 시
		else if ("DELETE_CART_ITEM".equals(cartDTO.getCondition())) {
			
			result = jdbcTemplate.update(
				DELETE_CART_ITEM,
				cartDTO.getCartPk(),
				cartDTO.getAccountPk()
			);
		}
		else {
        	
        }
		return result > 0;
	}
}

