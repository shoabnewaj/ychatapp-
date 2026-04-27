<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ユーザー登録 | Y-Chat</title>

<style>
body {
    margin: 0;
    font-family: Arial;
    background: #f0f2f5;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

/* Layout */
.container {
    display: flex;
    gap: 80px;
    align-items: center;
}

/* Left */
.left h1 {
    color: #1877f2;
    font-size: 50px;
}

.left p {
    font-size: 20px;
}

/* Card */
.card {
    background: white;
    padding: 25px;
    border-radius: 10px;
    width: 350px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
}

/* Input */
input {
    width: 100%;
    padding: 12px;
    margin-bottom: 8px;
    border-radius: 6px;
    border: 1px solid #ddd;
}

/* Button */
.signup-btn {
    width: 100%;
    background: #42b72a;
    color: white;
    border: none;
    padding: 12px;
    border-radius: 6px;
    font-size: 16px;
    cursor: pointer;
}

.signup-btn:hover {
    background: #36a420;
}

/* Error */
.error {
    color: red;
    font-size: 13px;
    margin-bottom: 5px;
}

/* Link */
.login-link {
    display: block;
    text-align: center;
    margin-top: 10px;
    color: #1877f2;
    text-decoration: none;
}
</style>
</head>

<body>

<div class="container">

    <!-- LEFT -->
    <div class="left">
        <h1>Y-Chat</h1>
        <p>Create your account and start sharing 🚀</p>
    </div>

    <!-- CARD -->
    <div class="card">

        <form action="UsersRegistServlet" method="post" enctype="multipart/form-data">

            <!-- NAME -->
            <input type="text" name="name"
                   placeholder="Your Name"
                   value="${usersBeans.name}" required>
            <div class="error">${errorMsg_name}</div>

            <!-- EMAIL -->
            <input type="email" name="email"
                   placeholder="Email address"
                   value="${usersBeans.email}" required>

            <!-- PASSWORD -->
            <input type="password" name="pass"
                   placeholder="半角英数字4〜12文字" required>
            <div class="error">${errorMsg_pass}</div>

            <!-- IMAGE -->
            <input type="file" name="user_img">

            <!-- GENERAL ERROR -->
            <div class="error">${errorMsg}</div>

            <!-- BUTTON -->
            <button type="submit" class="signup-btn">登録する</button>

        </form>

        <!-- LOGIN LINK -->
        <a href="UsersLoginServlet" class="login-link">← Back to Login</a>

    </div>

</div>

</body>
</html>