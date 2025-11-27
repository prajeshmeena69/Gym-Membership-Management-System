<!-- register.jsp -->
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String message = "";
    String messageType = "";

    if(request.getMethod().equals("POST")) {
        String name = request.getParameter("name");
        String mobile = request.getParameter("mobile");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement pst = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gym_management", "root", "031204");

            String sql = "INSERT INTO users (name, mobile, email, address, password) VALUES (?, ?, ?, ?, ?)";
            pst = conn.prepareStatement(sql);
            pst.setString(1, name);
            pst.setString(2, mobile);
            pst.setString(3, email);
            pst.setString(4, address);
            pst.setString(5, password);

            int result = pst.executeUpdate();

            if(result > 0) {
                message = "Registration Successful! You can now login.";
                messageType = "success";
            } else {
                message = "Registration Failed. Please try again.";
                messageType = "error";
            }

        } catch(Exception e) {
            message = "Error: " + e.getMessage();
            messageType = "error";
            e.printStackTrace();
        } finally {
            if(pst != null) pst.close();
            if(conn != null) conn.close();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gym Management - Register</title>
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <div class="register-container">
        <div class="register-box">
            <div class="register-header">
                <h1>💪 GYM MANAGEMENT</h1>
                <p>Create Your Account</p>
            </div>

            <% if(!message.equals("")) { %>
                <div class="alert <%= messageType %>">
                    <%= message %>
                </div>
            <% } %>

            <form method="POST" action="register.jsp" class="register-form">
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" placeholder="Enter your name" required>
                </div>

                <div class="form-group">
                    <label for="mobile">Mobile Number</label>
                    <input type="text" id="mobile" name="mobile" placeholder="Enter mobile number" pattern="[0-9]{10}" required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required>
                </div>

                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea id="address" name="address" placeholder="Enter your address" rows="3" required></textarea>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Create a password" required>
                </div>

                <button type="submit" class="btn-primary">Register Now</button>
            </form>

            <div class="register-footer">
                <p>Already have an account? <a href="login.jsp">Login Here</a></p>
            </div>
        </div>
    </div>
</body>
</html>