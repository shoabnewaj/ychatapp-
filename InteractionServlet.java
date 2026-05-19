package ychatapp.Servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.beans.UsersPost;
import ychatapp.model.dao.PostDAO;
import jakarta.servlet.annotation.MultipartConfig;

@WebServlet("/InteractionServlet")
@MultipartConfig
public class InteractionServlet extends HttpServlet {

    // @MultipartConfig থাকলে getParameter() কাজ করে না multipart request এ
    // তাই getPart() দিয়ে পড়তে হবে
    private String getFieldValue(HttpServletRequest req, String fieldName) {
        try {
            Part part = req.getPart(fieldName);
            if (part != null && part.getSize() > 0) {
                try (BufferedReader reader = new BufferedReader(
                        new InputStreamReader(part.getInputStream(), "UTF-8"))) {
                    StringBuilder sb = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) sb.append(line);
                    return sb.toString().trim();
                }
            }
        } catch (Exception e) {
            // ignore
        }
        // Fallback for non-multipart requests
        String val = req.getParameter(fieldName);
        return val != null ? val.trim() : null;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {

            String postIdStr = getFieldValue(request, "postId");
            if (postIdStr == null) postIdStr = getFieldValue(request, "id");

            String action = getFieldValue(request, "action");

            if (postIdStr == null || action == null) {
                out.write("{\"error\":\"invalid_request\"}");
                return;
            }

            int postId = Integer.parseInt(postIdStr);

            HttpSession session = request.getSession(false);
            UsersBeans ub = (UsersBeans) session.getAttribute("ub");

            if (ub == null) {
                out.write("{\"error\":\"not_logged_in\"}");
                return;
            }

            int userId = ub.getId();
            PostDAO dao = new PostDAO();

            // REACTION
            if (action.equalsIgnoreCase("LIKE") ||
                action.equalsIgnoreCase("LOVE") ||
                action.equalsIgnoreCase("CARE") ||
                action.equalsIgnoreCase("HAHA") ||
                action.equalsIgnoreCase("WOW") ||
                action.equalsIgnoreCase("SAD") ||
                action.equalsIgnoreCase("ANGRY") ||
                action.equalsIgnoreCase("DISLIKE") ||
                action.equalsIgnoreCase("DISLIKES")) {

                dao.handleInteraction(postId, userId, action.toUpperCase());
                
                // Get updated count to return
                UsersPost updatedPost = dao.getPostById(postId);
                
                // Add reaction notification
                if (updatedPost != null && userId != updatedPost.getUserId()) {
                    new ychatapp.model.dao.NotificationDAO().addNotification(
                        updatedPost.getUserId(),
                        ub.getName() + " reacted with " + action.toUpperCase() + " to your post: \"" + 
                        (updatedPost.getContent() != null && updatedPost.getContent().length() > 20 ? 
                         updatedPost.getContent().substring(0, 20) + "..." : updatedPost.getContent()) + "\""
                    );
                }

                int total = updatedPost.getLikeCount() + updatedPost.getLoveCount() + updatedPost.getCareCount() + 
                            updatedPost.getHahaCount() + updatedPost.getWowCount() + updatedPost.getSadCount() + 
                            updatedPost.getAngryCount() + updatedPost.getDislikes();

                out.write("{\"status\":\"ok\", \"newCount\":" + total + ", \"counts\":{" +
                          "\"Like\":" + updatedPost.getLikeCount() + "," +
                          "\"Love\":" + updatedPost.getLoveCount() + "," +
                          "\"Care\":" + updatedPost.getCareCount() + "," +
                          "\"Haha\":" + updatedPost.getHahaCount() + "," +
                          "\"Wow\":" + updatedPost.getWowCount() + "," +
                          "\"Sad\":" + updatedPost.getSadCount() + "," +
                          "\"Angry\":" + updatedPost.getAngryCount() + "," +
                          "\"Dislike\":" + updatedPost.getDislikes() + "}}");
                return;
            }

            // SHARE
            if ("SHARE".equalsIgnoreCase(action)) {

                UsersPost post = dao.getPostById(postId);

                if (post == null) {
                    out.write("{\"error\":\"not_found\"}");
                    return;
                }

                dao.sharePost(
                        userId,
                        post.getContent(),
                        post.getName(),
                        post.getFile_name(),
                        post.getPost_type(),
                        postId
                );
                
                // Add share notification
                if (userId != post.getUserId()) {
                    new ychatapp.model.dao.NotificationDAO().addNotification(
                        post.getUserId(),
                        ub.getName() + " shared your post: \"" + 
                        (post.getContent() != null && post.getContent().length() > 20 ? 
                         post.getContent().substring(0, 20) + "..." : post.getContent()) + "\""
                    );
                }

                out.write("{\"status\":\"shared\"}");
                return;
            }

            out.write("{\"error\":\"unknown\"}");

        } catch (Exception e) {
            e.printStackTrace();
            out.write("{\"error\":\"server\"}");
        }
    }
}