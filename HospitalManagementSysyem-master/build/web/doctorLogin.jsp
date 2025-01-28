<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hospital Management System</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <style>
            body {
                margin: 0;
                padding: 0;
                min-height: 100vh;
                background: url('img/Medical.jpg') center/cover no-repeat;
            }

            .navbar {
                background-color: white !important;
                padding: 0.5rem 1rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .navbar-brand img {
                height: 40px;
            }

            .nav-link {
                color: #333 !important;
                font-weight: 500;
            }

            .main-heading {
                color: white;
                font-size: 2.5rem;
                font-weight: bold;
                text-align: center;
                margin: 2rem 0;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            }

            .login-section {
                padding: 2rem;
                margin-left: 5rem;
            }

            .login-box {
                background: white;
                padding: 2rem;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.2);
                max-width: 400px;
            }

            .login-title {
                color: #666;
                font-size: 1.5rem;
                margin-bottom: 1.5rem;
                text-align: center;
            }

            .form-control {
                background-color: #f8f9fa;
                border: 1px solid #ddd;
                padding: 0.75rem;
                margin-bottom: 1rem;
            }

            .btn-login {
                background-color: #007bff;
                color: white;
                padding: 0.75rem;
                width: 100%;
                border: none;
                border-radius: 5px;
                font-weight: 500;
                margin-top: 1rem;
            }

            .create-account {
                text-align: center;
                margin-top: 1rem;
            }

            .create-account a {
                color: #007bff;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <!-- Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-light">
            <div class="container">
                <a class="navbar-brand" href="index.jsp">
                    <img src="images/hms-logo.png" alt="HMS Logo">
                </a>
                <div class="ml-auto">
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a class="nav-link" href="index.jsp">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="doctorLogin.jsp">Doctor Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="admin.jsp">Admin</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="container">
            <h1 class="main-heading">Hospital Management System</h1>
            
            <div class="login-section">
                <div class="login-box">
                    <h2 class="login-title">DOCTOR LOGIN</h2>
                    
                    <% 
                        String status = request.getParameter("status");
                        if (status != null) {
                            if (status.equals("invalid")) {
                    %>
                        <div class="alert alert-danger text-center">
                            Invalid email or password
                        </div>
                    <% 
                            } else if (status.equals("error")) {
                    %>
                        <div class="alert alert-danger text-center">
                            Database connection error. Please try again later.
                        </div>
                    <% 
                            }
                        }
                    %>
                    
                    <form action="${pageContext.request.contextPath}/DoctorLoginServlet" method="POST">
                        <div class="form-group">
                            <input type="email" class="form-control" name="email" placeholder="Email" required>
                        </div>
                        <div class="form-group">
                            <input type="password" class="form-control" name="password" placeholder="Password" required>
                        </div>
                        <button type="submit" class="btn btn-login">LOG IN</button>
                    </form>
                    
                    <div class="create-account">
                        <a href="forgotPassword.jsp">Forgot Password?</a>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
