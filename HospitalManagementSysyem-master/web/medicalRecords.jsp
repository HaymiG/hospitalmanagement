<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Medical Records</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <style>
            .record-card {
                margin-bottom: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .record-title {
                color: #007bff;
                text-decoration: none;
                font-size: 1.1em;
            }
            .record-title:hover {
                text-decoration: none;
            }
            .record-details {
                padding: 20px;
                background-color: #f8f9fa;
                border-radius: 0 0 8px 8px;
            }
            .record-details p {
                margin-bottom: 10px;
            }
            .record-details strong {
                color: #495057;
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-success">
            <div class="container">
                <a class="navbar-brand" href="index.jsp">Hospital Management System</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="index.jsp">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="doctorLogin.jsp">Doctor Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="admin.jsp">Admin</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container mt-5">
            <h1 class="mb-4">Medical Records</h1>
            
            <div class="row mb-4">
                <div class="col">
                    <form action="medicalRecords.jsp" method="GET" class="form-inline">
                        <input type="text" name="search" class="form-control mr-2" placeholder="Search by patient name..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                        <button type="submit" class="btn btn-primary">Search</button>
                    </form>
                </div>
            </div>
            
            <%
                try {
                    Connection con = DatabaseConnection.initializeDatabase();
                    String searchTerm = request.getParameter("search");
                    String query = "SELECT mr.*, " +
                                 "p.fname as patient_fname, p.lname as patient_lname, " +
                                 "d.fname as doctor_fname, d.lname as doctor_lname " +
                                 "FROM medical_records mr " +
                                 "JOIN patient p ON mr.patient_id = p.id " +
                                 "JOIN doctor d ON mr.doctor_id = d.id ";
                    
                    if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                        query += "WHERE p.fname LIKE ? OR p.lname LIKE ? ";
                    }
                    query += "ORDER BY mr.visit_date DESC";
                    
                    PreparedStatement pst = con.prepareStatement(query);
                    if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                        String searchPattern = "%" + searchTerm.trim() + "%";
                        pst.setString(1, searchPattern);
                        pst.setString(2, searchPattern);
                    }
                    
                    ResultSet rs = pst.executeQuery();
                    boolean hasRecords = false;
                    
                    while(rs.next()) {
                        hasRecords = true;
                        String patientName = rs.getString("patient_fname") + " " + rs.getString("patient_lname");
                        String doctorName = "Dr. " + rs.getString("doctor_fname") + " " + rs.getString("doctor_lname");
                        String visitDate = rs.getDate("visit_date").toString();
                        String visitType = rs.getString("visit_type");
            %>
            
            <div class="record-card">
                <div class="card">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">
                            <span class="record-title"><%= patientName %> - <%= visitDate %> (<%= visitType %>)</span>
                        </h5>
                    </div>
                    <div class="record-details">
                        <p><strong>Doctor:</strong> <%= doctorName %></p>
                        <p><strong>Diagnosis:</strong> <%= rs.getString("diagnosis") %></p>
                        <p><strong>Treatment:</strong> <%= rs.getString("treatment") %></p>
                        <p><strong>Notes:</strong> <%= rs.getString("notes") %></p>
                    </div>
                </div>
            </div>
            
            <%
                    }
                    
                    if (!hasRecords) {
                        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            %>
                            <div class="alert alert-info">No medical records found for "<%= searchTerm %>".</div>
            <%
                        } else {
            %>
                            <div class="alert alert-info">No medical records found.</div>
            <%
                        }
                    }
                    
                    rs.close();
                    pst.close();
                    con.close();
                    
                } catch(Exception e) {
                    out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                }
            %>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
