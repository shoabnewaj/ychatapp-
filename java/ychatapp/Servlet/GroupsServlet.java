package ychatapp.Servlet;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
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
import ychatapp.model.beans.Group;
import ychatapp.model.beans.UsersPost;
import ychatapp.model.dao.GroupDAO;
import ychatapp.model.dao.PostDAO;

@WebServlet("/GroupsServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class GroupsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final GroupDAO groupDAO = new GroupDAO();
    private final PostDAO postDAO = new PostDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("ub") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        UsersBeans ub = (UsersBeans) session.getAttribute("ub");
        String groupIdStr = req.getParameter("groupId");

        if (groupIdStr != null && !groupIdStr.trim().isEmpty()) {
            try {
                int groupId = Integer.parseInt(groupIdStr);
                Group group = groupDAO.getGroupById(groupId, ub.getId());
                if (group != null) {
                    List<UsersPost> posts = groupDAO.getGroupPosts(groupId);
                    req.setAttribute("group", group);
                    req.setAttribute("posts", posts);
                    req.getRequestDispatcher("/WEB-INF/jsp/groupDetail.jsp").forward(req, res);
                    return;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Show all groups list
        List<Group> groups = groupDAO.getAllGroups(ub.getId());
        req.setAttribute("groups", groups);
        req.getRequestDispatcher("/WEB-INF/jsp/groups.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("ub") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        UsersBeans ub = (UsersBeans) session.getAttribute("ub");
        String action = req.getParameter("action");

        if ("CREATE".equalsIgnoreCase(action)) {
            String name = req.getParameter("name");
            String description = req.getParameter("description");
            String coverPic = null;

            try {
                Part filePart = req.getPart("coverPic");
                if (filePart != null && filePart.getSize() > 0) {
                    String originalFile = filePart.getSubmittedFileName();
                    if (originalFile != null && !originalFile.isEmpty()) {
                        coverPic = System.currentTimeMillis() + "_" + originalFile;
                        String uploadPath = getServletContext().getRealPath("") + "img" + File.separator;
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }
                        filePart.write(uploadPath + coverPic);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (name != null && !name.trim().isEmpty()) {
                int newGroupId = groupDAO.createGroup(name, description, ub.getId(), coverPic);
                if (newGroupId > 0) {
                    res.sendRedirect("GroupsServlet?groupId=" + newGroupId);
                    return;
                }
            }
            res.sendRedirect("GroupsServlet");

        } else if ("JOIN".equalsIgnoreCase(action)) {
            String groupIdStr = req.getParameter("groupId");
            if (groupIdStr != null) {
                int groupId = Integer.parseInt(groupIdStr);
                groupDAO.joinGroup(groupId, ub.getId());
                res.sendRedirect("GroupsServlet?groupId=" + groupId);
            } else {
                res.sendRedirect("GroupsServlet");
            }

        } else if ("LEAVE".equalsIgnoreCase(action)) {
            String groupIdStr = req.getParameter("groupId");
            if (groupIdStr != null) {
                int groupId = Integer.parseInt(groupIdStr);
                groupDAO.leaveGroup(groupId, ub.getId());
            }
            res.sendRedirect("GroupsServlet");

        } else if ("ADD_POST".equalsIgnoreCase(action)) {
            String groupIdStr = req.getParameter("groupId");
            String content = req.getParameter("content");
            String file_name = null;
            String postType = "text";

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

                        String contentType = filePart.getContentType();
                        if (contentType != null && contentType.startsWith("video/")) {
                            postType = "video";
                        } else {
                            postType = "image";
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (groupIdStr != null) {
                try {
                    int groupId = Integer.parseInt(groupIdStr);
                    // Add group post
                    String sql = "INSERT INTO posts(user_id, content, file_name, post_type, group_id) VALUES (?, ?, ?, ?, ?)";
                    try (java.sql.Connection conn = ychatapp.model.dao.DBConnection.getConnection();
                         java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, ub.getId());
                        ps.setString(2, content);
                        ps.setString(3, file_name);
                        ps.setString(4, postType);
                        ps.setInt(5, groupId);
                        ps.executeUpdate();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    res.sendRedirect("GroupsServlet?groupId=" + groupId);
                    return;
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            res.sendRedirect("GroupsServlet");
        }
    }
}
