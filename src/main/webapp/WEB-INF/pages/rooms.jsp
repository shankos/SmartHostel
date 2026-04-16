<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Rooms — Smart Hostel</title>
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
        <a href="rooms" class="active">Rooms</a>
        <a href="complaints">Complaints</a>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <%
        String error   = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        com.hostel.model.Room editRoom    = (com.hostel.model.Room) request.getAttribute("editRoom");
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

    <h1 class="page-title">Room Management</h1>
    <p class="page-subtitle">Configure and manage hostel room inventory.</p>

    <!-- Add / Edit Form -->
    <div class="page-card">
        <div class="page-card-header">
            <h2><%= (editRoom != null) ? "✏️ Edit Room" : "➕ Add New Room" %></h2>
            <% if (editRoom != null) { %>
            <a href="rooms" class="btn btn-outline" style="font-size:0.83rem; padding:6px 14px;">
                ✕ Cancel Edit
            </a>
            <% } %>
        </div>

        <form action="rooms" method="post" id="roomForm" novalidate>
            <input type="hidden" name="editIndex" value="<%= (editIndex != null) ? editIndex : "" %>">

            <div class="form-row form-row-2">
                <div class="form-group" style="margin-bottom:0">
                    <label for="roomNumber">Room Number</label>
                    <input type="text" id="roomNumber" name="roomNumber"
                           placeholder="e.g. 101A"
                           value="<%= (editRoom != null) ? editRoom.getRoomNumber() : "" %>">
                    <div class="field-error" id="roomNumberError">Room number is required.</div>
                </div>
                <div class="form-group" style="margin-bottom:0">
                    <label for="capacity">Capacity (persons)</label>
                    <input type="number" id="capacity" name="capacity"
                           placeholder="e.g. 2" min="1" max="20"
                           value="<%= (editRoom != null) ? editRoom.getCapacity() : "" %>">
                    <div class="field-error" id="capacityError">Please enter a valid capacity (1–20).</div>
                </div>
            </div>

            <div class="form-actions">
                <input type="submit" id="roomBtn"
                       value="<%= (editRoom != null) ? "Update Room" : "Add Room" %>">
                <% if (editRoom != null) { %>
                <a href="rooms" class="btn btn-outline">Cancel</a>
                <% } %>
            </div>
        </form>
    </div>

    <!-- Room List Table -->
    <div class="page-card">
        <div class="page-card-header">
            <h2>All Rooms</h2>
            <%
                java.util.ArrayList<com.hostel.model.Room> rooms =
                    (java.util.ArrayList<com.hostel.model.Room>) request.getAttribute("rooms");
                int roomCount = (rooms != null) ? rooms.size() : 0;
            %>
            <span style="font-size:0.82rem; color:var(--text-soft); background:var(--cream);
                         padding:4px 12px; border-radius:20px; font-weight:600;">
                <%= roomCount %> Room<%= roomCount != 1 ? "s" : "" %>
            </span>
        </div>

        <% if (rooms == null || rooms.isEmpty()) { %>
        <div class="empty-state">
            <span class="empty-icon">🚪</span>
            <p class="empty-title">No rooms added yet</p>
            <p>Use the form above to add your first room.</p>
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
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (int i = 0; i < rooms.size(); i++) {
                            com.hostel.model.Room r = rooms.get(i);
                    %>
                    <tr style="animation-delay:<%= i * 0.04 %>s">
                        <td style="color:var(--text-muted); font-size:0.85rem;"><%= i + 1 %></td>
                        <td><strong style="color:var(--navy);">Room <%= r.getRoomNumber() %></strong></td>
                        <td>
                            <span style="display:inline-flex; align-items:center; gap:5px;">
                                👤 <%= r.getCapacity() %> person<%= r.getCapacity() != 1 ? "s" : "" %>
                            </span>
                        </td>
                        <td><span class="badge badge-resolved">✔ Available</span></td>
                        <td>
                            <div class="table-actions">
                                <a href="rooms?edit=<%= i %>" class="action-link edit">✏️ Edit</a>
                                <a href="#" class="action-link delete"
                                   onclick="confirmDelete(event, 'rooms?delete=<%= i %>', 'Room <%= r.getRoomNumber() %>')">
                                   🗑 Delete
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
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
                   color:var(--navy); margin-bottom:8px;">Delete Room?</h3>
        <p id="confirmMessage" style="color:var(--text-soft); font-size:0.9rem; margin-bottom:24px;"></p>
        <div style="display:flex; gap:12px; justify-content:center;">
            <button onclick="closeConfirm()" class="btn btn-outline">Cancel</button>
            <a id="confirmAction" href="#" class="btn btn-danger">Yes, Delete</a>
        </div>
    </div>
</div>

<footer class="footer">
    &copy; 2025 Smart Hostel Management System. All rights reserved.
</footer>

<script>
    /* ── Form Validation ─────────────────────────── */
    document.getElementById('roomForm').addEventListener('submit', function(e) {
        let valid = true;
        const roomNumber = document.getElementById('roomNumber');
        const capacity   = document.getElementById('capacity');
        const rnErr      = document.getElementById('roomNumberError');
        const capErr     = document.getElementById('capacityError');

        [roomNumber, capacity].forEach(el => el.classList.remove('input-error'));
        [rnErr, capErr].forEach(el => el.classList.remove('show'));

        if (!roomNumber.value.trim()) {
            roomNumber.classList.add('input-error');
            rnErr.classList.add('show');
            valid = false;
        }

        const cap = parseInt(capacity.value);
        if (!capacity.value || isNaN(cap) || cap < 1 || cap > 20) {
            capacity.classList.add('input-error');
            capErr.textContent = 'Capacity must be between 1 and 20.';
            capErr.classList.add('show');
            valid = false;
        }

        if (!valid) { e.preventDefault(); return; }

        const btn = document.getElementById('roomBtn');
        btn.value = btn.value === 'Add Room' ? 'Adding…' : 'Updating…';
        btn.classList.add('loading');
    });

    ['roomNumber', 'capacity'].forEach(function(id) {
        document.getElementById(id).addEventListener('input', function() {
            this.classList.remove('input-error');
            document.getElementById(id + 'Error').classList.remove('show');
        });
    });

    /* ── Custom Delete Confirm Modal ─────────────── */
    var pendingDeleteUrl = '';

    function confirmDelete(e, url, name) {
        e.preventDefault();
        pendingDeleteUrl = url;
        document.getElementById('confirmMessage').textContent =
            'Are you sure you want to delete "' + name + '"? This cannot be undone.';
        var modal = document.getElementById('confirmModal');
        modal.style.display = 'flex';
        document.getElementById('confirmAction').href = url;
    }

    function closeConfirm() {
        document.getElementById('confirmModal').style.display = 'none';
    }

    // Close modal on backdrop click
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

    /* Scroll to form if editing */
    <% if (editRoom != null) { %>
    document.getElementById('roomForm').scrollIntoView({ behavior: 'smooth', block: 'start' });
    document.getElementById('roomNumber').focus();
    <% } %>
</script>

</body>
</html>
