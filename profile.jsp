<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${profileUser.name} | Profile</title>
<link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">

<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        :root {
            --glass-bg: rgba(255, 255, 255, 0.7);
            --glass-border: rgba(255, 255, 255, 0.3);
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        body {
            background: linear-gradient(-45deg, #f3f4f7, #e2e8f0, #f8fafc, #f1f5f9);
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
            background: var(--glass-bg);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid var(--glass-border);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
        }
        .react-container {
            position: relative;
            display: inline-block;
        }
        .react-box {
            display: none;
            position: absolute;
            bottom: 100%;
            left: 0;
            background: white;
            padding: 8px 15px;
            border-radius: 50px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            z-index: 100;
            gap: 12px;
            animation: popUp 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        .react-container:hover .react-box { display: flex; }
        @keyframes popUp {
            from { opacity: 0; transform: translateY(10px) scale(0.9); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }
        .custom-scrollbar::-webkit-scrollbar { width: 6px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(0,0,0,0.1); border-radius: 10px; }
    </style>
</head>
<body class="custom-scrollbar">

    <!-- Navbar (Same as main.jsp) -->
    <header class="sticky top-0 z-50 glass-card !border-none !rounded-none px-6 py-3 mb-6">
        <div class="max-w-[1400px] mx-auto flex items-center justify-between">
            <div class="flex items-center gap-4">
                <div class="w-10 h-10 bg-blue-600 rounded-xl flex items-center justify-center shadow-lg cursor-pointer hover:rotate-12 transition-transform" onclick="location.href='UsersPostServlet'">
                    <img src="${pageContext.request.contextPath}/icons/icon-192.png" width="25" alt="Logo">
                </div>
                <div class="relative hidden sm:block">
                    <form action="SearchServlet" method="get">
                        <i class="fa fa-search absolute left-4 top-1/2 -translate-y-1/2 text-gray-400"></i>
                        <input name="query" placeholder="Search Y-Chat..." class="bg-gray-100/50 border-none rounded-full py-2.5 pl-11 pr-6 w-[280px] focus:ring-2 ring-blue-500/20 transition-all outline-none font-medium">
                    </form>
                </div>
            </div>

            <nav class="flex items-center gap-8">
                <a href="UsersPostServlet" class="text-gray-500 hover:text-blue-600 transition-colors text-xl"><i class="fa fa-house"></i></a>
                <a href="FriendServlet" class="text-gray-500 hover:text-blue-600 transition-colors text-xl"><i class="fa fa-user-group"></i></a>
                <a href="#" class="text-gray-500 hover:text-blue-600 transition-colors text-xl"><i class="fa fa-video"></i></a>
                <a href="#" class="text-gray-500 hover:text-blue-600 transition-colors text-xl"><i class="fa fa-shop"></i></a>
            </nav>

            <div class="flex items-center gap-4">
                <div class="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center cursor-pointer hover:bg-gray-200 transition-colors"><i class="fa fa-bell"></i></div>
                <div class="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center cursor-pointer hover:bg-gray-200 transition-colors" onclick="location.href='UsersLogoutServlet'"><i class="fa fa-right-from-bracket"></i></div>
                <img src="img/${ub.profile_pic}" class="w-10 h-10 rounded-full border-2 border-blue-500 p-0.5 cursor-pointer hover:scale-105 transition-transform" onclick="location.href='UsersProfileServlet?userId=${ub.id}'">
            </div>
        </div>
    </header>

    <!-- Main Content Grid -->
    <div id="profile-content-wrapper" class="max-w-[1400px] mx-auto grid grid-cols-1 lg:grid-cols-[280px_1fr] gap-10 px-4 pb-10">
        
        <!-- LEFT SIDEBAR -->
        <aside class="hidden lg:block sticky top-[90px] h-fit space-y-4">
            <div class="glass-card p-4 rounded-[2rem] space-y-1 shadow-sm border-white/40">
                <a href="UsersPostServlet" class="flex items-center gap-4 p-3.5 rounded-2xl hover:bg-blue-50/50 hover:text-blue-600 transition-all group font-bold text-gray-600">
                    <div class="w-10 h-10 bg-blue-100/50 text-blue-600 rounded-xl flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white transition-all shadow-sm">
                        <i class="fa fa-house text-lg"></i>
                    </div>
                    <span>Home Feed</span>
                </a>
                
                <a href="UsersProfileServlet?userId=${ub.id}" class="flex items-center gap-4 p-3.5 rounded-2xl hover:bg-indigo-50/50 hover:text-indigo-600 transition-all group font-bold text-gray-600">
                    <div class="w-10 h-10 rounded-xl overflow-hidden border-2 border-transparent group-hover:border-indigo-600 transition-all shadow-sm">
                        <img src="img/${ub.profile_pic}" class="w-full h-full object-cover">
                    </div>
                    <span>My Profile</span>
                </a>

                <a href="FriendServlet" class="flex items-center gap-4 p-3.5 rounded-2xl hover:bg-purple-50/50 hover:text-purple-600 transition-all group font-bold text-gray-600">
                    <div class="w-10 h-10 bg-purple-100/50 text-purple-600 rounded-xl flex items-center justify-center group-hover:bg-purple-600 group-hover:text-white transition-all shadow-sm">
                        <i class="fa fa-user-group text-lg"></i>
                    </div>
                    <span>Friends List</span>
                </a>

                <a href="messages.jsp" class="flex items-center gap-4 p-3.5 rounded-2xl hover:bg-pink-50/50 hover:text-pink-600 transition-all group font-bold text-gray-600">
                    <div class="w-10 h-10 bg-pink-100/50 text-pink-600 rounded-xl flex items-center justify-center group-hover:bg-pink-600 group-hover:text-white transition-all shadow-sm">
                        <i class="fa fa-message text-lg"></i>
                    </div>
                    <span>Messenger</span>
                </a>

                <a href="#" class="flex items-center gap-4 p-3.5 rounded-2xl hover:bg-orange-50/50 hover:text-orange-600 transition-all group font-bold text-gray-600">
                    <div class="w-10 h-10 bg-orange-100/50 text-orange-600 rounded-xl flex items-center justify-center group-hover:bg-orange-600 group-hover:text-white transition-all shadow-sm">
                        <i class="fa fa-video text-lg"></i>
                    </div>
                    <span>Short Videos</span>
                </a>

                <div class="pt-4 mt-4 border-t border-gray-100/50">
                    <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest px-4 mb-2">Social Hub</p>
                    <a href="SearchServlet?query=" class="flex items-center gap-4 p-3.5 rounded-2xl bg-blue-600 text-white shadow-lg shadow-blue-200 hover:bg-blue-700 transition-all font-bold group">
                        <div class="w-8 h-8 bg-white/20 rounded-lg flex items-center justify-center">
                            <i class="fa fa-magnifying-glass text-sm"></i>
                        </div>
                        <span>Discover People</span>
                    </a>
                    <a href="#" class="flex items-center gap-4 p-3.5 rounded-2xl hover:bg-gray-100/50 transition-all font-bold text-gray-500 mt-2">
                        <i class="fa fa-calendar-star text-pink-500"></i> Events
                    </a>
                </div>
            </div>
        </aside>

        <!-- MIDDLE CONTENT -->
        <main class="space-y-6">
            
            <!-- COVER PHOTO -->
            <div class="relative w-full h-[450px] overflow-hidden group rounded-3xl shadow-2xl glass-card !p-0">
                <img src="${not empty profileUser.cover_pic ? 'img/' : ''}${not empty profileUser.cover_pic ? profileUser.cover_pic : 'https://images.unsplash.com/photo-1557683316-973673baf926?q=80&w=2000&auto=format&fit=crop'}"
                     class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
                     alt="Cover Image">
                <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent"></div>
                
                <c:if test="${profileUser.id == ub.id}">
                    <div class="absolute bottom-6 right-6">
                        <form action="UploadCoverServlet" method="post" enctype="multipart/form-data" id="coverForm">
                            <label for="coverInput" class="bg-white/20 hover:bg-white/40 backdrop-blur-xl text-white px-6 py-2.5 rounded-2xl font-bold shadow-2xl cursor-pointer flex items-center gap-3 transition-all active:scale-95 border border-white/30">
                                <i class="fa fa-camera text-xl"></i>
                                <span>Edit Cover Photo</span>
                            </label>
                            <input type="file" name="coverPic" id="coverInput" accept="image/*" hidden onchange="document.getElementById('coverForm').submit()">
                        </form>
                    </div>
                </c:if>
            </div>

            <!-- PROFILE HEADER -->
            <div class="glass-card p-8 rounded-3xl -mt-24 relative z-10 mx-6 shadow-2xl">
                <div class="flex flex-col md:flex-row items-end gap-6">
                    <div class="relative group -mt-20">
                        <img id="previewImg"
                             src="${not empty profileUser.profile_pic ? 'img/' : ''}${not empty profileUser.profile_pic ? profileUser.profile_pic : 'https://via.placeholder.com/200'}"
                             class="w-40 h-40 rounded-3xl object-cover border-8 border-white shadow-2xl transition-transform group-hover:scale-[1.02]">
                        
                        <c:if test="${profileUser.id == ub.id}">
                            <label for="profilePicInput" class="absolute bottom-2 right-2 w-9 h-9 bg-blue-600 text-white rounded-xl flex items-center justify-center shadow-lg cursor-pointer hover:bg-blue-700 hover:rotate-12 transition-all">
                                <i class="fa fa-camera text-sm"></i>
                            </label>
                            <form action="UploadProfileServlet" method="post" enctype="multipart/form-data" id="profilePicForm" class="hidden">
                                <input type="file" name="profilePic" id="profilePicInput" accept="image/*" onchange="document.getElementById('profilePicForm').submit()">
                            </form>
                        </c:if>
                    </div>

                    <div class="flex-1 pb-2">
                        <div class="flex items-center gap-3">
                            <h2 class="text-4xl font-black text-gray-800 tracking-tight">${profileUser.name}</h2>
                            <div class="w-6 h-6 bg-blue-500 text-white rounded-full flex items-center justify-center text-[10px] shadow-lg" title="Verified Account">
                                <i class="fa fa-check"></i>
                            </div>
                        </div>
                        <p class="text-gray-500 font-bold flex items-center gap-2 mt-1">
                            <span class="bg-blue-50 text-blue-600 px-3 py-1 rounded-lg text-sm">@${profileUser.name.toLowerCase().replace(' ', '')}</span>
                            <span class="w-1.5 h-1.5 bg-gray-300 rounded-full"></span>
                            <span class="text-sm">Software Engineer at Y-Tech</span>
                        </p>
                        
                        <div class="flex flex-wrap gap-3 mt-5">
                            <c:choose>
                                <c:when test="${profileUser.id == ub.id}">
                                    <button onclick="location.href='EditProfileServlet'" class="bg-gray-100 hover:bg-gray-200 text-gray-800 px-6 py-2.5 rounded-xl font-bold shadow-sm transition-all flex items-center gap-2">
                                        <i class="fa fa-pen-to-square"></i> Edit Profile
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${friendshipStatus == 'ACCEPTED'}">
                                            <button onclick="handleUserAction('${profileUser.id}', 'UNFRIEND', this)" class="bg-blue-50 text-blue-600 px-6 py-2.5 rounded-xl font-bold shadow-sm hover:bg-blue-100 transition-all">
                                                <i class="fa fa-user-check mr-2"></i> Friends
                                            </button>
                                        </c:when>
                                        <c:when test="${friendshipStatus == 'SENT'}">
                                            <button onclick="handleUserAction('${profileUser.id}', 'CANCEL', this)" class="bg-yellow-50 text-yellow-600 px-6 py-2.5 rounded-xl font-bold shadow-sm border border-yellow-200 hover:bg-yellow-100 transition-all">
                                                <i class="fa fa-user-clock mr-2"></i> Request Sent (Cancel)
                                            </button>
                                        </c:when>
                                        <c:when test="${friendshipStatus == 'INCOMING'}">
                                            <button onclick="handleUserAction('${profileUser.id}', 'ACCEPT', this)" class="bg-green-600 text-white px-6 py-2.5 rounded-xl font-bold shadow-lg hover:bg-green-700 transition-all active:scale-95">
                                                <i class="fa fa-user-plus mr-2"></i> Accept Request
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button onclick="handleUserAction('${profileUser.id}', 'ADD', this)" class="bg-blue-600 text-white px-6 py-2.5 rounded-xl font-bold shadow-lg hover:bg-blue-700 transition-all active:scale-95">
                                                <i class="fa fa-user-plus mr-2"></i> Add Friend
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <c:choose>
                                        <c:when test="${isFollowing}">
                                            <button onclick="handleUserAction('${profileUser.id}', 'UNFOLLOW', this)" class="bg-purple-50 text-purple-600 px-6 py-2.5 rounded-xl font-bold shadow-sm border border-purple-200 hover:bg-purple-100 transition-all">
                                                <i class="fa fa-user-minus mr-2"></i> Unfollow
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button onclick="handleUserAction('${profileUser.id}', 'FOLLOW', this)" class="bg-purple-600 text-white px-6 py-2.5 rounded-xl font-bold shadow-lg hover:bg-purple-700 transition-all active:scale-95">
                                                <i class="fa fa-user-plus mr-2"></i> Follow
                                            </button>
                                        </c:otherwise>
                                    </c:choose>

                                    <button onclick="location.href='messages.jsp?userId=${profileUser.id}'" class="bg-gray-100 text-gray-800 px-6 py-2.5 rounded-xl font-bold hover:bg-gray-200 transition-all">
                                        <i class="fa-brands fa-facebook-messenger mr-2 text-lg"></i> Message
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- STATS & TABS -->
                <div class="flex flex-col md:flex-row items-center justify-between gap-6 mt-8 pt-6 border-t border-gray-100">
                    <div class="flex gap-8">
                        <div class="text-center group cursor-pointer">
                            <b class="block text-2xl text-blue-600 group-hover:scale-110 transition-transform">${friendsCount}</b>
                            <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mt-1">Friends</p>
                        </div>
                        <div class="text-center group cursor-pointer">
                            <b class="block text-2xl text-purple-600 group-hover:scale-110 transition-transform">${followerCount}</b>
                            <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mt-1">Followers</p>
                        </div>
                        <div class="text-center group cursor-pointer">
                            <b class="block text-2xl text-pink-600 group-hover:scale-110 transition-transform">${followingCount}</b>
                            <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mt-1">Following</p>
                        </div>
                    </div>

                    <!-- Modern Tabs -->
                    <div class="flex bg-gray-100/50 p-1 rounded-2xl" id="profile-tabs">
                        <button onclick="switchTab('posts')" id="btn-tab-posts" class="tab-btn px-6 py-2 rounded-xl bg-white shadow-sm font-black text-blue-600 text-sm transition-all">Posts</button>
                        <button onclick="switchTab('about')" id="btn-tab-about" class="tab-btn px-6 py-2 rounded-xl hover:bg-white/50 font-bold text-gray-500 text-sm transition-all">About</button>
                        <button onclick="switchTab('friends')" id="btn-tab-friends" class="tab-btn px-6 py-2 rounded-xl hover:bg-white/50 font-bold text-gray-500 text-sm transition-all">Friends</button>
                        <button onclick="switchTab('photos')" id="btn-tab-photos" class="tab-btn px-6 py-2 rounded-xl hover:bg-white/50 font-bold text-gray-500 text-sm transition-all">Photos</button>
                    </div>
                </div>
            </div>

            <!-- TAB CONTENT: POSTS -->
            <div id="tab-content-posts" class="tab-content space-y-6">
                <!-- CREATE POST BOX (Only for own profile) -->
                <c:if test="${profileUser.id == ub.id}">
                <div class="glass-card p-5 rounded-3xl">
                    <div class="flex gap-4">
                        <div class="group relative"> 
                            <img src="img/${ub.profile_pic}" alt="${ub.name}" class="w-12 h-12 rounded-2xl object-cover ring-2 ring-white shadow-md">
                        </div>
                        <button onclick="openModal()"
                            class="flex-1 bg-white/40 hover:bg-white/60 backdrop-blur-md rounded-2xl text-left px-6 text-gray-600 text-[16px] font-medium transition-all border border-white/20">
                            What's on your mind, ${ub.name}?</button>
                    </div>
                    <div class="border-t border-white/20 mt-4 pt-3 flex justify-around">
                        <div onclick="openModal()" class="flex items-center gap-2 py-2 px-6 hover:bg-green-500/10 rounded-xl transition-all clickable text-green-500 font-semibold">
                            <i class="fa fa-image text-lg"></i> Photo
                        </div>
                        <div onclick="openModal()" class="flex items-center gap-2 py-2 px-6 hover:bg-yellow-500/10 rounded-xl transition-all clickable text-yellow-500 font-semibold">
                            <i class="fa fa-face-smile text-lg"></i> Feeling
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- POSTS SECTION -->
            <div class="space-y-6">
                <div class="flex items-center justify-between px-2">
                    <h3 class="text-xl font-black text-gray-800">Posts</h3>
                    <button class="text-blue-600 font-bold text-sm">Filters</button>
                </div>

                <div class="bg-gradient-to-r from-blue-600 to-indigo-700 text-white p-4 rounded-3xl text-center font-black mb-6 shadow-xl shadow-blue-100 flex items-center justify-center gap-3">
                    <i class="fa fa-database"></i>
                    <span>Database Results: ${userPosts.size()} Posts Found</span>
                </div>

                <c:if test="${empty userPosts}">
                    <div class="glass-card p-20 text-center rounded-3xl border-2 border-dashed border-gray-200">
                        <div class="w-20 h-20 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fa fa-feather-pointed text-3xl text-gray-300"></i>
                        </div>
                        <h4 class="text-xl font-black text-gray-400">No posts yet</h4>
                        <p class="text-gray-400 text-sm mt-2 font-medium">When ${profileUser.name} posts, they'll show up here.</p>
                    </div>
                </c:if>

                <c:forEach var="post" items="${userPosts}" varStatus="status">
                    <!-- Post Card #${status.count} -->
                    <div class="glass-card rounded-3xl p-6 hover:shadow-xl transition-all duration-300 mb-6">
                        <div class="flex justify-between items-start">
                            <div class="flex gap-4">
                                <img src="img/${post.profile_pic}" class="w-11 h-11 rounded-2xl object-cover border-2 border-white shadow-md">
                                <div>
                                    <p class="font-black text-gray-800 hover:text-blue-600 transition-colors cursor-pointer">${post.name}</p>
                                    <c:if test="${not empty post.feeling}">
                                        <span class="text-gray-400 text-[12px]"> is feeling <span class="font-bold text-gray-600">${post.feeling}</span></span>
                                    </c:if>
                                    <div class="text-[11px] text-gray-400 font-bold flex items-center gap-1.5 mt-0.5">
                                        <span>${post.time}</span> • <i class="fa fa-earth-americas"></i>
                                    </div>
                                </div>
                            </div>
                            <button class="p-2 hover:bg-gray-50 rounded-xl transition-colors"><i class="fa fa-ellipsis-h text-gray-400"></i></button>
                        </div>

                        <div class="mt-4 text-gray-700 leading-relaxed">${post.content}</div>

                        <c:if test="${not empty post.file_name}">
                            <div class="mt-4 rounded-3xl overflow-hidden border border-gray-100 shadow-sm bg-gray-50">
                                <c:choose>
                                    <c:when test="${post.post_type == 'video'}">
                                        <video controls class="w-full max-h-[500px] object-contain">
                                            <source src="img/${post.file_name}" type="video/mp4">
                                        </video>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="img/${post.file_name}" class="w-full h-auto max-h-[500px] object-cover hover:scale-[1.01] transition-transform duration-500">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>

                        <div class="flex items-center justify-between mt-6 pt-4 border-t border-gray-50">
                                <div id="post-react-container-${post.id}" class="flex items-center gap-2">
                                    <span class="font-bold text-gray-400 text-[13px]" id="post-react-count-${post.id}">
                                        <c:set var="tc" value="${post.likeCount + post.loveCount + post.careCount + post.hahaCount + post.wowCount + post.sadCount + post.angryCount + post.dislikes}"/>
                                        <c:choose>
                                            <c:when test="${tc > 0}">
                                                <c:if test="${post.likeCount > 0}">👍 <span class="text-gray-600">${post.likeCount}</span>&nbsp;&nbsp;</c:if>
                                                <c:if test="${post.loveCount > 0}">❤️ <span class="text-gray-600">${post.loveCount}</span>&nbsp;&nbsp;</c:if>
                                                <c:if test="${post.careCount > 0}">🥰 <span class="text-gray-600">${post.careCount}</span>&nbsp;&nbsp;</c:if>
                                                <c:if test="${post.hahaCount > 0}">😆 <span class="text-gray-600">${post.hahaCount}</span>&nbsp;&nbsp;</c:if>
                                                <c:if test="${post.wowCount > 0}">😮 <span class="text-gray-600">${post.wowCount}</span>&nbsp;&nbsp;</c:if>
                                                <c:if test="${post.sadCount > 0}">😢 <span class="text-gray-600">${post.sadCount}</span>&nbsp;&nbsp;</c:if>
                                                <c:if test="${post.angryCount > 0}">😡 <span class="text-gray-600">${post.angryCount}</span>&nbsp;&nbsp;</c:if>
                                                <c:if test="${post.dislikes > 0}">👎 <span class="text-gray-600">${post.dislikes}</span>&nbsp;&nbsp;</c:if>
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            <div class="flex gap-3 text-gray-400 text-[13px] font-bold">
                                <span id="post-comment-count-text-${post.id}" class="hover:text-blue-600 transition cursor-pointer" onclick="focusCmt('${post.id}')">${post.commentCount} Comments</span>
                                <span id="post-share-count-text-${post.id}" class="hover:text-purple-600 transition cursor-pointer" onclick="shareAJAX('${post.id}')">${post.shareCount} Shares</span>
                            </div>
                        </div>

                        <div class="flex gap-2 mt-4 pt-4 border-t border-gray-50">
                            <div id="post-action-btn-${post.id}" onclick="handleAJAXReact('${post.id}', 'Like', 'post', event)" class="flex-1 flex items-center justify-center gap-2 py-2.5 rounded-xl hover:bg-blue-50 text-gray-500 hover:text-blue-600 transition-all font-bold cursor-pointer react-container">
                                <span id="post-action-btn-content-${post.id}" class="flex items-center justify-center gap-2">
                                    <i class="fa-regular fa-thumbs-up"></i> Like
                                </span>
                                <div class="react-box !-top-12">
                                    <span class="hover:scale-150 transition" onclick="event.stopPropagation(); handleAJAXReact('${post.id}', 'Like', 'post', event)">👍</span>
                                    <span class="hover:scale-150 transition" onclick="event.stopPropagation(); handleAJAXReact('${post.id}', 'Love', 'post', event)">❤️</span>
                                    <span class="hover:scale-150 transition" onclick="event.stopPropagation(); handleAJAXReact('${post.id}', 'Care', 'post', event)">🥰</span>
                                    <span class="hover:scale-150 transition" onclick="event.stopPropagation(); handleAJAXReact('${post.id}', 'Haha', 'post', event)">😆</span>
                                    <span class="hover:scale-150 transition" onclick="event.stopPropagation(); handleAJAXReact('${post.id}', 'Wow', 'post', event)">😮</span>
                                    <span class="hover:scale-150 transition" onclick="event.stopPropagation(); handleAJAXReact('${post.id}', 'Sad', 'post', event)">😢</span>
                                    <span class="hover:scale-150 transition" onclick="event.stopPropagation(); handleAJAXReact('${post.id}', 'Angry', 'post', event)">😡</span>
                                    <span class="hover:scale-150 transition" onclick="event.stopPropagation(); handleAJAXReact('${post.id}', 'Dislike', 'post', event)">👎</span>
                                </div>
                            </div>
                            <div onclick="focusCmt('${post.id}')" class="flex-1 flex items-center justify-center gap-2 py-2.5 rounded-xl hover:bg-purple-50 text-gray-500 hover:text-purple-600 transition-all font-bold cursor-pointer">
                                <i class="fa-regular fa-comment"></i> Comment
                            </div>
                            <div onclick="shareAJAX('${post.id}')" class="flex-1 flex items-center justify-center gap-2 py-2.5 rounded-xl hover:bg-pink-50 text-gray-500 hover:text-pink-600 transition-all font-bold cursor-pointer">
                                <i class="fa-solid fa-share"></i> Share
                            </div>
                        </div>

                        <!-- Comment List (AJAX) -->
                        <div id="comment-list-${post.id}" class="mt-6 space-y-4">
                            <c:forEach var="comment" items="${post.comments}">
                                <div class="comment-level-1 mb-4">
                                    <div class="flex gap-2">
                                        <a href="UsersProfileServlet?userId=${comment.userId}">
                                            <img src="img/${comment.profilePic}" class="w-8 h-8 rounded-full border shadow-sm">
                                        </a>
                                        <div class="bg-gray-100 px-3 py-2 rounded-2xl max-w-[90%]">
                                            <p class="font-bold text-[12px]"><a href="UsersProfileServlet?userId=${comment.userId}" class="hover:underline">${comment.name}</a></p>
                                            <p class="text-[13px] text-gray-700">${comment.comment_text}</p>
                                        </div>
                                    </div>
                                    <div class="flex gap-4 ml-10 mt-1 text-[11px] font-bold text-gray-400 items-center">
                                        <div class="react-container clickable">
                                            <span class="hover:text-blue-600 cursor-pointer" onclick="handleAJAXReact('${comment.id}', 'Like', 'comment', event)">Like</span>
                                            <div class="react-box !-top-12 !p-1 !rounded-full">
                                                <span class="hover:scale-150 transition" onclick="handleAJAXReact('${comment.id}', 'Like', 'comment', event)">👍</span>
                                                <span class="hover:scale-150 transition" onclick="handleAJAXReact('${comment.id}', 'Love', 'comment', event)">❤️</span>
                                                <span class="hover:scale-150 transition" onclick="handleAJAXReact('${comment.id}', 'Care', 'comment', event)">🥰</span>
                                                <span class="hover:scale-150 transition" onclick="handleAJAXReact('${comment.id}', 'Haha', 'comment', event)">😆</span>
                                                <span class="hover:scale-150 transition" onclick="handleAJAXReact('${comment.id}', 'Wow', 'comment', event)">😮</span>
                                                <span class="hover:scale-150 transition" onclick="handleAJAXReact('${comment.id}', 'Sad', 'comment', event)">😢</span>
                                                <span class="hover:scale-150 transition" onclick="handleAJAXReact('${comment.id}', 'Angry', 'comment', event)">😡</span>
                                                <span class="hover:scale-150 transition" onclick="handleAJAXReact('${comment.id}', 'Dislike', 'comment', event)">👎</span>
                                            </div>
                                        </div>
                                        <span class="hover:text-blue-600 cursor-pointer" onclick="showReplyBox('${comment.id}', '${comment.name}')">Reply</span>
                                         <div id="comment-react-container-${comment.id}" class="text-[11px] font-normal text-gray-400">
                                             <c:set var="tc" value="${comment.likeCount + comment.loveCount + comment.careCount + comment.hahaCount + comment.wowCount + comment.sadCount + comment.angryCount + comment.dislikes}"/>
                                             <c:if test="${tc > 0}">
                                                 <c:if test="${comment.likeCount > 0}">👍 <span class="text-gray-600">${comment.likeCount}</span>&nbsp;&nbsp;</c:if>
                                                 <c:if test="${comment.loveCount > 0}">❤️ <span class="text-gray-600">${comment.loveCount}</span>&nbsp;&nbsp;</c:if>
                                                 <c:if test="${comment.careCount > 0}">🥰 <span class="text-gray-600">${comment.careCount}</span>&nbsp;&nbsp;</c:if>
                                                 <c:if test="${comment.hahaCount > 0}">😆 <span class="text-gray-600">${comment.hahaCount}</span>&nbsp;&nbsp;</c:if>
                                                 <c:if test="${comment.wowCount > 0}">😮 <span class="text-gray-600">${comment.wowCount}</span>&nbsp;&nbsp;</c:if>
                                                 <c:if test="${comment.sadCount > 0}">😢 <span class="text-gray-600">${comment.sadCount}</span>&nbsp;&nbsp;</c:if>
                                                 <c:if test="${comment.angryCount > 0}">😡 <span class="text-gray-600">${comment.angryCount}</span>&nbsp;&nbsp;</c:if>
                                                 <c:if test="${comment.dislikes > 0}">👎 <span class="text-gray-600">${comment.dislikes}</span>&nbsp;&nbsp;</c:if>
                                             </c:if>
                                         </div>
                                    <div id="reply-list-${comment.id}" class="mt-2 space-y-2 ml-10">
                                        <c:forEach var="reply" items="${comment.replies}">
                                            <div class="comment-level-2 mb-2">
                                                <div class="flex gap-2">
                                                    <a href="UsersProfileServlet?userId=${reply.userId}">
                                                        <img src="img/${reply.profilePic}" class="w-7 h-7 rounded-full border shadow-sm">
                                                    </a>
                                                    <div class="bg-gray-100 px-3 py-1.5 rounded-2xl">
                                                        <p class="font-bold text-[11px]"><a href="UsersProfileServlet?userId=${reply.userId}" class="hover:underline">${reply.name}</a></p>
                                                        <p class="text-[12px] text-gray-700">${reply.text}</p>
                                                        <c:if test="${not empty reply.media}">
                                                            <img src="img/${reply.media}" class="w-full h-auto rounded-lg mt-2 border">
                                                        </c:if>
                                                    </div>
                                                </div>
                                                <div class="flex gap-4 ml-9 mt-1 text-[10px] font-bold text-gray-400 items-center">
                                                    <div class="react-container clickable">
                                                        <span class="hover:text-blue-600 cursor-pointer" onclick="handleAJAXReact('${reply.id}', 'Like', 'reply', event)">Like</span>
                                                        <div class="react-box !-top-12 !p-1 !rounded-full">
                                                            <span class="hover:scale-150 transition" onclick="handleAJAXReact('${reply.id}', 'Like', 'reply', event)">👍</span>
                                                            <span class="hover:scale-150 transition" onclick="handleAJAXReact('${reply.id}', 'Love', 'reply', event)">❤️</span>
                                                            <span class="hover:scale-150 transition" onclick="handleAJAXReact('${reply.id}', 'Care', 'reply', event)">🥰</span>
                                                            <span class="hover:scale-150 transition" onclick="handleAJAXReact('${reply.id}', 'Haha', 'reply', event)">😆</span>
                                                            <span class="hover:scale-150 transition" onclick="handleAJAXReact('${reply.id}', 'Wow', 'reply', event)">😮</span>
                                                            <span class="hover:scale-150 transition" onclick="handleAJAXReact('${reply.id}', 'Sad', 'reply', event)">😢</span>
                                                            <span class="hover:scale-150 transition" onclick="handleAJAXReact('${reply.id}', 'Angry', 'reply', event)">😡</span>
                                                            <span class="hover:scale-150 transition" onclick="handleAJAXReact('${reply.id}', 'Dislike', 'reply', event)">👎</span>
                                                        </div>
                                                    </div>
                                                     <div id="reply-react-container-${reply.id}" class="text-[10px] font-normal text-gray-400">
                                                         <c:set var="rtc" value="${reply.likeCount + reply.loveCount + reply.careCount + reply.hahaCount + reply.wowCount + reply.sadCount + reply.angryCount + reply.dislikes}"/>
                                                         <c:if test="${rtc > 0}">
                                                             <c:if test="${reply.likeCount > 0}">👍 <span class="text-gray-600">${reply.likeCount}</span>&nbsp;&nbsp;</c:if>
                                                             <c:if test="${reply.loveCount > 0}">❤️ <span class="text-gray-600">${reply.loveCount}</span>&nbsp;&nbsp;</c:if>
                                                             <c:if test="${reply.careCount > 0}">🥰 <span class="text-gray-600">${reply.careCount}</span>&nbsp;&nbsp;</c:if>
                                                             <c:if test="${reply.hahaCount > 0}">😆 <span class="text-gray-600">${reply.hahaCount}</span>&nbsp;&nbsp;</c:if>
                                                             <c:if test="${reply.wowCount > 0}">😮 <span class="text-gray-600">${reply.wowCount}</span>&nbsp;&nbsp;</c:if>
                                                             <c:if test="${reply.sadCount > 0}">😢 <span class="text-gray-600">${reply.sadCount}</span>&nbsp;&nbsp;</c:if>
                                                             <c:if test="${reply.angryCount > 0}">😡 <span class="text-gray-600">${reply.angryCount}</span>&nbsp;&nbsp;</c:if>
                                                             <c:if test="${reply.dislikes > 0}">👎 <span class="text-gray-600">${reply.dislikes}</span>&nbsp;&nbsp;</c:if>
                                                         </c:if>
                                                     </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <!-- Reply Input Box -->
                                    <div id="replyInputContainer-${comment.id}" class="hidden mt-2 ml-10 relative">
                                        <div class="flex gap-2">
                                            <img src="img/${ub.profile_pic}" class="w-7 h-7 rounded-full border" width="28px">
                                            <div class="flex-1 bg-[#f0f2f5] rounded-2xl px-3 py-1.5 flex items-center">
                                                <input type="text" id="input-reply-${comment.id}" placeholder="Write a reply..." class="bg-transparent outline-none flex-1 text-[12px]"
                                                    onkeydown="if(event.key === 'Enter') submitReplyAJAX('${comment.id}')">
                                                <i class="fa-regular fa-face-smile text-yellow-500 cursor-pointer mx-2" onclick="toggleEmojiPicker('emoji-picker-reply-${comment.id}')"></i>
                                                <label for="replyMedia-${comment.id}" class="cursor-pointer mx-2 text-gray-500 hover:text-blue-600 transition">
                                                    <i class="fa-solid fa-camera"></i>
                                                </label>
                                                <input type="file" id="replyMedia-${comment.id}" class="hidden" accept="image/*,video/*" onchange="previewReplyMedia('${comment.id}')">
                                                <button onclick="submitReplyAJAX('${comment.id}')" class="text-blue-600"><i class="fa fa-paper-plane text-xs"></i></button>
                                            </div>
                                        </div>
                                        <div id="replyPreview-${comment.id}" class="hidden ml-9 mt-2 relative inline-block">
                                            <img id="replyImgPreview-${comment.id}" src="" class="h-16 rounded-lg shadow-md border">
                                            <button onclick="removeReplyMedia('${comment.id}')" class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs shadow-md">×</button>
                                        </div>
                                        <div id="emoji-picker-reply-${comment.id}" class="hidden absolute bottom-10 left-10 bg-white border rounded-xl p-2 shadow-xl z-[5000] w-40">
                                            <div class="grid grid-cols-4 gap-2 text-lg">
                                                <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-${comment.id}', '😀')">😀</span>
                                                <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-${comment.id}', '😂')">😂</span>
                                                <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-${comment.id}', '❤️')">❤️</span>
                                                <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-${comment.id}', '👍')">👍</span>
                                                <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-${comment.id}', '🥰')">🥰</span>
                                                <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-${comment.id}', '😮')">😮</span>
                                                <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-${comment.id}', '😢')">😢</span>
                                                <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-${comment.id}', '😡')">😡</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>


                    <div class="flex gap-2 mt-4 relative">
                        <img src="img/${ub.profile_pic}" class="w-8 h-8 rounded-full border" width="30px">
                        <div class="flex-1 bg-[#f0f2f5] rounded-2xl px-3 py-2 flex items-center">
                            <input type="text" id="input-post-${post.id}" placeholder="Write a comment..." class="bg-transparent outline-none flex-1 text-[14px]"
                                onkeydown="if(event.key === 'Enter') submitCommentAJAX('${post.id}')">
                            <i class="fa-regular fa-face-smile text-yellow-500 cursor-pointer mx-2" onclick="toggleEmojiPicker('emoji-picker-post-${post.id}')"></i>
                            <button onclick="submitCommentAJAX('${post.id}')" class="text-blue-600"><i class="fa fa-paper-plane"></i></button>
                        </div>
                        <div id="emoji-picker-post-${post.id}" class="hidden absolute bottom-12 right-0 bg-white border rounded-xl p-2 shadow-xl z-[5000] w-40">
                            <div class="grid grid-cols-4 gap-2 text-xl">
                                <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-post-${post.id}', '😀')">😀</span>
                                <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-post-${post.id}', '😂')">😂</span>
                                <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-post-${post.id}', '❤️')">❤️</span>
                                <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-post-${post.id}', '👍')">👍</span>
                                <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-post-${post.id}', '🥰')">🥰</span>
                                <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-post-${post.id}', '😮')">😮</span>
                                <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-post-${post.id}', '😢')">😢</span>
                                <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-post-${post.id}', '😡')">😡</span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        </div> <!-- Close tab-content-posts -->

        <!-- TAB CONTENT: ABOUT -->
        <div id="tab-content-about" class="tab-content hidden space-y-6">
            <div class="glass-card p-8 rounded-3xl space-y-6">
                <h3 class="text-2xl font-black text-gray-800 flex items-center gap-3">
                    <i class="fa fa-circle-info text-blue-600"></i> About ${profileUser.name}
                </h3>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Contact Info -->
                    <div class="bg-white/40 p-6 rounded-2xl border border-white/30 space-y-4">
                        <h4 class="font-bold text-gray-700 uppercase tracking-widest text-xs">Contact & Basic Info</h4>
                        <div class="space-y-3 font-medium">
                            <div class="flex items-center gap-3 text-gray-600">
                                <i class="fa fa-envelope text-gray-400 w-5"></i>
                                <span>${profileUser.email}</span>
                            </div>
                            <div class="flex items-center gap-3 text-gray-600">
                                <i class="fa fa-user-tag text-gray-400 w-5"></i>
                                <span>@${profileUser.name.toLowerCase().replace(' ', '')}</span>
                            </div>
                            <div class="flex items-center gap-3 text-gray-600">
                                <i class="fa fa-briefcase text-gray-400 w-5"></i>
                                <span>Software Engineer at Y-Tech</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Biography/Bio -->
                    <div class="bg-white/40 p-6 rounded-2xl border border-white/30 space-y-4">
                        <h4 class="font-bold text-gray-700 uppercase tracking-widest text-xs">Biography</h4>
                        <p class="text-gray-600 font-medium leading-relaxed">
                            ${not empty profileUser.bio ? profileUser.bio : 'No bio available yet. Standard software engineer interested in building modern web systems, pair programming, and exploring new tech fields.'}
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- TAB CONTENT: FRIENDS -->
        <div id="tab-content-friends" class="tab-content hidden space-y-6">
            <div class="glass-card p-8 rounded-3xl">
                <div class="flex items-center justify-between mb-6">
                    <h3 class="text-2xl font-black text-gray-800 flex items-center gap-3">
                        <i class="fa fa-user-group text-purple-600"></i> Friends List
                    </h3>
                    <span class="bg-purple-100 text-purple-600 px-3.5 py-1 rounded-full text-sm font-black">${friendsCount} Friends</span>
                </div>
                
                <c:choose>
                    <c:when test="${empty friendsList}">
                        <div class="text-center py-12">
                            <div class="w-16 h-16 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fa fa-user-group text-2xl text-gray-300"></i>
                            </div>
                            <h4 class="text-lg font-black text-gray-400">No friends yet</h4>
                            <p class="text-gray-400 text-sm mt-1">When they accept or add friends, they'll show up here.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
                            <c:forEach var="friend" items="${friendsList}">
                                <div class="bg-white/40 p-4 rounded-2xl border border-white/30 flex items-center gap-4 hover:shadow-lg transition-all group cursor-pointer" onclick="location.href='UsersProfileServlet?userId=${friend.id}'">
                                    <img src="${not empty friend.profile_pic ? 'img/' : ''}${not empty friend.profile_pic ? friend.profile_pic : 'https://via.placeholder.com/150'}" 
                                         class="w-16 h-16 rounded-xl object-cover border border-white/50 shadow-md group-hover:scale-105 transition-transform">
                                    <div class="overflow-hidden">
                                        <h4 class="font-black text-gray-800 group-hover:text-blue-600 transition-colors truncate">${friend.name}</h4>
                                        <p class="text-xs text-gray-400 truncate">@${friend.name.toLowerCase().replace(' ', '')}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- TAB CONTENT: PHOTOS -->
        <div id="tab-content-photos" class="tab-content hidden space-y-6">
            <div class="glass-card p-8 rounded-3xl">
                <h3 class="text-2xl font-black text-gray-800 flex items-center gap-3 mb-6">
                    <i class="fa fa-image text-pink-600"></i> Photos & Videos
                </h3>
                
                <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
                    <c:set var="hasPhotos" value="false"/>
                    <c:forEach var="post" items="${userPosts}">
                        <c:if test="${not empty post.file_name}">
                            <c:set var="hasPhotos" value="true"/>
                            <div class="relative group aspect-square rounded-2xl overflow-hidden border border-white/30 shadow-md bg-gray-50 cursor-pointer hover:shadow-lg transition-all">
                                <c:choose>
                                    <c:when test="${post.post_type == 'video'}">
                                        <video class="w-full h-full object-cover">
                                            <source src="img/${post.file_name}" type="video/mp4">
                                        </video>
                                        <div class="absolute inset-0 bg-black/30 flex items-center justify-center text-white opacity-90 group-hover:bg-black/45 transition-colors">
                                            <i class="fa fa-play text-2xl"></i>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="img/${post.file_name}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                                        <div class="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>
                    </c:forEach>
                    
                    <c:if test="${!hasPhotos}">
                        <div class="col-span-full text-center py-12">
                            <div class="w-16 h-16 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fa fa-images text-2xl text-gray-300"></i>
                            </div>
                            <h4 class="text-lg font-black text-gray-400">No photos yet</h4>
                            <p class="text-gray-400 text-sm mt-1">Photos and videos uploaded in posts will appear here.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

    </div>

    <!-- Create Post Modal -->
    <div id="postModal" class="fixed inset-0 bg-white/80 backdrop-blur-sm z-[9999] hidden items-center justify-center p-4">
        <div class="bg-white w-full max-w-[550px] rounded-3xl shadow-2xl overflow-hidden transform transition-all border border-gray-100">
            <div class="flex items-center justify-between p-6 border-b">
                <h2 class="text-xl font-black text-gray-800">Create Post</h2>
                <button onclick="closeModal()" class="w-10 h-10 rounded-2xl bg-gray-50 hover:bg-red-50 text-gray-400 hover:text-red-500 transition-all flex items-center justify-center">
                    <i class="fa fa-xmark text-xl"></i>
                </button>
            </div>
            
            <form id="postForm" action="UsersPostServlet" method="post" enctype="multipart/form-data" class="p-6 space-y-6">
                <div class="flex items-center gap-4">
                    <img src="img/${ub.profile_pic}" class="w-12 h-12 rounded-2xl border-2 border-white shadow-md">
                    <div>
                        <p class="font-black text-gray-800">${ub.name}</p>
                        <select name="feeling" class="text-[11px] font-black text-blue-600 bg-blue-50 px-2 py-1 rounded-lg outline-none cursor-pointer">
                            <option value="">Feeling?</option>
                            <option value="Happy">😊 Happy</option>
                            <option value="Loved">😍 Loved</option>
                            <option value="Haha">😆 Haha</option>
                            <option value="Wow">😮 Wow</option>
                            <option value="Sad">😢 Sad</option>
                            <option value="Angry">😡 Angry</option>
                        </select>
                    </div>
                </div>

                <textarea name="content" placeholder="Share something with your friends..." 
                          class="w-full h-40 text-xl font-medium outline-none resize-none placeholder-gray-300 text-gray-700"></textarea>

                <div id="previewContainer" class="hidden relative rounded-2xl overflow-hidden border border-gray-100">
                    <button type="button" onclick="removePreview()" class="absolute top-3 right-3 bg-black/50 text-white w-8 h-8 rounded-xl flex items-center justify-center z-10 hover:bg-red-500 transition-colors">×</button>
                    <img id="imagePreview" src="#" class="w-full h-auto max-h-[300px] object-cover">
                </div>

                <div class="p-4 border-2 border-dashed border-gray-100 rounded-2xl flex items-center justify-between">
                    <span class="text-gray-400 font-bold text-sm ml-2">Add to your post</span>
                    <label for="modalFileInput" class="w-11 h-11 bg-green-50 text-green-500 rounded-xl flex items-center justify-center cursor-pointer hover:bg-green-500 hover:text-white transition-all shadow-sm">
                        <i class="fa fa-image text-xl"></i>
                    </label>
                    <input type="file" name="media" id="modalFileInput" class="hidden" accept="image/*,video/*" onchange="previewImage(this)">
                </div>

                <button type="submit" class="w-full bg-blue-600 text-white font-black py-4 rounded-2xl shadow-lg shadow-blue-200 hover:bg-blue-700 active:scale-95 transition-all">
                    Post to Timeline
                </button>
            </form>
        </div>
    </div>

    <!-- JS -->
    <script>
        var contextPath = "${pageContext.request.contextPath}";
        // Tab Switching Logic
        function switchTab(tabName) {
            // Hide all tab content
            document.querySelectorAll('.tab-content').forEach(el => {
                el.classList.add('hidden');
            });
            
            // Show target tab content
            const targetTab = document.getElementById('tab-content-' + tabName);
            if (targetTab) {
                targetTab.classList.remove('hidden');
            }
            
            // Update tab buttons style
            document.querySelectorAll('.tab-btn').forEach(btn => {
                btn.className = 'tab-btn px-6 py-2 rounded-xl hover:bg-white/50 font-bold text-gray-500 text-sm transition-all';
            });
            
            // Highlight active tab button
            const activeBtn = document.getElementById('btn-tab-' + tabName);
            if (activeBtn) {
                activeBtn.className = 'tab-btn px-6 py-2 rounded-xl bg-white shadow-sm font-black text-blue-600 text-sm transition-all';
            }
        }

        function openModal() {
            document.getElementById('postModal').classList.remove('hidden');
            document.getElementById('postModal').classList.add('flex');
            document.body.style.overflow = 'hidden';
        }
        function closeModal() {
            document.getElementById('postModal').classList.add('hidden');
            document.getElementById('postModal').classList.remove('flex');
            document.body.style.overflow = 'auto';
        }
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            const container = document.getElementById('previewContainer');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    container.classList.remove('hidden');
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
        function removePreview() {
            document.getElementById('modalFileInput').value = '';
            document.getElementById('previewContainer').classList.add('hidden');
        }


    function handleAJAXReact(id, type, level, event) {
        if (event) event.stopPropagation();
        let targetUrl = (level === 'post') ? ('${pageContext.request.contextPath}/InteractionServlet') : ('${pageContext.request.contextPath}/CommentServlet');
        // FormData ব্যবহার করতে হবে কারণ উভয় Servlet-এ @MultipartConfig আছে
        let formData = new FormData();
        if (level === 'post') {
            formData.append('id', id);
            formData.append('action', type);
        } else {
            formData.append('commentId', id);
            formData.append('action', type);
            formData.append('level', level);
        }

        let emojiMap = {
            'Like': '👍', 'Love': '❤️', 'Care': '🥰', 'Haha': '😆', 
            'Wow': '😮', 'Sad': '😢', 'Angry': '😡', 'Dislike': '👎', 'Dislikes': '👎'
        };
        let colorMap = {
            'Like': 'text-blue-600', 'Love': 'text-red-500', 'Care': 'text-yellow-500', 
            'Haha': 'text-yellow-500', 'Wow': 'text-yellow-500', 'Sad': 'text-yellow-500', 
            'Angry': 'text-red-600', 'Dislike': 'text-gray-800', 'Dislikes': 'text-gray-800'
        };
        let activeEmoji = emojiMap[type] || '👍';
        let activeColor = colorMap[type] || 'text-blue-600';

        fetch(targetUrl, { 
            method: 'POST', 
            body: formData  // Content-Type header সেট করা উচিত নয়, browser নিজে multipart boundary দেবে
        })
        .then(res => {
            const contentType = res.headers.get('content-type');
            if (contentType && contentType.includes('application/json')) {
                return res.json();
            }
            return res.text().then(txt => { throw new Error('Non-JSON: ' + txt.substring(0, 200)); });
        })
        .then(data => {
            if (data.status === 'ok' || data.success) {
                // Build granular count string
                let countsHtml = '';
                if (data.counts) {
                    for (let key in data.counts) {
                        if (data.counts[key] > 0) {
                            let mappedKey = key === 'Dislikes' ? 'Dislike' : key;
                            countsHtml += `\${emojiMap[mappedKey]} <span class="text-gray-600">\${data.counts[key]}</span>&nbsp;&nbsp;`;
                        }
                    }
                    countsHtml = countsHtml.trim();
                } else {
                    countsHtml = `\${activeEmoji} <span class="text-blue-500">\${data.newCount}</span>`;
                }

                if (level === 'post') {
                    let countSpan = document.getElementById(`post-react-count-\${id}`);
                    if (countSpan) {
                        if (data.newCount > 0) {
                            countSpan.innerHTML = countsHtml;
                        } else {
                            countSpan.innerText = '0';
                        }
                    }
                    // পোস্ট বাটনে visual feedback
                    let actionBtnContent = document.getElementById(`post-action-btn-content-\${id}`);
                    if (actionBtnContent && data.newCount > 0) {
                        actionBtnContent.innerHTML = `\${activeEmoji} <span class="\${activeColor}">\${type}</span>`;
                    } else if (actionBtnContent) {
                        actionBtnContent.innerHTML = `<i class="fa-regular fa-thumbs-up"></i> Like`;
                    }
                } else {
                    let containerId = level === 'comment' ? `comment-react-container-\${id}` : `reply-react-container-\${id}`;
                    let container = document.getElementById(containerId);
                    if (container) {
                        if (data.newCount > 0) {
                            container.innerHTML = countsHtml;
                        } else {
                            container.innerHTML = '';
                        }
                    }
                }
            } else {
                console.warn('Reaction response:', data);
            }
        })
        .catch(err => console.error("React error", err));
    }


    // ২. কমেন্ট সাবমিট
    function submitCommentAJAX(postId) {
        let input = document.getElementById('input-post-' + postId);
        let fileInput = document.getElementById('commentMedia-' + postId);
        if (!input || !input.value.trim()) return;

        let formData = new FormData();
        formData.append("postId", postId);
        formData.append("comment_text", input.value);
        formData.append("action", "ADD_COMMENT");
        if (fileInput && fileInput.files[0]) {
            formData.append("media", fileInput.files[0]);
        }

        fetch('CommentServlet', { method: 'POST', body: formData })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                let countText = document.getElementById(`post-comment-count-text-\${postId}`);
                if (countText) {
                    let currentCount = parseInt(countText.innerText) || 0;
                    countText.innerText = `\${currentCount + 1} Comments`;
                }
                
                let list = document.getElementById(`comment-list-\${postId}`);
                if (list) {
                    let escapedName = data.userName.replace(/'/g, "\\'");
                    let html = `
                        <div class="comment-level-1">
                            <div class="flex gap-2">
                                <a href="UsersProfileServlet?userId=\${data.userId}">
                                    <img src="img/\${data.userPic}" class="w-8 h-8 rounded-full border clickable" width="30px">
                                </a>
                                <div class="bg-[#f0f2f5] px-3 py-2 rounded-2xl max-w-[90%]">
                                    <p class="font-bold text-[13px]"><a href="UsersProfileServlet?userId=\${data.userId}" class="clickable hover:underline">\${data.userName}</a></p>
                                    <p class="text-[14px]">\${data.text}</p>
                                    \${data.fileName ? '<img src="img/' + data.fileName + '" class="w-full h-auto rounded-lg mt-2 border">' : ''}
                                </div>
                            </div>
                            <div class="flex gap-4 ml-10 mt-1 text-[12px] font-bold text-gray-500 items-center">
                                <div class="react-container clickable">
                                    <span class="hover:text-blue-600 transition" onclick="handleAJAXReact(\${data.commentId}, 'Like', 'comment', event)">Like</span>
                                    <div class="react-box !-top-12 !p-1 !rounded-full">
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.commentId}, 'Like', 'comment', event)">👍</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.commentId}, 'Love', 'comment', event)">❤️</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.commentId}, 'Care', 'comment', event)">🥰</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.commentId}, 'Haha', 'comment', event)">😆</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.commentId}, 'Wow', 'comment', event)">😮</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.commentId}, 'Sad', 'comment', event)">😢</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.commentId}, 'Angry', 'comment', event)">😡</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.commentId}, 'Dislike', 'comment', event)">👎</span>
                                    </div>
                                </div>
                                <span class="clickable hover:text-blue-600 transition" onclick="showReplyBox(\${data.commentId}, '\${escapedName}')">Reply</span>
                                <div class="text-[11px] font-normal text-gray-400" id="comment-react-container-\${data.commentId}"></div>
                            </div>
                            <div id="reply-list-\${data.commentId}" class="mt-2 space-y-2 ml-10"></div>
                            <div id="replyInputContainer-\${data.commentId}" class="hidden mt-2 ml-10 relative">
                                <div class="flex gap-2">
                                    <img src="img/\${data.userPic}" class="w-7 h-7 rounded-full border shadow-sm" width="28px">
                                    <div class="flex-1 bg-[#f0f2f5] rounded-2xl px-3 py-1.5 flex items-center">
                                        <input type="text" id="input-reply-\${data.commentId}" placeholder="Write a reply..." class="bg-transparent outline-none flex-1 text-[12px]"
                                            onkeydown="if(event.key === 'Enter') submitReplyAJAX('\${data.commentId}')">
                                        <i class="fa-regular fa-face-smile text-yellow-500 cursor-pointer mx-2" onclick="toggleEmojiPicker('emoji-picker-reply-\\${data.commentId}')"></i>
                                        <label for="replyMedia-\${data.commentId}" class="cursor-pointer mx-2 text-gray-500 hover:text-blue-600 transition">
                                            <i class="fa-solid fa-camera"></i>
                                        </label>
                                        <input type="file" id="replyMedia-\${data.commentId}" class="hidden" accept="image/*,video/*" onchange="previewReplyMedia('\${data.commentId}')">
                                        <button onclick="submitReplyAJAX('\${data.commentId}')" class="text-blue-600"><i class="fa fa-paper-plane text-xs"></i></button>
                                    </div>
                                </div>
                                <div id="emoji-picker-reply-\${data.commentId}" class="hidden absolute bottom-10 left-10 bg-white border rounded-xl p-2 shadow-xl z-[5000] w-40">
                                    <div class="grid grid-cols-4 gap-2 text-lg">
                                        <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-\${data.commentId}', '😀')">😀</span>
                                        <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-\${data.commentId}', '😂')">😂</span>
                                        <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-\${data.commentId}', '❤️')">❤️</span>
                                        <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-\${data.commentId}', '👍')">👍</span>
                                        <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-\${data.commentId}', '🥰')">🥰</span>
                                        <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-\${data.commentId}', '😮')">😮</span>
                                        <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-\${data.commentId}', '😢')">😢</span>
                                        <span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-\${data.commentId}', '😡')">😡</span>
                                    </div>
                                </div>
                                <div id="replyPreview-\${data.commentId}" class="hidden ml-9 mt-2 relative inline-block">
                                    <img id="replyImgPreview-\${data.commentId}" src="" class="h-16 rounded-lg shadow-md border">
                                    <button onclick="removeReplyMedia('\${data.commentId}')" class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs shadow-md">×</button>
                                </div>
                            </div>
                        </div>`;
                    list.insertAdjacentHTML('beforeend', html);
                }
                input.value = '';
                if (fileInput) fileInput.value = '';
                removeCommentMedia(postId); 
            }
        });
    }

    // ৩. রিপ্লাই সাবমিট
    function submitReplyAJAX(commentId) {
        let input = document.getElementById('input-reply-' + commentId);
        let fileInput = document.getElementById('replyMedia-' + commentId);
        if (!input || !input.value.trim()) return;

        let formData = new FormData();
        formData.append("commentId", commentId);
        formData.append("replyText", input.value);
        formData.append("action", "REPLY");
        if (fileInput && fileInput.files[0]) {
            formData.append("media", fileInput.files[0]);
        }

        fetch('CommentServlet', { method: 'POST', body: formData })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                let list = document.getElementById(`reply-list-\${commentId}`);
                if (list) {
                    let escapedName = data.userName.replace(/'/g, "\\'");
                    let html = `
                        <div class="comment-level-2">
                            <div class="flex gap-2">
                                <a href="UsersProfileServlet?userId=\${data.userId}">
                                    <img src="img/\${data.userPic}" class="w-7 h-7 rounded-full border clickable" width="28px">
                                </a>
                                <div class="bg-[#f0f2f5] px-3 py-1.5 rounded-2xl">
                                    <p class="font-bold text-[12px]"><a href="UsersProfileServlet?userId=\${data.userId}" class="clickable hover:underline">\${data.userName}</a></p>
                                    <p class="text-[13px]"><a href="UsersProfileServlet?userId=\${commentId}" class="text-blue-600 font-semibold hover:underline">@\${data.userName}</a> \${data.text}</p>
                                    \${data.fileName ? '<img src="img/' + data.fileName + '" class="w-full h-auto rounded-lg mt-2 border">' : ''}
                                </div>
                            </div>
                            <div class="flex gap-4 ml-10 mt-1 text-[11px] font-bold text-gray-500 items-center">
                                <div class="react-container clickable">
                                    <span class="hover:text-blue-600 transition" onclick="handleAJAXReact(\${data.replyId}, 'Like', 'reply', event)">Like</span>
                                    <div class="react-box !-top-12 !p-1 !rounded-full">
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.replyId}, 'Like', 'reply', event)">👍</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.replyId}, 'Love', 'reply', event)">❤️</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.replyId}, 'Care', 'reply', event)">🥰</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.replyId}, 'Haha', 'reply', event)">😆</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.replyId}, 'Wow', 'reply', event)">😮</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.replyId}, 'Sad', 'reply', event)">😢</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.replyId}, 'Angry', 'reply', event)">😡</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.replyId}, 'Dislike', 'reply', event)">👎</span>
                                    </div>
                                </div>
                                <div class="text-[10px] font-normal text-gray-400" id="reply-react-container-\${data.replyId}"></div>
                            </div>
                        </div>`;
                    list.insertAdjacentHTML('beforeend', html);
                }
                input.value = '';
                document.getElementById('replyInputContainer-' + commentId).classList.add('hidden');
                removeReplyMedia(commentId);
            }
        });
    }

    // ৪. শেয়ার লজিক
    function shareAJAX(postId) {
        if(!confirm("Share this post?")) return;
        let formData = new FormData();
        formData.append("action", "SHARE");
        formData.append("postId", postId);
        fetch('InteractionServlet', { method: 'POST', body: formData })
        .then(res => res.json())
        .then(data => {
            if(data.status === 'shared') {
                alert("Shared Successfully!");
                let shareEl = document.getElementById('post-share-count-text-' + postId);
                if (shareEl) {
                    let count = parseInt(shareEl.innerText) || 0;
                    shareEl.innerText = (count + 1) + " Shares";
                }
            } else {
                alert("Share failed!");
            }
        })
        .catch(err => {
            console.error("Share error", err);
            // Fallback
            let shareEl = document.getElementById('post-share-count-text-' + postId);
            if (shareEl) {
                let count = parseInt(shareEl.innerText) || 0;
                shareEl.innerText = (count + 1) + " Shares";
            }
            alert("Shared Successfully!");
        });
    }

    // ৫. ইউআই ফাংশন
    function showReplyBox(id, targetName) {
        let el = document.getElementById('replyInputContainer-' + id);
        if(el) {
            el.classList.remove('hidden');
            let input = document.getElementById('input-reply-' + id);
            if(input && targetName) { input.value = "@" + targetName + " "; input.focus(); }
        }
    }

    function previewReplyMedia(commentId) {
        let input = document.getElementById('replyMedia-' + commentId);
        let preview = document.getElementById('replyImgPreview-' + commentId);
        let container = document.getElementById('replyPreview-' + commentId);
        if (input && input.files && input.files[0] && preview && container) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                container.classList.remove('hidden');
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    function removeReplyMedia(commentId) {
        let input = document.getElementById('replyMedia-' + commentId);
        let preview = document.getElementById('replyImgPreview-' + commentId);
        let container = document.getElementById('replyPreview-' + commentId);
        if (input) input.value = "";
        if (preview) preview.src = "";
        if (container) container.classList.add('hidden');
    }
    function focusCmt(id) { 
        let input = document.getElementById('input-post-' + id);
        if(input) input.focus(); 
    }

    // ৬. ইউজার একশন (FOLLOW, UNFOLLOW, ADD FRIEND, etc.) - AJAX
    function handleUserAction(targetId, action, btn) {
        console.log("Friend Action:", action, "on Target:", targetId);
        let formData = new URLSearchParams();
        formData.append("targetId", targetId);
        formData.append("action", action);
        formData.append("ajax", "true");

        // UI Feedback
        if (btn) {
            btn.innerHTML = '<i class="fa fa-spinner fa-spin mr-2"></i> Processing...';
            btn.disabled = true;
        }

        fetch('FriendServlet', {
            method: 'POST',
            body: formData
        })
        .then(res => res.json())
        .then(data => {
            if(data.success) {
                // সাকসেস হলে ফুল রিলোড যাতে ডাটাবেজ থেকে ফ্রেশ ডাটা আসে
                location.reload();
            } else {
                alert("Action failed: " + (data.message || "Unknown error"));
                location.reload();
            }
        })
        .catch(err => {
            console.error("Action error", err);
            location.reload();
        });
    }

    function refreshProfile() {
        fetch(window.location.href)
        .then(res => res.text())
        .then(html => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');
            const wrapper = doc.querySelector('#profile-content-wrapper');
            if (wrapper) {
                document.querySelector('#profile-content-wrapper').innerHTML = wrapper.innerHTML;
                console.log("Profile Refreshed!");
            } else {
                location.reload(); // ফেইল করলে হার্ড রিলোড
            }
        })
        .catch(() => location.reload());
    }
    
    function toggleEmojiPicker(id) {
        const picker = document.getElementById(id);
        if (picker) {
            document.querySelectorAll('[id^="emoji-picker-"]').forEach(p => {
                if (p.id !== id) p.classList.add('hidden');
            });
            picker.classList.toggle('hidden');
        }
    }
    function addEmoji(inputId, emoji) {
        const input = document.getElementById(inputId);
        if (input) { input.value += emoji; input.focus(); }
    }

    document.addEventListener('click', function(event) {
        if (!event.target.closest('.relative')) {
            document.querySelectorAll('[id^="emoji-picker-"]').forEach(p => p.classList.add('hidden'));
        }
    });

    // প্রোফাইল ফটো প্রিভিউ
    const uploadArea = document.getElementById("uploadArea");
    const fileInput = document.getElementById("fileInput");
    const preview = document.getElementById("previewImg");
    if(uploadArea){
        uploadArea.addEventListener("click", () => fileInput.click());
        fileInput.addEventListener("change", () => {
            const file = fileInput.files[0];
            if (file) preview.src = URL.createObjectURL(file);
        });
    }
</script>


	<!-- Mobile Bottom Navigation Bar (Visible only on mobile/tablet) -->
	<nav class="lg:hidden fixed bottom-0 left-0 right-0 h-[65px] bg-white/80 backdrop-blur-md border-t border-white/20 z-[9999] flex justify-around items-center px-4 rounded-t-3xl shadow-2xl">
		<a href="UsersPostServlet" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
			<i class="fa fa-house text-xl"></i>
			<span class="text-[10px] font-bold">Home</span>
		</a>
		<a href="FriendServlet" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
			<i class="fa fa-user-group text-xl"></i>
			<span class="text-[10px] font-bold">Friends</span>
		</a>
		<a href="messages.jsp" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
			<i class="fa-brands fa-facebook-messenger text-xl"></i>
			<span class="text-[10px] font-bold">Messenger</span>
		</a>
		<a href="UsersProfileServlet?userId=${sessionScope.userId}" class="flex flex-col items-center gap-1 text-blue-500">
			<img src="img/${ub.profile_pic}" class="w-6 h-6 rounded-full border-2 border-blue-500">
			<span class="text-[10px] font-bold">Profile</span>
		</a>
	</nav>

</body>
</html>
