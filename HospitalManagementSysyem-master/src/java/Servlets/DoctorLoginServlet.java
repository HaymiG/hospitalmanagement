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

@WebServlet(name = "DoctorLoginServlet", urlPatterns = {"/DoctorLoginServlet"})
public class DoctorLoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        try {
            Connection con = DatabaseConnection.initializeDatabase();
            
            // Check if the doctor exists and get their details
            String query = "SELECT * FROM doctor WHERE email = ? AND password = ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, email);
            pst.setString(2, password);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                // Login successful
                HttpSession session = request.getSession();
                session.setAttribute("doctorId", rs.getInt("id"));
                session.setAttribute("doctorEmail", email);
                session.setAttribute("doctorName", rs.getString("fname") + " " + rs.getString("lname"));
                session.setAttribute("specialization", rs.getString("specialization"));
                
                // Redirect to doctor dashboard
                response.sendRedirect("doctorDashboard.jsp");
            } else {
                // Login failed
                response.sendRedirect("doctorLogin.jsp?status=invalid");
            }
            
            rs.close();
            pst.close();
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("doctorLogin.jsp?status=error");
        }
    }
}
