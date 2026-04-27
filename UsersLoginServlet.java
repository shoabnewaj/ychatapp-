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



@WebServlet("/UsersLoginServlet")
public class UsersLoginServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String pass = req.getParameter("pass");

        UsersBeans input = new UsersBeans();
        input.setEmail(email);
        input.setPass(pass);

        UsersBeans ub = UsersLogic.login(input);

        if (ub != null) {

            HttpSession session = req.getSession();
            session.setAttribute("ub", ub);

            res.sendRedirect("UsersPostServlet");

        } else {

            req.setAttribute("errorMsg", "Invalid email or password");
            req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
        }
    }
}