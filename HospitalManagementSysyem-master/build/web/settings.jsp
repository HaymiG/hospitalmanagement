<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>System Settings</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <style>
            .settings-card {
                margin-bottom: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .settings-section {
                border-bottom: 1px solid #eee;
                padding: 20px 0;
            }
            .settings-section:last-child {
                border-bottom: none;
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-success">
            <div class="container">
                <a class="navbar-brand" href="AdminHome.jsp">Hospital Management System</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="AdminHome.jsp">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="logout.jsp">Logout</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container mt-5">
            <h2 class="mb-4">System Settings</h2>
            
            <div class="row">
                <div class="col-md-8 offset-md-2">
                    <!-- Hospital Information -->
                    <div class="card settings-card">
                        <div class="card-body">
                            <h5 class="card-title">Hospital Information</h5>
                            <form action="UpdateSettingsServlet" method="POST">
                                <div class="settings-section">
                                    <div class="form-group">
                                        <label>Hospital Name</label>
                                        <input type="text" class="form-control" name="hospitalName" 
                                               value="City General Hospital" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Contact Email</label>
                                        <input type="email" class="form-control" name="contactEmail" 
                                               value="contact@hospital.com" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Contact Phone</label>
                                        <input type="tel" class="form-control" name="contactPhone" 
                                               value="123-456-7890" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Address</label>
                                        <textarea class="form-control" name="address" 
                                                  rows="3" required>123 Hospital Street, Medical District, City</textarea>
                                    </div>
                                </div>

                                <!-- System Settings -->
                                <div class="settings-section">
                                    <h5 class="mb-3">System Settings</h5>
                                    <div class="form-group">
                                        <label>Appointment Time Slot Duration (minutes)</label>
                                        <select class="form-control" name="timeSlotDuration">
                                            <option value="15">15 minutes</option>
                                            <option value="30" selected>30 minutes</option>
                                            <option value="45">45 minutes</option>
                                            <option value="60">60 minutes</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Working Hours</label>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <label>Start Time</label>
                                                <input type="time" class="form-control" name="workingHoursStart" 
                                                       value="09:00" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label>End Time</label>
                                                <input type="time" class="form-control" name="workingHoursEnd" 
                                                       value="17:00" required>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Email Settings -->
                                <div class="settings-section">
                                    <h5 class="mb-3">Email Notifications</h5>
                                    <div class="form-group">
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" 
                                                   id="appointmentNotifications" name="appointmentNotifications" checked>
                                            <label class="custom-control-label" for="appointmentNotifications">
                                                Send appointment reminders
                                            </label>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" 
                                                   id="prescriptionNotifications" name="prescriptionNotifications" checked>
                                            <label class="custom-control-label" for="prescriptionNotifications">
                                                Send prescription notifications
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <div class="text-right mt-4">
                                    <button type="submit" class="btn btn-primary">Save Changes</button>
                                    <a href="AdminHome.jsp" class="btn btn-secondary ml-2">Cancel</a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Backup & Maintenance -->
                    <div class="card settings-card">
                        <div class="card-body">
                            <h5 class="card-title">Backup & Maintenance</h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <button class="btn btn-warning btn-block mb-3">
                                        <i class="fa fa-database mr-2"></i>Backup Database
                                    </button>
                                </div>
                                <div class="col-md-6">
                                    <button class="btn btn-info btn-block mb-3">
                                        <i class="fa fa-refresh mr-2"></i>Clear Cache
                                    </button>
                                </div>
                            </div>
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
