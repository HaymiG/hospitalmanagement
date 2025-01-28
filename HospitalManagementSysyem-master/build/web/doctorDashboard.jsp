<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Doctor Dashboard - Hospital Management System</title>
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
            .card {
                margin-bottom: 20px;
                border: none;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .card-header {
                background-color: #f8f9fa;
                border-bottom: none;
            }
            .notification-badge {
                position: absolute;
                top: -5px;
                right: -5px;
                padding: 3px 6px;
                border-radius: 50%;
                background: red;
                color: white;
            }
            .stats-card {
                background: linear-gradient(45deg, #28a745, #20c997);
                color: white;
                border-radius: 10px;
                padding: 20px;
            }
            .stats-card i {
                font-size: 2rem;
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <%
            // Check if doctor is logged in
            String doctorId = session.getAttribute("doctorId") != null ? 
                session.getAttribute("doctorId").toString() : null;
            
            if (doctorId == null) {
                response.sendRedirect("doctorLogin.jsp");
                return;
            }
            
            // Get doctor information
            String doctorName = "";
            String specialization = "";
            int todayAppointments = 0;
            int totalPatients = 0;
            int unreadNotifications = 0;
            
            try {
                Connection con = DatabaseConnection.initializeDatabase();
                
                // Get doctor details
                String query = "SELECT fname, lname, specialization FROM doctor WHERE id = ?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, doctorId);
                ResultSet rs = pst.executeQuery();
                if (rs.next()) {
                    doctorName = "Dr. " + rs.getString("fname") + " " + rs.getString("lname");
                    specialization = rs.getString("specialization");
                }
                
                // Get today's appointments count
                query = "SELECT COUNT(*) as count FROM appointments WHERE doctor_id = ? AND DATE(appointment_date) = CURDATE()";
                pst = con.prepareStatement(query);
                pst.setString(1, doctorId);
                rs = pst.executeQuery();
                if (rs.next()) {
                    todayAppointments = rs.getInt("count");
                }
                
                // Get total unique patients count
                query = "SELECT COUNT(DISTINCT patient_id) as count FROM appointments WHERE doctor_id = ?";
                pst = con.prepareStatement(query);
                pst.setString(1, doctorId);
                rs = pst.executeQuery();
                if (rs.next()) {
                    totalPatients = rs.getInt("count");
                }
                
                // Get unread notifications count
                query = "SELECT COUNT(*) as count FROM notifications WHERE doctor_id = ? AND is_read = 0";
                pst = con.prepareStatement(query);
                pst.setString(1, doctorId);
                rs = pst.executeQuery();
                if (rs.next()) {
                    unreadNotifications = rs.getInt("count");
                }
                
                rs.close();
                pst.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
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
                    <a href="doctorDashboard.jsp" class="active">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                    <a href="doctorViewAppointments.jsp">
                        <i class="fas fa-calendar-check"></i> Appointments
                        <% if (todayAppointments > 0) { %>
                            <span class="badge badge-pill badge-warning"><%= todayAppointments %></span>
                        <% } %>
                    </a>
                    <a href="viewPatients.jsp">
                        <i class="fas fa-users"></i> Patients
                    </a>
                    <a href="prescriptions.jsp">
                        <i class="fas fa-prescription"></i> Prescriptions
                    </a>
                    <a href="notifications.jsp">
                        <i class="fas fa-bell"></i> Notifications
                        <% if (unreadNotifications > 0) { %>
                            <span class="badge badge-pill badge-danger"><%= unreadNotifications %></span>
                        <% } %>
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
                        <h2>Welcome Back, <%= doctorName %></h2>
                        <div class="text-muted">
                            <i class="fas fa-calendar-alt"></i> 
                            <%= new java.text.SimpleDateFormat("EEEE, MMMM d, yyyy").format(new java.util.Date()) %>
                        </div>
                    </div>
                    
                    <!-- Statistics Cards -->
                    <div class="row">
                        <div class="col-md-4">
                            <div class="stats-card">
                                <i class="fas fa-calendar-check"></i>
                                <h3><%= todayAppointments %></h3>
                                <p class="mb-0">Today's Appointments</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stats-card">
                                <i class="fas fa-users"></i>
                                <h3><%= totalPatients %></h3>
                                <p class="mb-0">Total Patients</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stats-card">
                                <i class="fas fa-bell"></i>
                                <h3><%= unreadNotifications %></h3>
                                <p class="mb-0">Unread Notifications</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Recent Appointments -->
                    <div class="card mt-4">
                        <div class="card-header">
                            <h5 class="mb-0">Today's Appointments</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Time</th>
                                            <th>Patient Name</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            try {
                                                Connection con = DatabaseConnection.initializeDatabase();
                                                String query = "SELECT a.*, p.fname, p.lname FROM appointments a " +
                                                             "JOIN patient p ON a.patient_id = p.id " +
                                                             "WHERE a.doctor_id = ? AND DATE(a.appointment_date) = CURDATE() " +
                                                             "ORDER BY a.appointment_date ASC";
                                                PreparedStatement pst = con.prepareStatement(query);
                                                pst.setString(1, doctorId);
                                                ResultSet rs = pst.executeQuery();
                                                
                                                while(rs.next()) {
                                                    String appointmentTime = new java.text.SimpleDateFormat("hh:mm a").format(rs.getTimestamp("appointment_date"));
                                                    String patientName = rs.getString("fname") + " " + rs.getString("lname");
                                                    String status = rs.getString("status");
                                        %>
                                        <tr>
                                            <td><%= appointmentTime %></td>
                                            <td><%= patientName %></td>
                                            <td>
                                                <span class="badge badge-<%= status.equals("confirmed") ? "success" : 
                                                                           status.equals("pending") ? "warning" : 
                                                                           "secondary" %>">
                                                    <%= status %>
                                                </span>
                                            </td>
                                            <td>
                                                <a href="viewAppointment.jsp?id=<%= rs.getInt("id") %>" class="btn btn-sm btn-primary">
                                                    <i class="fas fa-eye"></i> View
                                                </a>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                                rs.close();
                                                pst.close();
                                                con.close();
                                            } catch (Exception e) {
                                                e.printStackTrace();
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
