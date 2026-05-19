package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import ychatapp.model.beans.StoryBeans;

public class StoryDAO {

    public StoryDAO() {
        createTableIfNotExists();
    }

    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }

    private void createTableIfNotExists() {
        String sql = "CREATE TABLE IF NOT EXISTS stories (" +
                     "id INT AUTO_INCREMENT PRIMARY KEY," +
                     "user_id INT NOT NULL," +
                     "media_url VARCHAR(255) DEFAULT NULL," +
                     "text VARCHAR(255) DEFAULT NULL," +
                     "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                     "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
                     ")";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
        } catch (Exception e) {
            System.err.println("Error creating stories table: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public boolean addStory(int userId, String mediaUrl, String text) {
        String sql = "INSERT INTO stories (user_id, media_url, text) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, mediaUrl);
            ps.setString(3, text);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<StoryBeans> getActiveStories() {
        List<StoryBeans> list = new ArrayList<>();
        // Fetch active stories (last 24 hours)
        String sql = "SELECT s.id, s.user_id, s.media_url, s.text, s.created_at, u.name, u.profile_pic " +
                     "FROM stories s " +
                     "JOIN users u ON s.user_id = u.id " +
                     "WHERE s.created_at >= NOW() - INTERVAL 1 DAY " +
                     "ORDER BY s.id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                StoryBeans story = new StoryBeans();
                story.setId(rs.getInt("id"));
                story.setUserId(rs.getInt("user_id"));
                story.setMediaUrl(rs.getString("media_url"));
                story.setText(rs.getString("text"));
                story.setCreatedAt(rs.getString("created_at"));
                story.setName(rs.getString("name"));
                story.setProfilePic(rs.getString("profile_pic"));
                list.add(story);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
