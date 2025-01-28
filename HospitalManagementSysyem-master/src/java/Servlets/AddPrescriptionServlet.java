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

@WebServlet(name = "AddPrescriptionServlet", urlPatterns = {"/AddPrescriptionServlet"})
public class AddPrescriptionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Connection con = DatabaseConnection.initializeDatabase();
            
            String query = "INSERT INTO prescriptions (patient_id, doctor_id, medication_name, dosage, " +
                         "frequency, start_date, end_date, notes, status) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'active')";
            
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, request.getParameter("patientId"));
            pst.setString(2, request.getParameter("doctorId"));
            pst.setString(3, request.getParameter("medicationName"));
            pst.setString(4, request.getParameter("dosage"));
            pst.setString(5, request.getParameter("frequency"));
            pst.setString(6, request.getParameter("startDate"));
            pst.setString(7, request.getParameter("endDate"));
            pst.setString(8, request.getParameter("notes"));
            
            pst.executeUpdate();
            pst.close();
            con.close();
            
            // Redirect back to prescriptions page
            String patientId = request.getParameter("patientId");
            if (patientId != null && !patientId.isEmpty()) {
                response.sendRedirect("prescriptions.jsp?patientId=" + patientId);
            } else {
                response.sendRedirect("prescriptions.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("prescriptions.jsp?error=true");
        }
    }
}
