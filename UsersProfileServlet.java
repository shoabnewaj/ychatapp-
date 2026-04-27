package ychatapp.Servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.UsersDAO;



@WebServlet("/UsersProfileServlet")
public class UsersProfileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");

        if (ub == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        UsersDAO dao = new UsersDAO();

        int pid = ub.getId();

        String tid = req.getParameter("userId");
        if (tid != null && !tid.isEmpty()) {
            pid = Integer.parseInt(tid);
        }

        UsersBeans profileUser = dao.getUserById(pid);

        if (profileUser != null) {

            req.setAttribute("profileUser", profileUser);
            req.setAttribute("friendsCount", dao.getProfileCount(pid, "FRIENDS"));
            req.setAttribute("followerCount", dao.getProfileCount(pid, "FOLLOWERS"));
            req.setAttribute("followingCount", dao.getProfileCount(pid, "FOLLOWING"));

            if (pid != ub.getId()) {
                req.setAttribute("friendStatus",
                        dao.getFriendshipStatus(ub.getId(), pid));
            }
        }

        req.getRequestDispatcher("/WEB-INF/jsp/profile.jsp").forward(req, res);
    }
}