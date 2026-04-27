package ychatapp.Servlet;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // সরাসরি পোস্ট সারভলেটে পাঠিয়ে দিবে কারণ সেখানে সার্চ লজিক আছে
        request.getRequestDispatcher("UsersPostServlet").forward(request, response);
    }
}
