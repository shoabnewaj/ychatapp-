package ychatapp.Servlet;

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
import ychatapp.model.dao.PostDAO;

//... (বাকি ইমপোর্ট ঠিক থাকবে)

@WebServlet("/UsersPostServlet")
/*@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
		maxFileSize = 1024 * 1024 * 10, // 10MB
		maxRequestSize = 1024 * 1024 * 50 // 50MB
)*/
@MultipartConfig()
public class UsersPostServlet extends HttpServlet {

	protected void doGet(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		PostDAO dao = new PostDAO();
		req.setAttribute("postList", dao.getAllposts());
		req.getRequestDispatcher("/WEB-INF/jsp/main.jsp").forward(req, res);
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

		String content = req.getParameter("content");
		// postType হ্যান্ডলিং (JSP-তে ইনপুট না থাকলে ডিফল্ট 'text')
		String postType = req.getParameter("type");
		if (postType == null)
			postType = "text";

		String fileName = null;
		Part part = req.getPart("media");

		System.out.println("part:" + part);

		// doPost মেথডের ভেতরে ফাইল সেভ করার অংশটি এভাবে আপডেট করুন
		// doPost এর ভেতর এই চেকটি নিশ্চিত করুন
		if (part != null && part.getSize() > 0) {
			
			//String submittedFileName = part.getSubmittedFileName();
			String submittedFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
			
			System.out.println("submittedFileName：" + submittedFileName);
			
			if (submittedFileName != null && !submittedFileName.isEmpty()) {
				fileName = System.currentTimeMillis() + "_" + submittedFileName;
				
				System.out.println("0_fileName：" + fileName);
				
				
				String uploadPath = "C:\\pleiades-2025-12-ultimate-win-64bit-jre_20251214\\workspace\\ychatApp\\src\\main\\webapp\\img\\";
				// ... বাকি কোড ...
				part.write(uploadPath + fileName);
			}
		}

		System.out.println("1_fileName：" + fileName);
		PostDAO dao = new PostDAO();
		dao.addPost(ub.getId(), content, fileName, postType);
		res.sendRedirect("UsersPostServlet");
	}
}