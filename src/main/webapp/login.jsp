<!-- login.jsp -->
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String message = "";
    String messageType = "";

    if(request.getMethod().equals("POST")) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String loginType = request.getParameter("login_type"); // "user" or "admin"

        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gym_management", "root", "031204");

            String sql = "";

            if("admin".equals(loginType)) {
                // Admin login
                sql = "SELECT * FROM admin WHERE email = ? AND password = ?";
            } else {
                // User login
                sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            }

            pst = conn.prepareStatement(sql);
            pst.setString(1, email);
            pst.setString(2, password);

            rs = pst.executeQuery();

            if(rs.next()) {
                if("admin".equals(loginType)) {
                    // Admin login successful
                    session.setAttribute("admin_id", rs.getInt("admin_id"));
                    session.setAttribute("admin_name", rs.getString("name"));
                    session.setAttribute("admin_email", rs.getString("email"));
                    session.setAttribute("role", "admin");
                    response.sendRedirect("admin_dashboard.jsp");
                } else {
                    // User login successful
                    session.setAttribute("user_id", rs.getInt("id"));
                    session.setAttribute("user_name", rs.getString("name"));
                    session.setAttribute("user_email", rs.getString("email"));
                    session.setAttribute("role", "user");
                    response.sendRedirect("dashboard.jsp");
                }
            } else {
                message = "Invalid Email or Password!";
                messageType = "error";
            }

        } catch(Exception e) {
            message = "Error: " + e.getMessage();
            messageType = "error";
            e.printStackTrace();
        } finally {
            if(rs != null) rs.close();
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
    <title>Gym Management - Login</title>
    <link rel="stylesheet" href="assets/style.css">
    <style>
        .login-type-toggle {
            display: flex;
            gap: 16px;
            margin-bottom: 24px;
            background: rgba(31, 41, 55, 0.6);
            padding: 8px;
            border-radius: 12px;
        }

        .login-type-btn {
            flex: 1;
            padding: 12px;
            background: transparent;
            border: none;
            color: rgba(255, 255, 255, 0.6);
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
        }

        .login-type-btn.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #ffffff;
        }

        .login-type-btn:hover {
            color: #ffffff;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <div class="login-header">
                <h1>💪 GYM MANAGEMENT</h1>
                <p>Login to Your Account</p>
            </div>

            <% if(!message.equals("")) { %>
                <div class="alert <%= messageType %>">
                    <%= message %>
                </div>
            <% } %>

            <form method="POST" action="login.jsp" class="login-form">
                <div class="login-type-toggle">
                    <button type="button" class="login-type-btn active" onclick="setLoginType('user')">
                        👤 User Login
                    </button>
                    <button type="button" class="login-type-btn" onclick="setLoginType('admin')">
                        🔐 Admin Login
                    </button>
                </div>

                <input type="hidden" name="login_type" id="login_type" value="user">

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                </div>

                <button type="submit" class="btn-primary">Login Now</button>
            </form>

            <div class="login-footer">
                <p>Don't have an account? <a href="index.jsp">Register Here</a></p>
            </div>
        </div>
    </div>

    <script>
        function setLoginType(type) {
            document.getElementById('login_type').value = type;

            // Update button styles
            const buttons = document.querySelectorAll('.login-type-btn');
            buttons.forEach(btn => {
                btn.classList.remove('active');
            });

            event.target.classList.add('active');
        }
    </script>
</body>
</html>