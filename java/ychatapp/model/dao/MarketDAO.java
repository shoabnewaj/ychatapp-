package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import ychatapp.model.beans.MarketplaceItem;

public class MarketDAO {
    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }

    public List<MarketplaceItem> getAllItems() {
        List<MarketplaceItem> list = new ArrayList<>();
        String sql = "SELECT m.*, u.name as seller_name, u.profile_pic as seller_pic FROM marketplace_items m JOIN users u ON m.seller_id = u.id ORDER BY m.id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                MarketplaceItem item = new MarketplaceItem();
                item.setId(rs.getInt("id"));
                item.setTitle(rs.getString("title"));
                item.setDescription(rs.getString("description"));
                item.setPrice(rs.getDouble("price"));
                item.setImageUrl(rs.getString("image_url"));
                item.setSellerId(rs.getInt("seller_id"));
                item.setSellerName(rs.getString("seller_name"));
                item.setSellerPic(rs.getString("seller_pic"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addItem(String title, String description, double price, String imageUrl, int sellerId) {
        String sql = "INSERT INTO marketplace_items (title, description, price, image_url, seller_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setDouble(3, price);
            ps.setString(4, imageUrl);
            ps.setInt(5, sellerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
