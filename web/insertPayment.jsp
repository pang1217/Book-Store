<%@page import="java.io.InputStream"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Insert Payment</title>
</head>
<body>
    
    <jsp:include page="./template/navbar.jsp"></jsp:include>
    <div class='container d-flex flex-column justify-content-center align-items-center vh-100 text-center'>
<%
    request.setCharacterEncoding("UTF-8");
    String user = (String) session.getAttribute("user");
        
    if (user == null) {
        response.sendRedirect("./login.jsp");
        return; // Stop further execution
    }
    
    String account = request.getParameter("account");
    String date = request.getParameter("date");
    String time = request.getParameter("time");
    String orderID = request.getParameter("orderID");
    String slipBase64 = request.getParameter("slipBase64");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        conn = (new database.connect()).getC();
        conn.setAutoCommit(false);

        // Insert payment information into the database
        String insertPaymentSQL = "INSERT INTO Payments (orderID, account, paymentDate, paymentTime, paymentSlip, uploadDate) VALUES (?, ?, ?, ?, ?, NOW())";
        pstmt = conn.prepareStatement(insertPaymentSQL);
        pstmt.setString(1, orderID);
        pstmt.setString(2, account);
        pstmt.setString(3, date);
        pstmt.setString(4, time);
        pstmt.setBytes(5, java.util.Base64.getDecoder().decode(slipBase64));
        pstmt.executeUpdate();
        
        // Update status when insertPatment success!
        String changeStatus = "update orders set status = 'รอตรวจสอบการชำระเงิน' where orderID = ? and userID = ?";
        pstmt = conn.prepareStatement(changeStatus);
        pstmt.setString(1, orderID);
        pstmt.setString(2, user);
        pstmt.executeUpdate();
        
        conn.commit(); // Commit the transaction
        
        %>
        
        <h1>Payment information submitted successfully!</h1>
        <a href="./orderDetail.jsp?orderID=<%=orderID%>">ดูใบคำสั่งซื้อ</a>
        <hr class="w-50 mx-auto">
        <a href='./index.jsp' class='btn btn-secondary'>กลับหน้าหลัก</a>
        
        <%
    } catch (SQLException e) {
        e.printStackTrace();
        if (conn != null) {
            try {
                conn.rollback(); // Rollback if there was an error
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        %>
        <h1>Error processing payment information. Please try again.</h1>
        <a href='./index.jsp' class='btn btn-secondary'>กลับหน้าหลัก</a>
        <%
    } finally {
        // Clean up resources
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
    </div>
    <jsp:include page="./template/footer.jsp"></jsp:include>
</body>
</html>
