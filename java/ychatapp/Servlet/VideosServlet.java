package ychatapp.Servlet;

import java.io.File;
import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.beans.UsersPost;
import ychatapp.model.dao.PostDAO;

@WebServlet("/VideosServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 100, // videos can be up to 100MB
        maxRequestSize = 1024 * 1024 * 120
)
public class VideosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final PostDAO postDAO = new PostDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("ub") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        List<UsersPost> videos = postDAO.getVideoPosts();
        req.setAttribute("videos", videos);
        req.getRequestDispatcher("/WEB-INF/jsp/videos.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("ub") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        UsersBeans ub = (UsersBeans) session.getAttribute("ub");
        String content = req.getParameter("content");

        String file_name = null;
        try {
            Part filePart = req.getPart("videoFile");
            if (filePart != null && filePart.getSize() > 0) {
                String originalFile = filePart.getSubmittedFileName();
                if (originalFile != null && !originalFile.isEmpty()) {
                    file_name = System.currentTimeMillis() + "_" + originalFile;
                    String uploadPath = getServletContext().getRealPath("") + "img" + File.separator;
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    filePart.write(uploadPath + file_name);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (file_name != null) {
            // Save post as video type
            postDAO.addPost(ub.getId(), content, file_name, "video", null);
        }

        res.sendRedirect("VideosServlet");
    }
}
