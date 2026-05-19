package ychatapp.model.beans;

public class StoryBeans {
    private int id;
    private int userId;
    private String name;
    private String profilePic;
    private String mediaUrl;
    private String text;
    private String createdAt;

    public StoryBeans() {}

    public StoryBeans(int id, int userId, String name, String profilePic, String mediaUrl, String text, String createdAt) {
        this.id = id;
        this.userId = userId;
        this.name = name;
        this.profilePic = profilePic;
        this.mediaUrl = mediaUrl;
        this.text = text;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getProfilePic() { return profilePic; }
    public void setProfilePic(String profilePic) { this.profilePic = profilePic; }

    public String getMediaUrl() { return mediaUrl; }
    public void setMediaUrl(String mediaUrl) { this.mediaUrl = mediaUrl; }

    public String getText() { return text; }
    public void setText(String text) { this.text = text; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
