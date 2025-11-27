<!-- dashboard.jsp -->
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in
    if(session.getAttribute("user_id") == null || !"user".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("user_name");
    int loggedInUserId = (int) session.getAttribute("user_id");

    // User-specific statistics
    int myAttendanceCount = 0;
    int myActivePlans = 0;
    String memberSince = "";

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gym_management", "root", "031204");

        // Get my total attendance count
        pst = conn.prepareStatement("SELECT COUNT(*) as total FROM attendance WHERE user_id = ?");
        pst.setInt(1, loggedInUserId);
        rs = pst.executeQuery();
        if(rs.next()) myAttendanceCount = rs.getInt("total");
        rs.close();
        pst.close();

        // Get my active plans count
        pst = conn.prepareStatement("SELECT COUNT(*) as total FROM membership WHERE user_id = ? AND status = 'Active'");
        pst.setInt(1, loggedInUserId);
        rs = pst.executeQuery();
        if(rs.next()) myActivePlans = rs.getInt("total");
        rs.close();
        pst.close();

        // Get member since date
        pst = conn.prepareStatement("SELECT MIN(date) as first_date FROM attendance WHERE user_id = ?");
        pst.setInt(1, loggedInUserId);
        rs = pst.executeQuery();
        if(rs.next() && rs.getString("first_date") != null) {
            memberSince = rs.getString("first_date");
        }

    } catch(Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Dashboard - Gym Management</title>
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>💪 GYM SYSTEM</h2>
            </div>
            <nav class="sidebar-nav">
                <a href="dashboard.jsp" class="nav-item active">📊 My Dashboard</a>
                <a href="attendance.jsp" class="nav-item">✅ Mark Attendance</a>
                <a href="view_records.jsp" class="nav-item">📋 My Profile</a>
                <a href="logout.jsp" class="nav-item">🚪 Logout</a>
            </nav>
        </aside>

        <main class="main-content">
            <header class="top-bar">
                <h1>My Dashboard</h1>
                <div class="user-info">
                    <span>Welcome, <%= userName %></span>
                </div>
            </header>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">✅</div>
                    <div class="stat-details">
                        <h3><%= myAttendanceCount %></h3>
                        <p>My Total Attendance</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">📅</div>
                    <div class="stat-details">
                        <h3><%= myActivePlans %></h3>
                        <p>Active Membership Plans</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">📆</div>
                    <div class="stat-details">
                        <h3><%= memberSince.isEmpty() ? "New" : memberSince %></h3>
                        <p>Member Since</p>
                    </div>
                </div>
            </div>

            <div class="dashboard-section">
                <h2>My Recent Attendance</h2>
                <div class="table-container">
                    <table class="data-table" style="table-layout: fixed; width: 100%;">
                        <colgroup>
                            <col style="width: 15%;">
                            <col style="width: 40%;">
                            <col style="width: 45%;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Date</th>
                                <th>Check-In Time</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    pst = conn.prepareStatement("SELECT * FROM attendance WHERE user_id = ? ORDER BY date DESC, checkin_time DESC LIMIT 5");
                                    pst.setInt(1, loggedInUserId);
                                    rs = pst.executeQuery();

                                    int count = 1;
                                    boolean hasRecords = false;

                                    while(rs.next()) {
                                        hasRecords = true;
                            %>
                            <tr>
                                <td><%= count++ %></td>
                                <td><%= rs.getString("date") %></td>
                                <td><%= rs.getString("checkin_time") %></td>
                            </tr>
                            <%
                                    }

                                    if(!hasRecords) {
                            %>
                            <tr>
                                <td colspan="3" style="text-align: center; padding: 30px; opacity: 0.6;">
                                    No attendance records yet. Mark your first attendance!
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
                <h2>My Active Membership Plans</h2>
                <div class="table-container">
                    <table class="data-table" style="table-layout: fixed; width: 100%;">
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
                                    pst = conn.prepareStatement("SELECT * FROM membership WHERE user_id = ? ORDER BY start_date DESC");
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
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="quick-actions">
                <h2>Quick Actions</h2>
                <div class="action-buttons">
                    <a href="attendance.jsp" class="action-btn">✅ Mark Attendance</a>
                    <a href="view_records.jsp" class="action-btn">📋 View My Profile</a>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
<%
    if(rs != null) rs.close();
    if(pst != null) pst.close();
    if(conn != null) conn.close();
%>