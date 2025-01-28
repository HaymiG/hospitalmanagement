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

@WebServlet(name = "UpdateDoctorProfileServlet", urlPatterns = {"/UpdateDoctorProfileServlet"})
public class UpdateDoctorProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String doctorId = request.getParameter("doctorId");
        String password = request.getParameter("password");
        
        try {
            Connection con = DatabaseConnection.initializeDatabase();
            
            StringBuilder queryBuilder = new StringBuilder();
            queryBuilder.append("UPDATE doctor SET ");
            queryBuilder.append("fname = ?, ");
            queryBuilder.append("lname = ?, ");
            queryBuilder.append("email = ?, ");
            queryBuilder.append("contact = ?, ");
            queryBuilder.append("specialization = ?");
            
            // Add password update if provided
            if (password != null && !password.trim().isEmpty()) {
                queryBuilder.append(", password = ?");
            }
            
            queryBuilder.append(" WHERE id = ?");
            
            PreparedStatement pst = con.prepareStatement(queryBuilder.toString());
            
            int paramIndex = 1;
            pst.setString(paramIndex++, request.getParameter("fname"));
            pst.setString(paramIndex++, request.getParameter("lname"));
            pst.setString(paramIndex++, request.getParameter("email"));
            pst.setString(paramIndex++, request.getParameter("contact"));
            pst.setString(paramIndex++, request.getParameter("specialization"));
            
            if (password != null && !password.trim().isEmpty()) {
                pst.setString(paramIndex++, password);
            }
            
            pst.setString(paramIndex, doctorId);
            
            pst.executeUpdate();
            pst.close();
            con.close();
            
            // Update session attributes
            HttpSession session = request.getSession();
            session.setAttribute("doctorName", request.getParameter("fname") + " " + request.getParameter("lname"));
            session.setAttribute("specialization", request.getParameter("specialization"));
            
            response.sendRedirect("doctorProfile.jsp?success=true");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("doctorProfile.jsp?error=true");
        }
    }
}
