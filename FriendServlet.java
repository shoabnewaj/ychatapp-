package ychatapp.Servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.UsersDAO;

@WebServlet("/FriendServlet")
public class FriendServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");
        
        if (ub == null) { 
            response.sendRedirect("UsersLoginServlet"); 
            return; 
        }

        UsersDAO dao = new UsersDAO();
        request.setAttribute("incomingRequests", dao.getPendingRequests(ub.getId()));
        request.setAttribute("sentRequests", dao.getSentRequests(ub.getId()));
        request.setAttribute("friendList", dao.getFriends(ub.getId()));

        request.getRequestDispatcher("/WEB-INF/jsp/friends.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");
        if (ub == null) { response.sendRedirect("UsersLoginServlet"); return; }

        try {
            String targetIdStr = request.getParameter("targetId");
            String action = request.getParameter("action"); 
            
            if(targetIdStr != null && action != null) {
                int targetId = Integer.parseInt(targetIdStr);
                UsersDAO uDao = new UsersDAO();
                uDao.handleFriendAction(ub.getId(), targetId, action);
            }
        } catch (Exception e) { e.printStackTrace(); }

        response.sendRedirect("FriendServlet");
    }
}