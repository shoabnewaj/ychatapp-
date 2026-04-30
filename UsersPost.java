package ychatapp.model.beans;

import java.io.Serializable;
import java.util.List;

public class UsersPost implements Serializable {

    private int posts_id;
    private int users_id;
    private String name;
    private String content;
    private String fileName;
    private String postType;

    private int likes;
    private int dislikes;
    private List<String> comments;

    public UsersPost(){}

    public UsersPost(int posts_id, String name, int users_id, String content, String fileName, String postType){
        this.posts_id = posts_id;
        this.name = name;
        this.users_id = users_id;
        this.content = content;
        this.fileName = fileName;
        this.postType = postType;
    }

    public int getPosts_id(){ return posts_id; }
    public int getUsers_id(){ return users_id; }
    public String getName(){ return name; }
    public String getContent(){ return content; }
    public String getFileName(){ return fileName; }
    public String getPostType(){ return postType; }
    public int getLikes(){ return likes; }
    public int getDislikes(){ return dislikes; }
    public List<String> getComments(){ return comments; }

    public void setLikes(int likes){ this.likes = likes; }
    public void setDislikes(int dislikes){ this.dislikes = dislikes; }
    public void setComments(List<String> comments){ this.comments = comments; }
}