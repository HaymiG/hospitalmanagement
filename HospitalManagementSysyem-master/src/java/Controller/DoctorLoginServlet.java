package Controller;

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
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        System.out.println("Doctor Login Attempt - Email: " + email); // Debug log
        
        try {
            Connection con = DatabaseConnection.initializeDatabase();
            String query = "SELECT * FROM doctor WHERE email = ? AND password = ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, email);
            pst.setString(2, password);
            
            System.out.println("Executing query: " + query); // Debug log
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                System.out.println("Login successful for doctor: " + email); // Debug log
                HttpSession session = request.getSession();
                session.setAttribute("doctorEmail", email);
                session.setAttribute("doctorName", rs.getString("fname") + " " + rs.getString("lname"));
                session.setAttribute("doctorId", rs.getInt("id"));
                response.sendRedirect("doctorHome.jsp");
            } else {
                System.out.println("Login failed for doctor: " + email); // Debug log
                response.sendRedirect("doctorLogin.jsp?status=invalid");
            }
            
            rs.close();
            pst.close();
            con.close();
            
        } catch (Exception e) {
            System.out.println("Exception in doctor login: " + e.getMessage()); // Debug log
            e.printStackTrace();
            response.sendRedirect("doctorLogin.jsp?status=error");
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
}
