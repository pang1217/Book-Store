<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="beans.UserBean" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sign up</title>
    <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"/>
    <script>
        function confirmAdminAction() {
            return confirm("Are you sure you want to add this user?");
        }
    </script>
  </head>
  <body>
    <jsp:include page="./template/navbar.jsp"></jsp:include>

    <%
        String errorMessage = null;
        boolean isAdmin = false;
        Connection c = null;

        try {
            UserBean userBean = new UserBean();
            c = (new database.connect()).getC();

            // Check if current session user is an admin
            String sessionUser = (String) session.getAttribute("user");
            if (sessionUser != null) {
                String roleQuery = "SELECT role FROM user WHERE username = ?";
                try (PreparedStatement stmt = c.prepareStatement(roleQuery)) {
                    stmt.setString(1, sessionUser);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next() && "Admin".equals(rs.getString("role"))) {
                        isAdmin = true;
                    }
                }
            }

            // Populate UserBean with request parameters
            userBean.setUsername(request.getParameter("username"));
            userBean.setEmail(request.getParameter("email"));
            userBean.setPassword(request.getParameter("password"));
            userBean.setConfirmPassword(request.getParameter("confirm_password"));
            if (isAdmin) {
                userBean.setFirstName(request.getParameter("firstName"));
                userBean.setLastName(request.getParameter("lastName"));
            }

            if (userBean.getUsername() != null && userBean.getEmail() != null) {
                if (!userBean.userExists(c)) {
                    if (userBean.registerUser(c, isAdmin)) {
                        if (sessionUser == null) {
                            response.sendRedirect("./login.jsp");
                        } else {
                            response.sendRedirect("./manageEmployee.jsp");
                        }
                    } else {
                        errorMessage = "Registration failed. Please check your inputs.";
                    }
                } else {
                    errorMessage = "Username or Email is already taken. Please choose another.";
                }
            }
        } catch (Exception e) {
            errorMessage = "Error: " + e.getMessage();
        } finally {
            if (c != null) try { c.close(); } catch (SQLException ignore) {}
        }
    %>

    <div class="container">
      <div class="row justify-content-center">
        <section id="signup" class="col-12 col-md-6 col-lg-4 border rounded p-3 mt-5 mx-auto">
          <h1 class="text-center" id="head">Sign up</h1>

          <% if (errorMessage != null) { %>
            <div class="alert alert-danger" role="alert">
              <%= errorMessage %>
            </div>
          <% } %>

          <form action="signup.jsp" method="post" onsubmit="<%= isAdmin ? "return confirmAdminAction()" : "" %>">
            <% if (isAdmin) { %>
            <script> document.getElemntById("head").innerHTML = "ลงทะเบียนพนักงาน";</script>
              <div class="form-group">
                  <label for="firstName">First name:</label>
                  <input type="text" name="firstName" id="firstName" placeholder="First Name" class="form-control mt-2" required />
              </div>
              <div class="form-group">
                  <label for="lastName">Last name:</label>
                  <input type="text" name="lastName" id="lastName" placeholder="Last Name" class="form-control mt-2" required />
              </div>
            <% } %>
            <div class="form-group">
              <label for="username">Username:</label>
              <input type="text" name="username" id="username" pattern="[A-Za-z0-9]{5,10}" title="Enter 5 to 10 letters or numbers" placeholder="Username" class="form-control mt-2" required />
            </div>
            <div class="form-group">
              <label for="email">Email:</label>
              <input type="email" name="email" id="email" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" title="Please enter a valid email address" placeholder="Email" class="form-control mt-2" required />
            </div>
            <div class="form-group">
              <label for="password" class="mt-2">Password:</label>
              <input type="password" name="password" id="password"  placeholder="Password" class="form-control mt-2"  required />
              </div>
            <div class="form-group">
              <label for="confirm-password" class="mt-2">Confirm Password:</label>
              <input type="password" name="confirm_password" id="confirm-password" placeholder="Confirm Password" class="form-control mt-2" required />
            </div>
            <button type="submit" class="btn btn-primary mt-2 w-100">Sign up</button>
          </form>

          <% if (!isAdmin) { %>
            <hr />
            <h5 class="text-center">Already have an account?</h5>
            <p class="text-center"><a href="./login.jsp">Login</a></p> 
          <% } %>
        </section>
      </div>
    </div>
<jsp:include page="./template/footer.jsp"></jsp:include>
    <script src="./Bootstrap/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
