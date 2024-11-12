<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Statistics Page</title>
        <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css" />
        <script src="./Bootstrap/js/bootstrap.bundle.min.js"></script>
        <style>
/*            .order-card {
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease;
            }
            .order-card:hover {
                transform: translateY(-5px);
            }*/
/*            .order-card h4 {
                font-weight: bold;
                color: #343a40;
            }*/
            .bg-pending { background-color: #f8d7da; }
            .bg-awaiting { background-color: #fff3cd; }
            .bg-preparing { background-color: #d1ecf1; }
            .bg-shipped { background-color: #d4edda; }
            .bg-cancelled { background-color: #f5c6cb; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1 class="pt-3">Orders Statistics</h1>
            <div class="row pt-4">

                <%
                    String user = (String) session.getAttribute("user");
                    if (user == null) {
                        response.sendRedirect("./login.jsp");
                    }
                    
                    int totalOrders = 0, pendingPaymentOrders = 0, awaitPaymentOrders = 0;
                    int preparingOrders = 0, shippedOrders = 0, cancelledOrders = 0;

                    Connection c = (new database.connect()).getC();
                    PreparedStatement stmt;
                    ResultSet rs;

                    // Fetch counts based on status
                    String[] statuses = { "รอชำระ", "รอตรวจสอบการชำระเงิน", "กำลังเตรียมจัดส่ง", "จัดส่ง", "ยกเลิก" };
                    int[] counts = new int[5];

                    for (int i = 0; i < statuses.length; i++) {
                        stmt = c.prepareStatement("SELECT count(*) as orderCount FROM orders WHERE status = ?");
                        stmt.setString(1, statuses[i]);
                        rs = stmt.executeQuery();
                        if (rs.next()) counts[i] = rs.getInt("orderCount");
                        rs.close();
                        stmt.close();
                    }

                    c.close();
                %>

                <!-- Total Orders -->
                <div class="col-md-4 col-xl-3 pb-3">
                    <div class="card order-card text-center">
                        <div class="card-body">
                            <h4>คำสั่งซื้อทั้งหมด : <%= counts[0] + counts[1] + counts[2] + counts[3] + counts[4] %></h4>
                        </div>
                    </div>
                </div>

                <!-- Pending Payment -->
                <div class="col-md-4 col-xl-3 pb-3">
                    <div class="card order-card bg-pending text-center">
                        <div class="card-body">
                            <h4>รอชำระ : <%= counts[0] %></h4>
                        </div>
                    </div>
                </div>

                <!-- Awaiting Payment Verification -->
                <div class="col-md-4 col-xl-3 pb-3">
                    <div class="card order-card bg-awaiting text-center">
                        <div class="card-body">
                            <h4>รอตรวจสอบการชำระ : <%= counts[1] %></h4>
                        </div>
                    </div>
                </div>

                <!-- Preparing for Shipment -->
                <div class="col-md-4 col-xl-3 pb-3">
                    <div class="card order-card bg-preparing text-center">
                        <div class="card-body">
                            <h4>กำลังเตรียมจัดส่ง : <%= counts[2] %></h4>
                        </div>
                    </div>
                </div>

                <!-- Shipped -->
                <div class="col-md-4 col-xl-3 pb-3">
                    <div class="card order-card bg-shipped text-center">
                        <div class="card-body">
                            <h4>จัดส่ง : <%= counts[3] %></h4>
                        </div>
                    </div>
                </div>

                <!-- Cancelled -->
                <div class="col-md-4 col-xl-3 pb-3">
                    <div class="card order-card bg-cancelled text-center">
                        <div class="card-body">
                            <h4>ยกเลิก : <%= counts[4] %></h4>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
