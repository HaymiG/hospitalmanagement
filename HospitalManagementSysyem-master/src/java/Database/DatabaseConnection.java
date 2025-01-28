/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Database;

/**
 *
 * @author Admin
 */
import java.sql.Connection; 
import java.sql.DriverManager; 
import java.sql.SQLException; 
  
// This class can be used to initialize the database connection 
public class DatabaseConnection { 
    public static Connection initializeDatabase() 
        throws SQLException, ClassNotFoundException 
    { 
        try {
            // Load the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver loaded successfully");
            
            // Create the connection
            String url = "jdbc:mysql://localhost:3306/hospital?useSSL=false&allowPublicKeyRetrieval=true";
            String username = "root";
            String password = "1234";
            
            System.out.println("Attempting to connect to database...");
            Connection con = DriverManager.getConnection(url, username, password);
            
            if (con != null) {
                System.out.println("Database connected successfully!");
            }
            return con;
        } catch (ClassNotFoundException e) {
            System.out.println("Error: MySQL JDBC Driver not found - " + e.getMessage());
            e.printStackTrace();
            throw e;
        } catch (SQLException e) {
            System.out.println("Error: Database connection failed!");
            System.out.println("Error Code: " + e.getErrorCode());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Message: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    } 
} 
