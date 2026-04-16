<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Students — Smart Hostel</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="page-wrapper">

<nav class="topbar">
    <a href="home" class="topbar-brand">
        <div class="brand-icon">🏨</div>
        <span>Smart Hostel</span>
    </a>
    <div class="topbar-nav">
        <a href="students" class="active">Students</a>
        <a href="rooms">Rooms</a>
        <a href="complaints">Complaints</a>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <%
        String error   = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        com.hostel.model.Student editStudent = (com.hostel.model.Student) request.getAttribute("editStudent");
        Integer editIndex = (Integer) request.getAttribute("editIndex");
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

    <h1 class="page-title">Student Management</h1>
    <p class="page-subtitle">Add, edit and remove hostel student records.</p>

    <!-- Add / Edit Form -->
    <div class="page-card">
        <div class="page-card-header">
            <h2><%= (editStudent != null) ? "✏️ Edit Student" : "➕ Add New Student" %></h2>
            <% if (editStudent != null) { %>
            <a href="students" class="btn btn-outline" style="font-size:0.83rem; padding:6px 14px;">
                ✕ Cancel Edit
            </a>
            <% } %>
        </div>

        <form action="students" method="post" id="studentForm" novalidate>
            <input type="hidden" name="editIndex" value="<%= (editIndex != null) ? editIndex : "" %>">

            <div class="form-row form-row-3">
                <div class="form-group" style="margin-bottom:0">
                    <label for="sName">Full Name</label>
                    <input type="text" id="sName" name="name"
                           placeholder="e.g. John Doe"
                           value="<%= (editStudent != null) ? editStudent.getName() : "" %>">
                    <div class="field-error" id="sNameError">Full name is required.</div>
                </div>
                <div class="form-group" style="margin-bottom:0">
                    <label for="sEmail">Email Address</label>
                    <input type="text" id="sEmail" name="email"
                           placeholder="student@email.com"
                           value="<%= (editStudent != null) ? editStudent.getEmail() : "" %>">
                    <div class="field-error" id="sEmailError">Please enter a valid email.</div>
                </div>
                <div class="form-group" style="margin-bottom:0">
                    <label for="sPhone">Phone Number</label>
                    <input type="text" id="sPhone" name="phone"
                           placeholder="e.g. 9800000000"
                           value="<%= (editStudent != null) ? editStudent.getPhone() : "" %>">
                    <div class="field-error" id="sPhoneError">Please enter a valid 10-digit phone number.</div>
                </div>
            </div>

            <div class="form-actions">
                <input type="submit" id="studentBtn"
                       value="<%= (editStudent != null) ? "Update Student" : "Add Student" %>">
                <% if (editStudent != null) { %>
                <a href="students" class="btn btn-outline">Cancel</a>
                <% } %>
            </div>
        </form>
    </div>

    <!-- Student List Table -->
    <div class="page-card">
        <div class="page-card-header">
            <h2>All Students</h2>
            <%
                java.util.ArrayList<com.hostel.model.Student> students =
                    (java.util.ArrayList<com.hostel.model.Student>) request.getAttribute("students");
                int studentCount = (students != null) ? students.size() : 0;
            %>
            <span style="font-size:0.82rem; color:var(--text-soft); background:var(--cream);
                         padding:4px 12px; border-radius:20px; font-weight:600;">
                <%= studentCount %> Student<%= studentCount != 1 ? "s" : "" %>
            </span>
        </div>

        <!-- Search / Filter -->
        <% if (students != null && !students.isEmpty()) { %>
        <div style="margin-bottom:16px;">
            <input type="text" id="searchInput" placeholder="🔍 Search by name or email…"
                   style="max-width:320px; padding:9px 14px; font-size:0.88rem;"
                   oninput="filterTable()">
        </div>
        <% } %>

        <% if (students == null || students.isEmpty()) { %>
        <div class="empty-state">
            <span class="empty-icon">👨‍🎓</span>
            <p class="empty-title">No students added yet</p>
            <p>Use the form above to add your first student.</p>
        </div>
        <% } else { %>
        <div class="table-wrapper">
            <table id="studentTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (int i = 0; i < students.size(); i++) {
                            com.hostel.model.Student s = students.get(i);
                    %>
                    <tr style="animation-delay:<%= i * 0.04 %>s">
                        <td style="color:var(--text-muted); font-size:0.85rem;"><%= i + 1 %></td>
                        <td>
                            <div style="display:flex; align-items:center; gap:10px;">
                                <div style="width:34px; height:34px; border-radius:50%; background:var(--navy);
                                            display:flex; align-items:center; justify-content:center;
                                            font-size:14px; flex-shrink:0; color:white;">
                                    <%= s.getName().substring(0,1).toUpperCase() %>
                                </div>
                                <strong><%= s.getName() %></strong>
                            </div>
                        </td>
                        <td style="color:var(--text-soft);"><%= s.getEmail() %></td>
                        <td><%= s.getPhone() != null && !s.getPhone().isEmpty() ? s.getPhone() : "—" %></td>
                        <td>
                            <div class="table-actions">
                                <a href="students?edit=<%= i %>" class="action-link edit">✏️ Edit</a>
                                <a href="#" class="action-link delete"
                                   onclick="confirmDelete(event, 'students?delete=<%= i %>', '<%= s.getName() %>')">
                                   🗑 Delete
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <div id="noResults" style="display:none; padding:24px; text-align:center;
             color:var(--text-soft); font-size:0.9rem;">
            No students match your search.
        </div>
        <% } %>
    </div>

    <a href="home" class="back-link">← Back to Dashboard</a>

</div>

<!-- Custom Confirm Modal -->
<div id="confirmModal" style="display:none; position:fixed; inset:0; background:rgba(11,25,41,0.55);
     z-index:1000; align-items:center; justify-content:center; padding:20px;">
    <div style="background:var(--white); border-radius:var(--radius); padding:32px 36px;
                max-width:380px; width:100%; box-shadow:var(--shadow-xl); text-align:center;
                animation:fadeUp 0.25s ease;">
        <div style="font-size:36px; margin-bottom:14px;">🗑️</div>
        <h3 style="font-family:'Cormorant Garamond',serif; font-size:1.3rem;
                   color:var(--navy); margin-bottom:8px;">Remove Student?</h3>
        <p id="confirmMessage" style="color:var(--text-soft); font-size:0.9rem; margin-bottom:24px;"></p>
        <div style="display:flex; gap:12px; justify-content:center;">
            <button onclick="closeConfirm()" class="btn btn-outline">Cancel</button>
            <a id="confirmAction" href="#" class="btn btn-danger">Yes, Remove</a>
        </div>
    </div>
</div>

<footer class="footer">
    &copy; 2025 Smart Hostel Management System. All rights reserved.
</footer>

<script>
    /* ── Form Validation ─────────────────────────── */
    document.getElementById('studentForm').addEventListener('submit', function(e) {
        let valid = true;
        const name  = document.getElementById('sName');
        const email = document.getElementById('sEmail');
        const phone = document.getElementById('sPhone');
        const nameErr  = document.getElementById('sNameError');
        const emailErr = document.getElementById('sEmailError');
        const phoneErr = document.getElementById('sPhoneError');

        [name, email, phone].forEach(el => el.classList.remove('input-error'));
        [nameErr, emailErr, phoneErr].forEach(el => el.classList.remove('show'));

        if (!name.value.trim() || name.value.trim().length < 2) {
            name.classList.add('input-error');
            nameErr.textContent = 'Please enter a valid full name.';
            nameErr.classList.add('show');
            valid = false;
        }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!email.value.trim() || !emailRegex.test(email.value.trim())) {
            email.classList.add('input-error');
            emailErr.textContent = 'Please enter a valid email address.';
            emailErr.classList.add('show');
            valid = false;
        }

        const phoneRegex = /^[0-9]{7,15}$/;
        if (!phone.value.trim() || !phoneRegex.test(phone.value.trim())) {
            phone.classList.add('input-error');
            phoneErr.textContent = 'Phone must be 7–15 digits.';
            phoneErr.classList.add('show');
            valid = false;
        }

        if (!valid) { e.preventDefault(); return; }

        const btn = document.getElementById('studentBtn');
        btn.value = btn.value === 'Add Student' ? 'Adding…' : 'Updating…';
        btn.classList.add('loading');
    });

    ['sName', 'sEmail', 'sPhone'].forEach(function(id) {
        document.getElementById(id).addEventListener('input', function() {
            this.classList.remove('input-error');
            var errId = id + 'Error';
            if (id === 'sName') errId = 'sNameError';
            else if (id === 'sEmail') errId = 'sEmailError';
            else if (id === 'sPhone') errId = 'sPhoneError';
            var errEl = document.getElementById(errId);
            if (errEl) errEl.classList.remove('show');
        });
    });

    /* ── Search / Filter Table ───────────────────── */
    function filterTable() {
        const query  = document.getElementById('searchInput').value.toLowerCase();
        const rows   = document.querySelectorAll('#studentTable tbody tr');
        let visible  = 0;
        rows.forEach(function(row) {
            const text = row.textContent.toLowerCase();
            const show = text.includes(query);
            row.style.display = show ? '' : 'none';
            if (show) visible++;
        });
        document.getElementById('noResults').style.display = visible === 0 ? 'block' : 'none';
    }

    /* ── Custom Delete Confirm Modal ─────────────── */
    function confirmDelete(e, url, name) {
        e.preventDefault();
        document.getElementById('confirmMessage').textContent =
            'Are you sure you want to remove "' + name + '"? This cannot be undone.';
        document.getElementById('confirmAction').href = url;
        document.getElementById('confirmModal').style.display = 'flex';
    }

    function closeConfirm() {
        document.getElementById('confirmModal').style.display = 'none';
    }

    document.getElementById('confirmModal').addEventListener('click', function(e) {
        if (e.target === this) closeConfirm();
    });

    /* Auto-dismiss alerts */
    var alertBox = document.getElementById('alertBox');
    if (alertBox) {
        setTimeout(function() {
            alertBox.style.transition = 'opacity 0.5s';
            alertBox.style.opacity = '0';
            setTimeout(function() { alertBox.remove(); }, 500);
        }, 5000);
    }

    /* Scroll to form + focus if editing */
    <% if (editStudent != null) { %>
    document.getElementById('studentForm').scrollIntoView({ behavior: 'smooth', block: 'start' });
    document.getElementById('sName').focus();
    <% } %>
</script>

</body>
</html>
