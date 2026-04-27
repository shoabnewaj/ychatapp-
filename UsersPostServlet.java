package ychatapp.Servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.beans.UsersPost;
import ychatapp.model.dao.NotificationDAO;
import ychatapp.model.dao.PostDAO;
import ychatapp.model.dao.UsersDAO;



@WebServlet("/UsersPostServlet")
public class UsersPostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // ================= 🔥 LOAD MAIN PAGE =================
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");

        // 🔐 Login check
        if (ub == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        UsersDAO uDao = new UsersDAO();
        PostDAO pDao = new PostDAO();
        NotificationDAO ndao = new NotificationDAO();

        // 🔍 Search
        String q = req.getParameter("query");
        if (q != null && !q.trim().isEmpty()) {
            req.setAttribute("searchList", uDao.searchUsers(q, ub.getId()));
        }

        // 📩 Friend Request (optional show)
        req.setAttribute("pendingRequests", uDao.getPendingRequests(ub.getId()));

        // 📝 Post List
        List<UsersPost> postList = pDao.getAllposts();
        req.setAttribute("postList", postList);

        // 🔔 Notifications (MAIN FEATURE)
        req.setAttribute("notifications", ndao.getNotifications(ub.getId()));

        // 👉 JSP
        req.getRequestDispatcher("/WEB-INF/jsp/main.jsp").forward(req, res);
    }

    // ================= 🔥 ADD POST =================
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");

        if (ub == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        String content = req.getParameter("content");

        if (content != null && !content.trim().isEmpty()) {

            PostDAO pDao = new PostDAO();
            pDao.addPost(ub.getId(), content);

            // 🔔 (OPTIONAL) self notification
            NotificationDAO ndao = new NotificationDAO();
            ndao.addNotification(ub.getId(), "📝 You posted something!");
        }

        // 🔁 reload
        res.sendRedirect("UsersPostServlet");
    }
}