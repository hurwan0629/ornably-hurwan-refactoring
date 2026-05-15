package bugsandwich.ornably.wishlist;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class WishlistRepository {
	@Autowired // 의존주입
	private JdbcTemplate jdbcTemplate;

	// 회원의 좋아요 목록 전체 조회
	private static final String SELECT_ALL_WISHLIST_BY_ACCOUNT_PK =
		    // 로그인 사용자 ACCOUNT 정보 미리 계산
		    "WITH acct AS ( " +
		    "  SELECT " +
		    "    a.account_pk AS accountPk, " +
		    "    DATE(a.account_date) AS joinedDate, " +
		    "    a.account_role AS accountRole, " +
		    "    IFNULL(SUM(oi.orders_item_price * oi.orders_item_count), 0) AS totalAmount " +
		    "  FROM account a " +
		    "  LEFT JOIN orders o ON o.account_pk = a.account_pk " +
		    "  LEFT JOIN orders_item oi ON oi.orders_pk = o.orders_pk " +
		    "  WHERE a.account_pk = ? " +   // (1) 로그인 사용자 PK
		    "  GROUP BY a.account_pk, DATE(a.account_date), a.account_role " +
		    "), " +

		    // 위시리스트 기반으로 ITEM 목록 뽑기 (여기가 핵심!)
		    "item_base AS ( " +
		    "  SELECT " +
		    "    w.wishlist_pk AS wishlistPk, " +
		    "    i.item_pk AS itemPk, " +
		    "    i.item_name AS itemName, " +
		    "    i.item_price AS itemPrice, " +
		    "    i.item_image_url AS itemImageUrl, " +
		    "    i.item_category AS itemCategory " +
		    "  FROM wishlist w " +
		    "  JOIN item i ON i.item_pk = w.item_pk " +
		    "  WHERE w.account_pk = ? " +   // (2) 찜 목록 주인 PK
		    ") " +

		    "SELECT " +
		    "  ib.itemPk, " +
		    "  ib.itemImageUrl, " +
		    "  ib.itemName, " +
		    "  ib.itemPrice, " +

		    // 이벤트 최대 할인율
		    "  IFNULL(MAX(e.event_discount_rate), 0) AS itemDiscountRate, " +

		    // 할인가 (최대 할인율 기준)
		    "  CASE " +
		    "    WHEN MAX(e.event_discount_rate) IS NOT NULL " +
		    "    THEN ROUND(ib.itemPrice * (1 - MAX(e.event_discount_rate)/100), 0) " +
		    "    ELSE ib.itemPrice " +
		    "  END AS itemDiscountPrice " +

		    "FROM item_base ib " +

		    // ACCOUNT join (이벤트 조건 계산용)
		    "LEFT JOIN acct a ON 1=1 " +

		    // 이벤트 join
		    "LEFT JOIN event e " +
		    "  ON JSON_CONTAINS(e.event_target_category, JSON_QUOTE(ib.itemCategory)) " +
		    " AND CURRENT_DATE BETWEEN e.event_start_date AND e.event_end_date " +
		    " AND ( " +
		    "       ( ? IS NULL AND e.event_target_account->>'$.type' = 'ALL' ) " + // (3) 비로그인
		    "    OR ( ? IS NOT NULL AND ( " +                                      // (4) 로그인
		    "         e.event_target_account->>'$.type' = 'ALL' " +
		    "      OR (e.event_target_account->>'$.type' = 'AMOUNT' " +
		    "          AND a.totalAmount >= CAST(e.event_target_account->>'$.amount' AS UNSIGNED)) " +
		    "      OR (e.event_target_account->>'$.type' = 'JOINED' " +
		    "          AND a.joinedDate BETWEEN " +
		    "              STR_TO_DATE(e.event_target_account->>'$.startDate','%Y-%m-%d') " +
		    "              AND STR_TO_DATE(e.event_target_account->>'$.endDate','%Y-%m-%d')) " +
		    "      OR (e.event_target_account->>'$.type' = 'MEMBER_TYPE' " +
		    "          AND JSON_CONTAINS(JSON_EXTRACT(e.event_target_account,'$.memberType'), JSON_QUOTE(a.accountRole))) " +
		    "    )) " +
		    " ) " +

		    // 집계 때문에 GROUP BY
		    "GROUP BY ib.wishlistPk, ib.itemPk, ib.itemImageUrl, ib.itemName, ib.itemPrice " +

		    // 찜한 순서 유지
		    "ORDER BY ib.wishlistPk ASC";


	/*
    private static final String SELECT_ALL_WISHLIST_BY_ACCOUNT_PK =
            "SELECT " +
            "  w.item_pk AS itemPk, " +
            "  i.item_image_url AS itemImageUrl, " +
            "  i.item_name AS itemName, " +
            "  i.item_price AS itemPrice, " +
            "  i.item_DISCOUNT_RATE AS itemDiscountRate, " +
            "  ROUND(i.item_price * (100 - i.item_DISCOUNT_RATE) / 100) AS itemDiscountPrice " +
            "FROM wishlist w " +
            "JOIN item i ON w.item_pk = i.item_pk " +
            "WHERE w.account_pk = ? " +
            "ORDER BY w.wishlist_pk ASC";
	*/
	// 좋아요 존재 여부 확인
	private static final String SELECT_WISHLIST_BY_ACCOUNT_PK_AND_ITEM_PK =
	    "SELECT " +
	    "  wishlist_pk AS wishlistPk, " +
	    "  account_pk  AS accountPk, " +
	    "  item_pk     AS itemPk " +
	    "FROM wishlist " +
	    "WHERE account_pk = ? " +
	    "AND item_pk = ?";

	// 좋아요 존재 시 삭제
	private static final String DELETE_WISHLIST_BY_ACCOUNT_PK_AND_ITEM_PK =
	    "DELETE FROM wishlist " +
	    "WHERE account_pk = ? " +
	    "AND item_pk = ?";

	// 좋아요 전체 삭제
	private static final String DELETE_ALL_WISHLIST_BY_ACCOUNT_PK =
	    "DELETE FROM wishlist " +
	    "WHERE account_pk = ?";

	// 좋아요 추가
	private static final String INSERT_WISHLIST_BY_ACCOUNT_PK_AND_ITEM_PK =
	    "INSERT INTO wishlist (account_pk, item_pk) " +
	    "VALUES (?, ?)";

	// 찜 목록 존재 여부 체크
	private static final String SELECT_ONE_WISHLIST_BY_ACCOUNT_PK_AND_ITEM_PK =
		"SELECT wishlist_pk AS wishlistPk" +
		"FROM wishlist " +
		"WHERE account_pk = ? " +
		"AND item_pk = ?";



	public List<WishlistDTO> selectAll(WishlistDTO wishlistDTO) {


	    if ("SELECT_ALL_WISHLIST_BY_ACCOUNT_PK".equals(wishlistDTO.getCondition())) {


	        return jdbcTemplate.query(
	            SELECT_ALL_WISHLIST_BY_ACCOUNT_PK,
	            new BeanPropertyRowMapper<>(WishlistDTO.class),
	            wishlistDTO.getAccountPk(),
	            wishlistDTO.getAccountPk(),
	            wishlistDTO.getAccountPk(),
	            wishlistDTO.getAccountPk()
			);
		}
	    else {

	    }
	    return List.of();
	}


	public WishlistDTO selectOne(WishlistDTO wishlistDTO) {


		//회원고유번호가져와서 해당 회원이 좋아요 누른 상품고유번호가 존재하는지 확인
		if ("SELECT_WISHLIST_BY_ACCOUNT_PK_AND_ITEM_PK".equals(wishlistDTO.getCondition())) {

	        List<WishlistDTO> list = jdbcTemplate.query(
	            SELECT_WISHLIST_BY_ACCOUNT_PK_AND_ITEM_PK,
	            new BeanPropertyRowMapper<>(WishlistDTO.class),
	            wishlistDTO.getAccountPk(),
	            wishlistDTO.getItemPk()
	        );
	        return list.isEmpty() ? null : list.get(0);
	    }
		else if ("SELECT_ONE_WISHLIST_BY_ACCOUNT_PK_AND_ITEM_PK".equals(wishlistDTO.getCondition())) {

	        return jdbcTemplate.queryForObject(
	            SELECT_WISHLIST_BY_ACCOUNT_PK_AND_ITEM_PK,
	            new BeanPropertyRowMapper<>(WishlistDTO.class),
	            wishlistDTO.getAccountPk(),
	            wishlistDTO.getItemPk()
	        );

	    }
	    else {

	    }
	    return null;
	}


	public boolean insert(WishlistDTO wishlistDTO) {

		int result = 0;

		//회원이 좋아요 누른 아이템 생성하기
		if ("INSERT_WISHLIST_BY_ACCOUNT_PK_AND_ITEM_PK".equals(wishlistDTO.getCondition())) {
			result = jdbcTemplate.update(
				INSERT_WISHLIST_BY_ACCOUNT_PK_AND_ITEM_PK,
				wishlistDTO.getAccountPk(),
				wishlistDTO.getItemPk());
		}
	    else {
	    }
		return result > 0;

	}


	public boolean update(WishlistDTO wishlistDTO) {
		return false;
	}


	public boolean delete(WishlistDTO wishlistDTO) {
		int result = 0;

		//해당아이템에 회원의 좋아요가 있을시 삭제하기
		if("DELETE_WISHLIST_BY_ACCOUNT_PK_AND_ITEM_PK".equals(wishlistDTO.getCondition())) {

			result = jdbcTemplate.update(
				DELETE_WISHLIST_BY_ACCOUNT_PK_AND_ITEM_PK,
				wishlistDTO.getAccountPk(),
				wishlistDTO.getItemPk()
			);
		}

		//회원고유번호에 대한 모든 좋아요 삭제하기
		else if("DELETE_ALL_WISHLIST_BY_ACCOUNT_PK".equals(wishlistDTO.getCondition())) {

			result = jdbcTemplate.update(
				DELETE_ALL_WISHLIST_BY_ACCOUNT_PK,
				wishlistDTO.getAccountPk()
			);
		}
		else {

	    }
		return result > 0;
	}
}