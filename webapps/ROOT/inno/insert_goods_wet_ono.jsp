<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="org.apache.log4j.Logger"%>
<%@ include file="common/db_connection.jsp" %>
<%!
 static Logger logger = Logger.getLogger("insert_goods_wet_ono.jsp");
%>
<%
boolean connection = false;
Connection conn = null;

request.setCharacterEncoding("UTF-8");
String data = request.getParameter("data");

try {
	conn = getMSSQLConnection();
	if(conn != null) {
		connection = true;
	}
} catch (Exception e) {
	connection = false;
	out.println(e.getMessage().toString());
	e.printStackTrace();
} 
try {
	String[] splitData = data.split("::");

  System.out.println("============================================");
  System.out.println("=========insert_goods_wet_ono start=========");
  System.out.println("============================================");
  System.out.println("##insert_goods_wet_ono all parameter :" + data);

  SimpleDateFormat dateformat = new SimpleDateFormat("yyyyMMdd");
  SimpleDateFormat timeformat = new SimpleDateFormat("HHmmss");

  long now = System.currentTimeMillis();
  Date datetime = new Date(now);
  String dateStr = dateformat.format(datetime);
  String timeStr = timeformat.format(datetime);

 //SQL 
  String qry = "INSERT INTO W_GOODS_WET(GOODS_WET_ID"
		+ ", GI_D_ID"
		+ ", WEIGHT"
		+ ", WEIGHT_UNIT"
		+ ", PACKER_PRODUCT_CODE"
		+ ", BARCODE"
		+ ", PACKER_CLIENT_CODE"
		+ ", MAKINGDATE"
		+ ", BOXSERIAL"
		+ ", BOX_CNT"
		+ ", REG_ID"
		+ ", REG_DATE"
		+ ", REG_TIME)"
		+ " VALUES "
		+ "(W_GOODS_WET_SEQ.NEXTVAL,?,?,?,?,?,?,?,?,?,?,?,?)";
  PreparedStatement pstmt = conn.prepareStatement(qry);
  
  

  pstmt.setInt(1, Integer.parseInt(splitData[0]));
  pstmt.setDouble(2, (Double.parseDouble(splitData[1]) * 100) / 100.0);
  pstmt.setString(3, splitData[2]);
  pstmt.setString(4, splitData[3]);
  pstmt.setString(5, splitData[4]);
  pstmt.setString(6, splitData[5]);
  pstmt.setString(7, splitData[6]);
  pstmt.setString(8, splitData[7]);
  pstmt.setInt(9, Integer.parseInt(splitData[8]));
  pstmt.setString(10, splitData[9]);
  pstmt.setString(11, dateStr);
  pstmt.setString(12, timeStr);
	
  pstmt.executeUpdate();

	String update_qry = "UPDATE W_GOODS_ID SET "
			+ "GI_QTY = GI_QTY +  ? "
			+ ", PACKING_QTY = PACKING_QTY + 1 "
			+", REG_ID = ? "
			+ ", REG_DATE = ? "
			+ ", REG_TIME = ? "
			+ "WHERE GI_D_ID = ? AND ITEM_CODE = ? AND BRAND_CODE = ?"; 
	pstmt = conn.prepareStatement(update_qry);  

	pstmt.setDouble(1, (Double.parseDouble(splitData[1]) * 100) / 100.0);
	pstmt.setString(2, splitData[9]);
	pstmt.setString(3, dateStr);
	pstmt.setString(4, timeStr);
	pstmt.setInt(5, Integer.parseInt(splitData[0]));
	pstmt.setString(6, splitData[10]);		// ITEM_CODE
	pstmt.setString(7, splitData[11]);		// BRAND_CODE

	pstmt.executeUpdate();


  conn.commit();

  System.out.println("##insert_goods_wet_ono parameter : ======INSERT_GOODS_WET_ONO PARAMS=====");
  System.out.println("##insert_goods_wet_ono parameter : ========GI_D_ID===================" + splitData[0]);
  System.out.println("##insert_goods_wet_ono parameter : ========WEIGHT====================" + splitData[1]);
  System.out.println("##insert_goods_wet_ono parameter : ========DATE======================" + dateStr + timeStr);
  System.out.println("##insert_goods_wet_ono parameter : ========REG_ID====================" + splitData[9]);
  System.out.println("##insert_goods_wet_ono parameter : ==================================");

  if(pstmt != null)
	  pstmt.close();
  if(conn != null)
	  conn.close();
  out.println("s");
} catch (Exception ex) {
		out.println("f");
		out.println(ex.getMessage());
		ex.printStackTrace();
		System.out.println("=============insert_goods_wet_ono exception============== message :" + ex.getMessage().toString());
		conn.rollback();
		conn.close();
}
	
  
%>
