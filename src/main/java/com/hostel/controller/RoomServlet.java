package com.hostel.controller;

import java.io.IOException;
import java.util.ArrayList;

import com.hostel.model.Room;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/rooms")
public class RoomServlet extends HttpServlet {

    static final ArrayList<Room> roomList = new ArrayList<>();

    /** Called by HomeServlet for dashboard stat count */
    public static ArrayList<Room> getRoomList() {
        return roomList;
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
                    if (index >= 0 && index < roomList.size()) {
                        String roomNum = roomList.get(index).getRoomNumber();
                        roomList.remove(index);
                        session.setAttribute("flash", "Room " + roomNum + " has been deleted.");
                    } else {
                        session.setAttribute("flash", "Room not found — it may have already been removed.");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("flash", "Invalid delete request.");
                }
                response.sendRedirect("rooms");
                return;
            }

            // Edit
            String editIndex = request.getParameter("edit");
            if (editIndex != null) {
                try {
                    int index = Integer.parseInt(editIndex);
                    if (index >= 0 && index < roomList.size()) {
                        request.setAttribute("editRoom",  roomList.get(index));
                        request.setAttribute("editIndex", index);
                    } else {
                        request.setAttribute("error", "Room not found. It may have been removed.");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid request. Please try again.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong. Please refresh the page.");
        }

        request.setAttribute("rooms", roomList);
        request.getRequestDispatcher("WEB-INF/pages/rooms.jsp").forward(request, response);
    }

    // ── POST ────────────────────────────────────────────────────
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login");
            return;
        }

        String roomNumber   = request.getParameter("roomNumber");
        String capacityStr  = request.getParameter("capacity");
        String editIndexStr = request.getParameter("editIndex");

        // ── Validation ─────────────────────────────────────────
        if (roomNumber == null || roomNumber.trim().isEmpty()) {
            request.setAttribute("error", "Room number is required.");
            request.setAttribute("rooms", roomList);
            request.getRequestDispatcher("WEB-INF/pages/rooms.jsp").forward(request, response);
            return;
        }

        if (capacityStr == null || capacityStr.trim().isEmpty()) {
            request.setAttribute("error", "Room capacity is required.");
            request.setAttribute("rooms", roomList);
            request.getRequestDispatcher("WEB-INF/pages/rooms.jsp").forward(request, response);
            return;
        }

        try {
            int capacity = Integer.parseInt(capacityStr.trim());

            if (capacity < 1 || capacity > 20) {
                request.setAttribute("error", "Capacity must be between 1 and 20.");
                request.setAttribute("rooms", roomList);
                request.getRequestDispatcher("WEB-INF/pages/rooms.jsp").forward(request, response);
                return;
            }

            roomNumber = roomNumber.trim().toUpperCase();

            if (editIndexStr != null && !editIndexStr.isEmpty()) {
                // UPDATE
                int index = Integer.parseInt(editIndexStr.trim());
                if (index >= 0 && index < roomList.size()) {
                    roomList.set(index, new Room(roomNumber, capacity));
                    session.setAttribute("flash", "Room " + roomNumber + " updated successfully.");
                } else {
                    request.setAttribute("error", "Room not found. It may have been removed.");
                    request.setAttribute("rooms", roomList);
                    request.getRequestDispatcher("WEB-INF/pages/rooms.jsp").forward(request, response);
                    return;
                }
            } else {
                // CREATE — check for duplicate room number
                for (Room r : roomList) {
                    if (r.getRoomNumber().equalsIgnoreCase(roomNumber)) {
                        request.setAttribute("error",
                            "Room " + roomNumber + " already exists. Please use a different room number.");
                        request.setAttribute("rooms", roomList);
                        request.getRequestDispatcher("WEB-INF/pages/rooms.jsp").forward(request, response);
                        return;
                    }
                }
                roomList.add(new Room(roomNumber, capacity));
                session.setAttribute("flash", "Room " + roomNumber + " added successfully.");
            }

            response.sendRedirect("rooms");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Capacity must be a whole number (e.g. 2).");
            request.setAttribute("rooms", roomList);
            request.getRequestDispatcher("WEB-INF/pages/rooms.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Operation failed. Please try again.");
            request.setAttribute("rooms", roomList);
            request.getRequestDispatcher("WEB-INF/pages/rooms.jsp").forward(request, response);
        }
    }
}