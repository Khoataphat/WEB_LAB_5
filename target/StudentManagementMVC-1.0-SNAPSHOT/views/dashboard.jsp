<%-- 
    Document   : dashboard
    Created on : 24 thg 11, 2025, 09:10:40
    Author     : Admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // 1. Get theme from cookie, default to 'light'
    String currentTheme = "light";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("user_theme".equals(cookie.getName())) {
                String cookieValue = cookie.getValue();
                if ("light".equals(cookieValue) || "dark".equals(cookieValue)) {
                    currentTheme = cookieValue;
                }
                break;
            }
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Dashboard</title>
        <style>
            /* CSS Variables for Dynamic Colors */
            :root {
                /* Light Mode Defaults */
                --bg-body: #f5f5f5;
                --bg-navbar: #2c3e50;
                --bg-card: white;
                --text-color: #2c3e50;
                --text-muted: #7f8c8d;
                --shadow-color: rgba(0,0,0,0.1);
            }

            /* Dark Mode Overrides applied via .theme-dark class on <body> */
            .theme-dark {
                --bg-body: #212529; /* Dark Gray */
                --bg-navbar: #34495e; /* Blue-Gray */
                --bg-card: #2c3e50; /* Slightly lighter card for contrast */
                --text-color: #ecf0f1; /* Light White */
                --text-muted: #bdc3c7; /* Muted Light Gray */
                --shadow-color: rgba(0,0,0,0.4);
            }

            /* --- Global Base Styles --- */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: var(--bg-body); /* Use variable */
                color: var(--text-color); /* Use variable */
                transition: background-color 0.3s, color 0.3s;
            }

            /* ... (Keep existing dashboard styles, ensuring they use CSS variables) ... */

            .navbar {
                background: var(--bg-navbar); /* Use variable */
                color: white;
                padding: 15px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                transition: background-color 0.3s;
            }

            .navbar h2 {
                font-size: 20px;
            }

            .navbar-right {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .user-info {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .role-badge {
                padding: 4px 12px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 600;
            }

            .role-admin {
                background: #e74c3c;
            }

            .role-user {
                background: #3498db;
            }

            .btn-logout {
                padding: 8px 20px;
                background: #e74c3c;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                font-size: 14px;
                transition: background 0.3s;
            }

            .btn-logout:hover {
                background: #c0392b;
            }

            .container {
                max-width: 1200px;
                margin: 30px auto;
                padding: 0 20px;
            }

            /* Card Styles updated to use variables */
            .welcome-card, .stat-card, .quick-actions {
                background: var(--bg-card); /* Use variable */
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px var(--shadow-color); /* Use variable */
                margin-bottom: 30px;
                transition: background-color 0.3s, box-shadow 0.3s;
            }

            .welcome-card h1, .quick-actions h2 {
                color: var(--text-color); /* Use variable */
                margin-bottom: 10px;
                transition: color 0.3s;
            }

            .welcome-card p {
                color: var(--text-muted); /* Use variable */
                transition: color 0.3s;
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                padding: 25px;
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .stat-icon {
                font-size: 40px;
                width: 60px;
                height: 60px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 10px;
            }

            .stat-icon-students {
                background: #e8f4fd;
            }

            .stat-content h3 {
                font-size: 28px;
                color: var(--text-color); /* Use variable */
                margin-bottom: 5px;
                transition: color 0.3s;
            }

            .stat-content p {
                color: var(--text-muted); /* Use variable */
                font-size: 14px;
                transition: color 0.3s;
            }

            /* --- Theme Switcher Specific Styles --- */
            .theme-switcher {
                display: flex;
                border: 1px solid rgba(255, 255, 255, 0.3);
                border-radius: 6px;
                overflow: hidden;
                margin-right: 15px;
                height: 35px;
            }

            .theme-link {
                padding: 5px 12px;
                color: white;
                text-decoration: none;
                font-size: 14px;
                transition: background 0.2s, font-weight 0.2s;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .theme-link:first-child {
                border-right: 1px solid rgba(255, 255, 255, 0.3);
            }
            .theme-link:hover:not(.active-theme) {
                background: rgba(255, 255, 255, 0.2);
            }

            .active-theme {
                background: #3498db; /* Active color */
                font-weight: 600;
            }

            .action-btn {
                padding: 20px;
                background: #3498db;
                color: white;
                text-decoration: none;
                border-radius: 8px;
                text-align: center;
                transition: all 0.3s;
                display: block;
            }

            .action-btn:hover {
                background: #2980b9;
                transform: translateY(-2px);
            }

            .action-btn-primary {
                background: #3498db;
            }

            .action-btn-success {
                background: #27ae60;
            }

            .action-btn-warning {
                background: #f39c12;
            }

            /* --- Session Warning Modal Styles (New) --- */
            .session-modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.7);
                display: none; /* Hidden by default */
                justify-content: center;
                align-items: center;
                z-index: 1000;
            }

            .session-modal-content {
                background: var(--bg-card);
                color: var(--text-color);
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 5px 15px var(--shadow-color);
                max-width: 400px;
                width: 90%;
                text-align: center;
            }

            .session-modal-content h3 {
                margin-top: 0;
                color: #e74c3c; /* Red for warning */
            }

            .session-modal-content p {
                margin: 15px 0;
                font-size: 16px;
            }

            .session-modal-content .btn-modal {
                padding: 10px 20px;
                background: #3498db;
                color: white;
                text-decoration: none;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: background 0.3s;
            }

            .session-modal-content .btn-modal:hover {
                background: #2980b9;
            }

            /* --- Non-Blocking Warning Toast (New) --- */
            .session-toast {
                position: fixed;
                top: 20px;
                right: 20px;
                background: #f39c12; /* Warning Yellow */
                color: #2c3e50;
                padding: 15px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
                z-index: 999;
                max-width: 300px;
                transition: opacity 0.3s ease-in-out;
                opacity: 0;
                visibility: hidden;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .session-toast.show {
                opacity: 1;
                visibility: visible;
            }

            .session-toast .icon {
                font-size: 24px;
            }
        </style>
    </head>
    <!-- Apply theme class to the body tag -->
    <body class="theme-<%= currentTheme%>">
        <!-- Navigation Bar -->
        <div class="navbar">
            <h2>📚 Student Management System</h2>
            <div class="navbar-right">

                <!-- Theme Switcher UI -->
                <div class="theme-switcher">
                    <a href="theme?mode=light" 
                       class="theme-link <%= "light".equals(currentTheme) ? "active-theme" : ""%>">
                        <span style="font-size: 1.2em;">☀️</span> Light
                    </a>
                    <a href="theme?mode=dark" 
                       class="theme-link <%= "dark".equals(currentTheme) ? "active-theme" : ""%>">
                        <span style="font-size: 1.2em;">🌙</span> Dark
                    </a>
                </div>

                <div class="user-info">
                    <span>${sessionScope.fullName}</span>
                    <span class="role-badge role-${sessionScope.role}">
                        ${sessionScope.role}
                    </span>
                </div>
                <a href="logout" class="btn-logout">Logout</a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="container">
            <!-- Welcome Card -->
            <div class="welcome-card">
                <h1>${welcomeMessage}</h1>
                <p>Here's what's happening with your students today.</p>
            </div>

            <!-- Statistics -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon stat-icon-students">
                        👨‍🎓
                    </div>
                    <div class="stat-content">
                        <h3>${totalStudents}</h3>
                        <p>Total Students</p>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <h2>Quick Actions</h2>
                <div class="action-grid">
                    <a href="student?action=list" class="action-btn action-btn-primary">
                        📋 View All Students
                    </a>

                    <c:if test="${sessionScope.role eq 'admin'}">
                        <a href="student?action=new" class="action-btn action-btn-success">
                            ➕ Add New Student
                        </a>
                    </c:if>

                    <a href="student?action=search" class="action-btn action-btn-warning">
                        🔍 Search Students
                    </a>
                </div>
            </div>
        </div>

        <!-- Session Warning Toast -->
        <div id="session-toast" class="session-toast">
            <span class="icon">⚠️</span>
            <div id="toast-message"></div>
        </div>

        <!-- Session Expired Modal -->
        <div id="session-expired-modal" class="session-modal-overlay">
            <div class="session-modal-content">
                <h3>⏰ Session Expired</h3>
                <p>Your session has expired due to inactivity. Please log in again to continue.</p>
                <a href="logout" class="btn-modal">Go to Login</a>
            </div>
        </div>

        <script>
            // Configuration
            // NOTE: If your server session timeout is different, update SESSION_TIMEOUT here.
            const SESSION_TIMEOUT = 30 * 60 * 1000; // 30 minutes in milliseconds
            const WARNING_TIME = 5 * 60 * 1000;    // Warn 5 minutes before expiry

            // Track last user activity
            let lastActivity = Date.now();
            let warningShown = false; // Flag to prevent repeated console warnings every minute

            // DOM Elements
            const expiredModal = document.getElementById('session-expired-modal');
            const warningToast = document.getElementById('session-toast');
            const toastMessage = document.getElementById('toast-message');

            // Update activity time on user interactions
            function updateActivity() {
                lastActivity = Date.now();
                warningShown = false; // Reset warning flag when user is active
                // Hide toast if visible
                if (warningToast.classList.contains('show')) {
                    warningToast.classList.remove('show');
                }
            }

            // Listen to user interactions
            document.addEventListener('mousemove', updateActivity);
            document.addEventListener('keypress', updateActivity);
            document.addEventListener('click', updateActivity);
            document.addEventListener('scroll', updateActivity);

            // Function to display the non-blocking warning toast
            function showSessionWarning(minutes) {
                if (warningShown)
                    return; // Only show toast once per warning period

                const message = "Your session will expire in " + minutes + " minute" + (minutes !== 1 ? 's' : '') + ". Please save your work.";
                toastMessage.textContent = message;

                // Show the toast
                warningToast.classList.add('show');
                warningShown = true;

                // Auto-hide after 10 seconds (or after the next minute check if user is inactive)
                setTimeout(() => {
                    warningToast.classList.remove('show');
                }, 10000);
            }

            // Function to handle session expiry (replaces alert and redirect)
            function handleSessionExpired() {
                // Stop the checker interval
                clearInterval(sessionChecker);

                // Show the modal (blocking UI)
                expiredModal.style.display = 'flex';

                // Note: The modal button links directly to 'logout'
            }

            // Check session status every minute
            const sessionChecker = setInterval(function () {
                const timeElapsed = Date.now() - lastActivity;
                const timeRemaining = SESSION_TIMEOUT - timeElapsed;

                if (timeRemaining <= 0) {
                    // Session expired
                    handleSessionExpired();
                } else if (timeRemaining <= WARNING_TIME) {
                    // Show warning
                    const minutesLeft = Math.floor(timeRemaining / 60000);
                    console.warn(`⚠️ Session will expire in ${minutesLeft} minute(s)`);

                    showSessionWarning(minutesLeft);
                }
            }, 60000); // Check every 60 seconds (1 minute)

            // Initial log
            console.log('Session timeout tracking initialized. Timeout: 30 minutes. Warning at 5 minutes.');
        </script>
    </body>
</html>