<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results | Y-ChatApp</title>
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <style>
        body {
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%;
            animation: gradient 15s ease infinite;
            font-family: 'Outfit', sans-serif;
            min-height: 100vh;
        }
        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.7) !important;
            backdrop-filter: blur(12px) !important;
            border: 1px solid rgba(255, 255, 255, 0.3) !important;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.15) !important;
        }
        .glass-nav {
            background: rgba(255, 255, 255, 0.8) !important;
            backdrop-filter: blur(10px) !important;
            border-bottom: 1px solid rgba(255, 255, 255, 0.3) !important;
        }
    </style>
</head>
<body>

    <nav class="glass-nav h-[56px] sticky top-0 z-[5000] flex items-center justify-between px-4">
        <div class="flex items-center gap-2 flex-1">
            <a href="UsersPostServlet" class="flex items-center gap-2 group">
                <div class="w-10 h-10 bg-gradient-to-tr from-blue-600 to-purple-600 rounded-xl flex items-center justify-center shadow-lg group-hover:rotate-12 transition-transform duration-300">
                    <img src="<%=request.getContextPath()%>/icons/icon-192.png" width="28" alt="Logo">
                </div>
                <span class="bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-purple-600 font-extrabold text-2xl tracking-tight hidden sm:inline">Y-ChatApp</span>
            </a>
            
            <form action="SearchServlet" method="get" class="bg-white/50 backdrop-blur-md px-4 py-2 rounded-full hidden md:flex items-center gap-2 ml-4 border border-white/30 transition-all duration-300">
                <i class="fa fa-search text-gray-400"></i>
                <input name="query" value="${searchQuery}" placeholder="Search Y-Chat" class="bg-transparent outline-none w-[200px] text-sm font-medium">
            </form>
        </div>

        <div class="flex items-center gap-3 flex-1 justify-end">
            <a href="UsersPostServlet" class="w-10 h-10 bg-gray-200 rounded-full flex items-center justify-center hover:bg-gray-300 transition">
                <i class="fa fa-house"></i>
            </a>
            <a href="UsersProfileServlet?userId=${sessionScope.userId}" class="flex items-center gap-2 p-1 hover:bg-gray-100 rounded-full transition">
                <img src="img/${ub.profile_pic}" class="w-9 h-9 rounded-full border">
                <span class="hidden sm:inline">${ub.name}</span>
            </a>
        </div>
    </nav>

    <div class="max-w-[800px] mx-auto mt-6 px-4">
        <h1 class="text-2xl font-bold mb-6">Search Results for "${searchQuery}"</h1>

        <!-- Tabs or Sections -->
        <div class="space-y-8">
            
            <!-- USERS SECTION -->
            <div>
                <h2 class="text-xl font-bold mb-4 text-gray-700 border-b pb-2">Users</h2>
                <div class="space-y-4">
                    <c:if test="${empty userResults}">
                        <p class="text-gray-500 italic">No users found matching your search.</p>
                    </c:if>
                    <c:forEach var="user" items="${userResults}">
                        <div class="glass-card p-4 rounded-2xl flex items-center justify-between hover:bg-white/80 transition-all group">
                            <div class="flex items-center gap-4">
                                <img src="img/${not empty user.profile_pic ? user.profile_pic : 'default.png'}" 
                                     class="w-14 h-14 rounded-2xl border-2 border-white object-cover shadow-md group-hover:scale-105 transition-transform">
                                <div>
                                    <a href="UsersProfileServlet?userId=${user.id}" class="font-bold text-lg hover:text-blue-600 transition-colors">${user.name}</a>
                                    <p class="text-gray-500 text-sm">${user.email}</p>
                                </div>
                            </div>
                            <a href="UsersProfileServlet?userId=${user.id}" class="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-6 py-2 rounded-xl font-bold hover:shadow-lg transition-all active:scale-95">
                                View
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- POSTS SECTION -->
            <div>
                <h2 class="text-xl font-bold mb-4 text-white drop-shadow-md">Posts</h2>
                <div class="space-y-4">
                    <c:if test="${empty postResults}">
                        <p class="text-white/80 italic">No posts found matching your search.</p>
                    </c:if>
                    <c:forEach var="post" items="${postResults}">
                        <div class="glass-card p-6 rounded-3xl hover:shadow-xl transition-all">
                            <div class="flex items-center gap-3 mb-4">
                                <img src="img/${not empty post.profile_pic ? post.profile_pic : 'default.png'}" class="w-11 h-11 rounded-xl border-2 border-white shadow-sm">
                                <div>
                                    <p class="font-bold text-gray-800">${post.name}</p>
                                    <p class="text-gray-500 text-xs">${post.time}</p>
                                </div>
                            </div>
                            <div class="text-gray-700 text-[16px] leading-relaxed mb-4 line-clamp-3">${post.content}</div>
                            <c:if test="${not empty post.file_name}">
                                <div class="rounded-2xl overflow-hidden border border-white/20 mb-4 shadow-inner">
                                    <img src="img/${post.file_name}" class="w-full h-48 object-cover">
                                </div>
                            </c:if>
                            <a href="UsersPostServlet" class="inline-flex items-center gap-2 text-blue-600 font-bold hover:gap-3 transition-all">
                                View in Feed <i class="fa fa-arrow-right text-xs"></i>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </div>

</body>
</html>
