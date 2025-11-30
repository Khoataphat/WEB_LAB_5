/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author Admin
 */
import dao.StudentDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.Student;

@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get user from session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Get statistics
        int totalStudents = 0;
        List<Student> studentList = studentDAO.getAllStudents();
        // 2. Get the size of the list.
        if (studentList != null) {
            totalStudents = studentList.size();
        }

        // Set attributes
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("welcomeMessage", "Welcome back, " + user.getFullName() + "!");

        // Forward to dashboard
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }
}
