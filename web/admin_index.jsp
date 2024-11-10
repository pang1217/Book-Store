<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Homepage</title>
        <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css" />
        <script src="./jquery/jquery-3.6.0.min"></script>
    </head>
    <body>
        <div class="container">
            <h1 class="pt-3">Dashboard</h1>
            <div class="row">

                <%
                    String user = (String) session.getAttribute("user");
                    boolean isAdmin = false, isEmployee = false;
                    if (user != null) {
                        Connection c = (new database.connect()).getC();

                        String sql = "SELECT role FROM user WHERE username = ?";
                        PreparedStatement stmt = c.prepareStatement(sql);
                        stmt.setString(1, user);

                        ResultSet rs = stmt.executeQuery();

                        if (rs.next()) {
                            String role = rs.getString("role");
                            if (role.equals("Admin")) {
                                isAdmin = true;
                            } else if (role.equals("Employee")) {
                                isEmployee = true;
                            }
                            rs.close();
                            stmt.close();
                            c.close();
                        }
                    }
                %>
                <%if (isAdmin) {%>
                <!-- Register employee (for admin)-->
                <div class="col-md-4 col-xl-3 pb-3">
                    <a href="/Book_store/signup.jsp" class="text-decoration-none">
                        <div class="card bg-c-blue order-card">
                            <div class="card-block">
                                <h4 class="p-5 text-center ">Register Employee</h4>
                            </div>
                        </div>
                    </a>
                </div>

                <!--manage Employee-->
                <div class="col-md-4 col-xl-3 pb-3">
                    <a href="./manageEmployee.jsp" class="text-decoration-none">
                        <div class="card bg-c-blue order-card">
                            <div class="card-block">
                                <h4 class="p-5 text-center ">Manage Employee</h4>
                            </div>
                        </div>
                    </a>
                </div>

                <%}%>

                <!--manage book-->
                <div class="col-md-4 col-xl-3 pb-3">
                    <a href="/Book_store/manageBook.jsp" class="text-decoration-none">
                        <div class="card bg-c-blue order-card">
                            <div class="card-block">
                                <h4 class="p-5 text-center ">Manage Book</h4>
                            </div>
                        </div>
                    </a>
                </div>

                <!--add book-->
                <div class="col-md-4 col-xl-3 pb-3">
                    <a href="/Book_store/insertBook.jsp" class="text-decoration-none">
                        <div class="card bg-c-blue order-card">
                            <div class="card-block">
                                <h4 class="p-5 text-center">Insert Book</h4>
                            </div>
                        </div>
                    </a>
                </div>

                <!--edit book-->
                <div class="col-md-4 col-xl-3 pb-3">
                    <a href="" class="text-decoration-none" data-bs-toggle="modal" data-bs-target="#editBookModal">
                        <div class="card bg-c-blue order-card">
                            <div class="card-block">
                                <h4 class="p-5 text-center ">Edit Book</h4>
                            </div>
                        </div>
                    </a>
                </div>


                <!-- Orders-->
                <div class="col-md-4 col-xl-3 pb-3">
                    <a href="./manageOrder.jsp" class="text-decoration-none">
                        <div class="card bg-c-blue order-card">
                            <div class="card-block">
                                <h4 class="p-5 text-center ">Manage Orders</h4>
                            </div>
                        </div>
                    </a>
                </div>

            </div>
        </div>


        <div class="modal" id="editBookModal" tabindex="-1" aria-labelledby="editBookModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editBookModalLabel">Enter Book ID</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="editBookForm" action="/Book_store/editProduct.jsp" method="get">
                            <div class="form-group">
                                <label for="bookId">Book ID:</label>
                                <input type="text" class="form-control" id="bookId" name="bookId" required>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary">Edit Book</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        

        <script src="./Bootstrap/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
