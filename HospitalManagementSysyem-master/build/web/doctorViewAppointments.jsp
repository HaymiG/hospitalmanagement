<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Doctor Appointments - Hospital Management System</title>
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
            .btn-action {
                margin: 0 2px;
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
                    <a href="doctorViewAppointments.jsp" class="active">
                        <i class="fas fa-calendar-check"></i> Appointments
                    </a>
                    <a href="viewPatients.jsp">
                        <i class="fas fa-users"></i> Patients
                    </a>
                    <a href="prescriptions.jsp">
                        <i class="fas fa-prescription"></i> Prescriptions
                    </a>
                    <a href="notifications.jsp">
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
                        <h2>Appointments</h2>
                        <div class="text-muted">
                            <i class="fas fa-calendar-alt"></i> 
                            <%= new java.text.SimpleDateFormat("EEEE, MMMM d, yyyy").format(new java.util.Date()) %>
                        </div>
                    </div>
                    
                    <!-- Appointment Filters -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <form method="GET" class="row align-items-end">
                                <div class="col-md-3">
                                    <label>Date Range</label>
                                    <select name="dateRange" class="form-control">
                                        <option value="today">Today</option>
                                        <option value="tomorrow">Tomorrow</option>
                                        <option value="week">This Week</option>
                                        <option value="month">This Month</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label>Status</label>
                                    <select name="status" class="form-control">
                                        <option value="all">All Status</option>
                                        <option value="confirmed">Confirmed</option>
                                        <option value="pending">Pending</option>
                                        <option value="cancelled">Cancelled</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-filter"></i> Filter
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Appointments Table -->
                    <div class="card">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Date & Time</th>
                                            <th>Patient Name</th>
                                            <th>Contact</th>
                                            <th>Reason</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            try {
                                                Connection con = DatabaseConnection.initializeDatabase();
                                                
                                                // Get date filter
                                                String dateRange = request.getParameter("dateRange");
                                                String dateFilter = "DATE(a.appointment_date) = CURDATE()"; // default to today
                                                if (dateRange != null) {
                                                    switch(dateRange) {
                                                        case "tomorrow":
                                                            dateFilter = "DATE(a.appointment_date) = DATE_ADD(CURDATE(), INTERVAL 1 DAY)";
                                                            break;
                                                        case "week":
                                                            dateFilter = "YEARWEEK(a.appointment_date, 1) = YEARWEEK(CURDATE(), 1)";
                                                            break;
                                                        case "month":
                                                            dateFilter = "MONTH(a.appointment_date) = MONTH(CURDATE()) AND YEAR(a.appointment_date) = YEAR(CURDATE())";
                                                            break;
                                                    }
                                                }
                                                
                                                // Get status filter
                                                String status = request.getParameter("status");
                                                String statusFilter = "";
                                                if (status != null && !status.equals("all")) {
                                                    statusFilter = " AND a.status = '" + status + "'";
                                                }
                                                
                                                String query = "SELECT a.*, p.fname, p.lname, p.contact " +
                                                             "FROM appointments a " +
                                                             "JOIN patient p ON a.patient_id = p.id " +
                                                             "WHERE a.doctor_id = ? AND " + dateFilter + statusFilter +
                                                             " ORDER BY a.appointment_date ASC";
                                                
                                                PreparedStatement pst = con.prepareStatement(query);
                                                pst.setString(1, doctorId);
                                                ResultSet rs = pst.executeQuery();
                                                
                                                while(rs.next()) {
                                                    String appointmentDateTime = new java.text.SimpleDateFormat("MMM d, yyyy hh:mm a")
                                                            .format(rs.getTimestamp("appointment_date"));
                                                    String patientName = rs.getString("fname") + " " + rs.getString("lname");
                                                    String appointmentStatus = rs.getString("status");
                                        %>
                                        <tr>
                                            <td><%= appointmentDateTime %></td>
                                            <td><%= patientName %></td>
                                            <td><%= rs.getString("contact") %></td>
                                            <td><%= rs.getString("reason") %></td>
                                            <td>
                                                <span class="badge badge-<%= appointmentStatus.equals("confirmed") ? "success" : 
                                                                           appointmentStatus.equals("pending") ? "warning" : 
                                                                           "secondary" %>">
                                                    <%= appointmentStatus %>
                                                </span>
                                            </td>
                                            <td>
                                                <a href="viewAppointment.jsp?id=<%= rs.getInt("id") %>" 
                                                   class="btn btn-sm btn-info btn-action">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <% if (appointmentStatus.equals("pending")) { %>
                                                    <a href="updateAppointment.jsp?id=<%= rs.getInt("id") %>&action=confirm" 
                                                       class="btn btn-sm btn-success btn-action">
                                                        <i class="fas fa-check"></i>
                                                    </a>
                                                <% } %>
                                                <a href="prescriptions.jsp?appointmentId=<%= rs.getInt("id") %>" 
                                                   class="btn btn-sm btn-primary btn-action">
                                                    <i class="fas fa-prescription"></i>
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
