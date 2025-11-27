<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>

<%
	request.setCharacterEncoding("UTF-8");
	String companyCode = request.getParameter("companyCode");
	String id = request.getParameter("id");
	String pwd = request.getParameter("pwd");
	byte[] pwdII = null;
	StringBuilder sb = new StringBuilder();	
	System.out.println("id : " + id);

	boolean connection = false;

	Connection conn = null;
	String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
	String url = "jdbc:sqlserver://115.68.112.17:1433;databaseName=weberp_dev;encrypt=false";

	try {
		Class.forName(driver);
		conn = DriverManager.getConnection(url,"weberp_dev", "weberpdev!@#");
		connection = true;
		System.out.println("INNO DB 연결 성공");
	} catch (Exception e) {
		connection = false;
		System.out.println("INNO DB 연결 실패");
		out.println("fail");
		e.printStackTrace();
	}
	System.out.println("url=" + url);
	System.out.println("id=" + id + "   pwd " + pwd);

	//SQL
	//비밀번호 조회 비밀번호 
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery("SELECT 비밀번호 from CO_비밀번호 WHERE 회사코드 = '" + companyCode + "' AND 사번 = '" + id + "' ");
	ResultSetMetaData rsmd = rs.getMetaData();

	int count = 0;

	while (rs.next()) {
		count++;
		pwdII = rs.getBytes(rsmd.getColumnName(1));

		for (byte b : pwdII) {
			sb.append(String.format("%02x", b));  // 16진수로 변환
		}		

		System.out.println(sb.toString());
	}

	if(sb.toString().equals(pwd)) {
		out.println(id);
	} else {
		out.println("fail");
	}

	try{
		if(rs != null)
			rs.close();
		if(stmt != null)
			stmt.close();
		if(conn != null)
			conn.close();
	}catch(SQLException se){
		System.out.println("연결객체 오류");
	}
%>