<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"/>
       <style>
      .search-box {
        width: 300px;
        border: 1px solid #ced4da;
        border-radius: 5px;
      }
      .navbar-center {
        flex-grow: 1;
        display: flex;
        justify-content: center;
      }
      .navbar-center form {
        display: flex;
        align-items: center;
      }
    </style>
  </head>
  <body>
    <section>
      <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <a class="navbar-brand ms-2" href="./index.jsp">Chapter & Verse</a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav me-auto">
            <li class="nav-item active">
              <a class="nav-link" href="./index.jsp">Books</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="./priceDown.jsp">Price Down</a>
            </li>
          </ul>

          <div class="navbar-center">
            <form class="d-flex" action="./search.jsp" method="GET">
              <input class="form-control me-2 search-box" type="search" name="search" placeholder="Search books..." aria-label="Search">
              <button class="btn btn-outline-primary" type="submit" hidden>Search</button>
            </form>
          </div>
            
          <ul class="navbar-nav ms-auto">
            <li class="nav-item">
              <a class="nav-link position-relative" href="./cart.jsp">
                <i class="fas fa-shopping-cart"></i>
                <!-- Cart item count badge can be added here in the future -->
              </a>
            </li>

            <li class="nav-item d-flex">
                <% 
                  String user = (String) session.getAttribute("user");
                  if (user != null) { 
                %>
                <a class="nav-link" href="./profile.jsp">Welcome, <%= user %></a> 
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
