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
 static Logger logger = Logger.getLogger("insert_goods_wet_production.jsp");
%>
<%
/*
 * 생산(searchType=1) 계근 데이터 전송 → PD_생산계근 INSERT
 *
 * insert_goods_wet_new.jsp(SM_출고계근)와 배치 처리 구조는 동일하며,
 * 적재 테이블과 참조 키만 생산(PD) 모듈로 교체한다.
 *
 *   SM_출고계근.출고상세SEQ → PD_생산계근.소요량SEQ (PD_생산작업지시소요량.SEQ)
 *   SM_출고계근.출고LOTSEQ  → PD_생산계근.지시SEQ   (PD_생산작업지시.SEQ)
 *
 * SM_출고계근을 사용하지 않는 이유
 *  - 출고상세SEQ/출고LOTSEQ 는 SM_출고상세/SM_출고LOT 참조 키이므로
 *    PD_ 계열 SEQ 를 넣으면 키 공간이 충돌한다.
 *
 * packet 구조 (BixolonShipmentActivity.java L2716~2730)
 *  행 구분자 "##", 컬럼 구분자 "::"
 *  [0] GI_D_ID(=Q.SEQ)  [1] WEIGHT             [2] WEIGHT_UNIT   [3] PACKER_PRODUCT_CODE
 *  [4] BARCODE          [5] PACKER_CLIENT_CODE [6] MAKINGDATE    [7] BOXSERIAL
 *  [8] BOX_CNT          [9] REG_ID             [10] 회사코드      [11] BRAND_CODE
 *  [12] CLIENT_TYPE     [13] BOX_ORDER         [14] GI_L_ID(=H.SEQ)
 */
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
  System.out.println("=====insert_goods_wet_production start======");
  System.out.println("============================================");
  System.out.println("##insert_goods_wet_production all parameter :" + data);

  SimpleDateFormat dateformat = new SimpleDateFormat("yyyyMMdd");
  SimpleDateFormat timeformat = new SimpleDateFormat("HHmmss");

  long now = System.currentTimeMillis();
  Date datetime = new Date(now);
  String dateStr = dateformat.format(datetime);
  String timeStr = timeformat.format(datetime);

    String qry = "INSERT INTO PD_생산계근(SEQ"
			+ ", 소요량SEQ"
			+ ", 지시SEQ"
			+ ", 계근중량"
			+ ", 계근중량단위"
			+ ", PPCODE"
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
			+ "(NEXT VALUE FOR PD_PRDCTN_WEIGH_SEQ,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	PreparedStatement pstmt = conn.prepareStatement(qry);

	for (int i = 0; i < splitDataTotal.length; i++) {

      String[] splitData = splitDataTotal[i].split("::");
	  //SQL


	  pstmt.setInt(1, Integer.parseInt(splitData[0]));                         // 소요량SEQ (GI_D_ID = PD_생산작업지시소요량.SEQ)
	  pstmt.setInt(2, Integer.parseInt(splitData[14]));                        // 지시SEQ (GI_L_ID = PD_생산작업지시.SEQ)
	  pstmt.setDouble(3, (Double.parseDouble(splitData[1]) * 100) / 100.0);    // 계근중량 (WEIGHT, 앱에서 버림 완료)
	  pstmt.setString(4, splitData[2]);                                        // 계근중량단위 (WEIGHT_UNIT)
	  pstmt.setString(5, splitData[3]);                                        // PPCODE (PACKER_PRODUCT_CODE)
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

	  System.out.println("##insert_goods_wet_production query start, query :"+ qry);

	  pstmt.executeUpdate();
	  pstmt.clearParameters();

	  System.out.println("##insert_goods_wet_production parameter : ===INSERT_PRDCTN_WEIGH PARAMS===");
	  System.out.println("##insert_goods_wet_production parameter : ========소요량SEQ=================" + splitData[0]);
	  System.out.println("##insert_goods_wet_production parameter : ========지시SEQ===================" + splitData[14]);
	  System.out.println("##insert_goods_wet_production parameter : ========WEIGHT====================" + splitData[1]);
	  System.out.println("##insert_goods_wet_production parameter : ========DATE======================" + dateStr + timeStr);
	  System.out.println("##insert_goods_wet_production parameter : ========REG_ID====================" + splitData[9]);
	  System.out.println("##insert_goods_wet_production parameter : ==================================");

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
		System.out.println("=============insert_goods_wet_production exception============== message :" + ex.getMessage().toString());
		conn.rollback();
		conn.close();
}


%>
