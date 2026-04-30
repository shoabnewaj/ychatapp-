<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Messenger | Y-ChatApp</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { background-color: #f0f2f5; display: flex; height: 100vh; overflow: hidden; }

        /* Sidebar Design */
        .sidebar { width: 360px; background: white; border-right: 1px solid #ddd; display: flex; flex-direction: column; }
        .sidebar-header { padding: 20px; background: purple; color: white; }
        
        /* 🔥 Search Bar Styles */
        .search-container { padding: 10px 15px; border-bottom: 1px solid #eee; }
        .search-box {
            width: 100%; padding: 10px 15px; border: none; border-radius: 20px;
            background: #f0f2f5; outline: none; font-size: 14px;
        }

        /* Chat List */
        #friendListContainer { flex: 1; overflow-y: auto; padding: 10px; }
        .friend-item { 
            display: flex; align-items: center; padding: 12px; border-radius: 12px; 
            cursor: pointer; transition: 0.2s; margin-bottom: 5px;
        }
        .friend-item:hover { background-color: #f3e8ff; }
        .friend-item.active { background-color: #ede9fe; border-left: 4px solid purple; }

        .avatar { 
            width: 45px; height: 45px; background: #9333ea; color: white; 
            border-radius: 50%; margin-right: 12px; display: flex; 
            align-items: center; justify-content: center; font-weight: bold; position: relative;
        }
        .online-dot { 
            width: 12px; height: 12px; background: #31a24c; border: 2px solid white;
            border-radius: 50%; position: absolute; bottom: 0; right: 0;
        }

        /* Chat Window */
        .main-chat { flex: 1; display: flex; flex-direction: column; background: white; }
        .chat-header { padding: 15px 25px; border-bottom: 1px solid #eee; font-weight: bold; font-size: 18px; color: purple; }
        #chatBox { flex: 1; padding: 20px; overflow-y: auto; background: #f9f9f9; display: flex; flex-direction: column; gap: 8px; }
        
        /* Messages */
        .msg { max-width: 70%; padding: 10px 15px; border-radius: 18px; font-size: 15px; word-wrap: break-word; }
        .sent { align-self: flex-end; background: purple; color: white; border-bottom-right-radius: 2px; }
        .received { align-self: flex-start; background: #e4e6eb; color: black; border-bottom-left-radius: 2px; }

        .input-area { padding: 20px; border-top: 1px solid #eee; display: flex; gap: 10px; }
        .input-area input { flex: 1; padding: 12px 20px; border: 1px solid #ddd; border-radius: 25px; outline: none; }
        .btn-send { background: purple; color: white; border: none; padding: 10px 25px; border-radius: 25px; cursor: pointer; font-weight: bold; }
        .back-link { display: block; padding: 15px; text-align: center; text-decoration: none; color: purple; font-weight: bold; border-top: 1px solid #eee; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header">
            <h3>Chats</h3>
            <small>Logged in as: <b>${ub.name}</b></small>
        </div>

        <div class="search-container">
            <input type="text" id="userSearch" class="search-box" placeholder="Search friends..." onkeyup="filterUsers()">
        </div>
        
        <div id="friendListContainer">
            <p style="padding:20px; color:#999; text-align:center;">Connecting...</p>
        </div>

        <a href="UsersPostServlet" class="back-link">← Home</a>
    </div>

    <div class="main-chat">
        <div class="chat-header">
            Chatting with: <span id="chattingWith">None</span>
            <input type="hidden" id="targetFriendName" value="None">
        </div>

        <div id="chatBox">
            <div style="text-align:center; color:#999; margin-top:150px;">Select a user to chat</div>
        </div>

        <div class="input-area">
            <input type="text" id="messageText" placeholder="Type a message..." onkeypress="if(event.key==='Enter') sendToFriend()">
            <button class="btn-send" onclick="sendToFriend()">Send</button>
        </div>
    </div>

    <script>
        var socket;
        var myName = "${ub.name}";
        var contextPath = "${pageContext.request.contextPath}";

        window.onload = function() {
            var protocol = window.location.protocol === "https:" ? "wss://" : "ws://";
            var host = window.location.host;
            var wsUrl = protocol + host + contextPath + "/ws/user/" + myName;
            socket = new WebSocket(wsUrl);

            socket.onmessage = function(event) {
                var data = event.data;
                if (data.startsWith("ONLINE_USERS|")) {
                    updateFriendList(data.substring(13).split(","));
                } else if (data.startsWith("CHAT|")) {
                    var parts = data.split("|", 3);
                    if (document.getElementById("targetFriendName").value === parts[1]) {
                        displayMessage(parts[2], 'received');
                    } else {
                        alert("New message from " + parts[1]);
                    }
                }
            };
        };

        // 🔥 SEARCH FILTER LOGIC
        function filterUsers() {
            var input = document.getElementById('userSearch').value.toLowerCase();
            var items = document.getElementsByClassName('friend-item');

            for (var i = 0; i < items.length; i++) {
                var name = items[i].getElementsByTagName('b')[0].innerText.toLowerCase();
                if (name.includes(input)) {
                    items[i].style.display = "flex";
                } else {
                    items[i].style.display = "none";
                }
            }
        }

        function updateFriendList(users) {
            var container = document.getElementById("friendListContainer");
            var html = "";
            users.forEach(function(user) {
                user = user.trim();
                if (user !== "" && user !== myName) {
                    html += `
                        <div class="friend-item" onclick="openChat('${user}', this)">
                            <div class="avatar">${user.charAt(0).toUpperCase()}<div class="online-dot"></div></div>
                            <div class="friend-info"><b>${user}</b><br><small style="color:green">Active</small></div>
                        </div>`;
                }
            });
            container.innerHTML = html || "<p style='text-align:center; padding:20px; color:#999;'>No one online</p>";
            filterUsers(); // সার্চ চালু থাকলে লিস্ট আপডেট হলেও ফিল্টার বজায় থাকবে
        }

        function openChat(friend, element) {
            document.getElementById("chattingWith").innerText = friend;
            document.getElementById("targetFriendName").value = friend;
            document.getElementById("chatBox").innerHTML = "";
            document.querySelectorAll('.friend-item').forEach(i => i.classList.remove('active'));
            element.classList.add('active');
        }

        function sendToFriend() {
            var friend = document.getElementById("targetFriendName").value;
            var msgInput = document.getElementById("messageText");
            if (friend !== "None" && msgInput.value.trim() !== "") {
                socket.send("CHAT|" + friend + "|" + msgInput.value);
                displayMessage(msgInput.value, 'sent');
                msgInput.value = "";
            }
        }

        function displayMessage(msg, type) {
            var chatBox = document.getElementById("chatBox");
            var div = document.createElement("div");
            div.className = "msg " + type;
            div.innerText = msg;
            chatBox.appendChild(div);
            chatBox.scrollTop = chatBox.scrollHeight;
        }
    </script>
</body>
</html>