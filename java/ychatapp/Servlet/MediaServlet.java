package ychatapp.Servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/media")
public class MediaServlet extends HttpServlet {

 protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {

     String file = request.getParameter("file");

     String path = getServletContext().getRealPath("/img") + File.separator + file;

     File f = new File(path);

     if (!f.exists()) return;

     FileInputStream fis = new FileInputStream(f);
     OutputStream os = response.getOutputStream();

     byte[] buffer = new byte[1024];
     int bytes;

     while ((bytes = fis.read(buffer)) != -1) {
         os.write(buffer, 0, bytes);
     }

     fis.close();
 }
}