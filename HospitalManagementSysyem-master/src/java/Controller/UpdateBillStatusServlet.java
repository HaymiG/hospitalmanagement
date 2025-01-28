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

@WebServlet("/UpdateBillStatusServlet")
public class UpdateBillStatusServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int billId = Integer.parseInt(request.getParameter("billId"));
            String status = request.getParameter("status");
            
            Connection con = DatabaseConnection.initializeDatabase();
            String query = "UPDATE billing SET status=?, payment_date=CURDATE() WHERE bill_id=?";
            
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, status);
            pst.setInt(2, billId);
            
            int rowsAffected = pst.executeUpdate();
            
            pst.close();
            con.close();
            
            response.sendRedirect("billing.jsp");
            
        } catch(Exception e) {
            out.println("<script type='text/javascript'>");
            out.println("alert('Error: " + e.getMessage() + "');");
            out.println("window.location.href='billing.jsp';");
            out.println("</script>");
        }
    }
}
