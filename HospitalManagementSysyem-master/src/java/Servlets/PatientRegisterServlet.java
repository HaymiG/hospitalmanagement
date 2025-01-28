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

@WebServlet(name = "PatientRegisterServlet", urlPatterns = {"/PatientRegisterServlet"})
public class PatientRegisterServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String gender = request.getParameter("gender");
        int age = Integer.parseInt(request.getParameter("age"));
        String mobile = request.getParameter("mobile");
        String address = request.getParameter("address");
        
        try {
            Connection con = DatabaseConnection.initializeDatabase();
            
            // Check if email already exists
            String checkQuery = "SELECT COUNT(*) as count FROM patient WHERE email = ?";
            PreparedStatement checkStmt = con.prepareStatement(checkQuery);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();
            rs.next();
            
            if (rs.getInt("count") > 0) {
                response.sendRedirect("patientRegister.jsp?error=1"); // Email exists
                return;
            }
            
            // Insert new patient
            String insertQuery = "INSERT INTO patient (fname, lname, email, password, gender, age, mobile, address) " +
                               "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(insertQuery);
            pst.setString(1, fname);
            pst.setString(2, lname);
            pst.setString(3, email);
            pst.setString(4, password);
            pst.setString(5, gender);
            pst.setInt(6, age);
            pst.setString(7, mobile);
            pst.setString(8, address);
            
            int rowsAffected = pst.executeUpdate();
            
            if (rowsAffected > 0) {
                // Registration successful, create session and redirect to dashboard
                HttpSession session = request.getSession();
                session.setAttribute("patientEmail", email);
                session.setAttribute("patientName", fname + " " + lname);
                response.sendRedirect("UserHome.jsp");
            } else {
                response.sendRedirect("patientRegister.jsp?error=2"); // Registration failed
            }
            
            pst.close();
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("patientRegister.jsp?error=2");
        }
    }
}
