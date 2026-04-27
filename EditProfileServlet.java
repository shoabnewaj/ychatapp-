package ychatapp.Servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.bo.UsersLogic;



@WebServlet("/EditProfileServlet")
public class EditProfileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.getRequestDispatcher("/WEB-INF/jsp/editProfile.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");

        if (ub == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        ub.setName(req.getParameter("name"));
        ub.setEmail(req.getParameter("email"));
        ub.setPass(req.getParameter("pass"));

        if (UsersLogic.updateProfile(ub)) {
            res.sendRedirect("UsersProfileServlet?update=success");
        } else {
            res.sendRedirect("UsersProfileServlet?update=fail");
        }
    }
}