<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Prescriptions</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    </head>
    <body>
        <%
            String patientId = session.getAttribute("patientId") != null ? 
                session.getAttribute("patientId").toString() : null;
            
            if (patientId == null) {
                response.sendRedirect("patientLogin.jsp");
                return;
            }
        %>
        
        <div class="container mt-4">
            <h2>My Prescriptions</h2>
            
            <div class="table-responsive mt-4">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Medication</th>
                            <th>Doctor</th>
                            <th>Dosage</th>
                            <th>Frequency</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Status</th>
                            <th>Notes</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                Connection con = DatabaseConnection.initializeDatabase();
                                String query = "SELECT p.*, d.fname as doctor_fname, d.lname as doctor_lname " +
                                             "FROM prescriptions p " +
                                             "JOIN doctor d ON p.doctor_id = d.id " +
                                             "WHERE p.patient_id = ? " +
                                             "ORDER BY p.start_date DESC";
                                
                                PreparedStatement pst = con.prepareStatement(query);
                                pst.setString(1, patientId);
                                ResultSet rs = pst.executeQuery();
                                
                                boolean hasRecords = false;
                                while (rs.next()) {
                                    hasRecords = true;
                                    String doctorName = rs.getString("doctor_fname") + " " + rs.getString("doctor_lname");
                        %>
                                    <tr>
                                        <td><%= rs.getString("medication_name") %></td>
                                        <td>Dr. <%= doctorName %></td>
                                        <td><%= rs.getString("dosage") %></td>
                                        <td><%= rs.getString("frequency") %></td>
                                        <td><%= rs.getDate("start_date") %></td>
                                        <td><%= rs.getDate("end_date") %></td>
                                        <td><%= rs.getString("status") %></td>
                                        <td><%= rs.getString("notes") != null ? rs.getString("notes") : "" %></td>
                                    </tr>
                        <%
                                }
                                
                                if (!hasRecords) {
                        %>
                                    <tr>
                                        <td colspan="8" class="text-center">No prescriptions found.</td>
                                    </tr>
                        <%
                                }
                                
                                rs.close();
                                pst.close();
                                con.close();
                                
                            } catch (Exception e) {
                                out.println("<tr><td colspan='8' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
