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



@WebServlet("/UploadProfileServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,   // 1MB
    maxFileSize = 1024 * 1024 * 5,         // 5MB
    maxRequestSize = 1024 * 1024 * 10      // 10MB
)
public class UploadProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");

        // 🔒 Login check
        if (ub == null) {
            resp.sendRedirect("UsersLoginServlet");
            return;
        }

        try {
            Part filePart = req.getPart("profilePic");

            // ❗ empty file check
            if (filePart == null || filePart.getSize() == 0) {
                resp.sendRedirect("UsersProfileServlet");
                return;
            }

            // 🔥 unique filename (VERY IMPORTANT)
            String fileName = System.currentTimeMillis() + "_" +
                    filePart.getSubmittedFileName();

            // 📁 uploads path
            String uploadPath = getServletContext().getRealPath("/uploads");

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 💾 save file
            filePart.write(uploadPath + File.separator + fileName);

            // 🗄 DB update (logged-in user)
            UsersDAO dao = new UsersDAO();
            dao.updateProfilePic(ub.getId(), fileName);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 🔁 redirect back to profile
        resp.sendRedirect("UsersProfileServlet");
    }
}