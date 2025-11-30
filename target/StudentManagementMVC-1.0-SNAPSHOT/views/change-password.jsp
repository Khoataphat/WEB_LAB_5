<%-- 
    Document   : change-password
    Created on : 30 thg 11, 2025, 12:05:42
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            /* --- Existing Styles (omitted for brevity) --- */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                padding: 20px;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                background: white;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            }

            h1 {
                color: #333;
                margin-bottom: 10px;
                font-size: 32px;
            }

            .subtitle {
                color: #666;
                margin-bottom: 30px;
                font-style: italic;
            }

            .message {
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 5px;
                font-weight: 500;
            }

            .success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            .btn {
                display: inline-block;
                padding: 12px 24px;
                text-decoration: none;
                border-radius: 5px;
                font-weight: 500;
                transition: all 0.3s;
                border: none;
                cursor: pointer;
                font-size: 14px;
            }

            .btn-sm { /* Style cho các nút nhỏ hơn trong bảng/form lọc */
                padding: 8px 16px;
                font-size: 13px;
            }

            .btn-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            }

            .btn-secondary, .btn-outline-secondary {
                background-color: #6c757d;
                color: white;
                padding: 8px 16px;
                font-size: 13px;
                text-decoration: none;
            }

            .btn-outline-secondary {
                background-color: transparent;
                border: 1px solid #6c757d;
                color: #6c757d;
            }
            .btn-outline-secondary:hover {
                background-color: #6c757d;
                color: white;
            }

            .btn-danger {
                background-color: #dc3545;
                color: white;
                padding: 8px 16px;
                font-size: 13px;
                text-decoration: none;
            }

            .btn-danger:hover {
                background-color: #c82333;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }

            thead {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }

            th, td {
                padding: 15px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }

            th {
                font-weight: 600;
                text-transform: uppercase;
                font-size: 13px;
                letter-spacing: 0.5px;
            }

            th a { /* Styles cho link sắp xếp */
                color: white;
                text-decoration: none;
                display: inline-block;
                padding-right: 5px;
            }

            th a:hover {
                text-decoration: underline;
            }

            .sort-indicator {
                font-size: 12px;
                margin-left: 5px;
            }

            tbody tr {
                transition: background-color 0.2s;
            }

            tbody tr:hover {
                background-color: #f8f9fa;
            }

            .actions {
                display: flex;
                gap: 10px;
            }

            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #999;
            }

            .empty-state-icon {
                font-size: 64px;
                margin-bottom: 20px;
            }

            /* --- NEW STYLES FOR SEARCH & FILTER --- */
            .search-container, .filter-box {
                margin-bottom: 25px;
                padding: 20px;
                background-color: #f0f4ff;
                border-radius: 8px;
                border: 1px solid #c8d2f0;
            }

            .search-form, .filter-form {
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .filter-form label {
                font-weight: 600;
                color: #4a5568;
            }

            .filter-form select {
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
                flex-grow: 1; /* Cho phép select box co giãn */
                font-size: 16px;
                max-width: 300px;
            }

            .search-form input[type="text"] {
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
                flex-grow: 1;
                font-size: 16px;
            }

            .search-results-info {
                margin-top: 15px;
                padding: 10px;
                background-color: #e9ecef;
                border-left: 5px solid #764ba2;
                color: #333;
                font-weight: 500;
            }
            .pagination {
                margin: 20px 0;
                text-align: center;
            }

            .pagination a {
                padding: 8px 12px;
                margin: 0 4px;
                border: 1px solid #ddd;
                text-decoration: none;
                color: #4A5568;
                border-radius: 4px;
                transition: background-color 0.2s;
            }

            .pagination a:hover {
                background-color: #f0f0f0;
            }

            .pagination strong.current-page { /* Đã đổi tên class từ 'strong' thành 'current-page' để tránh xung đột */
                padding: 8px 12px;
                margin: 0 4px;
                /* Dùng màu primary gradient để làm nổi bật */
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: 1px solid #764ba2;
                border-radius: 4px;
            }
            .page-info {
                text-align: center;
                color: #555;
                margin-top: 10px;
                margin-bottom: 30px;
                font-weight: 500;
            }
            .navbar {
                background: white; /* Nền trắng cho thanh nav */
                padding: 15px 30px;
                display: flex;
                justify-content: space-between; /* Đẩy các phần tử ra hai bên */
                align-items: center;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px; /* Khoảng cách với container bên dưới */
                border-radius: 8px; /* Bo góc nhẹ */
            }

            .navbar h2 {
                color: #4A5568; /* Màu chữ tiêu đề */
                font-size: 20px;
                font-weight: 600;
            }

            .navbar-right {
                display: flex;
                align-items: center;
                gap: 15px; /* Khoảng cách giữa các phần tử bên phải */
            }

            .user-info {
                display: flex;
                align-items: center;
                font-size: 14px;
                color: #555;
                font-weight: 500;
            }

            .role-badge {
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 11px;
                margin-left: 8px;
                font-weight: bold;
                text-transform: uppercase;
            }

            .role-admin {
                background-color: #f7a44f; /* Màu cam */
                color: white;
            }

            .role-user {
                background-color: #667eea; /* Màu tím/xanh primary */
                color: white;
            }

            .btn-nav, .btn-logout {
                padding: 8px 16px;
                text-decoration: none;
                border-radius: 5px;
                font-weight: 500;
                transition: all 0.3s;
                font-size: 14px;
                display: inline-block;
                border: 1px solid transparent;
            }

            .btn-nav {
                background-color: #e9ecef;
                color: #4A5568;
            }

            .btn-nav:hover {
                background-color: #d1d6db;
            }

            .btn-logout {
                background-color: #dc3545;
                color: white;
            }

            .btn-logout:hover {
                background-color: #c82333;
                transform: none; /* Tránh dịch chuyển */
            }
            * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        
        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 32px;
        }
        
        .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-style: italic;
        }
        
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: 500;
        }
        
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-danger {
            background-color: #dc3545;
            color: white;
            padding: 8px 16px;
            font-size: 13px;
        }
        
        .btn-danger:hover {
            background-color: #c82333;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 13px;
            letter-spacing: 0.5px;
        }
        
        tbody tr {
            transition: background-color 0.2s;
        }
        
        tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .actions {
            display: flex;
            gap: 10px;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        
        .empty-state-icon {
            font-size: 64px;
            margin-bottom: 20px;
        } 
            </style>
    </head>
    <body>
        <div class="container">
            <h2>🔑 Change Password</h2>

            <c:if test="${not empty requestScope.error}">
                <div class="message error">❌ ${requestScope.error}</div>
            </c:if>
            <c:if test="${not empty requestScope.message}">
                <div class="message success">✅ ${requestScope.message}</div>
            </c:if>

            <form action="change-password" method="post" class="form-standard">
                <div class="form-group">
                    <label for="currentPassword">Current Password:</label>
                    <input type="password" id="currentPassword" name="currentPassword" 
                           placeholder="Enter current password" required>
                </div>

                <div class="form-group">
                    <label for="newPassword">New Password:</label>
                    <input type="password" id="newPassword" name="newPassword" 
                           placeholder="Minimum 8 characters" required>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password:</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" 
                           placeholder="Confirm new password" required>
                </div>

                <button type="submit" class="btn btn-primary">Change Password</button>
            </form>
    </body>
</html>
