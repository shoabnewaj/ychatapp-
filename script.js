var socket;

window.onload = function() {
    if (myName) {
        // ডাইনামিক ইউআরএল তৈরি (এটি প্রোজেক্টের নাম যাই হোক, কাজ করবে)
        var protocol = window.location.protocol === "https:" ? "wss://" : "ws://";
        var host = window.location.host;
        var wsUrl = protocol + host + contextPath + "/ws/user/" + myName;

        console.log("Attempting to connect to: " + wsUrl);
        socket = new WebSocket(wsUrl);

        socket.onopen = function() {
            console.log("WebSocket Connected successfully!");
            document.getElementById("friendListContainer").innerHTML = "<p style='padding:15px; color:#999;'>Waiting for users...</p>";
        };

        socket.onmessage = function(event) {
            var data = event.data;
            console.log("Message from server: " + data);

            // ১. অনলাইন লিস্ট আপডেট
            if (data.startsWith("ONLINE_USERS|")) {
                var users = data.substring(13).split(",");
                updateFriendList(users);
            } 
            // ২. মেসেজ রিসিভ করা (CHAT|sender|message)
            else if (data.startsWith("CHAT|")) {
                var parts = data.split("|", 3);
                var sender = parts[1];
                var msg = parts[2];
                
                var currentChat = document.getElementById("targetFriendName").value;
                if (currentChat === sender) {
                    displayMessage(msg, 'received');
                } else {
                    // অন্য কারো মেসেজ আসলে নোটিফিকেশন বা এলার্ট
                    alert("New message from " + sender);
                }
            }
        };

        socket.onerror = function(err) {
            console.error("WebSocket Error detected:", err);
            document.getElementById("friendListContainer").innerHTML = "<p style='padding:15px; color:red;'>Connection Error!</p>";
        };

        socket.onclose = function() {
            console.log("Connection closed.");
        };
    }
};

function updateFriendList(users) {
    var container = document.getElementById("friendListContainer");
    var html = "";
    var count = 0;

    users.forEach(function(user) {
        user = user.trim();
        // নিজেকে ছাড়া বাকি সবাইকে লিস্টে দেখানো
        if (user !== "" && user !== myName) {
            html += '<div class="friend-item" onclick="openChat(\'' + user + '\')">' +
                    '<div class="online-dot"></div><b>' + user + '</b></div>';
            count++;
        }
    });

    container.innerHTML = html || "<p style='padding:15px; color:#999;'>No one else online</p>";
}

function openChat(friend) {
    document.getElementById("chattingWith").innerText = friend;
    document.getElementById("targetFriendName").value = friend;
    document.getElementById("chatBox").innerHTML = "<div style='text-align:center; color:#999; font-size:12px;'>Conversation with " + friend + "</div>";
}

function sendToFriend() {
    var friend = document.getElementById("targetFriendName").value;
    var msgInput = document.getElementById("messageText");
    var msg = msgInput.value;

    if (!friend || friend === "" || friend === "None") {
        alert("Select a friend first!");
        return;
    }

    if (msg.trim() !== "" && socket.readyState === WebSocket.OPEN) {
        // জাভা সার্ভারের ফরম্যাট: CHAT|receiver|content
        socket.send("CHAT|" + friend + "|" + msg);
        displayMessage(msg, 'sent');
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
