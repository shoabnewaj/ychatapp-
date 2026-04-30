package ychatapp.websocket;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;

@ServerEndpoint("/ws/user/{username}")
public class UserWebSocket {

    private static final Map<String, Session> clients = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session, @PathParam("username") String username) {
        if (username != null && !username.trim().isEmpty()) {
            clients.put(username, session);
            System.out.println("User Online: " + username);
            broadcastOnlineUsers();
        }
    }

    @OnMessage
    public void onMessage(String message, Session session, @PathParam("username") String sender) {
        try {
            // ফরম্যাট: TYPE|receiver|content
            String[] parts = message.split("\\|", 3);
            
            if (parts.length == 3) {
                String type = parts[0];     // CHAT
                String receiver = parts[1]; // Target User
                String content = parts[2];  // Text
                
                Session targetSession = clients.get(receiver);
                if (targetSession != null && targetSession.isOpen()) {
                    // রিসিভারকে পাঠানো হচ্ছে (সাথে প্রেরকের নাম জুড়ে দেওয়া হলো)
                    targetSession.getBasicRemote().sendText("CHAT|" + sender + "|" + content);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session, @PathParam("username") String username) {
        clients.remove(username);
        System.out.println("User Offline: " + username);
        broadcastOnlineUsers();
    }

    private void broadcastOnlineUsers() {
        String userList = "ONLINE_USERS|" + String.join(",", clients.keySet());
        for (Session s : clients.values()) {
            try {
                if (s.isOpen()) s.getBasicRemote().sendText(userList);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
