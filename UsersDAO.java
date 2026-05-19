package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import ychatapp.model.beans.UsersBeans;

public class UsersDAO {

    static {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); } catch (Exception e) { e.printStackTrace(); }
    }

    private Connection getConnection() throws Exception {
        return DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/ychatapp", "root", "1234");
    }

    // 📊 Profile Count
    public int getProfileCount(int userId, String type) {
        int count = 0;
        String sql = (type.equalsIgnoreCase("FRIENDS")) ? 
            "SELECT COUNT(*) FROM friendships WHERE (user_id1=? OR user_id2=?) AND status='ACCEPTED'" :
            (type.equalsIgnoreCase("FOLLOWERS") ? "SELECT COUNT(*) FROM followers WHERE following_id=?" : "SELECT COUNT(*) FROM followers WHERE follower_id=?");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (type.equalsIgnoreCase("FRIENDS")) ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    // 🔥 User Registration
    public boolean registerUser(UsersBeans ub) {
        String sql = "INSERT INTO users (name, email, password, profile_pic) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ub.getName());
            ps.setString(2, ub.getEmail());
            ps.setString(3, ub.getHashedPass()); 
            ps.setString(4, ub.getProfile_pic());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 🔥 Login Check
    public UsersBeans loginCheck(String email, String hashedPass) {
        UsersBeans ub = null;
        String sql = "SELECT * FROM users WHERE email=? AND password=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, hashedPass);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ub = new UsersBeans();
                ub.setId(rs.getInt("id"));
                ub.setName(rs.getString("name"));
                ub.setEmail(rs.getString("email"));
                ub.setProfile_pic(rs.getString("profile_pic"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return ub;
    }

    public boolean updatePasswordByEmail(String email, String hashedPass) {
        String sql = "UPDATE users SET password=? WHERE email=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPass);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 🛠️ Update User (ETAI MISSING CHILO)
    public boolean updateUser(UsersBeans ub) {
        String sql = "UPDATE users SET name=?, email=?, password=?, profile_pic=? WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ub.getName());
            ps.setString(2, ub.getEmail());
            ps.setString(3, ub.getHashedPass());
            ps.setString(4, ub.getProfile_pic());
            ps.setInt(5, ub.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 📸 Update Profile Pic
    public boolean updateProfilePic(int userId, String fileName) {
        String sql = "UPDATE users SET profile_pic = ? WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fileName);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 🆔 Get User by ID
    public UsersBeans getUserById(int id) {
        UsersBeans ub = null;
        String sql = "SELECT * FROM users WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ub = new UsersBeans();
                ub.setId(rs.getInt("id"));
                ub.setName(rs.getString("name"));
                ub.setEmail(rs.getString("email"));
                ub.setProfile_pic(rs.getString("profile_pic"));
                ub.setCover_pic(rs.getString("cover_pic"));
                ub.setBio(rs.getString("bio"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return ub;
    }

    // 🤝 Friends logic (Required for Profile/Friend Servlets)
    public String getFriendshipStatus(int myId, int targetId) {
        String status = "NONE";
        String sql = "SELECT user_id1, status FROM friendships WHERE (user_id1=? AND user_id2=?) OR (user_id1=? AND user_id2=?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, myId); ps.setInt(2, targetId);
            ps.setInt(3, targetId); ps.setInt(4, myId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int senderId = rs.getInt("user_id1");
                    String dbStatus = rs.getString("status");
                    if ("ACCEPTED".equalsIgnoreCase(dbStatus)) {
                        status = "ACCEPTED";
                    } else if ("PENDING".equalsIgnoreCase(dbStatus)) {
                        if (senderId == myId) {
                            status = "SENT";
                        } else {
                            status = "INCOMING";
                        }
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return status;
    }
    public boolean updateCoverPic(int userId, String fileName) {
        boolean flag = false;

        String sql = "UPDATE users SET cover_pic=? WHERE id=?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fileName);
            ps.setInt(2, userId);

            flag = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    public List<UsersBeans> getPendingRequests(int userId) {
        List<UsersBeans> list = new ArrayList<>();
        String sql = "SELECT u.* FROM users u JOIN friendships f ON u.id = f.user_id1 WHERE f.user_id2 = ? AND f.status = 'PENDING'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UsersBeans ub = new UsersBeans();
                ub.setId(rs.getInt("id"));
                ub.setName(rs.getString("name"));
                ub.setEmail(rs.getString("email"));
                ub.setProfile_pic(rs.getString("profile_pic"));
                list.add(ub);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<UsersBeans> getSentRequests(int userId) {
        List<UsersBeans> list = new ArrayList<>();
        String sql = "SELECT u.* FROM users u JOIN friendships f ON u.id = f.user_id2 WHERE f.user_id1 = ? AND f.status = 'PENDING'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UsersBeans ub = new UsersBeans();
                ub.setId(rs.getInt("id"));
                ub.setName(rs.getString("name"));
                ub.setEmail(rs.getString("email"));
                ub.setProfile_pic(rs.getString("profile_pic"));
                list.add(ub);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<UsersBeans> getFriends(int userId) {
        List<UsersBeans> list = new ArrayList<>();
        String sql = "SELECT u.* FROM users u JOIN friendships f ON (u.id = f.user_id1 OR u.id = f.user_id2) WHERE (f.user_id1 = ? OR f.user_id2 = ?) AND f.status = 'ACCEPTED' AND u.id != ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UsersBeans ub = new UsersBeans();
                ub.setId(rs.getInt("id"));
                ub.setName(rs.getString("name"));
                ub.setEmail(rs.getString("email"));
                ub.setProfile_pic(rs.getString("profile_pic"));
                list.add(ub);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    private String lastError = "";
    public String getLastError() { return lastError; }

    public boolean handleFriendAction(int myId, int targetId, String action) {
        System.out.println(">>> DAO Action: " + action + " | From: " + myId + " | To: " + targetId);
        try (Connection conn = getConnection()) {
            if ("ADD".equalsIgnoreCase(action)) {
                // ১. পুরনো সব রেকর্ড মুছে ফেলা
                String delSql = "DELETE FROM friendships WHERE (user_id1=? AND user_id2=?) OR (user_id1=? AND user_id2=?)";
                try (PreparedStatement ps = conn.prepareStatement(delSql)) {
                    ps.setInt(1, myId); ps.setInt(2, targetId);
                    ps.setInt(3, targetId); ps.setInt(4, myId);
                    ps.executeUpdate();
                }

                // ২. নতুন রিকোয়েস্ট পাঠানো
                String insSql = "INSERT IGNORE INTO friendships (user_id1, user_id2, status) VALUES (?, ?, 'PENDING')";
                try (PreparedStatement ps = conn.prepareStatement(insSql)) {
                    ps.setInt(1, myId);
                    ps.setInt(2, targetId);
                    int res = ps.executeUpdate();
                    if (res == 0) {
                        String upSql = "UPDATE friendships SET status='PENDING' WHERE user_id1=? AND user_id2=?";
                        try(PreparedStatement ps2 = conn.prepareStatement(upSql)) {
                            ps2.setInt(1, myId); ps2.setInt(2, targetId);
                            return ps2.executeUpdate() > 0;
                        }
                    }
                    return res > 0;
                }
            } else if ("ACCEPT".equalsIgnoreCase(action)) {
                String sql = "UPDATE friendships SET status = 'ACCEPTED' WHERE user_id1 = ? AND user_id2 = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, targetId);
                    ps.setInt(2, myId);
                    return ps.executeUpdate() > 0;
                }
            } else {
                // CANCEL, DECLINE, UNFRIEND
                String sql = "DELETE FROM friendships WHERE (user_id1 = ? AND user_id2 = ?) OR (user_id1 = ? AND user_id2 = ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, myId); ps.setInt(2, targetId);
                    ps.setInt(3, targetId); ps.setInt(4, myId);
                    return ps.executeUpdate() > 0;
                }
            }
        } catch (Exception e) { 
            this.lastError = e.getMessage();
            System.err.println(">>> DAO ERROR: " + e.getMessage());
            e.printStackTrace(); 
        }
        return false;
    }

    public boolean isFollowing(int followerId, int followingId) {
        String sql = "SELECT * FROM followers WHERE follower_id = ? AND following_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, followerId);
            ps.setInt(2, followingId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean handleFollowAction(int followerId, int followingId, String action) {
        String sql = "";
        try (Connection conn = getConnection()) {
            if ("FOLLOW".equalsIgnoreCase(action)) {
                sql = "INSERT IGNORE INTO followers (follower_id, following_id) VALUES (?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, followerId);
                    ps.setInt(2, followingId);
                    return ps.executeUpdate() > 0;
                }
            } else if ("UNFOLLOW".equalsIgnoreCase(action)) {
                sql = "DELETE FROM followers WHERE follower_id = ? AND following_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, followerId);
                    ps.setInt(2, followingId);
                    return ps.executeUpdate() > 0;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public List<UsersBeans> searchUsers(String query) {
        List<UsersBeans> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE name LIKE ? OR email LIKE ? LIMIT 20";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchTerm = "%" + query + "%";
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UsersBeans ub = new UsersBeans();
                ub.setId(rs.getInt("id"));
                ub.setName(rs.getString("name"));
                ub.setEmail(rs.getString("email"));
                ub.setProfile_pic(rs.getString("profile_pic"));
                list.add(ub);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}