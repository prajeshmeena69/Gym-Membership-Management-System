package com.gym.database;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {
    // Database connection parameters
    private static final String URL = "jdbc:mysql://localhost:3306/gym_management";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "031204";

    /**
     * Method to establish and return database connection
     * @return Connection object
     */
    public static Connection getConnection() {
        Connection conn = null;

        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish connection
            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);

            System.out.println("Database connected successfully!");

        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Connection failed!");
            e.printStackTrace();
        }

        return conn;
    }

    /**
     * Method to close database connection
     * @param conn Connection object to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("Database connection closed successfully!");
            } catch (SQLException e) {
                System.err.println("Failed to close connection!");
                e.printStackTrace();
            }
        }
    }
}
