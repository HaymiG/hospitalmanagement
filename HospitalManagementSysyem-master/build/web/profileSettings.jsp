<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Profile Settings</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <style>
            .profile-section {
                background: #fff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .profile-header {
                margin-bottom: 30px;
                border-bottom: 2px solid #f8f9fa;
                padding-bottom: 20px;
            }
        </style>
    </head>
    <body class="bg-light">
        <nav class="navbar navbar-expand-lg navbar-dark bg-success">
            <div class="container">
                <a class="navbar-brand" href="UserHome.jsp">Hospital Management System</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="UserHome.jsp">Home</a>
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
                    <div class="profile-section">
                        <div class="profile-header">
                            <h2>Profile Settings</h2>
                            <p class="text-muted">Update your personal information</p>
                        </div>
                        
                        <%
                            try {
                                Connection con = DatabaseConnection.initializeDatabase();
                                String query = "SELECT * FROM user_profiles WHERE user_id = ?";
                                PreparedStatement pst = con.prepareStatement(query);
                                // Replace with actual user ID from session
                                pst.setInt(1, 1);
                                ResultSet rs = pst.executeQuery();
                                
                                if(rs.next()) {
                        %>
                        <form action="UpdateProfileServlet" method="POST">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Full Name</label>
                                        <input type="text" class="form-control" name="fullName" 
                                               value="<%= rs.getString("full_name") %>" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Email</label>
                                        <input type="email" class="form-control" name="email" 
                                               value="<%= rs.getString("email") %>" required>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Phone Number</label>
                                        <input type="tel" class="form-control" name="phone" 
                                               value="<%= rs.getString("phone") %>" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Date of Birth</label>
                                        <input type="date" class="form-control" name="dob" 
                                               value="<%= rs.getDate("date_of_birth") %>" required>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>Address</label>
                                <textarea class="form-control" name="address" 
                                          rows="3" required><%= rs.getString("address") %></textarea>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Blood Group</label>
                                        <select class="form-control" name="bloodGroup">
                                            <option value="A+" <%= rs.getString("blood_group").equals("A+") ? "selected" : "" %>>A+</option>
                                            <option value="A-" <%= rs.getString("blood_group").equals("A-") ? "selected" : "" %>>A-</option>
                                            <option value="B+" <%= rs.getString("blood_group").equals("B+") ? "selected" : "" %>>B+</option>
                                            <option value="B-" <%= rs.getString("blood_group").equals("B-") ? "selected" : "" %>>B-</option>
                                            <option value="O+" <%= rs.getString("blood_group").equals("O+") ? "selected" : "" %>>O+</option>
                                            <option value="O-" <%= rs.getString("blood_group").equals("O-") ? "selected" : "" %>>O-</option>
                                            <option value="AB+" <%= rs.getString("blood_group").equals("AB+") ? "selected" : "" %>>AB+</option>
                                            <option value="AB-" <%= rs.getString("blood_group").equals("AB-") ? "selected" : "" %>>AB-</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <h4 class="mt-4 mb-3">Emergency Contact</h4>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Contact Name</label>
                                        <input type="text" class="form-control" name="emergencyContact" 
                                               value="<%= rs.getString("emergency_contact") %>" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Contact Phone</label>
                                        <input type="tel" class="form-control" name="emergencyPhone" 
                                               value="<%= rs.getString("emergency_phone") %>" required>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mt-4">
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                                <a href="UserHome.jsp" class="btn btn-secondary">Cancel</a>
                            </div>
                        </form>
                        <%
                                } else {
                        %>
                        <div class="alert alert-warning">
                            Profile not found. Please contact administrator.
                        </div>
                        <%
                                }
                                rs.close();
                                pst.close();
                                con.close();
                            } catch(Exception e) {
                                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
