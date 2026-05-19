package ychatapp.Servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import ychatapp.model.Message;
import ychatapp.model.dao.MessageDAO;



@WebServlet("/loadMessages")
public class LoadMessagesServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {

        String u1 = req.getParameter("user1");
        String u2 = req.getParameter("user2");

        MessageDAO dao = new MessageDAO();
        List<Message> list = dao.getChat(u1, u2);

        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();

        out.print("[");

        for(int i=0;i<list.size();i++){
            Message m=list.get(i);

            String msg = m.getMessage().replace("\"","\\\"");

            out.print("{\"sender\":\""+m.getSender()+"\",\"message\":\""+msg+"\"}");

            if(i<list.size()-1) out.print(",");
        }

        out.print("]");
    }
}