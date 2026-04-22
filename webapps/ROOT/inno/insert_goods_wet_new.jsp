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
  
    String qry = "INSERT INTO SM_출고계근(SEQ"
			+ ", 출고상세SEQ"
			+ ", 출고LOTSEQ"
			+ ", 계근중량"
			+ ", 계근중량단위"
			+ ", ppCode"
			+ ", 계근바코드"
			+ ", 패커코드"
			+ ", 제조일자"
			+ ", 박스시리얼"
			+ ", 계근순번"
			+ ", 등록사원"
			+ ", 등록일자"
			+ ", 등록시간"
			+ ", 회사코드"
			+ ", 수정사원"
			+ ", 수정일자"
			+ ", 수정시간)"
			+ " VALUES "
			+ "(NEXT VALUE FOR SM_DLIVY_WEIGH_SEQ,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	PreparedStatement pstmt = conn.prepareStatement(qry);

	for (int i = 0; i < splitDataTotal.length; i++) {

      String[] splitData = splitDataTotal[i].split("::");
	  //SQL


	  pstmt.setInt(1, Integer.parseInt(splitData[0]));                         // 출고상세SEQ (GI_D_ID)
	  pstmt.setInt(2, Integer.parseInt(splitData[14]));                        // 출고LOTSEQ (GI_L_ID)
	  pstmt.setDouble(3, (Double.parseDouble(splitData[1]) * 100) / 100.0);    // 계근중량 (WEIGHT)
	  pstmt.setString(4, splitData[2]);                                        // 계근중량단위 (WEIGHT_UNIT)
	  pstmt.setString(5, splitData[3]);                                        // ppCode (PACKER_PRODUCT_CODE)
	  pstmt.setString(6, splitData[4]);                                        // 계근바코드 (BARCODE)
	  pstmt.setString(7, splitData[5]);                                        // 패커코드 (PACKER_CLIENT_CODE)
	  pstmt.setString(8, splitData[6]);                                        // 제조일자 (MAKINGDATE)
	  pstmt.setString(9, splitData[7]);                                        // 박스시리얼 (BOXSERIAL)
	  pstmt.setInt(10, Integer.parseInt(splitData[8]));                        // 계근순번 (BOX_CNT)
	  pstmt.setString(11, splitData[9]);                                       // 등록사원 (REG_ID)
	  pstmt.setString(12, dateStr);                                            // 등록일자 (서버 자동)
	  pstmt.setString(13, timeStr);                                            // 등록시간 (서버 자동)
	  pstmt.setString(14, splitData[10]);                                      // 회사코드 (Common.selectCompanyCode)
	  pstmt.setString(15, splitData[9]);                                       // 수정사원 (REG_ID와 동일)
	  pstmt.setString(16, dateStr);                                            // 수정일자 (서버 자동)
	  pstmt.setString(17, timeStr);                                            // 수정시간 (서버 자동)

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
		ex.printStackTrace();
		System.out.println("=============insert_goods_wet exception============== message :" + ex.getMessage().toString());
		conn.rollback();
		conn.close();
}
	
  
%>
