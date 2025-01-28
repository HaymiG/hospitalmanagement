/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
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

/**
 *
 * @author Admin piyush
 */
@WebServlet(name = "AdminLoginServlet", urlPatterns = {"/AdminLoginServlet"})
public class AdminLogin extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("AdminLogin servlet called");
        String username = request.getParameter("your_name");
        String password = request.getParameter("your_pass");
        
        try {
            Connection con = DatabaseConnection.initializeDatabase();
            
            // Debug print to check values
            System.out.println("Attempting login with - Username: " + username + ", Password: " + password);
            
            String query = "SELECT * FROM adminreg WHERE username=? AND password=?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, username);
            pst.setString(2, password);
            
            System.out.println("Executing query: " + query);
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                System.out.println("Login successful!");
                // Valid admin credentials
                HttpSession session = request.getSession();
                session.setAttribute("adminUsername", username);
                session.setAttribute("isAdminLoggedIn", "true");
                
                System.out.println("Redirecting to adminDashboard.jsp");
                response.sendRedirect("adminDashboard.jsp");
            } else {
                System.out.println("Login failed - Invalid credentials");
                // Invalid credentials
                response.sendRedirect("adminLogin.jsp?error=1");
            }
            
            rs.close();
            pst.close();
            con.close();
            
        } catch (Exception e) {
            System.out.println("Error during login: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("adminLogin.jsp?error=1");
        }
    }
}
