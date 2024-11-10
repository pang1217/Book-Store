<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Delete Book</title>
    <script>
        function showErrorAndRedirect(message) {
            alert(message);
            window.location.href = "./manageBook.jsp";
        }
    </script>
</head>
<body>
    <%
        String bookId = request.getParameter("bookid");
        boolean deleted = false;

        try (Connection conn = (new database.connect()).getC()) {
            String sql = "DELETE FROM books WHERE bookid = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, bookId);
                int rowsAffected = stmt.executeUpdate();
                deleted = (rowsAffected > 0);
            }
        } catch (SQLException e) {
            out.println("<script>showErrorAndRedirect('Error: " + e.getMessage() + "');</script>");
        }

        if (deleted) {
    %>
            <script>
                window.location.href = "./manageBook.jsp";
            </script>
    <%
        } else {
    %>
            <script>
                showErrorAndRedirect('Failed to delete the book. Please try again.');
            </script>
    <%
        }
    %>
</body>
</html>
