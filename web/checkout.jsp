<%-- 
    Document   : checkout
    Created on : 02-Sept-2024, 10:48:00 am
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout</title>
    <link rel="stylesheet" href="checkout.css">
</head>
<body>
    <div class="mainContainer">
    <div class="container">
        <h2>Checkout</h2>

        
        <!-- Order Summary Section -->
        <div class="order-summary">
            <h3>Order Summary</h3>
            <% 
                        int userId = (Integer) session.getAttribute("userId");
                        int carttotal = 0;
                        
                        try {
                        Class.forName("com.mysql.jdbc.Driver");

                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3307/vmart", "root", "vivek17");

                        String sql = "SELECT c.cart_id,p.pname,p.productid, p.price,c.quantity, (p.price * c.quantity) AS total_price,c.added_at FROM cart c JOIN product p ON c.product_id = p.productid WHERE c.user_id = ?;";
                        
                        PreparedStatement ps = con.prepareStatement(sql);
                        
                        ps.setInt(1, userId);

                        ResultSet rs = ps.executeQuery();
                        
                        while(rs.next()) {
                        
                            String name = rs.getString("pname");
                            int cid = rs.getInt("cart_id");

                            int price = rs.getInt("price");
                            int pid = rs.getInt("productid");
                            int totalprc = rs.getInt("total_price");
                            int qt = rs.getInt("quantity");
                            
                            session.setAttribute("cartIt", cid);
                            
                            carttotal += totalprc;
                        
                        
            %>
            
            <p><%=name%>: <span>₹<%=totalprc%></span></p>
            
            
            
            <%
                        }
                        }catch(Exception e) {
                            e.printStackTrace();
                        }
            %>
            <p>Shipping: <span>free</span></p>
            <p class="total">Total: <span>₹<%=carttotal%></span></p>
        </div>

        <!-- Payment Information Section -->
        <form action="OrderServlet" method="post" onsubmit="return validateForm()">
            <h3>Payment Information</h3>

            <label for="cardName">Cardholder's Name</label>
            <input type="text" id="cardName" name="cardName" required>

            <label for="cardNumber">Card Number</label>
<!--            <input type="text" id="cardNumber" name="cardNumber" required>-->
            <input type="text" id="cardNumber" name="cardNumber" required maxlength="16" minlength="16" pattern="\d{16}" title="Please enter a 16-digit card number">

            <label for="expDate">Expiration Date</label>
<!--            <input type="text" id="expDate" name="expDate" placeholder="MM/YY" required>-->
            <input type="text" id="expDate" name="expDate" placeholder="MM/YY" required pattern="(0[1-9]|1[0-2])\/?([0-9]{2})" title="Please enter a valid expiration date in MM/YY format">

            <label for="cvv">CVV</label>
            <input type="text" id="cvv" name="cvv" required maxlength="3" minlength="3" pattern="\d{3}" title="Please enter a 3-digit CVV">
<!--            <input type="text" id="cvv" name="cvv" required>-->

            <button type="submit">Place Order</button>
        </form>
    </div>
    </div>
        
    <script>
        function validateForm() {
            const cardName = document.getElementById('cardName').value.trim();
            const cardNumber = document.getElementById('cardNumber').value;
            const expDate = document.getElementById('expDate').value;
            const cvv = document.getElementById('cvv').value;

            // Validate Cardholder's Name
            if (cardName === "") {
                alert("Please enter the cardholder's name.");
                return false;
            }

            // Validate Card Number (16 digits)
            const cardNumberPattern = /^\d{16}$/;
            if (!cardNumberPattern.test(cardNumber)) {
                alert("Please enter a valid 16-digit card number.");
                return false;
            }

            // Validate Expiration Date (MM/YY format)
            const expDatePattern = /^(0[1-9]|1[0-2])\/?([0-9]{2})$/;
            if (!expDatePattern.test(expDate)) {
                alert("Please enter a valid expiration date (MM/YY).");
                return false;
            }

            // Validate CVV (3 digits)
            const cvvPattern = /^\d{3}$/;
            if (!cvvPattern.test(cvv)) {
                alert("Please enter a valid 3-digit CVV.");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>

