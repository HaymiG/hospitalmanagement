<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Doctor Appointments</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    </head>
    <body>
        <%
            // Check if doctor is logged in
            String doctorEmail = (String) session.getAttribute("doctorEmail");
            if (doctorEmail == null) {
                response.sendRedirect("doctorLogin.jsp");
                return;
            }
        %>
        <nav class="navbar navbar-expand-lg navbar-dark bg-success">
            <div class="container">
                <a class="navbar-brand" href="doctorHome.jsp">Hospital Management System</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item active">
                            <a class="nav-link" href="doctorAppointments.jsp">Appointments</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="prescribeMedicine.jsp">Prescribe Medicine</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="logout.jsp">Logout</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container mt-5">
            <div class="row">
                <div class="col-md-12">
                    <h2>My Appointments</h2>
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        Connection con = DatabaseConnection.initializeDatabase();
                                        String query = "SELECT a.*, p.fname as patient_fname, p.lname as patient_lname " +
                                                     "FROM appointments a " +
                                                     "JOIN patient p ON a.patient_id = p.id " +
                                                     "WHERE a.doctor_id = (SELECT id FROM doctor WHERE email = ?) " +
                                                     "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
                                        PreparedStatement pst = con.prepareStatement(query);
                                        pst.setString(1, doctorEmail);
                                        ResultSet rs = pst.executeQuery();
                                        
                                        while(rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getString("patient_fname") %> <%= rs.getString("patient_lname") %></td>
                                    <td><%= rs.getDate("appointment_date") %></td>
                                    <td><%= rs.getTime("appointment_time") %></td>
                                    <td><span class="badge badge-<%= rs.getString("status").equals("scheduled") ? "success" : "warning" %>">
                                        <%= rs.getString("status") %>
                                    </span></td>
                                    <td>
                                        <a href="prescribeMedicine.jsp?appointment_id=<%= rs.getInt("id") %>" 
                                           class="btn btn-primary btn-sm">Prescribe Medicine</a>
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
