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
import model.Student;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/student")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class StudentController extends HttpServlet {

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
            case "search":
            case "sort":
            case "filter":
            case "list":
            default:
            {
                try {
                    listStudents(request, response);
                } catch (SQLException ex) {
                    System.getLogger(StudentController.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
                }
            }
                break;

        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        switch (action) {
            case "insert":
                insertStudent(request, response);
                break;
            case "update":
                updateStudent(request, response);
                break;

        }
    }

    // List all students
private void listStudents(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SQLException {

    // --- 1. Thu thập tất cả tham số trạng thái (Persistence) ---
    String pageParam = request.getParameter("page");
    String sortBy = studentDAO.validateSortBy(request.getParameter("sortBy"));
    String order = studentDAO.validateOrder(request.getParameter("order"));
    String major = request.getParameter("major");
    String keyword = (request.getParameter("keyword") == null) ? "" : request.getParameter("keyword").trim();

    int recordsPerPage = 10;
    int currentPage = 1;
    int totalRecords = 0;
    List<Student> listStudent = new ArrayList<>();

    // Lấy trang hiện tại
    if (pageParam != null) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }

    // --- 2. Xử lý Logic Tìm kiếm và Lọc (Ưu tiên Tìm kiếm) ---
    boolean isSearching = !keyword.isEmpty();
    boolean isFiltering = (major != null && !major.isEmpty());
    
    if (isSearching) {
        // CASE 1: Đang tìm kiếm (Chỉ dùng hàm searchStudents, BỎ QUA filter/sort/pagination)
        
        listStudent = studentDAO.searchStudents(keyword);
        totalRecords = listStudent.size(); // Không cần DAO đếm
        currentPage = 1; // Chỉ có 1 trang kết quả
        
    } else if (isFiltering) {
        // CASE 2: Đang lọc theo Major (Chỉ dùng hàm getStudentsByMajor, BỎ QUA sort/pagination)
        
        listStudent = studentDAO.getStudentsByMajor(major);
        totalRecords = listStudent.size(); // Không cần DAO đếm
        currentPage = 1; // Chỉ có 1 trang kết quả

    } else {
        // CASE 3: Danh sách chung (Áp dụng Phân trang và Sắp xếp)
        
        totalRecords = studentDAO.getTotalStudents();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        if (totalPages > 0 && currentPage > totalPages) {
            currentPage = totalPages;
        } else if (totalPages == 0) {
            currentPage = 1;
        }

        int offset = (currentPage - 1) * recordsPerPage;
        
        listStudent = studentDAO.getStudentsPaginatedAndSorted(sortBy, order, offset, recordsPerPage); 
        
        request.setAttribute("totalPages", totalPages);
    }
    
    // --- 4. Đặt thuộc tính cho View (JSP) ---
    request.setAttribute("listStudent", listStudent);
    
    // Đặt các thuộc tính Persistence
    request.setAttribute("currentPage", currentPage);
    request.setAttribute("totalRecords", totalRecords);
    
    request.setAttribute("sortBy", sortBy);
    request.setAttribute("order", order);
    request.setAttribute("selectedMajor", major);
    request.setAttribute("keyword", keyword);

    // --- 5. Chuyển tiếp đến View ---
    RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
    dispatcher.forward(request, response);
}
    
    // Show form for new student
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("student", null);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }

    // Show form for editing student
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Student existingStudent = studentDAO.getStudentById(id);

        request.setAttribute("student", existingStudent);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }

    // Insert new student
    private void insertStudent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");
        String photoFileName = handleFileUpload(request);

        Student newStudent = new Student(studentCode, fullName, email, major);
        newStudent.setPhoto(photoFileName);
        
        if (!validateStudent(newStudent, request)) {
            request.setAttribute("student", newStudent);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (studentDAO.addStudent(newStudent)) {
            response.sendRedirect("student?action=list&message=Student added successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to add student");
        }
    }

    // Update student
    private void updateStudent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");
        
    String photoFileName = handleFileUpload(request);
    
    if (photoFileName == null) {
        photoFileName = request.getParameter("currentPhoto"); // Lấy từ input hidden ở View
    }

        Student student = new Student(studentCode, fullName, email, major);
        student.setId(id);
student.setPhoto(photoFileName);
        if (!validateStudent(student, request)) {
            request.setAttribute("student", student);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (studentDAO.updateStudent(student)) {
            response.sendRedirect("student?action=list&message=Student updated successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to update student");
        }
    }

    // Delete student
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        if (studentDAO.deleteStudent(id)) {
            response.sendRedirect("student?action=list&message=Student deleted successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to delete student");
        }
    }

// --- New Method for Search Functionality (Exercise 5.2) ---
    private void searchStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String trimmedKeyword = (keyword == null) ? "" : keyword.trim();

        List<Student> students;

        try {
            if (keyword == null || trimmedKeyword.isEmpty()) {
                listStudents(request, response);
                return;
            }

            students = studentDAO.searchStudents(trimmedKeyword);

            request.setAttribute("students", students);
            request.setAttribute("keyword", trimmedKeyword); // Keep the keyword for view persistence and message display

            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException ex) {
            ex.printStackTrace();
            throw new ServletException("Database error during student search operation.", ex);
        }
    }
// -----------------------------------------------------------

//------------------------------------------------------------
    private boolean validateStudent(Student student, HttpServletRequest request) {
        boolean isValid = true;

        String codePattern = "[A-Z]{2}[0-9]{3,}";
        String emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$";

        // --- 1. Validate Student Code (Required + Pattern) ---
        if (student.getStudentCode() == null || student.getStudentCode().trim().isEmpty()) {
            request.setAttribute("errorCode", "Student Code is required.");
            isValid = false;
        } else if (!student.getStudentCode().trim().matches(codePattern)) {
            request.setAttribute("errorCode", "Invalid format. Use 2 uppercase letters + 3 or more digits (e.g., SV001).");
            isValid = false;
        }

        // --- 2. Validate Full Name (Required + Min Length) ---
        if (student.getFullName() == null || student.getFullName().trim().isEmpty()) {
            request.setAttribute("errorName", "Full Name is required.");
            isValid = false;
        } else if (student.getFullName().trim().length() < 2) {
            request.setAttribute("errorName", "Full Name must be at least 2 characters long.");
            isValid = false;
        }

        // --- 3. Validate Email (Conditional + Format) ---
        if (student.getEmail() != null && !student.getEmail().trim().isEmpty()) {
            if (!student.getEmail().trim().matches(emailPattern)) {
                request.setAttribute("errorEmail", "Invalid email format (must contain @ and .).");
                isValid = false;
            }
        }

        // --- 4. Validate Major (Required) ---
        if (student.getMajor() == null || student.getMajor().trim().isEmpty()) {
            request.setAttribute("errorMajor", "Major is required.");
            isValid = false;
        }

        return isValid;
    }
//------------------------------------------------------------   
    
    private String handleFileUpload(HttpServletRequest request) throws IOException, ServletException {
    Part filePart = request.getPart("photo"); // Lấy file từ form
    
    // Kiểm tra nếu người dùng có chọn file không
    if (filePart == null || filePart.getSize() == 0) {
        return null; 
    }

    // 1. Lấy tên file gốc và validate đuôi file
    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
    String extension = "";
    int i = fileName.lastIndexOf('.');
    if (i > 0) {
        extension = fileName.substring(i).toLowerCase();
    }
    
    // Chỉ cho phép ảnh
    if (!extension.equals(".jpg") && !extension.equals(".jpeg") && !extension.equals(".png")) {
        return null;
    }

    // 2. Tạo tên file độc nhất (Unique Filename) để tránh trùng lặp
    String uniqueFileName = System.currentTimeMillis() + extension;

    // 3. Xác định thư mục lưu (Lưu vào thư mục 'uploads' trong thư mục gốc của Web App)
    String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
    
    // Tạo thư mục nếu chưa tồn tại
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) uploadDir.mkdir();

    // 4. Ghi file
    filePart.write(uploadPath + File.separator + uniqueFileName);
    
    return uniqueFileName; // Trả về tên file để lưu vào DB
}

}
