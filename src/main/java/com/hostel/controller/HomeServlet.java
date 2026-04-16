package com.hostel.controller;

import java.io.IOException;
import java.util.ArrayList;

import com.hostel.model.Room;
import com.hostel.model.Student;
import com.hostel.model.Complaint;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ── Session Check ───────────────────────────────────────
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect("login");
            return;
        }

        // ── Admin only ──────────────────────────────────────────
        if (!"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("studentHome");
            return;
        }

        try {
            // Pass the live lists to home.jsp so stat counters work
            // These lists are held in the respective servlets (static).
            // We expose them via session-like shared references.
            request.setAttribute("userEmail",      session.getAttribute("userEmail"));
            request.setAttribute("studentCount",   StudentServlet.getStudentList());
            request.setAttribute("roomCount",      RoomServlet.getRoomList());
            request.setAttribute("complaintCount", ComplaintServlet.getComplaintList());

            request.getRequestDispatcher("WEB-INF/pages/home.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load the dashboard. Please try again.");
            request.getRequestDispatcher("WEB-INF/pages/home.jsp").forward(request, response);
        }
    }
}
