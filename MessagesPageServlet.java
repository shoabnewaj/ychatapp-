package ychatapp.Servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/messages")
public class MessagesPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // 🔥 friend list forward করতে চাইলে এখানে set করো (optional)
        // req.setAttribute("friendsList", yourList);

        req.getRequestDispatcher("/WEB-INF/messages.jsp")
           .forward(req, res);
    }
}