<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Y-ChatApp | Home</title>
<style>
    /* basic reset & layout */
    *{margin:0;padding:0;box-sizing:border-box;}
    body{font-family: 'Segoe UI', sans-serif; display:flex; background:#f0f2f5; color: #1c1e21;}

    /* sidebar */
    .sidebar{ width:260px; height:100vh; background:white; position:fixed; display:flex; flex-direction:column; justify-content:space-between; padding:20px; border-right: 1px solid #ddd; z-index: 100; }
    
    .logo{ font-size:26px; font-weight:bold; color:purple; display:flex; gap:10px; align-items:center; margin-bottom: 25px; animation: pulse 2s infinite; }
    @keyframes pulse { 0% { transform: scale(1); } 50% { transform: scale(1.05); } 100% { transform: scale(1); } }

    .search-bar { width: 100%; padding: 10px 15px; border-radius: 20px; border: 1px solid #ddd; background: #f0f2f5; outline: none; margin-bottom: 20px; }

    .menu a{ display:flex; align-items:center; gap:12px; padding:12px; text-decoration:none; color:#444; border-radius:8px; margin-bottom: 5px; transition: 0.3s; }
    .menu a:hover{ background:#f3e8ff; color:purple; }

    /* main feed */
    .main{ margin-left:260px; padding:20px; width:100%; display:flex; justify-content:center; }
    .feed{ width:650px; max-width: 100%; }

    /* create post box */
    .create-post{ background: white; padding: 20px; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    .create-post textarea{ width: 100%; border: none; padding: 10px; resize: none; font-size: 16px; outline: none; background: #f9f9f9; border-radius: 8px; }
    
    .post-footer { display: flex; justify-content: space-between; align-items: center; margin-top: 15px; }
    .custom-file-upload { background: #f0f2f5; padding: 8px 15px; border-radius: 20px; cursor: pointer; font-weight: 600; color: #65676b; }
    .btn-post{ background: purple; color: white; border: none; padding: 10px 25px; border-radius: 20px; font-weight: bold; cursor: pointer; }

    /* post card */
    .post-card{ background:white; padding:15px; border-radius:12px; margin-bottom:15px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
    .post-media{ width:100%; border-radius:10px; margin-top:10px; }

    /* comments style */
    .comment-container { margin-top: 15px; padding: 12px; background: #f8f9fa; border-radius: 12px; }
    .comment-list { max-height: 250px; overflow-y: auto; }
    .single-comment { display: flex; gap: 10px; margin-bottom: 12px; align-items: flex-start; }
    .comment-bubble { background: white; padding: 8px 12px; border-radius: 15px; border: 1px solid #ddd; box-shadow: 0 1px 2px rgba(0,0,0,0.05); }
    .commenter-name { font-size: 12px; font-weight: bold; color: purple; display: block; margin-bottom: 2px; }
</style>
</head>
<body>

<div class="sidebar">
    <div>
        <div class="logo"><img src="${pageContext.request.contextPath}/icons/icon-192.png" width="30">Y-ChatApp</div>
        <input type="text" id="postSearch" class="search-bar" placeholder="Search posts..." onkeyup="filterPosts()">
        <div class="menu">
            <a href="UsersPostServlet">🏠 Home</a>
            <a href="messages.jsp">💬 Messages</a>
            <a href="NotificationServlet">🔔 Notifications</a>
            <a href="FriendServlet">👥 Friends</a>
            <a href="UsersProfileServlet">👤 Profile</a>
            <a href="UsersLogoutServlet">🚪 Logout</a>
        </div>
    </div>
    <div style="border-top:1px solid #eee; padding-top:15px;">
        <b>${ub.name}</b><br><small>${ub.email}</small>
    </div>
</div>

<div class="main">
    <div class="feed">
        <div class="create-post">
            <form action="UsersPostServlet" method="post" enctype="multipart/form-data">
                <textarea name="content" rows="3" placeholder="What's on your mind, ${ub.name}?" required></textarea>
                <div class="post-footer">
                    <!--  <label class="custom-file-upload">
                        <input type="file" name="media" style="display:none;" onchange="this.parentElement.innerText='✅ File Selected'">
                        🖼️ Photo/Video
                    </label> --> 
                     テスト：<input type="file" name="media"> 
                    <button type="submit" class="btn-post">Post Now</button>
                </div>
            </form>
        </div>

        <c:forEach var="post" items="${postList}">
            <div class="post-card">
                <b style="color:purple; font-size:18px;">${post.name}</b>
                <p style="margin-top:8px;">${post.content}</p>
   		<c:if test="${not empty post.fileName}">
            <img class="post-media" src="img/${post.fileName}" >
        </c:if>

                <div style="margin-top:12px; display:flex; gap:10px; border-top:1px solid #eee; padding-top:10px;">
                    <button style="border:none; background:#f3e8ff; padding:8px 15px; border-radius:20px; cursor:pointer;" onclick="sendInteraction(${post.posts_id}, 'LIKE')">👍 <span id="like-${post.posts_id}">${post.likes}</span></button>
                    <button style="border:none; background:#f3e8ff; padding:8px 15px; border-radius:20px; cursor:pointer;" onclick="sendInteraction(${post.posts_id}, 'DISLIKE')">👎 <span id="dislike-${post.posts_id}">${post.dislikes}</span></button>
                    <button style="border:none; background:#f3e8ff; padding:8px 15px; border-radius:20px; cursor:pointer;" onclick="sendInteraction(${post.posts_id}, 'SHARE')">📤 Share</button>
                </div>

                <div class="comment-container">
                    <div class="comment-list" id="cbox-${post.posts_id}">
                        <c:forEach var="cmt" items="${post.comments}">
                            <div class="single-comment">
                                <div style="width:30px; height:30px; background:#ddd; border-radius:50%; display:flex; align-items:center; justify-content:center;">👤</div>
                                <div class="comment-bubble">
                                    <span class="commenter-name">User</span>
                                    <span>${cmt}</span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <div style="display:flex; gap:8px; margin-top:10px;">
                        <input id="cmt-${post.posts_id}" style="flex:1; padding:10px; border:1px solid #ddd; border-radius:20px; outline:none;" placeholder="Write a comment..." onkeypress="if(event.key==='Enter') sendComment(${post.posts_id})">
                        <button class="btn-post" style="padding:5px 15px; font-size:13px;" onclick="sendComment(${post.posts_id})">Send</button>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script>
    var socket;
    var myName = "${ub.name}";
    var myId = "${ub.id}";

    window.onload = function() {
        var protocol = window.location.protocol === "https:" ? "wss://" : "ws://";
        var wsUrl = protocol + window.location.host + "${pageContext.request.contextPath}/ws/user/" + myName;
        socket = new WebSocket(wsUrl);
        
        socket.onmessage = function(event) {
            if (event.data.startsWith("CHAT|")) {
                alert("New message from " + event.data.split("|")[1]);
            }
        };
    };

    function sendComment(postId) {
        var input = document.getElementById("cmt-" + postId);
        var text = input.value.trim();
        if (!text) return;

        fetch("CommentServlet", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "postId=" + encodeURIComponent(postId) + "&commentText=" + encodeURIComponent(text)
        }).then(res => {
            if (res.ok) {
                var box = document.getElementById("cbox-" + postId);
                var div = document.createElement("div");
                div.className = "single-comment";
                div.innerHTML = `
                    <div style="width:32px; height:32px; background:purple; color:white; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:12px; font-weight:bold; flex-shrink:0;">\${myName.charAt(0).toUpperCase()}</div>
                    <div style="display:flex; flex-direction:column;">
                        <span class="commenter-name">\${myName}</span>
                        <div class="comment-bubble">\${text}</div>
                    </div>`;
                box.appendChild(div);
                input.value = "";
                box.scrollTop = box.scrollHeight;
            }
        });
    }

    function sendInteraction(postId, action) {
        fetch("InteractionServlet", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "postId=" + postId + "&action=" + action
        }).then(r => r.json()).then(data => {
            if (action === "SHARE") location.reload();
            else {
                document.getElementById('like-' + postId).innerText = data.likes;
                document.getElementById('dislike-' + postId).innerText = data.dislikes;
            }
        });
    }

    function filterPosts() {
        var input = document.getElementById('postSearch').value.toLowerCase();
        var posts = document.getElementsByClassName('post-card');
        for (var i = 0; i < posts.length; i++) {
            posts[i].style.display = posts[i].innerText.toLowerCase().includes(input) ? "block" : "none";
        }
    }
</script>
</body>
</html>