package ychatapp.Servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.beans.UsersPost;
import ychatapp.model.dao.PostDAO;

@WebServlet("/InteractionServlet")
public class InteractionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json"); // 🔥 IMPORTANT (NO RELOAD AJAX)

        try {

            int postId = Integer.parseInt(request.getParameter("postId"));
            String action = request.getParameter("action");

            HttpSession session = request.getSession();
            UsersBeans ub = (UsersBeans) session.getAttribute("ub");

            if (ub == null) {
                response.getWriter().write("{\"error\":\"not_logged_in\"}");
                return;
            }

            int userId = ub.getId();
            PostDAO dao = new PostDAO();

            int likes = 0;
            int dislikes = 0;

            String html = "";

            // ================= LIKE / DISLIKE =================
            if ("LIKE".equals(action) || "DISLIKE".equals(action)) {

                dao.handleInteraction(postId, userId, action);

                likes = dao.getInteractionCount(postId, "LIKE");
                dislikes = dao.getInteractionCount(postId, "DISLIKE");

                response.getWriter().write(
                    "{"
                    + "\"likes\":" + likes + ","
                    + "\"dislikes\":" + dislikes
                    + "}"
                );
                return;
            }

            // ================= SHARE =================
            else if ("SHARE".equals(action)) {

                UsersPost post = dao.getPostById(postId);

                if (post != null) {

                    dao.sharePost(
                        userId,
                        post.getContent(),
                        post.getName(),
                        post.getFileName(),
                        post.getPostType()
                    );

                    // 🔥 RETURN HTML FOR INSTANT INSERT (NO RELOAD)
                    html =
                    "<div class='post-card'>" +

                    "<b><a href='UsersProfileServlet?userId=" + post.getUsers_id() + "' style='color:purple;text-decoration:none'>" +
                    post.getName() +
                    "</a></b>" +

                    "<p>" + post.getContent() + "</p>";

                    if (post.getFileName() != null) {

                        if ("image".equals(post.getPostType())) {
                            html += "<img class='post-media' src='media?file=" + post.getFileName() + "'>";
                        }

                        if ("video".equals(post.getPostType())) {
                            html += "<video class='post-media' controls>"
                                  + "<source src='media?file=" + post.getFileName() + "'>"
                                  + "</video>";
                        }
                    }

                    html += "</div>";
                }

                response.getWriter().write(
                    "{"
                    + "\"html\":\"" + html.replace("\"", "\\\"") + "\""
                    + "}"
                );
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\":\"server_error\"}");
        }
    }
}