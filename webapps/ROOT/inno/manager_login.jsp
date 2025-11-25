<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>

<%
	request.setCharacterEncoding("UTF-8");
	String id = request.getParameter("id");
	String pwd = request.getParameter("pwd");
	System.out.println("id : " + id);

	boolean connection = false;

	Connection conn = null;
	String driver = "oracle.jdbc.driver.OracleDriver";
	String url = "jdbc:oracle:thin:@1.1.1.1:SIDname";
	String USER_TYPE = "";

	try {
		Class.forName(driver);
		conn = DriverManager.getConnection(url,"DBuser", "DBpassword");
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
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery("SELECT USER_TYPE from S_USER WHERE USER_ID = '" + id + "' AND USER_PASSWORD_ORIGIN = '" + pwd + "'");
//  ResultSet rs = stmt.executeQuery("SELECT USER_TYPE from S_USER WHERE USER_ID = 'Admin' AND USER_PASSWORD_ORIGIN = 'MzcwMA=='");
	ResultSetMetaData rsmd = rs.getMetaData();

	int columnCnt = rsmd.getColumnCount(); //컬럼????

	int count = 0;

	while(rs.next())
	{
		count++;
		USER_TYPE = rs.getString(rsmd.getColumnName(1));
		//out.println(rs.getString(rsmd.getColumnName(1)));
	}
	if(count > 0) {
		out.println(USER_TYPE);
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