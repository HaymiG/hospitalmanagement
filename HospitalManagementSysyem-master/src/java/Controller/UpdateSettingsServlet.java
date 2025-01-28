package Controller;

import Database.DatabaseConnection;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateSettingsServlet")
public class UpdateSettingsServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Get form data
            String hospitalName = request.getParameter("hospitalName");
            String contactEmail = request.getParameter("contactEmail");
            String contactPhone = request.getParameter("contactPhone");
            String address = request.getParameter("address");
            String timeSlotDuration = request.getParameter("timeSlotDuration");
            String workingHoursStart = request.getParameter("workingHoursStart");
            String workingHoursEnd = request.getParameter("workingHoursEnd");
            String appointmentNotifications = request.getParameter("appointmentNotifications");
            String prescriptionNotifications = request.getParameter("prescriptionNotifications");
            
            // In a real application, you would save these settings to a database
            // For now, we'll just show a success message
            
            out.println("<script type='text/javascript'>");
            out.println("alert('Settings updated successfully!');");
            out.println("window.location.href='settings.jsp';");
            out.println("</script>");
            
        } catch(Exception e) {
            out.println("<script type='text/javascript'>");
            out.println("alert('Error updating settings: " + e.getMessage() + "');");
            out.println("window.location.href='settings.jsp';");
            out.println("</script>");
        }
    }
}
