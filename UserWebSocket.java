package ychatapp.websocket;

import java.io.IOException;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

@ServerEndpoint("/ws/user/{username}")
public class UserWebSocket {

    // MULTI SESSION SUPPORT (important fix)
    private static final ConcurrentHashMap<String, Set<Session>> clients = new ConcurrentHashMap<>();

    /* =========================
       OPEN CONNECTION
    ========================== */
    @OnOpen
    public void onOpen(Session session,
                       @PathParam("username") String encodedUsername) {

        String username = "";
        try {
            username = URLDecoder.decode(encodedUsername, "UTF-8");
        } catch (Exception e) {
            username = encodedUsername;
        }

        clients.computeIfAbsent(username, k -> ConcurrentHashMap.newKeySet())
               .add(session);

        System.out.println("User Online: " + username);

        broadcastOnlineUsers();
    }

    /* =========================
       MESSAGE HANDLING
       FORMAT: TYPE|RECEIVER|CONTENT
    ========================== */
    @OnMessage
    public void onMessage(String message,
                          Session session,
                          @PathParam("username") String encodedSender) {

        try {
            String sender = "";
            try {
                sender = URLDecoder.decode(encodedSender, "UTF-8");
            } catch (Exception e) {
                sender = encodedSender;
            }
            String[] parts = message.split("\\|", 3);

            if (parts.length < 3) return;

            String type = parts[0];
            String receiver = parts[1];
            String content = parts[2];

            if ("CHAT".equalsIgnoreCase(type)) {
                new ychatapp.model.dao.MessageDAO().saveMessage(sender, receiver, content);
                
                // Add message notification to database
                String cleanContent = content != null && content.length() > 30 ? content.substring(0, 30) + "..." : content;
                new ychatapp.model.dao.NotificationDAO().addNotificationByUsername(
                    receiver,
                    sender + " sent you a message: \"" + cleanContent + "\""
                );
            }

            Set<Session> sessions = clients.get(receiver);

            if (sessions != null) {
                for (Session s : sessions) {
                    if (s.isOpen()) {
                        s.getBasicRemote()
                         .sendText(type + "|" + sender + "|" + content);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /* =========================
       CLOSE CONNECTION
    ========================== */
    @OnClose
    public void onClose(Session session,
                        @PathParam("username") String encodedUsername) {

        String username = "";
        try {
            username = URLDecoder.decode(encodedUsername, "UTF-8");
        } catch (Exception e) {
            username = encodedUsername;
        }

        Set<Session> set = clients.get(username);

        if (set != null) {
            set.remove(session);
            if (set.isEmpty()) {
                clients.remove(username);
            }
        }

        broadcastOnlineUsers();
    }

    /* =========================
       ONLINE USERS BROADCAST
    ========================== */
    private void broadcastOnlineUsers() {

        String users = String.join(",", clients.keySet());
        String msg = "ONLINE_USERS|" + users;

        for (Set<Session> sessions : clients.values()) {
            for (Session s : sessions) {
                try {
                    if (s.isOpen()) {
                        s.getBasicRemote().sendText(msg);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /* =========================
       NOTIFICATION API
    ========================== */
    public static void sendNotification(String username, String message) {

        Set<Session> sessions = clients.get(username);

        if (sessions != null) {
            for (Session s : sessions) {
                try {
                    if (s.isOpen()) {
                        s.getBasicRemote().sendText("NOTIF|" + message);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}