<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Patients - Hospital Management System</title>
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
            .search-box {
                margin-bottom: 20px;
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
                    <a href="viewPatients.jsp" class="active">
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
                        <h2>My Patients</h2>
                        <div class="text-muted">
                            <i class="fas fa-calendar-alt"></i> 
                            <%= new java.text.SimpleDateFormat("EEEE, MMMM d, yyyy").format(new java.util.Date()) %>
                        </div>
                    </div>
                    
                    <!-- Search Box -->
                    <div class="card search-box">
                        <div class="card-body">
                            <form method="GET" class="row">
                                <div class="col-md-4">
                                    <input type="text" name="search" class="form-control" 
                                           placeholder="Search by name or ID" 
                                           value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                                </div>
                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-search"></i> Search
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Patients Table -->
                    <div class="card">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Patient ID</th>
                                            <th>Name</th>
                                            <th>Contact</th>
                                            <th>Last Visit</th>
                                            <th>Total Visits</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            try {
                                                Connection con = DatabaseConnection.initializeDatabase();
                                                
                                                String searchTerm = request.getParameter("search");
                                                String query = "SELECT DISTINCT p.*, " +
                                                             "(SELECT COUNT(*) FROM appointments WHERE patient_id = p.id AND doctor_id = ?) as visit_count, " +
                                                             "(SELECT MAX(appointment_date) FROM appointments WHERE patient_id = p.id AND doctor_id = ?) as last_visit " +
                                                             "FROM patient p " +
                                                             "INNER JOIN appointments a ON p.id = a.patient_id " +
                                                             "WHERE a.doctor_id = ? ";
                                                
                                                if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                                                    query += "AND (p.fname LIKE ? OR p.lname LIKE ? OR p.id LIKE ?) ";
                                                }
                                                
                                                query += "ORDER BY last_visit DESC";
                                                
                                                PreparedStatement pst = con.prepareStatement(query);
                                                pst.setString(1, doctorId);
                                                pst.setString(2, doctorId);
                                                pst.setString(3, doctorId);
                                                
                                                if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                                                    String searchPattern = "%" + searchTerm.trim() + "%";
                                                    pst.setString(4, searchPattern);
                                                    pst.setString(5, searchPattern);
                                                    pst.setString(6, searchPattern);
                                                }
                                                
                                                ResultSet rs = pst.executeQuery();
                                                
                                                while(rs.next()) {
                                                    String patientId = rs.getString("id");
                                                    String patientName = rs.getString("fname") + " " + rs.getString("lname");
                                                    String contact = rs.getString("contact");
                                                    Timestamp lastVisit = rs.getTimestamp("last_visit");
                                                    int visitCount = rs.getInt("visit_count");
                                                    
                                                    String lastVisitStr = lastVisit != null ? 
                                                        new java.text.SimpleDateFormat("MMM d, yyyy").format(lastVisit) : "No visits";
                                        %>
                                        <tr>
                                            <td><%= patientId %></td>
                                            <td><%= patientName %></td>
                                            <td><%= contact %></td>
                                            <td><%= lastVisitStr %></td>
                                            <td><%= visitCount %></td>
                                            <td>
                                                <a href="viewPatientHistory.jsp?id=<%= patientId %>" 
                                                   class="btn btn-sm btn-info">
                                                    <i class="fas fa-history"></i> History
                                                </a>
                                                <a href="prescriptions.jsp?patientId=<%= patientId %>" 
                                                   class="btn btn-sm btn-primary">
                                                    <i class="fas fa-prescription"></i> Prescriptions
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
