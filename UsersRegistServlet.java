package ychatapp.Servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.bo.UsersLogic;

@WebServlet("/UsersRegistServlet")
@MultipartConfig
public class UsersRegistServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/regist.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String pass = req.getParameter("pass");
        String name = req.getParameter("name");

        // ✅ image upload
        Part part = req.getPart("profile_pic"); // JSP input name
        String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();

        String user_img = null; // এখানে আপনি user_img নাম দিয়েছেন

        if (fileName != null && !fileName.isEmpty()) {
            String uploadPath = getServletContext().getRealPath("/img");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            user_img = System.currentTimeMillis() + "_" + fileName;

            // ✅ ভুল ১: profile_pic এর বদলে user_img হবে
            part.write(uploadPath + File.separator + user_img);
        }

        // ✅ FIXED constructor usage
        UsersBeans ub = new UsersBeans();
        ub.setEmail(email);
        ub.setPass(pass);
        ub.setName(name);
        
        // ✅ ভুল ২: profile_pic এর বদলে user_img হবে
        // ✅ ভুল ৩: Beans ক্লাসে মেথড চেক করুন: setProfile_pic (P বড় হাতের হতে পারে)
        ub.setProfile_pic(user_img); 

        if (UsersLogic.userRegist(req, ub)) {
            req.getRequestDispatcher("/WEB-INF/jsp/registDone.jsp").forward(req, res);
        } else {
            req.setAttribute("error", "Registration Failed");
            req.getRequestDispatcher("/WEB-INF/jsp/regist.jsp").forward(req, res);
        }
    }
}
