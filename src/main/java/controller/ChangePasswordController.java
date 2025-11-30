/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author Admin
 */
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import model.User;
import util.PasswordUtil;

// Giả định bạn có model User và DAO UserDAO đã implement
// import model.User; 
// import dao.UserDAO;
// import util.PasswordUtil; // Giả định có lớp tiện ích này

@WebServlet("/change-password")
public class ChangePasswordController extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    
    /**
     * Hiển thị form thay đổi mật khẩu (Chỉ khi đã đăng nhập)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
    }
    
    /**
     * Xử lý POST đổi mật khẩu
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String error = null;
        
        // 1. Kiểm tra Session và Tải lại User (Khắc phục lỗi mất đồng bộ)
        Object userObject = session.getAttribute("user");
        if (session == null || userObject == null) {
            response.sendRedirect("login");
            return;
        }
        
        User currentUserInSession = (User) userObject; 
        int currentUserId = currentUserInSession.getId();
        
        // TẢI LẠI USER MỚI NHẤT từ DB để lấy hash hiện tại chính xác
        User userFromDB = userDAO.getUserById(currentUserId);
        
        if (userFromDB == null) {
            request.setAttribute("error", "Error: User data not found.");
            doGet(request, response);
            return;
        }
        
        String dbHashedPassword = userFromDB.getPassword(); 
        
        // 2. Lấy tham số form
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // 3. Xác thực mật khẩu hiện tại (Sử dụng hash từ DB)
        if (!PasswordUtil.verifyPassword(currentPassword, dbHashedPassword)) {
            error = "Current password is incorrect.";
        }
        
        // 4. Xác thực mật khẩu mới
        if (error == null) {
            if (newPassword.length() < 8) {
                error = "New password must be at least 8 characters long.";
            } else if (!newPassword.equals(confirmPassword)) {
                error = "New password and confirmation password do not match.";
            } else if (newPassword.equals(currentPassword)) {
                error = "New password cannot be the same as the current password.";
            }
        }
        
        // Xử lý lỗi
        if (error != null) {
            request.setAttribute("error", error);
            doGet(request, response);
            return;
        }
        
        // 5. Hash mật khẩu mới
        String newHashedPassword = PasswordUtil.hashPassword(newPassword);
        
        // 6. Cập nhật trong database
        boolean success = userDAO.updatePassword(currentUserId, newHashedPassword);
        
        // 7. Cập nhật Session và Phản hồi
        if (success) {
            // Cập nhật đối tượng User trong Session để duy trì đăng nhập
            userFromDB.setPassword(newHashedPassword); 
            session.setAttribute("user", userFromDB);
            
            // Chuyển hướng Post-Redirect-Get
            response.sendRedirect("dashboard?message=Password successfully changed!");
            
        } else {
            request.setAttribute("error", "Error updating password. Please try again.");
            doGet(request, response);
        }
    }
}