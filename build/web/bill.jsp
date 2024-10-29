<%-- 
    Document   : bill
    Created on : 08-Oct-2024, 4:27:00 pm
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("index.html");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bill Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .bill-container {
            width: 80%;
            margin: auto;
            border: 1px solid #ddd;
            padding: 20px;
        }
        .bill-container .logo {
            width: 150px;
            height: 150px;
        }
        .bill-header {
            text-align: center;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .bill-header h1 {
            margin: 0;
        }
        .bill-details, .bill-items, .bill-total {
            margin-bottom: 20px;
        }
        .bill-items table {
            width: 100%;
            border-collapse: collapse;
        }
        .bill-items th, .bill-items td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }
        .bill-items th {
            background-color: #f4f4f4;
        }
        .bill-total {
            text-align: right;
        }
        .print-btn {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }
        .print-btn button {
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    
    <a href="home.jsp">Back</a>

<div id="mybill" class="bill-container">
    <div class="bill-header">
        <img src="mylogo.png" alt="logo" class="logo">
        <h1>Customer Invoice</h1>
        <p>Date: <%= new java.util.Date() %></p>
    </div>
    
    <% 
//                        int userId = (Integer) session.getAttribute("userId");
                        int carttotal = 0;
                        String userName = "", userContact = "", userAddress = "";
                        
                        try {
                        Class.forName("com.mysql.jdbc.Driver");

                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3307/vmart", "root", "vivek17");

                        String sql = "SELECT c.cart_id,p.pname,p.productid, p.price,c.quantity, (p.price * c.quantity) AS total_price,c.added_at, u.name AS uname, u.phone, u.address  FROM cart c JOIN product p ON c.product_id = p.productid JOIN users u ON c.user_id = u.id  WHERE c.user_id = ?;";
                        
                        PreparedStatement ps = con.prepareStatement(sql);
                        PreparedStatement ps2 = con.prepareStatement(sql);
                        
                        ps.setInt(1, userId);
                        ps2.setInt(1, userId);

                        ResultSet rs = ps.executeQuery();
                        ResultSet rs2 = ps2.executeQuery();
                        
                        if(rs.next()) {
                            userName = rs.getString("uname");
                            userContact = rs.getString("phone");
                            userAddress = rs.getString("address");
                        }
//                        rs.close();
                    %>

    <!-- Customer Details -->
    <div class="bill-details">
        <p><strong>Customer Name:</strong> <%=userName%></p>
        <p><strong>Contact:</strong> <%=userContact%></p>
        <p><strong>Address:</strong> <%=userAddress%></p>
    </div>

    <!-- Items Table -->
    <div class="bill-items">
        <h2>Items Purchased</h2>
        <table>
            <thead>
            <tr>
                <th>Item</th>
                <th>Quantity</th>
                <th>Price per Unit</th>
                <th>Total</th>
            </tr>
            </thead>
            <tbody>
                <%
                    
                    // above i already used rs.next so cursor is ahed now that's why it not showing any thing
                    while(rs2.next()) {
                        
                        String name = rs2.getString("pname");
                            int cid = rs2.getInt("cart_id");

                            int price = rs2.getInt("price");
                            int pid = rs2.getInt("productid");
                            int totalprc = rs2.getInt("total_price");
                            int qt = rs2.getInt("quantity");
                            
                            carttotal += totalprc;
                %>
            <tr>
                <td><%=name%></td>
                <td><%=qt%></td>
                <td>₹ <%=price%></td>
                <td>₹ <%=totalprc%></td>
            </tr>
            <% }%>
            </tbody>
        </table>
    </div>

    <!-- Total Amount -->
    <div class="bill-total">
        <p><strong>Total Amount: ₹ <%=carttotal%></strong></p>
    </div>

    <!-- Print Button -->
    <%
        
        // Clear the user's cart after order is placed
                String deleteCartSql = "DELETE FROM cart WHERE user_id = ?";
                PreparedStatement psDeleteCart = con.prepareStatement(deleteCartSql);
                psDeleteCart.setInt(1, userId);
                psDeleteCart.executeUpdate();
        
                        }catch(Exception e) {
                            e.printStackTrace();
                        }
    %>
    
</div>
    
    
    
    <div class="print-btn">
        <button onclick="printDiv('mybill')">Print Bill</button>
    </div>

    <script>
        function printDiv(divName) {
            var printContents = document.getElementById(divName).innerHTML;
            var originalContents = document.body.innerHTML;

            document.body.innerHTML = printContents;

            window.print();

            document.body.innerHTML = originalContents;
       }
    </script>
</body>
</html>
