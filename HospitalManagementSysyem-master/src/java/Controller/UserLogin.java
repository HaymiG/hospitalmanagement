/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Database.DatabaseConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Admin
 */
@WebServlet("/UserLogin")
public class UserLogin extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Get form parameters
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            // Debug print
            System.out.println("Username received: " + username);
            System.out.println("Password received: " + password);
            
            // Get database connection
            Connection conn = DatabaseConnection.initializeDatabase();
            Statement stmt = conn.createStatement();
            
            // Execute query
            String sql = "SELECT * FROM login WHERE username='" + username + "' AND password='" + password + "'";
            System.out.println("Executing SQL: " + sql);
            ResultSet rs = stmt.executeQuery(sql);
            
            if (rs.next()) {
                System.out.println("Login successful");
                // Store username in session
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                
                // Redirect to home page
                response.sendRedirect("UserHome.jsp");
            } else {
                System.out.println("Login failed");
                out.println("<html><body>");
                out.println("<script type='text/javascript'>");
                out.println("alert('Invalid username or password');");
                out.println("window.location.href='index.jsp';");
                out.println("</script>");
                out.println("</body></html>");
            }
            
            // Close resources
            rs.close();
            stmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println("Error in UserLogin: " + e.getMessage());
            e.printStackTrace();
            
            out.println("<html><body>");
            out.println("<script type='text/javascript'>");
            out.println("alert('Error: " + e.getMessage() + "');");
            out.println("window.location.href='index.jsp';");
            out.println("</script>");
            out.println("</body></html>");
        }
    }
}
