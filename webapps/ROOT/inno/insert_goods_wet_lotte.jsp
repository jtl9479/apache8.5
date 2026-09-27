<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.logging.Logger" %>
<%@ include file="common/db_connection.jsp" %>
<%!
 static Logger logger = Logger.getLogger("insert_goods_wet_lotte.jsp");
%>
<%
/*
 * 롯데(searchType 6) 전용 계근 적재
 *
 * insert_goods_wet.jsp(건별) 와 동일한 구조이며 박스순번 1개만 추가한다.
 * 롯데는 라벨 바코드 시퀀스를 위해 박스순번을 이어받아야 하는데,
 * insert_goods_wet.jsp 에는 해당 컬럼 INSERT 가 없어 값이 적재되지 않았다.
 *
 * 저장된 박스순번은 search_shipment_lotte.jsp 의 LAST_BOX_ORDER 서브쿼리가
 * ORDER BY W.SEQ DESC 로 최근 1건을 읽어 다음 계근의 시작값으로 사용한다.
 *
 * 패킷: 단건, "::" 구분 (일괄용 "##" 없음)
 *   [0] GI_D_ID   [1] WEIGHT   [2] WEIGHT_UNIT  [3] PACKER_PRODUCT_CODE
 *   [4] BARCODE   [5] PACKER_CLIENT_CODE        [6] MAKINGDATE
 *   [7] BOXSERIAL [8] BOX_CNT  [9] REG_ID       [10] 회사코드
 *   [11] BRAND_CODE(미사용)    [12] CLIENT_TYPE(미사용)
 *   [13] BOX_ORDER ← 박스순번   [14] GI_L_ID
 *
 * 관련: 개발/63_롯데_박스순번_파이프라인_복구[36].md
 *       오류/36_롯데_search_shipment_lotte_박스순번_계근ID_미존재컬럼...md
 */
boolean connection = false;
Connection conn = null;

request.setCharacterEncoding("UTF-8");
String data = request.getParameter("data");
String dbid = request.getParameter("dbid");

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
  System.out.println("=====insert_goods_wet_lotte start===========");
  System.out.println("============================================");
  System.out.println("##insert_goods_wet_lotte all parameter :" + data);

  SimpleDateFormat dateformat = new SimpleDateFormat("yyyyMMdd");
  SimpleDateFormat timeformat = new SimpleDateFormat("HHmmss");

  long now = System.currentTimeMillis();
  Date datetime = new Date(now);
  String dateStr = dateformat.format(datetime);
  String timeStr = timeformat.format(datetime);

  // 박스순번 미설정 방어 - 빈 값이면 0 으로 적재 (NumberFormatException 방지)
  int boxOrder = 0;
  if(splitData.length > 13 && splitData[13] != null && !"".equals(splitData[13].trim())) {
	  boxOrder = Integer.parseInt(splitData[13].trim());
  }

 //SQL
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
		+ ", 박스순번"
		+ ", 등록사원"
		+ ", 등록일자"
		+ ", 등록시간"
		+ ", 회사코드"
		+ ", 수정사원"
		+ ", 수정일자"
		+ ", 수정시간)"
		+ " VALUES "
		+ "(NEXT VALUE FOR SM_DLIVY_WEIGH_SEQ,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
  PreparedStatement pstmt = conn.prepareStatement(qry);


  pstmt.setInt(1, Integer.parseInt(splitData[0]));       // 출고상세SEQ (GI_D_ID)
  pstmt.setInt(2, Integer.parseInt(splitData[14]));      // 출고LOTSEQ (GI_L_ID)
  pstmt.setDouble(3, (Double.parseDouble(splitData[1]) * 100) / 100.0);  // 계근중량
  pstmt.setString(4, splitData[2]);                      // 계근중량단위
  pstmt.setString(5, splitData[3]);                      // ppCode
  pstmt.setString(6, splitData[4]);                      // 계근바코드
  pstmt.setString(7, splitData[5]);                      // 패커코드
  pstmt.setString(8, splitData[6]);                      // 제조일자
  pstmt.setString(9, splitData[7]);                      // 박스시리얼
  pstmt.setInt(10, Integer.parseInt(splitData[8]));      // 계근순번
  pstmt.setInt(11, boxOrder);                            // 박스순번 (롯데 전용)
  pstmt.setString(12, splitData[9]);                     // 등록사원
  pstmt.setString(13, dateStr);                          // 등록일자
  pstmt.setString(14, timeStr);                          // 등록시간
  pstmt.setString(15, splitData[10]);                    // 회사코드
  pstmt.setString(16, splitData[9]);                     // 수정사원
  pstmt.setString(17, dateStr);                          // 수정일자
  pstmt.setString(18, timeStr);                          // 수정시간


  System.out.println("##insert_goods_wet_lotte query start, query :"+ qry);
  pstmt.executeUpdate();

  conn.commit();

  System.out.println("##insert_goods_wet_lotte parameter : ==INSERT_GOODS_WET_LOTTE PARAMS==");
  System.out.println("##insert_goods_wet_lotte parameter : ========GI_D_ID===================" + splitData[0]);
  System.out.println("##insert_goods_wet_lotte parameter : ========WEIGHT====================" + splitData[1]);
  System.out.println("##insert_goods_wet_lotte parameter : ========BOX_ORDER=================" + boxOrder);
  System.out.println("##insert_goods_wet_lotte parameter : ========DATE======================" + dateStr + timeStr);
  System.out.println("##insert_goods_wet_lotte parameter : ========REG_ID====================" + splitData[9]);
  System.out.println("##insert_goods_wet_lotte parameter : ==================================");

  if(pstmt != null)
	  pstmt.close();
  if(conn != null)
	  conn.close();
  out.println("s");
} catch (Exception ex) {
		out.println("f");
		out.println(ex.getMessage());
		ex.printStackTrace();
		System.out.println("=======insert_goods_wet_lotte exception======== message :" + ex.getMessage().toString());
		conn.rollback();
		conn.close();
}


%>
