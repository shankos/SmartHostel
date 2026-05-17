package com.hostel.controller;

import java.io.IOException;
import java.util.ArrayList;

import com.hostel.model.RoomRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/roomRequests")
public class RoomRequestServlet extends HttpServlet {

    static final ArrayList<RoomRequest> requestList = new ArrayList<>();

    public static ArrayList<RoomRequest> getRequestList() { return requestList; }

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

                String approve = request.getParameter("approve");
                if (approve != null) {
                    int idx = Integer.parseInt(approve);
                    if (idx >= 0 && idx < requestList.size()) {
                        RoomRequest rr = requestList.get(idx);
                        rr.setStatus("Approved");
                        rr.setAdminNote("Request approved by admin.");
                        session.setAttribute("flash", "Room request approved for " + rr.getStudentName());
                    }
                    response.sendRedirect("roomRequests"); return;
                }

                String deny = request.getParameter("deny");
                if (deny != null) {
                    int idx = Integer.parseInt(deny);
                    if (idx >= 0 && idx < requestList.size()) {
                        RoomRequest rr = requestList.get(idx);
                        rr.setStatus("Denied");
                        rr.setAdminNote("Request denied by admin.");
                        session.setAttribute("flash", "Room request denied for " + rr.getStudentName());
                    }
                    response.sendRedirect("roomRequests"); return;
                }

                String delete = request.getParameter("delete");
                if (delete != null) {
                    int idx = Integer.parseInt(delete);
                    if (idx >= 0 && idx < requestList.size()) requestList.remove(idx);
                    session.setAttribute("flash", "Request record deleted.");
                    response.sendRedirect("roomRequests"); return;
                }

                request.setAttribute("roomRequests", requestList);
                request.getRequestDispatcher("WEB-INF/pages/adminRoomRequests.jsp").forward(request, response);
                return;
            }

            if ("student".equals(role)) {
                String email = (String) session.getAttribute("userEmail");
                ArrayList<RoomRequest> mine = new ArrayList<>();
                for (RoomRequest rr : requestList)
                    if (rr.getStudentEmail().equalsIgnoreCase(email)) mine.add(rr);
                request.setAttribute("myRequests", mine);
                request.setAttribute("rooms", RoomServlet.getRoomList());
                request.getRequestDispatcher("WEB-INF/pages/studentRoomRequest.jsp").forward(request, response);
                return;
            }

            response.sendRedirect("login");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong. Please try again.");
            request.setAttribute("roomRequests", requestList);
            request.getRequestDispatcher("WEB-INF/pages/adminRoomRequests.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login"); return;
        }

        String email         = (String) session.getAttribute("userEmail");
        String preferredRoom = request.getParameter("preferredRoom");
        String reason        = request.getParameter("reason");

        if (preferredRoom == null || preferredRoom.trim().isEmpty()) {
            request.setAttribute("error", "Please select a preferred room.");
            request.setAttribute("myRequests", getMyRequests(email));
            request.setAttribute("rooms", RoomServlet.getRoomList());
            request.getRequestDispatcher("WEB-INF/pages/studentRoomRequest.jsp").forward(request, response);
            return;
        }

        if (reason == null || reason.trim().length() < 10) {
            request.setAttribute("error", "Please provide a reason (at least 10 characters).");
            request.setAttribute("myRequests", getMyRequests(email));
            request.setAttribute("rooms", RoomServlet.getRoomList());
            request.getRequestDispatcher("WEB-INF/pages/studentRoomRequest.jsp").forward(request, response);
            return;
        }

        // Check if student already has a pending request
        for (RoomRequest rr : requestList) {
            if (rr.getStudentEmail().equalsIgnoreCase(email) && rr.isPending()) {
                request.setAttribute("error", "You already have a pending room request. Please wait for admin response.");
                request.setAttribute("myRequests", getMyRequests(email));
                request.setAttribute("rooms", RoomServlet.getRoomList());
                request.getRequestDispatcher("WEB-INF/pages/studentRoomRequest.jsp").forward(request, response);
                return;
            }
        }

        requestList.add(new RoomRequest(email, email, preferredRoom.trim(), reason.trim()));
        session.setAttribute("flash", "Room request submitted. The admin will review it shortly.");
        response.sendRedirect("roomRequests");
    }

    private ArrayList<RoomRequest> getMyRequests(String email) {
        ArrayList<RoomRequest> mine = new ArrayList<>();
        for (RoomRequest rr : requestList)
            if (rr.getStudentEmail().equalsIgnoreCase(email)) mine.add(rr);
        return mine;
    }
}