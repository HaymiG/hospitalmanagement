<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<%
    // Check if admin is logged in
    String adminUsername = (String) session.getAttribute("adminUsername");
    String isAdminLoggedIn = (String) session.getAttribute("isAdminLoggedIn");
    
    if (adminUsername == null || !"true".equals(isAdminLoggedIn)) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard - Hospital Management System</title>
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
                background-color: #dc3545;
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
        </style>
    </head>
    <body>
        <%
            // Get statistics
            int totalDoctors = 0;
            int totalPatients = 0;
            int todayAppointments = 0;
            int pendingAppointments = 0;
            
            try {
                Connection con = DatabaseConnection.initializeDatabase();
                
                // Get total doctors
                String query = "SELECT COUNT(*) as count FROM doctor WHERE status = 'active'";
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(query);
                if (rs.next()) {
                    totalDoctors = rs.getInt("count");
                }
                
                // Get total patients
                query = "SELECT COUNT(*) as count FROM patient WHERE status = 'active'";
                rs = stmt.executeQuery(query);
                if (rs.next()) {
                    totalPatients = rs.getInt("count");
                }
                
                // Get today's appointments
                query = "SELECT COUNT(*) as count FROM appointments WHERE appointment_date = CURDATE()";
                rs = stmt.executeQuery(query);
                if (rs.next()) {
                    todayAppointments = rs.getInt("count");
                }
                
                // Get pending appointments
                query = "SELECT COUNT(*) as count FROM appointments WHERE status = 'pending'";
                rs = stmt.executeQuery(query);
                if (rs.next()) {
                    pendingAppointments = rs.getInt("count");
                }
                
                rs.close();
                stmt.close();
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
                        <img src="images/admin-avatar.png" alt="Admin Avatar" class="rounded-circle" width="100">
                        <h6 class="text-white mt-2">Administrator</h6>
                    </div>
                    <a href="adminDashboard.jsp" class="active">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                    <a href="manageDoctors.jsp">
                        <i class="fas fa-user-md"></i> Manage Doctors
                    </a>
                    <a href="managePatients.jsp">
                        <i class="fas fa-users"></i> Manage Patients
                    </a>
                    <a href="manageAppointments.jsp">
                        <i class="fas fa-calendar-check"></i> Appointments
                        <% if (pendingAppointments > 0) { %>
                            <span class="badge badge-warning"><%= pendingAppointments %></span>
                        <% } %>
                    </a>
                    <a href="reports.jsp">
                        <i class="fas fa-chart-bar"></i> Reports
                    </a>
                    <a href="settings.jsp">
                        <i class="fas fa-cog"></i> Settings
                    </a>
                    <a href="logout.jsp">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>

                <!-- Main content -->
                <div class="col-md-10 main-content">
                    <h2 class="mb-4">Admin Dashboard</h2>
                    
                    <div class="row">
                        <!-- Total Doctors -->
                        <div class="col-md-6 col-lg-3">
                            <div class="card bg-primary text-white">
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <i class="fas fa-user-md"></i>
                                        Total Doctors
                                    </h5>
                                    <h2 class="mb-0"><%= totalDoctors %></h2>
                                    <a href="manageDoctors.jsp" class="text-white">Manage Doctors →</a>
                                </div>
                            </div>
                        </div>

                        <!-- Total Patients -->
                        <div class="col-md-6 col-lg-3">
                            <div class="card bg-success text-white">
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <i class="fas fa-users"></i>
                                        Total Patients
                                    </h5>
                                    <h2 class="mb-0"><%= totalPatients %></h2>
                                    <a href="managePatients.jsp" class="text-white">View Details →</a>
                                </div>
                            </div>
                        </div>

                        <!-- Today's Appointments -->
                        <div class="col-md-6 col-lg-3">
                            <div class="card bg-info text-white">
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <i class="fas fa-calendar-day"></i>
                                        Today's Appointments
                                    </h5>
                                    <h2 class="mb-0"><%= todayAppointments %></h2>
                                    <a href="manageAppointments.jsp" class="text-white">View Schedule →</a>
                                </div>
                            </div>
                        </div>

                        <!-- Pending Appointments -->
                        <div class="col-md-6 col-lg-3">
                            <div class="card bg-warning text-white">
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <i class="fas fa-clock"></i>
                                        Pending Appointments
                                    </h5>
                                    <h2 class="mb-0"><%= pendingAppointments %></h2>
                                    <a href="manageAppointments.jsp?status=pending" class="text-white">Take Action →</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Activities -->
                    <div class="card mt-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Recent Activities</h5>
                            <div class="btn-group">
                                <button type="button" class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-user-md"></i> Add Doctor
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-success">
                                    <i class="fas fa-download"></i> Download Report
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Activity</th>
                                            <th>User</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            try {
                                                Connection con = DatabaseConnection.initializeDatabase();
                                                String query = "SELECT a.appointment_date, a.status, " +
                                                             "p.fname as patient_fname, p.lname as patient_lname, " +
                                                             "d.fname as doctor_fname, d.lname as doctor_lname " +
                                                             "FROM appointments a " +
                                                             "JOIN patient p ON a.patient_id = p.id " +
                                                             "JOIN doctor d ON a.doctor_id = d.id " +
                                                             "ORDER BY a.created_at DESC LIMIT 5";
                                                
                                                Statement stmt = con.createStatement();
                                                ResultSet rs = stmt.executeQuery(query);
                                                
                                                while(rs.next()) {
                                                    String patientName = rs.getString("patient_fname") + " " + rs.getString("patient_lname");
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
                                            <td>Appointment: <%= patientName %> with <%= doctorName %></td>
                                            <td><%= patientName %></td>
                                            <td><span class="badge badge-<%= statusClass %>"><%= status %></span></td>
                                        </tr>
                                        <%
                                                }
                                                rs.close();
                                                stmt.close();
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
