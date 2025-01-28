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

@WebServlet(name = "PrescribeMedicineServlet", urlPatterns = {"/PrescribeMedicineServlet"})
public class PrescribeMedicineServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get form parameters
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String medicineName = request.getParameter("medicineName");
            String dosage = request.getParameter("dosage");
            String frequency = request.getParameter("frequency");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String notes = request.getParameter("notes");
            
            Connection con = DatabaseConnection.initializeDatabase();
            
            // Insert prescription
            String query = "INSERT INTO prescriptions (patient_id, doctor_id, medication_name, " +
                         "dosage, frequency, start_date, end_date, status, notes) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, 'active', ?)";
            
            PreparedStatement pst = con.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS);
            pst.setInt(1, patientId);
            pst.setInt(2, doctorId);
            pst.setString(3, medicineName);
            pst.setString(4, dosage);
            pst.setString(5, frequency);
            pst.setString(6, startDate);
            pst.setString(7, endDate);
            pst.setString(8, notes);
            
            pst.executeUpdate();
            
            ResultSet rs = pst.getGeneratedKeys();
            int prescriptionId = 0;
            if (rs.next()) {
                prescriptionId = rs.getInt(1);
            }
            
            // Create notification for patient
            String notifQuery = "INSERT INTO notifications (user_id, user_type, title, message) " +
                              "VALUES (?, 'patient', 'New Prescription', ?)";
            PreparedStatement notifPst = con.prepareStatement(notifQuery);
            notifPst.setInt(1, patientId);
            notifPst.setString(2, "You have been prescribed " + medicineName + ". Check your prescriptions for details.");
            notifPst.executeUpdate();
            
            rs.close();
            pst.close();
            notifPst.close();
            con.close();
            
            response.sendRedirect("doctorDashboard.jsp?success=1");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("doctorDashboard.jsp?error=1");
        }
    }
}
