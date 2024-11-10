<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation</title>
    <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="./template/navbar.jsp"></jsp:include>

    <%
        request.setCharacterEncoding("UTF-8");
        String user = (String) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("./login.jsp");
            return; // Stop further execution
        }

        // Database connection
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        double totalAmount = 0;

        try {
            conn = (new database.connect()).getC();
            conn.setAutoCommit(false);
            
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String phoneNO = request.getParameter("phoneNO");
            int addressID = 0;
            
            String checkAddressSQL = "SELECT addressID FROM addresses WHERE name = ? AND address = ? AND phone = ?";
            pstmt = conn.prepareStatement(checkAddressSQL);
            pstmt.setString(1, name);
            pstmt.setString(2, address);
            pstmt.setString(3, phoneNO);
            rs = pstmt.executeQuery();

            // If address exists, get the addressID
            if (rs.next()) {
                addressID = rs.getInt("addressID");
            } else {
                // If the address does not exist, insert it
                String insertAddressSQL = "INSERT INTO addresses (name, address, phone) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(insertAddressSQL, Statement.RETURN_GENERATED_KEYS);
                pstmt.setString(1, name);
                pstmt.setString(2, address);
                pstmt.setString(3, phoneNO);
                pstmt.executeUpdate();

                // Get the generated address ID
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    addressID = rs.getInt(1);
                }
            }
            
            // Insert the order into the Orders table
            String insertOrderSQL = "INSERT INTO Orders (userID, addressID, orderDate, status, total) VALUES (?, ?, NOW(), 'รอชำระ', ?)";
            pstmt = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, user);
            pstmt.setInt(2, addressID);
            pstmt.setDouble(3, totalAmount);
            pstmt.executeUpdate();

            // Get the generated order ID
            rs = pstmt.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            // Loop through the request parameters to insert order details
            for (int i = 0; ; i++) {
                String bookIdParam = request.getParameter("item_" + i + "_id");
                String quantityParam = request.getParameter("item_" + i + "_quantity");

                if (bookIdParam == null || quantityParam == null) {
                    break; // No more items to process
                }

                int bookId = Integer.parseInt(bookIdParam);
                int quantity = Integer.parseInt(quantityParam);

                // Fetch the book price to calculate total
                String fetchPriceSQL = "SELECT price, priceDown FROM Books WHERE bookID = ?";
                pstmt = conn.prepareStatement(fetchPriceSQL);
                pstmt.setInt(1, bookId);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    double price = rs.getDouble("price");
                    double priceDown = rs.getDouble("priceDown");
                    double effectivePrice = (priceDown > 0 && priceDown < price) ? priceDown : price; // Use discounted price if available
                    double itemTotal = effectivePrice * quantity; // Calculate total for this item
                    totalAmount += itemTotal; // Accumulate total amount

                    // Insert into OrderDetails table
                    String insertOrderDetailSQL = "INSERT INTO OrderDetails (orderID, bookID, quantity, buyPrice) VALUES (?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(insertOrderDetailSQL);
                    pstmt.setInt(1, orderId);
                    pstmt.setInt(2, bookId);
                    pstmt.setInt(3, quantity);
                    pstmt.setDouble(4, effectivePrice);
                    pstmt.executeUpdate();
                    
                     // Update stock quantity
                    String updateStockSQL = "UPDATE Books SET qtyInStock = qtyInStock - ? WHERE bookID = ? AND qtyInStock >= ?";
                    pstmt = conn.prepareStatement(updateStockSQL);
                    pstmt.setInt(1, quantity);
                    pstmt.setInt(2, bookId);
                    pstmt.setInt(3, quantity); // Ensures stock doesn't go negative
                    int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected == 0) {
                    // Roll back if stock update failed (likely due to insufficient stock)
                    conn.rollback();
                    out.println("<div class='container mt-3 mx-auto d-flex flex-column justify-content-center align-items-center vh-100 text-center'><h3>Insufficient stock for book ID: " + bookId + ". Order failed.</h3></div>");
                    return;
                }   
                }
            }
            
            String updateTotalSQL = "UPDATE Orders SET total = ? WHERE orderID = ?";
            pstmt = conn.prepareStatement(updateTotalSQL);
            pstmt.setDouble(1, totalAmount);
            pstmt.setInt(2, orderId);
            pstmt.executeUpdate();
            
            conn.commit();
            
            out.println("<div class='container d-flex flex-column justify-content-center align-items-center vh-100 text-center'>");
            out.println("<h1>Your order has been placed successfully!</h1>");
            out.println("<h3>Order ID: " + orderId + "</p>");
            out.println("<hr class='w-50 mx-auto'>");
            out.println("<h1>Payment</h1>");
            out.println("<div class='d-flex gap-3'>");
            out.println("<a href='./payment.jsp?orderID=" + orderId + "' class='btn btn-primary'>Pay Now</a>");
            out.println("<a href='./index.jsp' class='btn btn-secondary'>Pay Later</a>");
            out.println("</div>");
            out.println("</div>");
            
            out.println("<script>");
            out.println("localStorage.clear();");
            out.println("</script>");
            
            
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<div class='container mt-3 d-flex flex-column justify-content-center align-items-center vh-100 text-center'><h3>There was an error processing your order. Please try again later.</h3>"
            + "<br><a href='./index.jsp' class='btn btn-secondary'>Return to HomePage.</a></div>");
            conn.rollback();
        } finally {
            // Clean up resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
    <script src="./Bootstrap/js/bootstrap.min.js"></script>
</body>
</html>
