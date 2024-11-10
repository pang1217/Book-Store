<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Edit Book</title>
    <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css" />
</head>
<body>
    <jsp:include page="./template/navbar.jsp"></jsp:include>
        <%
            String user = (String) session.getAttribute("user");
            if(user == null){
                response.sendRedirect("./login.jsp");
                return;
            }
        %>
    <div class="container">
        <div class="row justify-content-center">
            <section class="col-12 col-md-8 border rounded p-3 mt-5 mx-auto d-flex">
                <%
                    request.setCharacterEncoding("UTF-8");
                    String bookId = request.getParameter("bookid");
                    String message = "";

                    if (bookId != null) {
                        try (
                            Connection conn = (new database.connect()).getC();
                            PreparedStatement ps = conn.prepareStatement("SELECT * FROM books WHERE bookid = ?")
                        ) {
                            ps.setString(1, bookId);
                            ResultSet rs = ps.executeQuery();

                            if (rs.next()) {
                                String title = rs.getString("name");
                                String author = rs.getString("author");
                                String price = rs.getString("price");
                                String priceDown = rs.getString("priceDown");
                                String description = rs.getString("description");
                                String qtyInStock = rs.getString("qtyInstock");
                %>
                
                <!-- Left column for the image -->
                <div class="col-md-4">
                    <img src="image?bookid=<%= bookId %>" alt="Book Cover" class="img-fluid rounded mb-3 pe-3 py-auto"
                         style="max-height: 400px; width: 100%; object-fit: cover;">
                </div>
                
                <!-- Right column for the form -->
                <div class="col-md-8">
                    <h1 class="text-center">Edit Book</h1>
                    <form id="editBook" action="editProduct.jsp" method="post">
                        <input type="hidden" name="bookid" value="<%= bookId %>">
                        <div class="form-group">
                            <label>Title: <%= title %></label>
                        </div>
                        <div class="form-group">
                            <label>Author: <%= author %></label>
                        </div>
                        <div class="form-group">
                            <label>Price: <%= price %></label>
                        </div>
                        <div class="form-group">
                            <label for="qtyInStock">Quantity InStock:</label>
                            <input type="number" class="form-control" name="qtyInStock" id="qtyInStock" value="<%= qtyInStock %>" min="0" required>
                        </div>
                        <div class="form-group">
                            <label for="priceDown">Price Down:</label>
                            <input type="number" class="form-control" name="priceDown" id="priceDown" value="<%= priceDown %>" min="0" required>
                        </div>
                        <div class="form-group">
                            <label for="description">Description:</label>
                            <textarea class="form-control" name="description" id="description" rows="7" required><%= description %></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary mt-2 w-100">Update</button>
                    </form>
                </div>
                
                <%
                            } else {
                                message = "<div class='alert alert-danger'>Book not found.</div>";
                            }
                        } catch (SQLException e) {
                            message = "<div class='alert alert-danger'>Database error: " + e.getMessage() + "</div>";
                        }
                    } else {
                        message = "<div class='alert alert-danger'>No book ID provided.</div>";
                    }

                    out.print(message);
                    // Handle form submission
                    if ("POST".equalsIgnoreCase(request.getMethod())) {
                        String priceDown = request.getParameter("priceDown");
                        String description = request.getParameter("description");
                        String qtyInStock = request.getParameter("qtyInStock");

                        if (description != null & priceDown != null) {
                            try (
                                Connection conn = (new database.connect()).getC();
                                PreparedStatement ps = conn.prepareStatement(
                                    "UPDATE books SET description = ?, priceDown = ? , qtyInStock = ? WHERE bookid = ?")
                            ) {
                                ps.setString(1, description);
                                ps.setString(2, priceDown);
                                ps.setString(3, qtyInStock);
                                ps.setString(4, bookId);
                                

                                int rowsUpdated = ps.executeUpdate();
                                message = rowsUpdated > 0
                                    ? "<div class='alert alert-success'>Book updated successfully!</div>"
                                    : "<div class='alert alert-danger'>Failed to update book.</div>";

                            } catch (SQLException e) {
                                message = "<div class='alert alert-danger'>Database error: " + e.getMessage() + "</div>";
                            }
                        } else {
                            message = "<div class='alert alert-danger'>Please fill in all fields.</div>";
                        }
                        
                    }
                %>
            </section>
        </div>
            <% 
         out.print(message);
    %>
    </div>
    <jsp:include page="./template/footer.jsp"></jsp:include>
    
    <script src="./Bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
