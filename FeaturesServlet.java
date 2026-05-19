package ychatapp.Servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.beans.UsersPost;
import ychatapp.model.dao.PostDAO;

@WebServlet("/FeaturesServlet")
public class FeaturesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final PostDAO postDAO = new PostDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("application/json; charset=UTF-8");
        PrintWriter out = res.getWriter();

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("ub") == null) {
            out.print("{\"success\": false, \"message\": \"Not authenticated\"}");
            return;
        }

        UsersBeans ub = (UsersBeans) session.getAttribute("ub");
        String action = req.getParameter("action");

        if ("GET_SAVED".equalsIgnoreCase(action)) {
            List<UsersPost> list = postDAO.getSavedPosts(ub.getId());
            out.print(toJsonString(list));
        } else if ("GET_MEMORIES".equalsIgnoreCase(action)) {
            List<UsersPost> list = postDAO.getMemoriesPosts(ub.getId());
            out.print(toJsonString(list));
        } else {
            out.print("{\"success\": false, \"message\": \"Invalid action\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("application/json; charset=UTF-8");
        PrintWriter out = res.getWriter();

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("ub") == null) {
            out.print("{\"success\": false, \"message\": \"Not authenticated\"}");
            return;
        }

        UsersBeans ub = (UsersBeans) session.getAttribute("ub");
        String action = req.getParameter("action");
        String postIdStr = req.getParameter("postId");

        if (postIdStr == null || postIdStr.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"Missing postId\"}");
            return;
        }

        try {
            int postId = Integer.parseInt(postIdStr);
            boolean success = false;

            if ("SAVE".equalsIgnoreCase(action)) {
                success = postDAO.savePost(ub.getId(), postId);
                out.print("{\"success\": " + success + ", \"saved\": true}");
            } else if ("UNSAVE".equalsIgnoreCase(action)) {
                success = postDAO.unsavePost(ub.getId(), postId);
                out.print("{\"success\": " + success + ", \"saved\": false}");
            } else {
                out.print("{\"success\": false, \"message\": \"Invalid action\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid postId format\"}");
        }
    }

    private String toJsonString(List<UsersPost> posts) {
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for (int i = 0; i < posts.size(); i++) {
            UsersPost p = posts.get(i);
            sb.append("{");
            sb.append("\"id\": ").append(p.getId()).append(",");
            sb.append("\"userId\": ").append(p.getUserId()).append(",");
            sb.append("\"name\": \"").append(escapeJson(p.getName())).append("\",");
            sb.append("\"content\": \"").append(escapeJson(p.getContent())).append("\",");
            sb.append("\"fileName\": \"").append(escapeJson(p.getFile_name() == null ? "" : p.getFile_name())).append("\",");
            sb.append("\"postType\": \"").append(escapeJson(p.getPost_type() == null ? "" : p.getPost_type())).append("\",");
            sb.append("\"feeling\": \"").append(escapeJson(p.getFeeling() == null ? "" : p.getFeeling())).append("\",");
            sb.append("\"profile_Pic\": \"").append(escapeJson(p.getProfile_pic() == null ? "" : p.getProfile_pic())).append("\",");
            sb.append("\"time\": \"").append(escapeJson(p.getTime())).append("\",");
            sb.append("\"shareCount\": ").append(p.getShareCount());
            sb.append("}");
            if (i < posts.size() - 1) {
                sb.append(",");
            }
        }
        sb.append("]");
        return sb.toString();
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
