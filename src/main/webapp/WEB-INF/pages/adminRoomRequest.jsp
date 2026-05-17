<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Requests — Smart Hostel Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .req-card {
            border: 1px solid #e2ddd6; border-radius: 10px;
            padding: 18px 20px; margin-bottom: 12px; background: #fff;
            transition: all .18s; animation: fadeUp .4s ease both;
        }
        .req-card:hover { box-shadow: 0 4px 20px rgba(13,27,42,.1); }
        .req-card.pending  { border-left: 4px solid #e8a020; }
        .req-card.approved { border-left: 4px solid #2e9e6b; opacity:.82; }
        .req-card.denied   { border-left: 4px solid #d94f4f; opacity:.72; }
        .req-top { display:flex; align-items:flex-start; justify-content:space-between; gap:12px; margin-bottom:12px; }
        .req-student { display:flex; align-items:center; gap:9px; }
        .req-actions { display:flex; gap:6px; flex-wrap:wrap; flex-shrink:0; }
        .req-room-tag {
            display:inline-flex; align-items:center; gap:5px;
            background:#e8eef5; padding:3px 11px; border-radius:20px;
            font-size:.8rem; font-weight:700; color:#0d1b2a; margin-bottom:8px;
        }
        .req-reason { font-size:.87rem; color:#4a5568; line-height:1.6;
                      background:#faf8f5; padding:10px 14px; border-radius:6px; }
        .req-time   { font-size:.75rem; color:#8a9ab0; margin-top:8px; }
    </style>
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
        <a href="roomRequests" class="active">Room Requests</a>
        <a href="complaints">Complaints</a>
        <a href="payments">Payments</a>
        <a href="users">Users</a>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <%
        String error   = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        java.util.ArrayList<com.hostel.model.RoomRequest> roomRequests =
            (java.util.ArrayList<com.hostel.model.RoomRequest>) request.getAttribute("roomRequests");

        int total = (roomRequests != null) ? roomRequests.size() : 0;
        int pendingC = 0; int approvedC = 0; int deniedC = 0;
        if (roomRequests != null) {
            for (com.hostel.model.RoomRequest rr : roomRequests) {
                if (rr.isPending()) pendingC++;
                else if (rr.isApproved()) approvedC++;
                else deniedC++;
            }
        }
    %>

    <% if (error != null) { %>
    <div class="alert alert-error" id="alertBox">
        <span class="alert-icon">⚠</span><span><%= error %></span>
        <button class="alert-close" onclick="this.parentElement.remove()">✕</button>
    </div>
    <% } %>
    <% if (success != null) { %>
    <div class="alert alert-success" id="alertBox">
        <span class="alert-icon">✓</span><span><%= success %></span>
        <button class="alert-close" onclick="this.parentElement.remove()">✕</button>
    </div>
    <% } %>

    <h1 class="page-title">Room Requests</h1>
    <p class="page-subtitle">Review and respond to student room allocation requests.</p>

    <!-- Stats -->
    <div class="dashboard-grid" style="margin-bottom:24px;">
        <div class="stat-card">
            <div class="stat-icon navy">📬</div>
            <div class="stat-info"><p>Total</p><h3 class="count-up" data-target="<%= total %>">0</h3></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon amber">⏳</div>
            <div class="stat-info"><p>Pending</p><h3 class="count-up" data-target="<%= pendingC %>">0</h3></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green">✔</div>
            <div class="stat-info"><p>Approved</p><h3 class="count-up" data-target="<%= approvedC %>">0</h3></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon red">✕</div>
            <div class="stat-info"><p>Denied</p><h3 class="count-up" data-target="<%= deniedC %>">0</h3></div>
        </div>
    </div>

    <div class="page-card">
        <div class="page-card-header">
            <h2>All Room Requests</h2>
            <div style="display:flex; gap:6px;">
                <button class="filter-btn active" onclick="filterReq('all',this)">All</button>
                <button class="filter-btn" onclick="filterReq('pending',this)">Pending</button>
                <button class="filter-btn" onclick="filterReq('approved',this)">Approved</button>
                <button class="filter-btn" onclick="filterReq('denied',this)">Denied</button>
            </div>
        </div>

        <% if (roomRequests == null || roomRequests.isEmpty()) { %>
        <div class="empty-state">
            <span class="empty-icon">📬</span>
            <p class="empty-title">No room requests yet</p>
            <p>Student requests will appear here once submitted.</p>
        </div>
        <% } else { %>
        <div id="reqContainer">
            <% for (int i = 0; i < roomRequests.size(); i++) {
                com.hostel.model.RoomRequest rr = roomRequests.get(i);
                String cls = rr.isPending() ? "pending" : rr.isApproved() ? "approved" : "denied";
            %>
            <div class="req-card <%= cls %>" data-status="<%= cls %>"
                 style="animation-delay:<%= i * 0.05 %>s">
                <div class="req-top">
                    <div class="req-student">
                        <div style="width:36px; height:36px; border-radius:50%; background:#0d1b2a;
                                    display:flex; align-items:center; justify-content:center;
                                    font-size:14px; color:white; font-weight:700; flex-shrink:0;">
                            <%= rr.getStudentEmail().substring(0,1).toUpperCase() %>
                        </div>
                        <div>
                            <div style="font-weight:700; font-size:.9rem; color:#0d1b2a;">
                                <%= rr.getStudentName() %>
                            </div>
                            <div style="font-size:.77rem; color:#5a6a7e;"><%= rr.getStudentEmail() %></div>
                        </div>
                    </div>
                    <div style="display:flex; flex-direction:column; align-items:flex-end; gap:6px;">
                        <% if (rr.isPending()) { %>
                            <span class="badge badge-pending">⏳ Pending</span>
                        <% } else if (rr.isApproved()) { %>
                            <span class="badge badge-approved">✔ Approved</span>
                        <% } else { %>
                            <span class="badge badge-denied">✕ Denied</span>
                        <% } %>
                        <div class="req-actions">
                            <% if (rr.isPending()) { %>
                            <a href="roomRequests?approve=<%= i %>" class="action-link approve"
                               onclick="return confirm('Approve this room request?')">✔ Approve</a>
                            <a href="roomRequests?deny=<%= i %>" class="action-link deny"
                               onclick="return confirm('Deny this room request?')">✕ Deny</a>
                            <% } %>
                            <a href="#" class="action-link delete"
                               onclick="confirmRRDelete(event,'roomRequests?delete=<%= i %>','<%= rr.getStudentName().replace("'","") %>')">🗑</a>
                        </div>
                    </div>
                </div>
                <div>
                    <span class="req-room-tag">🚪 Preferred: Room <%= rr.getPreferredRoom() %></span>
                </div>
                <div class="req-reason"><%= rr.getReason() %></div>
                <% if (rr.getAdminNote() != null && !rr.getAdminNote().isEmpty()) { %>
                <div style="margin-top:8px; font-size:.8rem; color:#5a6a7e; font-style:italic;">
                    📝 Note: <%= rr.getAdminNote() %>
                </div>
                <% } %>
                <div class="req-time">🕐 Submitted: <%= rr.getSubmittedAt() %></div>
            </div>
            <% } %>
        </div>
        <div id="noRRResults" style="display:none; padding:28px; text-align:center; color:#5a6a7e; font-size:.9rem;">
            No requests match the selected filter.
        </div>
        <% } %>
    </div>

    <a href="home" class="back-link">← Back to Dashboard</a>
</div>

<!-- Delete Confirm Modal -->
<div id="rrConfirmModal" style="display:none; position:fixed; inset:0;
     background:rgba(11,25,41,.55); z-index:1000; align-items:center; justify-content:center; padding:20px;">
    <div style="background:#fff; border-radius:14px; padding:32px 36px; max-width:380px; width:100%;
                box-shadow:0 24px 72px rgba(13,27,42,.22); text-align:center;">
        <div style="font-size:38px; margin-bottom:14px;">🗑️</div>
        <h3 style="font-family:'Cormorant Garamond',serif; font-size:1.3rem; color:#0d1b2a; margin-bottom:8px;">Delete Request?</h3>
        <p id="rrConfirmMsg" style="color:#5a6a7e; font-size:.9rem; margin-bottom:24px;"></p>
        <div style="display:flex; gap:12px; justify-content:center;">
            <button onclick="closeRRModal()" class="btn btn-outline">Cancel</button>
            <a id="rrConfirmAction" href="#" class="btn btn-danger">Yes, Delete</a>
        </div>
    </div>
</div>

<footer class="footer">&copy; 2025 Smart Hostel Management System. All rights reserved.</footer>

<script>
    function filterReq(status, btn) {
        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        let vis = 0;
        document.querySelectorAll('.req-card').forEach(c => {
            const show = status === 'all' || c.getAttribute('data-status') === status;
            c.style.display = show ? '' : 'none';
            if (show) vis++;
        });
        document.getElementById('noRRResults').style.display = vis === 0 ? 'block' : 'none';
    }

    function confirmRRDelete(e, url, name) {
        e.preventDefault();
        document.getElementById('rrConfirmMsg').textContent =
            'Delete the room request from "' + name + '"? This cannot be undone.';
        document.getElementById('rrConfirmAction').href = url;
        document.getElementById('rrConfirmModal').style.display = 'flex';
    }
    function closeRRModal() { document.getElementById('rrConfirmModal').style.display = 'none'; }
    document.getElementById('rrConfirmModal').addEventListener('click', function(e) {
        if (e.target === this) closeRRModal();
    });

    document.querySelectorAll('.count-up').forEach(el => {
        const target = parseInt(el.getAttribute('data-target'), 10) || 0;
        if (!target) { el.textContent = '0'; return; }
        let cur = 0;
        const t = setInterval(() => { cur++; el.textContent = cur; if (cur >= target) { clearInterval(t); } }, Math.ceil(900/target));
    });

    var alertBox = document.getElementById('alertBox');
    if (alertBox) {
        setTimeout(() => { alertBox.style.transition = 'opacity .5s'; alertBox.style.opacity = '0';
            setTimeout(() => alertBox.remove(), 500); }, 5000);
    }
</script>
</body>
</html>
