package ychatapp.Servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.StoryDAO;

@WebServlet("/StoryServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class StoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final StoryDAO storyDAO = new StoryDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) 
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        UsersBeans ub = (session != null) ? (UsersBeans) session.getAttribute("ub") : null;

        if (ub == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        String text = req.getParameter("text");
        String fileName = null;

        try {
            Part part = req.getPart("media");
            if (part != null && part.getSize() > 0) {
                String submittedFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                if (submittedFileName != null && !submittedFileName.isEmpty()) {
                    fileName = System.currentTimeMillis() + "_" + submittedFileName;
                    String uploadPath = getServletContext().getRealPath("/img");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    part.write(uploadPath + File.separator + fileName);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        storyDAO.addStory(ub.getId(), fileName, text);
        res.sendRedirect("UsersPostServlet");
    }
}
