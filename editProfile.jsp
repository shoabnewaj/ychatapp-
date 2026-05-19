<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile | Y-Chat</title>
    
    <!-- Google Fonts & FontAwesome -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    
    <style>
        :root {
            --glass-bg: rgba(255, 255, 255, 0.75);
            --glass-border: rgba(255, 255, 255, 0.4);
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --btn-gradient: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
        }
        
        body {
            margin: 0;
            background: linear-gradient(-45deg, #f3f4f7, #e2e8f0, #f8fafc, #f1f5f9);
            background-size: 400% 400%;
            animation: gradient 15s ease infinite;
            font-family: 'Outfit', sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        
        .edit-card {
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            padding: 40px;
            border-radius: 2rem;
            box-shadow: 0 20px 40px rgba(31, 38, 135, 0.08);
            width: 100%;
            max-width: 420px;
            box-sizing: border-box;
            animation: fadeIn 0.6s ease-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        h2 {
            text-align: center;
            color: #1e293b;
            font-weight: 800;
            font-size: 1.85rem;
            margin-top: 0;
            margin-bottom: 25px;
            letter-spacing: -0.5px;
        }
        
        .input-group {
            margin-bottom: 20px;
            position: relative;
        }
        
        label {
            font-weight: 700;
            font-size: 0.85rem;
            color: #475569;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: block;
            margin-bottom: 8px;
        }
        
        input {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid rgba(0, 0, 0, 0.08);
            border-radius: 1rem;
            box-sizing: border-box;
            background: rgba(255, 255, 255, 0.5);
            font-family: 'Outfit', sans-serif;
            font-size: 0.95rem;
            color: #334155;
            transition: all 0.3s ease;
            outline: none;
        }
        
        input:focus {
            border-color: #3b82f6;
            background: white;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.12);
        }
        
        .save-btn {
            background: var(--btn-gradient);
            color: white;
            border: none;
            padding: 15px;
            width: 100%;
            border-radius: 1rem;
            cursor: pointer;
            font-weight: 800;
            font-size: 1rem;
            letter-spacing: 0.5px;
            margin-top: 15px;
            box-shadow: 0 10px 20px rgba(37, 99, 235, 0.15);
            transition: all 0.3s ease;
        }
        
        .save-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 25px rgba(37, 99, 235, 0.25);
        }
        
        .save-btn:active {
            transform: translateY(0);
        }
        
        .cancel-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            text-decoration: none;
            color: #64748b;
            font-size: 0.9rem;
            font-weight: 600;
            transition: color 0.2s ease;
        }
        
        .cancel-link:hover {
            color: #0f172a;
        }
    </style>
</head>
<body>
    <div class="edit-card">
        <h2><i class="fa-solid fa-user-gear text-blue-600 mr-2"></i>Edit Profile</h2>
        
        <form action="EditProfileServlet" method="post">
            <div class="input-group">
                <label><i class="fa-regular fa-user mr-1.5"></i>Full Name</label>
                <input type="text" name="name" value="${ub.name}" required placeholder="Enter your full name">
            </div>

            <div class="input-group">
                <label><i class="fa-regular fa-envelope mr-1.5"></i>Email Address</label>
                <input type="email" name="email" value="${ub.email}" required placeholder="Enter email address">
            </div>
            
            <div class="input-group">
                <label><i class="fa-solid fa-key mr-1.5"></i>New Password</label>
                <input type="password" name="pass" placeholder="Leave blank to keep current password">
            </div>
            
            <button type="submit" class="save-btn"><i class="fa-regular fa-circle-check mr-2"></i>Save Changes</button>
        </form>
        
        <a href="UsersProfileServlet?userId=${ub.id}" class="cancel-link"><i class="fa-solid fa-arrow-left mr-1.5"></i>Cancel & Back</a>
    </div>
</body>
</html>