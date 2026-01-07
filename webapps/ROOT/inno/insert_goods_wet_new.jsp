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
 static Logger logger = Logger.getLogger("insert_goods_wet.jsp");
%>
<%
boolean connection = false;
Connection conn = null;

request.setCharacterEncoding("UTF-8");
String data = request.getParameter("data");
String dbid = request.getParameter("dbid"); //real
System.out.println("=============dbidCheck==============="+dbid);

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
  //String[] splitData = data.split("::");
  String[] splitDataTotal = data.split("##");
  
  System.out.println("####LENGTH CHECK#### : "+splitDataTotal.length);
  System.out.println("####LENGTH CHECK#### : "+splitDataTotal[0]);
	
  System.out.println("============================================");
  System.out.println("=========insert_goods_wet start=============");
  System.out.println("============================================");
  System.out.println("##insert_goods_wet all parameter :" + data);	

  SimpleDateFormat dateformat = new SimpleDateFormat("yyyyMMdd");
  SimpleDateFormat timeformat = new SimpleDateFormat("HHmmss");

  long now = System.currentTimeMillis();
  Date datetime = new Date(now);
  String dateStr = dateformat.format(datetime);
  String timeStr = timeformat.format(datetime);
  
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

	for (int i = 0; i < splitDataTotal.length; i++) {
	
      String[] splitData = splitDataTotal[i].split("::");	
	  //SQL 
	  

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

	  System.out.println("##insert_goods_wet query start, query :"+ qry);	
	  
	  pstmt.executeUpdate();
	  pstmt.clearParameters();
	  
	  System.out.println("##insert_goods_wet parameter : ======INSERT_GOODS_WET PARAMS=====");
	  System.out.println("##insert_goods_wet parameter : ========GI_D_ID===================" + splitData[0]);
	  System.out.println("##insert_goods_wet parameter : ========WEIGHT====================" + splitData[1]);
	  System.out.println("##insert_goods_wet parameter : ========DATE======================" + dateStr + timeStr);
	  System.out.println("##insert_goods_wet parameter : ========REG_ID====================" + splitData[9]);
	  System.out.println("##insert_goods_wet parameter : ==================================");
	  
	}
	
	conn.commit();
	
	if(pstmt != null) 
    pstmt.close();
    if(conn != null) 
    conn.close();
	
  out.println("s");  
} catch (Exception ex) {
		out.println("f");
		//out.println(ex.getMessage());
		ex.printStackTrace();
		System.out.println("=============insert_goods_wet exception============== message :" + ex.getMessage().toString());
		conn.rollback();
		conn.close();
}
	
  
%>
