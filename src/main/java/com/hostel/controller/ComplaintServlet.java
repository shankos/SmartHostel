package com.hostel.controller;

import java.io.IOException;
import java.util.ArrayList;

import com.hostel.model.Complaint;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/complaints")
public class ComplaintServlet extends HttpServlet {

    // Package-accessible so HomeServlet can read counts
    static final ArrayList<Complaint> complaintList = new ArrayList<>();

    /** Called by HomeServlet to display stats */
    public static ArrayList<Complaint> getComplaintList() {
        return complaintList;
    }

    // ── GET ─────────────────────────────────────────────────────
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect("login");
            return;
        }

        String role = (String) session.getAttribute("userRole");

        try {
            if ("admin".equals(role)) {

                // Resolve a complaint
                String resolveIndex = request.getParameter("resolve");
                if (resolveIndex != null) {
                    try {
                        int index = Integer.parseInt(resolveIndex);
                        if (index >= 0 && index < complaintList.size()) {
                            complaintList.get(index).setStatus("Resolved");
                        } else {
                            request.getSession().setAttribute("flash",
                                "Complaint not found. It may have already been removed.");
                        }
                    } catch (NumberFormatException e) {
                        // Ignore bad parameter, just redirect
                    }
                    response.sendRedirect("complaints");
                    return;
                }

                // Show admin complaints page
                request.setAttribute("complaints", complaintList);
                request.getRequestDispatcher("WEB-INF/pages/adminComplaints.jsp").forward(request, response);
                return;
            }

            if ("student".equals(role)) {
                // Pass any flash message from session
                String flash = (String) session.getAttribute("flash");
                if (flash != null) {
                    request.setAttribute("success", flash);
                    session.removeAttribute("flash");
                }
                request.getRequestDispatcher("WEB-INF/pages/complaints.jsp").forward(request, response);
                return;
            }

            // Unknown role
            response.sendRedirect("login");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong. Please try again.");
            if ("admin".equals(role)) {
                request.setAttribute("complaints", complaintList);
                request.getRequestDispatcher("WEB-INF/pages/adminComplaints.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("WEB-INF/pages/complaints.jsp").forward(request, response);
            }
        }
    }

    // ── POST ────────────────────────────────────────────────────
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"student".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login");
            return;
        }

        String description = request.getParameter("description");
        String category    = request.getParameter("category");
        String userEmail   = (String) session.getAttribute("userEmail");

        // ── Validation ─────────────────────────────────────────
        if (category == null || category.trim().isEmpty()) {
            request.setAttribute("error", "Please select a complaint category.");
            request.getRequestDispatcher("WEB-INF/pages/complaints.jsp").forward(request, response);
            return;
        }

        if (description == null || description.trim().isEmpty()) {
            request.setAttribute("error", "Complaint description cannot be empty.");
            request.getRequestDispatcher("WEB-INF/pages/complaints.jsp").forward(request, response);
            return;
        }

        if (description.trim().length() < 20) {
            request.setAttribute("error",
                "Please provide a more detailed description (at least 20 characters).");
            request.getRequestDispatcher("WEB-INF/pages/complaints.jsp").forward(request, response);
            return;
        }

        if (description.trim().length() > 500) {
            request.setAttribute("error", "Description is too long. Please keep it under 500 characters.");
            request.getRequestDispatcher("WEB-INF/pages/complaints.jsp").forward(request, response);
            return;
        }

        try {
            String fullDescription = "[" + category.trim() + "] " + description.trim();
            complaintList.add(new Complaint(fullDescription, userEmail));

            // Use POST → Redirect → GET to avoid re-submission on refresh
            session.setAttribute("flash",
                "Your complaint has been submitted successfully. The administration will review it shortly.");
            response.sendRedirect("complaints");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error",
                "Unable to submit your complaint right now. Please try again.");
            request.getRequestDispatcher("WEB-INF/pages/complaints.jsp").forward(request, response);
        }
    }
}