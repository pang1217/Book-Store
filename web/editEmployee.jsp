<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Edit User</title>
    <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css" />
    <script src="./jquery/jquery-3.7.1.min.js"></script>
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
            <section class="col-12 col-md-6 col-lg-4 border rounded p-3 mt-5 mx-auto">
                <h1 class="text-center">Edit User</h1>

                <%
                    request.setCharacterEncoding("UTF-8");
                    String username = request.getParameter("username");
                    String message = "";

                    if (username != null && !username.trim().isEmpty()) {
                        try (
                            Connection conn = (new database.connect()).getC();
                            PreparedStatement ps = conn.prepareStatement("SELECT * FROM user WHERE username = ?")
                        ) {
                            ps.setString(1, username);
                            ResultSet rs = ps.executeQuery();

                            if (rs.next()) {
                                String email = rs.getString("email");
                                String firstName = rs.getString("firstName");
                                String lastName = rs.getString("Lastname");
                %>
                                <form id="editUser" action="editEmployee.jsp?username=<%= username %>" method="post">
                                    <label>Username : <%= username%></label>
                                    <div class="form-group">
                                        <label for="email">Email:</label>
                                        <input type="email" class="form-control" name="email" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" title="Please enter a valid email address" id="email" value="<%= email %>" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="firstName">First Name:</label>
                                        <input type="text" class="form-control" name="firstName" id="firstName" value="<%= firstName %>" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="lastName">Last Name:</label>
                                        <input type="text" class="form-control" name="lastName" id="lastName" value="<%= lastName %>" required>
                                    </div>
                                    <button type="submit" class="btn btn-primary mt-2 w-100">Update</button>
                                </form>
                <%
                            } else {
                                message = "<div class='alert alert-danger'>Username not found.</div>";
                            }
                        } catch (SQLException e) {
                            message = "<div class='alert alert-danger'>Database error: " + e.getMessage() + "</div>";
                        }
                    } else {
                        message = "<div class='alert alert-danger'>No username provided.</div>";
                    }

                    out.print(message);

                    // Handle form submission
                    if ("POST".equalsIgnoreCase(request.getMethod())) {
                        String email = request.getParameter("email");
                        String firstName = request.getParameter("firstName");
                        String lastName = request.getParameter("lastName");

                        if (email != null && firstName != null && lastName != null &&
                            !email.trim().isEmpty() && !firstName.trim().isEmpty() && !lastName.trim().isEmpty()) {
                            try (
                                Connection conn = (new database.connect()).getC();
                                PreparedStatement ps = conn.prepareStatement(
                                    "UPDATE user SET email = ?, firstName = ?, Lastname = ? WHERE username = ?")
                            ) {
                                ps.setString(1, email);
                                ps.setString(2, firstName);
                                ps.setString(3, lastName);
                                ps.setString(4, username);
                                int rowsUpdated = ps.executeUpdate();
                                message = rowsUpdated > 0
                                    ? "<div class='alert alert-success'>User updated successfully!</div>"
                                    : "<div class='alert alert-danger'>Failed to update user.</div>";
                            } catch (SQLException e) {
                                message = "<div class='alert alert-danger'>Database error: " + e.getMessage() + "</div>";
                            }
                        } else {
                            message = "<div class='alert alert-danger'>Please fill in all fields.</div>";
                        }
                        out.print(message);
                    }
                %>
            </section>
        </div>
    </div>
    <jsp:include page="./template/footer.jsp"></jsp:include>
    
    <script src="./Bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
