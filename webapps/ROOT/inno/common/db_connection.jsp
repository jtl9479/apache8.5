<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%!
    // MSSQL Server 연결
    public Connection getMSSQLConnection() {
        Connection conn = null;
        String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://115.68.112.17:1433;databaseName=weberp_hl;encrypt=false";
        String user = "weberp_hl";
        String password = "weberphl1234!!";

        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("INNO DB 연결 성공");
        } catch (Exception e) {
            System.out.println("INNO DB 연결 실패");
            e.printStackTrace();
        }
        return conn;
    }

    // DB 연결 종료
    public void closeDB(Connection conn, Statement stmt, ResultSet rs) {
        try { if(rs != null) rs.close(); } catch(Exception e) {}
        try { if(stmt != null) stmt.close(); } catch(Exception e) {}
        try { if(conn != null) conn.close(); } catch(Exception e) {}
    }
%>
