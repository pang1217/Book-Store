<%-- 
    Document   : listBooks
    Created on : 22 ต.ค. 2567, 13:44:49
    Author     : nathaphan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Price Down</title>
    </head>
    <body>
        <jsp:include page="./template/navbar.jsp"></jsp:include>
        <section>
            <div class="container">
                <h1>หนังสือลดราคา</h1>
                <div class="row mb-3 p-3">
                    <%
                        Connection c = (new database.connect()).getC();
                        Statement stmt = c.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT * FROM Books where priceDown <> 0 order by bookid desc");

                        int count = 0; // To group books in rows of 4
                        while(rs.next()) {
                            String bookid = rs.getString("bookid");
                            String title = rs.getString("name");
                            String price = rs.getString("price");
                            String priceDown = rs.getString("priceDown");
//                            String image = rs.getString("image"); // Assuming this is a BLOB in the database
                            if(count % 4 == 0 && count != 0) { // Start new row after 4 columns
                    %>
                    </div> <!-- End previous row -->
                    <div class="row mb-3 "> <!-- Start new row -->
                    <%
                            }
                    %>
                    <div class="col-md-3 text-center">
                        <a href="detail.jsp?bookid=<%= bookid %>" class="text-dark text-decoration-none">
                            <img src="image?bookid=<%= bookid %>" class="img-fluid" style="height: 300px; width: auto;" alt="<%= title %>">
                            <p class="mt-2 ps-5 text-start">
                                <strong><%= title%> </strong> <br>
                                <span class="text-danger text-decoration-line-through"> <%= price %></span> <%= priceDown %></p>
                            
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
    </body>
</html>
