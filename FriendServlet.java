package ychatapp.Servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.NotificationDAO;
import ychatapp.model.dao.UsersDAO;



@WebServlet("/FriendServlet")
public class FriendServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");
        if (ub == null) { response.sendRedirect("UsersLoginServlet"); return; }

        UsersDAO dao = new UsersDAO();
        request.setAttribute("incomingRequests", dao.getPendingRequests(ub.getId()));
        request.setAttribute("sentRequests", dao.getSentRequests(ub.getId()));
        request.setAttribute("friendList", dao.getFriends(ub.getId()));

        request.getRequestDispatcher("/WEB-INF/jsp/friends.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");
        if (ub == null) { response.sendRedirect("UsersLoginServlet"); return; }

        try {
            int targetId = Integer.parseInt(request.getParameter("targetId"));
            String action = request.getParameter("action");
            
            UsersDAO uDao = new UsersDAO();
            NotificationDAO nDao = new NotificationDAO();
            
            boolean result = uDao.handleFriendAction(ub.getId(), targetId, action);
            
            // 🔥 নোটিফিকেশন লজিক শুরু
            if (result) {
                if ("SEND".equals(action)) {
                    // সাকুরা মিনাতোকে রিকোয়েস্ট পাঠালে মিনাতো নোটিফিকেশন পাবে
                    nDao.addNotification(targetId, ub.getName() + " sent you a friend request!");
                } else if ("ACCEPT".equals(action)) {
                    // মিনাতো রিকোয়েস্ট একসেপ্ট করলে সাকুরা নোটিফিকেশন পাবে
                    nDao.addNotification(targetId, ub.getName() + " accepted your friend request!");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("FriendServlet");
    }
}
