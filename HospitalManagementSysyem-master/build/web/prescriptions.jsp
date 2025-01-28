<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Prescriptions - Hospital Management System</title>
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
            .prescription-card {
                margin-bottom: 20px;
            }
            .status-active {
                color: #28a745;
            }
            .status-completed {
                color: #6c757d;
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
            
            // Get patient ID if passed as parameter
            String patientId = request.getParameter("patientId");
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
                    <a href="prescriptions.jsp" class="active">
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
                        <h2>Prescriptions</h2>
                        <div>
                            <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#newPrescriptionModal">
                                <i class="fas fa-plus"></i> New Prescription
                            </button>
                        </div>
                    </div>
                    
                    <!-- Filter Section -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <form method="GET" class="row">
                                <% if (patientId != null) { %>
                                    <input type="hidden" name="patientId" value="<%= patientId %>">
                                <% } %>
                                <div class="col-md-3">
                                    <label>Status</label>
                                    <select name="status" class="form-control">
                                        <option value="all">All Status</option>
                                        <option value="active">Active</option>
                                        <option value="completed">Completed</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label>&nbsp;</label>
                                    <button type="submit" class="btn btn-primary btn-block">
                                        <i class="fas fa-filter"></i> Filter
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Prescriptions List -->
                    <div class="row">
                        <%
                            try {
                                Connection con = DatabaseConnection.initializeDatabase();
                                
                                StringBuilder queryBuilder = new StringBuilder();
                                queryBuilder.append("SELECT p.*, pt.fname as patient_fname, pt.lname as patient_lname ");
                                queryBuilder.append("FROM prescriptions p ");
                                queryBuilder.append("JOIN patient pt ON p.patient_id = pt.id ");
                                queryBuilder.append("WHERE p.doctor_id = ? ");
                                
                                if (patientId != null && !patientId.trim().isEmpty()) {
                                    queryBuilder.append("AND p.patient_id = ? ");
                                }
                                
                                String status = request.getParameter("status");
                                if (status != null && !status.equals("all")) {
                                    queryBuilder.append("AND p.status = ? ");
                                }
                                
                                queryBuilder.append("ORDER BY p.created_at DESC");
                                
                                PreparedStatement pst = con.prepareStatement(queryBuilder.toString());
                                int paramIndex = 1;
                                pst.setString(paramIndex++, doctorId);
                                
                                if (patientId != null && !patientId.trim().isEmpty()) {
                                    pst.setString(paramIndex++, patientId);
                                }
                                
                                if (status != null && !status.equals("all")) {
                                    pst.setString(paramIndex, status);
                                }
                                
                                ResultSet rs = pst.executeQuery();
                                
                                boolean hasPrescriptions = false;
                                while(rs.next()) {
                                    hasPrescriptions = true;
                                    String statusClass = rs.getString("status").equals("active") ? "status-active" : "status-completed";
                        %>
                        <div class="col-md-6">
                            <div class="card prescription-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5 class="card-title">
                                            <%= rs.getString("medication_name") %>
                                            <small class="<%= statusClass %>">
                                                <i class="fas fa-circle"></i> <%= rs.getString("status") %>
                                            </small>
                                        </h5>
                                    </div>
                                    <p class="card-text">
                                        <strong>Patient:</strong> <%= rs.getString("patient_fname") + " " + rs.getString("patient_lname") %><br>
                                        <strong>Dosage:</strong> <%= rs.getString("dosage") %><br>
                                        <strong>Frequency:</strong> <%= rs.getString("frequency") %><br>
                                        <strong>Duration:</strong> <%= rs.getDate("start_date") %> to <%= rs.getDate("end_date") %>
                                    </p>
                                    <% if(rs.getString("notes") != null && !rs.getString("notes").isEmpty()) { %>
                                    <div class="mt-3">
                                        <strong>Notes:</strong>
                                        <p class="mb-0"><%= rs.getString("notes") %></p>
                                    </div>
                                    <% } %>
                                    <div class="mt-3">
                                        <button class="btn btn-sm btn-info" onclick="printPrescription(<%= rs.getInt("id") %>)">
                                            <i class="fas fa-print"></i> Print
                                        </button>
                                        <% if (rs.getString("status").equals("active")) { %>
                                        <button class="btn btn-sm btn-success" onclick="markCompleted(<%= rs.getInt("id") %>)">
                                            <i class="fas fa-check"></i> Mark Completed
                                        </button>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%
                                }
                                if (!hasPrescriptions) {
                        %>
                        <div class="col-12">
                            <div class="alert alert-info">
                                No prescriptions found.
                            </div>
                        </div>
                        <%
                                }
                                rs.close();
                                pst.close();
                                con.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                                out.println("<div class='col-12'><div class='alert alert-danger'>Error: " + e.getMessage() + "</div></div>");
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- New Prescription Modal -->
        <div class="modal fade" id="newPrescriptionModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">New Prescription</h5>
                        <button type="button" class="close" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <form action="AddPrescriptionServlet" method="POST">
                        <div class="modal-body">
                            <input type="hidden" name="doctorId" value="<%= doctorId %>">
                            <div class="form-group">
                                <label>Patient</label>
                                <% if (patientId != null) { %>
                                    <input type="hidden" name="patientId" value="<%= patientId %>">
                                <% } else { %>
                                    <select name="patientId" class="form-control" required>
                                        <option value="">Select Patient</option>
                                        <%
                                            try {
                                                Connection con = DatabaseConnection.initializeDatabase();
                                                String query = "SELECT DISTINCT p.id, p.fname, p.lname " +
                                                             "FROM patient p " +
                                                             "INNER JOIN appointments a ON p.id = a.patient_id " +
                                                             "WHERE a.doctor_id = ? " +
                                                             "ORDER BY p.fname, p.lname";
                                                PreparedStatement pst = con.prepareStatement(query);
                                                pst.setString(1, doctorId);
                                                ResultSet rs = pst.executeQuery();
                                                
                                                while(rs.next()) {
                                        %>
                                        <option value="<%= rs.getInt("id") %>">
                                            <%= rs.getString("fname") + " " + rs.getString("lname") %>
                                        </option>
                                        <%
                                                }
                                                rs.close();
                                                pst.close();
                                                con.close();
                                            } catch (Exception e) {
                                                e.printStackTrace();
                                            }
                                        %>
                                    </select>
                                <% } %>
                            </div>
                            <div class="form-group">
                                <label>Medication Name</label>
                                <input type="text" name="medicationName" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Dosage</label>
                                <input type="text" name="dosage" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Frequency</label>
                                <input type="text" name="frequency" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Start Date</label>
                                <input type="date" name="startDate" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>End Date</label>
                                <input type="date" name="endDate" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Notes</label>
                                <textarea name="notes" class="form-control" rows="3"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Prescription</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
        <script>
            function printPrescription(id) {
                window.open('printPrescription.jsp?id=' + id, '_blank');
            }
            
            function markCompleted(id) {
                if (confirm('Are you sure you want to mark this prescription as completed?')) {
                    window.location.href = 'UpdatePrescriptionServlet?id=' + id + '&action=complete';
                }
            }
        </script>
    </body>
</html>
