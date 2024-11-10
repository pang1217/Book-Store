<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %> 
<%
    request.setCharacterEncoding("UTF-8");
    String user = (String) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("./login.jsp");
        return; // Stop further execution
    }

    String orderID = request.getParameter("orderID");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
            conn = (new database.connect()).getC();
            conn.setAutoCommit(false);

            String sql = "update Orders set status = 'ยกเลิก' where orderID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, orderID);
            pstmt.executeUpdate();

            int rowsUpdated = pstmt.executeUpdate();
            
            String query = "SELECT bookid, quantity FROM OrderDetails WHERE orderID = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, orderID);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                String bookID = rs.getString("bookid");
                int quantityOrdered = rs.getInt("quantity");

                // เพิ่มจำนวนสินค้าในสต็อกคืน
                String updateStock = "UPDATE Books SET qtyInstock = qtyInstock + ? WHERE bookid = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateStock);
                updateStmt.setInt(1, quantityOrdered);
                updateStmt.setString(2, bookID);
                updateStmt.executeUpdate();
            }
            
            conn.commit();
            response.sendRedirect("./orderDetail.jsp?orderID="+ orderID);
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