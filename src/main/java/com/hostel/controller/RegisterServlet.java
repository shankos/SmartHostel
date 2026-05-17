package com.hostel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.hostel.config.DBConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If already logged in, redirect
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userRole") != null) {
            String role = (String) session.getAttribute("userRole");
            response.sendRedirect("admin".equals(role) ? "home" : "studentHome");
            return;
        }

        request.getRequestDispatcher("WEB-INF/pages/register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name     = request.getParameter("name");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // ── Server-side Validation ──────────────────────────────
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Full name is required.");
            request.getRequestDispatcher("WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }

        if (email == null || email.trim().isEmpty() || !email.contains("@")) {
            request.setAttribute("error", "Please enter a valid email address.");
            request.getRequestDispatcher("WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long.");
            request.getRequestDispatcher("WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }

        name     = name.trim();
        email    = email.trim().toLowerCase();
        password = password.trim();

        Connection conn = null;
        try {
            conn = DBConfig.getConnection();
            if (conn == null) {
                request.setAttribute("error", "Unable to connect to the database. Please try again later.");
                request.getRequestDispatcher("WEB-INF/pages/register.jsp").forward(request, response);
                return;
            }

            // ── Check Duplicate Email ───────────────────────────
            String checkSql = "SELECT id FROM users WHERE email = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, email);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                request.setAttribute("error",
                    "This email is already registered. Please use a different email or sign in.");
                request.getRequestDispatcher("WEB-INF/pages/register.jsp").forward(request, response);
                rs.close();
                checkPs.close();
                return;
            }

            rs.close();
            checkPs.close();

            // ── Insert User ─────────────────────────────────────
            // NOTE: Only name, email, password columns as per your DB schema
            String sql = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.executeUpdate();
            ps.close();

            // ── Redirect to login with success message ──────────
            request.getSession().setAttribute("registerSuccess",
                "Account created successfully! Please sign in.");
            response.sendRedirect("login");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error",
                "Registration failed due to a server error. Please try again.");
            request.getRequestDispatcher("WEB-INF/pages/register.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception ignored) {}
            }
        }
    }
}