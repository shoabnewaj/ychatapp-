<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head><title>Friends Management</title>
<link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
<style>

    body { background: #f0f2f5; font-family: sans-serif; padding: 20px; }
    .container { max-width: 600px; margin: auto; background: white; padding: 25px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
    h3 { color: #6a1b9a; border-bottom: 2px solid #eee; padding-bottom: 10px; margin-top: 30px; display: flex; align-items: center; }
    .user-item { display: flex; justify-content: space-between; align-items: center; padding: 12px; border-bottom: 1px solid #f9f9f9; }
    .btn { padding: 7px 15px; border-radius: 20px; border: none; cursor: pointer; font-weight: bold; color: white; }
</style></head>
<body>
<div class="container">
    <a href="UsersPostServlet" style="text-decoration:none; color:#1877f2; font-weight:bold;">← Home</a>
    
    <h3>📩 Incoming Requests (Received)</h3>
    <c:if test="${empty incomingRequests}"><p style="color:gray; font-style:italic;">No pending requests from others.</p></c:if>
    <c:forEach var="req" items="${incomingRequests}">
        <div class="user-item"><span><b>${req.name}</b></span>
            <form action="FriendServlet" method="post">
                <input type="hidden" name="targetId" value="${req.id}">
                <button name="action" value="ACCEPT" class="btn" style="background:#2ecc71;">Accept</button>
                <button name="action" value="DECLINE" class="btn" style="background:#e74c3c;">Decline</button>
            </form>
        </div>
    </c:forEach>

    <h3>⏳ Sent Requests (Outgoing)</h3>
    <c:if test="${empty sentRequests}"><p style="color:gray; font-style:italic;">No pending requests sent by you.</p></c:if>
    <c:forEach var="sent" items="${sentRequests}">
        <div class="user-item"><span><b>${sent.name}</b></span>
            <form action="FriendServlet" method="post">
                <input type="hidden" name="targetId" value="${sent.id}">
                <button name="action" value="CANCEL" class="btn" style="background:#95a5a6;">Cancel</button>
            </form>
        </div>
    </c:forEach>

    <h3>👥 Friends List</h3>
    <c:if test="${empty friendList}"><p style="color:gray; font-style:italic;">You have no friends yet.</p></c:if>
    <c:forEach var="f" items="${friendList}">
        <div class="user-item"><span><b>${f.name}</b></span>
            <form action="FriendServlet" method="post">
                <input type="hidden" name="targetId" value="${f.id}">
                <button name="action" value="DELETE" class="btn" style="background:#f02849;" onclick="return confirm('Unfriend?')">Unfriend</button>
            </form>
        </div>
    </c:forEach>
</div>
</body></html>
