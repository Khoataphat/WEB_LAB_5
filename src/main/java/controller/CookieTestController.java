/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author Admin
 */
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import util.CookieUtil; // Đảm bảo import đúng

@WebServlet("/test-cookie")
public class CookieTestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("<h1>Cookie Test Utility</h1>");
        
        // --- BƯỚC 1: TẠO/CẬP NHẬT COOKIE ---
        // Tạo cookie "theme" (sống 7 ngày)
        int maxAge = 7 * 24 * 60 * 60; // 604800 giây
        CookieUtil.createCookie(response, "theme", "dark", maxAge);
        response.getWriter().println("<h2>1. Created Cookie: theme=dark</h2>");
        
        // Tạo cookie "lastVisit" (sống 1 giờ)
        CookieUtil.createCookie(response, "lastVisit", String.valueOf(System.currentTimeMillis()), 60 * 60);
        response.getWriter().println("<h2>2. Created Cookie: lastVisit</h2>");
        
        // --- BƯỚC 2: ĐỌC VÀ KIỂM TRA COOKIE ---
        
        String currentTheme = CookieUtil.getCookieValue(request, "theme");
        response.getWriter().println("<h2>3. Read Cookie: theme is " + currentTheme + "</h2>");
        
        boolean themeExists = CookieUtil.hasCookie(request, "theme");
        response.getWriter().println("<h2>4. Has Cookie 'theme': " + themeExists + "</h2>");
        
        // --- BƯỚC 3: CẬP NHẬT COOKIE ---
        CookieUtil.updateCookie(response, "theme", "light", maxAge);
        response.getWriter().println("<h2>5. Updated Cookie: theme=light</h2>");
        
        // Đọc lại giá trị sau khi cập nhật (thường cần request tiếp theo mới thấy giá trị mới)
        response.getWriter().println("<p>(Giá trị 'theme' = light sẽ được thấy ở request tiếp theo)</p>");
        
        // --- BƯỚC 4: XÓA COOKIE ---
        response.getWriter().println("<h2>6. Deleting Cookie: lastVisit</h2>");
        CookieUtil.deleteCookie(response, "lastVisit");
        response.getWriter().println("<p>-- Vui lòng F5 (Refresh) trang để kiểm tra --</p>");
    }
}
