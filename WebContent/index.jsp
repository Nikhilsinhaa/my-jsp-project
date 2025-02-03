<%@page import="cn.techtutorial.connection.DbCon"%>
<%@page import="cn.techtutorial.dao.ProductDao"%>
<%@page import="cn.techtutorial.model.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%
User auth = (User) request.getSession().getAttribute("auth");
if (auth != null) {
    request.setAttribute("person", auth);
}
ProductDao pd = new ProductDao(DbCon.getConnection());
List<Product> products = pd.getAllProducts();
ArrayList<Cart> cart_list = (ArrayList<Cart>) session.getAttribute("cart-list");
if (cart_list != null) {
    request.setAttribute("cart_list", cart_list);
}

// Group products by category
Map<String, List<Product>> categorizedProducts = new HashMap<>();
for (Product p : products) {
    categorizedProducts.computeIfAbsent(p.getCategory(), k -> new ArrayList<>()).add(p);
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>E-Commerce Products</title>
    <style>
        .card-img-top {
            width: 100%;
            height: 250px; /* Ensures images are of uniform size */
            object-fit: cover; /* Prevents stretching and keeps aspect ratio */
        }
        .card {
            height: 100%; /* Makes all product cards the same height */
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .card-body {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            flex-grow: 1;
        }
    </style>
</head>
<body>
    <%@include file="/includes/navbar.jsp"%>

    <div class="container">
        <div class="card-header my-3 text-center">
            <h2>All Products by Category</h2>
        </div>

        <%
        if (!categorizedProducts.isEmpty()) {
            for (Map.Entry<String, List<Product>> entry : categorizedProducts.entrySet()) {
                String category = entry.getKey();
                List<Product> categoryProducts = entry.getValue();
        %>
        
        <!-- Category Section -->
        <div class="mt-4">
            <h3 class="text-center text-primary"><%= category %></h3> 
        </div>
        
        <div class="row">
            <%
            for (Product p : categoryProducts) {
            %>
            <div class="col-md-3 my-3">
                <div class="card">
                    <img class="card-img-top" src="product-image/<%= p.getImage() %>"
                        alt="<%= p.getName() %>">
                    <div class="card-body">
                        <h5 class="card-title"><%= p.getName() %></h5>
                        <h6 class="price">Price: $<%= p.getPrice() %></h6>
                        <div class="mt-3 d-flex justify-content-between">
                            <a class="btn btn-dark" href="add-to-cart?id=<%= p.getId() %>">Add to Cart</a>
                            <a class="btn btn-primary" href="order-now?quantity=1&id=<%= p.getId() %>">Buy Now</a>
                        </div>
                    </div>
                </div>
            </div>
            <%
            }
            %>
        </div>
        <%
            }
        } else {
        %>
        <div class="text-center mt-4">
            <h4 class="text-danger">No products available.</h4>
        </div>
        <%
        }
        %>
    </div>

    <%@include file="/includes/footer.jsp"%>
</body>
</html>
