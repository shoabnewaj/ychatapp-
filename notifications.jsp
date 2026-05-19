<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notifications | Y-ChatApp</title>
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Segoe UI', sans-serif; display: flex; background: #f0f2f5; height: 100vh; overflow: hidden; }
        .sidebar { width: 260px; height: 100vh; background: white; padding: 20px; border-right: 1px solid #ddd; position: fixed; display: flex; flex-direction: column; justify-content: space-between; }
        .logo { font-size: 22px; font-weight: bold; color: purple; margin-bottom: 25px; }
        .menu a { display: block; padding: 12px; text-decoration: none; color: #555; border-radius: 10px; margin-bottom: 5px; }
        .menu a:hover, .active-menu { background: #f3e8ff; color: purple !important; }
        .main { flex: 1; margin-left: 260px; padding: 40px; overflow-y: auto; display: flex; flex-direction: column; align-items: center; }
        .notif-container { width: 100%; max-width: 600px; background: white; padding: 25px; border-radius: 15px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .notif-item { display: flex; justify-content: space-between; align-items: center; padding: 15px; border-bottom: 1px solid #eee; }
        .notif-left { display: flex; align-items: center; gap: 15px; }
        .notif-icon { font-size: 20px; width: 45px; height: 45px; background: #f3e8ff; border-radius: 50%; display: flex; align-items: center; justify-content: center; }
        .delete-btn { color: #ff3b30; text-decoration: none; font-size: 20px; padding: 5px; cursor: pointer; }
    </style>
</head>
<body>

<div class="sidebar">
    <div>
        <div class="logo">💬 Y-ChatApp</div>
        <div class="menu">
            <a href="UsersPostServlet">🏠 Home</a>
            <a href="NotificationServlet" class="active-menu">🔔 Notifications</a>
            <a href="FriendServlet">👥 Friends</a>
            <a href="UsersProfileServlet?userId=${sessionScope.userId}">👤 Profile</a>
            <a href="UsersLogoutServlet">🚪 Logout</a>
        </div>
    </div>
    <div style="background: #f3f4f6; padding: 15px; border-radius: 12px;">
        <b>${ub.name}</b><br><small>${ub.email}</small>
    </div>
</div>

<div class="main">
    <div class="notif-container">
        <h2 style="color: purple; margin-bottom: 20px; border-bottom: 2px solid #f3e8ff; padding-bottom: 10px;">🔔 Notifications</h2>
        
        <c:choose>
            <c:when test="${empty notifications}">
                <p style="text-align:center; padding: 20px; color:#888;">📭 No new notifications.</p>
            </c:when>
            <c:otherwise>
                <c:forEach var="message" items="${notifications}">
                    <div class="notif-item">
                        <div class="notif-left">
                            <div class="notif-icon">
                                <c:choose>
                                    <c:when test="${message.contains('reacted')}">❤️</c:when>
                                    <c:when test="${message.contains('liked')}">👍</c:when>
                                    <c:when test="${message.contains('friend request')}">👥</c:when>
                                    <c:when test="${message.contains('accepted')}">🤝</c:when>
                                    <c:when test="${message.contains('message')}">💬</c:when>
                                    <c:when test="${message.contains('commented')}">📝</c:when>
                                    <c:when test="${message.contains('replied')}">↩️</c:when>
                                    <c:when test="${message.contains('shared')}">🔄</c:when>
                                    <c:otherwise>🔔</c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <p style="color: #333; font-size: 15px;">${message}</p>
                                <small style="color: #999;">Just now</small>
                            </div>
                        </div>
                        <a href="NotificationServlet?action=delete&msg=${message}" class="delete-btn" onclick="return confirm('Delete this notification?')">×</a>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

</body>
</html>