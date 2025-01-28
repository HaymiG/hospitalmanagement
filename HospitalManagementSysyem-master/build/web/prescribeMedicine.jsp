<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Prescribe Medicine</title>
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
            
            // Get appointment details
            String appointmentId = request.getParameter("appointment_id");
            String patientName = "";
            if (appointmentId != null) {
                try {
                    Connection con = DatabaseConnection.initializeDatabase();
                    String query = "SELECT p.fname, p.lname FROM appointments a " +
                                 "JOIN patient p ON a.patient_id = p.id " +
                                 "WHERE a.id = ?";
                    PreparedStatement pst = con.prepareStatement(query);
                    pst.setString(1, appointmentId);
                    ResultSet rs = pst.executeQuery();
                    if (rs.next()) {
                        patientName = rs.getString("fname") + " " + rs.getString("lname");
                    }
                    rs.close();
                    pst.close();
                    con.close();
                } catch(Exception e) {
                    out.println("Error: " + e.getMessage());
                }
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
                        <li class="nav-item">
                            <a class="nav-link" href="doctorHome.jsp">Dashboard</a>
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
                <div class="col-md-8 offset-md-2">
                    <div class="card">
                        <div class="card-header">
                            <h4>Prescribe Medicine for <%= patientName %></h4>
                        </div>
                        <div class="card-body">
                            <form action="PrescribeMedicineServlet" method="POST">
                                <input type="hidden" name="appointment_id" value="<%= appointmentId %>">
                                
                                <div class="form-group">
                                    <label>Diagnosis</label>
                                    <textarea class="form-control" name="diagnosis" rows="3" required></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label>Medicines</label>
                                    <div id="medicineList">
                                        <div class="medicine-entry mb-3">
                                            <div class="row">
                                                <div class="col-md-5">
                                                    <input type="text" class="form-control" name="medicine_name[]" 
                                                           placeholder="Medicine Name" required>
                                                </div>
                                                <div class="col-md-4">
                                                    <input type="text" class="form-control" name="dosage[]" 
                                                           placeholder="Dosage (e.g., 1-0-1)" required>
                                                </div>
                                                <div class="col-md-2">
                                                    <input type="number" class="form-control" name="duration[]" 
                                                           placeholder="Days" required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <button type="button" class="btn btn-secondary btn-sm" onclick="addMedicine()">
                                        Add More Medicine
                                    </button>
                                </div>
                                
                                <div class="form-group">
                                    <label>Additional Instructions</label>
                                    <textarea class="form-control" name="instructions" rows="3"></textarea>
                                </div>
                                
                                <button type="submit" class="btn btn-success">Save Prescription</button>
                                <a href="doctorHome.jsp" class="btn btn-secondary">Cancel</a>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function addMedicine() {
                const medicineList = document.getElementById('medicineList');
                const newEntry = document.createElement('div');
                newEntry.className = 'medicine-entry mb-3';
                newEntry.innerHTML = `
                    <div class="row">
                        <div class="col-md-5">
                            <input type="text" class="form-control" name="medicine_name[]" 
                                   placeholder="Medicine Name" required>
                        </div>
                        <div class="col-md-4">
                            <input type="text" class="form-control" name="dosage[]" 
                                   placeholder="Dosage (e.g., 1-0-1)" required>
                        </div>
                        <div class="col-md-2">
                            <input type="number" class="form-control" name="duration[]" 
                                   placeholder="Days" required>
                        </div>
                        <div class="col-md-1">
                            <button type="button" class="btn btn-danger btn-sm" 
                                    onclick="this.parentElement.parentElement.parentElement.remove()">
                                ×
                            </button>
                        </div>
                    </div>
                `;
                medicineList.appendChild(newEntry);
            }
        </script>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
