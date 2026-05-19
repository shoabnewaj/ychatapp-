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
        String query = request.getParameter("query");
        if (query != null && !query.trim().isEmpty()) {
            ychatapp.model.dao.UsersDAO userDao = new ychatapp.model.dao.UsersDAO();
            ychatapp.model.dao.PostDAO postDao = new ychatapp.model.dao.PostDAO();
            
            java.util.List<ychatapp.model.beans.UsersBeans> userResults = userDao.searchUsers(query);
            java.util.List<ychatapp.model.beans.UsersPost> postResults = postDao.searchPosts(query);
            
            request.setAttribute("userResults", userResults);
            request.setAttribute("postResults", postResults);
            request.setAttribute("searchQuery", query);
        }
        request.getRequestDispatcher("/WEB-INF/jsp/search.jsp").forward(request, response);
    }
}
