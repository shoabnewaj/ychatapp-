<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ユーザー登録 | Y-Chat</title>
    <style>
        body { margin: 0; font-family: Arial; background: #f0f2f5; display: flex; justify-content: center; align-items: center; height: 100vh; }
        .container { display: flex; gap: 80px; align-items: center; }
        .left h1 { color: #1877f2; font-size: 50px; }
        .card { background: white; padding: 25px; border-radius: 10px; width: 350px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        input { width: 100%; padding: 12px; margin-bottom: 8px; border-radius: 6px; border: 1px solid #ddd; box-sizing: border-box; }
        .signup-btn { width: 100%; background: #42b72a; color: white; border: none; padding: 12px; border-radius: 6px; font-size: 16px; cursor: pointer; }
        .error { color: red; font-size: 13px; margin-bottom: 5px; }
        .login-link { display: block; text-align: center; margin-top: 10px; color: #1877f2; text-decoration: none; }
    </style>
</head>
<body>

<div class="container">
    <div class="left">
        <h1>Y-Chat</h1>
        <p>Create your account and start sharing 🚀</p>
    </div>

    <div class="card">
        <form action="UsersRegistServlet" method="post" enctype="multipart/form-data">

            <input type="text" name="name" placeholder="Your Name" value="${usersBeans.name}" required>
            <div class="error">${errorMsg_name}</div>

            <input type="email" name="email" placeholder="Email address" value="${usersBeans.email}" required>

            <input type="password" name="pass" placeholder="半角英数字4〜12文字" required>
            <div class="error">${errorMsg_pass}</div>

            <label style="font-size: 12px; color: #666;">Profile Picture (Optional):</label>
            <input type="file" name="profile_pic" accept="image/*">

            <div class="error">${errorMsg}</div>

            <button type="submit" class="signup-btn">登録する</button>
        </form>

        <a href="UsersLoginServlet" class="login-link">← Back to Login</a>
    </div>
</div>

</body>
</html>