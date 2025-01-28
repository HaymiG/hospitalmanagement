<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Billing Management</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.24/css/dataTables.bootstrap4.min.css">
        <style>
            .bill-card {
                margin-bottom: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .status-paid {
                color: #28a745;
                font-weight: bold;
            }
            .status-unpaid {
                color: #dc3545;
                font-weight: bold;
            }
            .search-box {
                margin-bottom: 20px;
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
            <div class="row mb-4">
                <div class="col-md-6">
                    <h2>Billing Management</h2>
                </div>
                <div class="col-md-6 text-right">
                    <button class="btn btn-primary" data-toggle="modal" data-target="#addBillModal">
                        <i class="fa fa-plus"></i> New Bill
                    </button>
                </div>
            </div>

            <!-- Summary Cards -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card bg-info text-white">
                        <div class="card-body">
                            <h5 class="card-title">Total Revenue</h5>
                            <%
                                try {
                                    Connection con = DatabaseConnection.initializeDatabase();
                                    Statement st = con.createStatement();
                                    ResultSet rs = st.executeQuery("SELECT SUM(amount) as total FROM billing WHERE status='Paid'");
                                    if(rs.next()) {
                                        double total = rs.getDouble("total");
                            %>
                            <h3>$<%= String.format("%.2f", total) %></h3>
                            <%
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
                <div class="col-md-4">
                    <div class="card bg-warning text-white">
                        <div class="card-body">
                            <h5 class="card-title">Pending Payments</h5>
                            <%
                                try {
                                    Connection con = DatabaseConnection.initializeDatabase();
                                    Statement st = con.createStatement();
                                    ResultSet rs = st.executeQuery("SELECT COUNT(*) as count FROM billing WHERE status='Unpaid'");
                                    if(rs.next()) {
                            %>
                            <h3><%= rs.getInt("count") %></h3>
                            <%
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
                <div class="col-md-4">
                    <div class="card bg-success text-white">
                        <div class="card-body">
                            <h5 class="card-title">Paid Bills</h5>
                            <%
                                try {
                                    Connection con = DatabaseConnection.initializeDatabase();
                                    Statement st = con.createStatement();
                                    ResultSet rs = st.executeQuery("SELECT COUNT(*) as count FROM billing WHERE status='Paid'");
                                    if(rs.next()) {
                            %>
                            <h3><%= rs.getInt("count") %></h3>
                            <%
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

            <!-- Billing Table -->
            <div class="card bill-card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table id="billingTable" class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Bill ID</th>
                                    <th>Patient Name</th>
                                    <th>Date</th>
                                    <th>Service</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        Connection con = DatabaseConnection.initializeDatabase();
                                        String query = "SELECT b.*, u.full_name FROM billing b " +
                                                     "LEFT JOIN user_profiles u ON b.patient_id = u.user_id " +
                                                     "ORDER BY b.bill_date DESC";
                                        Statement st = con.createStatement();
                                        ResultSet rs = st.executeQuery(query);
                                        
                                        while(rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getInt("bill_id") %></td>
                                    <td><%= rs.getString("full_name") %></td>
                                    <td><%= rs.getDate("bill_date") %></td>
                                    <td><%= rs.getString("service_description") %></td>
                                    <td>$<%= String.format("%.2f", rs.getDouble("amount")) %></td>
                                    <td>
                                        <span class="status-<%= rs.getString("status").toLowerCase() %>">
                                            <%= rs.getString("status") %>
                                        </span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-primary" onclick="viewBill(<%= rs.getInt("bill_id") %>)">
                                            <i class="fa fa-eye"></i>
                                        </button>
                                        <% if(rs.getString("status").equals("Unpaid")) { %>
                                        <button class="btn btn-sm btn-success" onclick="markAsPaid(<%= rs.getInt("bill_id") %>)">
                                            <i class="fa fa-check"></i>
                                        </button>
                                        <% } %>
                                        <button class="btn btn-sm btn-danger" onclick="deleteBill(<%= rs.getInt("bill_id") %>)">
                                            <i class="fa fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                                <%
                                        }
                                        rs.close();
                                        st.close();
                                        con.close();
                                    } catch(Exception e) {
                                        out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add Bill Modal -->
        <div class="modal fade" id="addBillModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Add New Bill</h5>
                        <button type="button" class="close" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <form action="AddBillServlet" method="POST">
                        <div class="modal-body">
                            <div class="form-group">
                                <label>Patient</label>
                                <select class="form-control" name="patientId" required>
                                    <option value="">Select Patient</option>
                                    <%
                                        try {
                                            Connection con = DatabaseConnection.initializeDatabase();
                                            Statement st = con.createStatement();
                                            ResultSet rs = st.executeQuery("SELECT user_id, full_name FROM user_profiles");
                                            while(rs.next()) {
                                    %>
                                    <option value="<%= rs.getInt("user_id") %>">
                                        <%= rs.getString("full_name") %>
                                    </option>
                                    <%
                                            }
                                            rs.close();
                                            st.close();
                                            con.close();
                                        } catch(Exception e) {
                                            out.println("<option>Error loading patients</option>");
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Service Description</label>
                                <input type="text" class="form-control" name="service" required>
                            </div>
                            <div class="form-group">
                                <label>Amount</label>
                                <input type="number" step="0.01" class="form-control" name="amount" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-primary">Add Bill</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.24/js/dataTables.bootstrap4.min.js"></script>
        
        <script>
            $(document).ready(function() {
                $('#billingTable').DataTable();
            });
            
            function viewBill(billId) {
                // Implement view bill details
                alert('Viewing bill ' + billId);
            }
            
            function markAsPaid(billId) {
                if(confirm('Mark this bill as paid?')) {
                    window.location.href = 'UpdateBillStatusServlet?billId=' + billId + '&status=Paid';
                }
            }
            
            function deleteBill(billId) {
                if(confirm('Are you sure you want to delete this bill?')) {
                    window.location.href = 'DeleteBillServlet?billId=' + billId;
                }
            }
        </script>
    </body>
</html>
