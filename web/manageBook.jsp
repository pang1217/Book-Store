<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Manage Book</title>
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
    <section class="w-75 mx-auto">
        <h1>Manage Book</h1>
        
        <div class="mb-3 d-flex">
            <input type="text" id="bookSearch" placeholder="Search Books..." class="form-control w-50">
            <a href="./insertBook.jsp" class="btn btn-success ms-2">Add Book</a>
        </div>
        
        <div>
            <table class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">Title</th>
                        <th scope="col">Author</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Option</th>
                    </tr>
                </thead>
                <tbody id="bookTable">
                <%
                    try (Connection c = (new database.connect()).getC();
                         Statement stmt = c.createStatement();
                         ResultSet rs = stmt.executeQuery("SELECT * FROM Books order by qtyInStock asc")) {

                        while (rs.next()) {
                            String bookid = rs.getString("bookid");
                            String title = rs.getString("name");
                            String author = rs.getString("author");
                            int qty = rs.getInt("qtyInStock");
                %>
                    <tr>
                        <th scope="row"><%= bookid %></th>
                        <td><%= title %></td>
                        <td><%= author %></td>
                        <% if (qty != 0) { %>
                        <td><%= qty %></td>
                        <% } else { %>
                            <td class="text-danger">Out of Stock</td>
                        <% } %>
                        <td>
                            <a href="./editProduct.jsp?bookid=<%= bookid %>" class="btn btn-primary">Edit </a>
                            <a href="./deleteProduct.jsp?bookid=<%= bookid %>" class="btn btn-danger" onclick="return confirmDelete();">Delete</a>
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
        $(document).ready(function() {
            $("#bookSearch").on("keyup", function() {
                var value = $(this).val().toLowerCase();
                $("#bookTable tr").filter(function() {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
                });
            });
        });
    </script>
</body>
</html>
