package ychatapp.Servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import ychatapp.model.bo.UsersLogic;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/jsp/forgot_password.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");

        if (email == null || email.isEmpty() || newPass == null || newPass.isEmpty() || !newPass.equals(confirmPass)) {
            request.setAttribute("errorMsg", "Passwords do not match or email is empty.");
            request.getRequestDispatcher("/WEB-INF/jsp/forgot_password.jsp").forward(request, response);
            return;
        }

        boolean success = UsersLogic.resetPasswordByEmail(email, newPass);

        if (success) {
            request.setAttribute("successMsg", "Password reset successfully. Please login.");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMsg", "Email not found or error occurred.");
            request.getRequestDispatcher("/WEB-INF/jsp/forgot_password.jsp").forward(request, response);
        }
    }
}
