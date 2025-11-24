<!-- admin_manage_membership.jsp -->
<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if admin is logged in
    if(session.getAttribute("admin_id") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String adminName = (String) session.getAttribute("admin_name");
    String message = "";
    String messageType = "";

    // Handle form submission
    if(request.getMethod().equals("POST")) {
        String action = request.getParameter("action");

        if("add".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("user_id"));
            String plan = request.getParameter("plan");
            String startDate = request.getParameter("start_date");
            String endDate = request.getParameter("end_date");
            String status = request.getParameter("status");

            Connection conn = null;
            PreparedStatement pst = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gym_management", "root", "031204");

                String sql = "INSERT INTO membership (user_id, plan, start_date, end_date, status) VALUES (?, ?, ?, ?, ?)";
                pst = conn.prepareStatement(sql);
                pst.setInt(1, userId);
                pst.setString(2, plan);
                pst.setString(3, startDate);
                pst.setString(4, endDate);
                pst.setString(5, status);

                int result = pst.executeUpdate();

                if(result > 0) {
                    message = "Membership plan assigned successfully!";
                    messageType = "success";
                } else {
                    message = "Failed to assign membership.";
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
        } else if("delete".equals(action)) {
            int membershipId = Integer.parseInt(request.getParameter("membership_id"));

            Connection conn = null;
            PreparedStatement pst = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gym_management", "root", "031204");

                String sql = "DELETE FROM membership WHERE membership_id = ?";
                pst = conn.prepareStatement(sql);
                pst.setInt(1, membershipId);

                int result = pst.executeUpdate();

                if(result > 0) {
                    message = "Membership plan deleted successfully!";
                    messageType = "success";
                }

            } catch(Exception e) {
                message = "Error: " + e.getMessage();
                messageType = "error";
            } finally {
                if(pst != null) pst.close();
                if(conn != null) conn.close();
            }
        }
    }

    LocalDate today = LocalDate.now();
    String todayDate = today.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Memberships - Admin Panel</title>
    <link rel="stylesheet" href="assets/style.css">
    <script>
        function confirmDelete(membershipId, userName, plan) {
            if(confirm('Are you sure you want to delete ' + plan + ' membership for ' + userName + '?')) {
                document.getElementById('delete_membership_id').value = membershipId;
                document.getElementById('deleteForm').submit();
            }
        }

        function calculateEndDate() {
            const startDate = document.getElementById('start_date').value;
            const plan = document.getElementById('plan').value;

            if(startDate && plan) {
                const start = new Date(startDate);
                let end = new Date(start);

                if(plan === 'Monthly') {
                    end.setMonth(end.getMonth() + 1);
                } else if(plan === 'Quarterly') {
                    end.setMonth(end.getMonth() + 3);
                } else if(plan === 'Half-Yearly') {
                    end.setMonth(end.getMonth() + 6);
                } else if(plan === 'Yearly') {
                    end.setFullYear(end.getFullYear() + 1);
                }

                document.getElementById('end_date').value = end.toISOString().split('T')[0];
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
                <a href="admin_manage_users.jsp" class="nav-item">👥 Manage Users</a>
                <a href="admin_manage_membership.jsp" class="nav-item active">📅 Manage Memberships</a>
                <a href="admin_view_attendance.jsp" class="nav-item">✅ View Attendance</a>
                <a href="logout.jsp" class="nav-item">🚪 Logout</a>
            </nav>
        </aside>

        <main class="main-content">
            <header class="top-bar">
                <h1>Manage Membership Plans</h1>
                <div class="user-info">
                    <span>👤 Admin: <%= adminName %></span>
                </div>
            </header>

            <% if(!message.equals("")) { %>
                <div class="alert <%= messageType %>">
                    <%= message %>
                </div>
            <% } %>

            <div class="dashboard-section">
                <h2>📝 Assign New Membership Plan</h2>
                <form method="POST" action="admin_manage_membership.jsp" class="attendance-form">
                    <input type="hidden" name="action" value="add">

                    <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px;">
                        <div class="form-group">
                            <label for="user_id">Select Member</label>
                            <select id="user_id" name="user_id" required style="width: 100%; padding: 14px 18px; background: rgba(31, 41, 55, 0.6); border: 1.5px solid rgba(156, 163, 175, 0.2); border-radius: 12px; color: #ffffff; font-size: 15px;">
                                <option value="">-- Select Member --</option>
                                <%
                                    Connection conn = null;
                                    Statement stmt = null;
                                    ResultSet rs = null;

                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gym_management", "root", "031204");
                                        stmt = conn.createStatement();
                                        rs = stmt.executeQuery("SELECT id, name, email FROM users ORDER BY name");

                                        while(rs.next()) {
                                %>
                                <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %> (<%= rs.getString("email") %>)</option>
                                <%
                                        }
                                    } catch(Exception e) {
                                        e.printStackTrace();
                                    }
                                %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="plan">Membership Plan</label>
                            <select id="plan" name="plan" onchange="calculateEndDate()" required style="width: 100%; padding: 14px 18px; background: rgba(31, 41, 55, 0.6); border: 1.5px solid rgba(156, 163, 175, 0.2); border-radius: 12px; color: #ffffff; font-size: 15px;">
                                <option value="">-- Select Plan --</option>
                                <option value="Monthly">Monthly (1 Month)</option>
                                <option value="Quarterly">Quarterly (3 Months)</option>
                                <option value="Half-Yearly">Half-Yearly (6 Months)</option>
                                <option value="Yearly">Yearly (12 Months)</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="start_date">Start Date</label>
                            <input type="date" id="start_date" name="start_date" value="<%= todayDate %>" onchange="calculateEndDate()" required>
                        </div>

                        <div class="form-group">
                            <label for="end_date">End Date</label>
                            <input type="date" id="end_date" name="end_date" required>
                        </div>

                        <div class="form-group">
                            <label for="status">Status</label>
                            <select id="status" name="status" required style="width: 100%; padding: 14px 18px; background: rgba(31, 41, 55, 0.6); border: 1.5px solid rgba(156, 163, 175, 0.2); border-radius: 12px; color: #ffffff; font-size: 15px;">
                                <option value="Active">Active</option>
                                <option value="Inactive">Inactive</option>
                            </select>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary" style="margin-top: 20px;">Assign Membership Plan</button>
                </form>
            </div>

            <div class="dashboard-section">
                <h2>All Membership Plans</h2>
                <div class="table-container">
                    <table class="data-table glow-table" style="table-layout: fixed; width: 100%;">
                        <colgroup>
                            <col style="width: 8%;">
                            <col style="width: 8%;">
                            <col style="width: 20%;">
                            <col style="width: 18%;">
                            <col style="width: 14%;">
                            <col style="width: 14%;">
                            <col style="width: 10%;">
                            <col style="width: 8%;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>M-ID</th>
                                <th>U-ID</th>
                                <th>Member Name</th>
                                <th>Plan Type</th>
                                <th>Start Date</th>
                                <th>End Date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    PreparedStatement pst = conn.prepareStatement(
                                        "SELECT m.*, u.name FROM membership m " +
                                        "JOIN users u ON m.user_id = u.id " +
                                        "ORDER BY m.start_date DESC"
                                    );
                                    ResultSet membershipRs = pst.executeQuery();
                                    boolean hasMemberships = false;

                                    while(membershipRs.next()) {
                                        hasMemberships = true;
                                        int membershipId = membershipRs.getInt("membership_id");
                                        String userName = membershipRs.getString("name");
                                        String plan = membershipRs.getString("plan");
                            %>
                            <tr>
                                <td><%= membershipId %></td>
                                <td><%= membershipRs.getInt("user_id") %></td>
                                <td><%= userName %></td>
                                <td><%= plan %></td>
                                <td><%= membershipRs.getString("start_date") %></td>
                                <td><%= membershipRs.getString("end_date") %></td>
                                <td><span class="status-badge <%= membershipRs.getString("status").toLowerCase() %>"><%= membershipRs.getString("status") %></span></td>
                                <td>
                                    <button onclick="confirmDelete(<%= membershipId %>, '<%= userName %>', '<%= plan %>')" class="btn-delete" title="Delete Plan">🗑️</button>
                                </td>
                            </tr>
                            <%
                                    }

                                    if(!hasMemberships) {
                            %>
                            <tr>
                                <td colspan="8" style="text-align: center; padding: 30px; opacity: 0.6;">
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

            <!-- Hidden delete form -->
            <form id="deleteForm" method="POST" action="admin_manage_membership.jsp" style="display: none;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" id="delete_membership_id" name="membership_id">
            </form>
        </main>
    </div>
</body>
</html>
<%
    if(rs != null) rs.close();
    if(stmt != null) stmt.close();
    if(conn != null) conn.close();
%>