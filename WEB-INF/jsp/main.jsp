<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> --%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Y-ChatApp | Newsfeed</title>
<link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">

<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">

<style>
* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

/* --- আপনার আসল বডি স্টাইল (শুধু width এবং overflow-x যোগ করা হয়েছে) --- */
body {
	background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
	background-size: 400% 400%;
	animation: gradient 15s ease infinite;
	font-family: 'Outfit', sans-serif;
	width: 100%;
	max-width: 100%;
	min-height: 100vh;
	overflow-x: hidden;
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

/* --- ২. এই নতুন ফিক্সটি যোগ করা হয়েছে (ইমেজ স্ক্রিনে ফিক্স করার জন্য) --- */
img {
	max-width: 100%;
	height: auto;
	display: block;
}

/* --- আপনার বাকি সব আসল কোড হুবহু নিচে রইলো (কিছুই বাদ দেওয়া হয়নি) --- */
.fb-shadow {
	box-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
}

.logo {
	display: flex;
	align-items: center;
	gap: 8px;
	color: #0866FF;
	font-size: 24px;
	font-weight: bold;
}

.react-container {
	position: relative;
	display: inline-block;
}

.react-box {
	display: none;
	position: absolute;
	bottom: 25px;
	left: -10px;
	background: white;
	padding: 5px 12px;
	border-radius: 50px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
	z-index: 9999;
	gap: 10px;
	animation: pop 0.2s ease-out;
}

.react-box::after {
	content: '';
	position: absolute;
	bottom: -15px;
	left: 0;
	width: 100%;
	height: 20px;
}

.react-container:hover .react-box {
	display: flex;
}

.react-box span {
	font-size: 26px;
	cursor: pointer;
	transition: transform 0.1s;
}

.react-box span:hover {
	transform: scale(1.4);
}

@
keyframes pop {from { opacity:0;
	transform: translateY(10px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.comment-level-1 {
	margin-left: 0px;
}

.comment-level-2 {
	margin-left: 48px;
	border-left: 2px solid #ddd;
	padding-left: 10px;
}

.comment-level-3 {
	margin-left: 96px;
	border-left: 2px solid #ddd;
	padding-left: 10px;
}

.modal {
	display: none;
	position: fixed;
	inset: 0;
	background: rgba(255, 255, 255, 0.8);
	backdrop-filter: blur(5px);
	z-index: 9999;
	align-items: center;
	justify-content: center;
}

.clickable {
	cursor: pointer;
}

.clickable:hover {
	text-decoration: underline;
}

.media-icon {
	color: #65676b;
	cursor: pointer;
	padding: 8px;
	border-radius: 50%;
	transition: 0.2s;
}

.media-icon:hover {
	background: #e4e6eb;
}

/* === ৩-কলামের লেআউট এবং পোস্ট ফিক্স করার সঠিক কোড === */
/* টপ নেভারকে স্ক্রিনের সাথে ফিট করা */
header, .navbar {
	width: 100% !important;
	max-width: 100% !important;
}

/* পোস্টের ভেতরের ইমেজের অতিরিক্ত স্পেস কমানো */
	object-fit: cover !important;
}

/* --- REELS STYLES --- */
.reels-container {
	display: flex;
	gap: 12px;
	overflow-x: auto;
	padding: 10px 0;
	scrollbar-width: none; /* Hide scrollbar for Firefox */
}
.reels-container::-webkit-scrollbar {
	display: none; /* Hide scrollbar for Chrome/Safari */
}
.reel-card {
	min-width: 140px;
	height: 230px;
	border-radius: 15px;
	position: relative;
	overflow: hidden;
	background: #000;
	cursor: pointer;
	flex-shrink: 0;
	transition: 0.3s;
	box-shadow: 0 4px 10px rgba(0,0,0,0.1);
}
.reel-card:hover {
	transform: scale(1.02);
}
.reel-video {
	width: 100%;
	height: 100%;
	object-fit: cover;
	opacity: 0.8;
}
.reel-user {
	position: absolute;
	top: 10px;
	left: 10px;
	z-index: 10;
}
.reel-user img {
	width: 32px;
	height: 32px;
	border-radius: 50%;
	border: 2px solid #0866FF;
}
.reel-info {
	position: absolute;
	bottom: 10px;
	left: 10px;
	color: white;
	font-size: 13px;
	font-weight: 600;
	z-index: 10;
}

@keyframes slideInUp {
    from { opacity: 0; transform: translateY(15px); }
    to { opacity: 1; transform: translateY(0); }
}
.animate-slide-in {
    animation: slideInUp 0.4s ease-out forwards;
}

.custom-scrollbar::-webkit-scrollbar-thumb:hover { background: #6B7280; }

@media (max-width: 1023px) {
	body {
		padding-bottom: 80px !important;
	}
}
</style>
</head>
<body class="bg-fixed">

	<header class="glass-nav h-[56px] sticky top-0 z-[5000] flex items-center justify-between px-4">
		<!-- LEFT SECTION (Logo and Search) -->
		<div class="flex items-center gap-2 flex-1">
			<div class="logo"
				style="display: flex; align-items: center; gap: 10px;">
				<img src="<%=request.getContextPath()%>/icons/icon-192.png"
					width="40" alt="Logo"> <span
					style="font-weight: bold; font-size: 20px;">Y-ChatApp</span>
			</div>

			<form action="SearchServlet" method="get"
				class="bg-white/50 backdrop-blur-md px-4 py-2 rounded-full hidden md:flex items-center gap-2 ml-4 border border-white/30 focus-within:w-[250px] transition-all duration-300 group">
				<i class="fa fa-search text-gray-400 group-focus-within:text-blue-500"></i> <input
					name="query" placeholder="Search Y-Chat"
					class="bg-transparent outline-none w-[150px] text-sm font-medium">
			</form>
		</div>

		<!-- CENTER SECTION (Navigation Links) -->
		<div
			class="hidden lg:flex flex-1 justify-center gap-12 text-[24px] text-gray-500">
			<a href="UsersPostServlet" title="Home"><i
				class="fa fa-house text-[#0866FF]"></i></a> <a href="GroupsServlet"
				title="Groups" class="text-gray-500 hover:text-blue-500 transition"><i
				class="fa fa-user-group clickable"></i></a> <a href="VideosServlet"
				title="Videos" class="text-gray-500 hover:text-blue-500 transition"><i
				class="fa fa-video clickable"></i></a> <a href="MarketServlet"
				title="Market" class="text-gray-500 hover:text-blue-500 transition"><i
				class="fa fa-shop clickable"></i></a>
		</div>

		<!-- RIGHT SECTION (Actions & Profile) -->
		<div class="flex items-center gap-3 flex-1 justify-end">
			<!-- Notification Link -->
			<a href="NotificationServlet"
				class="w-10 h-10 bg-gray-200 rounded-full flex items-center justify-center relative clickable hover:bg-gray-300 transition">
				<i class="fa fa-bell text-black"></i> <span
				class="absolute -top-1 -right-1 bg-red-600 text-white text-[11px] px-1.5 rounded-full border-2 border-white font-bold"></span>
			</a>

			<!-- Profile Link -->
			<a href="UsersProfileServlet?userId=${sessionScope.userId}"
				class="flex items-center gap-2 p-1 hover:bg-gray-100 rounded-full clickable border border-transparent hover:border-gray-200 transition">
				<img src="img/${ub.profile_pic}" class="w-9 h-9 rounded-full border"
				width="45Px"> <span>${ub.name}</span>
			</a>

			<!-- Logout Link -->
			<a href="UsersLogoutServlet" title="Logout"
				class="w-10 h-10 bg-gray-200 rounded-full flex items-center justify-center hover:bg-red-100 hover:text-red-600 transition">
				<i class="fa fa-right-from-bracket"></i>
			</a>
		</div>
	</header>


	<div class="max-w-[1400px] mx-auto grid grid-cols-1 lg:grid-cols-[250px_1fr_280px] xl:grid-cols-[280px_1fr_320px] gap-6 mt-4 px-4">

		<!-- LEFT SIDEBAR -->
		<aside class="hidden lg:block sticky top-[70px] h-fit">
			<div class="glass-card p-4 rounded-3xl space-y-2">
				<div onclick="location.href='UsersProfileServlet?userId=${sessionScope.userId}'"
					class="flex items-center gap-3 p-3 rounded-xl hover:bg-white hover:shadow-[0_10px_20px_rgba(0,0,0,0.1)] hover:-translate-y-1 transition-all duration-300 cursor-pointer group">
					<div class="relative">
						<img src="img/${ub.profile_pic}" alt="${ub.name}" class="w-10 h-10 rounded-full border-2 border-blue-500 shadow-md">
						<div class="absolute bottom-0 right-0 w-3 h-3 bg-green-500 border-2 border-white rounded-full"></div>
					</div>
					<span class="font-bold text-gray-700 group-hover:text-blue-600">${ub.name}</span>
				</div>

				<a href="FriendServlet" class="flex items-center gap-4 p-3 rounded-xl hover:bg-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group">
					<div class="w-10 h-10 flex items-center justify-center rounded-xl bg-gradient-to-br from-blue-400 to-blue-600 shadow-lg shadow-blue-200">
						<i class="fa fa-user-group text-white"></i>
					</div> <span class="font-bold text-gray-600 group-hover:text-blue-600">Friends</span>
				</a>

				<a href="messages.jsp" class="flex items-center gap-4 p-3 rounded-xl hover:bg-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group">
					<div class="w-10 h-10 flex items-center justify-center rounded-xl bg-gradient-to-br from-purple-400 to-purple-600 shadow-lg shadow-purple-200">
						<i class="fa fa-comment-dots text-white"></i>
					</div> <span class="font-bold text-gray-600 group-hover:text-purple-600">Messenger</span>
				</a>

				<div onclick="showMemoriesModal()" class="flex items-center gap-4 p-3 rounded-xl hover:bg-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group cursor-pointer">
					<div class="w-10 h-10 flex items-center justify-center rounded-xl bg-gradient-to-br from-cyan-400 to-cyan-600 shadow-lg shadow-cyan-200">
						<i class="fa fa-clock text-white"></i>
					</div>
					<span class="font-bold text-gray-600 group-hover:text-cyan-600">Memories</span>
				</div>

				<div onclick="showSavedPostsModal()" class="flex items-center gap-4 p-3 rounded-xl hover:bg-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group cursor-pointer">
					<div class="w-10 h-10 flex items-center justify-center rounded-xl bg-gradient-to-br from-pink-400 to-pink-600 shadow-lg shadow-pink-200">
						<i class="fa fa-bookmark text-white"></i>
					</div>
					<span class="font-bold text-gray-600 group-hover:text-pink-600">Saved</span>
				</div>

				<div onclick="openReelModal()" class="flex items-center gap-4 p-3 rounded-xl bg-orange-50/50 border border-orange-100 hover:bg-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group cursor-pointer">
					<div class="w-10 h-10 flex items-center justify-center rounded-xl bg-gradient-to-br from-orange-400 to-orange-600 shadow-lg shadow-orange-200">
						<i class="fa fa-clapperboard text-white"></i>
					</div>
					<span class="font-bold text-gray-700 group-hover:text-orange-600">Create Reel</span>
				</div>

				<hr class="my-4 border-white/20">
				<p class="px-4 text-xs font-bold text-gray-400 uppercase tracking-widest">Shortcuts</p>
			</div>
		</aside>

		<!-- MAIN FEED -->
		<main class="space-y-6">
			<!-- STORIES SECTION -->
			<div class="flex gap-3 overflow-x-auto pb-2 custom-scrollbar">
				<!-- Create Story Card -->
				<div onclick="openStoryModal()" class="w-[120px] h-[190px] min-w-[120px] rounded-2xl glass-card relative overflow-hidden flex flex-col group cursor-pointer border border-white/30 shadow-md">
					<div class="h-[130px] overflow-hidden bg-gray-200">
						<img src="img/${ub.profile_pic}" alt="${ub.name}" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500">
					</div>
					<div class="flex-1 bg-white relative flex flex-col items-center justify-end pb-3 pt-4">
						<div class="absolute -top-5 left-1/2 -translate-x-1/2 w-10 h-10 rounded-full bg-blue-600 border-4 border-white flex items-center justify-center shadow-md">
							<i class="fa fa-plus text-white text-sm"></i>
						</div>
						<span class="text-[11px] font-bold text-gray-700">Create Story</span>
					</div>
				</div>

				<!-- Story Cards -->
				<c:forEach var="story" items="${storyList}">
					<div onclick="openStoryViewer('${story.name}', '${story.profilePic}', '${story.mediaUrl}', '${story.text}')" 
					     class="w-[120px] h-[190px] min-w-[120px] rounded-2xl relative overflow-hidden cursor-pointer shadow-md group border border-white/20">
						<c:choose>
							<c:when test="${not empty story.mediaUrl}">
								<img src="img/${story.mediaUrl}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
								<div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent"></div>
							</c:when>
							<c:otherwise>
								<!-- Text Story default gradient background -->
								<div class="w-full h-full bg-gradient-to-br from-indigo-500 via-purple-500 to-pink-500 flex items-center justify-center p-3 text-center">
									<p class="text-white text-xs font-bold leading-tight line-clamp-4">${story.text}</p>
								</div>
							</c:otherwise>
						</c:choose>
						<!-- User avatar top left -->
						<div class="absolute top-2 left-2 w-8 h-8 rounded-full border-2 border-blue-500 overflow-hidden shadow-md">
							<img src="img/${story.profilePic}" class="w-full h-full object-cover">
						</div>
						<!-- User Name bottom left -->
						<div class="absolute bottom-2 left-2 right-2">
							<p class="text-[11px] font-bold text-white truncate shadow-sm">${story.name}</p>
						</div>
					</div>
				</c:forEach>
			</div>

			<!-- REELS SECTION -->
			<div class="reels-container py-2">
				<div onclick="openReelModal()" class="reel-card glass-card flex flex-col items-center justify-center border-2 border-dashed border-white/50 group">
					<div class="w-14 h-14 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center mb-2 shadow-lg group-hover:scale-110 transition-transform">
						<i class="fa fa-plus text-white text-2xl"></i>
					</div>
					<span class="text-gray-800 font-extrabold text-xs uppercase tracking-wider">Create Reel</span>
				</div>

				<c:forEach var="reel" items="${reelsList}">
					<div onclick="openReelViewer(${reel.id})" class="reel-card">
						<video class="reel-video">
							<source src="img/${reel.file_name}" type="video/mp4">
						</video>
						<div class="reel-user">
							<img src="img/${reel.profile_pic}" alt="user">
						</div>
						<div class="reel-info">${reel.name}</div>
					</div>
				</c:forEach>
			</div>

			<!-- POST BOX -->
			<div class="glass-card p-5 rounded-3xl">
				<div class="flex gap-4">
					<a href="UsersProfileServlet?userId=${sessionScope.userId}" class="group relative"> 
                        <img src="img/${ub.profile_pic}" alt="${ub.name}" class="w-12 h-12 rounded-2xl object-cover ring-2 ring-white shadow-md group-hover:scale-105 transition-transform">
                        <div class="absolute -bottom-1 -right-1 w-4 h-4 bg-green-500 border-2 border-white rounded-full"></div>
					</a>
					<button onclick="openModal()"
						class="flex-1 bg-white/40 hover:bg-white/60 backdrop-blur-md rounded-2xl text-left px-6 text-gray-600 text-[16px] font-medium transition-all border border-white/20">
						What's on your mind, ${ub.name}?</button>
				</div>
				<div class="border-t border-white/20 mt-4 pt-3 flex justify-around">
					<div onclick="openLiveModal()"
						class="flex items-center gap-2 py-2 px-6 hover:bg-red-500/10 rounded-xl transition-all clickable text-red-500 font-semibold">
						<i class="fa fa-video text-lg"></i> Live
					</div>
					<div onclick="openModal(); document.getElementById('modalFileInput').click();"
						class="flex items-center gap-2 py-2 px-6 hover:bg-green-500/10 rounded-xl transition-all clickable text-green-500 font-semibold">
						<i class="fa fa-image text-lg"></i> Photo
					</div>
					<div onclick="openModal()"
						class="flex items-center gap-2 py-2 px-6 hover:bg-yellow-500/10 rounded-xl transition-all clickable text-yellow-500 font-semibold">
						<i class="fa fa-face-smile text-lg"></i> Feeling
					</div>
				</div>
			</div>

			<!-- POSTS LIST -->
			<c:forEach var="post" items="${postList}">
				<div class="glass-card rounded-3xl p-6 mb-6 hover:shadow-2xl transition-all duration-500 group/post">
					<div class="flex justify-between">
						<div class="flex gap-3">
							<img onclick="location.href='UsersProfileServlet?userId=${post.userId}'"
								src="img/${post.profile_pic}" class="w-10 h-10 rounded-full clickable" width="30Px">
							<div>
								<a href="UsersProfileServlet?userId=${post.userId}" class="font-bold clickable group-hover/post:text-blue-600 transition-colors">${post.name}</a>
								<c:if test="${not empty post.feeling}">
									<span class="text-gray-500 text-[14px]"> is feeling <span class="font-bold text-gray-700">${post.feeling}</span></span>
								</c:if>
								<div class="text-[12px] text-gray-500 flex items-center gap-1">
									<span class="time-ago" data-time="${post.time}">${post.time}</span> • <i class="fa fa-earth-americas"></i>
								</div>
							</div>
						</div>
						<div class="relative group/menu">
							<div class="p-2 hover:bg-gray-100 rounded-full transition-colors cursor-pointer"><i class="fa fa-ellipsis-h text-gray-500"></i></div>
							<div class="hidden group-hover/menu:block absolute right-0 top-8 bg-white border shadow-lg rounded-xl z-50 min-w-[150px] overflow-hidden">
								<div onclick="toggleSavePost(${post.id}, this)" class="px-4 py-3 hover:bg-blue-50 text-blue-600 cursor-pointer font-bold transition flex items-center gap-2">
									<i class="fa fa-bookmark"></i> Save Post
								</div>
								<c:if test="${post.userId == sessionScope.ub.id}">
									<div onclick="deletePost(${post.id})" class="px-4 py-3 hover:bg-red-50 text-red-600 cursor-pointer font-bold transition flex items-center gap-2">
										<i class="fa fa-trash"></i> Delete Post
									</div>
								</c:if>
							</div>
						</div>
					</div>

					<!-- Post Content -->
					<div class="mt-4">
						<p class="text-gray-800 leading-relaxed">${post.content}</p>
						<c:if test="${not empty post.file_name}">
							<div class="mt-4 rounded-2xl overflow-hidden border border-white/20 shadow-lg bg-gray-100/30">
								<c:choose>
									<c:when test="${post.post_type == 'video' || post.file_name.toLowerCase().endsWith('.webm') || post.file_name.toLowerCase().endsWith('.mp4')}">
										<video src="img/${post.file_name}" controls class="w-full max-h-[500px] object-contain bg-black"></video>
									</c:when>
									<c:otherwise>
										<img src="img/${post.file_name}" class="w-full max-h-[500px] object-cover hover:scale-[1.01] transition-transform duration-700">
									</c:otherwise>
								</c:choose>
							</div>
						</c:if>
					</div>

					<!-- Stats Section -->
					<div class="flex items-center justify-between mt-4 py-3 border-y border-white/10">
						<div class="flex items-center gap-1.5 text-gray-500 text-sm">
							<span id="react-count-${post.id}" class="font-bold ml-1">
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
						<div class="flex gap-4 text-gray-500 text-sm font-bold">
							<span id="post-comment-count-text-${post.id}" class="hover:underline cursor-pointer" onclick="focusCmt(${post.id})">${post.commentCount} Comments</span>
							<span id="post-share-count-text-${post.id}" class="hover:underline cursor-pointer" onclick="shareAJAX(${post.id})">${post.shareCount} Shares</span>
						</div>
					</div>

					<!-- Action Buttons -->
					<div class="flex justify-around py-1.5">
						<div class="react-container flex-1">
							<div id="post-action-btn-${post.id}" onclick="handleAJAXReact(${post.id}, 'Like', 'post', event)" class="flex items-center justify-center gap-2 py-2 rounded-xl hover:bg-white/50 transition-all cursor-pointer font-bold text-gray-600">
								<span id="post-action-btn-content-${post.id}" class="flex items-center justify-center gap-2">
									<i class="fa-regular fa-thumbs-up"></i> Like
								</span>
							</div>
							<div class="react-box glass-card !p-2 !rounded-full">
								<span title="Like" class="hover:scale-125 transition" onclick="handleAJAXReact(${post.id}, 'Like', 'post', event)">👍</span>
								<span title="Love" class="hover:scale-125 transition" onclick="handleAJAXReact(${post.id}, 'Love', 'post', event)">❤️</span>
								<span title="Care" class="hover:scale-125 transition" onclick="handleAJAXReact(${post.id}, 'Care', 'post', event)">🥰</span>
								<span title="Haha" class="hover:scale-125 transition" onclick="handleAJAXReact(${post.id}, 'Haha', 'post', event)">😆</span>
								<span title="Wow" class="hover:scale-125 transition" onclick="handleAJAXReact(${post.id}, 'Wow', 'post', event)">😮</span>
								<span title="Sad" class="hover:scale-125 transition" onclick="handleAJAXReact(${post.id}, 'Sad', 'post', event)">😢</span>
								<span title="Angry" class="hover:scale-125 transition" onclick="handleAJAXReact(${post.id}, 'Angry', 'post', event)">😡</span>
								<span title="Dislike" class="hover:scale-125 transition" onclick="handleAJAXReact(${post.id}, 'Dislike', 'post', event)">👎</span>
							</div>
						</div>
						<div onclick="focusCmt(${post.id})" class="flex-1 flex items-center justify-center gap-2 py-2 rounded-xl hover:bg-white/50 transition-all cursor-pointer font-bold text-gray-600">
							<i class="fa-regular fa-comment"></i> Comment
						</div>
						<div onclick="shareAJAX(${post.id})" class="flex-1 flex items-center justify-center gap-2 py-2 rounded-xl hover:bg-white/50 transition-all cursor-pointer font-bold text-gray-600">
							<i class="fa-solid fa-share"></i> Share
						</div>
					</div>

					<!-- Comment Section -->
					<div id="comment-section-${post.id}" class="mt-4 pt-4 border-t border-white/10">
						<div id="comment-list-${post.id}" class="space-y-4 mb-4">
							<c:forEach var="cmt" items="${post.comments}">
								<div class="flex flex-col gap-2 group/cmt mb-4">
									<div class="flex gap-2">
										<img src="img/${cmt.profilePic}" class="w-8 h-8 rounded-full border shadow-sm cursor-pointer" onclick="location.href='UsersProfileServlet?userId=${cmt.userId}'">
										<div class="flex flex-col flex-1">
											<div class="bg-white/50 px-4 py-2 rounded-2xl shadow-sm inline-block max-w-fit">
												<p class="font-bold text-[13px] hover:underline cursor-pointer" onclick="location.href='UsersProfileServlet?userId=${cmt.userId}'">${cmt.name}</p>
												<p class="text-[14px] text-gray-700">${cmt.comment_text}</p>
												<c:if test="${not empty cmt.file_name}">
													<img src="img/${cmt.file_name}" class="mt-2 rounded-xl max-h-40 border shadow-sm">
												</c:if>
											</div>
											<div class="flex gap-4 ml-4 mt-1 text-[11px] font-bold text-gray-500 items-center">
												<div class="react-container clickable">
													<span class="hover:text-blue-600 transition" onclick="handleAJAXReact(${cmt.id}, 'Like', 'comment', event)">Like</span>
													<div class="react-box !p-1 !rounded-full">
														<span title="Like" onclick="handleAJAXReact(${cmt.id}, 'Like', 'comment', event)">👍</span>
														<span title="Love" onclick="handleAJAXReact(${cmt.id}, 'Love', 'comment', event)">❤️</span>
														<span title="Care" onclick="handleAJAXReact(${cmt.id}, 'Care', 'comment', event)">🥰</span>
														<span title="Haha" onclick="handleAJAXReact(${cmt.id}, 'Haha', 'comment', event)">😆</span>
														<span title="Wow" onclick="handleAJAXReact(${cmt.id}, 'Wow', 'comment', event)">😮</span>
														<span title="Sad" onclick="handleAJAXReact(${cmt.id}, 'Sad', 'comment', event)">😢</span>
														<span title="Angry" onclick="handleAJAXReact(${cmt.id}, 'Angry', 'comment', event)">😡</span>
														<span title="Dislike" onclick="handleAJAXReact(${cmt.id}, 'Dislike', 'comment', event)">👎</span>
													</div>
												</div>
												<span class="clickable hover:text-blue-600 transition" onclick="showReplyBox(${cmt.id}, '${cmt.name}')">Reply</span>
												<span class="clickable hover:text-blue-600 transition" onclick="shareCommentOrReply(this)">Share</span>
												<div id="comment-react-container-${cmt.id}" class="text-[10px] font-normal text-gray-400">
													<c:set var="tc" value="${cmt.likeCount + cmt.loveCount + cmt.careCount + cmt.hahaCount + cmt.wowCount + cmt.sadCount + cmt.angryCount + cmt.dislikes}"/>
													<c:if test="${tc > 0}">
														<c:if test="${cmt.likeCount > 0}">👍 <span class="text-gray-600">${cmt.likeCount}</span>&nbsp;&nbsp;</c:if>
														<c:if test="${cmt.loveCount > 0}">❤️ <span class="text-gray-600">${cmt.loveCount}</span>&nbsp;&nbsp;</c:if>
														<c:if test="${cmt.careCount > 0}">🥰 <span class="text-gray-600">${cmt.careCount}</span>&nbsp;&nbsp;</c:if>
														<c:if test="${cmt.hahaCount > 0}">😆 <span class="text-gray-600">${cmt.hahaCount}</span>&nbsp;&nbsp;</c:if>
														<c:if test="${cmt.wowCount > 0}">😮 <span class="text-gray-600">${cmt.wowCount}</span>&nbsp;&nbsp;</c:if>
														<c:if test="${cmt.sadCount > 0}">😢 <span class="text-gray-600">${cmt.sadCount}</span>&nbsp;&nbsp;</c:if>
														<c:if test="${cmt.angryCount > 0}">😡 <span class="text-gray-600">${cmt.angryCount}</span>&nbsp;&nbsp;</c:if>
														<c:if test="${cmt.dislikes > 0}">👎 <span class="text-gray-600">${cmt.dislikes}</span>&nbsp;&nbsp;</c:if>
													</c:if>
												</div>
											</div>

											<!-- Reply List -->
											<div id="reply-list-${cmt.id}" class="mt-2 space-y-2 ml-10">
												<c:forEach var="reply" items="${cmt.replies}">
													<div class="comment-level-2 mb-2 flex gap-2">
														<a href="UsersProfileServlet?userId=${reply.userId}">
															<img src="img/${reply.profilePic}" class="w-7 h-7 rounded-full border shadow-sm">
														</a>
														<div class="flex flex-col flex-1">
															<div class="bg-white/40 px-3 py-1.5 rounded-2xl inline-block max-w-fit shadow-sm">
																<p class="font-bold text-[12px]"><a href="UsersProfileServlet?userId=${reply.userId}" class="hover:underline">${reply.name}</a></p>
																<p class="text-[13px] text-gray-700">${reply.text}</p>
																<c:if test="${not empty reply.media}">
																	<img src="img/${reply.media}" class="mt-1 rounded-lg max-h-32 border shadow-sm">
																</c:if>
															</div>
															<div class="flex gap-4 ml-3 mt-0.5 text-[10px] font-bold text-gray-500 items-center">
																<div class="react-container clickable">
																	<span class="hover:text-blue-600 transition" onclick="handleAJAXReact(${reply.id}, 'Like', 'reply', event)">Like</span>
																	<div class="react-box !p-1 !rounded-full">
																		<span title="Like" onclick="handleAJAXReact(${reply.id}, 'Like', 'reply', event)">👍</span>
																		<span title="Love" onclick="handleAJAXReact(${reply.id}, 'Love', 'reply', event)">❤️</span>
																		<span title="Care" onclick="handleAJAXReact(${reply.id}, 'Care', 'reply', event)">🥰</span>
																		<span title="Haha" onclick="handleAJAXReact(${reply.id}, 'Haha', 'reply', event)">😆</span>
																		<span title="Wow" onclick="handleAJAXReact(${reply.id}, 'Wow', 'reply', event)">😮</span>
																		<span title="Sad" onclick="handleAJAXReact(${reply.id}, 'Sad', 'reply', event)">😢</span>
																		<span title="Angry" onclick="handleAJAXReact(${reply.id}, 'Angry', 'reply', event)">😡</span>
																		<span title="Dislike" onclick="handleAJAXReact(${reply.id}, 'Dislike', 'reply', event)">👎</span>
																	</div>
																</div>
																<span class="clickable hover:text-blue-600 transition" onclick="showReplyBox(${cmt.id}, '${reply.name}')">Reply</span>
																<span class="clickable hover:text-blue-600 transition" onclick="shareCommentOrReply(this)">Share</span>
																<div id="reply-react-container-${reply.id}" class="text-[9px] font-normal text-gray-400">
																	<c:set var="trc" value="${reply.likeCount + reply.loveCount + reply.careCount + reply.hahaCount + reply.wowCount + reply.sadCount + reply.angryCount + reply.dislikes}"/>
																	<c:if test="${trc > 0}">
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
													</div>
												</c:forEach>
											</div>

											<!-- Reply Input Box -->
											<div id="replyInputContainer-${cmt.id}" class="hidden mt-2 ml-10 relative">
												<div class="flex gap-2">
													<img src="img/${ub.profile_pic}" class="w-7 h-7 rounded-full border shadow-sm" width="28px">
													<div class="flex-1 bg-white/40 backdrop-blur-sm rounded-2xl px-3 py-1.5 flex items-center border border-white/20">
														<input type="text" id="input-reply-${cmt.id}" placeholder="Write a reply..." class="bg-transparent outline-none flex-1 text-[12px] font-medium"
															onkeydown="if(event.key === 'Enter') submitReplyAJAX('${cmt.id}')">
														<i class="fa-regular fa-face-smile text-yellow-500 cursor-pointer mx-2" onclick="toggleEmojiPicker('emoji-picker-reply-${cmt.id}')"></i>
                                                        <label for="replyMedia-${cmt.id}" class="cursor-pointer mx-2 text-gray-500 hover:text-blue-600 transition">
                                                            <i class="fa-solid fa-camera"></i>
                                                        </label>
                                                        <input type="file" id="replyMedia-${cmt.id}" class="hidden" accept="image/*,video/*" onchange="previewReplyMedia('${cmt.id}')">
														<button onclick="submitReplyAJAX('${cmt.id}')" class="text-blue-600"><i class="fa fa-paper-plane text-xs"></i></button>
													</div>
												</div>
                                                <div id="replyPreview-${cmt.id}" class="hidden ml-9 mt-2 relative inline-block">
                                                    <img id="replyImgPreview-${cmt.id}" src="" class="h-16 rounded-lg shadow-md border">
                                                    <button onclick="removeReplyMedia('${cmt.id}')" class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs shadow-md">×</button>
                                                </div>
												<div id="emoji-picker-reply-${cmt.id}" class="hidden absolute bottom-10 left-10 bg-white border rounded-xl p-2 shadow-xl z-[5000] w-40">
													<div class="grid grid-cols-4 gap-2 text-lg">
														<span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-${cmt.id}', '😀')">😀</span>
														<span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-${cmt.id}', '😂')">😂</span>
														<span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-${cmt.id}', '❤️')">❤️</span>
														<span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-${cmt.id}', '👍')">👍</span>
														<span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-${cmt.id}', '🥰')">🥰</span>
														<span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-${cmt.id}', '😮')">😮</span>
														<span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-${cmt.id}', '😢')">😢</span>
														<span class="cursor-pointer hover:scale-125 transition" onclick="addEmoji('input-reply-${cmt.id}', '😡')">😡</span>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</c:forEach>
						</div>
						<!-- Comment Input -->
						<form onsubmit="event.preventDefault(); submitCommentAJAX(${post.id});" class="flex gap-2 mt-4 items-center relative">
							<img src="img/${ub.profile_pic}" class="w-8 h-8 rounded-full border shadow-sm" width="30Px">
							<div class="flex-1 bg-white/40 backdrop-blur-sm rounded-2xl px-4 py-2 flex items-center gap-2 border border-white/30 focus-within:ring-2 ring-blue-500/20 transition-all">
								<input id="input-post-${post.id}" class="bg-transparent outline-none flex-1 text-sm font-medium" placeholder="Write a comment...">
								<div class="flex items-center gap-1.5 text-gray-400">
									<i class="fa-regular fa-face-smile hover:text-yellow-500 cursor-pointer transition-colors" onclick="toggleEmojiPicker('emoji-picker-post-${post.id}')"></i>
									<i class="fa-regular fa-image hover:text-blue-500 cursor-pointer transition-colors" onclick="document.getElementById('commentMedia-${post.id}').click()"></i>
								</div>
								<input type="file" id="commentMedia-${post.id}" class="hidden" accept="image/*" onchange="previewCommentMedia(event, ${post.id})">
								<button type="submit" class="text-blue-600 hover:scale-110 transition-transform"><i class="fa fa-paper-plane"></i></button>
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
						</form>
					</div>
				</div>
			</c:forEach>
		</main>

		<!-- RIGHT SIDEBAR (Dynamic & Colorful) -->
		<aside class="hidden lg:block sticky top-[70px] h-fit">
			<div class="space-y-6">
				<!-- Sponsored Card -->
				<div class="glass-card p-5 rounded-3xl group cursor-pointer transition-all hover:shadow-2xl">
					<div class="flex items-center justify-between mb-4">
						<h3 class="text-xs font-bold text-gray-500 uppercase tracking-widest">Sponsored</h3>
						<i class="fa fa-ellipsis-h text-gray-400 group-hover:text-blue-500 transition"></i>
					</div>
					<div class="rounded-2xl overflow-hidden mb-3 relative">
						<img src="https://images.unsplash.com/photo-1611162617474-5b21e879e113?q=80&w=1000&auto=format&fit=crop" class="w-full h-32 object-cover group-hover:scale-110 transition-transform duration-500">
						<div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>
						<div class="absolute bottom-2 left-3 text-white text-[10px] font-bold bg-blue-600 px-2 py-0.5 rounded-full uppercase tracking-tighter">New</div>
					</div>
					<div class="flex items-center justify-between">
						<div>
							<p class="text-sm font-bold text-gray-800">Y-Ads Manager</p>
							<p class="text-[11px] text-gray-500">Grow your business today</p>
						</div>
						<i class="fa fa-arrow-right text-blue-500 group-hover:translate-x-1 transition-transform"></i>
					</div>
				</div>

				<!-- Contacts Section -->
				<div class="glass-card p-5 rounded-3xl">
					<div class="flex items-center justify-between mb-4">
						<h3 class="text-xs font-bold text-gray-500 uppercase tracking-widest">Contacts</h3>
						<div class="flex gap-2 text-gray-400">
							<i class="fa fa-video hover:text-blue-500 transition cursor-pointer"></i>
							<i class="fa fa-search hover:text-blue-500 transition cursor-pointer"></i>
							<i class="fa fa-ellipsis-h hover:text-blue-500 transition cursor-pointer"></i>
						</div>
					</div>
					<div class="space-y-1">
						<c:forEach var="friend" items="${friendList}">
							<div onclick="location.href='messages.jsp?userName=${friend.name}'" class="flex items-center gap-3 p-2 rounded-xl hover:bg-white/40 transition-all cursor-pointer group">
								<div class="relative">
									<img src="img/${friend.profile_pic}" class="w-10 h-10 rounded-xl object-cover shadow-sm group-hover:rotate-6 transition-transform">
									<div class="absolute -bottom-1 -right-1 w-3.5 h-3.5 bg-green-500 border-2 border-white rounded-full"></div>
								</div>
								<span class="text-sm font-semibold text-gray-700 group-hover:text-blue-600 transition-colors">${friend.name}</span>
							</div>
						</c:forEach>
						<c:if test="${empty friendList}">
							<p class="text-xs text-gray-400 text-center py-4">No contacts online</p>
						</c:if>
					</div>
				</div>
			</div>
		</aside>
	</div>

	<!-- Features (Saved/Memories) Modal -->
	<div id="featuresModal" class="modal !bg-black/85 z-[9999]">
		<div class="modal-content !max-w-[700px] !w-[95%] !bg-[#18191A] rounded-3xl shadow-2xl overflow-hidden border border-gray-700 p-0">
			<!-- Header -->
			<div class="flex items-center justify-between p-5 border-b border-gray-700">
				<h2 id="featuresModalTitle" class="text-xl font-bold text-white flex items-center gap-2"></h2>
				<button onclick="closeFeaturesModal()" class="w-8 h-8 rounded-full bg-gray-700 hover:bg-gray-600 flex items-center justify-center text-white transition">
                    <i class="fa fa-times"></i>
                </button>
			</div>
			<!-- Content Container -->
			<div id="featuresModalBody" class="p-6 max-h-[60vh] overflow-y-auto space-y-4 text-white">
				<!-- Content dynamically loaded via JS -->
			</div>
		</div>
	</div>

	<!-- Create Story Modal -->
	<div id="storyModal" class="modal">
		<div class="modal-content !max-w-[450px] !w-[95%] bg-white rounded-2xl shadow-2xl p-0 overflow-hidden">
			<div class="flex items-center justify-between p-4 border-b">
				<h2 class="text-xl font-bold text-gray-800">Create Story</h2>
				<button onclick="closeStoryModal()" class="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center hover:bg-red-100 hover:text-red-600 transition">
					<i class="fa fa-times"></i>
				</button>
			</div>
			<form id="storyForm" action="StoryServlet" method="post" enctype="multipart/form-data" class="p-6 space-y-4">
				<div>
					<label class="block text-sm font-bold text-gray-700 mb-1">Story Text (Optional)</label>
					<textarea name="text" placeholder="Write something in your story..." class="w-full p-3 border rounded-xl outline-none resize-none h-20 text-sm focus:ring-2 focus:ring-blue-500/20 transition-all"></textarea>
				</div>
				<div>
					<label class="block text-sm font-bold text-gray-700 mb-1">Upload Photo/Video</label>
					<div class="border-2 border-dashed border-gray-200 rounded-xl p-6 text-center cursor-pointer hover:bg-gray-50 transition" onclick="document.getElementById('storyMediaInput').click()">
						<i class="fa fa-image text-3xl text-blue-500 mb-2"></i>
						<p class="text-gray-500 text-sm font-medium">Click to select photo or video</p>
					</div>
					<input type="file" name="media" id="storyMediaInput" class="hidden" accept="image/*,video/*" onchange="previewStoryMedia(this)">
				</div>
				<!-- Preview Container -->
				<div id="storyPreviewContainer" class="hidden mt-3 rounded-xl overflow-hidden bg-gray-100 border relative max-h-[200px]">
					<button type="button" onclick="removeStoryPreview()" class="absolute top-2 right-2 bg-black/60 text-white rounded-full w-6 h-6 flex items-center justify-center text-xs">×</button>
					<img id="storyImagePreview" src="#" class="w-full h-auto object-contain max-h-[200px] hidden">
					<video id="storyVideoPreview" src="#" class="w-full h-auto object-contain max-h-[200px] hidden" controls></video>
				</div>
				<button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 rounded-xl shadow-lg transition">Share to Story</button>
			</form>
		</div>
	</div>

	<!-- Story Viewer Modal -->
	<div id="storyViewerModal" class="modal !bg-black/95">
		<div class="relative w-full h-full flex items-center justify-center">
			<button onclick="closeStoryViewer()" class="absolute top-6 right-6 text-white text-3xl z-50 hover:scale-110 transition">
				<i class="fa fa-times"></i>
			</button>
			
			<div class="h-[80vh] w-[90%] max-w-[400px] bg-[#1c1c1e] rounded-2xl overflow-hidden relative shadow-2xl flex flex-col">
				<!-- Progress Bar -->
				<div class="absolute top-3 left-3 right-3 flex gap-1 z-50">
					<div class="h-1 flex-1 bg-white/30 rounded-full overflow-hidden">
						<div id="storyProgressBar" class="h-full bg-white w-0"></div>
					</div>
				</div>

				<!-- User Header -->
				<div class="absolute top-6 left-4 right-4 flex items-center gap-3 z-50 text-white">
					<img id="storyViewerUserPic" src="" class="w-9 h-9 rounded-full border-2 border-white object-cover">
					<div>
						<p id="storyViewerUserName" class="font-bold text-sm shadow-sm"></p>
					</div>
				</div>

				<!-- Story Content Body -->
				<div class="flex-1 flex items-center justify-center relative p-4">
					<img id="storyViewerImage" src="" class="w-full h-full object-contain hidden">
					<video id="storyViewerVideo" src="" class="w-full h-full object-contain hidden" autoplay controls></video>
					
					<!-- Text-only Story overlay -->
					<div id="storyViewerTextContainer" class="w-full h-full bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600 rounded-2xl flex items-center justify-center p-6 text-center text-white hidden">
						<p id="storyViewerText" class="text-xl font-bold leading-normal"></p>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Live Stream Modal -->
	<div id="liveModal" class="modal !bg-black/95 z-[9999]">
		<div class="modal-content !max-w-[850px] !w-[95%] !bg-[#18191A] rounded-2xl shadow-2xl overflow-hidden border border-gray-700 p-0">
			<!-- Header -->
			<div class="flex items-center justify-between p-4 border-b border-gray-700">
				<div class="flex items-center gap-3">
                    <div class="w-3 h-3 bg-red-600 rounded-full animate-pulse"></div>
                    <h2 class="text-xl font-bold text-white">Live Broadcast</h2>
                </div>
				<button onclick="closeLiveModal()" class="w-8 h-8 rounded-full bg-gray-700 hover:bg-gray-600 flex items-center justify-center text-white transition">
                    <i class="fa fa-times"></i>
                </button>
			</div>

			<!-- Main Content Area -->
			<div class="flex flex-col md:flex-row h-[65vh] min-h-[450px]">
                <!-- Video Section -->
				<div class="flex-1 relative bg-black flex items-center justify-center overflow-hidden">
                    <video id="liveVideo" autoplay muted playsinline class="w-full h-full object-cover transform scale-x-[-1]"></video>
                    
                    <!-- Overlay Elements -->
                    <div class="absolute top-4 left-4 flex gap-2">
                        <span id="liveBadge" class="hidden bg-red-600 text-white px-3 py-1 rounded-md text-sm font-bold uppercase tracking-wider shadow-lg animate-pulse">LIVE</span>
                        <span id="liveTimer" class="hidden bg-black/60 backdrop-blur-sm text-white px-3 py-1 rounded-md text-sm font-bold">00:00</span>
                    </div>
                    <div class="absolute top-4 right-4 flex gap-2">
                        <span id="liveViewers" class="hidden bg-black/60 backdrop-blur-sm text-white px-3 py-1 rounded-md text-sm font-bold flex items-center gap-2">
                            <i class="fa fa-eye text-red-500"></i> <span id="viewerCount">0</span>
                        </span>
                    </div>

                    <!-- Setup Overlay -->
                    <div id="liveSetupOverlay" class="absolute inset-0 bg-black/80 backdrop-blur-sm flex flex-col items-center justify-center z-10 p-6">
                        <i class="fa fa-video text-6xl text-gray-400 mb-4 animate-bounce"></i>
                        <h3 class="text-white text-2xl font-bold mb-2">Camera Setup</h3>
                        <p class="text-gray-400 text-center text-sm mb-6 max-w-md">Allow camera and microphone access to start your live broadcast.</p>
                        <button onclick="requestCameraAccess()" class="bg-blue-600 hover:bg-blue-700 text-white px-8 py-3 rounded-xl font-bold transition shadow-[0_0_20px_rgba(37,99,235,0.4)] flex items-center gap-2 hover:scale-105">
                            <i class="fa fa-camera"></i> Enable Camera
                        </button>
                    </div>
                </div>

                <!-- Chat/Control Section -->
                <div class="w-full md:w-[320px] border-l border-gray-700 flex flex-col bg-[#242526]">
                    <div class="p-4 border-b border-gray-700">
                        <h3 class="text-white font-bold mb-2 text-sm uppercase tracking-wider">Stream Details</h3>
                        <input type="text" id="liveTitle" placeholder="What's your live about?" class="w-full bg-[#3A3B3C] text-white outline-none p-3 rounded-xl text-sm border border-transparent focus:border-blue-500 transition shadow-inner">
                    </div>

                    <!-- Simulated Chat -->
                    <div id="liveChatBox" class="flex-1 p-4 overflow-y-auto space-y-3 hidden custom-scrollbar">
                        <!-- Chat messages will appear here -->
                    </div>
                    <div id="chatPlaceholder" class="flex-1 flex flex-col items-center justify-center text-gray-500">
                        <i class="fa fa-comment-slash text-4xl mb-3 opacity-30"></i>
                        <p class="text-sm font-medium">Live chat will appear here</p>
                    </div>

                    <div class="p-4 border-t border-gray-700 bg-[#18191A]">
                        <button id="goLiveBtn" disabled onclick="startLiveStream()" class="w-full bg-red-600 hover:bg-red-700 disabled:opacity-50 disabled:cursor-not-allowed text-white font-bold py-3.5 rounded-xl transition shadow-[0_0_15px_rgba(220,38,38,0.4)] flex items-center justify-center gap-2">
                            <i class="fa fa-broadcast-tower"></i> Go Live Now
                        </button>
                        <button id="endLiveBtn" onclick="endLiveStream()" class="w-full hidden bg-gray-700 hover:bg-gray-600 text-white font-bold py-3.5 rounded-xl transition shadow-lg flex items-center justify-center gap-2">
                            <i class="fa fa-stop-circle text-red-500"></i> End Broadcast
                        </button>
                    </div>
                </div>
			</div>
		</div>
	</div>

	<!-- Create Post Modal -->
	<div id="postModal" class="modal">
		<div
			class="modal-content !max-w-[500px] !w-[95%] aspect-square flex flex-col bg-white rounded-2xl shadow-[0_20px_50px_rgba(0,0,0,0.3)] transform transition-all">

			<!-- Modal Header -->
			<div class="flex items-center justify-between p-4 border-b">
				<h2 class="text-xl font-bold text-center flex-1 text-gray-800">Create
					Post</h2>
				<button onclick="closeModal()"
					class="bg-gray-100 hover:bg-red-100 hover:text-red-600 rounded-full p-2 w-9 h-9 flex items-center justify-center transition-all">
					<i class="fa fa-xmark text-lg"></i>
				</button>
			</div>

			<form id="postForm" action="UsersPostServlet" method="post"
				enctype="multipart/form-data"
				class="p-5 flex flex-col flex-1 overflow-y-auto">

				<!-- User Info -->
				<div class="flex items-center gap-3 mb-4">
					<div class="relative">
						<img src="img/${ub.profile_pic}"
							class="w-11 h-11 rounded-full border-2 border-blue-500 shadow-sm">
					</div>
					<div>
						<p class="font-bold text-gray-800">${ub.name}</p>
						<div class="flex gap-2">
							<!-- Feeling Indicator -->
							<div
								class="flex items-center gap-1 bg-gray-100 px-2 py-0.5 rounded-md">
								<i class="fa fa-face-smile text-yellow-500 text-xs"></i> <select
									name="feeling"
									class="text-[11px] font-bold bg-transparent outline-none cursor-pointer text-gray-600">
									<option value="">Feeling</option>
									<option value="Happy">😊 Happy</option>
									<option value="Loved">😍 Loved</option>
									<option value="Haha">😆 Haha</option>
									<option value="Wow">😯 Wow</option>
									<option value="Sad">😢 Sad!</option>
								</select>
							</div>
							<!-- Tag Indicator (New) -->
							<div id="tagBadge"
								class="hidden flex items-center gap-1 bg-blue-50 px-2 py-0.5 rounded-md">
								<i class="fa fa-user-tag text-blue-500 text-xs"></i> <span
									class="text-[11px] font-bold text-blue-600">Friends
									Tagged</span>
							</div>
						</div>
					</div>
				</div>

				<!-- Text Area -->
				<textarea name="content"
					placeholder="What's on your mind, ${ub.name}?"
					class="w-full flex-1 text-xl outline-none resize-none placeholder-gray-400 text-gray-700 min-h-[100px]"></textarea>

				<!-- 👥 Friends Tag Selection (এটি লুকানো থাকবে, ক্লিক করলে আসবে) -->
				<div id="tagSection"
					class="hidden mb-3 p-3 bg-blue-50 rounded-xl border border-blue-100 shadow-inner">
					<p class="text-xs font-bold text-blue-600 mb-2">Tag Friends:</p>
					<select name="taggedFriends" multiple
						class="w-full bg-white border-none rounded-lg text-sm p-2 outline-none h-20 shadow-sm">
						<option value="1">Sakura</option>
						<option value="2">John Doe</option>
						<option value="3">Alex</option>
					</select>
				</div>

				<!-- Image/Video Preview -->
				<div id="modalPreviewContainer"
					class="hidden relative mt-2 mb-2 rounded-xl overflow-hidden border-2 border-blue-50 shadow-inner">
					<button type="button" onclick="removeModalPreview()"
						class="absolute top-2 right-2 bg-black/50 text-white hover:bg-red-500 rounded-full w-7 h-7 flex items-center justify-center z-10 transition-all">×</button>
					<img id="modalImagePreview" src="#"
						class="w-full h-auto object-cover max-h-[180px]">
				</div>

				<!-- 🌈 কালারফুল ৩ডি "Add to Post" বক্স -->
				<div
					class="mt-auto p-3 border-2 border-gray-100 rounded-2xl flex items-center justify-between shadow-sm bg-gradient-to-r from-white to-gray-50">
					<span class="font-bold text-gray-700 text-sm pl-2">Add to
						your post</span>
					<div class="flex gap-2">
						<!-- Photo/Video Icon (Glossy Green) -->
						<div title="Photo/Video"
							onclick="document.getElementById('modalFileInput').click()"
							class="w-10 h-10 flex items-center justify-center rounded-xl bg-green-50 text-green-600 hover:bg-green-500 hover:text-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 cursor-pointer">
							<i class="fa fa-image text-xl"></i>
						</div>
						<!-- Tag Friends Icon (Glossy Blue) -->
						<div title="Tag Friends" onclick="toggleTagSection()"
							class="w-10 h-10 flex items-center justify-center rounded-xl bg-blue-50 text-blue-600 hover:bg-blue-500 hover:text-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 cursor-pointer">
							<i class="fa fa-user-tag text-xl"></i>
						</div>
						<!-- Feeling/Activity Icon (Glossy Yellow) -->
						<div title="Feeling"
							class="w-10 h-10 flex items-center justify-center rounded-xl bg-yellow-50 text-yellow-600 hover:bg-yellow-500 hover:text-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 cursor-pointer">
							<i class="fa fa-face-smile text-xl"></i>
						</div>
					</div>
				</div>

				<input type="file" name="media" id="modalFileInput" class="hidden"
					accept="image/*,video/*" onchange="previewModalImage(this)">

				<button type="submit"
					class="w-full bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white font-bold py-3 rounded-xl mt-4 shadow-lg active:scale-95 transition-all">
					Post</button>
			</form>
		</div>
	</div>

	<!-- Live Video Modal -->
	<div id="liveModal" class="modal z-[10000]">
		<div class="modal-content !max-w-[800px] !w-[95%] bg-black text-white rounded-2xl shadow-2xl p-0 overflow-hidden flex flex-col md:flex-row h-[80vh]">
			<!-- Video Section -->
			<div id="liveVideoContainer" class="flex-1 relative bg-gray-900 flex flex-col justify-center items-center overflow-hidden">
				<video id="liveVideo" autoplay muted playsinline class="w-full h-full object-cover"></video>
				
				<!-- Floating Emoji Container -->
				<div id="floatingEmojiContainer" class="absolute inset-0 pointer-events-none z-10"></div>
				
				<!-- Floating Reaction Panel (Visible when live) -->
				<div id="liveReactionPanel" class="hidden absolute bottom-4 left-1/2 -translate-x-1/2 bg-black/60 backdrop-blur-md rounded-full px-4 py-2 flex gap-3 z-20 transition-all border border-white/10 hover:bg-black/80">
					<span class="cursor-pointer hover:scale-150 transition-transform text-lg" onclick="triggerLiveReaction('Like')">👍</span>
					<span class="cursor-pointer hover:scale-150 transition-transform text-lg" onclick="triggerLiveReaction('Love')">❤️</span>
					<span class="cursor-pointer hover:scale-150 transition-transform text-lg" onclick="triggerLiveReaction('Care')">🥰</span>
					<span class="cursor-pointer hover:scale-150 transition-transform text-lg" onclick="triggerLiveReaction('Haha')">😆</span>
					<span class="cursor-pointer hover:scale-150 transition-transform text-lg" onclick="triggerLiveReaction('Wow')">😮</span>
					<span class="cursor-pointer hover:scale-150 transition-transform text-lg" onclick="triggerLiveReaction('Sad')">😢</span>
					<span class="cursor-pointer hover:scale-150 transition-transform text-lg" onclick="triggerLiveReaction('Angry')">😡</span>
					<span class="cursor-pointer hover:scale-150 transition-transform text-lg" onclick="triggerLiveReaction('Dislike')">👎</span>
				</div>

				<!-- Live Badges (Hidden Initially) -->
				<div class="absolute top-4 left-4 flex gap-2 z-10">
					<div id="liveBadge" class="hidden bg-red-600 text-white font-bold text-xs px-3 py-1 rounded-md animate-pulse">LIVE</div>
					<div id="liveTimer" class="hidden bg-black/50 text-white text-xs px-3 py-1 rounded-md font-mono">00:00</div>
					<div id="liveViewers" class="hidden bg-black/50 text-white text-xs px-3 py-1 rounded-md flex items-center gap-1">
						<i class="fa fa-eye"></i> <span id="viewerCount">0</span>
					</div>
				</div>

				<button type="button" onclick="closeLiveModal()" class="absolute top-4 right-4 w-8 h-8 rounded-full bg-black/50 text-white flex items-center justify-center hover:bg-red-500 z-10 transition">×</button>
			</div>

			<!-- Sidebar / Chat Section -->
			<div class="w-full md:w-[300px] bg-[#242526] flex flex-col border-l border-white/10 relative">
				<div class="p-4 border-b border-white/10">
					<h3 class="font-bold text-lg mb-2">Live Broadcast Setup</h3>
					<input type="text" id="liveTitle" placeholder="Describe your live video..." class="w-full bg-[#3A3B3C] text-white rounded-lg p-2 text-sm outline-none">
				</div>

				<!-- Setup Overlay (Before going live) -->
				<div id="liveSetupOverlay" class="absolute inset-0 top-[100px] bg-[#242526] z-20 flex flex-col items-center justify-center p-6 text-center">
					<div class="w-16 h-16 rounded-full bg-blue-500/20 text-blue-500 flex items-center justify-center text-2xl mb-4 cursor-pointer hover:bg-blue-500 hover:text-white transition" onclick="requestCameraAccess()">
						<i class="fa fa-video"></i>
					</div>
					<h4 class="font-bold mb-2">Camera Access Required</h4>
					<p class="text-xs text-gray-400 mb-4">Click the camera icon to allow access and preview your video before going live.</p>
				</div>

				<!-- Chat Area -->
				<div class="flex-1 overflow-y-auto p-4 flex flex-col gap-3 relative">
					<div id="chatPlaceholder" class="absolute inset-0 flex items-center justify-center text-gray-500 text-sm">
						Chat will appear here once live
					</div>
					<div id="liveChatBox" class="hidden flex-col gap-3 flex-1 overflow-y-auto"></div>
				</div>

				<!-- Live Chat Input (Hidden initially, visible when live) -->
				<div id="liveChatInputArea" class="hidden p-3 border-t border-white/10 flex gap-2">
					<input type="text" id="liveChatInput" placeholder="Write a comment..." class="flex-1 bg-[#3A3B3C] text-white rounded-full px-4 py-1.5 text-xs outline-none border border-transparent focus:border-blue-500" onkeydown="if(event.key === 'Enter') sendLiveComment()">
					<button onclick="sendLiveComment()" class="bg-blue-600 hover:bg-blue-700 text-white w-7 h-7 rounded-full flex items-center justify-center transition">
						<i class="fa fa-paper-plane text-xs"></i>
					</button>
				</div>

				<!-- Bottom Actions -->
				<div class="p-4 border-t border-white/10">
					<button type="button" id="goLiveBtn" onclick="startLiveStream()" disabled class="w-full bg-blue-600 hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed text-white font-bold py-3 rounded-xl transition">Go Live</button>
					<button type="button" id="endLiveBtn" onclick="endLiveStream()" class="hidden w-full bg-red-600 hover:bg-red-700 text-white font-bold py-3 rounded-xl transition">End Live Video</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Create Reel Modal -->
	<div id="reelModal" class="modal">
		<div class="modal-content !max-w-[450px] !w-[95%] bg-white rounded-2xl shadow-2xl p-0 overflow-hidden">
			<div class="flex items-center justify-between p-4 border-b">
				<h2 class="text-xl font-bold">Create Reel</h2>
				<button onclick="closeReelModal()" class="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center">×</button>
			</div>
			<form id="reelForm" action="UsersPostServlet" method="post" enctype="multipart/form-data" class="p-6">
				<input type="hidden" name="type" value="REEL">
				<div class="border-2 border-dashed border-gray-200 rounded-xl p-8 text-center cursor-pointer hover:bg-gray-50 transition"
					 onclick="document.getElementById('reelVideoInput').click()">
					<i class="fa fa-clapperboard text-4xl text-blue-500 mb-2"></i>
					<p class="text-gray-500 font-medium">Click to select a video for your Reel</p>
					<p class="text-xs text-gray-400 mt-1">Short vertical videos work best!</p>
				</div>
				<input type="file" name="media" id="reelVideoInput" class="hidden" accept="video/*" onchange="previewReel(this)">
				<div id="reelPreview" class="hidden mt-4 rounded-xl overflow-hidden bg-black aspect-[9/16]">
					<video id="reelVideoPreview" class="w-full h-full object-contain" controls></video>
				</div>
				<textarea name="content" placeholder="Describe your reel..." class="w-full mt-4 p-3 border rounded-xl outline-none resize-none h-20 text-sm"></textarea>
				<button type="submit" class="w-full bg-blue-600 text-white font-bold py-3 rounded-xl mt-6 shadow-lg hover:bg-blue-700">Share Reel</button>
			</form>
		</div>
	</div>

	<!-- Reel Viewer Modal -->
	<div id="reelViewer" class="modal !bg-black/95">
		<div class="relative w-full h-full flex items-center justify-center">
			<button onclick="closeReelViewer()" class="absolute top-6 right-6 text-white text-4xl z-50">×</button>
			<div class="h-[90vh] aspect-[9/16] bg-black rounded-2xl overflow-hidden relative shadow-2xl">
				<video id="viewerVideo" class="w-full h-full object-contain" loop autoplay controls></video>
				<div class="absolute bottom-0 left-0 right-0 p-6 bg-gradient-to-t from-black/80 to-transparent text-white">
					<div class="flex items-center gap-3 mb-2">
						<img id="viewerUserPic" src="" class="w-10 h-10 rounded-full border-2 border-white">
						<span id="viewerUserName" class="font-bold"></span>
					</div>
					<p id="viewerContent" class="text-sm"></p>
				</div>
			</div>
		</div>
	</div>

	<script>
    var contextPath = "${pageContext.request.contextPath}";

    // --- Live Stream Functions ---
    let liveStream = null;
    let liveInterval = null;
    let liveTimerSeconds = 0;
    let fakeViewers = 0;
    let fakeCommentsInterval = null;
    let mediaRecorder = null;
    let recordedChunks = [];

    function openLiveModal() {
        document.getElementById('liveModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeLiveModal() {
        document.getElementById('liveModal').style.display = 'none';
        document.body.style.overflow = 'auto';
        if (liveStream && document.getElementById('endLiveBtn').classList.contains('hidden') == false) {
            endLiveStream();
        }
        
        if (liveStream) {
            liveStream.getTracks().forEach(track => track.stop());
            document.getElementById('liveVideo').srcObject = null;
        }
        resetLiveUI();
    }

    function requestCameraAccess() {
        let handleStream = function(stream) {
            liveStream = stream;
            let video = document.getElementById('liveVideo');
            if(stream) {
                video.srcObject = stream;
                video.play();
            } else {
                video.style.display = 'none';
                let placeholder = document.createElement('div');
                placeholder.id = "liveFallbackBox";
                placeholder.className = 'w-full h-full flex flex-col items-center justify-center text-gray-500 bg-black/50 absolute inset-0';
                placeholder.innerHTML = '<i class="fa fa-video-slash text-6xl mb-4 opacity-50"></i><p class="font-bold text-lg">Camera Not Available</p><p class="text-xs mt-2">Simulated Broadcast Mode Active</p>';
                video.parentNode.appendChild(placeholder);
            }
            
            document.getElementById('liveSetupOverlay').classList.add('hidden');
            document.getElementById('goLiveBtn').disabled = false;
        };

        if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
            navigator.mediaDevices.getUserMedia({ video: true, audio: true })
            .then(handleStream)
            .catch(function(err) {
                console.warn("Audio/Video failed, trying Video only...", err);
                navigator.mediaDevices.getUserMedia({ video: true, audio: false })
                .then(handleStream)
                .catch(function(err2) {
                    console.error("Camera access failed entirely:", err2);
                    handleStream(null);
                });
            });
        } else {
            console.warn("Browser restricts camera access.");
            handleStream(null);
        }
    }

    function startLiveStream() {
        let title = document.getElementById('liveTitle').value.trim();
        if(!title) title = "Live Broadcast";

        if (liveStream) {
            recordedChunks = [];
            mediaRecorder = new MediaRecorder(liveStream, { mimeType: 'video/webm' });
            mediaRecorder.ondataavailable = function(e) {
                if (e.data.size > 0) {
                    recordedChunks.push(e.data);
                }
            };
            mediaRecorder.start();
        }

        document.getElementById('goLiveBtn').classList.add('hidden');
        document.getElementById('endLiveBtn').classList.remove('hidden');
        document.getElementById('liveTitle').disabled = true;

        // Show live badges, reaction panel and chat input area
        document.getElementById('liveBadge').classList.remove('hidden');
        document.getElementById('liveTimer').classList.remove('hidden');
        document.getElementById('liveViewers').classList.remove('hidden');
        document.getElementById('chatPlaceholder').classList.add('hidden');
        document.getElementById('liveChatBox').classList.remove('hidden');
        document.getElementById('liveReactionPanel').classList.remove('hidden');
        document.getElementById('liveChatInputArea').classList.remove('hidden');

        // Start timer & viewers
        liveTimerSeconds = 0;
        fakeViewers = Math.floor(Math.random() * 20) + 5;
        document.getElementById('viewerCount').innerText = fakeViewers;

        liveInterval = setInterval(() => {
            liveTimerSeconds++;
            let mins = String(Math.floor(liveTimerSeconds / 60)).padStart(2, '0');
            let secs = String(liveTimerSeconds % 60).padStart(2, '0');
            document.getElementById('liveTimer').innerText = mins + ":" + secs;
            
            if(Math.random() > 0.3) {
                fakeViewers += Math.floor(Math.random() * 8) - 2;
                if(fakeViewers < 1) fakeViewers = 1;
                document.getElementById('viewerCount').innerText = fakeViewers;
            }
        }, 1000);

        // Start fake chat and simulated reactions
        const fakeNames = ["Sakura", "John", "Alex", "Emma", "David", "Sato", "Maria"];
        const fakeMsgs = ["Awesome!", "Hello there!", "Looking great!", "Where are you streaming from?", "Nice setup!", "Wow!", "Keep it up.", "Can you show us around?", "Love this app!"];
        const fakePics = ["pic-1.png", "pic-2.png", "pic-3.png", "pic-4.png", "pic-5.png", "pic-6.png"];
        
        fakeCommentsInterval = setInterval(() => {
            let rand = Math.random();
            if(rand > 0.45) {
                let name = fakeNames[Math.floor(Math.random() * fakeNames.length)];
                let msg = fakeMsgs[Math.floor(Math.random() * fakeMsgs.length)];
                let pic = fakePics[Math.floor(Math.random() * fakePics.length)];
                appendLiveComment(name, msg, pic, false);
            } else if (rand > 0.15) {
                let name = fakeNames[Math.floor(Math.random() * fakeNames.length)];
                let emojis = ['👍', '❤️', '🥰', '😆', '😮', '😢', '😡', '👎'];
                let emoji = emojis[Math.floor(Math.random() * emojis.length)];
                
                createFloatingEmoji(emoji);
                appendLiveSystemMessage(name + " reacted with " + emoji);
            }
        }, 2200);
    }

    function sendLiveComment() {
        let input = document.getElementById('liveChatInput');
        if (!input || !input.value.trim()) return;
        
        let commentText = input.value.trim();
        let name = "${ub.name}";
        let userPic = "${ub.profile_pic}";
        
        appendLiveComment(name, commentText, userPic || 'default-avatar.png', true);
        input.value = '';
    }

    function appendLiveComment(name, text, profilePic, isSelf) {
        let nameColor = isSelf ? 'text-blue-400 font-bold' : 'text-gray-300 font-bold';
        let bgStyle = isSelf ? 'bg-blue-900/40 border border-blue-500/20' : 'bg-[#3A3B3C]';
        
        let chatHtml = 
            '<div class="flex items-start gap-2 animate-slide-in">' +
                '<img src="img/' + profilePic + '" onerror="this.src=\'https://i.imgur.com/6VBx3io.png\'" class="w-7 h-7 rounded-full border border-white/10 object-cover shadow-sm">' +
                '<div class="' + bgStyle + ' rounded-xl px-3 py-2 max-w-[85%] shadow-sm">' +
                    '<p class="text-[11px] ' + nameColor + ' mb-0.5">' + name + '</p>' +
                    '<p class="text-[13px] text-white leading-tight">' + text + '</p>' +
                '</div>' +
            '</div>';
        
        let chatBox = document.getElementById('liveChatBox');
        if (chatBox) {
            chatBox.insertAdjacentHTML('beforeend', chatHtml);
            chatBox.scrollTop = chatBox.scrollHeight;
        }
    }

    function triggerLiveReaction(type) {
        let emojiMap = {
            'Like': '👍', 'Love': '❤️', 'Care': '🥰', 'Haha': '😆', 
            'Wow': '😮', 'Sad': '😢', 'Angry': '😡', 'Dislike': '👎'
        };
        let emoji = emojiMap[type] || '👍';
        
        createFloatingEmoji(emoji);
        
        let name = "${ub.name}";
        appendLiveSystemMessage(name + " reacted with " + emoji);
    }

    function appendLiveSystemMessage(msg) {
        let chatHtml = 
            '<div class="flex items-center justify-center py-1 animate-slide-in">' +
                '<span class="text-[10px] text-gray-400 bg-white/5 px-2.5 py-1 rounded-full border border-white/5">' + msg + '</span>' +
            '</div>';
        let chatBox = document.getElementById('liveChatBox');
        if (chatBox) {
            chatBox.insertAdjacentHTML('beforeend', chatHtml);
            chatBox.scrollTop = chatBox.scrollHeight;
        }
    }

    function createFloatingEmoji(emoji) {
        let container = document.getElementById('floatingEmojiContainer');
        if (!container) return;
        
        let el = document.createElement('div');
        el.innerText = emoji;
        el.className = 'absolute text-2xl select-none pointer-events-none transition-all duration-1000 ease-out z-[99]';
        
        let startX = Math.random() * 60 + 20; 
        el.style.left = startX + '%';
        el.style.bottom = '10%';
        el.style.opacity = '1';
        el.style.transform = 'scale(0.5)';
        
        container.appendChild(el);
        
        // Force reflow
        el.offsetHeight;
        
        let endX = startX + (Math.random() * 40 - 20); 
        let endY = Math.random() * 40 + 50; 
        let scale = Math.random() * 1.5 + 0.8;
        
        el.style.left = endX + '%';
        el.style.bottom = endY + '%';
        el.style.opacity = '0';
        el.style.transform = 'scale(' + scale + ') rotate(' + (Math.random() * 40 - 20) + 'deg)';
        
        setTimeout(() => {
            el.remove();
        }, 1000);
    }

    function endLiveStream() {
        clearInterval(liveInterval);
        clearInterval(fakeCommentsInterval);
        
        let btn = document.getElementById('endLiveBtn');
        btn.innerText = "Posting Live Video...";
        btn.disabled = true;

        if (mediaRecorder && mediaRecorder.state !== "inactive") {
            mediaRecorder.onstop = function() {
                let blob = new Blob(recordedChunks, { type: "video/webm" });
                let file = new File([blob], "live_video.webm", { type: "video/webm" });
                
                let title = document.getElementById('liveTitle').value.trim();
                if(!title) title = "Live Broadcast";

                let formData = new FormData();
                formData.append("ajax", "true");
                formData.append("type", "video");
                formData.append("content", title);
                formData.append("media", file);

                fetch('UsersPostServlet?ajax=true', { method: 'POST', body: formData })
                .then(res => res.json())
                .then(data => {
                    if(data.success) {
                        alert("Live Video Posted successfully!");
                        refreshFeed();
                    } else {
                        alert("Failed to post live video!");
                    }
                })
                .catch(err => {
                    console.error("Upload error: ", err);
                    alert("Error posting video!");
                })
                .finally(() => {
                    closeLiveModal();
                });
            };
            mediaRecorder.stop();
        } else {
            closeLiveModal();
        }
    }

    function resetLiveUI() {
        document.getElementById('liveSetupOverlay').classList.remove('hidden');
        document.getElementById('goLiveBtn').disabled = true;
        document.getElementById('goLiveBtn').classList.remove('hidden');
        document.getElementById('endLiveBtn').classList.add('hidden');
        document.getElementById('endLiveBtn').innerText = "End Live Video";
        document.getElementById('endLiveBtn').disabled = false;
        document.getElementById('liveTitle').disabled = false;
        document.getElementById('liveTitle').value = '';
        
        let fallback = document.getElementById("liveFallbackBox");
        if(fallback) fallback.remove();
        document.getElementById('liveVideo').style.display = 'block';
        
        document.getElementById('liveBadge').classList.add('hidden');
        document.getElementById('liveTimer').classList.add('hidden');
        document.getElementById('liveTimer').innerText = '00:00';
        document.getElementById('liveViewers').classList.add('hidden');
        document.getElementById('viewerCount').innerText = '0';
        
        document.getElementById('chatPlaceholder').classList.remove('hidden');
        document.getElementById('liveChatBox').classList.add('hidden');
        document.getElementById('liveChatBox').innerHTML = '';
        document.getElementById('liveReactionPanel').classList.add('hidden');
        document.getElementById('liveChatInputArea').classList.add('hidden');
        
        fakeViewers = 0;
    }

    // --- Reels Functions ---
    function openReelModal() {
        const modal = document.getElementById('reelModal');
        if (modal) {
            modal.style.display = 'flex';
            document.body.style.overflow = 'hidden';
        }
    }

    function closeReelModal() {
        const modal = document.getElementById('reelModal');
        if (modal) {
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
        }
    }

    function previewReel(input) {
        const preview = document.getElementById('reelPreview');
        const video = document.getElementById('reelVideoPreview');
        if (input.files && input.files[0]) {
            const url = URL.createObjectURL(input.files[0]);
            video.src = url;
            preview.classList.remove('hidden');
        }
    }

    function openReelViewer(reelId) {
        // Fetch reel details (simple version)
        const reel = document.querySelector(`.reel-card[onclick="openReelViewer(\${reelId})"]`);
        if (reel) {
            const videoSrc = reel.querySelector('source').src;
            const userName = reel.querySelector('.reel-info').innerText;
            const userPic = reel.querySelector('.reel-user img').src;

            const viewer = document.getElementById('reelViewer');
            const viewerVideo = document.getElementById('viewerVideo');
            
            viewerVideo.src = videoSrc;
            document.getElementById('viewerUserName').innerText = userName;
            document.getElementById('viewerUserPic').src = userPic;
            
            viewer.style.display = 'flex';
        }
    }

    function closeReelViewer() {
        const viewer = document.getElementById('reelViewer');
        const viewerVideo = document.getElementById('viewerVideo');
        viewerVideo.pause();
        viewerVideo.src = "";
        viewer.style.display = 'none';
    }

    // ১. ৮টি রিঅ্যাকশন হ্যান্ডলার (পোস্ট, কমেন্ট, রিপ্লাই সবার জন্য)
    function handleAJAXReact(id, type, level, event) {
        // Prevent click bubbling to parent elements
        if (event) event.stopPropagation();

        let targetUrl = (level === 'post') ? ('${pageContext.request.contextPath}/InteractionServlet') : ('${pageContext.request.contextPath}/CommentServlet');
        
        // FormData ব্যবহার করতে হবে কারণ উভয় Servlet-এ @MultipartConfig আছে
        // @MultipartConfig থাকলে URLSearchParams দিয়ে পাঠানো data getParameter() এ পাওয়া যায় না
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
            body: formData  // Content-Type header সেট করা উচিত নয়, browser নিজে সেট করবে multipart/form-data boundary সহ
        })
        .then(res => {
            const contentType = res.headers.get('content-type');
            if (contentType && contentType.includes('application/json')) {
                return res.json();
            }
            return res.text().then(txt => { throw new Error('Non-JSON response: ' + txt.substring(0, 200)); });
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
                    let countSpan = document.getElementById(`react-count-\${id}`);
                    if (countSpan) {
                        if (data.newCount > 0) {
                            countSpan.innerHTML = countsHtml;
                        } else {
                            countSpan.innerText = '0';
                        }
                    }
                    // পোস্ট রিঅ্যাকশন বাটনে visual feedback
                    let actionBtnContent = document.getElementById(`post-action-btn-content-\${id}`);
                    if (actionBtnContent && data.newCount > 0) {
                        actionBtnContent.innerHTML = `\${activeEmoji} <span class="\${activeColor}">\${type}</span>`;
                    } else if (actionBtnContent) {
                        actionBtnContent.innerHTML = `<i class="fa-regular fa-thumbs-up"></i> Like`;
                    }
                } else {
                    // কমেন্ট বা রিপ্লাই রিঅ্যাকশন UI আপডেট
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
                console.warn('Reaction server response:', data);
            }
        })
        .catch(err => console.error('Reaction Error:', err));
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
                        <div class="flex flex-col gap-2 group/cmt mb-4">
                            <div class="flex gap-2">
                                <img src="img/\${data.userPic}" class="w-8 h-8 rounded-full border shadow-sm cursor-pointer" onclick="location.href='UsersProfileServlet?userId=\${data.userId}'">
                                <div class="flex flex-col flex-1">
                                    <div class="bg-white/50 px-4 py-2 rounded-2xl shadow-sm inline-block max-w-fit">
                                        <p class="font-bold text-[13px] hover:underline cursor-pointer" onclick="location.href='UsersProfileServlet?userId=\${data.userId}'">\${data.userName}</p>
                                        <p class="text-[14px] text-gray-700">\${data.text}</p>
                                        \${data.fileName ? '<img src="img/' + data.fileName + '" class="mt-2 rounded-xl max-h-40 border shadow-sm">' : ''}
                                    </div>
                                    <div class="flex gap-4 ml-4 mt-1 text-[11px] font-bold text-gray-500 items-center">
                                        <div class="react-container clickable">
                                            <span class="hover:text-blue-600 transition" onclick="handleAJAXReact(\${data.commentId}, 'Like', 'comment', event)">Like</span>
                                            <div class="react-box !p-1 !rounded-full">
                                                <span title="Like" onclick="handleAJAXReact(\${data.commentId}, 'Like', 'comment', event)">👍</span>
                                                <span title="Love" onclick="handleAJAXReact(\${data.commentId}, 'Love', 'comment', event)">❤️</span>
                                                <span title="Care" onclick="handleAJAXReact(\${data.commentId}, 'Care', 'comment', event)">🥰</span>
                                                <span title="Haha" onclick="handleAJAXReact(\${data.commentId}, 'Haha', 'comment', event)">😆</span>
                                                <span title="Wow" onclick="handleAJAXReact(\${data.commentId}, 'Wow', 'comment', event)">😮</span>
                                                <span title="Sad" onclick="handleAJAXReact(\${data.commentId}, 'Sad', 'comment', event)">😢</span>
                                                <span title="Angry" onclick="handleAJAXReact(\${data.commentId}, 'Angry', 'comment', event)">😡</span>
                                                <span title="Dislike" onclick="handleAJAXReact(\${data.commentId}, 'Dislike', 'comment', event)">👎</span>
                                            </div>
                                        </div>
                                        <span class="clickable hover:text-blue-600 transition" onclick="showReplyBox(\${data.commentId}, '\${escapedName}')">Reply</span>
                                        <span class="clickable hover:text-blue-600 transition" onclick="shareCommentOrReply(this)">Share</span>
                                        <div id="comment-react-container-\${data.commentId}" class="text-[10px] font-normal text-gray-400"></div>
                                    </div>

                                    <!-- Reply List -->
                                    <div id="reply-list-\${data.commentId}" class="mt-2 space-y-2 ml-10"></div>

                                    <!-- Reply Input Box -->
                                    <div id="replyInputContainer-\${data.commentId}" class="hidden mt-2 ml-10 relative">
                                        <div class="flex gap-2">
                                            <img src="img/\${data.userPic}" class="w-7 h-7 rounded-full border shadow-sm" width="28px">
                                            <div class="flex-1 bg-white/40 backdrop-blur-sm rounded-2xl px-3 py-1.5 flex items-center border border-white/20">
                                                <input type="text" id="input-reply-\${data.commentId}" placeholder="Write a reply..." class="bg-transparent outline-none flex-1 text-[12px] font-medium"
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
                                </div>
                            </div>
                        </div>`;
                    list.insertAdjacentHTML('beforeend', html);
                }
                input.value = '';
                if (fileInput) fileInput.value = '';
                removeCommentMedia(postId); // Helper to hide preview
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
                        <div class="comment-level-2 mb-2 flex gap-2">
                            <a href="UsersProfileServlet?userId=\${data.userId}">
                                <img src="img/\${data.userPic}" class="w-7 h-7 rounded-full border shadow-sm">
                            </a>
                            <div class="flex flex-col flex-1">
                                <div class="bg-white/40 px-3 py-1.5 rounded-2xl inline-block max-w-fit shadow-sm">
                                    <p class="font-bold text-[12px]"><a href="UsersProfileServlet?userId=\${data.userId}" class="hover:underline">\${data.userName}</a></p>
                                    <p class="text-[13px] text-gray-700">\${data.text}</p>
                                    \${data.fileName ? '<img src="img/' + data.fileName + '" class="mt-1 rounded-lg max-h-32 border shadow-sm">' : ''}
                                </div>
                                <div class="flex gap-4 ml-3 mt-0.5 text-[10px] font-bold text-gray-500 items-center">
                                    <div class="react-container clickable">
                                        <span class="hover:text-blue-600 transition" onclick="handleAJAXReact(\${data.replyId}, 'Like', 'reply', event)">Like</span>
                                        <div class="react-box !p-1 !rounded-full">
                                            <span title="Like" onclick="handleAJAXReact(\${data.replyId}, 'Like', 'reply', event)">👍</span>
                                            <span title="Love" onclick="handleAJAXReact(\${data.replyId}, 'Love', 'reply', event)">❤️</span>
                                            <span title="Care" onclick="handleAJAXReact(\${data.replyId}, 'Care', 'reply', event)">🥰</span>
                                            <span title="Haha" onclick="handleAJAXReact(\${data.replyId}, 'Haha', 'reply', event)">😆</span>
                                            <span title="Wow" onclick="handleAJAXReact(\${data.replyId}, 'Wow', 'reply', event)">😮</span>
                                            <span title="Sad" onclick="handleAJAXReact(\${data.replyId}, 'Sad', 'reply', event)">😢</span>
                                            <span title="Angry" onclick="handleAJAXReact(\${data.replyId}, 'Angry', 'reply', event)">😡</span>
                                            <span title="Dislike" onclick="handleAJAXReact(\${data.replyId}, 'Dislike', 'reply', event)">👎</span>
                                        </div>
                                    </div>
                                    <span class="clickable hover:text-blue-600 transition" onclick="showReplyBox(\${commentId}, '\${escapedName}')">Reply</span>
                                    <span class="clickable hover:text-blue-600 transition" onclick="shareCommentOrReply(this)">Share</span>
                                    <div id="reply-react-container-\${data.replyId}" class="text-[9px] font-normal text-gray-400"></div>
                                </div>
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

    function shareCommentOrReply(element) {
        let container = element.closest('.flex-1');
        if(container) {
            let textNode = container.querySelector('p.text-gray-700');
            if(textNode) {
                let text = textNode.innerText;
                if(!confirm("Share this comment/reply to your timeline?")) return;
                
                let formData = new FormData();
                formData.append("ajax", "true");
                formData.append("content", "Shared a comment: \"" + text + "\"");
                
                fetch('UsersPostServlet?ajax=true', { method: 'POST', body: formData })
                .then(res => res.json())
                .then(data => {
                    if(data.success) {
                        alert("Shared to your timeline successfully!");
                        refreshFeed();
                    } else {
                        alert("Failed to share.");
                    }
                })
                .catch(err => {
                    console.error("Share error: ", err);
                    alert("Error sharing comment.");
                });
            }
        }
    }

    // ৪. শেয়ার লজিক (তোর UsersPostServlet এর SHARE একশনের জন্য)
    function shareAJAX(postId) {
        if(!confirm("Share this post?")) return;
        fetch('InteractionServlet', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: "action=SHARE&postId=" + postId
        })
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
                alert("Share failed: " + data.error);
            }
        })
        .catch(err => console.error("Share error", err));
    }

    // ৫. নতুন পোস্ট সাবমিট (AJAX)
    document.getElementById('postForm')?.addEventListener('submit', function(e) {
        e.preventDefault();
        let formData = new FormData(this);
        formData.append("ajax", "true");
        
        const btn = this.querySelector('button[type="submit"]');
        const originalText = btn.innerText;
        btn.innerText = "Posting...";
        btn.disabled = true;

        fetch('UsersPostServlet?ajax=true', { method: 'POST', body: formData })
        .then(res => {
            if (!res.ok) {
                throw new Error("HTTP error " + res.status);
            }
            return res.json();
        })
        .then(data => {
            if(data.success) {
                closeModal();
                this.reset();
                removeModalPreview();
                refreshFeed(); // রিলোড ছাড়াই ফিড আপডেট
            } else {
                alert("Post failed!");
            }
        })
        .catch(err => {
            console.error("Post creation error:", err);
            alert("Post creation failed: " + err.message);
        })
        .finally(() => {
            btn.innerText = originalText;
            btn.disabled = false;
        });
    });

    // ৬. রিলস সাবমিট (AJAX)
    document.getElementById('reelForm')?.addEventListener('submit', function(e) {
        e.preventDefault();
        let formData = new FormData(this);
        formData.append("ajax", "true");
        
        const btn = this.querySelector('button[type="submit"]');
        btn.innerText = "Uploading...";
        btn.disabled = true;

        fetch('UsersPostServlet?ajax=true', { method: 'POST', body: formData })
        .then(res => {
            if (!res.ok) throw new Error("HTTP error " + res.status);
            return res.json();
        })
        .then(data => {
            if(data.success) {
                closeReelModal();
                this.reset();
                refreshFeed();
            } else {
                alert("Reel failed!");
            }
        })
        .catch(err => {
            console.error("Reel upload error:", err);
            alert("Reel upload failed: " + err.message);
        })
        .finally(() => {
            btn.innerText = "Share Reel";
            btn.disabled = false;
        });
    });

    // Delete Post Function
    function deletePost(postId) {
        if(!confirm("Are you sure you want to delete this post?")) return;
        
        let formData = new FormData();
        formData.append("action", "DELETE");
        formData.append("postId", postId);
        formData.append("ajax", "true");

        fetch('UsersPostServlet?ajax=true', { method: 'POST', body: formData })
        .then(res => {
            if (!res.ok) throw new Error("HTTP error " + res.status);
            return res.json();
        })
        .then(data => {
            if(data.success) {
                refreshFeed();
            } else {
                alert("Failed to delete post.");
            }
        })
        .catch(err => {
            console.error("Delete error: ", err);
            window.location.reload();
        });
    }

    // ৭. ফিড রিফ্রেশ ফাংশন (No Reload Logic)
    function refreshFeed() {
        fetch('UsersPostServlet')
        .then(res => res.text())
        .then(html => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');
            const newMain = doc.querySelector('main').innerHTML;
            document.querySelector('main').innerHTML = newMain;
            // টাইম-এগো এবং অন্যান্য জেএস পুনরায় চালু করার প্রয়োজন হতে পারে
            initTimeAgo(); 
        });
    }

    function initTimeAgo() {
        // যদি আপনার কোনো টাইম-এগো লাইব্রেরি থাকে তবে এখানে কল করুন
        console.log("Feed Refreshed!");
    }

    // ৫. প্রিভিউ এবং টগল ফাংশন
    function showReplyBox(id, targetName) {
        let el = document.getElementById('replyInputContainer-' + id);
        if(el) {
            el.classList.remove('hidden');
            let input = document.getElementById('input-reply-' + id);
            if(input && targetName) {
                input.value = "@" + targetName + " ";
                input.focus();
            }
        }
    }
    function focusCmt(id) { 
        let input = document.getElementById('input-post-' + id);
        if(input) input.focus(); 
    }
    function toggleTagSection() { 
        let tag = document.getElementById('tagSection');
        if(tag) tag.classList.toggle('hidden'); 
    }

    // --- Modal Functions ---
    function openModal() {
        const modal = document.getElementById('postModal');
        if (modal) {
            modal.style.display = 'flex';
            document.body.style.overflow = 'hidden'; // Prevent scrolling
        }
    }

    function closeModal() {
        const modal = document.getElementById('postModal');
        if (modal) {
            modal.style.display = 'none';
            document.body.style.overflow = 'auto'; // Restore scrolling
        }
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        const modal = document.getElementById('postModal');
        if (event.target == modal) {
            closeModal();
        }
    }

    // --- Media Preview Functions ---
    function previewModalImage(input) {
        const preview = document.getElementById('modalImagePreview');
        const container = document.getElementById('modalPreviewContainer');
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                if (preview) preview.src = e.target.result;
                if (container) container.classList.remove('hidden');
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    function removeModalPreview() {
        const input = document.getElementById('modalFileInput');
        const preview = document.getElementById('modalImagePreview');
        const container = document.getElementById('modalPreviewContainer');
        if (input) input.value = "";
        if (preview) preview.src = "#";
        if (container) container.classList.add('hidden');
    }

    function previewCommentMedia(event, postId) {
        const preview = document.getElementById('commentImgPreview-' + postId);
        const container = document.getElementById('commentPreview-' + postId);
        const file = event.target.files[0];
        if (file && preview && container) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.classList.remove('hidden');
                container.classList.remove('hidden');
            }
            reader.readAsDataURL(file);
        }
    }

    function removeCommentMedia(postId) {
        const input = document.getElementById('commentMedia-' + postId);
        const preview = document.getElementById('commentImgPreview-' + postId);
        const container = document.getElementById('commentPreview-' + postId);
        if (input) input.value = "";
        if (preview) {
            preview.src = "";
            preview.classList.add('hidden');
        }
        if (container) container.classList.add('hidden');
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

    // --- Other UI Functions ---
    function toggleEmojiPicker(id) {
        const picker = document.getElementById(id);
        if (picker) {
            // Close other pickers first
            document.querySelectorAll('[id^="emoji-picker-"]').forEach(p => {
                if (p.id !== id) p.classList.add('hidden');
            });
            picker.classList.toggle('hidden');
        }
    }

    function addEmoji(inputId, emoji) {
        const input = document.getElementById(inputId);
        if (input) {
            input.value += emoji;
            input.focus();
        }
    }
    
    function showReactionList(postId) {
        // Placeholder for reaction list
        console.log("Showing reactions for post: " + postId);
    }

    function previewMedia(event, type, id) {
        // Placeholder for other media previews
        console.log("Previewing media for " + type + " id: " + id);
    }

    // Close emoji pickers when clicking outside
    document.addEventListener('click', function(event) {
        if (!event.target.closest('.relative')) {
            document.querySelectorAll('[id^="emoji-picker-"]').forEach(p => p.classList.add('hidden'));
        }
    });

    // --- Saved Posts & Memories Features JS ---
    function toggleSavePost(postId, btn) {
        let isSaved = btn.innerText.includes("Unsave");
        let action = isSaved ? "UNSAVE" : "SAVE";
        
        fetch('FeaturesServlet?action=' + action + '&postId=' + postId, { method: 'POST' })
        .then(res => res.json())
        .then(data => {
            if(data.success) {
                if(action === "SAVE") {
                    btn.innerHTML = '<i class="fa fa-bookmark"></i> Unsave Post';
                    alert("Post Saved successfully!");
                } else {
                    btn.innerHTML = '<i class="fa fa-bookmark"></i> Save Post';
                    alert("Post Unsaved successfully!");
                }
            } else {
                alert("Action failed!");
            }
        })
        .catch(err => {
            console.error("Save error:", err);
            alert("Error processing request");
        });
    }

    function openFeaturesModal(title) {
        document.getElementById('featuresModalTitle').innerText = title;
        document.getElementById('featuresModalBody').innerHTML = '<div class="text-center py-8"><i class="fa fa-spinner animate-spin text-2xl text-blue-500"></i><p class="mt-2 text-gray-400">Loading...</p></div>';
        document.getElementById('featuresModal').style.display = 'flex';
    }

    function closeFeaturesModal() {
        document.getElementById('featuresModal').style.display = 'none';
    }

    function showSavedPostsModal() {
        openFeaturesModal("Saved Posts");
        fetch('FeaturesServlet?action=GET_SAVED')
        .then(res => res.json())
        .then(posts => {
            renderFeaturePosts(posts, "No saved posts yet. Bookmarked posts will appear here!");
        })
        .catch(err => {
            document.getElementById('featuresModalBody').innerHTML = '<p class="text-red-500 text-center">Error loading saved posts.</p>';
        });
    }

    function showMemoriesModal() {
        openFeaturesModal("Throwback Memories");
        fetch('FeaturesServlet?action=GET_MEMORIES')
        .then(res => res.json())
        .then(posts => {
            renderFeaturePosts(posts, "No memories yet. Create some posts to see throwbacks!");
        })
        .catch(err => {
            document.getElementById('featuresModalBody').innerHTML = '<p class="text-red-500 text-center">Error loading memories.</p>';
        });
    }

    function renderFeaturePosts(posts, emptyMessage) {
        const container = document.getElementById('featuresModalBody');
        if (!posts || posts.length === 0) {
            container.innerHTML = '<div class="text-center py-12 text-gray-400"><i class="fa fa-folder-open text-4xl mb-3 text-gray-500"></i><p>' + emptyMessage + '</p></div>';
            return;
        }
        
        let html = '';
        posts.forEach(p => {
            let mediaHtml = '';
            if (p.fileName) {
                if (p.postType === 'video' || p.fileName.endsWith('.webm') || p.fileName.endsWith('.mp4')) {
                    mediaHtml = '<video src="img/' + p.fileName + '" controls class="w-full max-h-[250px] object-contain bg-black rounded-lg mt-2"></video>';
                } else {
                    mediaHtml = '<img src="img/' + p.fileName + '" class="w-full max-h-[250px] object-cover rounded-lg mt-2">';
                }
            }
            
            let feelingHtml = p.feeling ? '<span class="text-xs bg-white/10 px-2 py-0.5 rounded-full text-blue-300">is feeling ' + p.feeling + '</span>' : '';
            
            html += `
                <div class="bg-[#242526] p-4 rounded-2xl border border-gray-700 space-y-3">
                    <div class="flex items-center gap-3">
                        <img src="img/\${p.profile_Pic}" class="w-10 h-10 rounded-full border border-gray-600 object-cover">
                        <div>
                            <div class="font-bold flex items-center gap-2">\${p.name} \${feelingHtml}</div>
                            <div class="text-xs text-gray-400">\${p.time}</div>
                        </div>
                    </div>
                    <p class="text-gray-200 text-sm leading-relaxed">\${p.content}</p>
                    \${mediaHtml}
                </div>
            `;
        });
        container.innerHTML = html;
    }

    // --- Stories Functions ---
    function openStoryModal() {
        document.getElementById('storyModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
    
    function closeStoryModal() {
        document.getElementById('storyModal').style.display = 'none';
        document.body.style.overflow = 'auto';
        removeStoryPreview();
    }
    
    function previewStoryMedia(input) {
        const previewImg = document.getElementById('storyImagePreview');
        const previewVideo = document.getElementById('storyVideoPreview');
        const container = document.getElementById('storyPreviewContainer');
        
        if (input.files && input.files[0]) {
            const file = input.files[0];
            const url = URL.createObjectURL(file);
            
            container.classList.remove('hidden');
            if (file.type.startsWith('video/')) {
                previewVideo.src = url;
                previewVideo.classList.remove('hidden');
                previewImg.classList.add('hidden');
                previewImg.src = "";
            } else {
                previewImg.src = url;
                previewImg.classList.remove('hidden');
                previewVideo.classList.add('hidden');
                previewVideo.src = "";
            }
        }
    }
    
    function removeStoryPreview() {
        const input = document.getElementById('storyMediaInput');
        const previewImg = document.getElementById('storyImagePreview');
        const previewVideo = document.getElementById('storyVideoPreview');
        const container = document.getElementById('storyPreviewContainer');
        
        if (input) input.value = "";
        if (previewImg) {
            previewImg.src = "#";
            previewImg.classList.add('hidden');
        }
        if (previewVideo) {
            previewVideo.src = "";
            previewVideo.classList.add('hidden');
        }
        if (container) container.classList.add('hidden');
    }

    let storyTimeout = null;
    function openStoryViewer(name, profilePic, mediaUrl, text) {
        document.getElementById('storyViewerUserName').innerText = name;
        document.getElementById('storyViewerUserPic').src = 'img/' + profilePic;
        
        const imgEl = document.getElementById('storyViewerImage');
        const videoEl = document.getElementById('storyViewerVideo');
        const textContainer = document.getElementById('storyViewerTextContainer');
        const textEl = document.getElementById('storyViewerText');
        
        imgEl.classList.add('hidden');
        videoEl.classList.add('hidden');
        textContainer.classList.add('hidden');
        
        if (mediaUrl && mediaUrl !== 'null' && mediaUrl !== '') {
            if (mediaUrl.toLowerCase().endsWith('.mp4') || mediaUrl.toLowerCase().endsWith('.webm')) {
                videoEl.src = 'img/' + mediaUrl;
                videoEl.classList.remove('hidden');
                videoEl.play();
            } else {
                imgEl.src = 'img/' + mediaUrl;
                imgEl.classList.remove('hidden');
            }
        } else {
            textEl.innerText = text;
            textContainer.classList.remove('hidden');
        }
        
        document.getElementById('storyViewerModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
        
        // Reset and trigger progress bar
        const progressBar = document.getElementById('storyProgressBar');
        progressBar.style.transition = 'none';
        progressBar.style.width = '0%';
        
        setTimeout(() => {
            progressBar.style.transition = 'width 5000ms linear';
            progressBar.style.width = '100%';
        }, 50);

        // Auto close after 5 seconds
        if (storyTimeout) clearTimeout(storyTimeout);
        storyTimeout = setTimeout(() => {
            closeStoryViewer();
        }, 5050);
    }
    
    function closeStoryViewer() {
        document.getElementById('storyViewerModal').style.display = 'none';
        document.body.style.overflow = 'auto';
        
        const videoEl = document.getElementById('storyViewerVideo');
        videoEl.pause();
        videoEl.src = "";
        
        if (storyTimeout) clearTimeout(storyTimeout);
    }
</script>



	<!-- Mobile Bottom Navigation Bar (Visible only on mobile/tablet) -->
	<nav class="lg:hidden fixed bottom-0 left-0 right-0 h-[65px] glass-nav border-t border-white/20 z-[9999] flex justify-around items-center px-4 rounded-t-3xl shadow-2xl">
		<a href="UsersPostServlet" class="flex flex-col items-center gap-1 text-blue-500">
			<i class="fa fa-house text-xl"></i>
			<span class="text-[10px] font-bold">Home</span>
		</a>
		<a href="FriendServlet" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
			<i class="fa fa-user-group text-xl"></i>
			<span class="text-[10px] font-bold">Friends</span>
		</a>
		<a href="#" onclick="openLiveModal(); return false;" class="flex flex-col items-center gap-1 text-red-500 animate-pulse">
			<i class="fa fa-video text-xl"></i>
			<span class="text-[10px] font-bold">Go Live</span>
		</a>
		<a href="messages.jsp" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
			<i class="fa-brands fa-facebook-messenger text-xl"></i>
			<span class="text-[10px] font-bold">Messenger</span>
		</a>
		<a href="UsersProfileServlet?userId=${sessionScope.userId}" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
			<img src="img/${ub.profile_pic}" class="w-6 h-6 rounded-full border border-gray-300">
			<span class="text-[10px] font-bold">Profile</span>
		</a>
	</nav>

</body>
</html>