package Controller;

import Database.DatabaseConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Get form data
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String dob = request.getParameter("dob");
            String address = request.getParameter("address");
            String bloodGroup = request.getParameter("bloodGroup");
            String emergencyContact = request.getParameter("emergencyContact");
            String emergencyPhone = request.getParameter("emergencyPhone");
            
            // Get database connection
            Connection con = DatabaseConnection.initializeDatabase();
            
            // Update profile
            String query = "UPDATE user_profiles SET full_name=?, email=?, phone=?, " +
                         "date_of_birth=?, address=?, blood_group=?, " +
                         "emergency_contact=?, emergency_phone=? WHERE user_id=?";
            
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, fullName);
            pst.setString(2, email);
            pst.setString(3, phone);
            pst.setString(4, dob);
            pst.setString(5, address);
            pst.setString(6, bloodGroup);
            pst.setString(7, emergencyContact);
            pst.setString(8, emergencyPhone);
            // Replace with actual user ID from session
            pst.setInt(9, 1);
            
            int rowsAffected = pst.executeUpdate();
            
            if(rowsAffected > 0) {
                out.println("<script type='text/javascript'>");
                out.println("alert('Profile updated successfully!');");
                out.println("window.location.href='profileSettings.jsp';");
                out.println("</script>");
            } else {
                out.println("<script type='text/javascript'>");
                out.println("alert('Failed to update profile. Please try again.');");
                out.println("window.location.href='profileSettings.jsp';");
                out.println("</script>");
            }
            
            pst.close();
            con.close();
            
        } catch(Exception e) {
            out.println("<script type='text/javascript'>");
            out.println("alert('Error: " + e.getMessage() + "');");
            out.println("window.location.href='profileSettings.jsp';");
            out.println("</script>");
        }
    }
}
