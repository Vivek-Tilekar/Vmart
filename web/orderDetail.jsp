<%-- 
    Document   : orderDetail
    Created on : 03-Sept-2024, 11:29:30 am
    Author     : user
--%>

<%@page import="java.text.SimpleDateFormat"%>
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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cart</title>
        <link rel="stylesheet" href="home.css">
        <link rel="stylesheet" href="./cart.css">
        <link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css">
    </head>
    <body>
        <section id="header">
            <!-- <a href="#"><img src="logo.png" alt="logo"></a> -->
            <a href="home.jsp"><img src="mylogo.png" alt="logo" class="logo"></a>

            <div class="">
                <ul id="navbar">
                    <li><a href="home.jsp">Home</a></li>
                    <li><a href="product.jsp">Products</a></li>
                    <li><a href="orderDetail.jsp" class="active">Orders</a></li>
                    <li><a href="cart.jsp" ><i class="far fa-shopping-bag"></i></a></li>
                </ul>
            </div>
        </section>
        

        <section id="Myheader2">
            <h2>#Your Orders</h2>
            <p>This are the products that you buy!!!</p>
         </section>

         <section id="cart" class="section-p1">
            <table width="100%">
                <thead>
                    <tr>
                        <td>date</td>
                        <td>Image</td>
                        <td>Product</td>
                        <td>Price</td>
                        <td>Quantity</td>
                        <td>Status</td>
                    </tr>
                </thead>
                <tbody>
                    
                    <% 
//                        int userId = (Integer) session.getAttribute("userId");
                        
                        try {
                        Class.forName("com.mysql.jdbc.Driver");

                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3307/vmart", "root", "vivek17");

                        String sql = "SELECT od.order_id,u.id, u.address,p.productid,p.pname,od.quantity,od.total_price,od.order_date,od.status, od.order_date FROM order_detail od JOIN users u ON od.user_id = u.id JOIN product p ON od.product_id = p.productid WHERE u.id = ?;";
                        
                        PreparedStatement ps = con.prepareStatement(sql);
                        
                        ps.setInt(1, userId);

                        ResultSet rs = ps.executeQuery();
                        
                        while(rs.next()) {
                        
                        
                        
                            String name = rs.getString("pname");
                            String status = rs.getString("status");

                            int price = rs.getInt("total_price");
                            int pid = rs.getInt("productid");
                            int qt = rs.getInt("quantity");
                            Timestamp orderDate = rs.getTimestamp("order_date");
                            String formattedDate = null;
                            if (orderDate != null) {
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                formattedDate = sdf.format(orderDate);
                            }
                            
                        
                        
                    %>
                    <tr>
                        <td><%=formattedDate%></td>
                        <td><img src="ImageGet?id=<%=pid%>" alt=""></td>
                        <td><%=name%></td>
                        <td>₹ <%=price%></td>
                        <td><%=qt%></td>
                        <%
                            if (status.equals("Paid")) {
                        %>
                        <td><p style="color: rgb(22, 241, 22);"><b><%=status%></b></p></td>
                        <%
                            }else {
                        %>
                        <td><p style="color: red;"><b><%=status%></b></p></td>
                        <%};%>
                    </tr>
                    
                    <%
                        }
                        }catch(Exception e) {
                            e.printStackTrace();
                        }
                    %>

<!--                    <tr>
                        <td><a href="#"><i class="far fa-times-circle"></i></a></td>
                        <td><img src="f8.jpg" alt=""></td>
                        <td>Cartoon Astronaut T-shirts</td>
                        <td>₹ 1245</td>
                        <td><input type="number" name="qt" value="1"></td>
                        <td>₹145</td>
                    </tr>-->

                    
                </tbody>
            </table>
         </section>

         
    </body>
</html>
