<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Patient Login</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <style>
            .login-container {
                max-width: 400px;
                margin: 100px auto;
            }
            .card {
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }
            .card-header {
                background-color: #28a745;
                color: white;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-success">
            <div class="container">
                <a class="navbar-brand" href="index.jsp">Hospital Management System</a>
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
                        <li class="nav-item active">
                            <a class="nav-link" href="patientLogin.jsp">Patient Login</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container login-container">
            <div class="card">
                <div class="card-header text-center">
                    <h4>Patient Login</h4>
                </div>
                <div class="card-body">
                    <%-- Display error message if any --%>
                    <% String error = request.getParameter("error");
                       if (error != null && error.equals("1")) { %>
                        <div class="alert alert-danger" role="alert">
                            Invalid email or password. Please try again.
                        </div>
                    <% } %>
                    
                    <form action="PatientLoginServlet" method="POST">
                        <div class="form-group">
                            <label for="email">Email address</label>
                            <input type="email" class="form-control" id="email" name="email" 
                                   placeholder="Enter email" required>
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" class="form-control" id="password" name="password" 
                                   placeholder="Password" required>
                        </div>
                        <button type="submit" class="btn btn-success btn-block">Login</button>
                    </form>
                    <div class="text-center mt-3">
                        <p>Don't have an account? <a href="patientRegistration.jsp">Register here</a></p>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
