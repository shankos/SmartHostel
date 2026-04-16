<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaints — Smart Hostel Admin</title>
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
        <a href="complaints" class="active">Complaints</a>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <%
        String error   = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");

        java.util.ArrayList<com.hostel.model.Complaint> complaints =
            (java.util.ArrayList<com.hostel.model.Complaint>) request.getAttribute("complaints");

        int totalCount    = (complaints != null) ? complaints.size() : 0;
        int pendingCount  = 0;
        int resolvedCount = 0;
        if (complaints != null) {
            for (com.hostel.model.Complaint c : complaints) {
                if ("Pending".equals(c.getStatus())) pendingCount++;
                else resolvedCount++;
            }
        }
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

    <h1 class="page-title">Complaints</h1>
    <p class="page-subtitle">Review and resolve student complaints.</p>

    <!-- Summary Stats -->
    <div class="dashboard-grid" style="margin-bottom:24px;">
        <div class="stat-card">
            <div class="stat-icon navy">📋</div>
            <div class="stat-info">
                <p>Total</p>
                <h3><%= totalCount %></h3>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon amber">⏳</div>
            <div class="stat-info">
                <p>Pending</p>
                <h3><%= pendingCount %></h3>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green">✔</div>
            <div class="stat-info">
                <p>Resolved</p>
                <h3><%= resolvedCount %></h3>
            </div>
        </div>
    </div>

    <!-- Complaints Table -->
    <div class="page-card">
        <div class="page-card-header">
            <h2>All Complaints</h2>
            <!-- Filter Buttons -->
            <div style="display:flex; gap:6px;">
                <button class="filter-btn active" onclick="filterComplaints('all', this)"
                        style="font-size:0.8rem; padding:5px 13px; border-radius:6px; border:1.5px solid var(--border);
                               background:var(--navy); color:white; cursor:pointer; font-weight:600; transition:all 0.2s;">
                    All
                </button>
                <button class="filter-btn" onclick="filterComplaints('pending', this)"
                        style="font-size:0.8rem; padding:5px 13px; border-radius:6px; border:1.5px solid var(--border);
                               background:transparent; color:var(--text-soft); cursor:pointer; font-weight:600; transition:all 0.2s;">
                    Pending
                </button>
                <button class="filter-btn" onclick="filterComplaints('resolved', this)"
                        style="font-size:0.8rem; padding:5px 13px; border-radius:6px; border:1.5px solid var(--border);
                               background:transparent; color:var(--text-soft); cursor:pointer; font-weight:600; transition:all 0.2s;">
                    Resolved
                </button>
            </div>
        </div>

        <% if (complaints == null || complaints.isEmpty()) { %>
        <div class="empty-state">
            <span class="empty-icon">🎉</span>
            <p class="empty-title">No complaints found</p>
            <p>Everything is running smoothly!</p>
        </div>
        <% } else { %>
        <div class="table-wrapper">
            <table id="complaintsTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Student</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (int i = 0; i < complaints.size(); i++) {
                            com.hostel.model.Complaint c = complaints.get(i);
                            String statusClass = "Pending".equals(c.getStatus()) ? "pending" : "resolved";
                    %>
                    <tr class="complaint-row <%= statusClass %>"
                        style="animation-delay:<%= i * 0.04 %>s">
                        <td style="color:var(--text-muted); font-size:0.85rem;"><%= i + 1 %></td>
                        <td>
                            <div style="display:flex; align-items:center; gap:9px;">
                                <div style="width:30px; height:30px; border-radius:50%; background:var(--navy-mid);
                                            display:flex; align-items:center; justify-content:center;
                                            font-size:12px; color:white; flex-shrink:0;">
                                    <%= c.getUserEmail().substring(0,1).toUpperCase() %>
                                </div>
                                <span style="font-size:0.88rem; color:var(--text-soft);">
                                    <%= c.getUserEmail() %>
                                </span>
                            </div>
                        </td>
                        <td style="max-width:320px; color:var(--text-soft); font-size:0.88rem; line-height:1.5;">
                            <%= c.getDescription() %>
                        </td>
                        <td>
                            <% if ("Pending".equals(c.getStatus())) { %>
                            <span class="badge badge-pending">⏳ Pending</span>
                            <% } else { %>
                            <span class="badge badge-resolved">✔ Resolved</span>
                            <% } %>
                        </td>
                        <td>
                            <% if ("Pending".equals(c.getStatus())) { %>
                            <a href="complaints?resolve=<%= i %>" class="action-link resolve"
                               onclick="return confirmResolve(event, this.href)">
                               ✔ Mark Resolved
                            </a>
                            <% } else { %>
                            <span style="font-size:0.82rem; color:var(--text-muted);">Closed</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <div id="noFilterResults" style="display:none; padding:24px; text-align:center;
             color:var(--text-soft); font-size:0.9rem;">
            No complaints match the selected filter.
        </div>
        <% } %>
    </div>

    <a href="home" class="back-link">← Back to Dashboard</a>

</div>

<footer class="footer">
    &copy; 2025 Smart Hostel Management System. All rights reserved.
</footer>

<script>
    /* ── Filter Complaints ───────────────────────── */
    function filterComplaints(type, btn) {
        // Update active button style
        document.querySelectorAll('.filter-btn').forEach(function(b) {
            b.style.background = 'transparent';
            b.style.color = 'var(--text-soft)';
            b.style.borderColor = 'var(--border)';
        });
        btn.style.background = 'var(--navy)';
        btn.style.color = 'white';
        btn.style.borderColor = 'var(--navy)';

        const rows   = document.querySelectorAll('.complaint-row');
        let visible  = 0;
        rows.forEach(function(row) {
            const show = type === 'all' || row.classList.contains(type);
            row.style.display = show ? '' : 'none';
            if (show) visible++;
        });
        var noRes = document.getElementById('noFilterResults');
        if (noRes) noRes.style.display = visible === 0 ? 'block' : 'none';
    }

    /* ── Confirm Resolve ─────────────────────────── */
    function confirmResolve(e, href) {
        e.preventDefault();
        if (confirm('Mark this complaint as resolved?\nThis action cannot be undone.')) {
            window.location.href = href;
        }
        return false;
    }

    /* Auto-dismiss alerts */
    var alertBox = document.getElementById('alertBox');
    if (alertBox) {
        setTimeout(function() {
            alertBox.style.transition = 'opacity 0.5s';
            alertBox.style.opacity = '0';
            setTimeout(function() { alertBox.remove(); }, 500);
        }, 5000);
    }
</script>

</body>
</html>
