package bugsandwich.ornably.ordersItem;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class OrdersItemRepository {
	@Autowired	// 의존 주입
	private JdbcTemplate jdbcTemplate;
	
	// 주문 상세 조회
	private static final String SELECT_ALL_ORDERS_ITEM = 
		    "SELECT DISTINCT ORD.orders_pk 	AS ordersPk, " +
		    "       ORD.orders_item_pk 		AS ordersItemPk, " +
		    "       I.item_name 			AS itemName, " +
		    "       I.item_pk 				AS itemPk, " +
		    "       ORD.orders_item_count 	AS ordersItemCount, " +
		    "       ORD.orders_item_price 	AS ordersItemPrice, " +
		    "       I.item_image_url 		AS itemImageUrl, " +
		    "       CASE WHEN EXISTS (SELECT 1 FROM review R WHERE R.item_pk = I.item_pk AND R.account_pk = ?) " +
		    "            THEN 1 ELSE 0 END AS isReviewed " +
		    "FROM ( " +
		    "    SELECT O.orders_pk, OI.orders_item_pk, OI.item_pk, OI.orders_item_count, OI.orders_item_price " +
		    "    FROM orders O INNER JOIN orders_item OI ON O.orders_pk = OI.orders_pk " +
		    ") ORD " +
		    "INNER JOIN item I ON ORD.item_pk = I.item_pk " +
		    "WHERE ORD.orders_pk = ? " +
		    "ORDER BY ORD.orders_item_pk";
					
	// 주문 상세 등록
	private static final String INSERT_ORDERS_ITEM = 
		    "INSERT INTO orders_item (orders_pk, item_pk, orders_item_count, orders_item_price) " +
		    "VALUES (?, ?, ?, ?)";

	
	// 주문 상세 삭제
	private static final String DELETE_ORDERS_ITEM = 
		    "DELETE FROM orders_item " +
		    "WHERE orders_pk IN (SELECT orders_pk FROM orders WHERE account_pk = ?)";
	
    
    
	
	public List<OrdersItemDTO> selectAll(OrdersItemDTO ordersItemDTO){
		
		
		// 주문내역에 해당 주문상세들 전체 출력
		if("SELECT_ALL_ORDERS_ITEM".equals(ordersItemDTO.getCondition())) {
			
			
			return jdbcTemplate.query(
				SELECT_ALL_ORDERS_ITEM,
				new BeanPropertyRowMapper<>(OrdersItemDTO.class),
				ordersItemDTO.getAccountPk(),
				ordersItemDTO.getOrdersPk()
			);
		}
		
		return null;
	}
	

	private OrdersItemDTO selectOne(OrdersItemDTO orderItemDTO) {
		return null;
	}
	
	
	public boolean insert(OrdersItemDTO orderItemDTO) {
		
		int result = 0;

		// 주문이 들어오면 해당 주문의 상품 상세 정보를 DB에 기록
		if("INSERT_ORDERS_ITEM".equals(orderItemDTO.getCondition())) {
			System.out.println("adf");
			System.out.println(orderItemDTO);
			result = jdbcTemplate.update(
				INSERT_ORDERS_ITEM,
				orderItemDTO.getOrdersPk(),
				orderItemDTO.getItemPk(),
				orderItemDTO.getOrdersItemCount(),
				orderItemDTO.getOrdersItemPrice() // ORDERS_ITEM_PRICE : 수량 X 단가 = 총액
			);
		}
		else {
			
		}
		return result > 0;
	}
	

	private boolean update(OrdersItemDTO orderItemDTO) {
		return false;
	}
	
	
	public boolean delete(OrdersItemDTO ordersItemDTO) {
		
		int result = 0;
		
		// 주문 상세 삭제
		if("DELETE_ORDERS_ITEM".equals(ordersItemDTO.getCondition())) {
			result = jdbcTemplate.update(
				DELETE_ORDERS_ITEM, 
				ordersItemDTO.getAccountPk()
			);
		}
		else {
			
		}
		return result > 0;
	}
}