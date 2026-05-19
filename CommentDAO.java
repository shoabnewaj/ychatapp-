package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import ychatapp.model.beans.CommentBeans;

public class CommentDAO {

    private static final String URL  = "jdbc:mysql://127.0.0.1:3306/ychatapp";
    private static final String USER = "root";
    private static final String PASS = "1234";

    static {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); } catch (Exception e) { e.printStackTrace(); }
    }

    private Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    // ================= ADD COMMENT =================
    public int addComment(int postId, int userId, String text, String file_name) {
        int id = (int)(System.currentTimeMillis() / 1000);
        String sql = "INSERT INTO comments(id, post_id, user_id, comment_text, file_name, created_at) VALUES(?,?,?,?,?, NOW())";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, postId);
            ps.setInt(3, userId);
            ps.setString(4, text);
            ps.setString(5, file_name);
            ps.executeUpdate();
            return id;
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    // ================= ADD REPLY =================
    public int addReply(int commentId, int userId, String text, String file_name) {
        String sql = "INSERT INTO replies(comment_id, user_id, text, file_name) VALUES(?,?,?,?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, commentId);
            ps.setInt(2, userId);
            ps.setString(3, text);
            ps.setString(4, file_name);
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
            return -1;
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public int getCommentAuthorId(int commentId) {
        String sql = "SELECT user_id FROM comments WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("user_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ================= COMMENT REACTION (comment_interactions) =================
    public void handleInteraction(int commentId, int userId, String type) {
        String normalizedType = type.toUpperCase();
        if (normalizedType.equals("DISLIKE")) {
            normalizedType = "DISLIKES";
        }
        try (Connection conn = getConnection()) {
            // Check existing reaction
            String currentType = null;
            PreparedStatement psCheck = conn.prepareStatement("SELECT type FROM comment_interactions WHERE comment_id=? AND user_id=?");
            psCheck.setInt(1, commentId);
            psCheck.setInt(2, userId);
            ResultSet rsCheck = psCheck.executeQuery();
            if (rsCheck.next()) {
                currentType = rsCheck.getString("type");
            }
            rsCheck.close();
            psCheck.close();

            // Always delete to handle toggle or update
            PreparedStatement ps1 = conn.prepareStatement(
                    "DELETE FROM comment_interactions WHERE comment_id=? AND user_id=?");
            ps1.setInt(1, commentId);
            ps1.setInt(2, userId);
            ps1.executeUpdate();
            ps1.close();

            // If new reaction is different from current, insert it
            if (currentType == null || !normalizedType.equals(currentType)) {
                PreparedStatement ps2 = conn.prepareStatement(
                        "INSERT INTO comment_interactions(comment_id, user_id, type) VALUES(?,?,?)");
                ps2.setInt(1, commentId);
                ps2.setInt(2, userId);
                ps2.setString(3, normalizedType);
                ps2.executeUpdate();
                ps2.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= REPLY REACTION (reply_interactions) =================
    public void handleReplyInteraction(int replyId, int userId, String type) {
        String normalizedType = type.toUpperCase();
        if (normalizedType.equals("DISLIKE")) {
            normalizedType = "DISLIKES";
        }
        try (Connection conn = getConnection()) {
            String currentType = null;
            PreparedStatement psCheck = conn.prepareStatement("SELECT type FROM reply_interactions WHERE reply_id=? AND user_id=?");
            psCheck.setInt(1, replyId);
            psCheck.setInt(2, userId);
            ResultSet rsCheck = psCheck.executeQuery();
            if (rsCheck.next()) {
                currentType = rsCheck.getString("type");
            }
            rsCheck.close();
            psCheck.close();

            PreparedStatement ps1 = conn.prepareStatement(
                    "DELETE FROM reply_interactions WHERE reply_id=? AND user_id=?");
            ps1.setInt(1, replyId);
            ps1.setInt(2, userId);
            ps1.executeUpdate();
            ps1.close();

            if (currentType == null || !normalizedType.equals(currentType)) {
                PreparedStatement ps2 = conn.prepareStatement(
                        "INSERT INTO reply_interactions(reply_id, user_id, type) VALUES(?,?,?)");
                ps2.setInt(1, replyId);
                ps2.setInt(2, userId);
                ps2.setString(3, normalizedType);
                ps2.executeUpdate();
                ps2.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= COMMENT REACTION COUNT =================
    public int getCount(int commentId, String type) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM comment_interactions WHERE comment_id=? AND type=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            ps.setString(2, type.toUpperCase());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // ================= REPLY REACTION COUNT =================
    public int getReplyCount(int replyId, String type) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM reply_interactions WHERE reply_id=? AND type=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, replyId);
            ps.setString(2, type.toUpperCase());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // ================= GET COMMENTS BY POST ID =================
    public List<CommentBeans> getCommentsByPostId(int postId) {
        try (Connection con = getConnection()) {
            return getCommentsByPostIdInternal(con, postId);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<CommentBeans> getCommentsByPostIdInternal(Connection con, int postId) {
        List<CommentBeans> list = new ArrayList<>();
        String sql =
            "SELECT c.*, u.name, u.profile_pic " +
            "FROM comments c " +
            "JOIN users u ON c.user_id=u.id " +
            "WHERE c.post_id=? " +
            "ORDER BY c.created_at ASC";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CommentBeans c = new CommentBeans();
                    c.setId(rs.getInt("id"));
                    c.setUserId(rs.getInt("user_id"));
                    String cText = rs.getString("comment_text");
                    c.setComment_text(cText);
                    c.setText(cText);
                    c.setFile_name(rs.getString("file_name"));
                    c.setName(rs.getString("name"));
                    c.setProfilePic(rs.getString("profile_pic"));

                    // Pass the existing connection to avoid leakage
                    c.setLikeCount(getCountInternal(con, c.getId(), "LIKE"));
                    c.setLoveCount(getCountInternal(con, c.getId(), "LOVE"));
                    c.setCareCount(getCountInternal(con, c.getId(), "CARE"));
                    c.setHahaCount(getCountInternal(con, c.getId(), "HAHA"));
                    c.setWowCount(getCountInternal(con, c.getId(), "WOW"));
                    c.setSadCount(getCountInternal(con, c.getId(), "SAD"));
                    c.setAngryCount(getCountInternal(con, c.getId(), "ANGRY"));
                    c.setDislikes(getCountInternal(con, c.getId(), "DISLIKES"));

                    // Replies for this comment
                    c.setReplies(getRepliesInternal(con, c.getId()));
                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private int getCountInternal(Connection conn, int commentId, String type) {
        String sql = "SELECT COUNT(*) FROM comment_interactions WHERE comment_id=? AND type=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            ps.setString(2, type.toUpperCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    private List<ychatapp.model.beans.Reply> getRepliesInternal(Connection conn, int commentId) {
        List<ychatapp.model.beans.Reply> list = new ArrayList<>();
        String sql =
            "SELECT r.*, u.name, u.profile_pic " +
            "FROM replies r " +
            "JOIN users u ON r.user_id=u.id " +
            "WHERE r.comment_id=? " +
            "ORDER BY r.created_at ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ychatapp.model.beans.Reply r = new ychatapp.model.beans.Reply();
                    r.setId(rs.getInt("id"));
                    r.setUserId(rs.getInt("user_id"));
                    r.setText(rs.getString("text"));
                    r.setMedia(rs.getString("file_name"));
                    r.setUser_pic(rs.getString("profile_pic"));
                    r.setName(rs.getString("name"));

                    r.setLikeCount(getReplyCountInternal(conn, r.getId(), "LIKE"));
                    r.setLoveCount(getReplyCountInternal(conn, r.getId(), "LOVE"));
                    r.setCareCount(getReplyCountInternal(conn, r.getId(), "CARE"));
                    r.setHahaCount(getReplyCountInternal(conn, r.getId(), "HAHA"));
                    r.setWowCount(getReplyCountInternal(conn, r.getId(), "WOW"));
                    r.setSadCount(getReplyCountInternal(conn, r.getId(), "SAD"));
                    r.setAngryCount(getReplyCountInternal(conn, r.getId(), "ANGRY"));
                    r.setDislikes(getReplyCountInternal(conn, r.getId(), "DISLIKES"));

                    list.add(r);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    private int getReplyCountInternal(Connection conn, int replyId, String type) {
        String sql = "SELECT COUNT(*) FROM reply_interactions WHERE reply_id=? AND type=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, replyId);
            ps.setString(2, type.toUpperCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // ================= GET REPLIES BY COMMENT ID =================
    public List<ychatapp.model.beans.Reply> getRepliesByCommentId(int commentId) {
        List<ychatapp.model.beans.Reply> list = new ArrayList<>();
        String sql =
            "SELECT r.*, u.name, u.profile_pic " +
            "FROM replies r " +
            "JOIN users u ON r.user_id=u.id " +
            "WHERE r.comment_id=? " +
            "ORDER BY r.created_at ASC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ychatapp.model.beans.Reply r = new ychatapp.model.beans.Reply();
                r.setId(rs.getInt("id"));
                r.setUserId(rs.getInt("user_id"));
                r.setText(rs.getString("text"));
                r.setMedia(rs.getString("file_name"));
                r.setUser_pic(rs.getString("profile_pic"));
                r.setName(rs.getString("name"));

                // Reaction counts for reply (reply_interactions table)
                r.setLikeCount(getReplyCount(r.getId(), "LIKE"));
                r.setLoveCount(getReplyCount(r.getId(), "LOVE"));
                r.setCareCount(getReplyCount(r.getId(), "CARE"));
                r.setHahaCount(getReplyCount(r.getId(), "HAHA"));
                r.setWowCount(getReplyCount(r.getId(), "WOW"));
                r.setSadCount(getReplyCount(r.getId(), "SAD"));
                r.setAngryCount(getReplyCount(r.getId(), "ANGRY"));
                r.setDislikes(getReplyCount(r.getId(), "DISLIKES"));

                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================= GET COMMENT COUNT =================
    public int getCommentCount(int postId) {
        try (Connection conn = getConnection()) {
            return getCommentCountInternal(conn, postId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int getCommentCountInternal(Connection conn, int postId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM comments WHERE post_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
}
