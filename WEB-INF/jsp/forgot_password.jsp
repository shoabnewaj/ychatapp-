<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Reset Password | Y-ChatApp</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap');
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: #f8fafc; }
        .glass-card { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.2); }
        .btn-gradient { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); transition: all 0.3s ease; }
        .btn-gradient:hover { transform: translateY(-2px); box-shadow: 0 10px 25px -5px rgba(37, 99, 235, 0.4); }
    </style>
</head>

<body class="min-h-screen flex items-center justify-center p-4 bg-slate-50">
    <div class="w-full max-w-md">
        <div class="glass-card p-10 rounded-[2.5rem] shadow-xl bg-white">
            <div class="mb-8 text-center">
                <h2 class="text-3xl font-bold text-slate-900 mb-2">Reset Password</h2>
                <p class="text-slate-500">Enter your email and new password</p>
            </div>

            <c:if test="${not empty errorMsg}">
                <div class="mb-6 p-4 bg-red-50 text-red-700 text-sm rounded-lg flex items-center gap-3">
                    <i class="fa fa-circle-exclamation"></i>
                    <span>${errorMsg}</span>
                </div>
            </c:if>

            <form action="ForgotPasswordServlet" method="post" class="space-y-5">
                <div class="space-y-1">
                    <label class="text-sm font-semibold text-slate-700">Email Address</label>
                    <div class="relative group">
                        <i class="fa fa-envelope absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-blue-500 transition-colors"></i>
                        <input type="email" name="email" placeholder="name@company.com" required
                            class="w-full pl-11 pr-4 py-3.5 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 outline-none transition-all text-slate-700">
                    </div>
                </div>

                <div class="space-y-1">
                    <label class="text-sm font-semibold text-slate-700">New Password</label>
                    <div class="relative group">
                        <i class="fa fa-lock absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-blue-500 transition-colors"></i>
                        <input type="password" name="newPass" placeholder="••••••••" required
                            class="w-full pl-11 pr-4 py-3.5 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 outline-none transition-all text-slate-700">
                    </div>
                </div>

                <div class="space-y-1">
                    <label class="text-sm font-semibold text-slate-700">Confirm New Password</label>
                    <div class="relative group">
                        <i class="fa fa-lock absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-blue-500 transition-colors"></i>
                        <input type="password" name="confirmPass" placeholder="••••••••" required
                            class="w-full pl-11 pr-4 py-3.5 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 outline-none transition-all text-slate-700">
                    </div>
                </div>

                <button type="submit" class="w-full btn-gradient py-4 text-white font-bold rounded-2xl shadow-lg flex items-center justify-center gap-3">
                    <span>Reset Password</span>
                    <i class="fa fa-key text-sm"></i>
                </button>
            </form>

            <div class="mt-8 text-center">
                <a href="UsersLoginServlet" class="text-blue-600 font-bold hover:underline">Back to Login</a>
            </div>
        </div>
    </div>
</body>
</html>
