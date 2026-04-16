<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — Smart Hostel</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="page-wrapper">

<nav class="topbar">
    <a href="home" class="topbar-brand">
        <div class="brand-icon">🏨</div>
        <span>Smart Hostel</span>
    </a>
    <div class="topbar-nav">
        <a href="students">Students</a>
        <a href="rooms">Rooms</a>
        <a href="complaints">Complaints</a>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <div class="alert alert-error" id="alertBox">
        <span class="alert-icon">⚠</span>
        <span><%= error %></span>
        <button class="alert-close" onclick="this.parentElement.remove()">✕</button>
    </div>
    <% } %>

    <!-- Welcome Banner -->
    <div class="welcome-banner">
        <div>
            <h2>Welcome back, Administrator</h2>
            <p>Manage your hostel operations from the dashboard below.</p>
        </div>
        <span class="amber-pill">Admin Panel</span>
    </div>

    <!-- Stats Row -->
    <%
        java.util.ArrayList<?> studentsForCount =
            (java.util.ArrayList<?>) request.getAttribute("studentCount");
        java.util.ArrayList<?> roomsForCount =
            (java.util.ArrayList<?>) request.getAttribute("roomCount");
        java.util.ArrayList<?> complaintsForCount =
            (java.util.ArrayList<?>) request.getAttribute("complaintCount");

        int totalStudents   = studentsForCount   != null ? studentsForCount.size()   : 0;
        int totalRooms      = roomsForCount      != null ? roomsForCount.size()      : 0;
        int totalComplaints = complaintsForCount != null ? complaintsForCount.size() : 0;
    %>
    <div class="dashboard-grid">
        <div class="stat-card" style="animation-delay:0.05s">
            <div class="stat-icon navy">👥</div>
            <div class="stat-info">
                <p>Total Students</p>
                <h3 class="count-up" data-target="<%= totalStudents %>">0</h3>
            </div>
        </div>
        <div class="stat-card" style="animation-delay:0.10s">
            <div class="stat-icon amber">🚪</div>
            <div class="stat-info">
                <p>Total Rooms</p>
                <h3 class="count-up" data-target="<%= totalRooms %>">0</h3>
            </div>
        </div>
        <div class="stat-card" style="animation-delay:0.15s">
            <div class="stat-icon red">📋</div>
            <div class="stat-info">
                <p>Open Complaints</p>
                <h3 class="count-up" data-target="<%= totalComplaints %>">0</h3>
            </div>
        </div>
        <div class="stat-card" style="animation-delay:0.20s">
            <div class="stat-icon green">🏠</div>
            <div class="stat-info">
                <p>Occupancy</p>
                <h3>—</h3>
            </div>
        </div>
    </div>

    <!-- Navigation Menu Cards -->
    <div class="page-card">
        <div class="page-card-header">
            <h2>Management Modules</h2>
        </div>
        <div class="menu-grid">
            <a href="students" class="menu-card" style="animation-delay:0.1s">
                <div class="menu-icon">👨‍🎓</div>
                <span>Students</span>
                <small>View &amp; manage residents</small>
            </a>
            <a href="rooms" class="menu-card" style="animation-delay:0.15s">
                <div class="menu-icon">🚪</div>
                <span>Rooms</span>
                <small>Add, edit &amp; assign rooms</small>
            </a>
            <a href="complaints" class="menu-card" style="animation-delay:0.20s">
                <div class="menu-icon">📋</div>
                <span>Complaints</span>
                <small>Review &amp; resolve issues</small>
            </a>
        </div>
    </div>

</div>

<footer class="footer">
    &copy; 2025 Smart Hostel Management System. All rights reserved.
</footer>

<script>
    /* ── Animated Count-Up Numbers ───────────────── */
    document.querySelectorAll('.count-up').forEach(function(el) {
        const target  = parseInt(el.getAttribute('data-target'), 10) || 0;
        if (target === 0) { el.textContent = '0'; return; }
        const duration = 900;
        const step     = Math.ceil(duration / target);
        let current    = 0;
        const timer    = setInterval(function() {
            current += 1;
            el.textContent = current;
            if (current >= target) { clearInterval(timer); el.textContent = target; }
        }, step);
    });

    /* Auto-dismiss alerts */
    var alertBox = document.getElementById('alertBox');
    if (alertBox) {
        setTimeout(function() {
            alertBox.style.transition = 'opacity 0.5s';
            alertBox.style.opacity = '0';
            setTimeout(function() { alertBox.remove(); }, 500);
        }, 6000);
    }
</script>

</body>
</html>
