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
import ychatapp.model.dao.NotificationDAO;

@WebServlet("/NotificationServlet")
public class NotificationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");

        if (ub == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        NotificationDAO dao = new NotificationDAO();
        int userId = ub.getId();

        // ১. পেজে ঢোকা মাত্রই সব নোটিফিকেশনকে 'Read' করে দাও
        dao.markAsRead(userId);
        
        // ২. সেশন থেকে আনরিড কাউন্ট ০ করে দাও যাতে হেডার থেকে লাল সিগন্যাল চলে যায়
        session.setAttribute("unreadCount", 0);

        // ৩. লিস্ট নিয়ে পেজে পাঠিয়ে দাও
        List<String> notifications = dao.getNotifications(userId);
        req.setAttribute("notifications", notifications);

        req.getRequestDispatcher("/WEB-INF/jsp/notifications.jsp").forward(req, res);
    }
}