package com.hostel.controller;

import java.io.IOException;
import java.util.ArrayList;

import com.hostel.model.Payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/payments")
public class PaymentServlet extends HttpServlet {

    static final ArrayList<Payment> paymentList = new ArrayList<>();

    public static ArrayList<Payment> getPaymentList() { return paymentList; }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect("login"); return;
        }

        String role  = (String) session.getAttribute("userRole");
        String flash = (String) session.getAttribute("flash");
        if (flash != null) { request.setAttribute("success", flash); session.removeAttribute("flash"); }

        try {
            if ("admin".equals(role)) {

                String markPaid = request.getParameter("markPaid");
                if (markPaid != null) {
                    int idx = Integer.parseInt(markPaid);
                    if (idx >= 0 && idx < paymentList.size()) {
                        Payment p = paymentList.get(idx);
                        p.setStatus("Paid");
                        p.setPaidDate(new java.text.SimpleDateFormat("dd MMM yyyy").format(new java.util.Date()));
                        session.setAttribute("flash", "Payment marked Paid for " + p.getStudentName());
                    }
                    response.sendRedirect("payments"); return;
                }

                String markOverdue = request.getParameter("markOverdue");
                if (markOverdue != null) {
                    int idx = Integer.parseInt(markOverdue);
                    if (idx >= 0 && idx < paymentList.size()) {
                        paymentList.get(idx).setStatus("Overdue");
                        session.setAttribute("flash", "Payment marked Overdue.");
                    }
                    response.sendRedirect("payments"); return;
                }

                String delete = request.getParameter("delete");
                if (delete != null) {
                    int idx = Integer.parseInt(delete);
                    if (idx >= 0 && idx < paymentList.size()) paymentList.remove(idx);
                    session.setAttribute("flash", "Payment record deleted.");
                    response.sendRedirect("payments"); return;
                }

                request.setAttribute("payments", paymentList);
                request.setAttribute("students", StudentServlet.getStudentList());
                request.getRequestDispatcher("WEB-INF/pages/payments.jsp").forward(request, response);
                return;
            }

            if ("student".equals(role)) {
                String email = (String) session.getAttribute("userEmail");
                ArrayList<Payment> mine = new ArrayList<>();
                for (Payment p : paymentList)
                    if (p.getStudentEmail().equalsIgnoreCase(email)) mine.add(p);
                request.setAttribute("myPayments", mine);
                request.getRequestDispatcher("WEB-INF/pages/studentPayments.jsp").forward(request, response);
                return;
            }

            response.sendRedirect("login");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong.");
            request.setAttribute("payments", paymentList);
            request.getRequestDispatcher("WEB-INF/pages/payments.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login"); return;
        }

        String studentEmail = request.getParameter("studentEmail");
        String studentName  = request.getParameter("studentName");
        String month        = request.getParameter("month");
        String amountStr    = request.getParameter("amount");

        if (studentEmail == null || studentEmail.trim().isEmpty() ||
            month == null || month.trim().isEmpty() ||
            amountStr == null || amountStr.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.setAttribute("payments", paymentList);
            request.setAttribute("students", StudentServlet.getStudentList());
            request.getRequestDispatcher("WEB-INF/pages/payments.jsp").forward(request, response);
            return;
        }

        try {
            double amount = Double.parseDouble(amountStr.trim());
            if (amount <= 0) throw new NumberFormatException();
            paymentList.add(new Payment(
                studentEmail.trim(),
                (studentName != null && !studentName.trim().isEmpty()) ? studentName.trim() : studentEmail.trim(),
                month.trim(), amount
            ));
            session.setAttribute("flash", "Payment record added for " + month.trim());
            response.sendRedirect("payments");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Please enter a valid amount.");
            request.setAttribute("payments", paymentList);
            request.setAttribute("students", StudentServlet.getStudentList());
            request.getRequestDispatcher("WEB-INF/pages/payments.jsp").forward(request, response);
        }
    }
}