package ychatapp.Servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.PostDAO;

@WebServlet("/CommentServlet")
public class CommentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        try {

            HttpSession session = req.getSession(false);
            UsersBeans ub = (session != null) ? (UsersBeans) session.getAttribute("ub") : null;

            if (ub == null) {
                res.setStatus(403);
                return;
            }

            int postId = Integer.parseInt(req.getParameter("postId"));
            String text = req.getParameter("commentText");

            if (text != null && !text.trim().isEmpty()) {
                new PostDAO().addComment(postId, ub.getId(), text.trim());
            }

            res.setStatus(200);

        } catch (Exception e) {
            e.printStackTrace();
            res.setStatus(500);
        }
    }
}