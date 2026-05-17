<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard — Smart Hostel</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="page-wrapper">

<nav class="topbar">
    <a href="studentHome" class="topbar-brand">
        <div class="brand-icon">🏨</div>
        <span>Smart Hostel</span>
    </a>
    <div class="topbar-nav">
        <a href="complaints">Complaints</a>
        <a href="payments">My Payments</a>
        <a href="roomRequests">Room Request</a>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <%
        String error     = (String) request.getAttribute("error");
        String success   = (String) request.getAttribute("success");
        String userEmail = (String) request.getAttribute("userEmail");
        if (userEmail == null) userEmail = (String) session.getAttribute("userEmail");

        java.util.ArrayList<com.hostel.model.Room> roomList =
            (java.util.ArrayList<com.hostel.model.Room>) request.getAttribute("roomList");
    %>

    <% if (error != null) { %>
    <div class="alert alert-error" id="alertBox">
        <span class="alert-icon">⚠</span>
        <span><%= error %></span>
        <button class="alert-close" onclick="this.parentElement.remove()">✕</button>
    </div>
    <% } %>

    <% if (success != null) { %>
    <div class="alert alert-success" id="alertBox">
        <span class="alert-icon">✓</span>
        <span><%= success %></span>
        <button class="alert-close" onclick="this.parentElement.remove()">✕</button>
    </div>
    <% } %>

    <!-- Welcome Banner -->
    <div class="welcome-banner">
        <div>
            <h2>Welcome, <%= userEmail != null ? userEmail : "Student" %></h2>
            <p>Access your hostel services and account information below.</p>
        </div>
        <span class="amber-pill">Student Portal</span>
    </div>

    <!-- Quick Actions -->
    <div class="page-card">
        <div class="page-card-header">
            <h2>Quick Actions</h2>
        </div>
        <div class="menu-grid">
            <a href="complaints" class="menu-card">
                <div class="menu-icon">📋</div>
                <span>My Complaints</span>
                <small>Submit &amp; track issues</small>
            </a>
            <a href="payments" class="menu-card">
                <div class="menu-icon">💳</div>
                <span>Fee Payments</span>
                <small>View payment status</small>
            </a>
            <a href="roomRequests" class="menu-card">
                <div class="menu-icon">📬</div>
                <span>Room Request</span>
                <small>Request a preferred room</small>
            </a>
            <a href="#room-info" class="menu-card"
               onclick="document.getElementById('room-info').scrollIntoView({behavior:'smooth'}); return false;">
                <div class="menu-icon">🚪</div>
                <span>Room Info</span>
                <small>View available rooms</small>
            </a>
        </div>
    </div>

    <!-- ROOM INFO SECTION -->
    <div class="page-card" id="room-info">
        <div class="page-card-header">
            <h2>Room Information</h2>
        </div>

        <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-bottom:24px;" id="facilGrid">
            <div style="padding:16px 18px; background:#f7f3ec; border-radius:10px; border-left:4px solid #e8a020;">
                <strong style="font-size:.92rem; color:#0d1b2a; display:block; margin-bottom:10px;">Room Facilities</strong>
                <div style="display:flex; flex-direction:column; gap:7px;">
                    <span style="font-size:.85rem; color:#5a6a7e;">✔ Bed, mattress &amp; pillow provided</span>
                    <span style="font-size:.85rem; color:#5a6a7e;">✔ Study table &amp; chair</span>
                    <span style="font-size:.85rem; color:#5a6a7e;">✔ Wardrobe / personal storage</span>
                    <span style="font-size:.85rem; color:#5a6a7e;">✔ Wi-Fi access included</span>
                    <span style="font-size:.85rem; color:#5a6a7e;">✔ 24/7 electricity supply</span>
                </div>
            </div>
            <div style="padding:16px 18px; background:#f0f8f4; border-radius:10px; border-left:4px solid #2e9e6b;">
                <strong style="font-size:.92rem; color:#0d1b2a; display:block; margin-bottom:10px;">Room Rules</strong>
                <div style="display:flex; flex-direction:column; gap:7px;">
                    <span style="font-size:.85rem; color:#5a6a7e;">→ No guests after 8:00 PM</span>
                    <span style="font-size:.85rem; color:#5a6a7e;">→ Keep rooms clean at all times</span>
                    <span style="font-size:.85rem; color:#5a6a7e;">→ No cooking inside rooms</span>
                    <span style="font-size:.85rem; color:#5a6a7e;">→ Lights off by 11:00 PM in common areas</span>
                    <span style="font-size:.85rem; color:#5a6a7e;">→ Report any damage immediately</span>
                </div>
            </div>
        </div>

        <div style="padding:14px 18px; background:#fdf2dc; border:1px solid #f5bc50;
                    border-radius:8px; display:flex; align-items:flex-start; gap:12px; margin-bottom:24px;">
            <span style="font-size:20px; flex-shrink:0; margin-top:2px;">ℹ</span>
            <div>
                <strong style="font-size:.9rem; color:#0d1b2a; display:block; margin-bottom:4px;">Room Assignment</strong>
                <p style="font-size:.85rem; color:#5a6a7e; line-height:1.5; margin:0;">
                    Room assignments are managed by the hostel administration. Need a specific room?
                    <a href="roomRequests" style="color:#0d1b2a; font-weight:600;
                       border-bottom:1px solid #e8a020; text-decoration:none;">
                        Submit a room request
                    </a> and the admin will review it.
                </p>
            </div>
        </div>

        <!-- Available Rooms Table -->
        <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:14px;">
            <strong style="font-size:1rem; color:#0d1b2a;">Available Rooms</strong>
            <%  int roomCount = (roomList != null) ? roomList.size() : 0; %>
            <span style="font-size:.82rem; color:#5a6a7e; background:#f7f3ec;
                         padding:4px 12px; border-radius:20px; font-weight:600;">
                <%= roomCount %> Room<%= roomCount != 1 ? "s" : "" %> Listed
            </span>
        </div>

        <% if (roomList == null || roomList.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon">🚪</div>
            <p class="empty-title">No rooms listed yet</p>
            <p>The administration has not added any rooms yet. Please check back later.</p>
        </div>
        <% } else { %>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Room Number</th>
                        <th>Capacity</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (int i = 0; i < roomList.size(); i++) {
                        com.hostel.model.Room r = roomList.get(i); %>
                    <tr>
                        <td style="color:#5a6a7e; font-size:.85rem;"><%= i + 1 %></td>
                        <td><strong style="color:#0d1b2a;">Room <%= r.getRoomNumber() %></strong></td>
                        <td><%= r.getCapacity() %> person<%= r.getCapacity() != 1 ? "s" : "" %></td>
                        <td><span class="badge badge-resolved">Available</span></td>
                        <td>
                            <a href="roomRequests" class="action-link approve" style="font-size:.77rem;">
                                📬 Request
                            </a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>

    <!-- Notice Board -->
    <div class="page-card">
        <div class="page-card-header">
            <h2>Notice Board</h2>
        </div>
        <div style="display:flex; flex-direction:column; gap:12px;">
            <div style="padding:14px 16px; background:#fdf8f0; border-left:4px solid #e8a020; border-radius:6px;">
                <strong style="font-size:.9rem; color:#0d1b2a;">Mess Timings</strong>
                <p style="font-size:.85rem; color:#5a6a7e; margin-top:3px;">
                    Breakfast 7:00 – 9:00 AM &nbsp;·&nbsp; Lunch 12:00 – 2:00 PM &nbsp;·&nbsp; Dinner 7:00 – 9:00 PM
                </p>
            </div>
            <div style="padding:14px 16px; background:#f0f8f4; border-left:4px solid #2e9e6b; border-radius:6px;">
                <strong style="font-size:.9rem; color:#0d1b2a;">Gate Timings</strong>
                <p style="font-size:.85rem; color:#5a6a7e; margin-top:3px;">
                    Main gate closes at <strong>10:00 PM</strong>. Please carry your hostel ID card at all times.
                </p>
            </div>
            <div style="padding:14px 16px; background:#eef2f7; border-left:4px solid #0d1b2a; border-radius:6px;">
                <strong style="font-size:.9rem; color:#0d1b2a;">Maintenance Notice</strong>
                <p style="font-size:.85rem; color:#5a6a7e; margin-top:3px;">
                    Water supply may be interrupted on Sundays 9 – 11 AM for routine maintenance.
                </p>
            </div>
        </div>
    </div>

    <!-- My Account -->
    <div class="page-card">
        <div class="page-card-header">
            <h2>My Account</h2>
        </div>
        <div style="display:flex; align-items:center; gap:20px; flex-wrap:wrap;">
            <div style="width:56px; height:56px; border-radius:50%; background:#0d1b2a;
                        display:flex; align-items:center; justify-content:center; font-size:24px; flex-shrink:0; color:white;">
                👤
            </div>
            <div>
                <p style="font-size:.8rem; color:#5a6a7e; font-weight:700; text-transform:uppercase;
                           letter-spacing:.07em; margin-bottom:3px;">Logged in as</p>
                <p style="font-size:1rem; font-weight:700; color:#0d1b2a;">
                    <%= userEmail != null ? userEmail : "—" %>
                </p>
                <p style="font-size:.8rem; color:#5a6a7e; margin-top:2px;">Student</p>
            </div>
            <a href="logout" class="btn btn-outline" style="margin-left:auto;">Logout</a>
        </div>
    </div>

</div>

<footer class="footer">
    &copy; 2025 Smart Hostel Management System. All rights reserved.
</footer>

<script>
    var alertBox = document.getElementById('alertBox');
    if (alertBox) {
        setTimeout(function() {
            alertBox.style.transition = 'opacity 0.5s'; alertBox.style.opacity = '0';
            setTimeout(function() { alertBox.remove(); }, 500);
        }, 6000);
    }
    function checkFacilGrid() {
        const g = document.getElementById('facilGrid');
        if (g) g.style.gridTemplateColumns = window.innerWidth < 640 ? '1fr' : '1fr 1fr';
    }
    checkFacilGrid(); window.addEventListener('resize', checkFacilGrid);
</script>

</body>
</html>
