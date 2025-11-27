<!-- admin_manage_users.jsp -->
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session.getAttribute("admin_id") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String adminName = (String) session.getAttribute("admin_name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Admin Panel</title>
    <link rel="stylesheet" href="assets/style.css">
    <script>
        function confirmDelete(userId, userName) {
            if(confirm('Are you sure you want to delete user: ' + userName + '?\n\nThis will also delete all their attendance and membership records.')) {
                window.location.href = 'admin_delete_user.jsp?id=' + userId;
            }
        }
    </script>
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
                <h1>Manage Users</h1>
                <div class="user-info">
                    <span>👤 Admin: <%= adminName %></span>
                </div>
            </header>

            <div class="dashboard-section">
                <h2>All Registered Members</h2>
                <div class="table-container">
                    <table class="data-table glow-table" style="table-layout: fixed; width: 100%;">
                        <colgroup>
                            <col style="width: 8%;">
                            <col style="width: 18%;">
                            <col style="width: 13%;">
                            <col style="width: 22%;">
                            <col style="width: 24%;">
                            <col style="width: 15%;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Mobile</th>
                                <th>Email</th>
                                <th>Address</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection conn = null;
                                Statement stmt = null;
                                ResultSet rs = null;

                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gym_management", "root", "031204");
                                    stmt = conn.createStatement();
                                    rs = stmt.executeQuery("SELECT * FROM users ORDER BY id ASC");

                                    boolean hasUsers = false;

                                    while(rs.next()) {
                                        hasUsers = true;
                                        int userId = rs.getInt("id");
                                        String name = rs.getString("name");
                            %>
                            <tr>
                                <td><%= userId %></td>
                                <td><%= name %></td>
                                <td><%= rs.getString("mobile") %></td>
                                <td><%= rs.getString("email") %></td>
                                <td><%= rs.getString("address") %></td>
                                <td>
                                    <div class="action-btns">
                                        <a href="admin_edit_user.jsp?id=<%= userId %>" class="btn-edit" title="Edit User">✏️</a>
                                        <button onclick="confirmDelete(<%= userId %>, '<%= name %>')" class="btn-delete" title="Delete User">🗑️</button>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }

                                    if(!hasUsers) {
                            %>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 30px; opacity: 0.6;">
                                    No members registered yet.
                                </td>
                            </tr>
                            <%
                                    }
                                } catch(Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if(rs != null) rs.close();
                                    if(stmt != null) stmt.close();
                                    if(conn != null) conn.close();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>