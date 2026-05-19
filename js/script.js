var socket;

window.onload = function() {

    if (!myName) return;

    var protocol = window.location.protocol === "https:" ? "wss://" : "ws://";
    var host = window.location.host;
    var wsUrl = protocol + host + contextPath + "/ws/user/" + myName;

    console.log("Connecting to:", wsUrl);

    socket = new WebSocket(wsUrl);

    socket.onopen = function() {
        console.log("WebSocket Connected!");
        document.getElementById("friendListContainer").innerHTML =
            "<p style='padding:15px; color:#999;'>Waiting for users...</p>";
    };

    // ✅ SINGLE onmessage (ALL HANDLED HERE)
    socket.onmessage = function(event) {

        var data = event.data;
        console.log("Server:", data);

        // ONLINE USERS
        if (data.startsWith("ONLINE_USERS|")) {
            var users = data.substring(13).split(",");
            updateFriendList(users);
        }

        // CHAT
        else if (data.startsWith("CHAT|")) {
            var parts = data.split("|", 3);
            var sender = parts[1];
            var msg = parts[2];

            var currentChat = document.getElementById("targetFriendName").value;

            if (currentChat === sender) {
                displayMessage(msg, 'received');
            } else {
                alert("New message from " + sender);
            }
        }

        // NOTIFICATION
        else if (data.startsWith("NOTIF|")) {
            let msg = data.split("|")[1];
            let list = document.querySelector(".notification-list");

            if (list) {
                let item = document.createElement("div");
                item.innerHTML = "🔔 " + msg + " (Just now)";
                list.prepend(item);
            }
        }
    };

    socket.onerror = function(err) {
        console.error("WebSocket Error:", err);
        document.getElementById("friendListContainer").innerHTML =
            "<p style='padding:15px; color:red;'>Connection Error!</p>";
    };

    socket.onclose = function() {
        console.log("Connection closed");
    };
};

// ================= FUNCTIONS =================

// FRIEND LIST
function updateFriendList(users) {
    var container = document.getElementById("friendListContainer");
    var html = "";

    users.forEach(function(user) {
        user = user.trim();
        if (user && user !== myName) {
            html += `<div class="friend-item" onclick="openChat('${user}')">
                        <div class="online-dot"></div>
                        <b>${user}</b>
                     </div>`;
        }
    });

    container.innerHTML = html || "<p style='padding:15px;'>No one online</p>";
}

// OPEN CHAT
function openChat(friend) {
    document.getElementById("chattingWith").innerText = friend;
    document.getElementById("targetFriendName").value = friend;
    document.getElementById("chatBox").innerHTML =
        `<div style='text-align:center;color:#999;'>Conversation with ${friend}</div>`;
}

// SEND MESSAGE
function sendToFriend() {
    if (!socket || socket.readyState !== WebSocket.OPEN) {
        alert("Connection not ready!");
        return;
    }

    var friend = document.getElementById("targetFriendName").value;
    var msgInput = document.getElementById("messageText");
    var msg = msgInput.value.trim();

    if (!friend) {
        alert("Select a friend!");
        return;
    }

    if (msg) {
        socket.send("CHAT|" + friend + "|" + msg);
        displayMessage(msg, 'sent');
        msgInput.value = "";
    }
}

// DISPLAY MESSAGE
function displayMessage(msg, type) {
    var chatBox = document.getElementById("chatBox");

    var div = document.createElement("div");
    div.className = "msg " + type;
    div.innerText = msg;

    chatBox.appendChild(div);
    chatBox.scrollTop = chatBox.scrollHeight;
}

// ================= COMMENT SYSTEM =================

// LIKE / DISLIKE
function commentAction(commentId, action){
    fetch("CommentInteractionServlet",{
        method:"POST",
        headers:{"Content-Type":"application/x-www-form-urlencoded"},
        body:"commentId="+commentId+"&action="+action
    })
    .then(r=>r.json())
    .then(data=>{
        document.getElementById("clike-"+commentId).innerText=data.likes;
        document.getElementById("cdislike-"+commentId).innerText=data.dislikes;
    });
}

// TOGGLE REPLY
function toggleReply(id){
    let box=document.getElementById("replyBox-"+id);
    box.style.display = box.style.display==="none"?"block":"none";
}

// SEND REPLY
function sendReply(commentId){
    let input=document.getElementById("reply-"+commentId);
    let text=input.value.trim();
    if(!text)return;

    fetch("ReplyServlet",{
        method:"POST",
        headers:{"Content-Type":"application/x-www-form-urlencoded"},
        body:"commentId="+commentId+"&replyText="+encodeURIComponent(text)
    }).then(()=>location.reload());
}