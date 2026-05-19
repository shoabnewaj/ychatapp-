package ychatapp.Servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.beans.UsersPost;
import ychatapp.model.dao.PostDAO;
import ychatapp.model.dao.UsersDAO;

@WebServlet("/UsersProfileServlet")
@MultipartConfig
public class UsersProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");

        // 🔒 login check
        if (ub == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        try {
            UsersDAO userDAO = new UsersDAO();
            PostDAO postDAO = new PostDAO();

            // 👤 profile user load
            String paramId = req.getParameter("userId");
            int targetId;
            if (paramId == null || paramId.trim().isEmpty()) {
                targetId = ub.getId();
            } else {
                try {
                    targetId = Integer.parseInt(paramId);
                } catch (NumberFormatException e) {
                    targetId = ub.getId();
                }
            }
            UsersBeans profileUser = userDAO.getUserById(targetId);

            if (profileUser == null) {
                profileUser = ub; // Fallback to current user if target not found
            }

            // 📊 counts
            int friendsCount = userDAO.getProfileCount(profileUser.getId(), "FRIENDS");
            int followerCount = userDAO.getProfileCount(profileUser.getId(), "FOLLOWERS");
            int followingCount = userDAO.getProfileCount(profileUser.getId(), "FOLLOWING");

            // 📝 user posts
            List<UsersPost> userPosts = postDAO.getPostsByUserId(profileUser.getId());
            if (userPosts == null) userPosts = new java.util.ArrayList<>();
            
            // 👥 friends list
            List<UsersBeans> friendsList = userDAO.getFriends(profileUser.getId());
            if (friendsList == null) friendsList = new java.util.ArrayList<>();
            
            System.out.println(">>> Loading Profile for: " + profileUser.getName() + " (ID: " + profileUser.getId() + ")");
            System.out.println(">>> Found Posts: " + userPosts.size());
            System.out.println(">>> Found Friends: " + friendsList.size());

            // 🔗 relationship status
            String friendshipStatus = userDAO.getFriendshipStatus(ub.getId(), profileUser.getId());
            boolean isFollowing = userDAO.isFollowing(ub.getId(), profileUser.getId());

            // 🔗 set attributes
            req.setAttribute("profileUser", profileUser);
            req.setAttribute("friendsCount", friendsCount);
            req.setAttribute("followerCount", followerCount);
            req.setAttribute("followingCount", followingCount);
            req.setAttribute("userPosts", userPosts);
            req.setAttribute("friendsList", friendsList);
            req.setAttribute("friendshipStatus", friendshipStatus);
            req.setAttribute("isFollowing", isFollowing);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 🔁 forward
        req.getRequestDispatcher("/WEB-INF/jsp/profile.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        doGet(req, res);
    }
}