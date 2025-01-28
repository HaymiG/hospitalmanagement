<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Print Prescription</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <style>
            @media print {
                .no-print {
                    display: none;
                }
                body {
                    padding: 0;
                    margin: 0;
                }
                .container {
                    width: 100%;
                    max-width: none;
                }
            }
            .prescription-header {
                text-align: center;
                margin-bottom: 30px;
            }
            .prescription-body {
                margin: 20px 0;
            }
            .prescription-footer {
                margin-top: 50px;
            }
            .doctor-signature {
                margin-top: 100px;
                border-top: 1px solid #000;
                width: 200px;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <div class="container mt-4">
            <%
                String prescriptionId = request.getParameter("id");
                if (prescriptionId != null) {
                    try {
                        Connection con = DatabaseConnection.initializeDatabase();
                        String query = "SELECT p.*, pt.fname as patient_fname, pt.lname as patient_lname, " +
                                     "d.fname as doctor_fname, d.lname as doctor_lname, d.specialization " +
                                     "FROM prescriptions p " +
                                     "JOIN patient pt ON p.patient_id = pt.id " +
                                     "JOIN doctor d ON p.doctor_id = d.id " +
                                     "WHERE p.id = ?";
                        
                        PreparedStatement pst = con.prepareStatement(query);
                        pst.setString(1, prescriptionId);
                        ResultSet rs = pst.executeQuery();
                        
                        if (rs.next()) {
            %>
            <div class="prescription-header">
                <h2>Hospital Management System</h2>
                <p>123 Healthcare Street, Medical City</p>
                <p>Phone: (123) 456-7890</p>
            </div>
            
            <div class="prescription-body">
                <div class="row">
                    <div class="col-6">
                        <p><strong>Patient Name:</strong> <%= rs.getString("patient_fname") + " " + rs.getString("patient_lname") %></p>
                        <p><strong>Date:</strong> <%= new java.util.Date() %></p>
                    </div>
                    <div class="col-6 text-right">
                        <p><strong>Prescription #:</strong> <%= prescriptionId %></p>
                    </div>
                </div>
                
                <div class="mt-4">
                    <h4>Rx</h4>
                    <div class="ml-4">
                        <p>
                            <strong>Medication:</strong> <%= rs.getString("medication_name") %><br>
                            <strong>Dosage:</strong> <%= rs.getString("dosage") %><br>
                            <strong>Frequency:</strong> <%= rs.getString("frequency") %><br>
                            <strong>Duration:</strong> <%= rs.getDate("start_date") %> to <%= rs.getDate("end_date") %>
                        </p>
                        
                        <% if(rs.getString("notes") != null && !rs.getString("notes").isEmpty()) { %>
                        <p>
                            <strong>Special Instructions:</strong><br>
                            <%= rs.getString("notes") %>
                        </p>
                        <% } %>
                    </div>
                </div>
            </div>
            
            <div class="prescription-footer">
                <div class="doctor-signature float-right">
                    <p>
                        Dr. <%= rs.getString("doctor_fname") + " " + rs.getString("doctor_lname") %><br>
                        <%= rs.getString("specialization") %>
                    </p>
                </div>
            </div>
            
            <div class="mt-4 text-center no-print">
                <button onclick="window.print()" class="btn btn-primary">
                    <i class="fas fa-print"></i> Print
                </button>
                <button onclick="window.close()" class="btn btn-secondary ml-2">
                    <i class="fas fa-times"></i> Close
                </button>
            </div>
            <%
                        } else {
                            out.println("<div class='alert alert-danger'>Prescription not found.</div>");
                        }
                        rs.close();
                        pst.close();
                        con.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                    }
                } else {
                    out.println("<div class='alert alert-danger'>Invalid prescription ID.</div>");
                }
            %>
        </div>
        
        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
