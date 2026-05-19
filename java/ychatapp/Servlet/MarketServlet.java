package ychatapp.Servlet;

import java.io.File;
import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.beans.MarketplaceItem;
import ychatapp.model.dao.MarketDAO;

@WebServlet("/MarketServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class MarketServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final MarketDAO marketDAO = new MarketDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("ub") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        List<MarketplaceItem> items = marketDAO.getAllItems();
        req.setAttribute("items", items);
        req.getRequestDispatcher("/WEB-INF/jsp/market.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("ub") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        UsersBeans ub = (UsersBeans) session.getAttribute("ub");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String priceStr = req.getParameter("price");

        double price = 0.0;
        try {
            if (priceStr != null) price = Double.parseDouble(priceStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        String file_name = null;
        try {
            Part filePart = req.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String originalFile = filePart.getSubmittedFileName();
                if (originalFile != null && !originalFile.isEmpty()) {
                    file_name = System.currentTimeMillis() + "_" + originalFile;
                    String uploadPath = getServletContext().getRealPath("") + "img" + File.separator;
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    filePart.write(uploadPath + file_name);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (title != null && !title.trim().isEmpty() && price > 0) {
            marketDAO.addItem(title, description, price, file_name, ub.getId());
        }

        res.sendRedirect("MarketServlet");
    }
}
