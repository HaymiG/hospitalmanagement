<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Medical Records - Hospital Management System</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            .record-card {
                margin-bottom: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .record-card .card-header {
                background-color: #f8f9fa;
                font-weight: bold;
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
        %>
        
        <div class="container mt-4">
            <h2 class="mb-4">Medical Records</h2>
            
            <div class="row">
                <%
                    try {
                        Connection con = DatabaseConnection.initializeDatabase();
                        String query = "SELECT mr.*, d.fname as doctor_fname, d.lname as doctor_lname, " +
                                     "d.specialization FROM medical_records mr " +
                                     "JOIN doctor d ON mr.doctor_id = d.id " +
                                     "WHERE mr.patient_id = ? ORDER BY mr.visit_date DESC";
                        
                        PreparedStatement pst = con.prepareStatement(query);
                        pst.setString(1, patientId);
                        ResultSet rs = pst.executeQuery();
                        
                        if (!rs.isBeforeFirst()) {
                %>
                            <div class="col-12">
                                <div class="alert alert-info">
                                    No medical records found.
                                </div>
                            </div>
                <%
                        }
                        
                        while (rs.next()) {
                            String doctorName = rs.getString("doctor_fname") + " " + rs.getString("doctor_lname");
                %>
                            <div class="col-md-6">
                                <div class="card record-card">
                                    <div class="card-header">
                                        Visit Date: <%= rs.getDate("visit_date") %>
                                    </div>
                                    <div class="card-body">
                                        <h5 class="card-title">
                                            <i class="fas fa-user-md"></i> Dr. <%= doctorName %>
                                            <small class="text-muted">(<%= rs.getString("specialization") %>)</small>
                                        </h5>
                                        <p class="card-text">
                                            <strong>Visit Type:</strong> <%= rs.getString("visit_type") %><br>
                                            <strong>Diagnosis:</strong> <%= rs.getString("diagnosis") %><br>
                                            <strong>Treatment:</strong> <%= rs.getString("treatment") %>
                                        </p>
                                        <% if (rs.getString("notes") != null && !rs.getString("notes").isEmpty()) { %>
                                            <div class="mt-2">
                                                <strong>Notes:</strong><br>
                                                <%= rs.getString("notes") %>
                                            </div>
                                        <% } %>
                                    </div>
                                    <div class="card-footer text-muted">
                                        Record created on: <%= rs.getTimestamp("created_at") %>
                                    </div>
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
        
        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
