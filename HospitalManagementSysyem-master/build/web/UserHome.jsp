<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Dashboard - Hospital Management System</title>
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
                margin-bottom: 20px;
            }
            .card:hover {
                transform: scale(1.05);
            }
            .card-body {
                text-align: center;
            }
            .card-icon {
                font-size: 3em;
                margin-bottom: 15px;
                display: block;
            }
        </style>
    </head>
    <body>
        <%
            // Check if patient is logged in
            String patientEmail = (String) session.getAttribute("patientEmail");
            String patientName = (String) session.getAttribute("patientName");
            if (patientEmail == null) {
                response.sendRedirect("patientLogin.jsp");
                return;
            }
        %>
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-success fixed-top">
            <div class="container">
                <a class="navbar-brand" href="#">Hospital Management System</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarResponsive">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item">
                            <span class="nav-link">Welcome, <%= patientName %></span>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="logout.jsp">Logout</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- User Dashboard -->
        <div class="container" style="margin-top: 80px;">
            <div class="row">
                <!-- View Appointments -->
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <i class="fa fa-calendar card-icon text-primary"></i>
                            <h5 class="card-title">My Appointments</h5>
                            <p class="card-text">View and manage your appointments</p>
                            <a href="viewAppointments.jsp" class="btn btn-primary">View Appointments</a>
                        </div>
                    </div>
                </div>
                
                <!-- Medical Records -->
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <i class="fa fa-file-text-o card-icon text-success"></i>
                            <h5 class="card-title">Medical Records</h5>
                            <p class="card-text">Access your medical history</p>
                            <a href="medicalRecords.jsp" class="btn btn-success">View Records</a>
                        </div>
                    </div>
                </div>
                
                <!-- Book Appointment -->
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <i class="fa fa-plus-circle card-icon text-info"></i>
                            <h5 class="card-title">Book Appointment</h5>
                            <p class="card-text">Schedule a new appointment</p>
                            <a href="bookAppointment.jsp" class="btn btn-info">Book Now</a>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <!-- Prescriptions -->
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <i class="fa fa-list-alt card-icon text-warning"></i>
                            <h5 class="card-title">Prescriptions</h5>
                            <p class="card-text">View your prescriptions</p>
                            <a href="viewPrescriptions.jsp" class="btn btn-warning">View Prescriptions</a>
                        </div>
                    </div>
                </div>
                
                <!-- Profile -->
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <i class="fa fa-user card-icon text-secondary"></i>
                            <h5 class="card-title">My Profile</h5>
                            <p class="card-text">View and update your profile</p>
                            <a href="patientProfile.jsp" class="btn btn-secondary">View Profile</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
