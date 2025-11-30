<%-- 
    Document   : student-list
    Created on : 17 thg 11, 2025, 09:37:31
    Author     : Admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<<<<<<< HEAD
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Student List - MVC</title>
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
        </style>
    </head>
    <body>

        <!-- Navigation Bar -->
        <div class="navbar">
            <h2>📚 Student Management System</h2>
            <div class="navbar-right">
                <div class="user-info">
                    <span>Welcome, ${sessionScope.fullName}</span>
                    <span class="role-badge role-${sessionScope.role}">
                        ${sessionScope.role}
                    </span>
                </div>
                <a href="dashboard" class="btn-nav">Dashboard</a>
                <a href="logout" class="btn-logout">Logout</a>
            </div>
        </div>

        <div class="container">
            <h1>📚 Student Management System</h1>
            <p class="subtitle">MVC Pattern with Jakarta EE & JSTL</p>

            <c:if test="${not empty param.message}">
                <div class="message success">
                    ✅ ${param.message}
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="message error">
                    ❌ ${param.error}
                </div>
            </c:if>

            <div style="margin-bottom: 20px;">
                <c:if test="${sessionScope.role eq 'admin'}">
                    <div style="margin: 20px 0;">
                        <a href="student?action=new" class="btn btn-primary">➕ Add New Student</a>
                    </div>
                </c:if>
                <a href="export" class="btn btn-success">
                    <i class="fas fa-file-excel"></i> Export to Excel
                </a>
=======
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List - MVC</title>
    <style>
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
        <h1>📚 Student Management System</h1>
        <p class="subtitle">MVC Pattern with Jakarta EE & JSTL</p>
        
        <!-- Success Message -->
        <c:if test="${not empty param.message}">
            <div class="message success">
                ✅ ${param.message}
>>>>>>> parent of cc33da8 (Lab5)
            </div>
        </c:if>
        
        <!-- Error Message -->
        <c:if test="${not empty param.error}">
            <div class="message error">
                ❌ ${param.error}
            </div>
<<<<<<< HEAD

            <div class="filter-box">
                <form action="student" method="get" class="filter-form">
                    <input type="hidden" name="action" value="filter">
                    <label for="major-filter">Filter by Major:</label>
                    <select id="major-filter" name="major">
                        <option value="" ${empty selectedMajor ? 'selected' : ''}>-- All Majors --</option> 

                        <option value="Computer Science" 
                                ${selectedMajor == 'Computer Science' ? 'selected' : ''}>
                            Computer Science
                        </option>
                        <option value="Information Technology" 
                                ${selectedMajor == 'Information Technology' ? 'selected' : ''}>
                            Information Technology
                        </option>
                        <option value="Software Engineering" 
                                ${selectedMajor == 'Software Engineering' ? 'selected' : ''}>
                            Software Engineering
                        </option>
                        <option value="Business Administration" 
                                ${selectedMajor == 'Business Administration' ? 'selected' : ''}>
                            Business Administration
                        </option>
                    </select>
                    <button type="submit" class="btn btn-primary btn-sm">Apply Filter</button>

                    <c:if test="${not empty selectedMajor}">
                        <a href="student?action=list" class="btn btn-outline-secondary btn-sm">Clear Filter</a>
                    </c:if>
                </form>
            </div>
            <c:choose>
                <c:when test="${not empty listStudent}">
                    <table>
                        <%-- Tính toán order ngược lại --%>
                        <c:set var="currentOrder" value="${order}"/>
                        <c:set var="newOrder" value="${currentOrder == 'ASC' ? 'desc' : 'asc'}"/>

                        <thead>
                            <tr>
                                <th>
                                    <a href="student?action=sort&sortBy=id&order=${sortBy == 'id' ? newOrder : 'asc'}">
                                        ID
                                    </a>
                                    <c:if test="${sortBy == 'id'}">
                                        <span class="sort-indicator">${order == 'DESC' ? '▼' : '▲'}</span>
                                    </c:if>
                                </th>
                                <th>
                                    <a href="student?action=sort&sortBy=student_code&order=${sortBy == 'student_code' ? newOrder : 'asc'}">
                                        Code
                                    </a>
                                    <c:if test="${sortBy == 'student_code'}">
                                        <span class="sort-indicator">${order == 'DESC' ? '▼' : '▲'}</span>
                                    </c:if>
                                </th>
                                <th>
                                    <a href="student?action=sort&sortBy=full_name&order=${sortBy == 'full_name' ? newOrder : 'asc'}">
                                        Name
                                    </a>
                                    <c:if test="${sortBy == 'full_name'}">
                                        <span class="sort-indicator">${order == 'DESC' ? '▼' : '▲'}</span>
                                    </c:if>
                                </th>
                                <th>
                                    <a href="student?action=sort&sortBy=email&order=${sortBy == 'email' ? newOrder : 'asc'}">
                                        Email
                                    </a>
                                    <c:if test="${sortBy == 'email'}">
                                        <span class="sort-indicator">${order == 'DESC' ? '▼' : '▲'}</span>
                                    </c:if>
                                </th>
                                <th>
                                    <a href="student?action=sort&sortBy=major&order=${sortBy == 'major' ? newOrder : 'asc'}">
                                        Major
                                    </a>
                                    <c:if test="${sortBy == 'major'}">
                                        <span class="sort-indicator">${order == 'DESC' ? '▼' : '▲'}</span>
                                    </c:if>
                                </th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="student" items="${listStudent}">
                                <tr>
                                    <td>${student.id}</td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty student.photo}">
                                                <img src="${pageContext.request.contextPath}/uploads/${student.photo}" 
                                                     alt="Student Photo" class="student-thumb">
                                            </c:when>
                                            <c:otherwise>
                                                <span class="no-image">No IMG</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><strong>${student.studentCode}</strong></td>
                                    <td>${student.fullName}</td>
                                    <td>${student.email}</td>
                                    <td>${student.major}</td>
                                    <td>
                                        <div class="actions">
                                            <a href="student?action=edit&id=${student.id}" class="btn btn-secondary btn-sm">
                                                ✏️ Edit
                                            </a>
                                            <a href="student?action=delete&id=${student.id}" 
                                               class="btn btn-danger btn-sm"
                                               onclick="return confirm('Are you sure you want to delete this student?')">
                                                🗑️ Delete
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <c:if test="${not empty keyword or not empty selectedMajor}">
                                🚫
                            </c:if>
                            <c:if test="${empty keyword and empty selectedMajor}">
                                📭
                            </c:if>
                        </div>
                        <h3>No students found</h3>
                        <c:if test="${not empty keyword}">
                            <p>No results match your search for **${keyword}**.</p>
                        </c:if>
                        <c:if test="${not empty selectedMajor}">
                            <p>No students found in **${selectedMajor}** major.</p>
                        </c:if>
                        <c:if test="${empty keyword and empty selectedMajor}">
                            <p>Start by adding a new student.</p>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>

            <c:if test="${totalPages > 1}">

                <%-- Xây dựng chuỗi tham số lọc/sắp xếp hiện tại (PERSISTENCE) --%>
                <c:url var="baseLink" value="student">
                    <c:param name="action" value="list"/>
                    <%-- Thêm tham số Major (Filter) --%>
                    <c:if test="${not empty selectedMajor}">
                        <c:param name="major" value="${selectedMajor}"/>
                    </c:if>
                    <%-- Thêm tham số Sort --%>
                    <c:if test="${not empty sortBy}">
                        <c:param name="sortBy" value="${sortBy}"/>
                        <c:param name="order" value="${order}"/>
                    </c:if>
                    <%-- Thêm tham số Search (nếu có) --%>
                    <c:if test="${not empty keyword}">
                        <c:param name="keyword" value="${keyword}"/>
                    </c:if>
                </c:url>

                <div class="pagination">

                    <%-- 1. Nút Previous: Dùng baseLink và nối thêm tham số page --%>
                    <c:if test="${currentPage > 1}">
                        <a href="${baseLink}&page=${currentPage - 1}">« Previous</a>
                    </c:if>

                    <%-- 2. Số trang: Dùng baseLink và nối thêm tham số page --%>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <strong class="current-page">${i}</strong>
                            </c:when>
                            <c:otherwise>
                                <a href="${baseLink}&page=${i}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <%-- 3. Nút Next: Dùng baseLink và nối thêm tham số page --%>
                    <c:if test="${currentPage < totalPages}">
                        <a href="${baseLink}&page=${currentPage + 1}">Next »</a>
                    </c:if>
                </div>

                <%-- 4. Thông tin trang --%>
                <p class="page-info">
                    Showing page **${currentPage}** of **${totalPages}**
                </p>
            </c:if>
=======
        </c:if>
        
        <!-- Add New Student Button -->
        <div style="margin-bottom: 20px;">
            <a href="student?action=new" class="btn btn-primary">
                ➕ Add New Student
            </a>
>>>>>>> parent of cc33da8 (Lab5)
        </div>
        
        <!-- Student Table -->
        <c:choose>
            <c:when test="${not empty students}">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Student Code</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Major</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="student" items="${students}">
                            <tr>
                                <td>${student.id}</td>
                                <td><strong>${student.studentCode}</strong></td>
                                <td>${student.fullName}</td>
                                <td>${student.email}</td>
                                <td>${student.major}</td>
                                <td>
                                    <div class="actions">
                                        <a href="student?action=edit&id=${student.id}" class="btn btn-secondary">
                                            ✏️ Edit
                                        </a>
                                        <a href="student?action=delete&id=${student.id}" 
                                           class="btn btn-danger"
                                           onclick="return confirm('Are you sure you want to delete this student?')">
                                            🗑️ Delete
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">📭</div>
                    <h3>No students found</h3>
                    <p>Start by adding a new student</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
