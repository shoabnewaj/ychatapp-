<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    <title>Login | Y-ChatApp</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap');
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: #f8fafc; }
        .glass-card { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.2); }
        .btn-gradient { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); transition: all 0.3s ease; }
        .btn-gradient:hover { transform: translateY(-2px); box-shadow: 0 10px 25px -5px rgba(37, 99, 235, 0.4); }
        .input-focus:focus { ring: 2px; ring-color: #3b82f6; border-color: #3b82f6; outline: none; }
    </style>
</head>

<body class="min-h-screen flex items-center justify-center p-4 bg-slate-50">
    
    <div class="max-w-6xl w-full grid lg:grid-cols-2 gap-12 items-center">
        
        <!-- Left Side: Branding -->
        <div class="hidden lg:block space-y-6">
            <div class="inline-flex items-center gap-2 text-blue-600 mb-2">
                <div class="bg-blue-600 p-1 rounded-xl">
                    <img src="<%=request.getContextPath()%>/icons/icon-192.png" alt="Logo" class="w-10 h-10 object-contain">
                </div>
                <span class="text-3xl font-bold tracking-tight text-slate-900">Y-ChatApp</span>
            </div>
            <h1 class="text-6xl font-extrabold text-slate-900 leading-[1.1]">
                Connect with the <br> 
                <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-indigo-600">World Around You.</span>
            </h1>
            <p class="text-xl text-slate-600 max-w-lg leading-relaxed">
                Experience the next generation of social interaction. Share, chat, and connect in a faster, more secure environment.
            </p>
            <div class="flex items-center gap-8 pt-6">
                <div class="flex -space-x-3">
                    <img class="w-12 h-12 rounded-full border-4 border-white shadow-sm" src="https://i.pravatar.cc/150?u=1" alt="">
                    <img class="w-12 h-12 rounded-full border-4 border-white shadow-sm" src="https://i.pravatar.cc/150?u=2" alt="">
                    <img class="w-12 h-12 rounded-full border-4 border-white shadow-sm" src="https://i.pravatar.cc/150?u=3" alt="">
                    <div class="w-12 h-12 rounded-full border-4 border-white bg-slate-100 flex items-center justify-center text-slate-500 font-bold text-xs shadow-sm">+10k</div>
                </div>
                <p class="text-slate-500 font-medium">Join 10,000+ active users today!</p>
            </div>
        </div>

        <!-- Right Side: Login Card -->
        <div class="w-full max-w-md mx-auto">
            <div class="glass-card p-10 rounded-[2.5rem] shadow-[0_20px_50px_rgba(0,0,0,0.05)] bg-white relative overflow-hidden">
                
                <div class="mb-8 text-center">
                    <h2 class="text-3xl font-bold text-slate-900 mb-2">Welcome Back</h2>
                    <p class="text-slate-500">Please enter your details to sign in</p>
                </div>

                <div id="errorBox" class="hidden mb-6 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 text-sm rounded-r-lg flex items-center gap-3">
                    <i class="fa fa-circle-exclamation text-lg"></i>
                    <span id="errorMessage"></span>
                </div>

                <c:if test="${not empty logoutMsg or not empty successMsg}">
                    <div class="mb-6 p-4 bg-green-50 border-l-4 border-green-500 text-green-700 text-sm rounded-r-lg flex items-center gap-3">
                        <i class="fa fa-circle-check text-lg"></i>
                        <span>${logoutMsg}${successMsg}</span>
                    </div>
                </c:if>

                <form id="loginForm" class="space-y-5">
                    <div class="space-y-1">
                        <label class="text-sm font-semibold text-slate-700 ml-1">Email Address</label>
                        <div class="relative group">
                            <i class="fa fa-envelope absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-blue-500 transition-colors"></i>
                            <input type="email" name="email" id="email" placeholder="name@company.com" required
                                class="w-full pl-11 pr-4 py-3.5 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 outline-none transition-all text-slate-700">
                        </div>
                    </div>

                    <div class="space-y-1">
                        <label class="text-sm font-semibold text-slate-700 ml-1">Password</label>
                        <div class="relative group">
                            <i class="fa fa-lock absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-blue-500 transition-colors"></i>
                            <input type="password" name="pass" id="pass" placeholder="••••••••" required
                                class="w-full pl-11 pr-4 py-3.5 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 outline-none transition-all text-slate-700">
                        </div>
                    </div>

                    <div class="flex items-center justify-between py-2">
                        <label class="flex items-center gap-2 cursor-pointer group">
                            <input type="checkbox" name="remember" class="w-5 h-5 rounded-lg border-slate-300 text-blue-600 focus:ring-blue-500 transition-all cursor-pointer">
                            <span class="text-sm text-slate-600 group-hover:text-slate-900 transition-colors">Remember me</span>
                        </label>
                        <a href="ForgotPasswordServlet" class="text-sm font-semibold text-blue-600 hover:text-blue-700">Forgot password?</a>
                    </div>

                    <button type="submit" id="submitBtn" class="w-full btn-gradient py-4 text-white font-bold rounded-2xl shadow-lg shadow-blue-500/30 flex items-center justify-center gap-3">
                        <span>Sign In</span>
                        <i class="fa fa-arrow-right text-sm"></i>
                    </button>
                </form>

                <div class="mt-8 flex items-center gap-4">
                    <div class="flex-1 h-px bg-slate-100"></div>
                    <span class="text-sm text-slate-400 font-medium italic">OR</span>
                    <div class="flex-1 h-px bg-slate-100"></div>
                </div>

                <div class="mt-8 text-center">
                    <p class="text-slate-600">Don't have an account? 
                        <a href="UsersRegistServlet" class="text-blue-600 font-bold hover:underline">Create an account</a>
                    </p>
                </div>

            </div>
        </div>
    </div>

    <!-- Loading Overlay -->
    <div id="loadingOverlay" class="hidden fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-[9999] flex flex-col items-center justify-center text-white">
        <div class="w-16 h-16 border-4 border-blue-500 border-t-transparent rounded-full animate-spin mb-4"></div>
        <p class="font-bold text-xl animate-pulse">Authenticating...</p>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const submitBtn = document.getElementById('submitBtn');
            const errorBox = document.getElementById('errorBox');
            const errorMessage = document.getElementById('errorMessage');
            const loadingOverlay = document.getElementById('loadingOverlay');
            
            errorBox.classList.add('hidden');
            loadingOverlay.classList.remove('hidden');
            
            const formData = new FormData(this);
            formData.append('ajax', 'true');
            
            const params = new URLSearchParams(formData);

            fetch('UsersLoginServlet', {
                method: 'POST',
                body: params,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    window.location.href = data.redirect;
                } else {
                    loadingOverlay.classList.add('hidden');
                    errorMessage.textContent = data.message;
                    errorBox.classList.remove('hidden');
                }
            })
            .catch(error => {
                loadingOverlay.classList.add('hidden');
                errorMessage.textContent = "An error occurred. Please try again.";
                errorBox.classList.remove('hidden');
            });
        });
    </script>

</body>
</html>