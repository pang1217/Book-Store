<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Manage Book</title>
    <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css" />
    <script>
        function confirmDelete() {
            return confirm("Are you sure you want to delete this book?");
        }
    </script>
</head>
<body>
    <jsp:include page="./template/navbar.jsp"></jsp:include>
            <%
            String checkUser = (String) session.getAttribute("user");
            if(checkUser == null){
                response.sendRedirect("./login.jsp");
                return;
            }
        %>
    <section class="w-75 mx-auto">
        <h1>Manage Employee</h1>
        
         <div class="mb-3 d-flex">
            <input type="text" id="empSearch" placeholder="Search Employee..." class="form-control w-50">
            <a href="./signup.jsp" class="btn btn-success ms-2">Add Employee</a>
        </div>
        
        <div>
            <table class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <th scope="col">Username</th>
                        <th scope="col">First name</th>
                        <th scope="col">Last name</th>
                        <th scope="col">Option</th>
                    </tr>
                </thead>
                <tbody id="empTable">
                <%
                    try (Connection c = (new database.connect()).getC();
                         Statement stmt = c.createStatement();
                         ResultSet rs = stmt.executeQuery("SELECT * FROM User Where role = 'Employee'")) {

                        while (rs.next()) {
                            String user = rs.getString("username");
                            String fName = rs.getString("firstName");
                            String lName = rs.getString("Lastname");
                %>
                    <tr>
                        <th scope="row"><%= user %></th>
                        <td><%= fName %></td>
                        <td><%= lName %></td>
                        <td>
                            <a href="./editEmployee.jsp?username=<%= user %>" class="btn btn-primary">Edit </a>
                            <a href="./deleteEmployee.jsp?username=<%= user %>" class="btn btn-danger" onclick="return confirmDelete();">Delete</a>
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
            $("#empSearch").on("keyup", function() {
                var value = $(this).val().toLowerCase();
                $("#empTable tr").filter(function() {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
                });
            });
        });
    </script>
</body>
</html>
