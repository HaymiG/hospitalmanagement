package Servlets;

import Database.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "MarkAllReadServlet", urlPatterns = {"/MarkAllReadServlet"})
public class MarkAllReadServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String doctorId = request.getParameter("doctorId");
        
        try {
            Connection con = DatabaseConnection.initializeDatabase();
            String query = "UPDATE notifications SET is_read = true " +
                         "WHERE user_id = ? AND user_type = 'doctor'";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, doctorId);
            pst.executeUpdate();
            pst.close();
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect("notifications.jsp");
    }
}
