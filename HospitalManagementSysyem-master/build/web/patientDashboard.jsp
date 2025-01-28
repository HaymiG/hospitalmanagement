<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Patient Dashboard - Hospital Management System</title>
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
                background-color: #007bff;
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
        </style>
    </head>
    <body>
        <%
            // Check if patient is logged in
            String patientId = session.getAttribute("patientId") != null ? 
                session.getAttribute("patientId").toString() : null;
            
            if (patientId == null) {
                response.sendRedirect("patientLogin.jsp");
                return;
            }
            
            // Get patient information
            String patientName = "";
            int unreadNotifications = 0;
            int upcomingAppointments = 0;
            int activePrescriptions = 0;
            
            try {
                Connection con = DatabaseConnection.initializeDatabase();
                
                // Get patient name
                String query = "SELECT fname, lname FROM patient WHERE id = ?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, patientId);
                ResultSet rs = pst.executeQuery();
                if (rs.next()) {
                    patientName = rs.getString("fname") + " " + rs.getString("lname");
                }
                
                // Get unread notifications count
                query = "SELECT COUNT(*) as count FROM notifications WHERE user_id = ? AND user_type = 'patient' AND is_read = 0";
                pst = con.prepareStatement(query);
                pst.setString(1, patientId);
                rs = pst.executeQuery();
                if (rs.next()) {
                    unreadNotifications = rs.getInt("count");
                }
                
                // Get upcoming appointments count
                query = "SELECT COUNT(*) as count FROM appointments WHERE patient_id = ? AND appointment_date >= CURDATE() AND status = 'scheduled'";
                pst = con.prepareStatement(query);
                pst.setString(1, patientId);
                rs = pst.executeQuery();
                if (rs.next()) {
                    upcomingAppointments = rs.getInt("count");
                }
                
                // Get active prescriptions count
                query = "SELECT COUNT(*) as count FROM prescriptions WHERE patient_id = ? AND status = 'active' AND end_date >= CURDATE()";
                pst = con.prepareStatement(query);
                pst.setString(1, patientId);
                rs = pst.executeQuery();
                if (rs.next()) {
                    activePrescriptions = rs.getInt("count");
                }
                
                rs.close();
                pst.close();
                con.close();
                
            } catch(Exception e) {
                out.println("Error: " + e.getMessage());
            }
        %>
        
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-2 sidebar">
                    <div class="text-center mb-4">
                        <img src="images/patient-avatar.png" alt="Patient Avatar" class="rounded-circle" width="100">
                        <h6 class="text-white mt-2"><%= patientName %></h6>
                    </div>
                    <a href="patientDashboard.jsp" class="active">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                    <a href="bookAppointment.jsp">
                        <i class="fas fa-calendar-plus"></i> Book Appointment
                    </a>
                    <a href="viewAppointments.jsp">
                        <i class="fas fa-calendar-check"></i> My Appointments
                        <% if (upcomingAppointments > 0) { %>
                            <span class="badge badge-primary"><%= upcomingAppointments %></span>
                        <% } %>
                    </a>
                    <a href="viewMedicalRecords.jsp">
                        <i class="fas fa-file-medical"></i> Medical Records
                    </a>
                    <a href="viewPrescriptions.jsp">
                        <i class="fas fa-prescription"></i> Prescriptions
                        <% if (activePrescriptions > 0) { %>
                            <span class="badge badge-primary"><%= activePrescriptions %></span>
                        <% } %>
                    </a>
                    <a href="patientNotifications.jsp">
                        <i class="fas fa-bell"></i> Notifications
                        <% if (unreadNotifications > 0) { %>
                            <span class="badge badge-danger"><%= unreadNotifications %></span>
                        <% } %>
                    </a>
                    <a href="patientProfile.jsp">
                        <i class="fas fa-user"></i> My Profile
                    </a>
                    <a href="logout.jsp">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>

                <!-- Main content -->
                <div class="col-md-10 main-content">
                    <h2 class="mb-4">Welcome, <%= patientName %></h2>
                    
                    <div class="row">
                        <!-- Upcoming Appointments -->
                        <div class="col-md-6 col-lg-3">
                            <div class="card bg-primary text-white">
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <i class="fas fa-calendar-check"></i>
                                        Upcoming Appointments
                                    </h5>
                                    <h2 class="mb-0"><%= upcomingAppointments %></h2>
                                    <a href="viewAppointments.jsp" class="text-white">View Details →</a>
                                </div>
                            </div>
                        </div>

                        <!-- Active Prescriptions -->
                        <div class="col-md-6 col-lg-3">
                            <div class="card bg-success text-white">
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <i class="fas fa-prescription"></i>
                                        Active Prescriptions
                                    </h5>
                                    <h2 class="mb-0"><%= activePrescriptions %></h2>
                                    <a href="viewPrescriptions.jsp" class="text-white">View Details →</a>
                                </div>
                            </div>
                        </div>

                        <!-- Notifications -->
                        <div class="col-md-6 col-lg-3">
                            <div class="card bg-warning text-white">
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <i class="fas fa-bell"></i>
                                        New Notifications
                                    </h5>
                                    <h2 class="mb-0"><%= unreadNotifications %></h2>
                                    <a href="patientNotifications.jsp" class="text-white">View Details →</a>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="col-md-6 col-lg-3">
                            <div class="card bg-info text-white">
                                <div class="card-body">
                                    <h5 class="card-title">Quick Actions</h5>
                                    <a href="bookAppointment.jsp" class="btn btn-light btn-sm mb-2 w-100">Book Appointment</a>
                                    <a href="viewMedicalRecords.jsp" class="btn btn-light btn-sm w-100">View Records</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Appointments -->
                    <div class="card mt-4">
                        <div class="card-header">
                            <h5 class="mb-0">Recent Appointments</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Time</th>
                                            <th>Doctor</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            try {
                                                Connection con = DatabaseConnection.initializeDatabase();
                                                String query = "SELECT a.*, d.fname as doctor_fname, d.lname as doctor_lname " +
                                                             "FROM appointments a " +
                                                             "JOIN doctor d ON a.doctor_id = d.id " +
                                                             "WHERE a.patient_id = ? " +
                                                             "ORDER BY a.appointment_date DESC, a.appointment_time DESC " +
                                                             "LIMIT 5";
                                                
                                                PreparedStatement pst = con.prepareStatement(query);
                                                pst.setString(1, patientId);
                                                ResultSet rs = pst.executeQuery();
                                                
                                                while(rs.next()) {
                                                    String doctorName = "Dr. " + rs.getString("doctor_fname") + " " + rs.getString("doctor_lname");
                                                    String status = rs.getString("status");
                                                    String statusClass = "";
                                                    switch(status) {
                                                        case "confirmed": statusClass = "success"; break;
                                                        case "pending": statusClass = "warning"; break;
                                                        case "cancelled": statusClass = "danger"; break;
                                                        default: statusClass = "secondary";
                                                    }
                                        %>
                                        <tr>
                                            <td><%= rs.getDate("appointment_date") %></td>
                                            <td><%= rs.getTime("appointment_time") %></td>
                                            <td><%= doctorName %></td>
                                            <td><span class="badge badge-<%= statusClass %>"><%= status %></span></td>
                                            <td>
                                                <a href="viewAppointmentDetails.jsp?id=<%= rs.getInt("id") %>" class="btn btn-sm btn-primary">
                                                    View Details
                                                </a>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                                rs.close();
                                                pst.close();
                                                con.close();
                                            } catch(Exception e) {
                                                out.println("Error: " + e.getMessage());
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
