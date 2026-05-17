<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Request — Smart Hostel</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .request-card {
            border: 1px solid #e2ddd6; border-radius: 10px;
            padding: 16px 18px; margin-bottom: 10px; background: #fff;
            transition: all .16s; animation: fadeUp .4s ease both;
        }
        .request-card:hover { box-shadow: 0 3px 14px rgba(13,27,42,.09); }
        .request-card.pending  { border-left: 4px solid #e8a020; }
        .request-card.approved { border-left: 4px solid #2e9e6b; }
        .request-card.denied   { border-left: 4px solid #d94f4f; }
        .req-header { display:flex; align-items:center; justify-content:space-between; gap:10px; margin-bottom:10px; }
        .req-room-tag {
            display:inline-flex; align-items:center; gap:5px;
            background:#e8eef5; padding:4px 12px; border-radius:20px;
            font-size:.82rem; font-weight:700; color:#0d1b2a;
        }
        .req-reason { font-size:.87rem; color:#4a5568; line-height:1.6;
                      background:#faf8f5; padding:9px 13px; border-radius:6px; }
        .req-admin-note { margin-top:8px; font-size:.8rem; padding:7px 12px;
                          border-radius:6px; font-style:italic; }
        .req-admin-note.approved { background:#e8f5ee; color:#1a6e46; }
        .req-admin-note.denied   { background:#fdeaea; color:#c0392b; }
        .req-time { font-size:.74rem; color:#8a9ab0; margin-top:6px; }
        .room-option-grid {
            display:grid; grid-template-columns:repeat(auto-fill,minmax(100px,1fr));
            gap:8px; margin-bottom:8px;
        }
        .room-option {
            border:1.5px solid #e2ddd6; border-radius:8px; padding:10px 8px;
            text-align:center; cursor:pointer; font-size:.82rem; font-weight:600;
            color:#1a2535; background:#f9f6f1; transition:all .16s;
        }
        .room-option:hover { border-color:#e8a020; background:#fdf8f0; }
        .room-option.selected { border-color:#0d1b2a; background:#0d1b2a; color:#fff; }
        .pending-notice {
            padding:14px 18px; background:#fff3cc; border:1px solid #ffe58a;
            border-radius:8px; margin-bottom:20px;
            display:flex; align-items:flex-start; gap:10px; font-size:.87rem;
        }
    </style>
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
        <a href="roomRequests" class="active">Room Request</a>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <%
        String error   = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        java.util.ArrayList<com.hostel.model.RoomRequest> myRequests =
            (java.util.ArrayList<com.hostel.model.RoomRequest>) request.getAttribute("myRequests");
        java.util.ArrayList<com.hostel.model.Room> rooms =
            (java.util.ArrayList<com.hostel.model.Room>) request.getAttribute("rooms");
        String userEmail = (String) session.getAttribute("userEmail");

        // Check for pending request
        boolean hasPending = false;
        if (myRequests != null) {
            for (com.hostel.model.RoomRequest rr : myRequests) {
                if (rr.isPending()) { hasPending = true; break; }
            }
        }
        int myReqTotal = (myRequests != null) ? myRequests.size() : 0;
        int approved = 0; int denied = 0; int pending = 0;
        if (myRequests != null) {
            for (com.hostel.model.RoomRequest rr : myRequests) {
                if (rr.isApproved()) approved++;
                else if (rr.isDenied()) denied++;
                else pending++;
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

    <h1 class="page-title">Room Request</h1>
    <p class="page-subtitle">Submit a preferred room request. The admin will review and respond.</p>

    <!-- Stats -->
    <% if (myReqTotal > 0) { %>
    <div class="dashboard-grid" style="margin-bottom:24px; grid-template-columns:repeat(3,1fr);">
        <div class="stat-card">
            <div class="stat-icon amber">⏳</div>
            <div class="stat-info"><p>Pending</p><h3 style="color:#b07800;"><%= pending %></h3></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green">✔</div>
            <div class="stat-info"><p>Approved</p><h3 style="color:#2e9e6b;"><%= approved %></h3></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon red">✕</div>
            <div class="stat-info"><p>Denied</p><h3 style="color:#d94f4f;"><%= denied %></h3></div>
        </div>
    </div>
    <% } %>

    <div style="display:grid; grid-template-columns:1fr 1fr; gap:24px; align-items:start;" id="rrGrid">

        <!-- Request Form -->
        <div>
            <div class="page-card" style="margin-bottom:0;">
                <div class="page-card-header">
                    <h2>🚪 New Room Request</h2>
                </div>

                <% if (hasPending) { %>
                <div class="pending-notice">
                    <span style="font-size:18px;">⏳</span>
                    <div>
                        <strong style="color:#8a5a00;">You have a pending request</strong>
                        <p style="color:#8a5a00; margin-top:2px; font-size:.83rem;">
                            Please wait for the admin to respond before submitting another request.
                        </p>
                    </div>
                </div>
                <% } %>

                <form action="roomRequests" method="post" id="roomReqForm" novalidate
                      <%= hasPending ? "style='opacity:.5; pointer-events:none;'" : "" %>>

                    <div class="form-group">
                        <label>Preferred Room</label>
                        <% if (rooms != null && !rooms.isEmpty()) { %>
                        <div class="room-option-grid" id="roomGrid">
                            <% for (com.hostel.model.Room r : rooms) { %>
                            <div class="room-option" onclick="selectRoom(this, '<%= r.getRoomNumber() %>')">
                                🚪 <%= r.getRoomNumber() %>
                                <div style="font-size:.7rem; font-weight:400; opacity:.7; margin-top:2px;">
                                    <%= r.getCapacity() %> person<%= r.getCapacity() != 1 ? "s" : "" %>
                                </div>
                            </div>
                            <% } %>
                        </div>
                        <input type="hidden" name="preferredRoom" id="preferredRoom">
                        <div class="field-error" id="roomErr">Please select a preferred room.</div>
                        <% } else { %>
                        <div style="padding:14px; background:#f7f3ec; border-radius:8px; font-size:.87rem; color:#5a6a7e;">
                            No rooms are available yet. Please check back later.
                        </div>
                        <input type="hidden" name="preferredRoom" id="preferredRoom" value="N/A">
                        <% } %>
                    </div>

                    <div class="form-group">
                        <label for="reason">Reason for Request</label>
                        <textarea name="reason" id="reason"
                                  placeholder="Explain why you need this room (e.g. medical reasons, proximity to classes, current room issues…)"
                                  maxlength="400" rows="4"
                                  oninput="updateRRCount(this)"></textarea>
                        <div class="char-counter" id="rrCount">0 / 400 characters</div>
                        <div class="field-error" id="reasonErr">
                            Please provide a reason (at least 10 characters).
                        </div>
                    </div>

                    <input type="submit" id="rrBtn" class="btn btn-primary btn-full"
                           value="Submit Room Request →">
                </form>
            </div>

            <!-- Tips -->
            <div class="page-card" style="margin-top:16px; margin-bottom:0;">
                <div class="page-card-header" style="margin-bottom:12px; padding-bottom:10px;">
                    <h2>💡 Tips</h2>
                </div>
                <ul style="list-style:none; display:flex; flex-direction:column; gap:8px;">
                    <li style="font-size:.84rem; color:#5a6a7e; display:flex; gap:7px;">
                        <span>→</span> Be specific — mention your current room if relevant
                    </li>
                    <li style="font-size:.84rem; color:#5a6a7e; display:flex; gap:7px;">
                        <span>→</span> Medical or academic reasons are given priority
                    </li>
                    <li style="font-size:.84rem; color:#5a6a7e; display:flex; gap:7px;">
                        <span>→</span> Only one pending request is allowed at a time
                    </li>
                    <li style="font-size:.84rem; color:#5a6a7e; display:flex; gap:7px;">
                        <span>→</span> Admin typically responds within 1–2 business days
                    </li>
                </ul>
            </div>
        </div>

        <!-- My Request History -->
        <div>
            <div class="page-card" style="margin-bottom:0;">
                <div class="page-card-header">
                    <h2>My Request History</h2>
                    <% if (myReqTotal > 0) { %>
                    <span style="font-size:.82rem; color:#5a6a7e; background:#f5f0e8;
                                 padding:3px 12px; border-radius:20px; font-weight:600;">
                        <%= myReqTotal %> Request<%= myReqTotal != 1 ? "s" : "" %>
                    </span>
                    <% } %>
                </div>

                <% if (myRequests == null || myRequests.isEmpty()) { %>
                <div style="text-align:center; padding:36px 20px;">
                    <div style="font-size:36px; margin-bottom:10px;">📬</div>
                    <p style="font-weight:700; color:#0d1b2a; margin-bottom:4px;">No requests yet</p>
                    <p style="font-size:.85rem; color:#5a6a7e;">
                        Use the form to submit your first room request.
                    </p>
                </div>
                <% } else { %>
                <div>
                    <% for (int i = myRequests.size() - 1; i >= 0; i--) {
                        com.hostel.model.RoomRequest rr = myRequests.get(i);
                        String cls = rr.isPending() ? "pending" : rr.isApproved() ? "approved" : "denied";
                    %>
                    <div class="request-card <%= cls %>"
                         style="animation-delay:<%= (myRequests.size() - 1 - i) * 0.06 %>s">
                        <div class="req-header">
                            <span class="req-room-tag">🚪 Room <%= rr.getPreferredRoom() %></span>
                            <% if (rr.isPending()) { %>
                                <span class="badge badge-pending">⏳ Pending</span>
                            <% } else if (rr.isApproved()) { %>
                                <span class="badge badge-approved">✔ Approved</span>
                            <% } else { %>
                                <span class="badge badge-denied">✕ Denied</span>
                            <% } %>
                        </div>
                        <div class="req-reason"><%= rr.getReason() %></div>
                        <% if (rr.getAdminNote() != null && !rr.getAdminNote().isEmpty()) { %>
                        <div class="req-admin-note <%= cls %>">
                            📝 Admin: <%= rr.getAdminNote() %>
                        </div>
                        <% } %>
                        <div class="req-time">🕐 Submitted: <%= rr.getSubmittedAt() %></div>
                    </div>
                    <% } %>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <div style="margin-top:12px;">
        <a href="studentHome" class="back-link">← Back to Dashboard</a>
    </div>
</div>

<footer class="footer">&copy; 2025 Smart Hostel Management System. All rights reserved.</footer>

<script>
    function selectRoom(el, roomNum) {
        document.querySelectorAll('.room-option').forEach(r => r.classList.remove('selected'));
        el.classList.add('selected');
        document.getElementById('preferredRoom').value = roomNum;
        el.classList.remove('input-error');
        document.getElementById('roomErr').classList.remove('show');
    }

    function updateRRCount(t) {
        const len = t.value.length;
        const c = document.getElementById('rrCount');
        c.textContent = len + ' / 400 characters';
        c.className = 'char-counter' + (len > 340 ? ' warn' : '') + (len >= 400 ? ' over' : '');
        t.classList.remove('input-error');
        document.getElementById('reasonErr').classList.remove('show');
    }

    document.getElementById('roomReqForm') && document.getElementById('roomReqForm').addEventListener('submit', function(e) {
        let ok = true;
        const pr = document.getElementById('preferredRoom');
        const re = document.getElementById('reason');

        if (!pr.value || pr.value === 'N/A') {
            ok = false;
            document.getElementById('roomErr').classList.add('show');
        }
        if (!re.value.trim() || re.value.trim().length < 10) {
            re.classList.add('input-error');
            document.getElementById('reasonErr').classList.add('show');
            ok = false;
        }
        if (!ok) { e.preventDefault(); return; }
        const btn = document.getElementById('rrBtn');
        btn.value = 'Submitting…'; btn.classList.add('loading');
    });

    function checkGrid() {
        const g = document.getElementById('rrGrid');
        if (g) g.style.gridTemplateColumns = window.innerWidth < 768 ? '1fr' : '1fr 1fr';
    }
    checkGrid();
    window.addEventListener('resize', checkGrid);

    var alertBox = document.getElementById('alertBox');
    if (alertBox) {
        setTimeout(() => { alertBox.style.transition = 'opacity .5s'; alertBox.style.opacity = '0';
            setTimeout(() => alertBox.remove(), 500); }, 6000);
    }
</script>
</body>
</html>
