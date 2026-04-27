package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import ychatapp.model.beans.UsersBeans;



public class UsersDAO {

    private static final String URL = "jdbc:mysql://localhost:3306/ychatapp";
    private static final String USER = "root";
    private static final String PASS = "1234";

    // 🔥 Driver Load
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    // ================= LOGIN =================
    public UsersBeans login(String email, String hashedPass) {

        String sql = "SELECT * FROM users WHERE email=? AND pass=?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, hashedPass);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new UsersBeans(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("name"),
                        rs.getString("user_img")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ================= REGISTER =================
    public boolean userRegist(UsersBeans ub) {

        String sql = "INSERT INTO users (email, pass, name, user_img) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ub.getEmail());
            ps.setString(2, ub.getHashedPass());
            ps.setString(3, ub.getName());
            ps.setString(4, ub.getUser_img());

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= UPDATE PROFILE =================
    public boolean updateUser(UsersBeans ub) {

        String sql = "UPDATE users SET name=?, email=?, pass=? WHERE id=?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ub.getName());
            ps.setString(2, ub.getEmail());
            ps.setString(3, ub.getHashedPass());
            ps.setInt(4, ub.getId());

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
 // ================= UPDATE PROFILE IMAGE =================
    public boolean updateProfilePic(int userId, String fileName) {

        String sql = "UPDATE users SET user_img=? WHERE id=?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fileName);
            ps.setInt(2, userId);

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    // ================= GET USER =================
    public UsersBeans getUserById(int id) {

        String sql = "SELECT * FROM users WHERE id=?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new UsersBeans(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("name"),
                        rs.getString("user_img")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ================= PROFILE COUNT =================
    public int getProfileCount(int userId, String type) {

        String sql = "";

        if ("FRIENDS".equals(type)) {
            sql = "SELECT COUNT(*) FROM user_relationships WHERE (sender_id=? OR receiver_id=?) AND status='ACCEPTED'";
        } else if ("FOLLOWERS".equals(type)) {
            sql = "SELECT COUNT(*) FROM user_relationships WHERE receiver_id=? AND status='PENDING'";
        } else if ("FOLLOWING".equals(type)) {
            sql = "SELECT COUNT(*) FROM user_relationships WHERE sender_id=? AND status='PENDING'";
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            if ("FRIENDS".equals(type)) {
                ps.setInt(2, userId);
            }

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // ================= FRIEND STATUS =================
    public String getFriendshipStatus(int myId, int targetId) {

        String sql = "SELECT sender_id, status FROM user_relationships " +
                     "WHERE (sender_id=? AND receiver_id=?) OR (sender_id=? AND receiver_id=?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, myId);
            ps.setInt(2, targetId);
            ps.setInt(3, targetId);
            ps.setInt(4, myId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                String status = rs.getString("status");

                if ("ACCEPTED".equals(status)) {
                    return "FRIENDS";
                }

                return (rs.getInt("sender_id") == myId) ? "SENT" : "RECEIVED";
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "NONE";
    }

    // ================= FRIEND ACTION =================
    public boolean handleFriendAction(int myId, int targetId, String action) {

        try (Connection conn = getConnection()) {

            if ("SEND".equals(action)) {

                String sql = "INSERT INTO user_relationships (sender_id, receiver_id, status) VALUES (?, ?, 'PENDING')";
                PreparedStatement ps = conn.prepareStatement(sql);

                ps.setInt(1, myId);
                ps.setInt(2, targetId);

                return ps.executeUpdate() == 1;

            } else if ("ACCEPT".equals(action)) {

                String sql = "UPDATE user_relationships SET status='ACCEPTED' WHERE sender_id=? AND receiver_id=?";
                PreparedStatement ps = conn.prepareStatement(sql);

                ps.setInt(1, targetId);
                ps.setInt(2, myId);

                return ps.executeUpdate() == 1;

            } else {

                String sql = "DELETE FROM user_relationships " +
                             "WHERE (sender_id=? AND receiver_id=?) OR (sender_id=? AND receiver_id=?)";

                PreparedStatement ps = conn.prepareStatement(sql);

                ps.setInt(1, myId);
                ps.setInt(2, targetId);
                ps.setInt(3, targetId);
                ps.setInt(4, myId);

                return ps.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= PENDING REQUEST =================
    public List<UsersBeans> getPendingRequests(int userId) {

        List<UsersBeans> list = new ArrayList<>();

        String sql = "SELECT u.* FROM users u " +
                     "JOIN user_relationships r ON u.id = r.sender_id " +
                     "WHERE r.receiver_id = ? AND r.status = 'PENDING'";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new UsersBeans(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("name"),
                        rs.getString("user_img")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= SENT REQUEST =================
    public List<UsersBeans> getSentRequests(int userId) {

        List<UsersBeans> list = new ArrayList<>();

        String sql = "SELECT u.* FROM users u " +
                     "JOIN user_relationships r ON u.id = r.receiver_id " +
                     "WHERE r.sender_id = ? AND r.status = 'PENDING'";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new UsersBeans(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("name"),
                        rs.getString("user_img")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= FRIEND LIST =================
    public List<UsersBeans> getFriends(int userId) {

        List<UsersBeans> list = new ArrayList<>();

        String sql = "SELECT u.* FROM users u " +
                     "JOIN user_relationships r " +
                     "ON (u.id = r.sender_id OR u.id = r.receiver_id) " +
                     "WHERE (r.sender_id = ? OR r.receiver_id = ?) " +
                     "AND r.status = 'ACCEPTED' " +
                     "AND u.id != ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new UsersBeans(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("name"),
                        rs.getString("user_img")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= SEARCH =================
    public List<UsersBeans> searchUsers(String q, int myId) {

        List<UsersBeans> list = new ArrayList<>();

        String sql = "SELECT * FROM users WHERE name LIKE ? AND id != ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + q + "%");
            ps.setInt(2, myId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new UsersBeans(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("name"),
                        rs.getString("user_img")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}