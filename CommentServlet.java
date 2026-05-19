package ychatapp.Servlet;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.CommentDAO;

@WebServlet("/CommentServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class CommentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\b", "\\b")
                  .replace("\f", "\\f")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }

    // Helper method to safely read form text field data under Multipart configs
    private String getFieldValue(HttpServletRequest req, String fieldName) {
        try {
            Part part = req.getPart(fieldName);
            if (part != null && part.getSize() > 0) {
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(part.getInputStream(), "UTF-8"))) {
                    StringBuilder sb = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sb.append(line);
                    }
                    return sb.toString().trim();
                }
            }
        } catch (Exception e) {
            // Fallback to standard request routing if part extraction drops
        }
        String fallback = req.getParameter(fieldName);
        return fallback != null ? fallback.trim() : null;
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        PrintWriter out = res.getWriter();
        HttpSession session = req.getSession(false);
        UsersBeans ub = null;

        if (session != null) {
            ub = (UsersBeans) session.getAttribute("ub");
        }

        if (ub == null) {
            out.write("{\"error\":\"not_logged_in\"}");
            return;
        }

        try {
            // Extract the action parameters directly from the multi-part body stream safely
            String action = getFieldValue(req, "action");

            if (action == null || action.isEmpty()) {
                action = "ADD";
            }

            CommentDAO dao = new CommentDAO();

            /*
             ======================================================
             ADD COMMENT
             ======================================================
            */
            if (action.equalsIgnoreCase("ADD") || action.equalsIgnoreCase("ADD_COMMENT")) {

                String postIdStr = getFieldValue(req, "postId");
                
                // Read text across all possible parameter names sent by the client interface
                String text = getFieldValue(req, "commentText");
                if (text == null || text.isEmpty()) {
                    text = getFieldValue(req, "comment_text");
                }
                if (text == null || text.isEmpty()) {
                    text = getFieldValue(req, "comment");
                }

                String file_name = null;

                try {
                    Part filePart = req.getPart("media");
                    if (filePart != null && filePart.getSize() > 0) {
                        String originalFile = filePart.getSubmittedFileName();
                        if (originalFile != null && !originalFile.isEmpty()) {
                            file_name = System.currentTimeMillis() + "_" + originalFile;
                            String uploadPath = getServletContext().getRealPath("") + "img" + File.separator;
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) {
                                uploadDir.mkdirs();
                            }
                            filePart.write(uploadPath + file_name);
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                if (postIdStr == null || ((text == null || text.isEmpty()) && file_name == null)) {
                    out.write("{\"error\":\"missing_data\"}");
                    return;
                }

                int postId = Integer.parseInt(postIdStr);
                int newCommentId = dao.addComment(postId, ub.getId(), text, file_name);

                // Comment notification
                try {
                    ychatapp.model.beans.UsersPost post = new ychatapp.model.dao.PostDAO().getPostById(postId);
                    if (post != null && post.getUserId() != ub.getId()) {
                        String shortText = (text != null && text.length() > 25) ? text.substring(0, 25) + "..." : text;
                        new ychatapp.model.dao.NotificationDAO().addNotification(
                            post.getUserId(),
                            ub.getName() + " commented on your post: \"" + shortText + "\""
                        );
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                int count = dao.getCommentCount(postId);

                out.write(
                        "{"
                                + "\"success\":true,"
                                + "\"type\":\"COMMENT_ADDED\","
                                + "\"postId\":" + postId + ","
                                + "\"commentId\":" + newCommentId + ","
                                + "\"count\":" + count + ","
                                + "\"userName\":\"" + escapeJson(ub.getName()) + "\","
                                + "\"userPic\":\"" + escapeJson(ub.getProfile_pic()) + "\","
                                + "\"text\":\"" + escapeJson(text) + "\","
                                + "\"fileName\":\"" + escapeJson(file_name != null ? file_name : "") + "\","
                                + "\"userId\":" + ub.getId()
                                + "}"
                );
            }

            /*
             ======================================================
             COMMENT / REPLY REACTION
             ======================================================
            */
            else if (action.equalsIgnoreCase("LIKE")    || action.equalsIgnoreCase("LOVE")  ||
                     action.equalsIgnoreCase("CARE")    || action.equalsIgnoreCase("HAHA")  ||
                     action.equalsIgnoreCase("WOW")     || action.equalsIgnoreCase("SAD")   ||
                     action.equalsIgnoreCase("ANGRY")   || action.equalsIgnoreCase("DISLIKES") ||
                     action.equalsIgnoreCase("DISLIKE")) {

                String targetIdStr = getFieldValue(req, "commentId");
                String level = getFieldValue(req, "level"); // "comment" or "reply"
                if (targetIdStr == null) {
                    out.write("{\"error\":\"missing_id\"}");
                    return;
                }

                int targetId = Integer.parseInt(targetIdStr);

                if ("reply".equalsIgnoreCase(level)) {
                    dao.handleReplyInteraction(targetId, ub.getId(), action);
                    // Get updated total count
                    int c_like = dao.getReplyCount(targetId, "LIKE");
                    int c_love = dao.getReplyCount(targetId, "LOVE");
                    int c_care = dao.getReplyCount(targetId, "CARE");
                    int c_haha = dao.getReplyCount(targetId, "HAHA");
                    int c_wow = dao.getReplyCount(targetId, "WOW");
                    int c_sad = dao.getReplyCount(targetId, "SAD");
                    int c_angry = dao.getReplyCount(targetId, "ANGRY");
                    int c_dislike = dao.getReplyCount(targetId, "DISLIKES");
                    int count = c_like + c_love + c_care + c_haha + c_wow + c_sad + c_angry + c_dislike;
                    
                    out.write("{\"success\":true,\"type\":\"REPLY_REACT\",\"replyId\":" + targetId + ",\"newCount\":" + count + ", \"counts\":{" +
                              "\"Like\":" + c_like + "," +
                              "\"Love\":" + c_love + "," +
                              "\"Care\":" + c_care + "," +
                              "\"Haha\":" + c_haha + "," +
                              "\"Wow\":" + c_wow + "," +
                              "\"Sad\":" + c_sad + "," +
                              "\"Angry\":" + c_angry + "," +
                              "\"Dislike\":" + c_dislike + "}}");
                } else {
                    dao.handleInteraction(targetId, ub.getId(), action);
                    // Get updated total count
                    int c_like = dao.getCount(targetId, "LIKE");
                    int c_love = dao.getCount(targetId, "LOVE");
                    int c_care = dao.getCount(targetId, "CARE");
                    int c_haha = dao.getCount(targetId, "HAHA");
                    int c_wow = dao.getCount(targetId, "WOW");
                    int c_sad = dao.getCount(targetId, "SAD");
                    int c_angry = dao.getCount(targetId, "ANGRY");
                    int c_dislike = dao.getCount(targetId, "DISLIKES");
                    int count = c_like + c_love + c_care + c_haha + c_wow + c_sad + c_angry + c_dislike;
                    
                    out.write("{\"success\":true,\"type\":\"COMMENT_REACT\",\"commentId\":" + targetId + ",\"newCount\":" + count + ", \"counts\":{" +
                              "\"Like\":" + c_like + "," +
                              "\"Love\":" + c_love + "," +
                              "\"Care\":" + c_care + "," +
                              "\"Haha\":" + c_haha + "," +
                              "\"Wow\":" + c_wow + "," +
                              "\"Sad\":" + c_sad + "," +
                              "\"Angry\":" + c_angry + "," +
                              "\"Dislike\":" + c_dislike + "}}");
                }
            }

            /*
             ======================================================
             ADD REPLY
             ======================================================
            */
            else if (action.equalsIgnoreCase("REPLY")) {

                String commentIdStr = getFieldValue(req, "commentId");
                String text = getFieldValue(req, "replyText");
                if (text == null || text.isEmpty()) {
                    text = getFieldValue(req, "reply_text");
                }

                String file_name = null;

                try {
                    Part filePart = req.getPart("media");
                    if (filePart != null && filePart.getSize() > 0) {
                        String originalFile = filePart.getSubmittedFileName();
                        if (originalFile != null && !originalFile.isEmpty()) {
                            file_name = System.currentTimeMillis() + "_" + originalFile;
                            String uploadPath = getServletContext().getRealPath("") + "img" + File.separator;
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) {
                                uploadDir.mkdirs();
                            }
                            filePart.write(uploadPath + file_name);
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                if (commentIdStr == null || ((text == null || text.isEmpty()) && file_name == null)) {
                    out.write("{\"error\":\"empty_reply\"}");
                    return;
                }

                int commentId = Integer.parseInt(commentIdStr);
                int newReplyId = dao.addReply(commentId, ub.getId(), text, file_name);

                // Reply notification
                try {
                    int commentAuthorId = dao.getCommentAuthorId(commentId);
                    if (commentAuthorId != -1 && commentAuthorId != ub.getId()) {
                        String shortText = (text != null && text.length() > 25) ? text.substring(0, 25) + "..." : text;
                        new ychatapp.model.dao.NotificationDAO().addNotification(
                            commentAuthorId,
                            ub.getName() + " replied to your comment: \"" + shortText + "\""
                        );
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                out.write(
                        "{"
                                + "\"success\":true,"
                                + "\"type\":\"REPLY_ADDED\","
                                + "\"commentId\":" + commentId + ","
                                + "\"replyId\":" + newReplyId + ","
                                + "\"userName\":\"" + escapeJson(ub.getName()) + "\","
                                + "\"userPic\":\"" + escapeJson(ub.getProfile_pic()) + "\","
                                + "\"text\":\"" + escapeJson(text) + "\","
                                + "\"fileName\":\"" + escapeJson(file_name != null ? file_name : "") + "\","
                                + "\"userId\":" + ub.getId()
                                + "}"
                );
            }

            /*
             ======================================================
             INVALID ACTION
             ======================================================
            */
            else {
                out.write("{\"error\":\"invalid_action\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            out.write("{\"error\":\"server_exception\",\"message\":\"" + e.getMessage() + "\"}");
        } finally {
            out.flush();
            out.close();
        }
    }
}
