<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Complaints — Smart Hostel</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .history-item {
            border: 1px solid #e2ddd6; border-radius: 10px;
            padding: 16px 18px; margin-bottom: 10px; background: #fff;
            transition: all .16s; animation: fadeUp .4s ease both;
        }
        .history-item:hover { box-shadow: 0 3px 14px rgba(13,27,42,.09); }
        .history-item.pending  { border-left: 4px solid #e8a020; }
        .history-item.resolved { border-left: 4px solid #2e9e6b; opacity: .82; }
        .hist-header { display: flex; align-items: flex-start; justify-content: space-between; gap: 10px; margin-bottom: 8px; }
        .hist-cat    { font-size: .75rem; font-weight: 700; text-transform: uppercase; letter-spacing: .07em;
                       color: #8a9ab0; margin-bottom: 3px; }
        .hist-desc   { font-size: .87rem; color: #4a5568; line-height: 1.6;
                       background: #faf8f5; padding: 9px 13px; border-radius: 6px; word-break: break-word; }
        .hist-time   { font-size: .74rem; color: #8a9ab0; margin-top: 6px; }
        .empty-history { text-align:center; padding:32px 20px; }
        .steps-list  { display:flex; flex-direction:column; gap:14px; }
        .step-row    { display:flex; align-items:flex-start; gap:12px; }
        .step-num    { width:28px; height:28px; border-radius:50%; background:#e8a020;
                       display:flex; align-items:center; justify-content:center;
                       font-size:12px; font-weight:700; color:#0d1b2a; flex-shrink:0; }
    </style>
</head>
<body class="page-wrapper">

<nav class="topbar">
    <a href="studentHome" class="topbar-brand">
        <div class="brand-icon">🏨</div>
        <span>Smart Hostel</span>
    </a>
    <div class="topbar-nav">
        <a href="complaints" class="active">Complaints</a>
        <a href="payments">My Payments</a>
        <a href="roomRequests">Room Request</a>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <%
        String error   = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        String userEmail = (String) session.getAttribute("userEmail");

        // Filter complaints for this student only
        java.util.ArrayList<com.hostel.model.Complaint> allComplaints =
            com.hostel.controller.ComplaintServlet.getComplaintList();
        java.util.ArrayList<com.hostel.model.Complaint> myComplaints = new java.util.ArrayList<>();
        if (allComplaints != null && userEmail != null) {
            for (com.hostel.model.Complaint c : allComplaints) {
                if (userEmail.equalsIgnoreCase(c.getUserEmail())) {
                    myComplaints.add(c);
                }
            }
        }
        int myTotal    = myComplaints.size();
        int myPending  = 0; int myResolved = 0;
        for (com.hostel.model.Complaint c : myComplaints) {
            if ("Pending".equals(c.getStatus())) myPending++;
            else myResolved++;
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

    <h1 class="page-title">Complaints</h1>
    <p class="page-subtitle">Submit a new complaint and track the status of your previous ones.</p>

    <!-- My Stats -->
    <% if (myTotal > 0) { %>
    <div class="dashboard-grid" style="margin-bottom:24px; grid-template-columns:repeat(3,1fr);">
        <div class="stat-card">
            <div class="stat-icon navy">📋</div>
            <div class="stat-info"><p>Submitted</p><h3><%= myTotal %></h3></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon amber">⏳</div>
            <div class="stat-info"><p>Pending</p><h3><%= myPending %></h3></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green">✔</div>
            <div class="stat-info"><p>Resolved</p><h3><%= myResolved %></h3></div>
        </div>
    </div>
    <% } %>

    <div style="display:grid; grid-template-columns:1fr 1fr; gap:24px; align-items:start;" id="mainGrid">

        <!-- Submit Form -->
        <div>
            <div class="page-card" style="margin-bottom:0;">
                <div class="page-card-header">
                    <h2>📋 New Complaint</h2>
                </div>
                <form action="complaints" method="post" id="complaintForm" novalidate>

                    <div class="form-group">
                        <label for="category">Category</label>
                        <select name="category" id="category">
                            <option value="">— Select a category —</option>
                            <option value="Maintenance">🔧 Maintenance / Repairs</option>
                            <option value="Cleanliness">🧹 Cleanliness</option>
                            <option value="Food">🍽 Food &amp; Mess</option>
                            <option value="Security">🔒 Security</option>
                            <option value="Internet">📡 Internet / Electricity</option>
                            <option value="Other">📌 Other</option>
                        </select>
                        <div class="field-error" id="categoryError">Please select a category.</div>
                    </div>

                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea name="description" id="description"
                                  placeholder="Describe the issue clearly. Include your room number, date/time, and relevant details…"
                                  maxlength="500" rows="5"
                                  oninput="updateCharCount(this)"></textarea>
                        <div class="char-counter" id="charCounter">0 / 500 characters</div>
                        <div class="field-error" id="descriptionError">
                            Please describe your issue (at least 20 characters).
                        </div>
                    </div>

                    <input type="submit" id="submitBtn" class="btn btn-primary btn-full" value="Submit Complaint →">
                </form>
            </div>

            <!-- How it works -->
            <div class="page-card" style="margin-top:16px; margin-bottom:0;">
                <div class="page-card-header" style="margin-bottom:14px; padding-bottom:10px;">
                    <h2>ℹ️ How It Works</h2>
                </div>
                <div class="steps-list">
                    <div class="step-row">
                        <div class="step-num">1</div>
                        <div>
                            <strong style="font-size:.88rem; color:#0d1b2a;">Submit your complaint</strong>
                            <p style="font-size:.82rem; color:#5a6a7e; margin-top:2px;">Select category and describe the issue.</p>
                        </div>
                    </div>
                    <div class="step-row">
                        <div class="step-num">2</div>
                        <div>
                            <strong style="font-size:.88rem; color:#0d1b2a;">Admin reviews it</strong>
                            <p style="font-size:.82rem; color:#5a6a7e; margin-top:2px;">Admin sees it and takes necessary action.</p>
                        </div>
                    </div>
                    <div class="step-row">
                        <div class="step-num">3</div>
                        <div>
                            <strong style="font-size:.88rem; color:#0d1b2a;">Status updates here</strong>
                            <p style="font-size:.82rem; color:#5a6a7e; margin-top:2px;">Track resolution progress in real time below.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- My Complaint History -->
        <div>
            <div class="page-card" style="margin-bottom:0;">
                <div class="page-card-header">
                    <h2>My Complaint History</h2>
                    <% if (myTotal > 0) { %>
                    <div style="display:flex; gap:5px;">
                        <button class="filter-btn active" onclick="filterMyComp('all',this)" style="font-size:.78rem; padding:4px 10px;">All</button>
                        <button class="filter-btn" onclick="filterMyComp('pending',this)" style="font-size:.78rem; padding:4px 10px;">Pending</button>
                        <button class="filter-btn" onclick="filterMyComp('resolved',this)" style="font-size:.78rem; padding:4px 10px;">Resolved</button>
                    </div>
                    <% } %>
                </div>

                <% if (myComplaints.isEmpty()) { %>
                <div class="empty-history">
                    <div style="font-size:36px; margin-bottom:10px;">📭</div>
                    <p style="font-weight:700; color:#0d1b2a; margin-bottom:4px;">No complaints yet</p>
                    <p style="font-size:.85rem; color:#5a6a7e;">
                        Use the form on the left to submit your first complaint.
                    </p>
                </div>
                <% } else { %>
                <div id="myCompHistory">
                    <% for (int i = myComplaints.size() - 1; i >= 0; i--) {
                        com.hostel.model.Complaint c = myComplaints.get(i);
                        String cls = "Pending".equals(c.getStatus()) ? "pending" : "resolved";
                        // Extract category from description
                        String desc = c.getDescription();
                        String cat = "";
                        String body = desc;
                        if (desc.startsWith("[") && desc.contains("] ")) {
                            int end = desc.indexOf("] ");
                            cat  = desc.substring(1, end);
                            body = desc.substring(end + 2);
                        }
                    %>
                    <div class="history-item <%= cls %>"
                         data-status="<%= cls %>"
                         style="animation-delay:<%= (myComplaints.size() - 1 - i) * 0.05 %>s">
                        <div class="hist-header">
                            <div>
                                <% if (!cat.isEmpty()) { %>
                                <div class="hist-cat">📌 <%= cat %></div>
                                <% } %>
                            </div>
                            <% if ("Pending".equals(c.getStatus())) { %>
                                <span class="badge badge-pending">⏳ Pending</span>
                            <% } else { %>
                                <span class="badge badge-resolved">✔ Resolved</span>
                            <% } %>
                        </div>
                        <div class="hist-desc"><%= body %></div>
                        <div class="hist-time">🕐 Submitted: <%= c.getTimestamp() %></div>
                    </div>
                    <% } %>
                </div>
                <div id="noMyComp" style="display:none; padding:20px; text-align:center; color:#5a6a7e; font-size:.88rem;">
                    No complaints match the selected filter.
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
    function updateCharCount(textarea) {
        const len = textarea.value.length;
        const counter = document.getElementById('charCounter');
        counter.textContent = len + ' / 500 characters';
        counter.className = 'char-counter' + (len > 425 ? ' warn' : '') + (len >= 500 ? ' over' : '');
        textarea.classList.remove('input-error');
        document.getElementById('descriptionError').classList.remove('show');
    }

    document.getElementById('complaintForm').addEventListener('submit', function(e) {
        let valid = true;
        const cat  = document.getElementById('category');
        const desc = document.getElementById('description');
        const catE = document.getElementById('categoryError');
        const desE = document.getElementById('descriptionError');
        [cat, desc].forEach(el => el.classList.remove('input-error'));
        [catE, desE].forEach(el => el.classList.remove('show'));

        if (!cat.value) { cat.classList.add('input-error'); catE.classList.add('show'); valid = false; }
        if (!desc.value.trim() || desc.value.trim().length < 20) {
            desc.classList.add('input-error');
            desE.textContent = 'Please describe your issue in at least 20 characters.';
            desE.classList.add('show'); valid = false;
        }
        if (!valid) { e.preventDefault(); return; }
        const btn = document.getElementById('submitBtn');
        btn.value = 'Submitting…'; btn.classList.add('loading');
    });

    document.getElementById('category').addEventListener('change', function() {
        this.classList.remove('input-error');
        document.getElementById('categoryError').classList.remove('show');
    });

    function filterMyComp(status, btn) {
        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        let vis = 0;
        document.querySelectorAll('.history-item').forEach(item => {
            const show = status === 'all' || item.getAttribute('data-status') === status;
            item.style.display = show ? '' : 'none';
            if (show) vis++;
        });
        document.getElementById('noMyComp').style.display = vis === 0 ? 'block' : 'none';
    }

    function checkLayout() {
        const grid = document.getElementById('mainGrid');
        if (!grid) return;
        grid.style.gridTemplateColumns = window.innerWidth < 768 ? '1fr' : '1fr 1fr';
    }
    checkLayout();
    window.addEventListener('resize', checkLayout);

    var alertBox = document.getElementById('alertBox');
    if (alertBox) {
        setTimeout(() => { alertBox.style.transition = 'opacity .5s'; alertBox.style.opacity = '0';
            setTimeout(() => alertBox.remove(), 500); }, 6000);
    }
</script>
</body>
</html>
