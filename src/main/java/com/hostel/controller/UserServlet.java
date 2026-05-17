package com.hostel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.hostel.config.DBConfig;
import com.hostel.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/users")
public class UserServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login");
            return;
        }

        // Flash message
        String flash = (String) session.getAttribute("flash");
        if (flash != null) {
            request.setAttribute("success", flash);
            session.removeAttribute("flash");
        }

        // Delete user
        String deleteEmail = request.getParameter("delete");
        if (deleteEmail != null && !deleteEmail.trim().isEmpty()) {
            Connection conn = null;
            try {
                conn = DBConfig.getConnection();
                if (conn != null) {
                    PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE email = ?");
                    ps.setString(1, deleteEmail.trim());
                    ps.executeUpdate();
                    ps.close();
                    session.setAttribute("flash", "User account deleted successfully.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("flash", "Could not delete user. Please try again.");
            } finally {
                if (conn != null) try { conn.close(); } catch (Exception ignored) {}
            }
            response.sendRedirect("users");
            return;
        }

        // Load all users from DB
        ArrayList<User> users = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConfig.getConnection();
            if (conn != null) {
                PreparedStatement ps = conn.prepareStatement("SELECT name, email, password FROM users ORDER BY name ASC");
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    users.add(new User(
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        "student"
                    ));
                }
                rs.close();
                ps.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Could not load users from database.");
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }

        request.setAttribute("users", users);
        request.getRequestDispatcher("WEB-INF/pages/users.jsp").forward(request, response);
    }
}