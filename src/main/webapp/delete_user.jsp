<!-- delete_user.jsp -->
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String message = "";
    String messageType = "";

    // Get user ID from URL parameter
    String userIdParam = request.getParameter("id");

    if(userIdParam != null && !userIdParam.equals("")) {
        int deleteUserId = Integer.parseInt(userIdParam);

        Connection conn = null;
        PreparedStatement pst = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gym_management", "root", "031204");

            // First delete related attendance records
            String deleteAttendance = "DELETE FROM attendance WHERE user_id = ?";
            pst = conn.prepareStatement(deleteAttendance);
            pst.setInt(1, deleteUserId);
            pst.executeUpdate();
            pst.close();

            // Then delete related membership records
            String deleteMembership = "DELETE FROM membership WHERE user_id = ?";
            pst = conn.prepareStatement(deleteMembership);
            pst.setInt(1, deleteUserId);
            pst.executeUpdate();
            pst.close();

            // Finally delete the user
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

        // Redirect back to view_records after 2 seconds
        response.setHeader("Refresh", "2; URL=view_records.jsp");
    }

    String userName = (String) session.getAttribute("user_name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete User - Gym Management</title>
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>💪 GYM SYSTEM</h2>
            </div>
            <nav class="sidebar-nav">
                <a href="dashboard.jsp" class="nav-item">📊 Dashboard</a>
                <a href="attendance.jsp" class="nav-item">✅ Mark Attendance</a>
                <a href="view_records.jsp" class="nav-item active">📋 View Records</a>
                <a href="logout.jsp" class="nav-item">🚪 Logout</a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Top Bar -->
            <header class="top-bar">
                <h1>Delete User</h1>
                <div class="user-info">
                    <span>Welcome, <%= userName %></span>
                </div>
            </header>

            <div class="delete-container">
                <div class="delete-box">
                    <% if(!message.equals("")) { %>
                        <div class="alert <%= messageType %>">
                            <%= message %>
                        </div>
                        <p class="redirect-message">Redirecting to View Records page...</p>
                    <% } else { %>
                        <div class="alert error">
                            No user ID provided!
                        </div>
                    <% } %>

                    <div class="action-buttons">
                        <a href="view_records.jsp" class="btn-primary">Go Back to Records</a>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>