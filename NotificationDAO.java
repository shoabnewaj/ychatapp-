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
     * ১. সাধারণ নোটিফিকেশন কাউন্ট (Red Badge-এর জন্য)
     */
    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = 0";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * ২. মেসেজ নোটিফিকেশন কাউন্ট (Messages Badge-এর জন্য)
     */
    public int getUnreadMessageCount(int receiverId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM messages WHERE receiver_id=? AND is_read=0";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, receiverId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error counting messages: " + e.getMessage());
        }
        return count;
    }

    /**
     * ৩. নতুন নোটিফিকেশন অ্যাড করা (যেমন: কেউ কমেন্ট বা ফ্রেন্ড রিকোয়েস্ট দিলে)
     */
    public void addNotification(int userId, String message) {
        String sql = "INSERT INTO notifications(user_id, message, is_read) VALUES (?, ?, 0)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, message);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * ৪. নোটিফিকেশন লিস্ট নিয়ে আসা (লেটেস্টগুলো আগে দেখাবে)
     */
    public List<String> getNotifications(int userId) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT message FROM notifications WHERE user_id=? ORDER BY id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("message"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * ৫. নোটিফিকেশন পড়া হয়েছে হিসেবে মার্ক করা
     */
    public void markAsRead(int userId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}