<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %> 
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css">
  </head>
  <body>
    <!-- Include the navbar -->
    <jsp:include page="./template/navbar.jsp"></jsp:include>

    <%
        // Check if the form has been submitted
        if (request.getParameter("username") != null && request.getParameter("password") != null) {
            String userid = request.getParameter("username");    
            String pwd = request.getParameter("password");

            try {
                // Establish connection
                Connection c = (new database.connect()).getC();

                // Use PreparedStatement to avoid SQL Injection
                String query = "SELECT * FROM user WHERE username = ? AND password = ?";
                PreparedStatement ps = c.prepareStatement(query);
                ps.setString(1, userid);
                ps.setString(2, pwd);

                // Execute the query
                ResultSet rec = ps.executeQuery();

                // Check if the user exists
                if (rec.next()) {
                    session.setAttribute("user", userid);  
                    response.sendRedirect("index.jsp");   // Redirect to homepage
                } else {
                    out.println("<div class='alert alert-danger text-center w-75 mx-auto'>Invalid username or password. <a href='login.jsp'>Try again</a></div>");
                }

                // Close resources
                rec.close();
                ps.close();
                c.close();
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class='alert alert-danger text-center'>An error occurred. Please try again later.</div>");
            }
        }
    %>

    <!-- Container for the login form -->
    <div class="container">
      <div class="row justify-content-center">
        <!-- Responsive login section -->
        <section id="login" class="col-12 col-md-6 col-lg-4 border rounded p-3 mt-5 mx-auto">
          <h1 class="text-center">Login</h1>
          <form action="login.jsp" method="post">
            <div class="form-group">
              <label for="username">Username:</label>
              <input type="text" name="username" id="username" placeholder="Username" class="form-control mt-2" required />
            </div>
            <div class="form-group">
              <label for="password" class="mt-2">Password:</label>
              <input type="password" name="password" id="password" placeholder="Password" class="form-control mt-2" required />
            </div>
            <!--<p class="text-end text-muted"><a href="forgot.jsp">Forgot Password?</a></p>-->
            <button type="submit" class="btn btn-primary mt-2 w-100">Login</button>
          </form>
          <hr />
          <h5 class="text-center">Don't have an account?</h5>
          <p class="text-center">
            <a href="./signup.jsp">Create an Account</a>
          </p>
        </section>
      </div>
    </div>
<jsp:include page="./template/footer.jsp"></jsp:include>
    <!-- JS -->
    <script src="./Bootstrap/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
