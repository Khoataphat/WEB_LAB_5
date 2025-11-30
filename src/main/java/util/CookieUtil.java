/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

/**
 *
 * @author Admin
 */
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CookieUtil {
    
    /**
     * Create and add cookie to response
     * @param response HTTP response
     * @param name Cookie name
     * @param value Cookie value
     * @param maxAge Cookie lifetime in seconds
     */
    public static void createCookie(HttpServletResponse response, 
                                   String name, 
                                   String value, 
                                   int maxAge) {
        if (name == null || value == null || response == null) {
            // Có thể log lỗi hoặc ném ngoại lệ, nhưng ở đây chỉ cần return
            return; 
        }
        
        // 1. Create new Cookie with name and value
        Cookie cookie = new Cookie(name, value);
        
        // 2. Set maxAge (lifetime in seconds)
        cookie.setMaxAge(maxAge);
        
        // 3. Set path to "/" (accessible by the entire application)
        cookie.setPath("/");
        
        // 4. Set httpOnly to true (security measure against XSS)
        cookie.setHttpOnly(true); 
        
        // 5. Add cookie to response
        response.addCookie(cookie);
    }
    
    /**
     * Get cookie value by name
     * @param request HTTP request
     * @param name Cookie name
     * @return Cookie value or null if not found
     */
    public static String getCookieValue(HttpServletRequest request, String name) {
        if (request == null || name == null) {
            return null;
        }
        
        // 1. Get all cookies from request
        Cookie[] cookies = request.getCookies();
        
        // 2. Kiểm tra nếu không có cookie nào tồn tại
        if (cookies != null) {
            // 3. Loop through cookies
            for (Cookie cookie : cookies) {
                // 4. Find cookie with matching name
                if (cookie.getName().equals(name)) {
                    // 5. Return value
                    return cookie.getValue();
                }
            }
        }
        
        // 6. Return null if not found
        return null;
    }
    
    /**
     * Check if cookie exists
     * @param request HTTP request
     * @param name Cookie name
     * @return true if cookie exists
     */
    public static boolean hasCookie(HttpServletRequest request, String name) {
        // Tái sử dụng logic getCookieValue() để kiểm tra sự tồn tại
        return getCookieValue(request, name) != null;
    }
    
    /**
     * Delete cookie by setting max age to 0
     * @param response HTTP response
     * @param name Cookie name to delete
     */
    public static void deleteCookie(HttpServletResponse response, String name) {
        if (name == null || response == null) {
            return;
        }
        
        // 1. Create cookie with same name and empty value (Giá trị không quan trọng)
        Cookie cookie = new Cookie(name, "");
        
        // 2. Set maxAge to 0 (tells the browser to delete the cookie immediately)
        cookie.setMaxAge(0);
        
        // 3. Set path to "/" (PHẢI TRÙNG VỚI path khi tạo cookie để xóa đúng)
        cookie.setPath("/");
        
        // 4. Add to response
        response.addCookie(cookie);
    }
    
    /**
     * Update existing cookie
     * @param response HTTP response
     * @param name Cookie name
     * @param newValue New cookie value
     * @param maxAge New max age
     */
    public static void updateCookie(HttpServletResponse response, 
                                   String name, 
                                   String newValue, 
                                   int maxAge) {
        // Cập nhật một cookie bằng cách tạo một cookie mới CÓ CÙNG TÊN 
        // và thêm nó vào phản hồi. Browser sẽ tự động ghi đè cái cũ.
        createCookie(response, name, newValue, maxAge);
    }
}
