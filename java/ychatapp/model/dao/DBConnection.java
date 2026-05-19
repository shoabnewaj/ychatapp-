package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws Exception {
        // Railway MySQL environment variables
        String host = System.getenv("MYSQLHOST");
        String port = System.getenv("MYSQLPORT");
        String database = System.getenv("MYSQLDATABASE");
        String user = System.getenv("MYSQLUSER");
        String password = System.getenv("MYSQLPASSWORD");

        String url;
        if (host != null && !host.trim().isEmpty()) {
            url = "jdbc:mysql://" + host + ":" + (port != null ? port : "3306") + "/" + (database != null ? database : "ychatapp") + "?useSSL=false&allowPublicKeyRetrieval=true";
        } else {
            // Local fallback
            url = "jdbc:mysql://127.0.0.1:3306/ychatapp?useSSL=false&allowPublicKeyRetrieval=true";
            user = "root";
            password = "1234";
        }
        
        return DriverManager.getConnection(url, user, password);
    }
}
