<!-- admin_edit_user.jsp -->
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session.getAttribute("admin_id") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String adminName = (String) session.getAttribute("admin_name");
    String message = "";
    String messageType = "";

    String userIdParam = request.getParameter("id");
    String name = "";
    String mobile = "";
    String email = "";
    String address = "";
    int editUserId = 0;

    if(userIdParam != null && !userIdParam.equals("")) {
        editUserId = Integer.parseInt(userIdParam);
    }

    if(request.getMethod().equals("POST")) {
        editUserId = Integer.parseInt(request.getParameter("user_id"));
        name = request.getParameter("name");
        mobile = request.getParameter("mobile");
        email = request.getParameter("email");
        address = request.getParameter("address");

        Connection conn = null;
        PreparedStatement pst = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gym_management", "root", "031204");

            String sql = "UPDATE users SET name = ?, mobile = ?, email = ?, address = ? WHERE id = ?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, name);
            pst.setString(2, mobile);
            pst.setString(3, email);
            pst.setString(4, address);
            pst.setInt(5, editUserId);

            int result = pst.executeUpdate();

            if(result > 0) {
                message = "User updated successfully!";
                messageType = "success";
            } else {
                message = "Failed to update user.";
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

    if(editUserId > 0) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gym_management", "root", "031204");

            String sql = "SELECT * FROM users WHERE id = ?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, editUserId);
            rs = pst.executeQuery();

            if(rs.next()) {
                name = rs.getString("name");
                mobile = rs.getString("mobile");
                email = rs.getString("email");
                address = rs.getString("address");
            }

        } catch(Exception e) {
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
    <title>Edit User - Admin Panel</title>
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>💪 ADMIN PANEL</h2>
            </div>
            <nav class="sidebar-nav">
                <a href="admin_dashboard.jsp" class="nav-item">📊 Dashboard</a>
                <a href="admin_manage_users.jsp" class="nav-item active">👥 Manage Users</a>
                <a href="admin_manage_membership.jsp" class="nav-item">📅 Manage Memberships</a>
                <a href="admin_view_attendance.jsp" class="nav-item">✅ View Attendance</a>
                <a href="logout.jsp" class="nav-item">🚪 Logout</a>
            </nav>
        </aside>

        <main class="main-content">
            <header class="top-bar">
                <h1>Edit User Details</h1>
                <div class="user-info">
                    <span>👤 Admin: <%= adminName %></span>
                </div>
            </header>

            <div class="edit-container">
                <div class="edit-box">
                    <h2>✏️ Update User Information</h2>

                    <% if(!message.equals("")) { %>
                        <div class="alert <%= messageType %>">
                            <%= message %>
                        </div>
                    <% } %>

                    <form method="POST" action="admin_edit_user.jsp" class="edit-form">
                        <input type="hidden" name="user_id" value="<%= editUserId %>">

                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" value="<%= name %>" placeholder="Enter full name" required>
                        </div>

                        <div class="form-group">
                            <label for="mobile">Mobile Number</label>
                            <input type="text" id="mobile" name="mobile" value="<%= mobile %>" placeholder="Enter mobile number" pattern="[0-9]{10}" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" value="<%= email %>" placeholder="Enter email address" required>
                        </div>

                        <div class="form-group">
                            <label for="address">Address</label>
                            <textarea id="address" name="address" placeholder="Enter address" rows="3" required><%= address %></textarea>
                        </div>

                        <div class="button-group">
                            <button type="submit" class="btn-primary">Update User</button>
                            <a href="admin_manage_users.jsp" class="btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</body>
</html>