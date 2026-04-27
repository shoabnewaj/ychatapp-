package ychatapp.model.beans;

import java.io.Serializable;
import java.util.List;

public class UsersPost implements Serializable {

    private int posts_id;
    private int users_id;
    private int likes;
    private int dislikes;

    private String name;
    private String content;

    private List<String> comments;

    public UsersPost() {}

    public UsersPost(int posts_id, String name, int users_id, String content) {
        this.posts_id = posts_id;
        this.name = name;
        this.users_id = users_id;
        this.content = content;
    }

    // ===== GETTERS =====
    public int getPosts_id() { return posts_id; }
    public int getUsers_id() { return users_id; }
    public String getName() { return name; }
    public String getContent() { return content; }
    public int getLikes() { return likes; }
    public int getDislikes() { return dislikes; }
    public List<String> getComments() { return comments; }

    // ===== SETTERS =====
    public void setLikes(int likes) { this.likes = likes; }
    public void setDislikes(int dislikes) { this.dislikes = dislikes; }
    public void setComments(List<String> comments) { this.comments = comments; }
}