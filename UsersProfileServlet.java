package ychatapp.Servlet;

import java.io.File;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.UsersDAO;

@WebServlet("/UsersProfileServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class UsersProfileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
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
            // Database-e followers table na thakle eita 0 return korbe (DAO method thik thakle)
            req.setAttribute("friendsCount", dao.getProfileCount(pid, "FRIENDS"));
            req.setAttribute("followerCount", dao.getProfileCount(pid, "FOLLOWERS"));
            req.setAttribute("followingCount", dao.getProfileCount(pid, "FOLLOWING"));

            if (pid != ub.getId()) {
                req.setAttribute("friendStatus", dao.getFriendshipStatus(ub.getId(), pid));
            }
        }
        req.getRequestDispatcher("/WEB-INF/jsp/profile.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");
        if (ub == null) { res.sendRedirect("UsersLoginServlet"); return; }

        try {
            Part filePart = req.getPart("profilePic");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = "profile_" + ub.getId() + "_" + System.currentTimeMillis() + ".png";
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                filePart.write(uploadPath + File.separator + fileName);

                UsersDAO dao = new UsersDAO();
                if(dao.updateProfilePic(ub.getId(), fileName)) {
                    ub.setProfile_pic(fileName); 
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        res.sendRedirect("UsersProfileServlet");
    }
}