<!-- admin_view_attendance.jsp -->
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
    <title>View Attendance - Admin Panel</title>
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
                <a href="admin_manage_users.jsp" class="nav-item">👥 Manage Users</a>
                <a href="admin_manage_membership.jsp" class="nav-item">📅 Manage Memberships</a>
                <a href="admin_view_attendance.jsp" class="nav-item active">✅ View Attendance</a>
                <a href="logout.jsp" class="nav-item">🚪 Logout</a>
            </nav>
        </aside>

        <main class="main-content">
            <header class="top-bar">
                <h1>All Attendance Records</h1>
                <div class="user-info">
                    <span>👤 Admin: <%= adminName %></span>
                </div>
            </header>

            <div class="dashboard-section">
                <h2>Complete Attendance History</h2>
                <div class="table-container">
                    <table class="data-table glow-table" style="table-layout: fixed; width: 100%;">
                        <colgroup>
                            <col style="width: 10%;">
                            <col style="width: 10%;">
                            <col style="width: 30%;">
                            <col style="width: 25%;">
                            <col style="width: 25%;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>Att-ID</th>
                                <th>User-ID</th>
                                <th>Member Name</th>
                                <th>Date</th>
                                <th>Check-In Time</th>
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

                                    String sql = "SELECT a.*, u.name FROM attendance a " +
                                                 "JOIN users u ON a.user_id = u.id " +
                                                 "ORDER BY a.date ASC, a.checkin_time ASC";
                                    pst = conn.prepareStatement(sql);
                                    rs = pst.executeQuery();

                                    boolean hasRecords = false;

                                    while(rs.next()) {
                                        hasRecords = true;
                            %>
                            <tr>
                                <td><%= rs.getInt("att_id") %></td>
                                <td><%= rs.getInt("user_id") %></td>
                                <td><%= rs.getString("name") %></td>
                                <td><%= rs.getString("date") %></td>
                                <td><%= rs.getString("checkin_time") %></td>
                            </tr>
                            <%
                                    }

                                    if(!hasRecords) {
                            %>
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 30px; opacity: 0.6;">
                                    No attendance records found.
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

            <div class="dashboard-section">
                <h2>📊 Today's Attendance Summary</h2>
                <div class="table-container">
                    <table class="data-table" style="table-layout: fixed; width: 100%;">
                        <colgroup>
                            <col style="width: 15%;">
                            <col style="width: 35%;">
                            <col style="width: 25%;">
                            <col style="width: 25%;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>User-ID</th>
                                <th>Member Name</th>
                                <th>Date</th>
                                <th>Check-In Time</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gym_management", "root", "031204");

                                    String sql = "SELECT a.*, u.name FROM attendance a " +
                                                 "JOIN users u ON a.user_id = u.id " +
                                                 "WHERE a.date = CURDATE() " +
                                                 "ORDER BY a.checkin_time ASC";
                                    pst = conn.prepareStatement(sql);
                                    rs = pst.executeQuery();

                                    boolean hasTodayRecords = false;

                                    while(rs.next()) {
                                        hasTodayRecords = true;
                            %>
                            <tr>
                                <td><%= rs.getInt("user_id") %></td>
                                <td><%= rs.getString("name") %></td>
                                <td><%= rs.getString("date") %></td>
                                <td><%= rs.getString("checkin_time") %></td>
                            </tr>
                            <%
                                    }

                                    if(!hasTodayRecords) {
                            %>
                            <tr>
                                <td colspan="4" style="text-align: center; padding: 30px; opacity: 0.6;">
                                    No attendance marked today.
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