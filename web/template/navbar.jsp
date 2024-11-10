<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %> 
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"/>
  </head>
  <body>
      
    <%
        String user = (String) session.getAttribute("user");

        if (user != null) {
            Connection c = (new database.connect()).getC();

            
            String sql = "SELECT role FROM user WHERE username = ?";
            PreparedStatement stmt = c.prepareStatement(sql);
            stmt.setString(1, user); 

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String role = rs.getString("role");
            if(role.equals("Admin") || role.equals("Employee")){ %>
                    <jsp:include page = "./navbar_admin.jsp"></jsp:include>
                <% } else { %>
                    <jsp:include page = "./navbar_customer.jsp"></jsp:include>
                <%}
            } else {
                out.println("User not found in the database.");
            }

            rs.close();
            stmt.close();
            c.close();
        } else { %>
            <jsp:include page = "./navbar_customer.jsp"></jsp:include>
        <% }
    %>

    <!-- JS -->
    <script src="./Bootstrap/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
