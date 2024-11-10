<%@ page import="Dao.UserDao, java.sql.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Change Password</title>
        <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css" />
        <script src="./jquery/jquery-3.7.1.min.js"></script>
        <script src="./Bootstrap/js/bootstrap.bundle.min"></script>
    </head>
    <body>
        <div class="container">
            <h4>เปลี่ยนรหัสผ่าน</h4>
            <hr>
            <form method="post" action="./template/Profile/changePass.jsp">
                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" class="form-control w-25" name="newPassword" id="newPassword" required>
                </div>
                <div class="form-group">
                    <label for="confirmNewPassword">Confirm New Password</label>
                    <input type="password" class="form-control w-25" name="confirmNewPassword" id="confirmNewPassword" required>
                </div>
                <button type="submit" class="btn btn-primary mt-3">บันทึก</button>
            </form>   
        </div>

        <%
            String message = "";
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String newPassword = request.getParameter("newPassword");
                String confirmNewPassword = request.getParameter("confirmNewPassword");

                if (newPassword != null && confirmNewPassword != null && newPassword.equals(confirmNewPassword)) {
                    String username = (String) session.getAttribute("user");
                    if (username != null) {
                        Connection conn = null;
                        try {
                            conn = (new database.connect()).getC();
                            UserDao userDAO = new UserDao();
                            boolean isUpdated = userDAO.changePassword(conn, username, newPassword);

                            if (isUpdated) {
                                response.sendRedirect("../../profile.jsp");
                                return;
                            } else {
                                message = "Error updating password. Please try again.";
                            }
                        } catch (SQLException e) {
                            message = "Database error: " + e.getMessage();
                        } finally {
                            if (conn != null) {
                                try { conn.close(); } catch (SQLException e) { /* Log if needed */ }
                            }
                        }
                    } else {
                        message = "User session expired. Please log in again.";
                    }
                } else {
                    message = "Passwords do not match.";
                }
            }
        %>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-info mt-3" role="alert">
                <%= message %>
            </div>
        <% } %>
    </body>
</html>
