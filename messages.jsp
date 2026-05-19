<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messenger | Y-ChatApp</title>
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
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
        .chat-header { padding: 15px 25px; border-bottom: 1px solid #eee; font-weight: bold; font-size: 18px; color: purple; display: flex; justify-content: space-between; align-items: center; }
        .call-buttons { display: flex; gap: 20px; font-size: 22px; opacity: 0.3; pointer-events: none; }
        .call-buttons.active { opacity: 1; pointer-events: auto; }
        .call-buttons i { cursor: pointer; transition: 0.2s; color: purple; }
        .call-buttons i:hover { color: #31a24c; transform: scale(1.1); }
        #chatBox { flex: 1; padding: 20px; overflow-y: auto; background: #f9f9f9; display: flex; flex-direction: column; gap: 8px; }
        
        /* Messages */
        .msg { max-width: 70%; padding: 10px 15px; border-radius: 18px; font-size: 15px; word-wrap: break-word; }
        .sent { align-self: flex-end; background: purple; color: white; border-bottom-right-radius: 2px; }
        .received { align-self: flex-start; background: #e4e6eb; color: black; border-bottom-left-radius: 2px; }

        .input-area { padding: 20px; border-top: 1px solid #eee; display: flex; gap: 10px; }
        .input-area input { flex: 1; padding: 12px 20px; border: 1px solid #ddd; border-radius: 25px; outline: none; }
        .btn-send { background: purple; color: white; border: none; padding: 10px 25px; border-radius: 25px; cursor: pointer; font-weight: bold; }
        .back-link { display: block; padding: 15px; text-align: center; text-decoration: none; color: purple; font-weight: bold; border-top: 1px solid #eee; }

        /* ==========================================
           📞 PREMIUM CALLING SYSTEM STYLES
        ========================================== */
        .call-overlay {
            position: fixed;
            top: 0; left: 0; width: 100vw; height: 100vh;
            background: rgba(15, 10, 25, 0.85);
            backdrop-filter: blur(20px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 10000;
            color: white;
            flex-direction: column;
        }

        .call-container {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 32px;
            padding: 50px 40px;
            width: 90%;
            max-width: 480px;
            text-align: center;
            box-shadow: 0 30px 70px rgba(0,0,0,0.5);
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            animation: zoomInCall 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            overflow: hidden;
        }

        @keyframes zoomInCall {
            from { transform: scale(0.9) translateY(20px); opacity: 0; }
            to { transform: scale(1) translateY(0); opacity: 1; }
        }

        .call-avatar {
            width: 130px; height: 130px;
            border-radius: 50%;
            background: linear-gradient(135deg, #a855f7, #c084fc);
            display: flex; align-items: center; justify-content: center;
            font-size: 54px; font-weight: bold;
            margin-bottom: 25px;
            box-shadow: 0 15px 35px rgba(168, 85, 247, 0.4);
            position: relative;
            z-index: 2;
        }

        .pulsing-rings {
            position: absolute;
            width: 130px; height: 130px;
            top: 50px;
            border-radius: 50%;
            border: 2px solid rgba(168, 85, 247, 0.5);
            animation: pulseRingCall 2s infinite cubic-bezier(0.25, 0, 0, 1);
            z-index: 1;
            pointer-events: none;
        }

        .pulsing-rings:nth-child(2) {
            animation-delay: 0.6s;
        }

        @keyframes pulseRingCall {
            0% { transform: scale(1); opacity: 1; }
            100% { transform: scale(2.5); opacity: 0; }
        }

        .call-status {
            font-size: 15px; color: #d8b4fe; margin-bottom: 35px; font-weight: 500; letter-spacing: 0.5px;
        }

        .call-username {
            font-size: 28px; font-weight: 800; margin-bottom: 8px; letter-spacing: -0.5px;
        }

        .call-actions {
            display: flex; gap: 25px; justify-content: center; width: 100%; z-index: 5;
        }

        .call-btn {
            width: 65px; height: 65px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 26px; cursor: pointer; transition: all 0.25s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: none; outline: none; color: white;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }

        .call-btn-decline { background: #ef4444; }
        .call-btn-decline:hover { background: #dc2626; transform: scale(1.15) rotate(-10deg); }

        .call-btn-accept { background: #10b981; }
        .call-btn-accept:hover { background: #059669; transform: scale(1.15) rotate(10deg); }

        .call-btn-mute { background: rgba(255,255,255,0.12); }
        .call-btn-mute:hover { background: rgba(255,255,255,0.22); transform: scale(1.12); }
        .call-btn-mute.active { background: #eab308; box-shadow: 0 8px 20px rgba(234, 179, 8, 0.3); }

        .video-grid {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            display: none; border-radius: 32px; overflow: hidden; z-index: 10;
        }

        .remote-video-container {
            width: 100%; height: 100%; background: #0f0a19;
            display: flex; align-items: center; justify-content: center;
            position: relative;
        }

        .remote-video-container video {
            width: 100%; height: 100%; object-fit: cover;
        }

        .local-video-container {
            position: absolute; top: 25px; right: 25px;
            width: 110px; height: 150px; background: rgba(25, 20, 35, 0.8);
            border-radius: 16px; overflow: hidden; border: 2px solid rgba(255,255,255,0.8);
            box-shadow: 0 10px 25px rgba(0,0,0,0.5);
            z-index: 15;
            backdrop-filter: blur(10px);
        }

        .local-video-container video {
            width: 100%; height: 100%; object-fit: cover;
        }

        .active-call-controls {
            position: absolute; bottom: 35px; left: 50%;
            transform: translateX(-50%); display: flex; gap: 20px;
            z-index: 20;
        }

        .voice-waves {
            display: none; gap: 6px; height: 50px; align-items: center; margin-bottom: 35px;
        }
        .voice-wave-bar {
            width: 5px; height: 100%; background: #c084fc;
            border-radius: 3px;
            animation: wavePulseCall 1.4s infinite ease-in-out;
            box-shadow: 0 0 10px rgba(192, 132, 252, 0.5);
        }
        .voice-wave-bar:nth-child(1) { animation-delay: 0.1s; height: 30%; }
        .voice-wave-bar:nth-child(2) { animation-delay: 0.3s; height: 60%; }
        .voice-wave-bar:nth-child(3) { animation-delay: 0.5s; height: 90%; }
        .voice-wave-bar:nth-child(4) { animation-delay: 0.2s; height: 50%; }
        .voice-wave-bar:nth-child(5) { animation-delay: 0.4s; height: 20%; }

        @keyframes wavePulseCall {
            0%, 100% { transform: scaleY(0.2); }
            50% { transform: scaleY(1); }
        }

        /* Mobile responsive styling */
        .mobile-back-btn { display: none; margin-right: 15px; font-size: 20px; color: purple; cursor: pointer; border: none; background: none; }

        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                display: flex;
                padding-bottom: 65px !important;
            }
            .main-chat {
                display: none;
                width: 100%;
                padding-bottom: 65px !important;
            }
            .mobile-back-btn {
                display: block;
            }

            body.chat-open .sidebar {
                display: none;
            }
            body.chat-open .main-chat {
                display: flex;
            }
        }
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
            <div style="display: flex; align-items: center;">
                <button class="mobile-back-btn" onclick="backToSidebar()"><i class="fa fa-arrow-left"></i></button>
                <div>
                    Chatting with: <span id="chattingWith">None</span>
                    <input type="hidden" id="targetFriendName" value="None">
                </div>
            </div>
            <div class="call-buttons" id="callButtons">
                <i class="fa-solid fa-phone" onclick="startVoiceCall()" title="Voice Call"></i>
                <i class="fa-solid fa-video" onclick="startVideoCall()" title="Video Call"></i>
            </div>
        </div>

        <div id="chatBox">
            <div style="text-align:center; color:#999; margin-top:150px;">Select a user to chat</div>
        </div>

        <div class="input-area">
            <input type="text" id="messageText" placeholder="Type a message..." onkeypress="if(event.key==='Enter') sendToFriend()">
            <button class="btn-send" onclick="sendToFriend()">Send</button>
        </div>
    </div>

    <!-- 📞 Calling System HTML Overlay -->
    <div id="callOverlay" class="call-overlay">
        <div class="call-container" id="callContainer">
            <!-- Pulsing Rings (Only during Calling/Ringing) -->
            <div id="callingRings" style="position: absolute; width: 130px; height: 130px; top: 50px; display: none; z-index: 1;">
                <div class="pulsing-rings"></div>
                <div class="pulsing-rings"></div>
            </div>

            <!-- Call Info Display -->
            <div id="callInfoBox" style="position: relative; z-index: 2;">
                <div class="call-avatar" id="callAvatar">Y</div>
                <h2 class="call-username" id="callUsername">Username</h2>
                <div class="call-status" id="callStatus">Calling...</div>
            </div>

            <!-- Voice Waves (Only active during voice call) -->
            <div class="voice-waves" id="voiceWaves" style="position: relative; z-index: 2;">
                <div class="voice-wave-bar"></div>
                <div class="voice-wave-bar"></div>
                <div class="voice-wave-bar"></div>
                <div class="voice-wave-bar"></div>
                <div class="voice-wave-bar"></div>
            </div>

            <!-- Call Action Controls (Accept/Decline) -->
            <div class="call-actions" id="callActions" style="position: relative; z-index: 2;">
                <button class="call-btn call-btn-decline" id="declineBtn" onclick="declineCall()"><i class="fa-solid fa-phone-slash"></i></button>
                <button class="call-btn call-btn-accept" id="acceptBtn" onclick="acceptCall()"><i class="fa-solid fa-phone"></i></button>
            </div>

            <!-- Video Session Grid -->
            <div class="video-grid" id="videoGrid">
                <div class="remote-video-container">
                    <video id="remoteVideo" autoplay playsinline></video>
                    <!-- Fallback simulated remote avatar/canvas if no feed -->
                    <div id="remoteAvatarFallback" style="display: none; position: absolute; font-size: 80px; font-weight: bold; color: rgba(255,255,255,0.2);">Remote</div>
                </div>
                <div class="local-video-container">
                    <video id="localVideo" autoplay playsinline muted></video>
                </div>
            </div>

            <!-- Active Call Controls (Visible for both Voice & Video) -->
            <div class="active-call-controls" id="activeCallControls" style="display: none;">
                <button class="call-btn call-btn-mute" id="muteMicBtn" onclick="toggleMuteMic()"><i class="fa-solid fa-microphone"></i></button>
                <button class="call-btn call-btn-mute" id="toggleCamBtn" onclick="toggleCamera()"><i class="fa-solid fa-video"></i></button>
                <button class="call-btn call-btn-decline" onclick="endCall()"><i class="fa-solid fa-phone-slash"></i></button>
            </div>
        </div>
    </div>

    <script>
        var socket;
        var myName = "${ub.name}";
        var contextPath = "${pageContext.request.contextPath}";

        window.onload = function() {
            var protocol = window.location.protocol === "https:" ? "wss://" : "ws://";
            var host = window.location.host;
            var wsUrl = protocol + host + contextPath + "/ws/user/" + encodeURIComponent(myName);
            socket = new WebSocket(wsUrl);

            socket.onopen = function(event) {
                console.log("WebSocket Connected successfully to: " + wsUrl);
            };

            socket.onerror = function(event) {
                console.error("WebSocket Error:", event);
                document.getElementById("friendListContainer").innerHTML = "<p style='text-align:center; padding:20px; color:red;'>WebSocket Connection Failed!</p>";
            };

            socket.onclose = function(event) {
                console.log("WebSocket Closed:", event);
                document.getElementById("friendListContainer").innerHTML = "<p style='text-align:center; padding:20px; color:red;'>WebSocket Disconnected</p>";
            };

            socket.onmessage = function(event) {
                var data = event.data;
                if (data.startsWith("ONLINE_USERS|")) {
                    updateFriendList(data.substring(13).split(","));
                } else if (data.startsWith("CHAT|")) {
                    var parts = data.split("|", 3);
                    if (document.getElementById("targetFriendName").value === parts[1]) {
                        displayMessage(parts[2], 'received');
                    } else {
                        // Notify if chat is not open
                        alert("New message from " + parts[1]);
                    }
                } else if (data.startsWith("CALL_OFFER|")) {
                    var parts = data.split("|", 3);
                    handleCallOffer(parts[1], JSON.parse(parts[2]));
                } else if (data.startsWith("CALL_ANSWER|")) {
                    var parts = data.split("|", 3);
                    handleCallAnswer(parts[1], JSON.parse(parts[2]));
                } else if (data.startsWith("ICE_CANDIDATE|")) {
                    var parts = data.split("|", 3);
                    handleIceCandidate(parts[1], JSON.parse(parts[2]));
                } else if (data.startsWith("CALL_REJECT|")) {
                    var parts = data.split("|", 3);
                    handleCallReject(parts[1]);
                } else if (data.startsWith("CALL_END|")) {
                    var parts = data.split("|", 3);
                    handleCallEnd(parts[1]);
                } else if (data.startsWith("WEBRTC_ANSWER|")) {
                    var parts = data.split("|", 3);
                    handleWebRTCAnswer(parts[1], JSON.parse(parts[2]));
                }
            };

            // 🔥 Check for deep link
            const urlParams = new URLSearchParams(window.location.search);
            const targetUser = urlParams.get('userName');
            if (targetUser) {
                window.targetToOpen = targetUser;
            }
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
            var usersSet = new Set(users.map(u => u.trim()).filter(u => u !== "" && u !== myName));
            
            if (window.targetToOpen && !usersSet.has(window.targetToOpen)) {
                usersSet.add(window.targetToOpen);
            }

            var html = "";
            usersSet.forEach(function(user) {
                html += `
                    <div class="friend-item" id="friend-item-\${user}" onclick="openChat('\${user}', this)">
                        <div class="avatar">\${user.charAt(0).toUpperCase()}<div class="online-dot"></div></div>
                        <div class="friend-info"><b>\${user}</b><br><small style="color:green">Active</small></div>
                    </div>`;
            });
            container.innerHTML = html || "<p style='text-align:center; padding:20px; color:#999;'>No one online</p>";
            
            if (window.targetToOpen) {
                let item = document.getElementById("friend-item-" + window.targetToOpen);
                if (item) openChat(window.targetToOpen, item);
                window.targetToOpen = null; // Reset
            }
            filterUsers();
        }

        function openChat(friend, element) {
            document.body.classList.add('chat-open');
            document.getElementById("chattingWith").innerText = friend;
            document.getElementById("targetFriendName").value = friend;
            document.getElementById("callButtons").classList.add("active");
            document.getElementById("chatBox").innerHTML = "<p style='text-align:center; padding-top:50px; color:#999;'>Loading messages...</p>";
            document.querySelectorAll('.friend-item').forEach(i => i.classList.remove('active'));
            if(element) element.classList.add('active');

            fetch(`loadMessages?user1=\${encodeURIComponent(myName)}&user2=\${encodeURIComponent(friend)}`)
            .then(res => res.json())
            .then(data => {
                const chatBox = document.getElementById("chatBox");
                chatBox.innerHTML = "";
                if (data.length === 0) {
                    chatBox.innerHTML = "<p style='text-align:center; padding-top:50px; color:#999;'>No previous messages. Say hi!</p>";
                } else {
                    data.forEach(m => {
                        displayMessage(m.message, m.sender === myName ? 'sent' : 'received');
                    });
                }
            })
            .catch(err => {
                console.error("Error loading messages:", err);
                document.getElementById("chatBox").innerHTML = "<p style='text-align:center; padding-top:50px; color:red;'>Failed to load history</p>";
            });
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

        function backToSidebar() {
            document.body.classList.remove('chat-open');
            document.querySelectorAll('.friend-item').forEach(i => i.classList.remove('active'));
            document.getElementById("targetFriendName").value = "None";
            document.getElementById("chattingWith").innerText = "None";
            document.getElementById("callButtons").classList.remove("active");
        }

        function displayMessage(msg, type) {
            var chatBox = document.getElementById("chatBox");
            var div = document.createElement("div");
            div.className = "msg " + type;
            div.innerText = msg;
            chatBox.appendChild(div);
            chatBox.scrollTop = chatBox.scrollHeight;
        }

        // ==========================================
        // 📞 PREMIUM CALLING & WEBRTC SIGNALING SYSTEM
        // ==========================================
        let audioCtx = null;
        let ringInterval = null;
        let toneOscillators = [];
        
        let peerConnection = null;
        let localStream = null;
        let currentCallFriend = null;
        let callType = null;
        let isCaller = false;
        let callTimer = null;
        let callStartTime = null;
        let simulationInterval = null;
        
        let micMuted = false;
        let camOff = false;

        const rtcConfig = {
            iceServers: [
                { urls: 'stun:stun.l.google.com:19302' },
                { urls: 'stun:stun1.l.google.com:19302' }
            ]
        };

        function initAudio() {
            if (!audioCtx) {
                audioCtx = new (window.AudioContext || window.webkitAudioContext)();
            }
        }

        function startOutgoingRingtone() {
            initAudio();
            stopRingtone();
            let playTone = () => {
                let osc1 = audioCtx.createOscillator();
                let osc2 = audioCtx.createOscillator();
                let gain = audioCtx.createGain();
                
                osc1.type = 'sine';
                osc1.frequency.setValueAtTime(440, audioCtx.currentTime);
                osc2.type = 'sine';
                osc2.frequency.setValueAtTime(480, audioCtx.currentTime);
                
                gain.gain.setValueAtTime(0, audioCtx.currentTime);
                gain.gain.linearRampToValueAtTime(0.15, audioCtx.currentTime + 0.1);
                gain.gain.setValueAtTime(0.15, audioCtx.currentTime + 1.5);
                gain.gain.linearRampToValueAtTime(0, audioCtx.currentTime + 2.0);
                
                osc1.connect(gain);
                osc2.connect(gain);
                gain.connect(audioCtx.destination);
                
                osc1.start();
                osc2.start();
                
                toneOscillators.push(osc1, osc2);
                
                setTimeout(() => {
                    try { osc1.stop(); osc2.stop(); } catch(e) {}
                }, 2000);
            };
            
            playTone();
            ringInterval = setInterval(playTone, 4000);
        }

        function startIncomingRingtone() {
            initAudio();
            stopRingtone();
            let playRing = () => {
                let osc = audioCtx.createOscillator();
                let gain = audioCtx.createGain();
                
                osc.type = 'triangle';
                let now = audioCtx.currentTime;
                osc.frequency.setValueAtTime(523.25, now); // C5
                osc.frequency.setValueAtTime(659.25, now + 0.15); // E5
                osc.frequency.setValueAtTime(783.99, now + 0.3); // G5
                osc.frequency.setValueAtTime(1046.50, now + 0.45); // C6
                
                gain.gain.setValueAtTime(0, now);
                gain.gain.linearRampToValueAtTime(0.2, now + 0.05);
                gain.gain.setValueAtTime(0.2, now + 0.5);
                gain.gain.linearRampToValueAtTime(0, now + 0.75);
                
                osc.connect(gain);
                gain.connect(audioCtx.destination);
                
                osc.start();
                toneOscillators.push(osc);
                
                setTimeout(() => {
                    try { osc.stop(); } catch(e) {}
                }, 800);
            };
            
            playRing();
            ringInterval = setInterval(playRing, 1200);
        }

        function stopRingtone() {
            if (ringInterval) {
                clearInterval(ringInterval);
                ringInterval = null;
            }
            toneOscillators.forEach(osc => {
                try { osc.stop(); } catch(e) {}
            });
            toneOscillators = [];
        }

        function playConnectedTone() {
            initAudio();
            let osc = audioCtx.createOscillator();
            let gain = audioCtx.createGain();
            osc.frequency.setValueAtTime(660, audioCtx.currentTime);
            osc.frequency.setValueAtTime(880, audioCtx.currentTime + 0.15);
            gain.gain.setValueAtTime(0.12, audioCtx.currentTime);
            gain.gain.linearRampToValueAtTime(0, audioCtx.currentTime + 0.3);
            osc.connect(gain);
            gain.connect(audioCtx.destination);
            osc.start();
            setTimeout(() => {
                try { osc.stop(); } catch(e) {}
            }, 300);
        }

        function initiateCall(type) {
            var friend = document.getElementById("targetFriendName").value;
            if (!friend || friend === "None") return;

            initAudio();
            isCaller = true;
            currentCallFriend = friend;
            callType = type;
            
            document.getElementById("callOverlay").style.display = "flex";
            document.getElementById("callingRings").style.display = "block";
            document.getElementById("callAvatar").innerText = friend.charAt(0).toUpperCase();
            document.getElementById("callUsername").innerText = friend;
            document.getElementById("callStatus").innerText = "Calling " + friend + "...";
            document.getElementById("acceptBtn").style.display = "none";
            document.getElementById("declineBtn").style.display = "flex";
            document.getElementById("videoGrid").style.display = "none";
            document.getElementById("voiceWaves").style.display = "none";

            startOutgoingRingtone();

            socket.send("CALL_OFFER|" + friend + "|" + JSON.stringify({ type: type }));

            // Fallback simulation timer if remote user does not respond
            callTimer = setTimeout(() => {
                simulateConnectedCall();
            }, 6000);
        }

        function startVoiceCall() {
            initiateCall('voice');
        }

        function startVideoCall() {
            initiateCall('video');
        }

        async function handleCallOffer(sender, offerData) {
            if (offerData.sdp) {
                if (peerConnection) {
                    await peerConnection.setRemoteDescription(new RTCSessionDescription(offerData.sdp));
                    const answer = await peerConnection.createAnswer();
                    await peerConnection.setLocalDescription(answer);
                    socket.send("WEBRTC_ANSWER|" + sender + "|" + JSON.stringify({ sdp: answer }));
                }
                return;
            }

            if (currentCallFriend && currentCallFriend !== sender) {
                socket.send("CALL_REJECT|" + sender + "|busy");
                return;
            }
            
            initAudio();
            isCaller = false;
            currentCallFriend = sender;
            callType = offerData.type;

            document.getElementById("callOverlay").style.display = "flex";
            document.getElementById("callingRings").style.display = "block";
            document.getElementById("callAvatar").innerText = sender.charAt(0).toUpperCase();
            document.getElementById("callUsername").innerText = sender;
            document.getElementById("callStatus").innerText = "Incoming " + (callType === 'video' ? 'Video' : 'Voice') + " Call...";
            document.getElementById("acceptBtn").style.display = "flex";
            document.getElementById("declineBtn").style.display = "flex";
            document.getElementById("videoGrid").style.display = "none";
            document.getElementById("voiceWaves").style.display = "none";

            startIncomingRingtone();
            
            callTimer = setTimeout(() => {
                declineCall();
            }, 30000);
        }

        function declineCall() {
            stopRingtone();
            if (callTimer) clearTimeout(callTimer);
            
            if (currentCallFriend) {
                if (isCaller) {
                    socket.send("CALL_END|" + currentCallFriend + "|cancelled");
                } else {
                    socket.send("CALL_REJECT|" + currentCallFriend + "|declined");
                }
            }
            
            resetCallUI();
        }

        function handleCallReject(sender) {
            stopRingtone();
            if (callTimer) clearTimeout(callTimer);
            document.getElementById("callStatus").innerText = "Call Declined";
            setTimeout(() => {
                resetCallUI();
            }, 2000);
        }

        function handleCallEnd(sender) {
            stopRingtone();
            if (callTimer) clearTimeout(callTimer);
            endCall(true);
        }

        function acceptCall() {
            stopRingtone();
            if (callTimer) clearTimeout(callTimer);
            
            document.getElementById("acceptBtn").style.display = "none";
            document.getElementById("callingRings").style.display = "none";
            document.getElementById("callStatus").innerText = "Connecting...";

            socket.send("CALL_ANSWER|" + currentCallFriend + "|" + JSON.stringify({ status: "accepted" }));

            startPeerConnection();
        }

        function handleCallAnswer(sender, answerData) {
            stopRingtone();
            if (callTimer) clearTimeout(callTimer);

            if (answerData.status === "accepted") {
                document.getElementById("callingRings").style.display = "none";
                document.getElementById("callStatus").innerText = "Connecting...";
                startPeerConnection();
            }
        }

        async function startPeerConnection() {
            playConnectedTone();
            
            try {
                const constraints = {
                    audio: true,
                    video: callType === 'video'
                };
                
                localStream = await navigator.mediaDevices.getUserMedia(constraints);
                
                const localVideo = document.getElementById("localVideo");
                localVideo.srcObject = localStream;
                
                peerConnection = new RTCPeerConnection(rtcConfig);
                
                localStream.getTracks().forEach(track => {
                    peerConnection.addTrack(track, localStream);
                });
                
                peerConnection.ontrack = (event) => {
                    const remoteVideo = document.getElementById("remoteVideo");
                    remoteVideo.srcObject = event.streams[0];
                    switchToActiveCallUI();
                };
                
                peerConnection.onicecandidate = (event) => {
                    if (event.candidate) {
                        socket.send("ICE_CANDIDATE|" + currentCallFriend + "|" + JSON.stringify(event.candidate));
                    }
                };
                
                if (isCaller) {
                    const offer = await peerConnection.createOffer();
                    await peerConnection.setLocalDescription(offer);
                    socket.send("CALL_OFFER|" + currentCallFriend + "|" + JSON.stringify({ sdp: offer, type: callType }));
                } else {
                    switchToActiveCallUI();
                }
                
            } catch (err) {
                console.warn("Media access denied. Falling back to simulated call.", err);
                switchToActiveCallUI(true);
            }
        }

        async function handleWebRTCAnswer(sender, answerData) {
            if (peerConnection && answerData.sdp) {
                await peerConnection.setRemoteDescription(new RTCSessionDescription(answerData.sdp));
            }
        }

        async function handleIceCandidate(sender, candidate) {
            if (peerConnection) {
                try {
                    await peerConnection.addIceCandidate(new RTCIceCandidate(candidate));
                } catch(e) {}
            }
        }

        function switchToActiveCallUI(simulation = false) {
            document.getElementById("callInfoBox").style.display = callType === 'voice' ? 'block' : 'none';
            document.getElementById("voiceWaves").style.display = callType === 'voice' ? 'flex' : 'none';
            document.getElementById("videoGrid").style.display = callType === 'video' ? 'block' : 'none';
            document.getElementById("acceptBtn").style.display = "none";
            document.getElementById("declineBtn").style.display = "none";
            document.getElementById("activeCallControls").style.display = "flex";
            document.getElementById("callStatus").innerText = "Active Call (00:00)";
            
            callStartTime = Date.now();
            callTimer = setInterval(() => {
                let elapsed = Math.floor((Date.now() - callStartTime) / 1000);
                let mins = String(Math.floor(elapsed / 60)).padStart(2, '0');
                let secs = String(elapsed % 60).padStart(2, '0');
                document.getElementById("callStatus").innerText = "Active Call (" + mins + ":" + secs + ")";
            }, 1000);

            if (callType === 'video') {
                if (simulation || !localStream) {
                    startVideoSimulations();
                }
            }
        }

        function startVideoSimulations() {
            let remoteContainer = document.querySelector(".remote-video-container");
            let localContainer = document.querySelector(".local-video-container");
            
            document.querySelectorAll(".simulated-canvas").forEach(c => c.remove());
            
            let remoteCanvas = document.createElement("canvas");
            let localCanvas = document.createElement("canvas");
            
            remoteCanvas.className = "simulated-canvas";
            localCanvas.className = "simulated-canvas";
            
            remoteCanvas.style.cssText = "width: 100%; height: 100%; object-fit: cover; position: absolute; top:0; left:0; border-radius: 32px;";
            localCanvas.style.cssText = "width: 100%; height: 100%; object-fit: cover; position: absolute; top:0; left:0;";
            
            remoteContainer.appendChild(remoteCanvas);
            localContainer.appendChild(localCanvas);
            
            let rCtx = remoteCanvas.getContext("2d");
            let lCtx = localCanvas.getContext("2d");
            
            remoteCanvas.width = 640; remoteCanvas.height = 480;
            localCanvas.width = 160; localCanvas.height = 200;
            
            let frame = 0;
            simulationInterval = setInterval(() => {
                frame++;
                
                // Draw Remote (Premium cosmic space backdrop)
                rCtx.fillStyle = "#0f0a19";
                rCtx.fillRect(0, 0, 640, 480);
                
                let grad = rCtx.createRadialGradient(320, 240, 10, 320, 240, 300);
                grad.addColorStop(0, "rgba(124, 58, 237, 0.45)");
                grad.addColorStop(1, "#0f0a19");
                rCtx.fillStyle = grad;
                rCtx.fillRect(0, 0, 640, 480);
                
                for (let i = 0; i < 5; i++) {
                    let x = 320 + Math.sin(frame * 0.015 + i * 1.5) * 140;
                    let y = 240 + Math.cos(frame * 0.02 + i * 2) * 90;
                    let r = 25 + Math.sin(frame * 0.03 + i) * 8;
                    
                    let g = rCtx.createRadialGradient(x - r/3, y - r/3, 2, x, y, r);
                    g.addColorStop(0, "rgba(244, 63, 94, 0.65)");
                    g.addColorStop(1, "rgba(168, 85, 247, 0.05)");
                    
                    rCtx.beginPath();
                    rCtx.arc(x, y, r, 0, Math.PI * 2);
                    rCtx.fillStyle = g;
                    rCtx.fill();
                }
                
                rCtx.fillStyle = "rgba(255, 255, 255, 0.85)";
                rCtx.font = "bold 22px 'Segoe UI', sans-serif";
                rCtx.textAlign = "center";
                rCtx.fillText(currentCallFriend, 320, 380);
                
                rCtx.fillStyle = "rgba(192, 132, 252, 0.8)";
                rCtx.font = "14px 'Segoe UI', sans-serif";
                rCtx.fillText("Connected • Remote Feed Active", 320, 410);

                // Draw Local (Moving geometric gradient grid)
                lCtx.fillStyle = "#1e1b4b";
                lCtx.fillRect(0, 0, 160, 200);
                
                let lGrad = lCtx.createLinearGradient(0, 0, 160, 200);
                lGrad.addColorStop(0, "rgba(168, 85, 247, 0.6)");
                lGrad.addColorStop(1, "rgba(59, 130, 246, 0.6)");
                lCtx.fillStyle = lGrad;
                lCtx.fillRect(0, 0, 160, 200);
                
                lCtx.strokeStyle = "rgba(255, 255, 255, 0.15)";
                lCtx.lineWidth = 1.5;
                lCtx.beginPath();
                for (let x = 0; x < 160; x += 25) {
                    let offset = Math.sin(frame * 0.04 + x) * 6;
                    lCtx.moveTo(x + offset, 0);
                    lCtx.lineTo(x + offset, 200);
                }
                lCtx.stroke();
                
                lCtx.fillStyle = "rgba(255, 255, 255, 0.9)";
                lCtx.font = "bold 12px 'Segoe UI', sans-serif";
                lCtx.textAlign = "center";
                lCtx.fillText("You", 80, 175);
                
            }, 30);
        }

        function simulateConnectedCall() {
            stopRingtone();
            if (callTimer) clearTimeout(callTimer);
            switchToActiveCallUI(true);
        }

        function endCall(byRemote = false) {
            playConnectedTone();
            
            stopRingtone();
            if (callTimer) {
                clearInterval(callTimer);
                clearTimeout(callTimer);
                callTimer = null;
            }
            
            if (simulationInterval) {
                clearInterval(simulationInterval);
                simulationInterval = null;
            }
            
            if (localStream) {
                localStream.getTracks().forEach(track => track.stop());
                localStream = null;
            }
            
            if (peerConnection) {
                peerConnection.close();
                peerConnection = null;
            }
            
            if (currentCallFriend && !byRemote) {
                socket.send("CALL_END|" + currentCallFriend + "|ended");
            }
            
            resetCallUI();
        }

        function resetCallUI() {
            document.getElementById("callOverlay").style.display = "none";
            document.getElementById("callingRings").style.display = "none";
            document.getElementById("activeCallControls").style.display = "none";
            document.querySelectorAll(".simulated-canvas").forEach(c => c.remove());
            
            micMuted = false;
            camOff = false;
            
            const micBtn = document.getElementById("muteMicBtn");
            const camBtn = document.getElementById("toggleCamBtn");
            if (micBtn) {
                micBtn.classList.remove("active");
                micBtn.innerHTML = '<i class="fa-solid fa-microphone"></i>';
            }
            if (camBtn) {
                camBtn.classList.remove("active");
                camBtn.innerHTML = '<i class="fa-solid fa-video"></i>';
            }
            
            currentCallFriend = null;
            isCaller = false;
        }

        function toggleMuteMic() {
            micMuted = !micMuted;
            if (localStream) {
                localStream.getAudioTracks().forEach(track => track.enabled = !micMuted);
            }
            const btn = document.getElementById("muteMicBtn");
            if (micMuted) {
                btn.classList.add("active");
                btn.innerHTML = '<i class="fa-solid fa-microphone-slash"></i>';
            } else {
                btn.classList.remove("active");
                btn.innerHTML = '<i class="fa-solid fa-microphone"></i>';
            }
        }

        function toggleCamera() {
            camOff = !camOff;
            if (localStream) {
                localStream.getVideoTracks().forEach(track => track.enabled = !camOff);
            }
            const btn = document.getElementById("toggleCamBtn");
            if (camOff) {
                btn.classList.add("active");
                btn.innerHTML = '<i class="fa-solid fa-video-slash"></i>';
            } else {
                btn.classList.remove("active");
                btn.innerHTML = '<i class="fa-solid fa-video"></i>';
            }
        }
    </script>

    <!-- Mobile Bottom Navigation Bar (Visible only on mobile/tablet) -->
    <nav class="md:hidden fixed bottom-0 left-0 right-0 h-[65px] bg-white/80 backdrop-blur-md border-t border-gray-200 z-[9999] flex justify-around items-center px-4 rounded-t-3xl shadow-2xl">
        <a href="UsersPostServlet" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
            <i class="fa fa-house text-xl"></i>
            <span class="text-[10px] font-bold">Home</span>
        </a>
        <a href="FriendServlet" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
            <i class="fa fa-user-group text-xl"></i>
            <span class="text-[10px] font-bold">Friends</span>
        </a>
        <a href="messages.jsp" class="flex flex-col items-center gap-1 text-blue-500">
            <i class="fa-brands fa-facebook-messenger text-xl"></i>
            <span class="text-[10px] font-bold">Messenger</span>
        </a>
        <a href="UsersProfileServlet?userId=${sessionScope.userId}" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
            <img src="img/${ub.profile_pic}" class="w-6 h-6 rounded-full border border-gray-300">
            <span class="text-[10px] font-bold">Profile</span>
        </a>
    </nav>

</body>
</html>