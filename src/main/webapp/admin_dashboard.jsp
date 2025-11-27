<!-- admin_dashboard.jsp -->
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if admin is logged in
    if(session.getAttribute("admin_id") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String adminName = (String) session.getAttribute("admin_name");

    int totalMembers = 0;
    int activePlans = 0;
    int todayAttendance = 0;

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gym_management", "root", "031204");
        stmt = conn.createStatement();

        rs = stmt.executeQuery("SELECT COUNT(*) as total FROM users");
        if(rs.next()) totalMembers = rs.getInt("total");
        rs.close();

        rs = stmt.executeQuery("SELECT COUNT(*) as total FROM membership WHERE status = 'Active'");
        if(rs.next()) activePlans = rs.getInt("total");
        rs.close();

        rs = stmt.executeQuery("SELECT COUNT(*) as total FROM attendance WHERE date = CURDATE()");
        if(rs.next()) todayAttendance = rs.getInt("total");
        rs.close();

    } catch(Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Gym Management</title>
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
                <a href="admin_dashboard.jsp" class="nav-item active">📊 Dashboard</a>
                <a href="admin_manage_users.jsp" class="nav-item">👥 Manage Users</a>
                <a href="admin_manage_membership.jsp" class="nav-item">📅 Manage Memberships</a>
                <a href="admin_view_attendance.jsp" class="nav-item">✅ View Attendance</a>
                <a href="logout.jsp" class="nav-item">🚪 Logout</a>
            </nav>
        </aside>

        <main class="main-content">
            <header class="top-bar">
                <h1>Admin Dashboard</h1>
                <div class="user-info">
                    <span>👤 Admin: <%= adminName %></span>
                </div>
            </header>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-details">
                        <h3><%= totalMembers %></h3>
                        <p>Total Members</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">📅</div>
                    <div class="stat-details">
                        <h3><%= activePlans %></h3>
                        <p>Active Plans</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">✅</div>
                    <div class="stat-details">
                        <h3><%= todayAttendance %></h3>
                        <p>Today's Attendance</p>
                    </div>
                </div>
            </div>

            <div class="dashboard-section">
                <h2>All Registered Members</h2>
                <div class="table-container">
                    <table class="data-table glow-table" style="table-layout: fixed; width: 100%;">
                        <colgroup>
                            <col style="width: 8%;">
                            <col style="width: 18%;">
                            <col style="width: 15%;">
                            <col style="width: 22%;">
                            <col style="width: 22%;">
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
                                try {
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
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="dashboard-section">
                <h2>Recent Membership Plans</h2>
                <div class="table-container">
                    <table class="data-table" style="table-layout: fixed; width: 100%;">
                        <colgroup>
                            <col style="width: 10%;">
                            <col style="width: 20%;">
                            <col style="width: 20%;">
                            <col style="width: 18%;">
                            <col style="width: 18%;">
                            <col style="width: 14%;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Member Name</th>
                                <th>Plan Type</th>
                                <th>Start Date</th>
                                <th>End Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    PreparedStatement pst = conn.prepareStatement(
                                        "SELECT m.*, u.name FROM membership m " +
                                        "JOIN users u ON m.user_id = u.id " +
                                        "ORDER BY m.start_date ASC LIMIT 10"
                                    );
                                    ResultSet membershipRs = pst.executeQuery();
                                    boolean hasMemberships = false;

                                    while(membershipRs.next()) {
                                        hasMemberships = true;
                            %>
                            <tr>
                                <td><%= membershipRs.getInt("membership_id") %></td>
                                <td><%= membershipRs.getString("name") %></td>
                                <td><%= membershipRs.getString("plan") %></td>
                                <td><%= membershipRs.getString("start_date") %></td>
                                <td><%= membershipRs.getString("end_date") %></td>
                                <td><span class="status-badge <%= membershipRs.getString("status").toLowerCase() %>"><%= membershipRs.getString("status") %></span></td>
                            </tr>
                            <%
                                    }

                                    if(!hasMemberships) {
                            %>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 30px; opacity: 0.6;">
                                    No membership plans assigned yet.
                                </td>
                            </tr>
                            <%
                                    }
                                    membershipRs.close();
                                    pst.close();
                                } catch(Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="quick-actions">
                <h2>Quick Actions</h2>
                <div class="action-buttons">
                    <a href="admin_manage_users.jsp" class="action-btn">👥 Manage Users</a>
                    <a href="admin_manage_membership.jsp" class="action-btn">📅 Assign Membership</a>
                    <a href="admin_view_attendance.jsp" class="action-btn">✅ View Attendance</a>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
<%
    if(rs != null) rs.close();
    if(stmt != null) stmt.close();
    if(conn != null) conn.close();
%>