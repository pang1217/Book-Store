<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Your Cart</title>
    <link rel="stylesheet" href="./Bootstrap/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="./template/navbar.jsp"></jsp:include>

    <% 
        String user = (String) session.getAttribute("user");
        if(user != null){
    %>
    <div class="container my-5">
        <h1>Your Cart</h1>

        <table class="table" id="cartTable">
            <thead>
                <tr>
                    <th></th>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="cartTableBody">
                <!-- Cart items will be dynamically inserted here -->
            </tbody>
        </table>

        <div class="text-end">
            <h4 id="grandTotal">Grand Total: 0 Bath</h4>
            <button class="btn btn-success mt-3" onclick="goToCheckout()">Checkout</button>
        </div>
    </div>
    <%
        } else {
            response.sendRedirect("./login.jsp");
            return; // Stop further execution
        } %>
    
    <jsp:include page="./template/footer.jsp"></jsp:include>
    
    <script>
        const cart = JSON.parse(localStorage.getItem(`cart_${user}`)) || [];
        const cartTableBody = document.getElementById('cartTableBody');
        let grandTotal = 0;
        let allOutOfStock = true;

        function renderCart() {
            cartTableBody.innerHTML = ""; // Clear the table body
            grandTotal = 0; // Reset grand total
            allOutOfStock = true; // Reset the out-of-stock flag

            if (cart.length === 0) {
                cartTableBody.innerHTML = "<tr><td colspan='7'>Your cart is empty.</td></tr>";
                document.getElementById("grandTotal").innerText = "Grand Total: 0 Bath";
                document.querySelector(".btn-success").disabled = true; // Disable checkout button if cart is empty
            } else {
                cart.forEach(function(item, index) {
                    const id = item.id;
                    let quantity = item.quantity;
                    const fetchUrl = "http://localhost:8080/Book_store/getBookDetails?id=" + id;

                    fetch(fetchUrl)
                        .then(function(response) {
                            if (!response.ok) throw new Error("Network response was not ok");
                            return response.json();
                        })
                        .then(function(book) {
                            const isDiscounted = book.priceDown && book.priceDown < book.price;
                            const effectivePrice = isDiscounted ? book.priceDown : book.price;
                            let total = effectivePrice * quantity;

                            // Check if the book is out of stock
                            const outOfStock = book.qtyInStock === 0;
                            if (!outOfStock) allOutOfStock = false;

                            // If quantity exceeds available stock, adjust it
                            if (quantity > book.qtyInStock) {
                                quantity = book.qtyInStock; // Set to maximum available
                                item.quantity = quantity; // Update localStorage item
                                localStorage.setItem('cart', JSON.stringify(cart)); // Save updated cart
                                alert(`จำนวนหนังสือ "${book.title}" ถูกปรับให้ตรงกับสต็อกที่เหลือในคลัง (${quantity} เล่ม)`);
                            }

                            total = effectivePrice * quantity; // Update total based on adjusted quantity
                            grandTotal += total;

                            // Add row to cart table
                            const row = document.createElement("tr");
                            row.innerHTML =
                                "<td><div class='text-center'><img src='image?bookid=" + id + "' alt='Book Image' style='width: 100px; height: auto;'></div></td>" +
                                "<td>" + book.title + "</td>" +
                                "<td>" + book.author + "</td>" +
                                "<td>" + (isDiscounted ? "<span>" + book.priceDown + " Bath</span><br><span class='text-decoration-line-through'>" + book.price + " Bath</span>" : book.price + " Bath") + "</td>" +
                                "<td>" +
                                    (outOfStock ? 
                                    "<span class='text-danger'>Out of stock</span>" :
                                    "<input type='number' min='1' value='" + quantity + "' max='" + book.qtyInStock + "' onchange='updateQuantity(" + index + ", this.value)' style='width: 60px;'>") +
                                "</td>" +
                                "<td>" + total.toFixed(2) + " Bath</td>" +
                                "<td><button class='btn btn-danger btn-sm' onclick='removeItem(" + index + ")'>Delete</button></td>";

                            cartTableBody.appendChild(row);

                            // Update grand total
                            document.getElementById("grandTotal").innerText = "Grand Total: " + grandTotal.toFixed(2) + " Bath";

                            // Enable or disable the checkout button based on stock status
                            document.querySelector(".btn-success").disabled = allOutOfStock;
                        })
                        .catch(function(error) {
                            console.error("Error fetching book details:", error);
                        });
                });
            }
        }
        
        function updateQuantity(index, newQuantity) {
            if (newQuantity < 1) return; // Ensure quantity is at least 1
            cart[index].quantity = parseInt(newQuantity); // Update the quantity
            localStorage.setItem('cart', JSON.stringify(cart)); // Update cart in localStorage
            renderCart(); // Re-render the cart
        }

        // Function to remove an item from the cart
        function removeItem(index) {
            cart.splice(index, 1); // Remove the item from the array
            localStorage.setItem('cart', JSON.stringify(cart)); // Update cart in localStorage
            renderCart(); // Re-render the cart
        }
       
        function goToCheckout() {
            localStorage.setItem('cart', JSON.stringify(cart)); // Store the cart in localStorage
            window.location.href = "checkout.jsp"; // Redirect to the checkout page
        }
        

        // Render cart on page load
        renderCart();
    </script>

    <script src="./Bootstrap/js/bootstrap.min.js"></script>
</body>
</html>
