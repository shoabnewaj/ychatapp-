<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
<title>ログイン | Y-Chat</title>

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

/* Left side */
.left h1 {
    color: #1877f2;
    font-size: 50px;
    margin-bottom: 10px;
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
    margin-bottom: 10px;
    border-radius: 6px;
    border: 1px solid #ddd;
}

/* Button */
.login-btn {
    width: 100%;
    background: #1877f2;
    color: white;
    border: none;
    padding: 12px;
    border-radius: 6px;
    font-size: 16px;
    cursor: pointer;
}

.login-btn:hover {
    background: #166fe5;
}

/* Create Account */
.create-btn {
    width: 100%;
    background: #42b72a;
    color: white;
    border: none;
    padding: 12px;
    border-radius: 6px;
    cursor: pointer;
}

/* Message */
.error-msg {
    color: red;
    margin-bottom: 10px;
}

.logout-msg {
    color: green;
    margin-bottom: 10px;
}
</style>
</head>

<body>

<div class="container">

    <!-- LEFT TEXT -->
    <div class="left">
        <h1>Y-Chat</h1>
        <p>Connect with friends and share your moments.</p>
    </div>

    <!-- LOGIN CARD -->
    <div class="card">

        <!-- Messages -->
        <c:if test="${not empty errorMsg}">
            <div class="error-msg">${errorMsg}</div>
        </c:if>

        <c:if test="${not empty logoutMsg}">
            <div class="logout-msg">${logoutMsg}</div>
        </c:if>

        <!-- FORM -->
        <form action="UsersLoginServlet" method="post">

            <input type="email" name="email" placeholder="登録済みemailアドレス" required>

            <input type="password" name="pass" placeholder="英数字で4～12文字" required>

            <button type="submit" class="login-btn">ログイン</button>

        </form>

        <hr>

        <!-- SIGNUP -->
        <form action="UsersRegistServlet">
            <button class="create-btn">新しいアカウントを作成</button>
        </form>

    </div>

</div>

</body>
</html>