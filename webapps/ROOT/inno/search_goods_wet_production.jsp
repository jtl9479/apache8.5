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
 static Logger logger = Logger.getLogger("search_goods_wet_production.jsp");
%>
<%
/*
 * 생산(searchType=1) 계근 이력 조회 → PD_생산계근
 *
 * search_goods_wet.jsp(SM_출고계근)와 출력 구조는 동일하며,
 * 조회 테이블과 키 컬럼만 생산(PD) 모듈로 교체한다.
 *
 *   SM_출고계근.출고상세SEQ → PD_생산계근.소요량SEQ (PD_생산작업지시소요량.SEQ)
 *   SM_출고계근.출고LOTSEQ  → PD_생산계근.지시SEQ   (PD_생산작업지시.SEQ)
 *
 * 용도 : 서버에 저장된 계근 이력을 PDA로 복원 (앱 재설치·기기 교체 대응)
 *        ProgressDlgBarcodeSearch 완료 후 ProgressDlgGoodsWetSearch 가 호출
 *
 * 출력 14개 컬럼 순서는 search_goods_wet.jsp 와 동일해야 한다.
 *   ProgressDlgGoodsWetSearch 가 temp[0]~temp[13] 으로 파싱
 */
boolean connection = false;
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;

request.setCharacterEncoding("UTF-8");

String qry_where = request.getParameter("data");
String dbid = request.getParameter("dbid");

// 앱이 보내는 키 컬럼(SM_출고계근 기준)을 생산 계근 컬럼으로 치환
//   출고상세SEQ → 소요량SEQ
if (qry_where != null) {
	qry_where = qry_where.replace("출고상세SEQ", "소요량SEQ");
} else {
	qry_where = "";
}

System.out.println("============================================");
System.out.println("====search_goods_wet_production start=======");
System.out.println("============================================");
System.out.println("##search_goods_wet_production all parameter :" + qry_where);

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
	SimpleDateFormat dateformat = new SimpleDateFormat("yyyyMMdd");
	long now = System.currentTimeMillis();
	Date datetime = new Date(now);
	String dateStr = dateformat.format(datetime);

 //SQL
 	stmt = conn.createStatement();

	String quertystring = "SELECT 소요량SEQ AS GI_D_ID"
		+ ", 계근중량 AS WEIGHT"
		+ ", 계근중량단위 AS WEIGHT_UNIT"
		+ ", PPCODE AS PACKER_PRODUCT_CODE"
		+ ", 계근바코드 AS BARCODE"
		+ ", 패커코드 AS PACKER_CLIENT_CODE"
		+ ", 계근순번 AS BOX_CNT"
		+ ", 등록사원 AS REG_ID"
		+ ", 등록일자 AS REG_DATE"
		+ ", 등록시간 AS REG_TIME"
		+ ", 제조일자 AS MAKINGDATE"
		+ ", 박스시리얼 AS BOXSERIAL"
		+ ", '' AS BOX_ORDER"
		+ ", 지시SEQ AS GI_L_ID"
		+ " FROM PD_생산계근"
		+ qry_where
		+ " ORDER BY GI_D_ID ASC";

	rs = stmt.executeQuery(quertystring);

	System.out.println("##search_goods_wet_production query :" + quertystring);

  	ResultSetMetaData rsmd = rs.getMetaData();
	int columnCnt = rsmd.getColumnCount();

 	 while(rs.next())
  	{
 	 out.println(rs.getString(rsmd.getColumnName(1)) + "::" + rs.getString(rsmd.getColumnName(2)) + "::" + rs.getString(rsmd.getColumnName(3)) + "::"
			+ rs.getString(rsmd.getColumnName(4)) + "::" + rs.getString(rsmd.getColumnName(5)) + "::" + rs.getString(rsmd.getColumnName(6)) + "::"
			+ rs.getString(rsmd.getColumnName(7)) + "::" + rs.getString(rsmd.getColumnName(8)) + "::" + rs.getString(rsmd.getColumnName(9)) + "::"
			+ rs.getString(rsmd.getColumnName(10)) + "::" + rs.getString(rsmd.getColumnName(11)) + "::" + rs.getString(rsmd.getColumnName(12)) + "::" + rs.getString(rsmd.getColumnName(13)) + "::" + rs.getString(rsmd.getColumnName(14)) + ";;");
  	}
	} catch (Exception ex) {
		out.println(ex.getMessage().toString());
		ex.printStackTrace();
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
