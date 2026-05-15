package bugsandwich.ornably.orders;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class OrdersRepository {
	@Autowired // 의존주입
	private JdbcTemplate jdbcTemplate;

	// 회원 주문 전체 조회
	private static final String SELECT_ALL_ORDERS_BY_ACCOUNT_PK =
		"WITH ranked_items AS ( "
		+ "  SELECT "
		+ "    OI.orders_pk, "
		+ "    OI.item_pk, "
		+ "    (OI.orders_item_price * OI.orders_item_count) AS lineAmount, "
		+ "    ROW_NUMBER() OVER ( "
		+ "      PARTITION BY OI.orders_pk "
		+ "      ORDER BY (OI.orders_item_price * OI.orders_item_count) DESC, OI.item_pk ASC "
		+ "    ) AS rn "
		+ "  FROM orders_item OI "
		+ "), "
		+ "order_sum AS (\r\n"
		+ "  SELECT\r\n"
		+ "    OI.orders_pk,\r\n"
		+ "    SUM(OI.orders_item_count) AS ordersItemCount,\r\n"
		+ "    SUM(OI.orders_item_price * OI.orders_item_count) AS ordersTotalAmount\r\n"
		+ "  FROM orders_item OI\r\n"
		+ "  GROUP BY OI.orders_pk\r\n"
		+ ")\r\n"
		+ "SELECT\r\n"
		+ "  O.orders_pk AS ordersPk,\r\n"
		+ "  O.orders_status AS ordersStatus,\r\n"
		+ "  I.item_image_url AS itemImageUrl,\r\n"
		+ "  I.item_name AS ordersSignatureItemName,\r\n"
		+ "  S.ordersItemCount AS ordersItemCount,\r\n"
		+ "  O.address_name AS addressName,\r\n"
		+ "  DATE_FORMAT(O.orders_date, '%Y-%m-%d') AS ordersDate,\r\n"
		+ "  S.ordersTotalAmount AS ordersTotalAmount\r\n"
		+ "FROM orders O\r\n"
		+ "JOIN order_sum S\r\n"
		+ "  ON S.orders_pk = O.orders_pk\r\n"
		+ "JOIN ranked_items R\r\n"
		+ "  ON R.orders_pk = O.orders_pk AND R.rn = 1\r\n"
		+ "JOIN item I\r\n"
		+ "  ON I.item_pk = R.item_pk\r\n"
		+ "WHERE O.account_pk = ?\r\n"
		+ "ORDER BY O.orders_date DESC";
	/*
        "SELECT " +
        "    O.ORDERS_PK AS ordersPk, " +
        "    O.ORDERS_STATUS AS ordersStatus, " +
        "    I.ITEM_IMAGE_URL AS itemImageUrl, " +
        "    I.ITEM_NAME AS ordersSignatureItemName, " +
        "    SUM(OI.ORDERS_ITEM_COUNT) AS ordersItemCount, " +
        "    O.ADDRESS_NAME AS addressName, " +
        "    DATE_FORMAT(O.ORDERS_DATE, '%Y-%m-%d') AS ordersDate, " +
        "    SUM(OI.ORDERS_ITEM_COUNT * OI.ORDERS_ITEM_PRICE) AS ordersTotalAmount " +
        "FROM ORDERS O " +
        "JOIN ORDERS_ITEM OI " +
        "ON O.ORDERS_PK = OI.ORDERS_PK " +
        "JOIN ITEM I " +
        "ON OI.ITEM_PK = I.ITEM_PK " +
        "WHERE O.ACCOUNT_PK = ? " +
        "GROUP BY O.ORDERS_PK " +
        "ORDER BY O.ORDERS_DATE DESC";
	*/

	// 주문 추가
    private static final String INSERT_ORDERS =
            "INSERT INTO orders " +
            "    (account_pk, orders_date, address_name, orders_payment_type, orders_import_uid, orders_message, orders_status) " +
            "SELECT ?, NOW(), address_name, ?, ?, ?, '상품 준비중' " +
            "FROM address " +
            "WHERE address_pk = ?";


    // 주문 상세 페이지 주문 정보 조회
    private final static String SELECT_ONE_ORDERS_PAGE_DATA =
    	"SELECT \r\n"
    	+ "orders_import_uid ordersImportUid,"
    	+ "orders_date ordersDate,"
    	+ "orders_status ordersStatus,"
    	+ "orders_payment_type ordersPaymentType,"
    	+ "orders_message ordersMessage, "
    	+ "address_name addressName "
    	+ "FROM orders O "
    	+ "WHERE orders_pk = ?";

	// 회원 최근 주문 조회
	private final static String SELECT_ORDERS_PK_BY_UID =
			"SELECT orders_pk AS ordersPk " +
			"FROM orders " +
			"WHERE orders_import_uid = ?";
			/*
	    "SELECT ORDERS_PK AS ordersPk " +
	    "FROM ORDERS " +
	    "WHERE ACCOUNT_PK = ? " +
	    "ORDER BY ORDERS_PK DESC " +
	    "LIMIT 1";
*/
	// 회원 주문 삭제
	private final static String DELETE_ONE_ORDERS =
	    "DELETE FROM orders WHERE account_pk = ?";




	public List<OrdersDTO> selectAll(OrdersDTO orderDTO){


		// 마이 페이지 들어갔을 때 주문내역 전체 출력
		if("SELECT_ALL_ORDERS_BY_ACCOUNT_PK".equals(orderDTO.getCondition())) {

			return jdbcTemplate.query(
					SELECT_ALL_ORDERS_BY_ACCOUNT_PK,
				new BeanPropertyRowMapper<>(OrdersDTO.class),
				orderDTO.getAccountPk()
			);
		}

		return null;
	}


	public OrdersDTO selectOne(OrdersDTO orderDTO) {


		// 주문내역 생성 후 해당 주문내역의 주문상세 생성을 위한 주문내역 PK 보내줌
		if("SELECT_ONE_ORDERS_PK_BY_UID".equals(orderDTO.getCondition())) {

			return jdbcTemplate.queryForObject(
				SELECT_ORDERS_PK_BY_UID,
				new BeanPropertyRowMapper<>(OrdersDTO.class),
				orderDTO.getOrdersImportUid()
			);
		}
		else if("SELECT_ONE_ORDERS_PAGE_DATA".equals(orderDTO.getCondition())) {

			return jdbcTemplate.queryForObject(
				SELECT_ONE_ORDERS_PAGE_DATA,
				new BeanPropertyRowMapper<>(OrdersDTO.class),
				orderDTO.getOrdersPk()
			);
		}

		return null;
	}


	private boolean update(OrdersDTO orderDTO) {
		return false;
	}


	public boolean insert(OrdersDTO orderDTO) {

		int result = 0;

		// 주문내역 생성
		if("INSERT_ORDERS".equals(orderDTO.getCondition())) {

			result = jdbcTemplate.update(
				INSERT_ORDERS,
				orderDTO.getAccountPk(),
				orderDTO.getOrdersPaymentType(),
				orderDTO.getOrdersImportUid(),
				orderDTO.getOrdersMessage(),
				orderDTO.getAddressPk()
			);
		}
		else {

		}
		return result > 0;
	}


	public boolean delete(OrdersDTO orderDTO) {

		int result = 0;

		// 회원 탈퇴 시 해당 회원 주문내역 전부 삭제
		if("DELETE_ALL_ORDER_BY_ACCOUNT_PK".equals(orderDTO.getCondition())) {

			result = jdbcTemplate.update(
				DELETE_ONE_ORDERS,
				orderDTO.getAccountPk()
			);
		}
		else {

		}
		return result > 0;	}
}


