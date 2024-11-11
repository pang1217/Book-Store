<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <section>
            <div class="container">
                <h1 class="">Books</h1>
                <div class="row mb-3 p-3">
                    <%
                        Connection c = (new database.connect()).getC();
                        Statement stmt = c.createStatement();
                        String search = request.getParameter("search");
                        
                        ResultSet rs = stmt.executeQuery("SELECT * FROM Books order by bookid desc");

                        int count = 0; // To group books in rows of 4
                        while (rs.next()) {
                            String bookid = rs.getString("bookid");
                            String title = rs.getString("name");
                            double price = rs.getDouble("price");
                            double priceDown = rs.getDouble("priceDown");
                            if (count % 4 == 0 && count != 0) { // Start new row after 4 columns
                    %>
                </div> <!-- End previous row -->
                <div class="row mb-3 "> <!-- Start new row -->
                    <%
                        }
                    %>
                    <div class="col-md-3 text-center">
                        <a href="detail.jsp?bookid=<%= bookid%>" class="text-dark text-decoration-none">
                            <img src="image?bookid=<%= bookid%>" class="img-fluid" style="height: 300px; width: auto;" alt="<%= title%>">
                            <p class="mt-2 ps-5 text-start">
                                <strong><%= title%> </strong> <br>
                                <% if (priceDown != 0) {%>
                                <span class="text-danger text-decoration-line-through">฿<%= price%></span>
                                <span>฿<%= priceDown%></span>
                                <% } else {%> 
                                <span>฿<%= price%></span>
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
    </body>
</html>
