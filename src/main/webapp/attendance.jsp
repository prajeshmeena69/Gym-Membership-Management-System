<!-- attendance.jsp -->
<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("user_name");
    int loggedInUserId = (int) session.getAttribute("user_id");
    String message = "";
    String messageType = "";

    LocalDate currentDate = LocalDate.now();
    LocalTime currentTime = LocalTime.now();
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");
    String todayDate = currentDate.format(dateFormatter);
    String todayTime = currentTime.format(timeFormatter);

    if(request.getMethod().equals("POST")) {
        String date = request.getParameter("date");
        String checkinTime = request.getParameter("checkin_time");

        Connection conn = null;
        PreparedStatement pst = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gym_management", "root", "031204");

            String sql = "INSERT INTO attendance (user_id, date, checkin_time) VALUES (?, ?, ?)";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, loggedInUserId);
            pst.setString(2, date);
            pst.setString(3, checkinTime);

            int result = pst.executeUpdate();

            if(result > 0) {
                message = "Your Attendance Marked Successfully!";
                messageType = "success";
            } else {
                message = "Failed to mark attendance.";
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
    <title>Mark Attendance - Gym Management</title>
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>💪 GYM SYSTEM</h2>
            </div>
            <nav class="sidebar-nav">
                <a href="dashboard.jsp" class="nav-item">📊 Dashboard</a>
                <a href="attendance.jsp" class="nav-item active">✅ Mark Attendance</a>
                <a href="view_records.jsp" class="nav-item">📋 View Records</a>
                <a href="logout.jsp" class="nav-item">🚪 Logout</a>
            </nav>
        </aside>

        <main class="main-content">
            <header class="top-bar">
                <h1>My Attendance</h1>
                <div class="user-info">
                    <span>Welcome, <%= userName %></span>
                </div>
            </header>

            <div class="attendance-container">
                <div class="attendance-box">
                    <h2>✅ Mark Your Attendance</h2>

                    <% if(!message.equals("")) { %>
                        <div class="alert <%= messageType %>">
                            <%= message %>
                        </div>
                    <% } %>

                    <form method="POST" action="attendance.jsp" class="attendance-form">
                        <div class="form-group">
                            <label for="date">Date</label>
                            <input type="date" id="date" name="date" value="<%= todayDate %>" required>
                        </div>

                        <div class="form-group">
                            <label for="checkin_time">Check-In Time</label>
                            <input type="text" id="checkin_time" name="checkin_time" value="<%= todayTime %>" required>
                        </div>

                        <button type="submit" class="btn-primary">Mark My Attendance</button>
                    </form>
                </div>

                <div class="attendance-list">
                    <h2>My Attendance History</h2>
                    <div class="table-container">
                        <table class="data-table" style="table-layout: fixed; width: 100%;">
                            <colgroup>
                                <col style="width: 20%;">
                                <col style="width: 40%;">
                                <col style="width: 40%;">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>Record</th>
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

                                        String sql = "SELECT * FROM attendance WHERE user_id = ? ORDER BY date DESC, checkin_time DESC";
                                        pst = conn.prepareStatement(sql);
                                        pst.setInt(1, loggedInUserId);
                                        rs = pst.executeQuery();

                                        int recordNumber = 1;
                                        while(rs.next()) {
                                %>
                                <tr>
                                    <td><%= recordNumber++ %></td>
                                    <td><%= rs.getString("date") %></td>
                                    <td><%= rs.getString("checkin_time") %></td>
                                </tr>
                                <%
                                        }

                                        if(recordNumber == 1) {
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
            </div>
        </main>
    </div>
</body>
</html>