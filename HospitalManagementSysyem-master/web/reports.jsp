<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hospital Reports</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            .report-card {
                margin-bottom: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .chart-container {
                position: relative;
                margin: auto;
                height: 300px;
                width: 100%;
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
            <h2 class="mb-4">Hospital Statistics and Reports</h2>
            
            <div class="row">
                <!-- Summary Cards -->
                <div class="col-md-3">
                    <div class="card report-card bg-primary text-white">
                        <div class="card-body">
                            <h5 class="card-title">Total Patients</h5>
                            <%
                                try {
                                    Connection con = DatabaseConnection.initializeDatabase();
                                    Statement st = con.createStatement();
                                    ResultSet rs = st.executeQuery("SELECT COUNT(*) as count FROM user_profiles");
                                    if(rs.next()) {
                                        out.println("<h3>" + rs.getInt("count") + "</h3>");
                                    }
                                    rs.close();
                                    st.close();
                                    con.close();
                                } catch(Exception e) {
                                    out.println("<h3>Error</h3>");
                                }
                            %>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-3">
                    <div class="card report-card bg-success text-white">
                        <div class="card-body">
                            <h5 class="card-title">Total Appointments</h5>
                            <%
                                try {
                                    Connection con = DatabaseConnection.initializeDatabase();
                                    Statement st = con.createStatement();
                                    ResultSet rs = st.executeQuery("SELECT COUNT(*) as count FROM appointments");
                                    if(rs.next()) {
                                        out.println("<h3>" + rs.getInt("count") + "</h3>");
                                    }
                                    rs.close();
                                    st.close();
                                    con.close();
                                } catch(Exception e) {
                                    out.println("<h3>Error</h3>");
                                }
                            %>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-3">
                    <div class="card report-card bg-warning text-white">
                        <div class="card-body">
                            <h5 class="card-title">Pending Appointments</h5>
                            <%
                                try {
                                    Connection con = DatabaseConnection.initializeDatabase();
                                    Statement st = con.createStatement();
                                    ResultSet rs = st.executeQuery("SELECT COUNT(*) as count FROM appointments WHERE status='Pending'");
                                    if(rs.next()) {
                                        out.println("<h3>" + rs.getInt("count") + "</h3>");
                                    }
                                    rs.close();
                                    st.close();
                                    con.close();
                                } catch(Exception e) {
                                    out.println("<h3>Error</h3>");
                                }
                            %>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-3">
                    <div class="card report-card bg-info text-white">
                        <div class="card-body">
                            <h5 class="card-title">Total Prescriptions</h5>
                            <%
                                try {
                                    Connection con = DatabaseConnection.initializeDatabase();
                                    Statement st = con.createStatement();
                                    ResultSet rs = st.executeQuery("SELECT COUNT(*) as count FROM prescriptions");
                                    if(rs.next()) {
                                        out.println("<h3>" + rs.getInt("count") + "</h3>");
                                    }
                                    rs.close();
                                    st.close();
                                    con.close();
                                } catch(Exception e) {
                                    out.println("<h3>Error</h3>");
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts -->
            <div class="row mt-4">
                <div class="col-md-6">
                    <div class="card report-card">
                        <div class="card-body">
                            <h5 class="card-title">Appointments by Status</h5>
                            <div class="chart-container">
                                <canvas id="appointmentChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <div class="card report-card">
                        <div class="card-body">
                            <h5 class="card-title">Recent Activity</h5>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Activity</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            try {
                                                Connection con = DatabaseConnection.initializeDatabase();
                                                Statement st = con.createStatement();
                                                ResultSet rs = st.executeQuery(
                                                    "SELECT appointment_date as date, 'New Appointment' as activity FROM appointments " +
                                                    "ORDER BY appointment_date DESC LIMIT 5"
                                                );
                                                while(rs.next()) {
                                        %>
                                        <tr>
                                            <td><%= rs.getDate("date") %></td>
                                            <td><%= rs.getString("activity") %></td>
                                        </tr>
                                        <%
                                                }
                                                rs.close();
                                                st.close();
                                                con.close();
                                            } catch(Exception e) {
                                                out.println("<tr><td colspan='2'>Error loading activities</td></tr>");
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
        
        <script>
            // Appointments Chart
            var ctx = document.getElementById('appointmentChart').getContext('2d');
            <%
                try {
                    Connection con = DatabaseConnection.initializeDatabase();
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery(
                        "SELECT status, COUNT(*) as count FROM appointments GROUP BY status"
                    );
                    
                    StringBuilder labels = new StringBuilder("[");
                    StringBuilder data = new StringBuilder("[");
                    
                    while(rs.next()) {
                        if(labels.length() > 1) {
                            labels.append(",");
                            data.append(",");
                        }
                        labels.append("'").append(rs.getString("status")).append("'");
                        data.append(rs.getInt("count"));
                    }
                    
                    labels.append("]");
                    data.append("]");
                    
                    rs.close();
                    st.close();
                    con.close();
            %>
            var myChart = new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: <%= labels.toString() %>,
                    datasets: [{
                        data: <%= data.toString() %>,
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.8)',
                            'rgba(54, 162, 235, 0.8)',
                            'rgba(255, 206, 86, 0.8)'
                        ]
                    }]
                }
            });
            <%
                } catch(Exception e) {
                    out.println("console.error('Error loading chart data');");
                }
            %>
        </script>
    </body>
</html>
