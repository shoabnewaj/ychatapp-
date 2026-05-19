package ychatapp.Servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.bo.UsersLogic;
import ychatapp.model.dao.UsersDAO;

@WebServlet("/UsersLoginServlet")
public class UsersLoginServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L; // জাভা সার্ভলেটের স্ট্যান্ডার্ড সিরিয়াল আইডি

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        // ১. কুকি চেক (Remember Me)
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            String email = null;
            String pass = null;
            for (Cookie c : cookies) {
                if ("rem_email".equals(c.getName())) email = c.getValue();
                if ("rem_pass".equals(c.getName())) pass = c.getValue();
            }
            if (email != null && pass != null) {
                UsersBeans input = new UsersBeans();
                input.setEmail(email);
                input.setPass(pass); // এখানে কুকি থেকে আসা হ্যাশড পাসওয়ার্ড ই থাকবে
                
                // UsersLogic.login সরাসরি hashValue কল করে, তাই কুকি ব্যবহারের সময় একটু সাবধান থাকতে হবে।
                // সহজ করার জন্য, কুকি তে সেভ করার সময় পাসওয়ার্ড টা সেভ করছি।
                UsersDAO dao = new UsersDAO();
                UsersBeans ub = dao.loginCheck(email, pass); 
                if (ub != null) {
                    HttpSession sess = req.getSession();
                    sess.setAttribute("ub", ub);
                    sess.setAttribute("userId", ub.getId());
                    res.sendRedirect("UsersPostServlet");
                    return;
                }
            }
        }
        
        // সরাসরি JSP পেজে ফরওয়ার্ড
        req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String pass = req.getParameter("pass");

        String isAjax = req.getParameter("ajax");

        // ১. বেসিক ভ্যালিডেশন
        if (email == null || email.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
            if ("true".equals(isAjax)) {
                res.setContentType("application/json");
                res.getWriter().write("{\"success\":false,\"message\":\"Email and Password cannot be empty\"}");
            } else {
                req.setAttribute("errorMsg", "Email and Password cannot be empty");
                req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
            }
            return;
        }

        UsersBeans input = new UsersBeans();
        input.setEmail(email.trim());
        input.setPass(pass);

        UsersBeans ub = UsersLogic.login(input);

        if (ub != null) {
            HttpSession session = req.getSession();
            session.invalidate(); 
            
            HttpSession newSession = req.getSession(true);
            newSession.setAttribute("ub", ub);
            newSession.setAttribute("userId", ub.getId());

            // 🍪 Remember Me
            String remember = req.getParameter("remember");
            if (remember != null) {
                Cookie cEmail = new Cookie("rem_email", email);
                Cookie cPass = new Cookie("rem_pass", input.getHashedPass());
                cEmail.setMaxAge(60 * 60 * 24 * 7); 
                cPass.setMaxAge(60 * 60 * 24 * 7);
                res.addCookie(cEmail);
                res.addCookie(cPass);
            }
            
            if ("true".equals(isAjax)) {
                res.setContentType("application/json");
                res.getWriter().write("{\"success\":true,\"redirect\":\"UsersPostServlet\"}");
            } else {
                res.sendRedirect("UsersPostServlet");
            }
        } else {
            if ("true".equals(isAjax)) {
                res.setContentType("application/json");
                res.getWriter().write("{\"success\":false,\"message\":\"Invalid email or password\"}");
            } else {
                req.setAttribute("errorMsg", "Invalid email or password");
                req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
            }
        }
    }
}
