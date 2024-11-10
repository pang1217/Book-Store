<%@ page import="java.sql.*, java.util.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<title>Payment</title>

<jsp:include page="./navbar.jsp"></jsp:include>
    
<%
    request.setCharacterEncoding("UTF-8");
    String user = (String) session.getAttribute("user");
    String orderID = request.getParameter("orderID");
    if (user == null) {
        response.sendRedirect("../login.jsp");
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = (new database.connect()).getC();
        conn.setAutoCommit(false);
           
        String paymentApprove = "update Orders set status = 'กำลังเตรียมจัดส่ง' where orderID = ?";
        pstmt = conn.prepareStatement(paymentApprove);
        pstmt.setString(1, orderID);
        pstmt.executeUpdate();
                    
        int rowsUpdated = pstmt.executeUpdate();
        
        if (rowsUpdated > 0) {
            conn.commit();
            response.sendRedirect("../manageOrder.jsp");
        } else {
            conn.rollback();
            out.print("<div class='container'>Order not found or update failed</div>");
        }
    } catch (SQLException e) {
    e.printStackTrace();
        if (conn != null) {
            try {
                conn.rollback(); // Rollback if there was an error
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    } finally {
     // Clean up resources
                        if (rs != null) try {
                            rs.close();
                        } catch (SQLException ignored) {
                        }
                        if (pstmt != null) try {
                            pstmt.close();
                        } catch (SQLException ignored) {
                        }
                        if (conn != null) try {
                            conn.close();
                        } catch (SQLException ignored) {
                        }
    }
%>