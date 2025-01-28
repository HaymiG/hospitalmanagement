<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard - Hospital Management System</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
        <style>
            .dashboard-header {
                padding: 100px 0;
                background-color: #f8f9fa;
            }
            .card {
                transition: transform .2s;
            }
            .card:hover {
                transform: scale(1.05);
            }
            .card-body {
                text-align: center;
            }
            .btn-primary {
                background-color: #007bff;
                border: none;
                padding: 8px 20px;
            }
            .btn-primary:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top">
            <div class="container">
                <a class="navbar-brand" href="#">Hospital Management System - Admin Panel</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarResponsive">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item">
                            <span class="nav-link">Welcome, <%=session.getAttribute("adminUsername")%></span>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="logout.jsp">Logout</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
        <%
            // Check if user is logged in as admin
            if (session.getAttribute("adminUsername") == null) {
                response.sendRedirect("adminLogin.jsp");
                return;
            }
        %>
        <!-- Admin Dashboard -->
        <div class="container" style="margin-top: 80px;">
            <div class="row">
                <!-- Doctor Management -->
                <div class="col-md-4">
                    <div class="card admin-card">
                        <div class="card-body text-center">
                            <i class="fa fa-user-md card-icon text-primary"></i>
                            <h5 class="card-title">Doctor Management</h5>
                            <p class="card-text">Add, view, and manage hospital doctors</p>
                            <a href="addDoctor.jsp" class="btn btn-primary">Add Doctor</a>
                            <a href="adminDoctorList.jsp" class="btn btn-outline-primary mt-2">View Doctors</a>
                        </div>
                    </div>
                </div>
                
                <!-- Patient Management -->
                <div class="col-md-4">
                    <div class="card admin-card">
                        <div class="card-body text-center">
                            <i class="fa fa-users card-icon text-success"></i>
                            <h5 class="card-title">Patient Management</h5>
                            <p class="card-text">View and manage patient records</p>
                            <a href="listPatient.jsp" class="btn btn-success">View Patients</a>
                        </div>
                    </div>
                </div>
                
                <!-- Staff Management -->
                <div class="col-md-4">
                    <div class="card admin-card">
                        <div class="card-body text-center">
                            <i class="fa fa-id-card card-icon text-info"></i>
                            <h5 class="card-title">Staff Management</h5>
                            <p class="card-text">Manage hospital staff and workers</p>
                            <a href="addRecp.jsp" class="btn btn-info">Add Staff</a>
                            <a href="adminRecpList.jsp" class="btn btn-outline-info mt-2">View Staff</a>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row mt-4">
                <!-- Reports -->
                <div class="col-md-4">
                    <div class="card admin-card">
                        <div class="card-body text-center">
                            <i class="fa fa-chart-bar card-icon text-warning"></i>
                            <h5 class="card-title">Reports</h5>
                            <p class="card-text">View hospital statistics and reports</p>
                            <a href="reports.jsp" class="btn btn-warning">View Reports</a>
                        </div>
                    </div>
                </div>
                
                <!-- Settings -->
                <div class="col-md-4">
                    <div class="card admin-card">
                        <div class="card-body text-center">
                            <i class="fa fa-cog card-icon text-secondary"></i>
                            <h5 class="card-title">Settings</h5>
                            <p class="card-text">Configure system settings</p>
                            <a href="settings.jsp" class="btn btn-secondary">Manage Settings</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
