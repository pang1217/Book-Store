<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Profile</title>
        <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css" />
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
                            <div class="d-flex align-items-center">
                                <label for="orderSearch" class="me-2">ค้นหาใบสั่งซื้อ :</label>
                                <input type="text" id="orderSearch" class="form-control" placeholder="ค้นหาใบสั่งซื้อ" style="width: 200px;">
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
                                                Connection c = (new database.connect()).getC();
                                                Statement stmt = c.createStatement(); 
                                                ResultSet rs = stmt.executeQuery("select * from orders where userId = '" + user + "' order by orderDate desc")){ 
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
                                            
                                            <a href="./orderDetail.jsp?orderID=<%= OrderID%>" class="btn btn-danger">View</a>
                                            <% if (status.equals("รอชำระ")) { %>
                                            <a href="./payment.jsp?orderID=<%= OrderID%>" class="btn btn-danger">Upload Payment</a>
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

        <script src="./Bootstrap/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
