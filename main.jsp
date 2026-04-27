<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Y-ChatApp | Home</title>

<link rel="manifest" href="<%=request.getContextPath()%>/manifest.json">
<meta name="theme-color" content="#4CAF50">

<style>
* { margin:0; padding:0; box-sizing:border-box; }
body { font-family: 'Segoe UI'; display: flex; background: #f0f2f5; }

.sidebar { width:260px; background:white; padding:20px; border-right:1px solid #ddd; position:fixed; height:100vh; }

.logo {
    font-size:22px;
    font-weight:bold;
    color:purple;
    margin-bottom:25px;
    display:flex;
    align-items:center;
    gap:10px;
    cursor:pointer;
    transition:0.3s;
}
.logo:hover { transform: scale(1.1) rotate(-2deg); }

.menu a {
    display:block;
    padding:12px;
    text-decoration:none;
    color:#555;
    border-radius:10px;
    margin-bottom:5px;
}
.menu a:hover { background:#f3e8ff; color:purple; }

.user-card { background:#f3f4f6; padding:15px; border-radius:12px; }

.main { margin-left:260px; padding:30px 10%; width:100%; }
.feed-container { max-width:650px; margin:auto; }

.post-box, .post-card, .search-box {
    background:white;
    padding:20px;
    border-radius:15px;
    margin-bottom:20px;
}

textarea { width:100%; height:60px; border:none; outline:none; }

.post-btn {
    float:right;
    background:purple;
    color:white;
    border:none;
    padding:8px 22px;
    border-radius:20px;
    cursor:pointer;
}

.username {
    color:purple;
    text-decoration:none;
    font-weight:bold;
}
.username:hover { text-decoration:underline; }

.search-bar input {
    width:70%;
    padding:10px;
    border-radius:20px;
    border:1px solid #ccc;
}
.search-bar button {
    padding:10px 15px;
    border:none;
    background:purple;
    color:white;
    border-radius:20px;
    cursor:pointer;
}
</style>
</head>

<body>

<!-- Sidebar -->
<div class="sidebar">

    <div class="logo">
        <img src="<%=request.getContextPath()%>/icons/icon-192.png" width="35">
        Y-ChatApp
    </div>

    <div class="menu">
        <a href="UsersPostServlet">🏠 Home</a>
        <a href="messages.jsp">💬 Messages</a>
        <a href="FriendServlet">👥 Friends</a>
        <a href="UsersProfileServlet">👤 Profile</a>
        <a href="UsersLogoutServlet">🚪 Logout</a>
        <a href="NotificationServlet">🔔 Notifications</a>
    </div>

    <div class="user-card">
        <b>${ub.name}</b><br>
        <small>${ub.email}</small>
    </div>
</div>

<!-- Main -->
<div class="main">
<div class="feed-container">

<!-- 🔍 SEARCH BAR (FIXED) -->
<div class="search-box">
<form action="UsersPostServlet" method="get" class="search-bar">
    <input type="text" name="query" placeholder="Search friends..." required>
    <button type="submit">Search</button>
</form>
</div>

<!-- 🔍 SEARCH RESULT -->
<c:if test="${not empty searchList}">
<div class="search-box">
    <h4>People you may know</h4>
    <c:forEach var="user" items="${searchList}">
        <div style="display:flex; justify-content:space-between; margin-top:10px;">
            <a class="username" href="UsersProfileServlet?userId=${user.id}">
                ${user.name}
            </a>

            <form action="FriendServlet" method="post">
                <input type="hidden" name="targetId" value="${user.id}">
                <button name="action" value="SEND">Add Friend</button>
            </form>
        </div>
    </c:forEach>
</div>
</c:if>

<!-- POST BOX -->
<div class="post-box">
<form action="UsersPostServlet" method="post" enctype="multipart/form-data">

    <textarea name="content" placeholder="What's on your mind, ${ub.name}?" required></textarea>

    <input type="file" name="media">

    <select name="type">
        <option value="image">Image</option>
        <option value="video">Video</option>
    </select>

    <button type="submit" class="post-btn">Post</button>
    <div style="clear:both;"></div>

</form>
</div>

<!-- POSTS -->
<c:forEach var="post" items="${postList}">
<div class="post-card">

    👤 
    <a class="username" href="UsersProfileServlet?userId=${post.users_id}">
        ${post.name}
    </a>

    <p>${post.content}</p>

    <!-- LIKE -->
    <form action="InteractionServlet" method="post">
        <input type="hidden" name="postId" value="${post.posts_id}">
        <button name="action" value="LIKE">👍 ${post.likes}</button>
        <button name="action" value="DISLIKE">👎 ${post.dislikes}</button>
    </form>

    <!-- SHARE -->
    <form action="InteractionServlet" method="post">
        <input type="hidden" name="action" value="SHARE">
        <input type="hidden" name="postId" value="${post.posts_id}">
        <input type="hidden" name="content" value="${post.content}">
        <button>📤 Share</button>
    </form>

    <!-- COMMENTS -->
    <c:forEach var="c" items="${post.comments}">
        <div>💬 ${c}</div>
    </c:forEach>

    <form action="CommentServlet" method="post">
        <input type="hidden" name="postId" value="${post.posts_id}">
        <input type="text" name="commentText" placeholder="Write comment..." required>
        <button>Comment</button>
    </form>

</div>
</c:forEach>

</div>
</div>

<!-- Service Worker -->
<script>
window.addEventListener("load", () => {
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('<%=request.getContextPath()%>/sw.js');
  }
});
</script>

</body>
</html>