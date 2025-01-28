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
import javax.servlet.http.HttpSession;

@WebServlet(name = "UpdatePatientProfileServlet", urlPatterns = {"/UpdatePatientProfileServlet"})
public class UpdatePatientProfileServlet extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        String userId = session.getAttribute("userId").toString();
        
        // Get form data
        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String bloodGroup = request.getParameter("bloodGroup");
        String medicalHistory = request.getParameter("medicalHistory");
        String emergencyContactName = request.getParameter("emergencyContactName");
        String emergencyContactPhone = request.getParameter("emergencyContactPhone");
        
        try {
            Connection con = DatabaseConnection.initializeDatabase();
            
            // First update the patient table
            String query = "UPDATE patient SET " +
                          "fname=?, lname=?, phone=?, address=?, dob=?, " +
                          "gender=?, blood_group=?, medical_history=?, " +
                          "emergency_contact_name=?, emergency_contact_phone=?, " +
                          "profile_completed=1 " +
                          "WHERE id=?";
            
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, fname);
            pst.setString(2, lname);
            pst.setString(3, phone);
            pst.setString(4, address);
            pst.setString(5, dob);
            pst.setString(6, gender);
            pst.setString(7, bloodGroup);
            pst.setString(8, medicalHistory);
            pst.setString(9, emergencyContactName);
            pst.setString(10, emergencyContactPhone);
            pst.setString(11, userId);
            
            int rowsAffected = pst.executeUpdate();
            
            pst.close();
            con.close();
            
            if (rowsAffected > 0) {
                // Set profile completion status in session
                session.setAttribute("profileCompleted", true);
                response.sendRedirect("patientDashboard.jsp");
            } else {
                response.sendRedirect("patientProfile.jsp?status=error");
            }
            
        } catch(Exception e) {
            response.sendRedirect("patientProfile.jsp?status=error&message=" + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Updates patient profile information";
    }
}
