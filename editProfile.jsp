<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile | Y-Chat</title>
    <link rel="stylesheet" href="css/test.css">
    <style>
        body { margin: 0; background-color: #f0f2f5; }
        .edit-card {
            background: white; padding: 30px; border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1); width: 100%; max-width: 400px;
        }
        input { width: 100%; padding: 12px; margin: 10px 0; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        label { font-weight: bold; font-size: 14px; color: #555; }
        .save-btn { background: #42b72a; color: white; border: none; padding: 12px; width: 100%; border-radius: 5px; cursor: pointer; font-weight: bold; margin-top: 10px; }
        .save-btn:hover { background: #36a420; }
    </style>
</head>
<body>
    <div class="main-content" style="display:flex; justify-content:center; align-items:center; height:100vh;">
        <div class="edit-card">
            <h2 style="text-align: center; color: #1877f2;">Edit Your Profile</h2>
            
            <form action="EditProfileServlet" method="post">
                <label>New Password</label>
                <!-- ভুল ১ ঠিক করা হয়েছে: pass="pass" এর বদলে name="pass" হবে -->
                <!-- ভুল ২ ঠিক করা হয়েছে: value="${ub.name}" এর বদলে খালি রাখা ভালো বা টাইপ password হবে -->
                <input type="password" name="pass" placeholder="Enter new password" required>
                
                <label>Email Address</label>
                <input type="email" name="email" value="${ub.email}" required>
                
                <button type="submit" class="save-btn">Save Changes</button>
            </form>
            
            <!-- ভুল ৩ ঠিক করা হয়েছে: href="profile" এর বদলে "UsersProfileServlet" হবে -->
            <a href="UsersProfileServlet" style="display:block; text-align:center; margin-top:15px; text-decoration:none; color:gray; font-size: 14px;">Cancel</a>
        </div>
    </div>
</body>
</html>