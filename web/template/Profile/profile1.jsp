<%@ page import="Dao.UserDao, beans.UserBean, java.sql.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Profile Page</title>
    <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css" />
    <script src="./jquery/jquery-3.7.1.min.js"></script>
    <script src="./Bootstrap/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <%
    String username = (String) session.getAttribute("user");
    String message = ""; 
    UserDao userDAO = new UserDao();
    UserBean user = new UserBean();

    if (username != null) {
        Connection conn = null;
        try {
            conn = (new database.connect()).getC();

            // Handle form submission for updating profile
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");

                // Update user object
                user.setUsername(username);
                user.setEmail(email != null && !email.trim().isEmpty() ? email : user.getEmail());
                user.setPhone(phone != null && !phone.trim().isEmpty() ? phone : user.getPhone());

                if (userDAO.updateUser(conn, user)) {
                    message = "Profile updated successfully!";
                    session.setAttribute("email", email); // Update session email if changed
                } else {
                    message = "Error updating profile. Email or phone number may already exist!";
                }
            }

            // Fetch updated user details to display in the form
            user = userDAO.getUserDetails(conn, username);
        } catch (SQLException e) {
            message = "Error: " + e.getMessage();
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { /* Log if needed */ }
            }
        }
    }
    %>

    <div class="container">
        <h4> MyProfile</h4>
        <hr>
        <form method="post">
            <label>Username : <%= user.getUsername()%></label>
            <div class="form-group">
                <label for="email">Email :</label>
                <input type="email" name="email" id="email" placeholder="Email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" class="form-control mt-2 w-25" required />
            </div>
            <div class="form-group">
                <label for="phone">Phone : </label>
                <input type="text" name="phone" id="phone" placeholder="Phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>" class="form-control mt-2 w-25" />
            </div>
            <button type="submit" class="btn btn-primary mt-3">Save</button>
        </form>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-info mt-3" role="alert">
                <%= message %>
            </div>
        <% } %>
    </div>
</body>
</html>
