/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package filter;

/**
 *
 * @author Admin
 */
import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Authentication Filter - Checks if user is logged in Protects all pages except
 * login and public resources
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    // Public URLs that don't require authentication
    private static final String[] PUBLIC_URLS = {
        "/login",
        "/logout",
        ".css",
        ".js",
        ".png",
        ".jpg",
        ".jpeg",
        ".gif",
        "/change-password"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("AuthFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // Check if this is a public URL
        if (isPublicUrl(path)) {
            // Allow access to public URLs
            chain.doFilter(request, response);
            return;
        }

        // Check if user is logged in
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        Object token = null;

        // 2. Nếu token tồn tại, thử auto-login
            if (token != null) {
                UserDAO userDAO = new UserDAO();
                User user = userDAO.getUserByToken((String) token); // Lấy User nếu token hợp lệ và chưa hết hạn
                
                if (user != null) {
                    // Token hợp lệ - Tự động đăng nhập User
                    session = httpRequest.getSession(true); // Tạo session mới
                    session.setAttribute("user", user);
                    session.setAttribute("userId", user.getId());
                    session.setAttribute("username", user.getUsername());
                    session.setAttribute("role", user.getRole());
                    session.setAttribute("fullName", user.getFullName());

                    // Đánh dấu đã đăng nhập thành công
                    isLoggedIn = true; 
                    
                    // KHÔNG cần chain.doFilter ở đây vì chúng ta sẽ tiếp tục kiểm tra isLoggedIn ở dưới
                    // và cho phép truy cập.
                    
                } else {
                    // Token không hợp lệ/đã hết hạn - Xóa cookie khỏi trình duyệt
                    Cookie deleteCookie = new Cookie("remember_token", "");
                    deleteCookie.setMaxAge(0);
                    deleteCookie.setPath("/");
                    httpResponse.addCookie(deleteCookie);
                    
                    // KHUYẾN NGHỊ: Xóa token khỏi DB (để dọn dẹp), nhưng logic này thường đặt trong UserDAO.getUserByToken
                    // hoặc LogoutController để tránh logic quá nặng trong Filter.
                }
            }
       
        
        if (isLoggedIn) {
            // User is logged in, allow access
            chain.doFilter(request, response);
        } else {
            // User not logged in, redirect to login
            String loginURL = contextPath + "/login";
            httpResponse.sendRedirect(loginURL);
        }
    }

    @Override
    public void destroy() {
        System.out.println("AuthFilter destroyed");
    }

    /**
     * Check if URL is public (doesn't require authentication)
     */
    private boolean isPublicUrl(String path) {
        // Luôn coi đường dẫn gốc là công khai (thường chuyển hướng đến login hoặc dashboard)
        if (path.equals("/")) {
            return true;
        }

        // Chuyển đường dẫn thành chữ thường để so sánh không phân biệt chữ hoa/thường
        String lowerCasePath = path.toLowerCase();

        for (String publicUrl : PUBLIC_URLS) {
            // Kiểm tra các URL Controller chính xác (bắt đầu bằng /)
            if (publicUrl.startsWith("/")) {
                // Kiểm tra khớp chính xác: /login (tránh /mylogin)
                if (lowerCasePath.equals(publicUrl)) {
                    return true;
                }
            } // Kiểm tra các phần mở rộng tệp tĩnh (kết thúc bằng .extension)
            else {
                // Kiểm tra nếu đường dẫn kết thúc bằng phần mở rộng
                if (lowerCasePath.endsWith(publicUrl)) {
                    return true;
                }
            }
        }
        return false;
    }
}
