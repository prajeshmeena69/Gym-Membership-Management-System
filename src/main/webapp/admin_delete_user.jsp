<!-- admin_delete_user.jsp -->
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

    if(userIdParam != null && !userIdParam.equals("")) {
        int deleteUserId = Integer.parseInt(userIdParam);

        Connection conn = null;
        PreparedStatement pst = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gym_management", "root", "031204");

            // Delete related attendance records
            String deleteAttendance = "DELETE FROM attendance WHERE user_id = ?";
            pst = conn.prepareStatement(deleteAttendance);
            pst.setInt(1, deleteUserId);
            pst.executeUpdate();
            pst.close();

            // Delete related membership records
            String deleteMembership = "DELETE FROM membership WHERE user_id = ?";
            pst = conn.prepareStatement(deleteMembership);
            pst.setInt(1, deleteUserId);
            pst.executeUpdate();
            pst.close();

            // Delete the user
            String deleteUser = "DELETE FROM users WHERE id = ?";
            pst = conn.prepareStatement(deleteUser);
            pst.setInt(1, deleteUserId);

            int result = pst.executeUpdate();

            if(result > 0) {
                message = "User deleted successfully!";
                messageType = "success";
            } else {
                message = "Failed to delete user.";
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

        response.setHeader("Refresh", "2; URL=admin_manage_users.jsp");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete User - Admin Panel</title>
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
                <h1>Delete User</h1>
                <div class="user-info">
                    <span>👤 Admin: <%= adminName %></span>
                </div>
            </header>

            <div class="delete-container">
                <div class="delete-box">
                    <% if(!message.equals("")) { %>
                        <div class="alert <%= messageType %>">
                            <%= message %>
                        </div>
                        <p class="redirect-message">Redirecting to Manage Users page...</p>
                    <% } else { %>
                        <div class="alert error">
                            No user ID provided!
                        </div>
                    <% } %>

                    <div class="action-buttons">
                        <a href="admin_manage_users.jsp" class="btn-primary">Go Back to Manage Users</a>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>