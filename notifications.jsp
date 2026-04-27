<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications | Y-ChatApp</title>
    
    <style>
        /* ১. গ্লোবাল এবং সাইডবার স্টাইল (আপনার অ্যাপের থিম বজায় রাখা হয়েছে) */
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; display: flex; background: #f0f2f5; height: 100vh; overflow: hidden; }

        .sidebar { width: 260px; height: 100vh; background: white; padding: 20px; border-right: 1px solid #ddd; position: fixed; left: 0; top: 0; display: flex; flex-direction: column; justify-content: space-between; }
        .logo { font-size: 22px; font-weight: bold; color: purple; margin-bottom: 25px; }
        .menu a { display: block; padding: 12px; text-decoration: none; color: #555; border-radius: 10px; margin-bottom: 5px; transition: 0.3s; }
        .menu a:hover { background: #f3e8ff; color: purple; }
        .active-menu { background: #f3e8ff; color: purple !important; font-weight: bold; }

        .user-card { background: #f3f4f6; padding: 15px; border-radius: 12px; }

        /* ২. মেইন এরিয়া */
        .main { flex: 1; margin-left: 260px; padding: 40px 10%; height: 100vh; overflow-y: auto; display: flex; flex-direction: column; align-items: center; }
        
        /* ৩. নোটিফিকেশন কন্টেইনার */
        .notif-container { width: 100%; max-width: 650px; background: white; padding: 30px; border-radius: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        
        .header-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #f3e8ff; padding-bottom: 15px; }
        .header-row h2 { color: purple; font-size: 24px; }
        
        /* ৪. নোটিফিকেশন আইটেম লজিক */
        .notif-item { display: flex; align-items: flex-start; padding: 15px; border-radius: 12px; margin-bottom: 10px; background: #fff; border: 1px solid #f0f0f0; transition: 0.2s; }
        .notif-item:hover { background: #fbf8ff; border-color: #dcd0ff; transform: translateY(-2px); }
        
        .notif-icon { font-size: 24px; margin-right: 15px; padding: 10px; background: #f3e8ff; border-radius: 50%; display: flex; align-items: center; justify-content: center; }
        
        .notif-content { flex: 1; }
        .notif-message { font-size: 15px; color: #333; line-height: 1.4; margin-bottom: 5px; }
        .notif-time { font-size: 12px; color: #999; }
        
        .no-notif { text-align: center; padding: 50px 0; color: #888; }
        .no-notif-icon { font-size: 50px; display: block; margin-bottom: 10px; opacity: 0.5; }

        .back-btn { text-decoration: none; color: purple; font-weight: bold; font-size: 14px; }
    </style>
</head>

<body>

<!-- সাইডবার (আপনার আগের ডিজাইন অনুযায়ী) -->
<div class="sidebar">
    <div>
        <div class="logo">💬 Y-ChatApp</div>
        <div class="menu">
            <a href="UsersPostServlet">🏠 Home</a>
            <a href="NotificationServlet" class="active-menu">🔔 Notifications</a>
            <a href="FriendServlet">👥 Friends</a>
            <a href="UsersProfileServlet">👤 Profile</a>
            <a href="UsersLogoutServlet">🚪 Logout</a>
        </div>
    </div>
    <div class="user-card">
        <b>${ub.name}</b><br>
        <small>${ub.email}</small>
    </div>
</div>

<!-- মেইন এরিয়া -->
<div class="main">
    <div class="notif-container">
        
        <div class="header-row">
            <h2>🔔 Notifications</h2>
            <a href="UsersPostServlet" class="back-btn">Back to Home</a>
        </div>

        <c:choose>
            <c:when test="${empty notifications}">
                <div class="no-notif">
                    <span class="no-notif-icon">📭</span>
                    <p>No new notifications for you right now.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="message" items="${notifications}">
                    <div class="notif-item">
                        <div class="notif-icon">
                            <c:choose>
                                <c:when test="${message.contains('request')}">🤝</c:when>
                                <c:when test="${message.contains('liked')}">❤️</c:when>
                                <c:when test="${message.contains('commented')}">💬</c:when>
                                <c:otherwise>📩</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="notif-content">
                            <p class="notif-message">${message}</p>
                            <span class="notif-time">Just now</span>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

    </div>
</div>

</body>
</html>
