package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import ychatapp.model.beans.Group;
import ychatapp.model.beans.UsersPost;

public class GroupDAO {
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/ychatapp";
    private static final String USER = "root";
    private static final String PASS = "1234";

    static {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); } catch (Exception e) { e.printStackTrace(); }
    }

    private Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    public List<Group> getAllGroups(int userId) {
        List<Group> list = new ArrayList<>();
        String sql = "SELECT g.*, u.name as creator_name, " +
                     "(SELECT COUNT(*) FROM group_members WHERE group_id = g.id) as member_count, " +
                     "(SELECT COUNT(*) FROM group_members WHERE group_id = g.id AND user_id = ?) as is_joined " +
                     "FROM groups g JOIN users u ON g.creator_id = u.id ORDER BY g.id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Group group = new Group();
                    group.setId(rs.getInt("id"));
                    group.setName(rs.getString("name"));
                    group.setDescription(rs.getString("description"));
                    group.setCreatorId(rs.getInt("creator_id"));
                    group.setCoverPic(rs.getString("cover_pic"));
                    group.setCreatedAt(rs.getTimestamp("created_at"));
                    group.setCreatorName(rs.getString("creator_name"));
                    group.setMemberCount(rs.getInt("member_count"));
                    group.setJoined(rs.getInt("is_joined") > 0);
                    list.add(group);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Group getGroupById(int groupId, int userId) {
        String sql = "SELECT g.*, u.name as creator_name, " +
                     "(SELECT COUNT(*) FROM group_members WHERE group_id = g.id) as member_count, " +
                     "(SELECT COUNT(*) FROM group_members WHERE group_id = g.id AND user_id = ?) as is_joined " +
                     "FROM groups g JOIN users u ON g.creator_id = u.id WHERE g.id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, groupId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Group group = new Group();
                    group.setId(rs.getInt("id"));
                    group.setName(rs.getString("name"));
                    group.setDescription(rs.getString("description"));
                    group.setCreatorId(rs.getInt("creator_id"));
                    group.setCoverPic(rs.getString("cover_pic"));
                    group.setCreatedAt(rs.getTimestamp("created_at"));
                    group.setCreatorName(rs.getString("creator_name"));
                    group.setMemberCount(rs.getInt("member_count"));
                    group.setJoined(rs.getInt("is_joined") > 0);
                    return group;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int createGroup(String name, String description, int creatorId, String coverPic) {
        String sql = "INSERT INTO groups (name, description, creator_id, cover_pic) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setInt(3, creatorId);
            ps.setString(4, coverPic);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int groupId = rs.getInt(1);
                    // Creator automatically joins the group
                    joinGroup(groupId, creatorId);
                    return groupId;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean joinGroup(int groupId, int userId) {
        String sql = "INSERT IGNORE INTO group_members (group_id, user_id) VALUES (?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, groupId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean leaveGroup(int groupId, int userId) {
        String sql = "DELETE FROM group_members WHERE group_id = ? AND user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, groupId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<UsersPost> getGroupPosts(int groupId) {
        List<UsersPost> list = new ArrayList<>();
        String sql =
            "SELECT p.id AS posts_id, u.name, p.user_id AS users_id, p.content, p.file_name, p.post_type, p.feeling, " +
            "       u.profile_pic, p.created_at, p.share_count, " +
            "       SUM(CASE WHEN pi.type='LIKE'     THEN 1 ELSE 0 END) AS like_count, " +
            "       SUM(CASE WHEN pi.type='LOVE'     THEN 1 ELSE 0 END) AS love_count, " +
            "       SUM(CASE WHEN pi.type='CARE'     THEN 1 ELSE 0 END) AS care_count, " +
            "       SUM(CASE WHEN pi.type='HAHA'     THEN 1 ELSE 0 END) AS haha_count, " +
            "       SUM(CASE WHEN pi.type='WOW'      THEN 1 ELSE 0 END) AS wow_count, " +
            "       SUM(CASE WHEN pi.type='SAD'      THEN 1 ELSE 0 END) AS sad_count, " +
            "       SUM(CASE WHEN pi.type='ANGRY'    THEN 1 ELSE 0 END) AS angry_count, " +
            "       SUM(CASE WHEN pi.type='DISLIKES' THEN 1 ELSE 0 END) AS dislike_count, " +
            "       COUNT(DISTINCT c.id) AS comment_count " +
            "FROM posts p " +
            "JOIN users u ON p.user_id = u.id " +
            "LEFT JOIN post_interactions pi ON pi.post_id = p.id " +
            "LEFT JOIN comments c ON c.post_id = p.id " +
            "WHERE p.group_id = ? " +
            "GROUP BY p.id, u.name, p.user_id, p.content, p.file_name, p.post_type, p.feeling, u.profile_pic, p.created_at, p.share_count " +
            "ORDER BY p.id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, groupId);
            try (ResultSet rs = ps.executeQuery()) {
                CommentDAO commentDAO = new CommentDAO();
                while (rs.next()) {
                    UsersPost post = new UsersPost(
                            rs.getInt("posts_id"),
                            rs.getString("name"),
                            rs.getInt("users_id"),
                            rs.getString("content"),
                            rs.getString("file_name"),
                            rs.getString("post_type"),
                            rs.getString("feeling")
                    );
                    post.setProfile_pic(rs.getString("profile_pic"));
                    post.setTime(rs.getString("created_at"));

                    post.setLikeCount(rs.getInt("like_count"));
                    post.setLoveCount(rs.getInt("love_count"));
                    post.setCareCount(rs.getInt("care_count"));
                    post.setHahaCount(rs.getInt("haha_count"));
                    post.setWowCount(rs.getInt("wow_count"));
                    post.setSadCount(rs.getInt("sad_count"));
                    post.setAngryCount(rs.getInt("angry_count"));
                    post.setDislikes(rs.getInt("dislike_count"));
                    post.setCommentCount(rs.getInt("comment_count"));
                    post.setShareCount(rs.getInt("share_count"));

                    post.setComments(commentDAO.getCommentsByPostIdInternal(conn, post.getId()));
                    list.add(post);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
