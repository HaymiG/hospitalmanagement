<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Database.DatabaseConnection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Patient Notifications</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <style>
            .notification-card {
                margin-bottom: 15px;
                border-left: 4px solid #28a745;
            }
            .unread {
                background-color: #f8f9fa;
            }
            .notification-time {
                color: #6c757d;
                font-size: 0.85rem;
            }
        </style>
    </head>
    <body>
        <%
            String patientId = session.getAttribute("patientId") != null ? 
                session.getAttribute("patientId").toString() : null;
            
            if (patientId == null) {
                response.sendRedirect("patientLogin.jsp");
                return;
            }
        %>
        
        <div class="container mt-4">
            <h2>My Notifications</h2>
            
            <div class="mt-4">
                <%
                    try {
                        Connection con = DatabaseConnection.initializeDatabase();
                        String query = "SELECT * FROM notifications WHERE user_id = ? AND user_type = 'patient' " +
                                     "ORDER BY created_at DESC";
                        
                        PreparedStatement pst = con.prepareStatement(query);
                        pst.setString(1, patientId);
                        ResultSet rs = pst.executeQuery();
                        
                        boolean hasNotifications = false;
                        while (rs.next()) {
                            hasNotifications = true;
                            boolean isUnread = rs.getBoolean("is_read") == false;
                %>
                            <div class="card notification-card <%= isUnread ? "unread" : "" %>">
                                <div class="card-body">
                                    <h5 class="card-title"><%= rs.getString("title") %></h5>
                                    <p class="card-text"><%= rs.getString("message") %></p>
                                    <p class="notification-time">
                                        <%= rs.getTimestamp("created_at") %>
                                        <% if (isUnread) { %>
                                            <span class="badge badge-success ml-2">New</span>
                                        <% } %>
                                    </p>
                                </div>
                            </div>
                <%
                        }
                        
                        if (!hasNotifications) {
                %>
                            <div class="alert alert-info">
                                No notifications found.
                            </div>
                <%
                        }
                        
                        // Mark all notifications as read
                        String updateQuery = "UPDATE notifications SET is_read = true " +
                                           "WHERE user_id = ? AND user_type = 'patient' AND is_read = false";
                        PreparedStatement updatePst = con.prepareStatement(updateQuery);
                        updatePst.setString(1, patientId);
                        updatePst.executeUpdate();
                        
                        rs.close();
                        pst.close();
                        updatePst.close();
                        con.close();
                        
                    } catch (Exception e) {
                        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                    }
                %>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    </body>
</html>
