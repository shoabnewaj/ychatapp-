package ychatapp.Servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
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
import ychatapp.model.dao.StoryDAO;

@WebServlet("/UsersPostServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class UsersPostServlet extends HttpServlet {

    // ================= GET (Feed Display) =================
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        PostDAO dao = new PostDAO();

        List<UsersPost> postList = new ArrayList<>();
        List<UsersPost> reelsList = new ArrayList<>();
        
        // getAllposts() এখন নিজেই comments fetch করে, তাই আলাদা loop দরকার নেই
        for (UsersPost post : dao.getAllposts()) {
            if ("REEL".equalsIgnoreCase(post.getPost_type())) {
                reelsList.add(post);
            } else {
                postList.add(post);
            }
        }
        req.setAttribute("postList", postList);
        req.setAttribute("reelsList", reelsList);
        req.setAttribute("storyList", new StoryDAO().getActiveStories());

        // Sidebar friends
        HttpSession session = req.getSession(false);
        if (session != null) {
            ychatapp.model.beans.UsersBeans ub = (ychatapp.model.beans.UsersBeans) session.getAttribute("ub");
            if (ub != null) {
                ychatapp.model.dao.UsersDAO usersDAO = new ychatapp.model.dao.UsersDAO();
                req.setAttribute("friendList", usersDAO.getFriends(ub.getId()));
            }
        }
        
        req.getRequestDispatcher("/WEB-INF/jsp/main.jsp").forward(req, res);
    }


    // ================= POST (Create or Share Post) =================
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        UsersBeans ub = (session != null)
                ? (UsersBeans) session.getAttribute("ub")
                : null;

        // 🔐 LOGIN CHECK
        if (ub == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        PostDAO dao = new PostDAO();
        String action = req.getParameter("action"); // Share করার জন্য action লাগবে

        // 🔄 HANDLE SHARE POST (রিকোয়ারমেন্ট ৪ ও ৯ অনুযায়ী)
        if ("SHARE".equalsIgnoreCase(action)) {
            String postIdStr = req.getParameter("postId");
            if (postIdStr != null) {
                int postId = Integer.parseInt(postIdStr);
                UsersPost originalPost = dao.getPostById(postId);
                
                if (originalPost != null) {
                    // শেয়ার করার সময় অরিজিনাল মিডিয়া এবং কন্টেন্ট বজায় রাখা
                    dao.sharePost(ub.getId(), originalPost.getContent(), originalPost.getName(), originalPost.getFile_name(), "shared", postId);
                }
            }
        }
        // 🗑️ HANDLE DELETE POST
        else if ("DELETE".equalsIgnoreCase(action)) {
            String postIdStr = req.getParameter("postId");
            boolean success = false;
            if (postIdStr != null) {
                int postId = Integer.parseInt(postIdStr);
                success = dao.deletePost(postId);
            }
            if ("true".equals(req.getParameter("ajax"))) {
                res.setContentType("application/json");
                res.setCharacterEncoding("UTF-8");
                res.getWriter().write("{\"success\": " + success + "}");
                return;
            }
        } 
        // 📝 HANDLE NEW POST (রিকোয়ারমেন্ট ৩ ও ৪ অনুযায়ী)
        else {
            String content = req.getParameter("content");
            String feeling = req.getParameter("feeling"); // ✅ Feeling রিসিভ করা হচ্ছে (ফিক্স)

            // ✅ POST TYPE নির্ধারণ
            String postType = req.getParameter("type");
            if (postType == null || postType.isEmpty()) {
                postType = "original";
            }

            String fileName = null;

            try {
                Part part = req.getPart("media"); // ছবি বা ভিডিও

                if (part != null && part.getSize() > 0) {
                    String submittedFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();

                    if (submittedFileName != null && !submittedFileName.isEmpty()) {
                        // ✅ ইউনিক ফাইল নেম (একই নামের ফাইল ওভাররাইট হবে না)
                        fileName = System.currentTimeMillis() + "_" + submittedFileName;

                        // ✅ আপলোড পাথ
                        String uploadPath = getServletContext().getRealPath("/img");
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }

                        // ✅ ফাইল রাইট করা
                        part.write(uploadPath + File.separator + fileName);
                        
                        // যদি ভিডিও হয় তবে টাইপ পরিবর্তন (ঐচ্ছিক)
                        if(submittedFileName.toLowerCase().endsWith(".mp4") || submittedFileName.toLowerCase().endsWith(".webm")) {
                            postType = "video";
                        } else {
                            postType = "image";
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            // ✅ SAVE POST (সব প্যারামিটারসহ DAO কল)
            boolean success = dao.addPost(ub.getId(), content, fileName, postType, feeling);
            
            if ("true".equals(req.getParameter("ajax"))) {
                res.setContentType("application/json");
                res.setCharacterEncoding("UTF-8");
                res.getWriter().write("{\"success\": " + success + "}");
                return;
            }
        }

        // ✅ REDIRECT (পেজ রিফ্রেশ করে নতুন পোস্ট দেখানো)
        res.sendRedirect("UsersPostServlet");
    }
}