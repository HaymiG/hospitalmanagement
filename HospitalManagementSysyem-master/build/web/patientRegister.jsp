<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Patient Registration</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <style>
            .register-container {
                max-width: 600px;
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
                        <li class="nav-item">
                            <a class="nav-link" href="patientLogin.jsp">Patient Login</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container register-container">
            <div class="card">
                <div class="card-header text-center">
                    <h4>Patient Registration</h4>
                </div>
                <div class="card-body">
                    <%-- Display error message if any --%>
                    <% String error = request.getParameter("error");
                       if (error != null) { %>
                        <div class="alert alert-danger" role="alert">
                            <%= error.equals("1") ? "Email already exists. Please use a different email." : "Registration failed. Please try again." %>
                        </div>
                    <% } %>
                    
                    <form action="PatientRegisterServlet" method="POST">
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="fname">First Name</label>
                                <input type="text" class="form-control" id="fname" name="fname" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="lname">Last Name</label>
                                <input type="text" class="form-control" id="lname" name="lname" required>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="email">Email</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="password">Password</label>
                                <input type="password" class="form-control" id="password" name="password" 
                                       required minlength="6">
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="gender">Gender</label>
                                <select class="form-control" id="gender" name="gender" required>
                                    <option value="">Choose...</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="age">Age</label>
                                <input type="number" class="form-control" id="age" name="age" 
                                       required min="0" max="150">
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="mobile">Mobile Number</label>
                                <input type="tel" class="form-control" id="mobile" name="mobile" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="address">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="1" required></textarea>
                            </div>
                        </div>
                        
                        <button type="submit" class="btn btn-success btn-block">Register</button>
                    </form>
                    <div class="text-center mt-3">
                        <p>Already have an account? <a href="patientLogin.jsp">Login here</a></p>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
