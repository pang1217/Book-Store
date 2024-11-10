<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Payment</title>
        <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css">
        <script>
            function confirmPayment() {
                return confirm("ยืนยันการชำระเงิน");
            }
        </script>
    </head>
    <body>
        <jsp:include page="./template/navbar.jsp"></jsp:include>
            <div class="container mt-5">
                <h1>Payment</h1>
                <hr>
            <%
                request.setCharacterEncoding("UTF-8");
                String user = (String) session.getAttribute("user");
                String orderID = request.getParameter("orderID");
                double total = 0.0; // Initialize total
                String status = "";

                if (user == null) {
                    response.sendRedirect("./login.jsp");
                    return; // Stop further execution
                }

                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    conn = (new database.connect()).getC();
                    conn.setAutoCommit(false);

                    // Get address detail
                    String GetAddress = "SELECT a.name, a.address, a.phone, o.status "
                            + "FROM Orders o "
                            + "JOIN user u ON u.username = o.userID "
                            + "JOIN addresses a ON o.addressID = a.addressID "
                            + "WHERE o.orderID = ? AND u.username = ?";
                    pstmt = conn.prepareStatement(GetAddress);
                    pstmt.setString(1, orderID);
                    pstmt.setString(2, user);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        String name = rs.getString("name");
                        String address = rs.getString("address");
                        String phone = rs.getString("phone");
                        status = rs.getString("status");
            %>
            <div class="d-flex">        
                <div class='w-50'>

                    <p><strong>หมายเลขใบสั่งซื้อ : </strong> <%=orderID%><br>
                        <strong>ชื่อ : </strong> <%=name%><br>
                        <strong>ที่อยู่ในการจัดส่ง : </strong> <%=address%><br>
                        <strong>เบอร์โทรศัพท์ : </strong> <%=phone%><br>
                        <strong>สถานะใบคำสั่งซื้อ : </strong> <%=status%><br>
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
                <%
                if (status.equals("รอชำระ")) {%>
                <!--submit payment form-->
                <div class="w-75 ps-3">
                    <h3>ข้อมูลการชำระเงิน</h3>
                    <hr>
                    <p>สามารถโอนเงินมาที่หมายเลขบัญชี​ : <br> - กรุงไทย ชื่อ-นามสกุล เลขบัญชี <br> และทำการกรอกฟอร์มเพื่อยืนยันการชำระเงิน</p>
                    <hr>
                    <form  id="paymentForm" method="POST" action="insertPayment.jsp" onsubmit="handleFormSubmit(event)" >
                        <div class="form-group">
                            <label for="account">หมายเลขบัญชีของลูกค้า</label>
                            <input type="text" name="account" id="account" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="date">วันที่ทำการชำระ</label>
                            <input type="date" name="date" id="date" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="time">เวลาที่ทำการชำระ</label>
                            <input type="time" name="time" id="time" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="slip">อัปโหลดหลักฐานการชำระเงิน</label>
                            <input type="file" class="form-control" name="slip" id="slip" accept="image/*" required>
                        </div>
                        
                        <input type="hidden" id="slipBase64" name="slipBase64">
                        <input type="hidden" id="orderID" name="orderID" value="<%=orderID%>">
                        <button type="submit" class="btn btn-primary mt-2 w-100" onclick="return confirmPayment()">ยืนยันการชำระเงิน</button>
                    </form>
                </div>
                <% } else {%>    
                <div class="w-75 ps-3">
                    <h2>Your Order has been submitted for Payment.</h2>
                    <a href="./orderDetail.jsp?orderID=<%=orderID%>">ดูใบคำสั่งซื้อ</a>
                </div>
                <%
                        }
                        conn.commit(); // Commit the transaction if everything goes well
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
                    }
                %>
            </div>
        </div>
<jsp:include page="./template/footer.jsp"></jsp:include>

        <script>
            function convertFileToBase64(file) {
                return new Promise((resolve, reject) => {
                    const reader = new FileReader();
                    reader.onload = () => resolve(reader.result.split(',')[1]); // Remove the "data:image/*;base64," prefix
                    reader.onerror = (error) => reject(error);
                    reader.readAsDataURL(file);
                });
            }

            async function handleFormSubmit(event) {
                event.preventDefault();

                const file = document.getElementById('slip').files[0];
                if (file) {
                    try {
                        const base64String = await convertFileToBase64(file);
                        document.getElementById('slipBase64').value = base64String;

                        // Submit the form after setting Base64 string
                        document.getElementById('paymentForm').submit();
                    } catch (error) {
                        alert('Error converting image to Base64: ' + error);
                    }
                } else {
                    alert('Please select an image to upload.');
                }
            }
        </script>
        <script src="./Bootstrap/js/bootstrap.min.js"></script>
    </body>
</html>
