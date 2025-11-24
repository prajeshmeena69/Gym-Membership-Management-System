<!-- view_records.jsp -->
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session.getAttribute("user_id") == null || !"user".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("user_name");
    int loggedInUserId = (int) session.getAttribute("user_id");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Gym Management</title>
    <link rel="stylesheet" href="assets/style.css">
    <script>
        function confirmDelete(userId, userName) {
            if(confirm('Are you sure you want to delete your account: ' + userName + '?\n\nThis will also delete all your attendance and membership records.')) {
                window.location.href = 'delete_user.jsp?id=' + userId;
            }
        }
    </script>
</head>
<body>
    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>💪 GYM SYSTEM</h2>
            </div>
            <nav class="sidebar-nav">
                <a href="dashboard.jsp" class="nav-item">📊 Dashboard</a>
                <a href="attendance.jsp" class="nav-item">✅ Mark Attendance</a>
                <a href="view_records.jsp" class="nav-item active">📋 My Profile</a>
                <a href="logout.jsp" class="nav-item">🚪 Logout</a>
            </nav>
        </aside>

        <main class="main-content">
            <header class="top-bar">
                <h1>My Profile & Records</h1>
                <div class="user-info">
                    <span>Welcome, <%= userName %></span>
                </div>
            </header>

            <div class="records-section">
                <h2>👤 My Profile Information</h2>
                <div class="table-container">
                    <table class="data-table glow-table" style="table-layout: fixed; width: 100%;">
                        <colgroup>
                            <col style="width: 8%;">
                            <col style="width: 18%;">
                            <col style="width: 15%;">
                            <col style="width: 22%;">
                            <col style="width: 27%;">
                            <col style="width: 10%;">
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
                                PreparedStatement pst = null;
                                ResultSet rs = null;

                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gym_management", "root", "031204");

                                    String sql = "SELECT * FROM users WHERE id = ?";
                                    pst = conn.prepareStatement(sql);
                                    pst.setInt(1, loggedInUserId);
                                    rs = pst.executeQuery();

                                    if(rs.next()) {
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
                                        <a href="edit_member.jsp?id=<%= userId %>" class="btn-edit" title="Edit Profile">✏️</a>
                                        <button onclick="confirmDelete(<%= userId %>, '<%= name %>')" class="btn-delete" title="Delete Account">🗑️</button>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                    rs.close();
                                    pst.close();
                                } catch(Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="records-section">
                <h2>📅 My Membership Plans</h2>
                <div class="table-container">
                    <table class="data-table glow-table" style="table-layout: fixed; width: 100%;">
                        <colgroup>
                            <col style="width: 25%;">
                            <col style="width: 25%;">
                            <col style="width: 25%;">
                            <col style="width: 25%;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>Plan Type</th>
                                <th>Start Date</th>
                                <th>End Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    String sql = "SELECT * FROM membership WHERE user_id = ? ORDER BY start_date DESC";
                                    pst = conn.prepareStatement(sql);
                                    pst.setInt(1, loggedInUserId);
                                    rs = pst.executeQuery();

                                    boolean hasMembership = false;
                                    while(rs.next()) {
                                        hasMembership = true;
                            %>
                            <tr>
                                <td><%= rs.getString("plan") %></td>
                                <td><%= rs.getString("start_date") %></td>
                                <td><%= rs.getString("end_date") %></td>
                                <td><span class="status-badge <%= rs.getString("status").toLowerCase() %>"><%= rs.getString("status") %></span></td>
                            </tr>
                            <%
                                    }

                                    if(!hasMembership) {
                            %>
                            <tr>
                                <td colspan="4" style="text-align: center; padding: 30px; opacity: 0.6;">
                                    You don't have any membership plan yet. Contact admin to enroll!
                                </td>
                            </tr>
                            <%
                                    }
                                } catch(Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if(rs != null) rs.close();
                                    if(pst != null) pst.close();
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