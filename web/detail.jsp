<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Detail</title>
        <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css">
    </head>
    <body>
        <jsp:include page="./template/navbar.jsp"></jsp:include>

        <%
            String user = (String) session.getAttribute("user"); 
            String bookId = request.getParameter("bookid");
            Connection conn = (new database.connect()).getC();
            String sql = "SELECT * FROM Books WHERE bookid = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, bookId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String title = rs.getString("name");
                String author = rs.getString("author");
                double price = rs.getDouble("price");
                String description = rs.getString("description");
                double priceDown = rs.getDouble("priceDown");
                int qtyInStock = rs.getInt("qtyInstock");
        %>

        <section>
            <div class="container my-5">
                <div class="row">
                    <div class="col-md-6 d-flex justify-content-center align-items-center">
                        <img src="image?bookid=<%= bookId%>" alt="" class="img-fluid" style="height: 600px; width: auto;">
                    </div>
                    <div class="col-md-6 text-start mt-2">
                        <h3><%= title%></h3>
                        <p>ผู้เขียน:​ <a href="./listBookByAuthor.jsp?author=<%=author%>"> <%= author%></a></p>
                        <% if (priceDown != 0) {%>
                        ราคา​ : <span >฿<%= priceDown%></span><br>
                        ราคาปกติ : <span class="text-danger text-decoration-line-through">฿<%= price%></span>
                        <% } else {%> 
                        ราคา​ : <span>฿<%= price%></span>
                        <% }%>
                        <div class="mb-3">
                            <label for="quantity" class="form-label">จำนวนที่มีอยู่ในคลัง : <%=qtyInStock%></label>
                            <div class="d-flex align-items-center">
                                <label for="quantity" class="form-label me-2">Quantity:</label>
                                <input type="number" id="quantity" class="form-control w-50" value="1" min="1" max="<%=qtyInStock%>" step="1">
                            </div>
                        </div>

                        <!-- Add to Cart Button -->
                        <%
                            if (qtyInStock != 0) {
                                if (user != null) {
                        %>
                        <button class="btn btn-primary mt-3" id="addToCartBtn" 
                                data-bookid="<%= bookId%>" 
                                data-title ="<%= title%>"
                                >Add to Cart</button>

                        <%
                        } else {
                        %>
                        <a href="login.jsp" class="btn btn-warning mt-3">Login to Add to Cart</a>
                        <%
                            }
                        } else { %>
                        <button class="btn btn-secondary mt-3" disabled>สินค้าหมด</button>
                        <% }
                        %>
                    </div>

                </div>
            </div>
        </section>  
        <div class="container">
            <h3>Description</h3>
            <hr>
            <p><%= description%></p>
        </div>

        <%
            } else {
                out.println("<h2>Book not found</h2>");
            }
            rs.close();
            stmt.close();
            conn.close();
        %>
        
        <jsp:include page="./template/footer.jsp"></jsp:include>
        
        <script>
            document.getElementById('addToCartBtn').addEventListener('click', function () {
                const user = '<%= user %>';
                const bookID = this.getAttribute('data-bookid');
                const title = this.getAttribute('data-title');
                const quantity = parseInt(document.getElementById('quantity').value);

                const cartItem = {
                    id: bookID,
                    quantity: quantity
                };

                let cart = JSON.parse(localStorage.getItem(`cart_${user}`)) || [];

                const existingItemIndex = cart.findIndex(item => item.id === bookID);
                if (existingItemIndex > -1) {
                    cart[existingItemIndex].quantity += quantity;
                } else {
                    cart.push(cartItem);
                }

                console.log(cart);

                localStorage.setItem(`cart_${user}`, JSON.stringify(cart));
                alert(title + " has been added to your cart.");
            });
        </script>


        <!-- JS -->
        <script src="./Bootstrap/js/bootstrap.min.js"></script>
    </body>
</html>
