<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title id="title"></title>
        <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css" />
        <script src="./Bootstrap/js/bootstrap.bundle.min.js"></script>
    </head>
    <body>
        <jsp:include page="./template/navbar.jsp"></jsp:include>
            <section>
                <div class="container mt-3">
                    <h1 id="author"></h1>
                    <hr>
                    <div class="row mb-3 p-3">
                    <%
                        request.setCharacterEncoding("UTF-8");
                        String name = request.getParameter("search");
                        String getBookByAuthor = "select * from Books where name like ? or author like ?";
                        Connection c = (new database.connect()).getC();

                        PreparedStatement stmt = c.prepareStatement(getBookByAuthor);
                        stmt.setString(1, "%" + name + "%"); // Adding wildcards for partial matching
                        stmt.setString(2, "%" + name + "%");
                        ResultSet rs = stmt.executeQuery();

                        int count = 0; // To group books in rows of 4
                        while (rs.next()) {
                            String bookid = rs.getString("bookid");
                            String title = rs.getString("name");
                            double price = rs.getDouble("price");
                            double priceDown = rs.getDouble("priceDown");
                            if (count % 4 == 0 && count != 0) { // Start new row after 4 columns
                    %>
                </div> <!-- End previous row -->
                <div class="row mb-3"> <!-- Start new row -->
                    <%
                        }
                    %>
                    <div class="col-md-3 text-center">
                        <a href="./detail.jsp?bookid=<%= bookid %>" class="text-dark text-decoration-none">
                            <img src="image?bookid=<%= bookid %>" class="img-fluid" style="height: 300px; width: auto;" alt="<%= title %>">
                            <p class="mt-2 ps-5 text-start">
                                <strong><%= title%> </strong> <br>
                                <% if (priceDown != 0) { %>
                                <span class="text-danger text-decoration-line-through">฿<%= price %></span>
                                <span>฿<%= priceDown %></span>
                                <% } else { %> 
                                <span>฿<%= price %></span>
                                <% } %>
                            </p>
                        </a>
                    </div>
                    <%
                            count++;
                        } // End of while loop
                        rs.close();
                        stmt.close();
                        c.close();
                    %>
                </div> <!-- End last row -->
            </div>
        </section>
<jsp:include page="./template/footer.jsp"></jsp:include>
        <script>
            // Escape any special characters in 'name' to prevent JavaScript errors
            var authorName = "<%= name != null ? name.replaceAll("\"", "\\\\\"") : "" %>";
            document.getElementById("author").textContent = "ค้นหา : " + authorName;
            document.getElementById("title").textContent = "ค้นหา : " + authorName;
        </script>
    </body>
</html>
