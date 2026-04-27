package ychatapp.model.beans;

import java.io.Serializable;

public class UsersBeans implements Serializable {

    private int id;
    private String email;
    private String name;
    private String user_img;

    private String pass;
    private String hashedPass;

    public UsersBeans() {}

    public UsersBeans(int id, String email, String name, String user_img) {
        this.id = id;
        this.email = email;
        this.name = name;
        this.user_img = user_img;
    }

    // ===== Getter =====
    public int getId() { return id; }
    public String getEmail() { return email; }
    public String getName() { return name; }
    public String getUser_img() { return user_img; }
    public String getPass() { return pass; }
    public String getHashedPass() { return hashedPass; }

    // ===== Setter =====
    public void setId(int id) { this.id = id; }
    public void setEmail(String email) { this.email = email; }
    public void setName(String name) { this.name = name; }
    public void setUser_img(String user_img) { this.user_img = user_img; }
    public void setPass(String pass) { this.pass = pass; }
    public void setHashedPass(String hashedPass) { this.hashedPass = hashedPass; }
}