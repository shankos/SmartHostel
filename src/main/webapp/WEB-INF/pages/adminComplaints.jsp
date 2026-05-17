<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaints — Smart Hostel Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .complaint-card {
            border: 1px solid #e2ddd6; border-radius: 10px;
            padding: 18px 20px; margin-bottom: 12px;
            background: #fff; transition: all .18s;
            animation: fadeUp .4s ease both;
        }
        .complaint-card:hover { box-shadow: 0 4px 20px rgba(13,27,42,.1); transform: translateY(-1px); }
        .complaint-card.resolved { opacity: .75; border-left: 4px solid #2e9e6b; }
        .complaint-card.pending  { border-left: 4px solid #e8a020; }
        .card-header { display: flex; align-items: flex-start; justify-content: space-between; gap: 12px; margin-bottom: 12px; }
        .card-meta   { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
        .timestamp   { font-size: .75rem; color: #8a9ab0; }
        .desc-text   { font-size: .88rem; color: #4a5568; line-height: 1.6; padding: 10px 14px;
                       background: #faf8f5; border-radius: 6px; word-break: break-word; }
        .student-chip {
            display: inline-flex; align-items: center; gap: 6px;
            background: #e8eef5; padding: 3px 10px; border-radius: 20px;
            font-size: .77rem; color: #0d1b2a; font-weight: 600;
        }
        .filter-bar  { display: flex; gap: 8px; flex-wrap: wrap; align-items: center; margin-bottom: 18px; }
        .search-input-wrap { flex: 1; min-width: 200px; max-width: 320px; }
        #studentFilter { max-width: 220px; font-size: .85rem; padding: 8px 12px; }
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
        <a href="complaints" class="active">Complaints</a>
        <a href="payments">Payments</a>
        <a href="users">Users</a>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <%
        String error   = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        java.util.ArrayList<com.hostel.model.Complaint> complaints =
            (java.util.ArrayList<com.hostel.model.Complaint>) request.getAttribute("complaints");

        int totalC = (complaints != null) ? complaints.size() : 0;
        int pendingC = 0; int resolvedC = 0;
        java.util.LinkedHashSet<String> studentEmails = new java.util.LinkedHashSet<>();
        if (complaints != null) {
            for (com.hostel.model.Complaint c : complaints) {
                if ("Pending".equals(c.getStatus())) pendingC++;
                else resolvedC++;
                studentEmails.add(c.getUserEmail());
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

    <h1 class="page-title">Complaint Management</h1>
    <p class="page-subtitle">Review, filter, and resolve student complaints.</p>

    <!-- Stats -->
    <div class="dashboard-grid" style="margin-bottom:24px;">
        <div class="stat-card">
            <div class="stat-icon navy">📋</div>
            <div class="stat-info"><p>Total</p><h3 class="count-up" data-target="<%= totalC %>">0</h3></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon amber">⏳</div>
            <div class="stat-info"><p>Pending</p><h3 class="count-up" data-target="<%= pendingC %>">0</h3></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green">✔</div>
            <div class="stat-info"><p>Resolved</p><h3 class="count-up" data-target="<%= resolvedC %>">0</h3></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon blue">👥</div>
            <div class="stat-info"><p>Students</p><h3><%= studentEmails.size() %></h3></div>
        </div>
    </div>

    <div class="page-card">
        <div class="page-card-header">
            <h2>All Complaints</h2>
        </div>

        <!-- Filter Bar -->
        <div class="filter-bar">
            <div style="display:flex; gap:6px;">
                <button class="filter-btn active" onclick="filterAdminComp('all',this)">All</button>
                <button class="filter-btn" onclick="filterAdminComp('pending',this)">Pending</button>
                <button class="filter-btn" onclick="filterAdminComp('resolved',this)">Resolved</button>
            </div>
            <div class="search-input-wrap">
                <input type="text" id="compSearch" placeholder="🔍 Search by student or description…"
                       style="font-size:.85rem; padding:8px 13px;" oninput="applyFilters()">
            </div>
            <select id="studentFilter" onchange="applyFilters()">
                <option value="">All Students</option>
                <% for (String email : studentEmails) { %>
                <option value="<%= email %>"><%= email %></option>
                <% } %>
            </select>
        </div>

        <% if (complaints == null || complaints.isEmpty()) { %>
        <div class="empty-state">
            <span class="empty-icon">🎉</span>
            <p class="empty-title">No complaints submitted</p>
            <p>Everything is running smoothly!</p>
        </div>
        <% } else { %>
        <div id="complaintCards">
            <%
                for (int i = 0; i < complaints.size(); i++) {
                    com.hostel.model.Complaint c = complaints.get(i);
                    String statusCls = "Pending".equals(c.getStatus()) ? "pending" : "resolved";
            %>
            <div class="complaint-card <%= statusCls %>"
                 data-status="<%= statusCls %>"
                 data-student="<%= c.getUserEmail() %>"
                 data-text="<%= c.getDescription().toLowerCase().replace("\"","") %>"
                 style="animation-delay:<%= i * 0.05 %>s">
                <div class="card-header">
                    <div class="card-meta">
                        <div style="width:32px; height:32px; border-radius:50%; background:#0d1b2a;
                                    display:flex; align-items:center; justify-content:center;
                                    font-size:13px; color:white; font-weight:700; flex-shrink:0;">
                            <%= c.getUserEmail().substring(0,1).toUpperCase() %>
                        </div>
                        <span class="student-chip">📧 <%= c.getUserEmail() %></span>
                        <span class="timestamp">🕐 <%= c.getTimestamp() %></span>
                    </div>
                    <div style="display:flex; align-items:center; gap:8px; flex-shrink:0;">
                        <% if ("Pending".equals(c.getStatus())) { %>
                            <span class="badge badge-pending">⏳ Pending</span>
                            <a href="complaints?resolve=<%= i %>" class="action-link resolve"
                               onclick="return confirmResolveAdmin(event, this.href)">✔ Resolve</a>
                        <% } else { %>
                            <span class="badge badge-resolved">✔ Resolved</span>
                        <% } %>
                    </div>
                </div>
                <div class="desc-text"><%= c.getDescription() %></div>
            </div>
            <% } %>
        </div>
        <div id="noCompResults" style="display:none; padding:32px; text-align:center; color:#5a6a7e; font-size:.9rem;">
            No complaints match your current filters.
        </div>
        <% } %>
    </div>

    <a href="home" class="back-link">← Back to Dashboard</a>
</div>

<footer class="footer">&copy; 2025 Smart Hostel Management System. All rights reserved.</footer>

<script>
    let activeStatusFilter = 'all';

    function filterAdminComp(status, btn) {
        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        activeStatusFilter = status;
        applyFilters();
    }

    function applyFilters() {
        const searchQ  = document.getElementById('compSearch').value.toLowerCase();
        const studentQ = document.getElementById('studentFilter').value.toLowerCase();
        const cards    = document.querySelectorAll('.complaint-card');
        let vis = 0;
        cards.forEach(card => {
            const statusOk  = activeStatusFilter === 'all' || card.getAttribute('data-status') === activeStatusFilter;
            const studentOk = !studentQ || card.getAttribute('data-student').toLowerCase() === studentQ;
            const searchOk  = !searchQ || card.getAttribute('data-text').includes(searchQ)
                              || card.getAttribute('data-student').toLowerCase().includes(searchQ);
            const show = statusOk && studentOk && searchOk;
            card.style.display = show ? '' : 'none';
            if (show) vis++;
        });
        document.getElementById('noCompResults').style.display = vis === 0 ? 'block' : 'none';
    }

    function confirmResolveAdmin(e, href) {
        e.preventDefault();
        if (confirm('Mark this complaint as resolved?\nThis action cannot be undone.')) {
            window.location.href = href;
        }
        return false;
    }

    document.querySelectorAll('.count-up').forEach(el => {
        const target = parseInt(el.getAttribute('data-target'), 10) || 0;
        if (!target) { el.textContent = '0'; return; }
        let cur = 0;
        const t = setInterval(() => {
            cur++;
            el.textContent = cur;
            if (cur >= target) { clearInterval(t); el.textContent = target; }
        }, Math.ceil(900/target));
    });

    var alertBox = document.getElementById('alertBox');
    if (alertBox) {
        setTimeout(() => { alertBox.style.transition = 'opacity .5s'; alertBox.style.opacity = '0';
            setTimeout(() => alertBox.remove(), 500); }, 5000);
    }
</script>
</body>
</html>
