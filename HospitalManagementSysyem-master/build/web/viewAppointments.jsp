<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Appointments</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    </head>
    <body>
        <%
            // Check if patient is logged in
            Integer patientId = (Integer) session.getAttribute("patientId");
            if (patientId == null) {
                response.sendRedirect("patientLogin.jsp");
                return;
            }
        %>
        
        <nav class="navbar navbar-expand-lg navbar-dark bg-success">
            <div class="container">
                <a class="navbar-brand" href="patientDashboard.jsp">
                    <i class="fas fa-hospital"></i> Hospital Management System
                </a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="patientDashboard.jsp">
                                <i class="fas fa-home"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="bookAppointment.jsp">
                                <i class="fas fa-calendar-plus"></i> Book Appointment
                            </a>
                        </li>
                        <li class="nav-item active">
                            <a class="nav-link" href="viewAppointments.jsp">
                                <i class="fas fa-calendar-check"></i> My Appointments
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="LogoutServlet">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container mt-4">
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h4><i class="fas fa-calendar-check"></i> My Appointments</h4>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Appointment ID</th>
                                    <th>Doctor</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        Connection con = DatabaseConnection.initializeDatabase();
                                        String query = "SELECT a.id, CONCAT('Dr. ', d.fname, ' ', d.lname) as doctor_name, " +
                                                      "a.appointment_date, a.appointment_time, a.status " +
                                                      "FROM appointments a " +
                                                      "JOIN doctor d ON a.doctor_id = d.id " +
                                                      "WHERE a.patient_id = ? " +
                                                      "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
                                        
                                        PreparedStatement pst = con.prepareStatement(query);
                                        pst.setInt(1, patientId);
                                        ResultSet rs = pst.executeQuery();
                                        
                                        while(rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getInt("id") %></td>
                                    <td><%= rs.getString("doctor_name") %></td>
                                    <td><%= rs.getDate("appointment_date") %></td>
                                    <td><%= rs.getTime("appointment_time") %></td>
                                    <td>
                                        <span class="badge badge-<%= rs.getString("status").equals("scheduled") ? "primary" : 
                                                                    rs.getString("status").equals("completed") ? "success" : 
                                                                    rs.getString("status").equals("cancelled") ? "danger" : "secondary" %>">
                                            <%= rs.getString("status") %>
                                        </span>
                                    </td>
                                </tr>
                                <%
                                        }
                                        rs.close();
                                        pst.close();
                                        con.close();
                                    } catch(Exception e) {
                                        out.println("<tr><td colspan='5' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
