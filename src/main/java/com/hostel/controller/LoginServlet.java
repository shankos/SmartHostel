package com.hostel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.hostel.config.DBConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If already logged in, redirect appropriately
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userRole") != null) {
            String role = (String) session.getAttribute("userRole");
            response.sendRedirect("admin".equals(role) ? "home" : "studentHome");
            return;
        }

        request.getRequestDispatcher("WEB-INF/pages/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // ── Validation ─────────────────────────────────────────
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Please enter your email or username.");
            request.getRequestDispatcher("WEB-INF/pages/login.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please enter your password.");
            request.getRequestDispatcher("WEB-INF/pages/login.jsp").forward(request, response);
            return;
        }

        email    = email.trim();
        password = password.trim();

        // ── Admin Login (hardcoded) ─────────────────────────────
        if ("admin".equals(email) && "admin".equals(password)) {
            HttpSession session = request.getSession();
            session.setAttribute("userRole",  "admin");
            session.setAttribute("userEmail", email);
            session.setMaxInactiveInterval(60 * 30); // 30 minutes
            response.sendRedirect("home");
            return;
        }

        // ── Student Login (database) ────────────────────────────
        Connection conn = null;
        try {
            conn = DBConfig.getConnection();
            if (conn == null) {
                request.setAttribute("error", "Unable to connect to the database. Please try again later.");
                request.getRequestDispatcher("WEB-INF/pages/login.jsp").forward(request, response);
                return;
            }

            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("userRole",  "student");
                session.setAttribute("userEmail", email);
                session.setMaxInactiveInterval(60 * 30);
                response.sendRedirect("studentHome");
            } else {
                // ❌ Wrong credentials — intentionally vague for security
                request.setAttribute("error",
                    "Wrong login credentials. Please check your email and password and try again.");
                request.getRequestDispatcher("WEB-INF/pages/login.jsp").forward(request, response);
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error",
                "Something went wrong on our end. Please try again in a moment.");
            request.getRequestDispatcher("WEB-INF/pages/login.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception ignored) {}
            }
        }
    }
}