<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${profileUser.name} | Profile</title>

    <style>
        * { margin:0; padding:0; box-sizing:border-box; }

        body {
            font-family: 'Segoe UI', sans-serif;
            display: flex;
            background: #f0f2f5;
            height: 100vh;
            overflow: hidden;
        }

        .sidebar {
            width: 260px;
            height: 100vh;
            background: white;
            padding: 20px;
            border-right: 1px solid #ddd;
            position: fixed;
        }

        .logo {
            font-size: 22px;
            font-weight: bold;
            color: purple;
            margin-bottom: 30px;
        }

        .menu a {
            display: block;
            padding: 12px;
            text-decoration: none;
            color: #555;
            border-radius: 10px;
            margin-bottom: 8px;
        }

        .menu a:hover, .menu a.active {
            background: #f3e8ff;
            color: purple;
            font-weight: bold;
        }

        .main {
            flex: 1;
            margin-left: 260px;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow-y: auto;
        }

        .profile-card {
            background: white;
            width: 450px;
            padding: 40px;
            border-radius: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            text-align: center;
        }

        .img-container {
            width: 130px;
            height: 130px;
            margin: 0 auto 15px;
            border-radius: 50%;
            border: 4px solid #f3e8ff;
            padding: 3px;
        }

        .profile-img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
        }

        .profile-info h2 {
            font-size: 24px;
            margin-bottom: 5px;
        }

        .profile-info p {
            color: #65676b;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .stats-row {
            display: flex;
            justify-content: space-around;
            margin: 25px 0;
            padding: 15px 0;
            border-top: 1px solid #f0f2f5;
            border-bottom: 1px solid #f0f2f5;
        }

        .stat-item b {
            display: block;
            font-size: 18px;
        }

        .stat-item span {
            font-size: 12px;
            color: #90949c;
        }

        .btn {
            display: block;
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            border: none;
            font-weight: bold;
            cursor: pointer;
            margin-top: 10px;
        }

        .btn-edit { background: #e4e6eb; }
        .btn-primary { background: #8e44ad; color: white; }
        .btn-accept { background: #2ecc71; color: white; }

        .upload-box {
            margin-top: 15px;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #1877f2;
            font-size: 13px;
        }
    </style>
</head>

<body>

<div class="sidebar">
    <div class="logo">💬 Y-ChatApp</div>
    <div class="menu">
        <a href="UsersPostServlet">🏠 Home</a>
        <a href="#">💬 Messages</a>
        <a href="FriendServlet">👥 Friends</a>
        <a href="UsersProfileServlet" class="active">👤 Profile</a>
        <a href="UsersLogoutServlet">🚪 Logout</a>
    </div>
</div>

<div class="main">
<div class="profile-card">

    <!-- PROFILE IMAGE -->
    <div class="img-container">
        <img src="${not empty profileUser.user_img ? 'uploads/' + profileUser.user_img : 'https://via.placeholder.com/150'}"
             class="profile-img">
    </div>

    <!-- 🆕 PROFILE PIC UPLOAD (ONLY OWN PROFILE) -->
    <c:if test="${profileUser.id == ub.id}">
        <form action="uploadProfile" method="post" enctype="multipart/form-data" class="upload-box">
            <input type="file" name="profilePic" required>
            <button type="submit" class="btn btn-primary">📸 Upload Profile</button>
        </form>
    </c:if>

    <!-- INFO -->
    <div class="profile-info">
        <h2>${profileUser.name}</h2>
        <p>📧 ${profileUser.email}<br><small>User ID: #${profileUser.id}</small></p>
    </div>

    <!-- STATS -->
    <div class="stats-row">
        <div class="stat-item"><b>${friendsCount}</b><span>Friends</span></div>
        <div class="stat-item"><b>${followerCount}</b><span>Followers</span></div>
        <div class="stat-item"><b>${followingCount}</b><span>Following</span></div>
    </div>

    <!-- ACTIONS -->
    <div class="actions">
        <c:choose>

            <c:when test="${profileUser.id == ub.id}">
                <a href="EditProfileServlet" class="btn btn-edit">⚙️ Edit Profile</a>
            </c:when>

            <c:when test="${friendStatus == 'RECEIVED'}">
                <form action="FriendServlet" method="post">
                    <input type="hidden" name="targetId" value="${profileUser.id}">
                    <button name="action" value="ACCEPT" class="btn btn-accept">✅ Accept</button>
                </form>
            </c:when>

            <c:when test="${friendStatus == 'SENT'}">
                <button class="btn btn-edit" disabled>⏳ Sent</button>
            </c:when>

            <c:when test="${friendStatus == 'FRIENDS'}">
                <button class="btn btn-edit" disabled>✅ Friends</button>
            </c:when>

            <c:otherwise>
                <form action="FriendServlet" method="post">
                    <input type="hidden" name="targetId" value="${profileUser.id}">
                    <button name="action" value="SEND" class="btn btn-primary">➕ Add Friend</button>
                </form>
            </c:otherwise>

        </c:choose>
    </div>

    <a href="UsersPostServlet" class="back-link">← Back to Feed</a>

</div>
</div>

</body>
</html>