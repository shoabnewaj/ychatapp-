package ychatapp.model.beans;

import java.util.List;

public class UsersPost {

    private int id;
    private String name;
    private int userId;
    private String content;
    private String file_name;
    private String post_type;
    private String profile_pic;
    private String time;
    private String feeling; // ✅ নতুন যোগ করা হয়েছে
    private int commentCount; // ✅ নতুন যোগ করা হয়েছে
    private int shareCount; // ✅ নতুন যোগ করা হয়েছে

    public int getShareCount() {
		return shareCount;
	}

	public void setShareCount(int shareCount) {
		this.shareCount = shareCount;
	}

	// রিঅ্যাকশন কাউন্টার
    private int likeCount, loveCount, hahaCount, wowCount, sadCount, angryCount, Care, dislikes;

    // কমেন্ট লিস্ট
    private List<CommentBeans> comments;

    // ✅ আপডেট করা ফুল কনস্ট্রাক্টর (Feeling সহ)
    public UsersPost(int id, String name, int userId, String content, String file_name, String post_type, String feeling) {
        this.id = id;
        this.name = name;
        this.userId = userId;
        this.content = content;
        this.file_name = file_name;
        this.post_type = post_type;
        this.feeling = feeling;
    }

    // ডিফল্ট কনস্ট্রাক্টর
    public UsersPost() {}

    // ✅ GETTERS
    public int getId() { return id; }
    public String getName() { return name; }
    public int getUserId() { return userId; }
    public String getContent() { return content; }
    public String getFile_name() { return file_name; }
    public String getPost_type() { return post_type; }
    public String getProfile_pic() { return profile_pic; }
    public int getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(int commentCount) {
		this.commentCount = commentCount;
	}

	public String getTime() { return time; }
    public String getFeeling() { return feeling; } // JSP এর জন্য অত্যন্ত জরুরি

    public int getLikeCount() { return likeCount; }
    public int getLoveCount() { return loveCount; }
    public int getHahaCount() { return hahaCount; }
    public int getWowCount() { return wowCount; }
    public int getSadCount() { return sadCount; }
    public int getAngryCount() { return angryCount; }
    public int getCareCount() { return Care; }
    public int getDislikes() {return dislikes;}

	public List<CommentBeans> getComments() { return comments; }

    // ✅ SETTERS
    public void setId(int id) { this.id = id; }
    public void setName(String name) { this.name = name; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setContent(String content) { this.content = content; }
    public void setFile_name(String file_name) { this.file_name = file_name; }
    public void setPost_type(String post_type) { this.post_type = post_type; }
    public void setProfile_pic(String profile_pic) { this.profile_pic = profile_pic; }
    public void setTime(String time) { this.time = time; }
    public void setFeeling(String feeling) { this.feeling = feeling; } // ডাটাবেজ থেকে ডাটা সেট করার জন্য

    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }
    public void setLoveCount(int loveCount) { this.loveCount = loveCount; }
    public void setHahaCount(int hahaCount) { this.hahaCount = hahaCount; }
    public void setWowCount(int wowCount) { this.wowCount = wowCount; }
    public void setSadCount(int sadCount) { this.sadCount = sadCount; }
    public void setAngryCount(int angryCount) { this.angryCount = angryCount; }
    public void setCareCount(int careCount) { this.Care = careCount; }
    public void setDislikes(int dislikes) {this.dislikes = dislikes;}

	public void setComments(List<CommentBeans> comments) { this.comments = comments; }
}