<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.apache.log4j.Logger"%>
<%@ include file="common/db_connection.jsp" %>
<%!
 static Logger logger = Logger.getLogger("search_barcode_info.jsp");
%>
<%
boolean connection = false;
Connection conn = null;

request.setCharacterEncoding("UTF-8");

String qry_where = request.getParameter("data");
String dbid = request.getParameter("dbid");
System.out.println("============================================");
System.out.println("=========search_barcode_info start==========");
System.out.println("============================================");
System.out.println("##search_barcode_info all parameter :" + qry_where);

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
 //SQL
  Statement stmt = conn.createStatement();
  // Java(ProgressDlgBarcodeSearch.java)에서 WHERE SBI.ITEM_CODE = '...' 형태로 전송
  // CO_품목코드의 실제 컬럼명은 '품목코드'이므로 ITEM_CODE → 품목코드로 치환
  qry_where = qry_where.replace("SBI.ITEM_CODE", "SBI.품목코드");
	String quertystring = "SELECT '이마트용' as PACKER_CLIENT_CODE"
		+ ", SBI.품목코드 as PACKER_PRODUCT_CODE"
		+ ", SBI.품목명 as PACKER_PRD_NAME"
		+ ", SBI.품목코드 as ITEMCODE"
		+ ", SBI.품목명 as ITEM_NAME_KR"
		+ ", '0000' as BRAND_CODE"
		+ ", SBI.품목코드 as BARCODEGOODS"
		+ ", 'KG' as BASEUNIT"
		+ ", SBI.소수점 AS ZEROPOINT"
		+ ", '' AS PACKER_PRD_CODE_FROM"
		+ ", '' AS PACKER_PRD_CODE_TO"
		+ ", SBI.바코드상품코드시작 AS BARCODEGOODS_FROM"
		+ ", SBI.바코드상품코드끝 AS BARCODEGOODS_TO"
		+ ", SBI.중량시작 AS WEIGHT_FROM"
		+ ", SBI.중량끝 AS WEIGHT_TO"
		+ ", SBI.제조일자시작 AS MAKINGDATE_FROM"
		+ ", SBI.제조일자끝 AS MAKINGDATE_TO"
		+ ", SBI.박스시리얼시작 AS BOXSERIAL_FROM"
		+ ", SBI.박스시리얼끝 AS BOXSERIAL_TO"
		+ ", SBI.생산품상태 AS STATUS"
		+ ", '' AS REG_ID"
		+ ", '' AS REG_DATE"
		+ ", '' AS REG_TIME"
		+ ", '0000' AS memo"
		+ " FROM CO_품목코드 SBI"
		+ qry_where
		+ " ORDER BY ITEMCODE ASC";
  
  ResultSet rs = stmt.executeQuery(quertystring);
  
  System.out.println("##search_barcode_info query :" + quertystring);
  
  ResultSetMetaData rsmd = rs.getMetaData();
	int columnCnt = rsmd.getColumnCount();

  
  while(rs.next())
  {
  out.println(rs.getString(rsmd.getColumnName(1)) + "::" + rs.getString(rsmd.getColumnName(2)) + "::" + rs.getString(rsmd.getColumnName(3)) + "::"	
			+ rs.getString(rsmd.getColumnName(4)) + "::" + rs.getString(rsmd.getColumnName(5)) + "::" + rs.getString(rsmd.getColumnName(6)) + "::" 
			+ rs.getString(rsmd.getColumnName(7)) + "::" + rs.getString(rsmd.getColumnName(8)) + "::" + rs.getString(rsmd.getColumnName(9)) + "::" 
			+ rs.getString(rsmd.getColumnName(10)) + "::" + rs.getString(rsmd.getColumnName(11)) + "::" + rs.getString(rsmd.getColumnName(12)) + "::" 
			+  rs.getString(rsmd.getColumnName(13)) + "::" + rs.getString(rsmd.getColumnName(14)) + "::" + rs.getString(rsmd.getColumnName(15)) + "::" 
			+ rs.getString(rsmd.getColumnName(16)) + "::" + rs.getString(rsmd.getColumnName(17)) + "::" + rs.getString(rsmd.getColumnName(18)) + "::" 
			+ rs.getString(rsmd.getColumnName(19)) + "::" + rs.getString(rsmd.getColumnName(20)) + "::" + rs.getString(rsmd.getColumnName(21)) + "::" 
			+ rs.getString(rsmd.getColumnName(22)) + "::" + rs.getString(rsmd.getColumnName(23)) + "::" + rs.getString(rsmd.getColumnName(24)) + ";;");
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
