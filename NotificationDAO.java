package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    private static final String URL = "jdbc:mysql://localhost:3306/ychatapp";
    private static final String USER = "root";
    private static final String PASS = "1234";

    // ড্রাইভ লোড করার জন্য static ব্লক (এটি কানেকশন এরর হওয়া থেকে বাঁচাবে)
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    /**
     * 🔔 নতুন নোটিফিকেশন সেভ করার মেথড
     * @param userId যার কাছে নোটিফিকেশন যাবে
     * @param message নোটিফিকেশনের টেক্সট
     */
    public void addNotification(int userId, String message) {
        String sql = "INSERT INTO notifications(user_id, message) VALUES (?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, message);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error adding notification: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 📩 ইউজারের সব নোটিফিকেশন লিস্ট আনার মেথড
     * @param userId যার নোটিফিকেশন দেখা হবে
     * @return নোটিফিকেশন মেসেজের লিস্ট
     */
    public List<String> getNotifications(int userId) {
        List<String> list = new ArrayList<>();
        // লেটেস্ট নোটিফিকেশন আগে দেখানোর জন্য ORDER BY id DESC ব্যবহার করা হয়েছে
        String sql = "SELECT message FROM notifications WHERE user_id=? ORDER BY id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getString("message"));
            }

        } catch (SQLException e) {
            System.err.println("Error fetching notifications: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }
}
