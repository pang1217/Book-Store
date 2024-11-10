<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Order</title>
        <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css">
        <script src="./Bootstrap/js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="./template/navbar.jsp"></jsp:include>
        <%
            String user = (String) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("./login.jsp");
                return;
            }
        %>
        <section class="w-75 mx-auto">
            <h1>Manage Order</h1>
            <hr>
            <!-- Filters -->
            <div class="mb-3 d-flex flex-column">
                
                ค้นหาจากหมายเลขใบสั่งซื้อ : <input type="text" id="orderSearch" placeholder="Search Order ID" class="form-control mb-2 w-50">
                ค้นหาจากหมายสถานะใบสั่งซื้อ :
                <select id="statusFilter" class="form-select ps-3 w-50">
                    <option value="">All Statuses</option>
                    <option value="รอชำระ">รอชำระ</option>
                    <option value="รอตรวจสอบการชำระเงิน">รอตรวจสอบการชำระเงิน</option>
                    <option value="กำลังเตรียมจัดส่ง">กำลังเตรียมจัดส่ง</option>
                    <option value="จัดส่ง">จัดส่ง</option>
                    <option value="ยกเลิก">ยกเลิก</option>
                </select>
            </div>

            <div>
                <table class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th scope="col">หมายเลขใบสั่งซื้อ</th>
                            <th scope="col">วันที่ทำการสั่งซื้อ</th>
                            <th scope="col">สถานะ</th>
                            <th scope="col">Option</th>
                        </tr>
                    </thead>
                    <tbody id="orderTable">
                        <%
                            try (Connection c = (new database.connect()).getC(); Statement stmt = c.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM Orders")) {

                                while (rs.next()) {
                                    String OrderID = rs.getString("OrderID");
                                    String orderDate = rs.getString("orderDate");
                                    String status = rs.getString("status");
                        %>
                        <tr>
                            <th scope="row"><%= OrderID%></th>
                            <td><%= orderDate%></td>
                            <td><%= status%></td>
                            <td>
                                <% if (status.equals("รอตรวจสอบการชำระเงิน")) {%>
                                <a href="./orderDetail.jsp?orderID=<%= OrderID%>" class="btn btn-success">ดูข้อมูล</a>
                                <a href="./paymentCheck.jsp?orderID=<%= OrderID%>" class="btn btn-success">ตรวจสอบการชำระเงิน</a>
                                <% } else if (status.equals("กำลังเตรียมจัดส่ง")) {%>
                                <a href="./paymentCheck.jsp?orderID=<%= OrderID%>" class="btn btn-success">ดูข้อมูล</a>
                                <a href="./updateTracking.jsp?orderID=<%=OrderID%>" class="btn btn-success">อัพเดทหมายเลขการจัดส่งสินค้า</a>
                                <% } else if (status.equals("จัดส่ง")) {%>
                                <a href="./paymentCheck.jsp?orderID=<%= OrderID%>" class="btn btn-success">ดูข้อมูล</a>
                                <% } else if (status.equals("ยกเลิก") || status.equals("รอชำระ")) {%>
                                <a href="./orderDetail.jsp?orderID=<%= OrderID%>" class="btn btn-success">ดูข้อมูล</a>
                                <% } %>
                            </td>
                        </tr>
                        <%
                                } // End of while loop
                            } catch (SQLException e) {
                                out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </section>

        <jsp:include page="./template/footer.jsp"></jsp:include>
        <!-- JS and Jquery -->
        <script src="./jquery/jquery-3.7.1.min"></script>
        <script src="./Bootstrap/js/bootstrap.bundle.min.js"></script>
        <script>
            $(document).ready(function () {
                function filterOrders() {
                    var searchValue = $("#orderSearch").val().toLowerCase();
                    var statusValue = $("#statusFilter").val();

                    $("#orderTable tr").filter(function () {
                        var textMatch = $(this).text().toLowerCase().indexOf(searchValue) > -1;
                        var statusMatch = statusValue === "" || $(this).find("td:nth-child(3)").text() === statusValue;
                        $(this).toggle(textMatch && statusMatch);
                    });
                }

                $("#orderSearch").on("keyup", filterOrders);
                $("#statusFilter").on("change", filterOrders);
            });
        </script>
    </body>
</html>
