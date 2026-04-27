package ychatapp.Servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.NotificationDAO;




@WebServlet("/NotificationServlet")
public class NotificationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        UsersBeans ub = (UsersBeans) req.getSession().getAttribute("ub");

        if (ub == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        NotificationDAO dao = new NotificationDAO();

        req.setAttribute("notifications", dao.getNotifications(ub.getId()));

        req.getRequestDispatcher("/WEB-INF/jsp/notifications.jsp").forward(req, res);
    }
}
