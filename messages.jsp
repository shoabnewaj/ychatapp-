<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Messenger | userMS</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body, html { height: 100%; width: 100%; font-family: 'Segoe UI', sans-serif; overflow: hidden; }
        .main-container { display: flex; height: 100vh; width: 100vw; }

        /* Sidebar ফিক্সড উইডথ */
        .sidebar { width: 300px; border-right: 1px solid #ddd; display: flex; flex-direction: column; background: #fff; }
        .sidebar-header { padding: 15px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; }
        .friend-list { flex: 1; overflow-y: auto; }
        
        /* Friend Item ডিজাইন */
        .friend-item { padding: 12px 15px; display: flex; align-items: center; cursor: pointer; border-bottom: 1px solid #f5f5f5; }
        .friend-item:hover { background: #f0f2f5; }
        .online-dot { height: 10px; width: 10px; background: #31a24c; border-radius: 50%; margin-right: 10px; }

        /* Chat Area (ফাঁকা জায়গা দূর করার জন্য flex: 1) */
        .chat-area { flex: 1; display: flex; flex-direction: column; background: #f0f2f5; }
        .chat-header { padding: 15px; background: #fff; border-bottom: 1px solid #ddd; font-weight: bold; }
        #chatBox { flex: 1; padding: 20px; overflow-y: auto; display: flex; flex-direction: column; }

        .msg { margin: 5px 0; padding: 8px 15px; border-radius: 18px; max-width: 75%; font-size: 14px; }
        .sent { align-self: flex-end; background: #0084ff; color: white; }
        .received { align-self: flex-start; background: #fff; color: black; border: 1px solid #ddd; }

        .input-area { padding: 10px 15px; background: #fff; border-top: 1px solid #ddd; display: flex; align-items: center; }
        #messageText { flex: 1; padding: 10px 15px; border-radius: 20px; border: 1px solid #ddd; outline: none; }
        .send-btn { margin-left: 10px; color: #0084ff; font-weight: bold; background: none; border: none; cursor: pointer; }
    </style>
</head>
<body>

<div class="main-container">
    <div class="sidebar">
        <div class="sidebar-header">
            <h3>Chats</h3>
            <a href="${pageContext.request.contextPath}/main.jsp" style="text-decoration:none; color:#0084ff; font-size:12px;">Back Home</a>
        </div>
        <!-- এই আইডি-টি খুব গুরুত্বপূর্ণ -->
        <div id="friendListContainer" class="friend-list">
            <p style="padding:15px; color:#999;">Connecting...</p>
        </div>
    </div>

    <div class="chat-area">
        <div class="chat-header">Chatting with: <span id="chattingWith" style="color:#0084ff;">None</span></div>
        <input type="hidden" id="targetFriendName">
        <div id="chatBox"></div>
        <div class="input-area">
            <input type="text" id="messageText" placeholder="Write a message..." onkeypress="if(event.keyCode==13) sendToFriend()">
            <button class="send-btn" onclick="sendToFriend()">Send</button>
        </div>
    </div>
</div>

<!-- messages.jsp এর একদম নিচে স্ক্রিপ্ট লিঙ্কের ঠিক উপরে এটি যোগ করুন -->
<script>
    // সেশন থেকে লগইন করা ইউজারের নাম সরাসরি নেওয়া হচ্ছে
    var myName = "${user.userName}"; 
    
    // যদি সেশনে নাম না থাকে (টেস্ট করার জন্য)
    if (!myName || myName === "" || myName === "null") {
        myName = "Guest_" + Math.floor(Math.random() * 100);
    }
</script>
<script src="${pageContext.request.contextPath}/js/script.js"></script>

</body>
</html>
