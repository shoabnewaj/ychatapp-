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



@WebServlet("/InteractionServlet")
public class InteractionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");

        if (ub == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        int postId = Integer.parseInt(req.getParameter("postId"));
        String action = req.getParameter("action");

        PostDAO dao = new PostDAO();

        if ("LIKE".equals(action) || "DISLIKE".equals(action)) {
            dao.handleInteraction(postId, ub.getId(), action);
        }

        else if ("SHARE".equals(action)) {
            String content = req.getParameter("content");
            String owner = req.getParameter("owner");
            dao.sharePost(ub.getId(), content, owner);
        }

        res.sendRedirect("UsersPostServlet");
    }
}