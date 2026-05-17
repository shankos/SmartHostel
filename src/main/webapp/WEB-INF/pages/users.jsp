<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registered Users — Smart Hostel Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .user-avatar {
            width: 38px; height: 38px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 15px; font-weight: 700; color: white; flex-shrink: 0;
        }
        .search-bar-wrap { display: flex; align-items: center; gap: 12px; margin-bottom: 18px; flex-wrap: wrap; }
        .search-bar-wrap input { max-width: 300px; font-size: .88rem; }
        .user-count-pill {
            font-size: .82rem; color: var(--text-soft, #5a6a7e);
            background: var(--cream, #f5f0e8);
            padding: 4px 14px; border-radius: 20px; font-weight: 600;
        }
        .delete-btn {
            font-size: .78rem; font-weight: 600; padding: 4px 11px;
            border-radius: 5px; background: var(--red-pale, #fdeaea);
            color: var(--red, #d94f4f); border: none; cursor: pointer;
            text-decoration: none; transition: all .14s; display: inline-block;
        }
        .delete-btn:hover { background: var(--red, #d94f4f); color: white; }
        .db-badge {
            display: inline-flex; align-items: center; gap: 5px;
            font-size: .72rem; font-weight: 700; padding: 2px 9px;
            border-radius: 20px; background: #e8f0fa; color: #3a6ea8;
            letter-spacing: .03em;
        }
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
        <a href="complaints">Complaints</a>
        <a href="payments">Payments</a>
        <a href="users" class="active">Users</a>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <%
        String error   = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        java.util.ArrayList<com.hostel.model.User> users =
            (java.util.ArrayList<com.hostel.model.User>) request.getAttribute("users");
        int userCount = (users != null) ? users.size() : 0;
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

    <h1 class="page-title">Registered Users</h1>
    <p class="page-subtitle">All student accounts registered via the portal — sourced live from the database.</p>

    <!-- Summary Cards -->
    <div class="dashboard-grid" style="margin-bottom:24px;">
        <div class="stat-card">
            <div class="stat-icon blue">👤</div>
            <div class="stat-info">
                <p>Total Users</p>
                <h3 class="count-up" data-target="<%= userCount %>">0</h3>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green">✔</div>
            <div class="stat-info">
                <p>Active Accounts</p>
                <h3 class="count-up" data-target="<%= userCount %>">0</h3>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon navy">🗄</div>
            <div class="stat-info">
                <p>Data Source</p>
                <h3 style="font-size:1rem; font-weight:600; color:var(--navy);">MySQL DB</h3>
            </div>
        </div>
    </div>

    <div class="page-card">
        <div class="page-card-header">
            <h2>All Registered Accounts</h2>
            <span class="user-count-pill"><%= userCount %> User<%= userCount != 1 ? "s" : "" %></span>
        </div>

        <% if (users != null && !users.isEmpty()) { %>
        <div class="search-bar-wrap">
            <input type="text" id="userSearch" placeholder="🔍 Search by name or email…"
                   oninput="filterUsers()" style="padding:9px 14px;">
            <span id="visibleCount" style="font-size:.82rem; color:var(--text-soft, #5a6a7e);">
                Showing all <%= userCount %> users
            </span>
        </div>
        <% } %>

        <% if (users == null || users.isEmpty()) { %>
        <div class="empty-state">
            <span class="empty-icon">👤</span>
            <p class="empty-title">No registered users found</p>
            <p>Users appear here once they register through the student portal.</p>
        </div>
        <% } else { %>
        <div class="table-wrapper">
            <table id="usersTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>User</th>
                        <th>Email Address</th>
                        <th>Role</th>
                        <th>Password (hashed)</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String[] avatarColors = {"#0d1b2a","#2e9e6b","#e8a020","#3a6ea8","#d94f4f","#7b4ea8"};
                        for (int i = 0; i < users.size(); i++) {
                            com.hostel.model.User u = users.get(i);
                            String avatarColor = avatarColors[i % avatarColors.length];
                            String initials = u.getName() != null && u.getName().length() > 0
                                ? u.getName().substring(0,1).toUpperCase() : "?";
                            String pwDisplay = u.getPassword() != null && u.getPassword().length() > 3
                                ? u.getPassword().substring(0, Math.min(u.getPassword().length(), 4)) + "••••••"
                                : "••••••••";
                    %>
                    <tr style="animation-delay:<%= i * 0.04 %>s">
                        <td style="color:var(--text-muted, #8a9ab0); font-size:.85rem;"><%= i + 1 %></td>
                        <td>
                            <div style="display:flex; align-items:center; gap:10px;">
                                <div class="user-avatar" style="background:<%= avatarColor %>;">
                                    <%= initials %>
                                </div>
                                <div>
                                    <strong style="color:var(--navy, #0d1b2a); font-size:.9rem;">
                                        <%= u.getName() != null ? u.getName() : "—" %>
                                    </strong>
                                    <div style="font-size:.75rem; color:var(--text-soft, #5a6a7e); margin-top:1px;">
                                        Registered Student
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td style="color:var(--text-soft, #5a6a7e); font-size:.88rem;">
                            <%= u.getEmail() != null ? u.getEmail() : "—" %>
                        </td>
                        <td>
                            <span class="role-tag student">Student</span>
                        </td>
                        <td>
                            <span style="font-family:monospace; font-size:.82rem; color:var(--text-muted, #8a9ab0);
                                         background:var(--cream, #f5f0e8); padding:2px 8px; border-radius:4px;">
                                <%= pwDisplay %>
                            </span>
                        </td>
                        <td>
                            <a href="#" class="delete-btn"
                               onclick="confirmUserDelete(event, 'users?delete=<%= java.net.URLEncoder.encode(u.getEmail() != null ? u.getEmail() : "", "UTF-8") %>', '<%= u.getName() != null ? u.getName().replace("'","") : "" %>')">
                               🗑 Delete
                            </a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <div id="noUserResults" style="display:none; padding:28px; text-align:center;
             color:var(--text-soft, #5a6a7e); font-size:.9rem;">
            No users match your search.
        </div>
        <% } %>
    </div>

    <a href="home" class="back-link">← Back to Dashboard</a>
</div>

<!-- Delete Confirm Modal -->
<div id="userConfirmModal" style="display:none; position:fixed; inset:0;
     background:rgba(11,25,41,.55); z-index:1000; align-items:center; justify-content:center; padding:20px;">
    <div style="background:#fff; border-radius:14px; padding:32px 36px; max-width:380px; width:100%;
                box-shadow:0 24px 72px rgba(13,27,42,.22); text-align:center;">
        <div style="font-size:38px; margin-bottom:14px;">🗑️</div>
        <h3 style="font-family:'Cormorant Garamond',serif; font-size:1.3rem; color:#0d1b2a; margin-bottom:8px;">
            Delete User Account?
        </h3>
        <p id="userConfirmMsg" style="color:#5a6a7e; font-size:.9rem; margin-bottom:24px;"></p>
        <div style="display:flex; gap:12px; justify-content:center;">
            <button onclick="closeUserModal()" class="btn btn-outline">Cancel</button>
            <a id="userConfirmAction" href="#" class="btn btn-danger">Yes, Delete</a>
        </div>
    </div>
</div>

<footer class="footer">
    &copy; 2025 Smart Hostel Management System. All rights reserved.
</footer>

<script>
    function filterUsers() {
        const q = document.getElementById('userSearch').value.toLowerCase();
        const rows = document.querySelectorAll('#usersTable tbody tr');
        let vis = 0;
        rows.forEach(r => {
            const show = r.textContent.toLowerCase().includes(q);
            r.style.display = show ? '' : 'none';
            if (show) vis++;
        });
        document.getElementById('noUserResults').style.display = vis === 0 ? 'block' : 'none';
        const vc = document.getElementById('visibleCount');
        if (vc) vc.textContent = 'Showing ' + vis + ' of <%= userCount %> users';
    }

    function confirmUserDelete(e, url, name) {
        e.preventDefault();
        document.getElementById('userConfirmMsg').textContent =
            'Are you sure you want to permanently delete the account for "' + name + '"? This cannot be undone.';
        document.getElementById('userConfirmAction').href = url;
        document.getElementById('userConfirmModal').style.display = 'flex';
    }
    function closeUserModal() {
        document.getElementById('userConfirmModal').style.display = 'none';
    }
    document.getElementById('userConfirmModal').addEventListener('click', function(e) {
        if (e.target === this) closeUserModal();
    });

    document.querySelectorAll('.count-up').forEach(function(el) {
        const target = parseInt(el.getAttribute('data-target'), 10) || 0;
        if (target === 0) { el.textContent = '0'; return; }
        const step = Math.ceil(900 / target);
        let current = 0;
        const timer = setInterval(() => {
            current++;
            el.textContent = current;
            if (current >= target) { clearInterval(timer); el.textContent = target; }
        }, step);
    });

    var alertBox = document.getElementById('alertBox');
    if (alertBox) {
        setTimeout(() => {
            alertBox.style.transition = 'opacity .5s';
            alertBox.style.opacity = '0';
            setTimeout(() => alertBox.remove(), 500);
        }, 5000);
    }
</script>
</body>
</html>
