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

    // সব অনলাইন ইউজারদের স্টোর করার জন্য Map
    private static Map<String, Session> clients = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session, @PathParam("username") String username) {
        clients.put(username, session);
        System.out.println("Online: " + username);
        broadcastOnlineUsers(); // সবাইকে নতুন অনলাইন লিস্ট পাঠানো
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            // মেসেজ চেক করা: এটি কি সাধারণ চ্যাট নাকি নোটিফিকেশন?
            // ফরম্যাট: TYPE|receiver|content
            String[] parts = message.split("\\|", 3);
            
            if (parts.length == 3) {
                String type = parts[0];     // CHAT অথবা NOTIFICATION
                String receiver = parts[1]; // যাকে পাঠানো হবে
                String content = parts[2];  // মেসেজ বা নোটিফিকেশন টেক্সট
                
                Session targetSession = clients.get(receiver);
                
                if (targetSession != null && targetSession.isOpen()) {
                    // রিসিভারকে ডেটা পাঠানো হচ্ছে
                    // আমরা পাঠানোর সময়ও "TYPE|content" ফরম্যাট বজায় রাখব
                    targetSession.getBasicRemote().sendText(type + "|" + content);
                }
            }
            
            // নিচের অংশটি আপনার আগের সিম্পল ফরম্যাটের (receiver|message) জন্য সাপোর্ট রাখবে
            else if (message.contains("|")) {
                String[] simpleParts = message.split("\\|", 2);
                String receiver = simpleParts[0];
                String msg = simpleParts[1];
                Session target = clients.get(receiver);
                if (target != null && target.isOpen()) {
                    target.getBasicRemote().sendText("CHAT|" + msg);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session, @PathParam("username") String username) {
        clients.remove(username);
        System.out.println("Offline: " + username);
        broadcastOnlineUsers(); // অফলাইন হলে লিস্ট আপডেট করা
    }

    // সব অনলাইন ইউজারকে লিস্ট পাঠানোর মেথড
    private void broadcastOnlineUsers() {
        String userList = "ONLINE_USERS|" + String.join(",", clients.keySet());
        for (Session s : clients.values()) {
            try {
                if (s.isOpen()) {
                    s.getBasicRemote().sendText(userList);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    // বিশেষ মেথড: সার্ভারের অন্য কোনো অংশ থেকে নোটিফিকেশন পাঠানোর জন্য
    public static void sendNotification(String targetUser, String message) {
        Session session = clients.get(targetUser);
        if (session != null && session.isOpen()) {
            try {
                session.getBasicRemote().sendText("NOTIFICATION|" + message);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
