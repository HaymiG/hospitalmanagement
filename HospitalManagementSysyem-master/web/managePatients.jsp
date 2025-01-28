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
        <title>Manage Patients - Hospital Management System</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    </head>
    <body>
        <div class="container mt-5">
            <div class="row mb-4">
                <div class="col">
                    <h2><i class="fas fa-users"></i> Manage Patients</h2>
                </div>
                <div class="col text-right">
                    <a href="adminDashboard.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                    <a href="addpatient.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add New Patient
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
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Address</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        Connection con = DatabaseConnection.initializeDatabase();
                                        String query = "SELECT * FROM patient";
                                        PreparedStatement pst = con.prepareStatement(query);
                                        ResultSet rs = pst.executeQuery();
                                        
                                        while(rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getString("id") %></td>
                                    <td><%= rs.getString("name") %></td>
                                    <td><%= rs.getString("email") %></td>
                                    <td><%= rs.getString("phone") %></td>
                                    <td><%= rs.getString("address") %></td>
                                    <td>
                                        <a href="editPatient.jsp?id=<%= rs.getString("id") %>" class="btn btn-sm btn-info">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="deletePatient.jsp?id=<%= rs.getString("id") %>" class="btn btn-sm btn-danger" 
                                           onclick="return confirm('Are you sure you want to delete this patient?')">
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
