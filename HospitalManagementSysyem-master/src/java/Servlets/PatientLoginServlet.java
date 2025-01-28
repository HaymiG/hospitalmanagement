package Servlets;

import Database.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "PatientLoginServlet", urlPatterns = {"/PatientLoginServlet"})
public class PatientLoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        try {
            Connection con = DatabaseConnection.initializeDatabase();
            
            // First check if the patient exists and get their ID
            String query = "SELECT * FROM patient WHERE email = ? AND password = ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, email);
            pst.setString(2, password);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                // Login successful
                HttpSession session = request.getSession();
                int patientId = rs.getInt("id");
                session.setAttribute("patientId", patientId);
                session.setAttribute("patientEmail", email);
                session.setAttribute("patientName", rs.getString("fname") + " " + rs.getString("lname"));
                
                // Check if profile is complete
                String profileQuery = "SELECT * FROM patient WHERE id = ? AND fname IS NOT NULL AND lname IS NOT NULL";
                PreparedStatement profileStmt = con.prepareStatement(profileQuery);
                profileStmt.setInt(1, patientId);
                ResultSet profileRs = profileStmt.executeQuery();
                
                if (profileRs.next()) {
                    response.sendRedirect("patientDashboard.jsp");
                } else {
                    response.sendRedirect("patientProfile.jsp");
                }
                
                profileRs.close();
                profileStmt.close();
            } else {
                // Login failed
                response.sendRedirect("patientLogin.jsp?error=1");
            }
            
            rs.close();
            pst.close();
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("patientLogin.jsp?error=1");
        }
    }
}
