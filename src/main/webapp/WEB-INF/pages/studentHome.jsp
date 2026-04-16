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
        <a href="complaints">My Complaints</a>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <%
        String error    = (String) request.getAttribute("error");
        String userEmail = (String) request.getAttribute("userEmail");
        if (userEmail == null) userEmail = (String) session.getAttribute("userEmail");
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
            <a href="complaints" class="menu-card" style="animation-delay:0.05s">
                <div class="menu-icon">📋</div>
                <span>Submit Complaint</span>
                <small>Report an issue to management</small>
            </a>
            <a href="rooms" class="menu-card" style="animation-delay:0.1s">
                <div class="menu-icon">🚪</div>
                <span>Room Info</span>
                <small>View your room details</small>
            </a>
        </div>
    </div>

    <!-- Notice Board -->
    <div class="page-card">
        <div class="page-card-header">
            <h2>📌 Notice Board</h2>
        </div>
        <div style="display:flex; flex-direction:column; gap:12px;">
            <div class="notice-item amber">
                <strong>Mess Timings</strong>
                <p>Breakfast 7:00–9:00 AM &nbsp;·&nbsp; Lunch 12:00–2:00 PM &nbsp;·&nbsp; Dinner 7:00–9:00 PM</p>
            </div>
            <div class="notice-item green">
                <strong>Gate Timings</strong>
                <p>Main gate closes at <strong>10:00 PM</strong>. Please carry your hostel ID card at all times.</p>
            </div>
            <div class="notice-item navy">
                <strong>Maintenance Notice</strong>
                <p>Water supply may be interrupted on Sundays 9–11 AM for routine maintenance.</p>
            </div>
        </div>
    </div>

    <!-- Student Info Card -->
    <div class="page-card">
        <div class="page-card-header">
            <h2>My Account</h2>
        </div>
        <div style="display:flex; align-items:center; gap:20px; flex-wrap:wrap;">
            <div style="width:56px; height:56px; border-radius:50%; background:var(--navy);
                        display:flex; align-items:center; justify-content:center;
                        font-size:24px; flex-shrink:0;">👤</div>
            <div>
                <p style="font-size:0.8rem; color:var(--text-soft); font-weight:700;
                           text-transform:uppercase; letter-spacing:0.07em; margin-bottom:3px;">
                    Logged in as
                </p>
                <p style="font-size:1rem; font-weight:700; color:var(--navy);">
                    <%= userEmail != null ? userEmail : "—" %>
                </p>
                <p style="font-size:0.8rem; color:var(--text-muted); margin-top:2px;">Student</p>
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
            alertBox.style.transition = 'opacity 0.5s';
            alertBox.style.opacity = '0';
            setTimeout(function() { alertBox.remove(); }, 500);
        }, 6000);
    }
</script>

</body>
</html>
