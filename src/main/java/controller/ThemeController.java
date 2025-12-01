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
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Handles user theme preference switching (light/dark) and saves it in a persistent cookie.
 * Accessed via /theme?mode=light or /theme?mode=dark
 */
@WebServlet("/theme")
public class ThemeController extends HttpServlet {
    
    // Cookie name
    private static final String THEME_COOKIE_NAME = "user_theme";
    // Max age (1 year)
    private static final int ONE_YEAR_IN_SECONDS = 365 * 24 * 60 * 60;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String theme = request.getParameter("mode");
        
        // 1. Validate theme value (security: only accept 'light' or 'dark')
        if ("light".equals(theme) || "dark".equals(theme)) {
            
            // 2. Create the cookie
            Cookie themeCookie = new Cookie(THEME_COOKIE_NAME, theme);
            
            // 3. Set persistent lifetime (1 year)
            themeCookie.setMaxAge(ONE_YEAR_IN_SECONDS);
            
            // 4. Set path to "/" (accessible by the entire application)
            themeCookie.setPath("/");
            
            // 5. Allow JavaScript to read the cookie for instant theme switching on subsequent pages
            themeCookie.setHttpOnly(false); 
            
            // 6. Add cookie to response
            response.addCookie(themeCookie);
        }
        
        // 7. Redirect back to the page user came from (using Referer header)
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            // Fallback to dashboard if referer is missing
            response.sendRedirect("dashboard");
        }
    }
}
