/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Admin
 */
import model.Student;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    // Database configuration
    private static final String DB_URL = "jdbc:mysql://localhost:3306/student_management";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "123456";

    // Get database connection
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Driver not found", e);
        }
    }

    // Get all students
    /**
     *
     * @return
     */
    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY id DESC";

        try (Connection conn = getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setCreatedAt(rs.getTimestamp("created_at"));
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    // Get student by ID
    public Student getStudentById(int id) {
        String sql = "SELECT * FROM students WHERE id = ?";

        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setCreatedAt(rs.getTimestamp("created_at"));
                return student;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Add new student
    public boolean addStudent(Student student) {
        String sql = "INSERT INTO students (student_code, full_name, email, major, photo) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, student.getStudentCode());
            pstmt.setString(2, student.getFullName());
            pstmt.setString(3, student.getEmail());
            pstmt.setString(4, student.getMajor());
            pstmt.setString(5, student.getPhoto());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update student
    public boolean updateStudent(Student student) {
        String sql = "UPDATE students SET student_code=?, full_name=?, email=?, major=?, photo=? WHERE id=?";

        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, student.getStudentCode());
            pstmt.setString(2, student.getFullName());
            pstmt.setString(3, student.getEmail());
            pstmt.setString(4, student.getMajor());
            pstmt.setString(5, student.getPhoto());
            pstmt.setInt(6, student.getId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete student
    public boolean deleteStudent(int id) {
        String sql = "DELETE FROM students WHERE id = ?";

        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //5.1: Update StudentDAO
    public List<Student> searchStudents(String keyword) throws SQLException {
        List<Student> students = new ArrayList<>();

        String sql = "SELECT * FROM students "
                + "WHERE student_code LIKE ? OR full_name LIKE ? OR email LIKE ? "
                + "ORDER BY id DESC";

        try (Connection connection = getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            String searchPattern = "%" + (keyword == null ? "" : keyword.trim()) + "%";

            preparedStatement.setString(1, searchPattern);
            preparedStatement.setString(2, searchPattern);
            preparedStatement.setString(3, searchPattern);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    students.add(mapResultSetToStudent(rs));
                }
            }
        }
        return students;
    }

    private Student mapResultSetToStudent(ResultSet rs) throws SQLException {
        Student student = new Student();
        student.setId(rs.getInt("id"));
        student.setStudentCode(rs.getString("student_code"));
        student.setFullName(rs.getString("full_name"));
        student.setEmail(rs.getString("email"));
        student.setMajor(rs.getString("major"));
        student.setPhoto(rs.getString("photo"));
        try {
            student.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (SQLException ignored) {
        }
        return student;
    }

    //--------------------------------------------------
    public String validateSortBy(String sortBy) {
        String[] validColumns = {"id", "student_code", "full_name", "email", "major"};
        for (String col : validColumns) {
            if (col.equalsIgnoreCase(sortBy)) {
                return col;
            }
        }
        return "id";
    }

    public String validateOrder(String order) {
        if ("desc".equalsIgnoreCase(order)) {
            return "DESC";
        }
        return "ASC";
    }

    public List<Student> getStudentsSorted(String sortBy, String order) throws SQLException {
        List<Student> students = new ArrayList<>();

        String validatedSortBy = validateSortBy(sortBy);
        String validatedOrder = validateOrder(order);

        String sql = "SELECT * FROM students ORDER BY " + validatedSortBy + " " + validatedOrder;

        try (Connection connection = getConnection(); Statement statement = connection.createStatement(); ResultSet rs = statement.executeQuery(sql)) {

            while (rs.next()) {
                students.add(mapResultSetToStudent(rs));
            }
        }
        return students;
    }

    public List<Student> getStudentsByMajor(String major) throws SQLException {
        List<Student> students = new ArrayList<>();
        // Mặc định sắp xếp theo ID giảm dần sau khi lọc
        String sql = "SELECT * FROM students WHERE major = ? ORDER BY id DESC";

        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

            // 1. Thiết lập tham số (An toàn chống SQL Injection)
            statement.setString(1, major);

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    students.add(mapResultSetToStudent(rs));
                }
            }
        }
        return students;
    }
    //-----------------------------------------

    //-----------------------------------------
    public int getTotalStudents() throws SQLException {
        String sql = "SELECT COUNT(*) FROM students";
        int count = 0;

        try (Connection connection = getConnection(); Statement statement = connection.createStatement(); ResultSet rs = statement.executeQuery(sql)) {

            if (rs.next()) {
                count = rs.getInt(1); // Get the value from the first column (COUNT(*))
            }
        }
        return count;
    }

    public List<Student> getStudentsPaginatedAndSorted(String sortBy, String order, int offset, int limit) throws SQLException {
        List<Student> students = new ArrayList<>();

        String validatedSortBy = validateSortBy(sortBy);
        String validatedOrder = validateOrder(order);

        // Xây dựng SQL có Order By, Limit, Offset
        String sql = "SELECT * FROM students ORDER BY " + validatedSortBy + " " + validatedOrder + " LIMIT ? OFFSET ?";

        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, limit);
            statement.setInt(2, offset);

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    students.add(mapResultSetToStudent(rs));
                }
            }
        }
        return students;
    }

}
