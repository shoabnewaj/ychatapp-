<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration | Y-Chat</title>
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    
    <!-- Tailwind CSS & FontAwesome -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%;
            animation: gradient 15s ease infinite;
            font-family: 'Outfit', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.75) !important;
            backdrop-filter: blur(20px) !important;
            border: 1px solid rgba(255, 255, 255, 0.4) !important;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15) !important;
        }

        .custom-file-upload {
            border: 2px dashed #1877f2;
            background: rgba(24, 119, 242, 0.05);
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .custom-file-upload:hover {
            background: rgba(24, 119, 242, 0.12);
            border-color: #166fe5;
            transform: scale(1.02);
        }
    </style>
</head>
<body>

<div class="flex flex-col md:flex-row items-center justify-center gap-12 max-w-[900px] w-[95%] p-4">
    <!-- Left Section -->
    <div class="text-white text-center md:text-left md:max-w-[400px]">
        <h1 class="text-6xl font-extrabold tracking-tight mb-4 drop-shadow-md">Y-Chat</h1>
        <p class="text-xl font-medium opacity-90 leading-relaxed drop-shadow-sm">Create your account and start sharing with your new friends! 🚀</p>
    </div>

    <!-- Right Section (Card) -->
    <div class="glass-card w-full max-w-[400px] p-8 rounded-3xl relative overflow-hidden">
        <!-- Glow Ornaments -->
        <div class="absolute -top-10 -right-10 w-24 h-24 bg-pink-300 rounded-full blur-2xl opacity-40"></div>
        <div class="absolute -bottom-10 -left-10 w-24 h-24 bg-blue-300 rounded-full blur-2xl opacity-40"></div>

        <h2 class="text-2xl font-bold text-gray-800 text-center mb-6 relative z-10">Sign Up</h2>

        <form action="UsersRegistServlet" method="post" enctype="multipart/form-data" class="space-y-4 relative z-10">
            <div>
                <input type="text" name="name" placeholder="Your Name" value="${usersBeans.name}" required
                       class="w-full px-4 py-3 rounded-xl border border-gray-300/80 outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 bg-white/70 transition-all text-sm">
                <div class="text-red-500 text-xs font-semibold mt-1 pl-1">${errorMsg_name}</div>
            </div>

            <div>
                <input type="email" name="email" placeholder="Email address" value="${usersBeans.email}" required
                       class="w-full px-4 py-3 rounded-xl border border-gray-300/80 outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 bg-white/70 transition-all text-sm">
            </div>

            <div>
                <input type="password" name="pass" placeholder="Password (4-12 characters)" required
                       class="w-full px-4 py-3 rounded-xl border border-gray-300/80 outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 bg-white/70 transition-all text-sm">
                <div class="text-red-500 text-xs font-semibold mt-1 pl-1">${errorMsg_pass}</div>
            </div>

            <!-- Beautiful File Upload Input -->
            <div class="space-y-2">
                <label class="text-xs font-bold text-gray-600 uppercase tracking-wider block">Profile Picture (Optional)</label>
                
                <label for="profile_pic_input" class="custom-file-upload flex flex-col items-center justify-center py-5 px-4 rounded-2xl cursor-pointer text-blue-600 select-none">
                    <div id="upload-icon-container" class="flex flex-col items-center gap-2">
                        <i class="fa fa-camera text-2xl animate-bounce"></i>
                        <span class="text-xs font-bold">Choose a Profile Photo</span>
                    </div>
                    
                    <!-- Preview Container -->
                    <div id="preview-container" class="hidden flex-col items-center gap-2">
                        <img id="profile-pic-preview" src="#" alt="Preview" class="w-16 h-16 rounded-full object-cover border-2 border-blue-500 shadow-md">
                        <span id="file-name-text" class="text-xs text-gray-600 font-semibold truncate max-w-[200px]"></span>
                        <span class="text-[10px] text-blue-600 font-bold underline">Change Photo</span>
                    </div>
                </label>
                <input type="file" id="profile_pic_input" name="profile_pic" accept="image/*" onchange="previewProfilePic(this)" class="hidden">
            </div>

            <div class="text-red-500 text-xs font-semibold text-center">${errorMsg}</div>

            <button type="submit" class="w-full bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white font-bold py-3.5 rounded-2xl shadow-md hover:shadow-lg active:scale-95 transition-all duration-150 text-sm">
                Create Account
            </button>
        </form>

        <div class="w-full h-[1px] bg-gray-200/60 my-6 relative z-10"></div>

        <a href="UsersLoginServlet" class="block text-center text-sm font-bold text-blue-600 hover:text-blue-700 hover:underline transition-colors relative z-10">
            ← Back to Login
        </a>
    </div>
</div>

<script>
    function previewProfilePic(input) {
        const iconContainer = document.getElementById('upload-icon-container');
        const previewContainer = document.getElementById('preview-container');
        const previewImage = document.getElementById('profile-pic-preview');
        const fileNameText = document.getElementById('file-name-text');
        
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            
            reader.onload = function(e) {
                previewImage.src = e.target.result;
                fileNameText.textContent = input.files[0].name;
                iconContainer.classList.add('hidden');
                previewContainer.classList.remove('hidden');
                previewContainer.classList.add('flex');
            }
            
            reader.readAsDataURL(input.files[0]);
        } else {
            iconContainer.classList.remove('hidden');
            previewContainer.classList.add('hidden');
            previewContainer.classList.remove('flex');
        }
    }
</script>

</body>
</html>