<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Notifications - Hospital Management System</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            .sidebar {
                background-color: #343a40;
                min-height: 100vh;
                padding: 20px 0;
            }
            .sidebar a {
                color: #ffffff;
                padding: 10px 20px;
                display: block;
                text-decoration: none;
            }
            .sidebar a:hover {
                background-color: #495057;
            }
            .sidebar a.active {
                background-color: #28a745;
            }
            .sidebar i {
                margin-right: 10px;
            }
            .main-content {
                padding: 20px;
            }
            .notification-card {
                margin-bottom: 15px;
                border-left: 4px solid #007bff;
            }
            .notification-card.unread {
                background-color: #f8f9fa;
                border-left-color: #28a745;
            }
            .notification-time {
                color: #6c757d;
                font-size: 0.85rem;
            }
        </style>
    </head>
    <body>
        <%
            // Check if doctor is logged in
            String doctorId = session.getAttribute("doctorId") != null ? 
                session.getAttribute("doctorId").toString() : null;
            String doctorName = (String) session.getAttribute("doctorName");
            String specialization = (String) session.getAttribute("specialization");
            
            if (doctorId == null) {
                response.sendRedirect("doctorLogin.jsp");
                return;
            }
        %>
        
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-2 sidebar">
                    <div class="text-center mb-4">
                        <i class="fas fa-user-md fa-3x text-white"></i>
                        <h6 class="text-white mt-2"><%= doctorName %></h6>
                        <small class="text-muted"><%= specialization %></small>
                    </div>
                    <a href="doctorDashboard.jsp">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                    <a href="doctorViewAppointments.jsp">
                        <i class="fas fa-calendar-check"></i> Appointments
                    </a>
                    <a href="viewPatients.jsp">
                        <i class="fas fa-users"></i> Patients
                    </a>
                    <a href="prescriptions.jsp">
                        <i class="fas fa-prescription"></i> Prescriptions
                    </a>
                    <a href="notifications.jsp" class="active">
                        <i class="fas fa-bell"></i> Notifications
                    </a>
                    <a href="doctorProfile.jsp">
                        <i class="fas fa-user-circle"></i> Profile
                    </a>
                    <a href="${pageContext.request.contextPath}/LogoutServlet">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
                
                <!-- Main Content -->
                <div class="col-md-10 main-content">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>Notifications</h2>
                        <form action="MarkAllReadServlet" method="POST" class="m-0">
                            <input type="hidden" name="doctorId" value="<%= doctorId %>">
                            <button type="submit" class="btn btn-secondary">
                                <i class="fas fa-check-double"></i> Mark All as Read
                            </button>
                        </form>
                    </div>
                    
                    <div class="notifications-list">
                        <%
                            try {
                                Connection con = DatabaseConnection.initializeDatabase();
                                String query = "SELECT * FROM notifications WHERE user_id = ? AND user_type = 'doctor' " +
                                             "ORDER BY created_at DESC";
                                PreparedStatement pst = con.prepareStatement(query);
                                pst.setString(1, doctorId);
                                ResultSet rs = pst.executeQuery();
                                
                                boolean hasNotifications = false;
                                while(rs.next()) {
                                    hasNotifications = true;
                                    String unreadClass = rs.getBoolean("is_read") ? "" : "unread";
                        %>
                        <div class="card notification-card <%= unreadClass %>">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <p class="mb-1"><%= rs.getString("message") %></p>
                                        <small class="notification-time">
                                            <%= rs.getTimestamp("created_at") %>
                                        </small>
                                    </div>
                                    <% if (!rs.getBoolean("is_read")) { %>
                                    <form action="MarkNotificationReadServlet" method="POST" class="ml-3">
                                        <input type="hidden" name="notificationId" value="<%= rs.getInt("id") %>">
                                        <button type="submit" class="btn btn-sm btn-outline-success">
                                            <i class="fas fa-check"></i> Mark as Read
                                        </button>
                                    </form>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        <%
                                }
                                if (!hasNotifications) {
                        %>
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i> No notifications found.
                        </div>
                        <%
                                }
                                rs.close();
                                pst.close();
                                con.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
