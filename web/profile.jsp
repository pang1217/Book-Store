<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Profile</title>
        <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css" />
        <script src="./Bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="./jquery/jquery-3.7.1.min"></script>
        <style>
            .nav-link.active {
                font-weight: bold;
                background-color: transparent !important; /* Removes the background color */
                color: black !important;
                border-left: 3px solid gray;
            }
        </style>

        <script>
            function confirmCancel() {
                return confirm("คุณแน่ใจหรือไม่ว่าต้องการยกเลิกคำสั่งซื้อนี้?");
            }
        </script>
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
        <!-- Profile Section -->
        <section class="container my-5">
            <h1>Welcome, <%= user%></h1>
            <hr>

            <!-- Flex container for horizontal layout -->
            <div class="d-flex">
                <!-- Tabs Navigation on the left -->
                <div class="nav flex-column nav-pills me-3" role="tablist" aria-orientation="vertical">
                    <a class="nav-link active" id="home-tab" data-bs-toggle="pill" href="#home" role="tab">ประวัติ</a>
                    <!--<a class="nav-link" id="menu1-tab" data-bs-toggle="pill" href="#menu1" role="tab">ที่อยู่</a>-->
                    <a class="nav-link" id="menu2-tab" data-bs-toggle="pill" href="#menu2" role="tab">เปลี่ยนรหัสผ่าน</a>
                    <a class="nav-link" id="menu3-tab" data-bs-toggle="pill" href="#menu3" role="tab">การซื้อของฉัน</a>
                </div>

                <!-- Tab Content on the right -->
                <div class="tab-content flex-grow-1">

                    <div class="tab-pane fade show active" id="home" role="tabpanel" aria-labelledby="home-tab">
                        <jsp:include page="./template/Profile/profile1.jsp"></jsp:include>
                        </div>

                        <!--                <div class="tab-pane fade" id="menu1" role="tabpanel" aria-labelledby="menu1-tab">
                    <%--<jsp:include page="./template/Profile/address.jsp"></jsp:include>--%>
                </div>-->


                    <div class="tab-pane fade" id="menu2" role="tabpanel" aria-labelledby="menu2-tab">
                        <jsp:include page="./template/Profile/changePass.jsp"></jsp:include>
                        </div>

                        <div class="tab-pane fade" id="menu3" role="tabpanel" aria-labelledby="menu3-tab">
                            <h4>การซื้อของฉัน</h4>
                            <hr>
                            
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
                                <table class="table table-striped table-bordered my-3">
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
                                        try (
                                                Connection c = (new database.connect()).getC(); Statement stmt = c.createStatement(); ResultSet rs = stmt.executeQuery("select * from orders where userId = '" + user + "' order by orderDate desc")) {
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

                                            <a href="./orderDetail.jsp?orderID=<%= OrderID%>" class="btn btn-info">View</a>
                                            <% if (status.equals("รอชำระ")) {%>
                                            <a href="./payment.jsp?orderID=<%= OrderID%>" class="btn btn-primary">Upload Payment</a>
                                            <a href="./cancel.jsp?orderID=<%= OrderID%>" class="btn btn-danger" onclick="return confirmCancel()">cancel</a>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } catch (SQLException e) {
                                            out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <jsp:include page="./template/footer.jsp"></jsp:include>
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
