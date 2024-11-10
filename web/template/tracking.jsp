<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String user = (String) session.getAttribute("user");
        
    if (user == null) {
        response.sendRedirect("./login.jsp");
        return; // Stop further execution
    }
    
    String tracking = "ไปรษณีย์ไทย EMS : " + request.getParameter("trackingNo");
    String orderID = request.getParameter("orderID");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = (new database.connect()).getC();
        conn.setAutoCommit(false);
           
        String setTracking = "update Orders set status = 'จัดส่ง' ,trackingNO = ? where orderID = ?";
        pstmt = conn.prepareStatement(setTracking);
        pstmt.setString(1, tracking);
        pstmt.setString(2, orderID);
        pstmt.executeUpdate();
                    
        int rowsUpdated = pstmt.executeUpdate();
        
        if (rowsUpdated > 0) {
            conn.commit();
            response.sendRedirect("../manage.jsp");
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

