<%@ page import="java.sql.*" %>
<%@ page import="beans.UserBean" %>
<%
    String username = request.getParameter("username");

    try (Connection connection = (new database.connect()).getC()) {
        // Call the deleteUser method from your DAO or service class
        UserBean dao = new UserBean();
        dao.deleteUser(connection, username);
        response.sendRedirect("./manageEmployee.jsp");
    } catch (SQLException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
    
%>
