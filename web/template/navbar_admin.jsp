<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    />
  </head>
  <body>
    <section>
      <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <a class="navbar-brand ps-2" href="./index.jsp">Chapter & Verse</a>

        <button
          class="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navbarSupportedContent"
          aria-controls="navbarSupportedContent"
          aria-expanded="false"
          aria-label="Toggle navigation"
        >
          <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <!-- Use ms-auto to align the list to the right -->
          <ul class="navbar-nav ms-auto">
            <li class="nav-item d-flex">
              <% 
                // Check if the user is logged in
                String user = (String) session.getAttribute("user");
                if (user != null) { 
              %>
                <a class="nav-link" href="#">Welcome, <%= user %></a> 
                <a class="nav-link" href="./logout.jsp">Logout</a>
              <% } else { %>
                <a class="nav-link" href="./login.jsp">Login</a>
              <% } %>
            </li>
          </ul>
        </div>
      </nav>
    </section>

    <!-- JS -->
    <script src="./Bootstrap/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
