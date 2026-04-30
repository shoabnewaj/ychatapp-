<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    <title>登録完了 | Y-Chat</title>
    <link rel="stylesheet" href="css/test.css">
    <style>
        /* このページ専用のレイアウト調整 */
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f0f2f5;
            font-family: 'Helvetica Neue', Arial, sans-serif;
        }

        .success-container {
            background-color: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            text-align: center;
        }

        .welcome-icon {
            font-size: 100px;
            margin-bottom: 100px;
        }

        h1 {
            color: #1877f2;
            font-size: 24px;
            margin-bottom: 10px;
        }

        p {
            color: #606770;
            font-size: 16px;
            line-height: 1.6;
            margin-bottom: 30px;
        }

        .login-btn {
            display: inline-block;
            background-color: #1877f2;
            color: white;
            padding: 12px 30px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
            font-size: 16px;
            transition: background-color 0.2s;
        }

        .login-btn:hover {
            background-color: #166fe5;
        }
    </style>
</head>
<body>

    <div class="success-container">
        <!-- 歓迎のアイコン -->
        <div class="welcome-icon">🎉</div>

        <!-- メッセージ -->
        <h1>Welcome to Y-Chat!</h1>
        <p>
            ユーザー登録が正常に完了しました。<br>
            新しい仲間とのコミュニケーションを楽しみましょう！
        </p>

        <hr style="border: 0; border-top: 1px solid #dadde1; margin-bottom: 30px;">

        <!-- ログインへのボタン -->
        <a href="UsersLoginServlet" class="login-btn">ログインして始める</a>
    </div>

</body>
</html>