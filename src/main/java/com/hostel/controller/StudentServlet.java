package com.hostel.controller;

import java.io.IOException;
import java.util.ArrayList;

import com.hostel.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/students")
public class StudentServlet extends HttpServlet {

    static final ArrayList<Student> studentList = new ArrayList<>();

    /** Called by HomeServlet for dashboard stat count */
    public static ArrayList<Student> getStudentList() {
        return studentList;
    }

    // ── GET ─────────────────────────────────────────────────────
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login");
            return;
        }

        // Flash message from redirect
        String flash = (String) session.getAttribute("flash");
        if (flash != null) {
            request.setAttribute("success", flash);
            session.removeAttribute("flash");
        }

        try {
            // Delete
            String deleteIndex = request.getParameter("delete");
            if (deleteIndex != null) {
                try {
                    int index = Integer.parseInt(deleteIndex);
                    if (index >= 0 && index < studentList.size()) {
                        String studentName = studentList.get(index).getName();
                        studentList.remove(index);
                        session.setAttribute("flash",
                            studentName + "'s record has been removed successfully.");
                    } else {
                        session.setAttribute("flash", "Student record not found — it may have already been removed.");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("flash", "Invalid delete request.");
                }
                response.sendRedirect("students");
                return;
            }

            // Edit
            String editIndex = request.getParameter("edit");
            if (editIndex != null) {
                try {
                    int index = Integer.parseInt(editIndex);
                    if (index >= 0 && index < studentList.size()) {
                        request.setAttribute("editStudent", studentList.get(index));
                        request.setAttribute("editIndex",   index);
                    } else {
                        request.setAttribute("error", "Student not found. They may have been removed.");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid request. Please try again.");
                }
            }

            request.setAttribute("students", studentList);
            request.getRequestDispatcher("WEB-INF/pages/students.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong. Please refresh the page.");
            request.setAttribute("students", studentList);
            request.getRequestDispatcher("WEB-INF/pages/students.jsp").forward(request, response);
        }
    }

    // ── POST ────────────────────────────────────────────────────
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login");
            return;
        }

        String name         = request.getParameter("name");
        String email        = request.getParameter("email");
        String phone        = request.getParameter("phone");
        String editIndexStr = request.getParameter("editIndex");

        // ── Validation ─────────────────────────────────────────
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Student name is required.");
            request.setAttribute("students", studentList);
            request.getRequestDispatcher("WEB-INF/pages/students.jsp").forward(request, response);
            return;
        }

        if (email == null || email.trim().isEmpty() || !email.contains("@")) {
            request.setAttribute("error", "Please enter a valid email address for the student.");
            request.setAttribute("students", studentList);
            request.getRequestDispatcher("WEB-INF/pages/students.jsp").forward(request, response);
            return;
        }

        if (phone == null || phone.trim().isEmpty()) {
            request.setAttribute("error", "Phone number is required.");
            request.setAttribute("students", studentList);
            request.getRequestDispatcher("WEB-INF/pages/students.jsp").forward(request, response);
            return;
        }

        // Basic phone format check
        String phoneCleaned = phone.trim().replaceAll("[\\s\\-]", "");
        if (!phoneCleaned.matches("\\d{7,15}")) {
            request.setAttribute("error", "Phone number must contain 7 to 15 digits only.");
            request.setAttribute("students", studentList);
            request.getRequestDispatcher("WEB-INF/pages/students.jsp").forward(request, response);
            return;
        }

        name  = name.trim();
        email = email.trim().toLowerCase();

        try {
            if (editIndexStr != null && !editIndexStr.isEmpty()) {
                // UPDATE
                int index = Integer.parseInt(editIndexStr.trim());
                if (index >= 0 && index < studentList.size()) {
                    studentList.set(index, new Student(name, email, phoneCleaned));
                    session.setAttribute("flash", name + "'s record has been updated successfully.");
                } else {
                    request.setAttribute("error", "Student not found. They may have been removed.");
                    request.setAttribute("students", studentList);
                    request.getRequestDispatcher("WEB-INF/pages/students.jsp").forward(request, response);
                    return;
                }
            } else {
                // CREATE — check duplicate email
                for (Student s : studentList) {
                    if (s.getEmail().equalsIgnoreCase(email)) {
                        request.setAttribute("error",
                            "A student with email \"" + email + "\" already exists.");
                        request.setAttribute("students", studentList);
                        request.getRequestDispatcher("WEB-INF/pages/students.jsp").forward(request, response);
                        return;
                    }
                }
                studentList.add(new Student(name, email, phoneCleaned));
                session.setAttribute("flash", name + " has been added successfully.");
            }

            response.sendRedirect("students");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid edit index. Please try again.");
            request.setAttribute("students", studentList);
            request.getRequestDispatcher("WEB-INF/pages/students.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Operation failed. Please try again.");
            request.setAttribute("students", studentList);
            request.getRequestDispatcher("WEB-INF/pages/students.jsp").forward(request, response);
        }
    }
}
