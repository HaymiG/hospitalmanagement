<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Patient Registration - Hospital Management System</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <style>
            body {
                background: url('img/Medical.jpg') center/cover no-repeat;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            .registration-card {
                background: white;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.2);
                width: 100%;
                max-width: 800px;
                margin: 20px;
            }
            .card-header {
                background: #28a745;
                color: white;
                padding: 20px;
                text-align: center;
                border-radius: 10px 10px 0 0;
            }
            .card-body {
                padding: 30px;
            }
            .form-group label {
                font-weight: 500;
                color: #333;
            }
            .form-control {
                border: 1px solid #ddd;
                border-radius: 5px;
                padding: 8px 15px;
            }
            .form-control:focus {
                border-color: #28a745;
                box-shadow: 0 0 5px rgba(40, 167, 69, 0.2);
            }
            .btn-register {
                background: #28a745;
                color: white;
                padding: 10px 30px;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                font-weight: 500;
                width: 100%;
            }
            .btn-register:hover {
                background: #218838;
                color: white;
            }
            .required::after {
                content: "*";
                color: red;
                margin-left: 4px;
            }
        </style>
    </head>
    <body>
        <div class="registration-card">
            <div class="card-header">
                <h2>Patient Registration</h2>
                <p class="mb-0">Please fill in your details to complete registration</p>
            </div>
            <div class="card-body">
                <form action="UpdatePatientProfileServlet" method="POST">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="required">First Name</label>
                                <input type="text" class="form-control" name="fname" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="required">Last Name</label>
                                <input type="text" class="form-control" name="lname" required>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="required">Date of Birth</label>
                                <input type="date" class="form-control" name="dob" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="required">Gender</label>
                                <select class="form-control" name="gender" required>
                                    <option value="">Select Gender</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="required">Phone Number</label>
                                <input type="tel" class="form-control" name="phone" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="required">Blood Group</label>
                                <select class="form-control" name="bloodGroup" required>
                                    <option value="">Select Blood Group</option>
                                    <option value="A+">A+</option>
                                    <option value="A-">A-</option>
                                    <option value="B+">B+</option>
                                    <option value="B-">B-</option>
                                    <option value="AB+">AB+</option>
                                    <option value="AB-">AB-</option>
                                    <option value="O+">O+</option>
                                    <option value="O-">O-</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="required">Address</label>
                        <textarea class="form-control" name="address" rows="2" required></textarea>
                    </div>

                    <div class="form-group">
                        <label>Medical History</label>
                        <textarea class="form-control" name="medicalHistory" rows="2" 
                                placeholder="Please mention any existing medical conditions, allergies, or ongoing medications"></textarea>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="required">Emergency Contact Name</label>
                                <input type="text" class="form-control" name="emergencyContactName" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="required">Emergency Contact Phone</label>
                                <input type="tel" class="form-control" name="emergencyContactPhone" required>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-register mt-3">Complete Registration</button>
                </form>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
