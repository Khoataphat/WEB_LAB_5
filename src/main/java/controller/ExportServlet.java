/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.StudentDAO;
import model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Cell;

@WebServlet("/export")
public class ExportServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy dữ liệu
        List<Student> students = studentDAO.getAllStudents(); 

        // 2. Cài đặt Header cho Response (Thiết lập Excel download)
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=students.xlsx");

        // 3. Tạo Workbook
        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Student List");

            // 4. Tạo Header Row
            Row headerRow = sheet.createRow(0);
            String[] headers = {"ID", "Student Code", "Full Name", "Email", "Major"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
            }

            // 5. Đổ dữ liệu
            int rowNum = 1;
            for (Student student : students) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(student.getId());
                row.createCell(1).setCellValue(student.getStudentCode());
                row.createCell(2).setCellValue(student.getFullName());
                row.createCell(3).setCellValue(student.getEmail());
                row.createCell(4).setCellValue(student.getMajor());
            }

            // 6. Ghi Workbook ra Response Stream
            workbook.write(response.getOutputStream());
        } catch (Exception e) {
            throw new ServletException("Error exporting data to Excel", e);
        }
    }
}
