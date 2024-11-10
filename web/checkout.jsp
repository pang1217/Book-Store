<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="java.sql.*" %> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Checkout</title>
        <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css">
    </head>
    <body>
        <jsp:include page="./template/navbar.jsp"></jsp:include>

        <%
            request.setCharacterEncoding("UTF-8");
            String user = (String) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("./login.jsp");
            }
        %>
        <section class="container mt-3">
            <h1>Order Summary</h1>
            <form id="orderForm" action="confirmOrder.jsp" method="post">
                <div class="d-flex justify-content-between">
                    <div class="w-25">
                        <div class="form-group">
                            <label for="name">ชื่อ : </label>
                            <input class="form-control" type="text" id="name" name="name" required>
                        </div>
                        <div class="form-group">
                            <label for="address">ที่อยู่ในการจัดส่ง : </label>
                            <textarea class="form-control" rows="5" name="address" id="address" required></textarea>
                        </div>
                        <div class="form-group">
                            <label for="phoneNO">เบอร์โทรศัพท์ : </label>
                            <input class="form-control" type="tel" name="phoneNO" id="phoneNo" pattern="\d{3}-)?\d{3}-\d{4}" 
                                    title="Please enter a phone number in the format: 123-456-7890"required>
                        </div>
                         <!-- Hidden inputs for book IDs and quantities will be added here -->
                        <div id="hiddenInputsContainer"></div>
                    </div>
                    <hr>
                    <div class="w-75 ps-3">
                        <table class="table" id="cartTable">
                            <thead>
                                <tr>
                                    <th></th>
                                    <th>Title</th>
                                    <th>Author</th>
                                    <th>Price</th>
                                    <th>Quantity</th>
                                    <th>Total</th>
                                </tr>
                            </thead>
                            <tbody id="cartTableBody">
                                <!-- Cart items will be dynamically inserted here -->
                            </tbody>
                        </table>

                        <div class="text-end">
                            <h4 id="grandTotal">Grand Total: 0 Bath</h4>
                            <button class="btn btn-success mt-3" >Place Order</button>
                        </div>

                    </div>
                </div> 
            </form>
        </section>
        <jsp:include page="./template/footer.jsp"></jsp:include>
           <script>
            const cart = JSON.parse(localStorage.getItem('cart')) || [];
            const cartTableBody = document.getElementById('cartTableBody');
            const hiddenInputsContainer = document.getElementById('hiddenInputsContainer');
            let grandTotal = 0;
            console.log(cart);
            function renderCart() {
                cartTableBody.innerHTML = ""; // Clear the table body
                grandTotal = 0; // Reset grand total

                if (cart.length === 0) {
                    cartTableBody.innerHTML = "<tr><td colspan='7'>Your cart is empty.</td></tr>";
                    document.getElementById("grandTotal").innerText = "Grand Total: 0 Bath";
                } else {
                    cart.forEach(function (item, index) {
                        const id = item.id;
                        const quantity = item.quantity;
                        const fetchUrl = "http://localhost:8080/Book_store/getBookDetails?id=" + id;
                        
                        fetch(fetchUrl)
                                .then(function (response) {
                                    if (!response.ok)
                                        throw new Error("Network response was not ok");
                                    return response.json();
                                })
                                .then(function (book) {
                                    const isDiscounted = book.priceDown && book.priceDown < book.price;
                                    const effectivePrice = isDiscounted ? book.priceDown : book.price;
                                    const total = effectivePrice * quantity;
                                    grandTotal += total;

                                    // Add row to cart table
                                    const row = document.createElement("tr");
                                    row.innerHTML =
                                            "<td><div class='text-center'><img src='image?bookid=" + id + "' alt='Book Image' style='width: 100px; height: auto;'></div></td>" +
                                            "<td>" + book.title + "</td>" +
                                            "<td>" + book.author + "</td>" +
                                            "<td>" + (isDiscounted ? "<span>" + book.priceDown + " Bath</span><br><span class='text-decoration-line-through'>" + book.price + " Bath</span>" : book.price + " Bath") + "</td>" +
                                            "<td>" + quantity + "</td>" +
                                            "<td>" + total.toFixed(2) + " Bath</td>";

                                    cartTableBody.appendChild(row);
                                    
                                    const hiddenId = document.createElement("input");
                                    hiddenId.type = "hidden";
                                    hiddenId.name = `item_`+ index + `_id`;
                                    hiddenId.value = id;

                                    const hiddenQty = document.createElement("input");
                                    hiddenQty.type = "hidden";
                                    hiddenQty.name = `item_`+ index + `_quantity`;
                                    hiddenQty.value = quantity;

                                    hiddenInputsContainer.appendChild(hiddenId);
                                    hiddenInputsContainer.appendChild(hiddenQty);
                                    // Update grand total
                                    document.getElementById("grandTotal").innerText = "Grand Total: " + grandTotal.toFixed(2) + " Bath";
                                })
                                .catch(function (error) {
                                    console.error("Error fetching book details:", error);
                                });
                    });
                }
            }


            //      call renderCart to display
            renderCart();
        </script>
        <script src="./Bootstrap/js/bootstrap.min.js"></script>
    </body>
</html>
