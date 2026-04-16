package com.hostel.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/studentHome")
public class StudentHomeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"student".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login");
            return;
        }

        try {
            // Flash message (e.g. after registration)
            String flash = (String) session.getAttribute("registerSuccess");
            if (flash != null) {
                request.setAttribute("success", flash);
                session.removeAttribute("registerSuccess");
            }

            request.setAttribute("userEmail", session.getAttribute("userEmail"));
            request.getRequestDispatcher("WEB-INF/pages/studentHome.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load your dashboard. Please try again.");
            request.getRequestDispatcher("WEB-INF/pages/studentHome.jsp").forward(request, response);
        }
    }
}
