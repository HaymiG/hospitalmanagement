package Servlets;

import Database.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BookAppointmentServlet", urlPatterns = {"/BookAppointmentServlet"})
public class BookAppointmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer patientId = (Integer) session.getAttribute("patientId");
        
        if (patientId == null) {
            session.setAttribute("errorMessage", "Please login to book an appointment");
            response.sendRedirect("patientLogin.jsp");
            return;
        }
        
        try {
            // Get form parameters
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String appointmentDate = request.getParameter("appointmentDate");
            String appointmentTime = request.getParameter("appointmentTime");
            
            Connection con = DatabaseConnection.initializeDatabase();
            
            // Check if appointment slot is available
            String checkSlotQuery = "SELECT COUNT(*) as count FROM appointments " +
                                  "WHERE doctor_id = ? AND appointment_date = ? AND appointment_time = ?";
            PreparedStatement checkStmt = con.prepareStatement(checkSlotQuery);
            checkStmt.setInt(1, doctorId);
            checkStmt.setString(2, appointmentDate);
            checkStmt.setString(3, appointmentTime);
            ResultSet checkRs = checkStmt.executeQuery();
            checkRs.next();
            
            if (checkRs.getInt("count") > 0) {
                session.setAttribute("errorMessage", "This time slot is already booked. Please choose another time.");
                response.sendRedirect("bookAppointment.jsp");
                return;
            }
            
            checkRs.close();
            checkStmt.close();
            
            // Insert new appointment
            String insertQuery = "INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status) " +
                               "VALUES (?, ?, ?, ?, 'scheduled')";
            PreparedStatement pst = con.prepareStatement(insertQuery);
            pst.setInt(1, patientId);
            pst.setInt(2, doctorId);
            pst.setString(3, appointmentDate);
            pst.setString(4, appointmentTime);
            
            int rowsAffected = pst.executeUpdate();
            pst.close();
            con.close();
            
            if (rowsAffected > 0) {
                session.setAttribute("successMessage", "Appointment booked successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to book appointment. Please try again.");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid doctor selected");
        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
        }
        
        response.sendRedirect("bookAppointment.jsp");
    }
}
