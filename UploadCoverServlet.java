package ychatapp.Servlet;

import java.io.File;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.UsersDAO;


@WebServlet("/UploadCoverServlet")
@MultipartConfig
public class UploadCoverServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
    public UploadCoverServlet() {
        super();
     
    }
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        HttpSession session = req.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");

        if (ub == null) {
            resp.sendRedirect("UsersLoginServlet");
            return;
        }

        try {
            Part filePart = req.getPart("coverPic");

            if (filePart != null && filePart.getSize() > 0) {

                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

                String uploadPath = getServletContext().getRealPath("/img");
                File dir = new File(uploadPath);
                if (!dir.exists()) dir.mkdirs();

                filePart.write(uploadPath + File.separator + fileName);

                UsersDAO dao = new UsersDAO();
                dao.updateCoverPic(ub.getId(), fileName);

                ub.setCover_pic(fileName);
                session.setAttribute("ub", ub); // 🔥 important
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect("UsersProfileServlet");
    }



	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
	}


}
