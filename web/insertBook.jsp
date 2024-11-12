<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Insert Book</title>
        <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css" />
        
        <script>
            function confirmInsert() {
                return confirm("Are you sure you want to add this book?");
            }
        </script>

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
                <!-- Responsive signup section -->
                <section id="signup" class="col-12 col-md-6 col-lg-6 border rounded p-3 mt-5 mx-auto" style="max-width: 50%;">
                    <h1 class="text-center">Insert Book</h1>

                    <form id="insertBook" action="insertBook.jsp" method="post">
                        <div class="form-group">
                            <label for="title">Title:</label>
                            <input type="text" class="form-control" name="title" id="title" placeholder="Title" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="author">Author:</label>
                            <input type="text" class="form-control" name="author" id="author" placeholder="Author" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="qtyInStock">Quantity InStock : </label>
                            <input type="number" class="form-control" name="qtyInStock" id="qtyInStock" placeholder="qtyInStock" min="0" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="price">Price:</label>
                            <input type="number" class="form-control" name="price" id="price" placeholder="0" min="0" step="0.01" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="price">Price Down :</label>
                            <input type="number" class="form-control" name="priceDown" id="priceDown" placeholder="0" min="0" step="0.01" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="description">Description:</label>
                            <textarea class="form-control" name="description" id="description" placeholder="description" rows="7" required></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label for="image">Book Cover Image:</label>
                            <input type="file" class="form-control" name="image" id="image" accept="image/*" required>
                        </div>

                        <input type="hidden" id="imgBase64" name="imgBase64">
                        <button type="submit" class="btn btn-primary mt-2 w-100" onclick="return confirmInsert()">Insert</button>
                    </form>
                </section>
            </div>
        </div>

        <%
            request.setCharacterEncoding("UTF-8");
            String message = "";
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String title = request.getParameter("title");
                String author = request.getParameter("author");
                String price = request.getParameter("price");
                String priceDown = request.getParameter("priceDown");
                String qtyInStock = request.getParameter("qtyInStock");
                String description = request.getParameter("description");
                String imgBase64 = request.getParameter("imgBase64");

                if (title != null && author != null && price != null && description != null && imgBase64 != null) {
                    try (
                        Connection conn = (new database.connect()).getC();
                        PreparedStatement ps = conn.prepareStatement(
                            "INSERT INTO books (name, price, image, description, author, priceDown, qtyInStock) VALUES (?, ?, ?, ?, ?, ?, ?)")
                    ) {
                        ps.setString(1, title);
                        ps.setString(2, price);
                        ps.setBytes(3, java.util.Base64.getDecoder().decode(imgBase64));
                        ps.setString(4, description);
                        ps.setString(5, author);
                        ps.setString(6, priceDown);
                        ps.setString(7, qtyInStock);

                        int rowsInserted = ps.executeUpdate();
                        message = rowsInserted > 0 
                            ? "<div class='alert alert-success'>Data inserted successfully!</div>" 
                            : "<div class='alert alert-danger'>Failed to insert data.</div>";
                        response.sendRedirect("./manageBook.jsp");
                    } catch (SQLException e) {
                        message = "<div class='alert alert-danger'>Database error: " + e.getMessage() + "</div>";
                    }
                } else {
                    message = "<div class='alert alert-danger'>Please fill in all fields.</div>";
                }
            }
        %>

        
        <jsp:include page="./template/footer.jsp"></jsp:include>
        <!-- jQuery for handling the form submission and converting image to Base64 -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
            
            // Convert file to Base64 string and submit form
            function convertFileToBase64(file) {
                return new Promise((resolve, reject) => {
                    const reader = new FileReader();
                    reader.onload = () => resolve(reader.result.split(',')[1]); // Get Base64 string without prefix
                    reader.onerror = (error) => reject(error);
                    reader.readAsDataURL(file);
                });
            }

            $(document).ready(function() {
                $('#insertBook').on('submit', async function(event) {
                    event.preventDefault(); // Prevent form submission until file is converted

                    const file = $('#image')[0].files[0];
                    if (file) {
                        try {
                            const base64String = await convertFileToBase64(file);
                            $('#imgBase64').val(base64String); // Set hidden input value

                            // Submit the form after setting Base64 string
                            this.submit();
                        } catch (error) {
                            alert('Error converting image to Base64: ' + error);
                        }
                    } else {
                        alert('Please select an image to upload.');
                    }
                });
            });
        </script>

        <script src="./Bootstrap/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
