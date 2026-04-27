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

        HttpSession session = req.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");

        if (ub == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        int postId = Integer.parseInt(req.getParameter("postId"));
        String text = req.getParameter("commentText");

        if (text != null && !text.trim().isEmpty()) {
            new PostDAO().addComment(postId, ub.getId(), text);
        }

        res.sendRedirect("UsersPostServlet");
    }
}

