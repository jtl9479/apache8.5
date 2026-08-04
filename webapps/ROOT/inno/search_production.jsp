<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.apache.log4j.Logger"%>
<%@ include file="common/db_connection.jsp" %>
<%!
 static Logger logger = Logger.getLogger("search_production.jsp");
%>
<%
/*
 * 생산(searchType=1) 계근대상 조회
 *
 * Oracle VW_PDA_WID_PRO_LIST → MSSQL 직접 JOIN 전환
 *
 *   W_GOODS_IH (GI_TYPE='M1') → PD_생산작업지시
 *   W_GOODS_ID                → PD_생산작업지시소요량
 *   B_ITEM                    → CO_품목코드
 *   W_GOODS_R                 → 제거 (월품목별재고화일_LOT별_VIEW + CO_품목코드 로 분해)
 *   I_OFFER_D                 → 제거 (CO_품목코드.패커코드 / PPCODE)
 *   B_CLIENT                  → CO_거래처MASTER
 *
 * 출력 컬럼 32개 → 25개 (24개 표준 + GI_L_ID)
 *   ProgressDlgShipSearch.java temp[0]~temp[24] 와 1:1 대응
 *   개발09(로컬DB v28)로 삭제된 8개 컬럼 제외
 *   : GI_H_ID, EOI_ID, AMOUNT, GOODS_R_ID, GR_REF_NO, BRANDNAME, PACKERNAME, EMARTLOGIS_NAME
 */
boolean connection = false;
Connection conn = null;

request.setCharacterEncoding("UTF-8");

String qry_where = request.getParameter("data");

// 앱이 보내는 별칭(SM_출고상세 기준)을 생산 테이블 별칭으로 치환
//   D.회사코드 → Q.회사코드 (PD_생산작업지시소요량)
//   D.출고일자 → H.지시일자 (PD_생산작업지시)
if (qry_where != null) {
	qry_where = qry_where.replace("D.회사코드", "Q.회사코드")
						 .replace("D.출고일자", "H.지시일자");
} else {
	qry_where = "";
}

System.out.println("==============inno==============");
System.out.println("=========search_production==========");
System.out.println("====================================");
System.out.println("##search_production all parameter :" + qry_where);

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
  String quertystring = "SELECT /* 생산 계근대상 조회 */"
								+ " Q.SEQ                                                   AS GI_D_ID"
								+ ", Q.자재코드                                               AS ITEM_CODE"
								+ ", I.품목명                                                 AS ITEM_NAME"
								+ ", ''                                                       AS EMARTITEM_CODE"
								+ ", ''                                                       AS EMARTITEM"
								+ ", CAST(CEILING(ROUND(Q.실소요량, 2) / NULLIF(COALESCE(NULLIF(V.평균중량, 0), I.박스중량), 0)) AS INT) AS GI_REQ_PKG"
								+ ", Q.실소요량                                               AS GI_REQ_QTY"
								+ ", H.지시일자                                               AS GI_REQ_DATE"
								+ ", COALESCE(NULLIF(V.BLNO, ''), NULLIF(Q.이력번호, ''), '') AS BL_NO"
								+ ", ''                                                       AS BRAND_CODE"
								+ ", ''                                                       AS CLIENT_CODE"
								+ ", ISNULL(G.상호, '')                                       AS CLIENTNAME"
								+ ", '하이랜드푸드'                                           AS CENTERNAME"
								+ ", ''                                                       AS ITEM_SPEC"
								+ ", ''                                                       AS CT_CODE"
								+ ", COALESCE(NULLIF(Q.이력번호, ''), '0000')                 AS IMPORT_ID_NO"
								+ ", I.패커코드                                               AS PACKER_CODE"
								+ ", COALESCE(NULLIF(I.PPCODE, ''), '0000')                   AS PACKER_PRODUCT_CODE"
								+ ", ''                                                       AS BARCODE_TYPE"
								+ ", CASE WHEN I.비정량여부 = 1 THEN 'S' ELSE 'J' END         AS ITEM_TYPE"
								+ ", COALESCE(NULLIF(V.평균중량, 0), I.박스중량)              AS PACKWEIGHT"
								+ ", COALESCE(NULLIF(I.상품바코드, ''), '0000000')            AS BARCODEGOODS"
								+ ", ''                                                       AS STORE_IN_DATE"
								+ ", ''                                                       AS EMARTLOGIS_CODE"
								+ ", H.SEQ                                                    AS GI_L_ID"
								+ " FROM PD_생산작업지시소요량 Q"
								+ " INNER JOIN PD_생산작업지시 H"
								+ "   ON H.SEQ = Q.HSEQ"
								+ " JOIN CO_품목코드 I"
								+ "   ON I.회사코드 = Q.회사코드"
								+ "  AND I.품목코드 = Q.자재코드"
								+ " LEFT JOIN 월품목별재고화일_LOT별_VIEW V"
								+ "   ON V.회사코드 = Q.회사코드"
								+ "  AND V.사업장 = Q.사업장"
								+ "  AND V.창고코드 = Q.창고코드"
								+ "  AND V.품목코드 = Q.자재코드"
								+ "  AND V.LOTNO = Q.LOTNO"
								+ "  AND V.년월 = LEFT(H.지시일자, 6)"
								+ " LEFT JOIN CO_거래처MASTER G"
								+ "   ON G.회사코드 = Q.회사코드"
								+ "  AND G.거래처코드 = H.거래처코드"
								+ " WHERE Q.실소요량 <> 0"
								+ "   AND I.대분류 = '2'"
								+ "   AND NOT EXISTS ("
								+ "         SELECT 1"
								+ "           FROM PD_생산계근 W"
								+ "          WHERE W.소요량SEQ = Q.SEQ"
								+ "            AND W.회사코드 = Q.회사코드"
								+ "       )"
								+ qry_where
								+ " ORDER BY GI_D_ID ASC";

  System.out.println("##search_production query :" + quertystring);

  ResultSet rs = null;
  try {
      rs = stmt.executeQuery(quertystring);
  } catch (SQLException sqle) {
      System.out.println("##search_production SQLException : " + sqle.getMessage());
      sqle.printStackTrace();
      throw sqle;
  }

  ResultSetMetaData rsmd = rs.getMetaData();
	int columnCnt = rsmd.getColumnCount();

  while(rs.next()) {
	out.println(
		rs.getString("GI_D_ID") + "::" +             // 0
		rs.getString("ITEM_CODE") + "::" +           // 1
		rs.getString("ITEM_NAME") + "::" +           // 2
		rs.getString("EMARTITEM_CODE") + "::" +      // 3
		rs.getString("EMARTITEM") + "::" +           // 4
		rs.getString("GI_REQ_PKG") + "::" +          // 5
		rs.getString("GI_REQ_QTY") + "::" +          // 6
		rs.getString("GI_REQ_DATE") + "::" +         // 7
		rs.getString("BL_NO") + "::" +               // 8
		rs.getString("BRAND_CODE") + "::" +          // 9
		rs.getString("CLIENT_CODE") + "::" +         // 10
		rs.getString("CLIENTNAME") + "::" +          // 11
		rs.getString("CENTERNAME") + "::" +          // 12
		rs.getString("ITEM_SPEC") + "::" +           // 13
		rs.getString("CT_CODE") + "::" +             // 14
		rs.getString("IMPORT_ID_NO") + "::" +        // 15
		rs.getString("PACKER_CODE") + "::" +         // 16
		rs.getString("PACKER_PRODUCT_CODE") + "::" + // 17
		rs.getString("BARCODE_TYPE") + "::" +        // 18
		rs.getString("ITEM_TYPE") + "::" +           // 19
		rs.getString("PACKWEIGHT") + "::" +          // 20
		rs.getString("BARCODEGOODS") + "::" +        // 21
		rs.getString("STORE_IN_DATE") + "::" +       // 22
		rs.getString("EMARTLOGIS_CODE") + "::" +     // 23
		rs.getString("GI_L_ID") + ";;"               // 24
		);
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
