package ychatapp.model.beans;

public class Reply {

    private int id;
    private int userId;
    private String name;
    private String text;
    private String user_pic;
    private String media;   // reply এর attached image/video
    private String time;

    private int likeCount, loveCount, hahaCount, wowCount, sadCount, angryCount, careCount, dislikes;

    // ===== GETTERS =====
    public int getId() { return id; }
    public int getUserId() { return userId; }
    public String getName() { return name; }
    public String getText() { return text; }
    public String getUser_pic() { return user_pic; }
    /** EL alias: ${reply.profilePic} */
    public String getProfilePic() { return user_pic; }
    public String getMedia() { return media; }
    public String getTime() { return time; }

    public int getLikeCount() { return likeCount; }
    public int getLoveCount() { return loveCount; }
    public int getHahaCount() { return hahaCount; }
    public int getWowCount() { return wowCount; }
    public int getSadCount() { return sadCount; }
    public int getAngryCount() { return angryCount; }
    public int getCareCount() { return careCount; }
    public int getDislikes() { return dislikes; }

    // ===== SETTERS =====
    public void setId(int id) { this.id = id; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setName(String name) { this.name = name; }
    public void setText(String text) { this.text = text; }
    public void setUser_pic(String user_pic) { this.user_pic = user_pic; }
    public void setMedia(String media) { this.media = media; }
    public void setTime(String time) { this.time = time; }

    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }
    public void setLoveCount(int loveCount) { this.loveCount = loveCount; }
    public void setHahaCount(int hahaCount) { this.hahaCount = hahaCount; }
    public void setWowCount(int wowCount) { this.wowCount = wowCount; }
    public void setSadCount(int sadCount) { this.sadCount = sadCount; }
    public void setAngryCount(int angryCount) { this.angryCount = angryCount; }
    public void setCareCount(int careCount) { this.careCount = careCount; }
    public void setDislikes(int dislikes) { this.dislikes = dislikes; }
}

