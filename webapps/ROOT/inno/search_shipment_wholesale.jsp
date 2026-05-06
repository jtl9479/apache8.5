<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.apache.log4j.Logger"%>
<%@ include file="common/db_connection.jsp" %>
<%!
 static Logger logger = Logger.getLogger("search_shipment.jsp");
%>
<%
boolean connection = false;
Connection conn = null;

request.setCharacterEncoding("UTF-8");

String qry_where = request.getParameter("data");
String dbid = request.getParameter("dbid");
System.out.println("==================================");
System.out.println("=========search_shipment==========");
System.out.println("==================================");
System.out.println(qry_where);
try {
	conn = getMSSQLConnection();
	if(conn != null) {
		connection = true;
	}
} catch (Exception e) {
	connection = false;
	System.out.println("DB 연결 실패");
	out.println(e.getMessage().toString());
	e.printStackTrace();
}
 //SQL 
  Statement stmt = conn.createStatement();
  
  String quertystring = "SELECT /* 도매 출하대상 조회 */"
								+ "  D.SEQ AS GI_D_ID"
								+ ", I.품목코드 AS ITEM_CODE"
								+ ", I.품목명 AS ITEM_NAME"
								+ ", 'NA' AS EMARTITEM_CODE"
								+ ", 'NA' AS EMARTITEM"
								+ ", L.박스수량 AS GI_REQ_PKG"
								+ ", L.중량 AS GI_REQ_QTY"
								+ ", D.출고일자 AS GI_REQ_DATE"
								+ ", COALESCE(NULLIF(V.BLNO, ''), V.이력번호) AS BL_NO"
								+ ", '' AS BRAND_CODE"
								+ ", H.출고거래처 AS CLIENT_CODE"
								+ ", G.상호 AS CLIENTNAME"
								+ ", G.상호 AS CENTERNAME"
								+ ", I.규격 AS ITEM_SPEC"
								+ ", I.원산지 AS CT_CODE"
								+ ", V.이력번호 AS IMPORT_ID_NO"
								+ ", I.패커코드 AS PACKER_CODE"
								+ ", I.PPCODE AS PACKER_PRODUCT_CODE"
								+ ", 'NA' AS BARCODE_TYPE"
								+ ", 'S' AS ITEM_TYPE"
								+ ", 'NA' AS PACKWEIGHT"
								+ ", I.상품바코드 AS BARCODEGOODS"
								+ ", D.출고일자 AS STORE_IN_DATE"
								+ ", '0000000' AS EMARTLOGIS_CODE"
								+ " FROM SM_출고상세 D"
								+ " INNER JOIN SM_출고머리 H"
								+ "   ON H.회사코드 = D.회사코드"
								+ "  AND H.출고사업장 = D.출고사업장"
								+ "  AND H.출고일자 = D.출고일자"
								+ "  AND H.출고일련번호 = D.출고일련번호"
								+ " JOIN CO_품목코드 I"
								+ "   ON D.회사코드 = I.회사코드"
								+ "  AND D.출고품목코드 = I.품목코드"
								+ " LEFT JOIN CO_거래처MASTER G"
								+ "   ON G.회사코드 = D.회사코드"
								+ "  AND G.거래처코드 = H.출고거래처"
								+ " JOIN SM_출고LOT L"
								+ "   ON L.출고상세SEQ = D.SEQ"
								+ " LEFT JOIN 월품목별재고화일_LOT별_VIEW V"
								+ "   ON V.회사코드 = D.회사코드"
								+ "  AND V.사업장 = D.출고사업장"
								+ "  AND V.창고코드 = D.창고코드"
								+ "  AND V.품목코드 = D.출고품목코드"
								+ "  AND V.LOTNO = L.LOTNO"
								+ " WHERE H.마트사구분 = ''"
								+ "   AND D.출고수량 > 0"
								+ "   AND I.원료육여부 = '1'"
								+ qry_where
								+ " ORDER BY D.SEQ ASC"
								;
  
  ResultSet rs = stmt.executeQuery(quertystring);
  
  System.out.println("##search_shipment query :" + quertystring);
  
  ResultSetMetaData rsmd = rs.getMetaData();
	int columnCnt = rsmd.getColumnCount();

  while(rs.next())
  {
   out.println(
			  rs.getString("GI_D_ID") + "::"             // 0
			+ rs.getString("ITEM_CODE") + "::"           // 1
			+ rs.getString("ITEM_NAME") + "::"           // 2
			+ rs.getString("EMARTITEM_CODE") + "::"      // 3
			+ rs.getString("EMARTITEM") + "::"           // 4
			+ rs.getString("GI_REQ_PKG") + "::"          // 5
			+ rs.getString("GI_REQ_QTY") + "::"          // 6
			+ rs.getString("GI_REQ_DATE") + "::"         // 7
			+ rs.getString("BL_NO") + "::"               // 8
			+ rs.getString("BRAND_CODE") + "::"          // 9
			+ rs.getString("CLIENT_CODE") + "::"         // 10
			+ rs.getString("CLIENTNAME") + "::"          // 11
			+ rs.getString("CENTERNAME") + "::"          // 12
			+ rs.getString("ITEM_SPEC") + "::"           // 13
			+ rs.getString("CT_CODE") + "::"             // 14
			+ rs.getString("IMPORT_ID_NO") + "::"        // 15
			+ rs.getString("PACKER_CODE") + "::"         // 16
			+ rs.getString("PACKER_PRODUCT_CODE") + "::" // 17
			+ rs.getString("BARCODE_TYPE") + "::"        // 18
			+ rs.getString("ITEM_TYPE") + "::"           // 19
			+ rs.getString("PACKWEIGHT") + "::"          // 20
			+ rs.getString("BARCODEGOODS") + "::"        // 21
			+ rs.getString("STORE_IN_DATE") + "::"       // 22
			+ rs.getString("EMARTLOGIS_CODE") + ";;");   // 23
  }

	try{
	  if(rs != null) 
		  rs.close();
	  if(stmt != null) 
		  stmt.close();
	  if(conn != null) 
		  conn.close();
	 }catch(SQLException se){
	}

%>