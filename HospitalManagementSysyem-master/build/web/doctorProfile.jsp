<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Doctor Profile - Hospital Management System</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            .sidebar {
                background-color: #343a40;
                min-height: 100vh;
                padding: 20px 0;
            }
            .sidebar a {
                color: #ffffff;
                padding: 10px 20px;
                display: block;
                text-decoration: none;
            }
            .sidebar a:hover {
                background-color: #495057;
            }
            .sidebar a.active {
                background-color: #28a745;
            }
            .sidebar i {
                margin-right: 10px;
            }
            .main-content {
                padding: 20px;
            }
            .profile-header {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 20px;
            }
            .profile-img {
                width: 150px;
                height: 150px;
                border-radius: 50%;
                object-fit: cover;
                border: 5px solid #fff;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .card {
                border: none;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            .card-header {
                background-color: #f8f9fa;
                border-bottom: none;
                font-weight: bold;
            }
            .btn-edit {
                position: absolute;
                right: 20px;
                top: 20px;
            }
        </style>
    </head>
    <body>
        <%
            // Check if doctor is logged in
            String doctorId = session.getAttribute("doctorId") != null ? 
                session.getAttribute("doctorId").toString() : null;
            String doctorName = (String) session.getAttribute("doctorName");
            String specialization = (String) session.getAttribute("specialization");
            
            if (doctorId == null) {
                response.sendRedirect("doctorLogin.jsp");
                return;
            }
            
            // Get doctor details from database
            Connection con = null;
            PreparedStatement pst = null;
            ResultSet rs = null;
            try {
                con = DatabaseConnection.initializeDatabase();
                String query = "SELECT * FROM doctor WHERE id = ?";
                pst = con.prepareStatement(query);
                pst.setString(1, doctorId);
                rs = pst.executeQuery();
                
                if (rs.next()) {
        %>
        
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-2 sidebar">
                    <div class="text-center mb-4">
                        <i class="fas fa-user-md fa-3x text-white"></i>
                        <h6 class="text-white mt-2"><%= doctorName %></h6>
                        <small class="text-muted"><%= specialization %></small>
                    </div>
                    <a href="doctorDashboard.jsp">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                    <a href="doctorViewAppointments.jsp">
                        <i class="fas fa-calendar-check"></i> Appointments
                    </a>
                    <a href="viewPatients.jsp">
                        <i class="fas fa-users"></i> Patients
                    </a>
                    <a href="prescriptions.jsp">
                        <i class="fas fa-prescription"></i> Prescriptions
                    </a>
                    <a href="notifications.jsp">
                        <i class="fas fa-bell"></i> Notifications
                    </a>
                    <a href="doctorProfile.jsp" class="active">
                        <i class="fas fa-user-circle"></i> Profile
                    </a>
                    <a href="${pageContext.request.contextPath}/LogoutServlet">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
                
                <!-- Main Content -->
                <div class="col-md-10 main-content">
                    <% if (request.getParameter("success") != null) { %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            Profile updated successfully!
                            <button type="button" class="close" data-dismiss="alert">
                                <span>&times;</span>
                            </button>
                        </div>
                    <% } %>
                    <% if (request.getParameter("error") != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            Error updating profile. Please try again.
                            <button type="button" class="close" data-dismiss="alert">
                                <span>&times;</span>
                            </button>
                        </div>
                    <% } %>
                    
                    <!-- Profile Header -->
                    <div class="profile-header position-relative">
                        <button class="btn btn-primary btn-edit" data-toggle="modal" data-target="#editProfileModal">
                            <i class="fas fa-edit"></i> Edit Profile
                        </button>
                        <div class="row">
                            <div class="col-md-3 text-center">
                                <img src="https://via.placeholder.com/150" alt="Doctor Profile" class="profile-img">
                            </div>
                            <div class="col-md-9">
                                <h2><%= rs.getString("fname") + " " + rs.getString("lname") %></h2>
                                <p class="text-muted mb-2"><%= rs.getString("specialization") %></p>
                                <p class="mb-1"><i class="fas fa-envelope mr-2"></i><%= rs.getString("email") %></p>
                                <p class="mb-1"><i class="fas fa-phone mr-2"></i><%= rs.getString("contact") %></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <!-- Personal Information -->
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <i class="fas fa-user mr-2"></i>Personal Information
                                </div>
                                <div class="card-body">
                                    <p><strong>Email:</strong> <%= rs.getString("email") %></p>
                                    <p><strong>Contact:</strong> <%= rs.getString("contact") %></p>
                                    <p><strong>Specialization:</strong> <%= rs.getString("specialization") %></p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Professional Information -->
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <i class="fas fa-briefcase mr-2"></i>Account Information
                                </div>
                                <div class="card-body">
                                    <p><strong>Account Created:</strong> <%= rs.getTimestamp("created_at") %></p>
                                    <p><strong>Last Updated:</strong> <%= new java.util.Date() %></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Edit Profile Modal -->
        <div class="modal fade" id="editProfileModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Edit Profile</h5>
                        <button type="button" class="close" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <form action="UpdateDoctorProfileServlet" method="POST">
                        <div class="modal-body">
                            <input type="hidden" name="doctorId" value="<%= doctorId %>">
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>First Name</label>
                                        <input type="text" name="fname" class="form-control" value="<%= rs.getString("fname") %>" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Last Name</label>
                                        <input type="text" name="lname" class="form-control" value="<%= rs.getString("lname") %>" required>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Email</label>
                                        <input type="email" name="email" class="form-control" value="<%= rs.getString("email") %>" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Contact</label>
                                        <input type="tel" name="contact" class="form-control" value="<%= rs.getString("contact") %>" required>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>Specialization</label>
                                <input type="text" name="specialization" class="form-control" value="<%= rs.getString("specialization") %>" required>
                            </div>
                            
                            <div class="form-group">
                                <label>Change Password</label>
                                <input type="password" name="password" class="form-control" placeholder="Leave blank to keep current password">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <%
                }
                rs.close();
                pst.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            }
        %>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
