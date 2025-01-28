<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hospital Management System</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            body {
                background-image: url("img/Medical.jpg");
                background-size: cover;
                background-position: center;
                background-repeat: no-repeat;
                background-attachment: fixed;
                min-height: 100vh;
                padding: 50px 0;
            }
            .container {
                background-color: rgba(255, 255, 255, 0.9);
                padding: 30px;
                border-radius: 15px;
                margin-top: 20px;
            }
            .card {
                border: none;
                border-radius: 10px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
                transition: transform 0.3s;
                background-color: rgba(255, 255, 255, 0.95);
            }
            .card:hover {
                transform: translateY(-5px);
            }
            .card-title {
                color: #2c3e50;
                font-weight: bold;
            }
            .display-4 {
                color: #2c3e50;
                font-weight: bold;
            }
            .lead {
                color: #34495e;
            }
            .navbar {
                background-color: rgba(255, 255, 255, 0.95) !important;
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-md navbar-light bg-light">
            <a href="#" class="navbar-brand"> <img src="img/2855.jpeg"
                                                 height="30" alt="HMS">
            </a>
            <button type="button" class="navbar-toggler" data-toggle="collapse"
                    data-target="#navbarCollapse">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarCollapse">
                <div class="navbar-nav ml-auto">
                    <a href="index.jsp" class="nav-item nav-link active">Home</a>
                    <a href="doctorLogin.jsp" class="nav-item nav-link">Doctor Login</a>
                    <a href="adminLogin.jsp" class="nav-item nav-link">Admin</a>
                </div>
            </div>
        </nav>
        <div class="container">
            <div class="text-center mb-5">
                <h1 class="display-4">Hospital Management System</h1>
                <p class="lead">Welcome to our state-of-the-art healthcare management platform</p>
            </div>
            
            <div class="row justify-content-center">
                <div class="col-md-4">
                    <div class="card mb-4">
                        <div class="card-body text-center">
                            <i class="fas fa-user-injured fa-3x mb-3 text-primary"></i>
                            <h5 class="card-title">Patient Portal</h5>
                            <p class="card-text">Access your medical records, appointments, and prescriptions.</p>
                            <a href="patientLogin.jsp" class="btn btn-primary">Patient Login</a>
                            <p class="mt-2">New patient? <a href="patientRegistration.jsp">Register here</a></p>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="card mb-4">
                        <div class="card-body text-center">
                            <i class="fas fa-user-md fa-3x mb-3 text-success"></i>
                            <h5 class="card-title">Doctor Portal</h5>
                            <p class="card-text">Manage your appointments and patient records.</p>
                            <a href="doctorLogin.jsp" class="btn btn-success">Doctor Login</a>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="card mb-4">
                        <div class="card-body text-center">
                            <i class="fas fa-user-shield fa-3x mb-3 text-danger"></i>
                            <h5 class="card-title">Admin Portal</h5>
                            <p class="card-text">System administration and management.</p>
                            <a href="adminLogin.jsp" class="btn btn-danger">Admin Login</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>