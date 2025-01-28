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

@WebServlet("/DeleteBillServlet")
public class DeleteBillServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int billId = Integer.parseInt(request.getParameter("billId"));
            
            Connection con = DatabaseConnection.initializeDatabase();
            String query = "DELETE FROM billing WHERE bill_id=?";
            
            PreparedStatement pst = con.prepareStatement(query);
            pst.setInt(1, billId);
            
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
