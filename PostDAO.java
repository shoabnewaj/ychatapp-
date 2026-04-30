package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import ychatapp.model.beans.UsersPost;

public class PostDAO {
    private static final String URL = "jdbc:mysql://localhost:3306/ychatapp";
    private static final String USER = "root";
    private static final String PASS = "1234";

    private Connection getConnection() throws SQLException {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); } catch (Exception e) {}
        return DriverManager.getConnection(URL, USER, PASS);
    }

    public void addPost(int userId, String content, String fileName, String postType) {
        String sql = "INSERT INTO posts(user_id, content, file_name, post_type) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, content);
            ps.setString(3, fileName);
            ps.setString(4, postType);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void sharePost(int userId, String content, String ownerName, String fileName, String postType) {

        String newContent = "🔄 Shared from " + ownerName + ": " + content;

        String sql = "INSERT INTO posts(user_id, content, file_name, post_type) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, newContent);
            ps.setString(3, fileName);   // 🔥 COPY MEDIA
            ps.setString(4, postType);   // 🔥 COPY TYPE

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<UsersPost> getAllposts() {
        List<UsersPost> list = new ArrayList<>();
        String sql = "SELECT * FROM user_posts_view ORDER BY posts_id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int pid = rs.getInt("posts_id");
                UsersPost post = new UsersPost(
                        pid, rs.getString("name"), rs.getInt("users_id"),
                        rs.getString("content"), rs.getString("file_name"), rs.getString("post_type")
                );
                post.setLikes(getInteractionCount(pid, "LIKE"));
                post.setDislikes(getInteractionCount(pid, "DISLIKE"));
                post.setComments(getCommentsByPostId(pid));
                list.add(post);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public void handleInteraction(int postId, int userId, String type) {
        try (Connection conn = getConnection()) {
            PreparedStatement ps1 = conn.prepareStatement("DELETE FROM post_interactions WHERE post_id=? AND user_id=?");
            ps1.setInt(1, postId); ps1.setInt(2, userId); ps1.executeUpdate();
            PreparedStatement ps2 = conn.prepareStatement("INSERT INTO post_interactions(post_id, user_id, type) VALUES(?,?,?)");
            ps2.setInt(1, postId); ps2.setInt(2, userId); ps2.setString(3, type); ps2.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public int getInteractionCount(int postId, String type) {
        String sql = "SELECT COUNT(*) FROM post_interactions WHERE post_id=? AND type=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId); ps.setString(2, type);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public void addComment(int postId, int userId, String text) {
        String sql = "INSERT INTO post_comments(post_id, user_id, comment_text) VALUES(?,?,?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId); ps.setInt(2, userId); ps.setString(3, text); ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public List<String> getCommentsByPostId(int postId) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT comment_text FROM post_comments WHERE post_id=? ORDER BY id DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { 
            	list.add(rs.getString("comment_text"));
            	
            }
            
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public UsersPost getPostById(int postId) {

        String sql = "SELECT * FROM user_posts_view WHERE posts_id=?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, postId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return new UsersPost(
                    rs.getInt("posts_id"),
                    rs.getString("name"),
                    rs.getInt("users_id"),
                    rs.getString("content"),
                    rs.getString("file_name"),
                    rs.getString("post_type")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}