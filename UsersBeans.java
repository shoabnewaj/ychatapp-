package ychatapp.model.beans;

import java.io.Serializable;

public class UsersBeans implements Serializable {

    private int id;
    private String email;
    private String name;
    private String profile_pic; // 👈 user_img er poriborte profile_pic dilam

    private String pass;
    private String hashedPass;

    public UsersBeans() {}

    public UsersBeans(int id, String email, String name, String profile_pic) {
        this.id = id;
        this.email = email;
        this.name = name;
        this.profile_pic = profile_pic;
    }

    // ===== Getter =====
    public int getId() { return id; }
    public String getEmail() { return email; }
    public String getName() { return name; }
    public String getProfile_pic() { return profile_pic; } // 👈 Method name update
    public String getPass() { return pass; }
    public String getHashedPass() { return hashedPass; }

    // ===== Setter =====
    public void setId(int id) { this.id = id; }
    public void setEmail(String email) { this.email = email; }
    public void setName(String name) { this.name = name; }
    public void setProfile_pic(String profile_pic) { this.profile_pic = profile_pic; } // 👈 Servlet ekhon eta khunje pabe
    public void setPass(String pass) { this.pass = pass; }
    public void setHashedPass(String hashedPass) { this.hashedPass = hashedPass; }
}