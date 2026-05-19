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
@MultipartConfig
public class UploadProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");

        if (ub == null) {
            resp.sendRedirect("UsersLoginServlet");
            return;
        }

        try {
            Part filePart = req.getPart("profilePic");

            if (filePart != null && filePart.getSize() > 0) {

                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

                String uploadPath = getServletContext().getRealPath("/img");
                File dir = new File(uploadPath);
                if (!dir.exists()) dir.mkdirs();

                filePart.write(uploadPath + File.separator + fileName);

                UsersDAO dao = new UsersDAO();
                dao.updateProfilePic(ub.getId(), fileName);

                ub.setProfile_pic(fileName);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect("UsersProfileServlet");
    }
}