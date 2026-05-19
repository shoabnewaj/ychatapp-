<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Diagnostic & Fixer</title>
    <style>
        body { font-family: sans-serif; padding: 20px; line-height: 1.6; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        .info { color: blue; }
        pre { background: #f4f4f4; padding: 10px; border: 1px solid #ddd; }
    </style>
</head>
<body>
    <h2>Database Diagnostic & Fixer Tool</h2>
    <hr>

    <%
        String url = "jdbc:mysql://127.0.0.1:3306/ychatapp";
        String user = "root";
        String pass = "1234";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, pass);
            out.println("<p class='success'>[1] Connection to Database 'ychatapp' SUCCESSFUL!</p>");

            Statement stmt = conn.createStatement();
            
            // 1. Existing Tables
            out.println("<h3>Existing Tables:</h3><ul>");
            ResultSet rsTables = conn.getMetaData().getTables("ychatapp", null, "%", new String[]{"TABLE"});
            Set<String> tableNames = new HashSet<>();
            while(rsTables.next()) {
                String tableName = rsTables.getString("TABLE_NAME").toLowerCase();
                out.println("<li>" + tableName + "</li>");
                tableNames.add(tableName);
            }
            out.println("</ul>");

            // 2. Create friendships table if not exists
            if(!tableNames.contains("friendships")) {
                out.println("<p class='info'>Table 'friendships' NOT found. Creating it now...</p>");
                String sql = "CREATE TABLE friendships (" +
                             "id INT AUTO_INCREMENT PRIMARY KEY, " +
                             "user_id1 INT NOT NULL, " +
                             "user_id2 INT NOT NULL, " +
                             "status VARCHAR(20) DEFAULT 'PENDING', " +
                             "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                             "UNIQUE KEY unique_pair (user_id1, user_id2)" +
                             ") ENGINE=InnoDB;";
                stmt.executeUpdate(sql);
                out.println("<p class='success'>SUCCESS: Table 'friendships' created successfully!</p>");
            }

            // 3. Create marketplace_items table if not exists
            if(!tableNames.contains("marketplace_items")) {
                out.println("<p class='info'>Table 'marketplace_items' NOT found. Creating it now...</p>");
                String sql = "CREATE TABLE marketplace_items (" +
                             "id INT AUTO_INCREMENT PRIMARY KEY, " +
                             "title VARCHAR(255) NOT NULL, " +
                             "description TEXT, " +
                             "price DECIMAL(10,2) NOT NULL, " +
                             "image_url VARCHAR(255), " +
                             "seller_id INT NOT NULL, " +
                             "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                             ") ENGINE=InnoDB;";
                stmt.executeUpdate(sql);
                out.println("<p class='success'>SUCCESS: Table 'marketplace_items' created successfully!</p>");
            }

            // 4. Create groups table if not exists
            if(!tableNames.contains("groups")) {
                out.println("<p class='info'>Table 'groups' NOT found. Creating it now...</p>");
                String sql = "CREATE TABLE `groups` (" +
                             "id INT AUTO_INCREMENT PRIMARY KEY, " +
                             "name VARCHAR(255) NOT NULL, " +
                             "description TEXT, " +
                             "creator_id INT NOT NULL, " +
                             "cover_pic VARCHAR(255), " +
                             "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                             ") ENGINE=InnoDB;";
                stmt.executeUpdate(sql);
                out.println("<p class='success'>SUCCESS: Table 'groups' created successfully!</p>");
            }

            // 5. Create group_members table if not exists
            if(!tableNames.contains("group_members")) {
                out.println("<p class='info'>Table 'group_members' NOT found. Creating it now...</p>");
                String sql = "CREATE TABLE group_members (" +
                             "id INT AUTO_INCREMENT PRIMARY KEY, " +
                             "group_id INT NOT NULL, " +
                             "user_id INT NOT NULL, " +
                             "joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                             "UNIQUE KEY unique_member (group_id, user_id)" +
                             ") ENGINE=InnoDB;";
                stmt.executeUpdate(sql);
                out.println("<p class='success'>SUCCESS: Table 'group_members' created successfully!</p>");
            }

            // 6. Check if group_id column exists in posts table, otherwise add it
            boolean hasGroupId = false;
            ResultSet rsCols = conn.getMetaData().getColumns("ychatapp", null, "posts", "%");
            while(rsCols.next()) {
                if("group_id".equalsIgnoreCase(rsCols.getString("COLUMN_NAME"))) {
                    hasGroupId = true;
                }
            }
            if(!hasGroupId) {
                out.println("<p class='info'>Column 'group_id' NOT found in 'posts' table. Adding it now...</p>");
                stmt.executeUpdate("ALTER TABLE posts ADD COLUMN group_id INT DEFAULT NULL");
                out.println("<p class='success'>SUCCESS: Column 'group_id' added to 'posts' table!</p>");
            } else {
                out.println("<p class='success'>Column 'group_id' already exists in 'posts' table.</p>");
            }

            conn.close();
            out.println("<hr><h2 class='success'>DATABASE SCHEMA COMPLETED & VERIFIED SUCCESSFULLY!</h2>");
            
        } catch (Exception e) {
            out.println("<h3 class='error'>FATAL ERROR: " + e.getMessage() + "</h3>");
            out.println("<pre>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre>");
        }
    %>
</body>
</html>
