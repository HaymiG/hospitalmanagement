<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Login - Hospital Management System</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <style>
            body {
                background: url('images/medical-bg.jpg') no-repeat center center fixed;
                background-size: cover;
                height: 100vh;
            }
            .login-container {
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.1);
                max-width: 400px;
                width: 90%;
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
            }
            .login-header {
                text-align: center;
                color: #666;
                margin-bottom: 30px;
            }
            .form-control {
                background-color: #f8f9fa;
                border: none;
                border-radius: 5px;
                padding: 15px;
                margin-bottom: 20px;
            }
            .btn-login {
                background-color: #5bc0de;
                color: white;
                padding: 12px;
                border: none;
                border-radius: 5px;
                width: 100%;
                font-weight: bold;
                margin-top: 10px;
            }
            .btn-login:hover {
                background-color: #46b8da;
                color: white;
            }
            .create-account {
                text-align: center;
                margin-top: 20px;
            }
            .create-account a {
                color: #5bc0de;
                text-decoration: none;
            }
            .navbar {
                background-color: transparent !important;
            }
            .navbar-brand {
                color: #333 !important;
            }
            .nav-link {
                color: #333 !important;
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg">
            <div class="container">
                <a class="navbar-brand" href="index.jsp">
                    <img src="images/hms-logo.png" height="30" alt="HMS Logo">
                </a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ml-auto">
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

        <div class="login-container">
            <div class="login-header">
                <h3>USER LOGIN</h3>
            </div>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger">Invalid username or password</div>
            <% } %>
            
            <form action="UserLoginServlet" method="POST">
                <input type="text" class="form-control" name="username" placeholder="Username" required>
                <input type="password" class="form-control" name="password" placeholder="Password" required>
                <button type="submit" class="btn btn-login">LOG IN</button>
            </form>
            
            <div class="create-account">
                <a href="userRegister.jsp">Create Account</a>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
