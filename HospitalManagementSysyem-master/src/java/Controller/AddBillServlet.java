package Controller;

import Database.DatabaseConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddBillServlet")
public class AddBillServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            String service = request.getParameter("service");
            double amount = Double.parseDouble(request.getParameter("amount"));
            
            Connection con = DatabaseConnection.initializeDatabase();
            String query = "INSERT INTO billing (patient_id, bill_date, service_description, amount, status) " +
                         "VALUES (?, CURDATE(), ?, ?, 'Unpaid')";
            
            PreparedStatement pst = con.prepareStatement(query);
            pst.setInt(1, patientId);
            pst.setString(2, service);
            pst.setDouble(3, amount);
            
            int rowsAffected = pst.executeUpdate();
            
            pst.close();
            con.close();
            
            if(rowsAffected > 0) {
                response.sendRedirect("billing.jsp");
            } else {
                out.println("<script type='text/javascript'>");
                out.println("alert('Failed to add bill');");
                out.println("window.location.href='billing.jsp';");
                out.println("</script>");
            }
            
        } catch(Exception e) {
            out.println("<script type='text/javascript'>");
            out.println("alert('Error: " + e.getMessage() + "');");
            out.println("window.location.href='billing.jsp';");
            out.println("</script>");
        }
    }
}
