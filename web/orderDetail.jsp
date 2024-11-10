<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order Detail</title>
        <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css">
        <script src="./Bootstrap/js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="./template/navbar.jsp"></jsp:include>
            <div class="container mt-5">
                <h1>ใบสั่งซื้อ</h1>
                <hr>
            <%
                request.setCharacterEncoding("UTF-8");
                String user = (String) session.getAttribute("user");
                String orderID = request.getParameter("orderID");
                double total = 0.0;

                if (user == null) {
                    response.sendRedirect("./login.jsp");
                    return; // Stop further execution
                }

                // Database connection
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                double totalAmount = 0;
                String status = "";
                try {
                    conn = (new database.connect()).getC();
                    conn.setAutoCommit(false);

                    // Get address detail
                    String GetAddress = "SELECT a.name, a.address, a.phone, o.status, o.trackingNO "
                    + "from orders o "
                    + "join addresses a on a.addressID = o.addressID "
                    + "where o.orderID = ?";
                    pstmt = conn.prepareStatement(GetAddress);
                    pstmt.setString(1, orderID);
//                    pstmt.setString(2, user);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        String name = rs.getString("name");
                        String address = rs.getString("address");
                        String phone = rs.getString("phone");
                        status = rs.getString("status");
                        String trackingNO = rs.getString("trackingNO");
                        
                        if(trackingNO == null){ trackingNO = "-";}
            %>

            <div>
                <p><strong>หมายเลขใบสั่งซื้อ : </strong> <%=orderID%><br>
                    <strong>ชื่อ : </strong> <%=name%><br>
                    <strong>ที่อยู่ในการจัดส่ง : </strong> <%=address%><br>
                    <strong>เบอร์โทรศัพท์ : </strong> <%=phone%><br>
                    <strong>สถานะใบคำสั่งซื้อ : </strong> <%=status%><br>
                    <strong>ติดตามคำสั่งซื้อ : </strong> <%=trackingNO%> <br>
                </p>
                <hr>

                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th></th>
                            <th>ชื่อสินค้า</th>
                            <th>ราคา</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            } else {
                                out.println("<p>No address details found for this order.</p>");
                            }

                            rs = null;
                            // Get order details
                            String getOrderDetail = "SELECT * FROM orderDetails od "
                                    + "JOIN books b ON od.bookID = b.bookid "
                                    + "JOIN Orders o ON o.orderID = od.orderID "
                                    + "WHERE o.orderID = ?";
                            pstmt = conn.prepareStatement(getOrderDetail);
                            pstmt.setString(1, orderID);
                            rs = pstmt.executeQuery();

                            while (rs.next()) {
                                String title = rs.getString("name");
                                String author = rs.getString("author");
                                int bookid = rs.getInt("bookid");
                                int qty = rs.getInt("quantity");
                                double price = rs.getDouble("buyPrice"); // Remove extra space
                                double subtotal = price * qty;
                                total += subtotal;
                        %>
                        <tr>
                            <td><img src="image?bookid=<%= bookid%>" alt="Book Image" style="width: 100px; height: auto;"></td>
                            <td><strong><%= title%></strong><br><%= author%></td>
                            <td><strong><%= price%> X <%= qty%></strong><br><%= subtotal%> บาท</td>
                        </tr>
                        <%
                } // End of order details
                %>
                    </tbody>
                </table>
                <p class='text-end'><strong>สรุปยอดชำระรวม : <%= total%> บาท</strong></p>
            </div>
            <%   conn.commit(); // Commit the transaction if everything goes well
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.print("<p>Error processing payment information. Please try again.</p>");
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
                        }%>
        </div>
        <jsp:include page="./template/footer.jsp"></jsp:include>
    </body>
</html>
