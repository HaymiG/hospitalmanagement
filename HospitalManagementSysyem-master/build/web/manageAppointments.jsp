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
        <title>Manage Appointments - Hospital Management System</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    </head>
    <body>
        <div class="container mt-5">
            <div class="row mb-4">
                <div class="col">
                    <h2><i class="fas fa-calendar-check"></i> Manage Appointments</h2>
                </div>
                <div class="col text-right">
                    <a href="adminDashboard.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Patient Name</th>
                                    <th>Doctor Name</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        Connection con = DatabaseConnection.initializeDatabase();
                                        String query = "SELECT a.*, p.name as patient_name, d.name as doctor_name " +
                                                     "FROM appointments a " +
                                                     "JOIN patient p ON a.patient_id = p.id " +
                                                     "JOIN doctor d ON a.doctor_id = d.id";
                                        PreparedStatement pst = con.prepareStatement(query);
                                        ResultSet rs = pst.executeQuery();
                                        
                                        while(rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getString("id") %></td>
                                    <td><%= rs.getString("patient_name") %></td>
                                    <td><%= rs.getString("doctor_name") %></td>
                                    <td><%= rs.getString("appointment_date") %></td>
                                    <td><%= rs.getString("appointment_time") %></td>
                                    <td>
                                        <span class="badge badge-<%= rs.getString("status").equals("Confirmed") ? "success" : 
                                                                    rs.getString("status").equals("Pending") ? "warning" : "danger" %>">
                                            <%= rs.getString("status") %>
                                        </span>
                                    </td>
                                    <td>
                                        <a href="updateAppointment.jsp?id=<%= rs.getString("id") %>" class="btn btn-sm btn-info">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="deleteAppointment.jsp?id=<%= rs.getString("id") %>" class="btn btn-sm btn-danger" 
                                           onclick="return confirm('Are you sure you want to delete this appointment?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                                <%
                                        }
                                        rs.close();
                                        pst.close();
                                        con.close();
                                    } catch(Exception e) {
                                        e.printStackTrace();
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
