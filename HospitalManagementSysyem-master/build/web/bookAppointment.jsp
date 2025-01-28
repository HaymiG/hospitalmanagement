<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Book Appointment</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    </head>
    <body>
        <%
            // Check if user is logged in
            Integer patientId = (Integer) session.getAttribute("patientId");
            if (patientId == null) {
                response.sendRedirect("patientLogin.jsp");
                return;
            }
        %>
        
        <!-- Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-success">
            <div class="container">
                <a class="navbar-brand" href="#"><i class="fas fa-hospital"></i> Hospital Management System</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="patientDashboard.jsp">Dashboard</a>
                        </li>
                        <li class="nav-item active">
                            <a class="nav-link" href="bookAppointment.jsp">Book Appointment</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="patientProfile.jsp">Profile</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="LogoutServlet">Logout</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container mt-4">
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h4><i class="fas fa-calendar-plus"></i> Book New Appointment</h4>
                </div>
                <div class="card-body">
                    <%-- Display error message if any --%>
                    <% 
                        String errorMessage = (String) session.getAttribute("errorMessage");
                        if (errorMessage != null) {
                    %>
                        <div class="alert alert-danger" role="alert">
                            <%= errorMessage %>
                        </div>
                    <%
                            session.removeAttribute("errorMessage");
                        }
                        
                        String successMessage = (String) session.getAttribute("successMessage");
                        if (successMessage != null) {
                    %>
                        <div class="alert alert-success" role="alert">
                            <%= successMessage %>
                        </div>
                    <%
                            session.removeAttribute("successMessage");
                        }
                    %>
                    
                    <form action="BookAppointmentServlet" method="POST">
                        <div class="form-group">
                            <label><i class="fas fa-user-md"></i> Select Doctor</label>
                            <select name="doctorId" class="form-control" required>
                                <option value="">Choose a doctor...</option>
                                <%
                                    try {
                                        Connection con = DatabaseConnection.initializeDatabase();
                                        String query = "SELECT id, fname, lname, specialization FROM doctor";
                                        Statement stmt = con.createStatement();
                                        ResultSet rs = stmt.executeQuery(query);
                                        
                                        while(rs.next()) {
                                %>
                                            <option value="<%= rs.getInt("id") %>">
                                                Dr. <%= rs.getString("fname") %> <%= rs.getString("lname") %> 
                                                - <%= rs.getString("specialization") %>
                                            </option>
                                <%
                                        }
                                        rs.close();
                                        stmt.close();
                                        con.close();
                                    } catch(Exception e) {
                                        out.println("Error loading doctors: " + e.getMessage());
                                    }
                                %>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label><i class="fas fa-calendar"></i> Appointment Date</label>
                            <input type="date" name="appointmentDate" class="form-control" required 
                                   min="<%= java.time.LocalDate.now() %>">
                        </div>
                        
                        <div class="form-group">
                            <label><i class="fas fa-clock"></i> Preferred Time</label>
                            <select name="appointmentTime" class="form-control" required>
                                <option value="">Select time...</option>
                                <option value="09:00:00">9:00 AM</option>
                                <option value="10:00:00">10:00 AM</option>
                                <option value="11:00:00">11:00 AM</option>
                                <option value="14:00:00">2:00 PM</option>
                                <option value="15:00:00">3:00 PM</option>
                                <option value="16:00:00">4:00 PM</option>
                            </select>
                        </div>
                        
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-calendar-check"></i> Book Appointment
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
