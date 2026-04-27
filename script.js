var socket;
// myName ভেরিয়েবলটি আপনার JSP পেজ থেকে আসবে (সেশন অনুযায়ী)

window.onload = function() {
    if (myName && myName !== "null") {
        // WebSocket কানেকশন তৈরি
        socket = new WebSocket("ws://localhost:8080/userMS_EX_tutorial/ws/user/" + myName);

        socket.onopen = function() {
            console.log("Connected to server as: " + myName);
        };

        socket.onmessage = function(event) {
            var data = event.data;
            console.log("Received: " + data);

            // ১. অনলাইন ইউজার লিস্ট আপডেট লজিক
            if (data.startsWith("ONLINE_USERS|")) {
                var users = data.substring(13).split(",");
                updateFriendList(users);
            } 
            
            // ২. নোটিফিকেশন সিগন্যাল লজিক (লাল ডট দেখানো)
            else if (data.startsWith("NOTIFICATION|")) {
                var notifBadge = document.getElementById("notif-badge");
                if (notifBadge) {
                    notifBadge.style.display = "inline-block"; // লাল ডটটি দেখাবে
                    var count = parseInt(notifBadge.innerText) || 0;
                    notifBadge.innerText = count + 1; // সংখ্যা ১ বাড়িয়ে দিবে
                }
            } 
            
            // ৩. চ্যাট মেসেজ রিসিভ করার লজিক
            else if (data.startsWith("CHAT|")) {
                // CHAT| মেসেজটি চ্যাট বক্সে দেখাবে
                displayMessage(data.substring(5), 'received');
            }
            
            // ৪. সাধারণ মেসেজ (যদি কোনো প্রিফিক্স না থাকে)
            else {
                displayMessage(data, 'received');
            }
        };

        socket.onerror = function(error) {
            console.error("WebSocket Error: ", error);
        };
    } else {
        console.error("Username not found! Please login first.");
    }
};

// ফ্রেন্ড লিস্ট আপডেট করার ফাংশন
function updateFriendList(users) {
    var html = "";
    users.forEach(function(user) {
        user = user.trim();
        // নিজেকে ছাড়া বাকি সবাইকে লিস্টে দেখাবে
        if (user !== "" && user !== myName) {
            html += '<div class="friend-item" onclick="openChat(\'' + user + '\')">' +
                    '<div class="online-dot"></div><b>' + user + '</b></div>';
        }
    });
    var container = document.getElementById("friendListContainer");
    if (container) {
        container.innerHTML = html || "<p style='padding:15px; color:#999;'>No one online</p>";
    }
}

// চ্যাট বক্স ওপেন করা
function openChat(friend) {
    var chattingWith = document.getElementById("chattingWith");
    var targetFriendName = document.getElementById("targetFriendName");
    var chatBox = document.getElementById("chatBox");

    if (chattingWith) chattingWith.innerText = friend;
    if (targetFriendName) targetFriendName.value = friend;
    if (chatBox) chatBox.innerHTML = "<p style='text-align:center; color:#ccc; font-size:12px;'>Conversation started with " + friend + "</p>";
}

// মেসেজ পাঠানোর ফাংশন
function sendToFriend() {
    var friendInput = document.getElementById("targetFriendName");
    var messageInput = document.getElementById("messageText");
    
    var friend = friendInput ? friendInput.value : "";
    var msg = messageInput ? messageInput.value : "";

    if (!friend || friend === "None") {
        alert("Please select a friend first!");
        return;
    }

    if (msg.trim() !== "" && socket.readyState === WebSocket.OPEN) {
        // সার্ভারকে পাঠানো হচ্ছে: receiver|message ফরম্যাটে
        socket.send(friend + "|" + msg);
        displayMessage(msg, 'sent');
        messageInput.value = "";
    }
}

// মেসেজ স্ক্রিনে দেখানোর ফাংশন
function displayMessage(msg, type) {
    var chatBox = document.getElementById("chatBox");
    if (chatBox) {
        chatBox.innerHTML += '<div class="msg ' + type + '">' + msg + '</div>';
        chatBox.scrollTop = chatBox.scrollHeight;
    }
}
