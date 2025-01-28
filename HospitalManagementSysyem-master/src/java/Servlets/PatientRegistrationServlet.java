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

@WebServlet(name = "PatientRegistrationServlet", urlPatterns = {"/PatientRegistrationServlet"})
public class PatientRegistrationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String gender = request.getParameter("gender");
        String age = request.getParameter("age");
        String mobile = request.getParameter("mobile");
        String address = request.getParameter("address");
        
        try {
            Connection con = DatabaseConnection.initializeDatabase();
            
            // First check if email already exists
            String checkQuery = "SELECT COUNT(*) as count FROM patient WHERE email = ?";
            PreparedStatement checkStmt = con.prepareStatement(checkQuery);
            checkStmt.setString(1, email);
            java.sql.ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next() && rs.getInt("count") > 0) {
                checkStmt.close();
                rs.close();
                con.close();
                response.sendRedirect("patientRegistration.jsp?error=Email already exists");
                return;
            }
            checkStmt.close();
            rs.close();
            
            // Insert the new patient
            String query = "INSERT INTO patient (fname, lname, email, password, gender, mobile, address) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            
            pst.setString(1, fname);
            pst.setString(2, lname);
            pst.setString(3, email);
            pst.setString(4, password);
            pst.setString(5, gender);
            pst.setString(6, mobile);
            pst.setString(7, address);
            
            int result = pst.executeUpdate();
            pst.close();
            con.close();
            
            if (result > 0) {
                // Redirect to login page after successful registration
                response.sendRedirect("patientLogin.jsp?success=Registration successful! Please login.");
            } else {
                response.sendRedirect("patientRegistration.jsp?error=Registration failed. Please try again.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("patientRegistration.jsp?error=" + e.getMessage());
        }
    }
}
