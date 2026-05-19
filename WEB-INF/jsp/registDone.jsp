<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    <title>Registration Complete | Y-Chat</title>
    
    <!-- Tailwind CSS & FontAwesome -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    
    <!-- Canvas Confetti CDN -->
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>

    <style>
        body {
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%;
            animation: gradient 15s ease infinite;
            font-family: 'Outfit', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            overflow: hidden;
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
            transform: translateY(30px);
            opacity: 0;
            animation: slideUpFade 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }

        @keyframes slideUpFade {
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        /* Animated Checkmark CSS */
        .checkmark__circle {
            stroke-dasharray: 166;
            stroke-dashoffset: 166;
            stroke-width: 2;
            stroke-miterlimit: 10;
            stroke: #10b981;
            fill: none;
            animation: stroke 0.6s cubic-bezier(0.65, 0, 0.45, 1) forwards;
        }

        .checkmark {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: block;
            stroke-width: 2;
            stroke: #fff;
            stroke-miterlimit: 10;
            margin: 0 auto 24px;
            box-shadow: inset 0px 0px 0px #10b981;
            animation: fill .4s ease-in-out .4s forwards, scale .3s ease-in-out .9s forwards;
        }

        .checkmark__check {
            transform-origin: 50% 50%;
            stroke-dasharray: 48;
            stroke-dashoffset: 48;
            animation: stroke 0.3s cubic-bezier(0.65, 0, 0.45, 1) 0.8s forwards;
        }

        @keyframes stroke {
            100% {
                stroke-dashoffset: 0;
            }
        }
        @keyframes scale {
            0%, 100% {
                transform: none;
            }
            50% {
                transform: scale3d(1.1, 1.1, 1);
            }
        }
        @keyframes fill {
            100% {
                box-shadow: inset 0px 0px 0px 40px #10b981;
            }
        }
    </style>
</head>
<body>

    <div class="glass-card max-w-[450px] w-[90%] p-8 rounded-3xl text-center relative overflow-hidden">
        <!-- Background Glow Ornaments -->
        <div class="absolute -top-10 -right-10 w-24 h-24 bg-pink-300 rounded-full blur-2xl opacity-50"></div>
        <div class="absolute -bottom-10 -left-10 w-24 h-24 bg-blue-300 rounded-full blur-2xl opacity-50"></div>

        <!-- Success Animation -->
        <div class="relative z-10">
            <svg class="checkmark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 52 52">
                <circle class="checkmark__circle" cx="26" cy="26" r="25" fill="none"/>
                <path class="checkmark__check" fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8"/>
            </svg>
        </div>

        <!-- Welcome Message -->
        <h1 class="text-3xl font-extrabold bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-3">
            Welcome to Y-Chat!
        </h1>
        
        <p class="text-gray-700 text-sm font-medium mb-6 leading-relaxed">
            Congratulations! Your registration is complete. <br>
            Get ready to connect, share, and chat with your friends!
        </p>

        <!-- Divider -->
        <div class="w-full h-[1px] bg-gray-200/60 mb-6"></div>

        <!-- Action Button -->
        <a href="UsersLoginServlet" class="group relative inline-flex items-center justify-center w-full bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white font-bold py-3.5 px-6 rounded-2xl shadow-lg hover:shadow-xl active:scale-95 transition-all duration-200">
            <span>Log In & Get Started</span>
            <i class="fa fa-arrow-right ml-2 group-hover:translate-x-1 transition-transform"></i>
        </a>
    </div>

    <script>
        // Start confetti explosion
        window.addEventListener('load', () => {
            setTimeout(() => {
                // Initial burst
                confetti({
                    particleCount: 150,
                    spread: 80,
                    origin: { y: 0.6 }
                });
                
                // Side bursts
                setTimeout(() => {
                    confetti({
                        particleCount: 80,
                        angle: 60,
                        spread: 55,
                        origin: { x: 0, y: 0.8 }
                    });
                }, 250);

                setTimeout(() => {
                    confetti({
                        particleCount: 80,
                        angle: 120,
                        spread: 55,
                        origin: { x: 1, y: 0.8 }
                    });
                }, 400);

            }, 1000);

            // Repeat occasional small celebration confetti
            setInterval(() => {
                confetti({
                    particleCount: 30,
                    spread: 50,
                    origin: { x: Math.random(), y: Math.random() - 0.2 }
                });
            }, 3000);
        });
    </script>
</body>
</html>