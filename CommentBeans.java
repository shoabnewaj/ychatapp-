package ychatapp.model.beans;

import java.util.List;

public class CommentBeans {

    private int id;
    private int userId;
    private String name;

	private String text;
    private String user_pic;
    private String time;
    private String file_name;
    private String profilePic;
    private String comment_text;  


	private int likeCount, loveCount, hahaCount, wowCount, sadCount, angryCount, careCount, dislikes;

    private List<Reply> replies;

    // ===== GETTERS =====
    public int getId() { return id; }
    
    public String getComment_text() {
    	return comment_text;
    }
    public int getUserId() { return userId; }
    
    public String getName() { return name; }
    
    public String getFile_name() {
    	return file_name;
    }
    public String getProfilePic() {
    	return profilePic;
    }
    public String getText() { return text; }
    public String getUser_pic() { return user_pic; }
    public String getTime() { return time; }

    public int getLikeCount() { return likeCount; }
    public int getLoveCount() { return loveCount; }
    public int getHahaCount() { return hahaCount; }
    public int getWowCount() { return wowCount; }
    public int getSadCount() { return sadCount; }
    public int getAngryCount() { return angryCount; }
    public int getCareCount() { return careCount; }
    public int getDislikes() { return dislikes; }

    public List<Reply> getReplies() { return replies; }

    // ===== SETTERS =====
    public void setId(int id) { this.id = id; }
    public void setComment_text(String comment_text) {
    	this.comment_text = comment_text;
    }
    public void setUserId(int userId) { this.userId = userId; }
    
    public void setFile_name(String file_name) {
    	this.file_name = file_name;
    }
    
    public void setProfilePic(String profilePic) {
    	this.profilePic = profilePic;
    }
    public void setName(String name) { this.name = name; }
    public void setText(String text) { this.text = text; }
    public void setUser_pic(String user_pic) { this.user_pic = user_pic; }
    public void setTime(String time) { this.time = time; }

    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }
    public void setLoveCount(int loveCount) { this.loveCount = loveCount; }
    public void setHahaCount(int hahaCount) { this.hahaCount = hahaCount; }
    public void setWowCount(int wowCount) { this.wowCount = wowCount; }
    public void setSadCount(int sadCount) { this.sadCount = sadCount; }
    public void setAngryCount(int angryCount) { this.angryCount = angryCount; }
    public void setCareCount(int careCount) { this.careCount = careCount; }
    public void setDislikes(int dislikes) { this.dislikes = dislikes; }

    public void setReplies(List<Reply> replies) { this.replies = replies; }
    
}
