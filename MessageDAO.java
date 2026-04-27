package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import ychatapp.model.Message;

public class MessageDAO {

    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/yourdb", "root", "password"
        );
    }

    public List<Message> getChat(String u1, String u2) {
        List<Message> list = new ArrayList<>();

        try (Connection con = getConnection()) {

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM messages WHERE (sender=? AND receiver=?) OR (sender=? AND receiver=?) ORDER BY id ASC"
            );

            ps.setString(1, u1);
            ps.setString(2, u2);
            ps.setString(3, u2);
            ps.setString(4, u1);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                list.add(new Message(
                    rs.getString("sender"),
                    rs.getString("receiver"),
                    rs.getString("message")
                ));
            }

        } catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }

    public void saveMessage(String s,String r,String m){
        try (Connection con = getConnection()) {

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO messages(sender,receiver,message) VALUES(?,?,?)"
            );

            ps.setString(1,s);
            ps.setString(2,r);
            ps.setString(3,m);
            ps.executeUpdate();

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}