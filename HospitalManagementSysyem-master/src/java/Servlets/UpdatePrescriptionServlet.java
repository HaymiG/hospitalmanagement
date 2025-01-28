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

@WebServlet(name = "UpdatePrescriptionServlet", urlPatterns = {"/UpdatePrescriptionServlet"})
public class UpdatePrescriptionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        String action = request.getParameter("action");
        
        try {
            Connection con = DatabaseConnection.initializeDatabase();
            
            if ("complete".equals(action)) {
                String query = "UPDATE prescriptions SET status = 'completed' WHERE id = ?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, id);
                pst.executeUpdate();
                pst.close();
            }
            
            con.close();
            response.sendRedirect("prescriptions.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("prescriptions.jsp?error=true");
        }
    }
}
