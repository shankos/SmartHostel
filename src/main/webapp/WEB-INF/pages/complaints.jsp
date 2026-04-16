<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Complaint — Smart Hostel</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="page-wrapper">

<nav class="topbar">
    <a href="studentHome" class="topbar-brand">
        <div class="brand-icon">🏨</div>
        <span>Smart Hostel</span>
    </a>
    <div class="topbar-nav">
        <a href="complaints" class="active">Complaints</a>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <%
        String error   = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
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

    <h1 class="page-title">Submit a Complaint</h1>
    <p class="page-subtitle">Describe your issue and the hostel administration will review it promptly.</p>

    <div style="display:grid; grid-template-columns:1fr 1fr; gap:28px; align-items:start;">

        <!-- Complaint Form -->
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
                              placeholder="Please describe your issue in detail. Include room number, date, and any other relevant information…"
                              maxlength="500"
                              oninput="updateCharCount(this)"></textarea>
                    <div class="char-counter" id="charCounter">0 / 500 characters</div>
                    <div class="field-error" id="descriptionError">
                        Please describe your issue (at least 20 characters).
                    </div>
                </div>

                <input type="submit" id="submitBtn" class="btn btn-primary btn-full" value="Submit Complaint →">

            </form>
        </div>

        <!-- Info Panel -->
        <div>
            <div class="page-card" style="margin-bottom:16px;">
                <div class="page-card-header" style="margin-bottom:16px; padding-bottom:12px;">
                    <h2>ℹ️ How It Works</h2>
                </div>
                <div style="display:flex; flex-direction:column; gap:14px;">
                    <div style="display:flex; align-items:flex-start; gap:12px;">
                        <div style="width:28px; height:28px; border-radius:50%; background:var(--amber);
                                    display:flex; align-items:center; justify-content:center;
                                    font-size:12px; font-weight:700; color:var(--navy); flex-shrink:0;">1</div>
                        <div>
                            <strong style="font-size:0.88rem; color:var(--navy);">Submit your complaint</strong>
                            <p style="font-size:0.82rem; color:var(--text-soft); margin-top:2px;">
                                Select a category and describe your issue clearly.
                            </p>
                        </div>
                    </div>
                    <div style="display:flex; align-items:flex-start; gap:12px;">
                        <div style="width:28px; height:28px; border-radius:50%; background:var(--amber);
                                    display:flex; align-items:center; justify-content:center;
                                    font-size:12px; font-weight:700; color:var(--navy); flex-shrink:0;">2</div>
                        <div>
                            <strong style="font-size:0.88rem; color:var(--navy);">Admin reviews it</strong>
                            <p style="font-size:0.82rem; color:var(--text-soft); margin-top:2px;">
                                The administration will review and take action.
                            </p>
                        </div>
                    </div>
                    <div style="display:flex; align-items:flex-start; gap:12px;">
                        <div style="width:28px; height:28px; border-radius:50%; background:var(--amber);
                                    display:flex; align-items:center; justify-content:center;
                                    font-size:12px; font-weight:700; color:var(--navy); flex-shrink:0;">3</div>
                        <div>
                            <strong style="font-size:0.88rem; color:var(--navy);">Issue gets resolved</strong>
                            <p style="font-size:0.82rem; color:var(--text-soft); margin-top:2px;">
                                Your complaint is marked resolved once addressed.
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="page-card" style="margin-bottom:0;">
                <div class="page-card-header" style="margin-bottom:14px; padding-bottom:12px;">
                    <h2>💡 Tips</h2>
                </div>
                <ul style="list-style:none; display:flex; flex-direction:column; gap:10px;">
                    <li style="display:flex; gap:8px; font-size:0.85rem; color:var(--text-soft);">
                        <span>→</span> Include your room number if relevant
                    </li>
                    <li style="display:flex; gap:8px; font-size:0.85rem; color:var(--text-soft);">
                        <span>→</span> Mention the date/time of the issue
                    </li>
                    <li style="display:flex; gap:8px; font-size:0.85rem; color:var(--text-soft);">
                        <span>→</span> Be as specific as possible for faster resolution
                    </li>
                    <li style="display:flex; gap:8px; font-size:0.85rem; color:var(--text-soft);">
                        <span>→</span> One complaint per issue is recommended
                    </li>
                </ul>
            </div>
        </div>

    </div>

    <div style="margin-top:10px;">
        <a href="studentHome" class="back-link">← Back to Dashboard</a>
    </div>

</div>

<footer class="footer">
    &copy; 2025 Smart Hostel Management System. All rights reserved.
</footer>

<script>
    /* ── Character Counter ───────────────────────── */
    function updateCharCount(textarea) {
        const len     = textarea.value.length;
        const max     = 500;
        const counter = document.getElementById('charCounter');
        counter.textContent = len + ' / ' + max + ' characters';
        counter.className   = 'char-counter';
        if (len > max * 0.85) counter.classList.add('warn');
        if (len >= max)       counter.classList.add('over');
        // clear error on type
        textarea.classList.remove('input-error');
        document.getElementById('descriptionError').classList.remove('show');
    }

    /* ── Form Validation ─────────────────────────── */
    document.getElementById('complaintForm').addEventListener('submit', function(e) {
        let valid = true;
        const category    = document.getElementById('category');
        const description = document.getElementById('description');
        const catErr      = document.getElementById('categoryError');
        const descErr     = document.getElementById('descriptionError');

        [category, description].forEach(el => el.classList.remove('input-error'));
        [catErr, descErr].forEach(el => el.classList.remove('show'));

        if (!category.value) {
            category.classList.add('input-error');
            catErr.classList.add('show');
            valid = false;
        }

        if (!description.value.trim() || description.value.trim().length < 20) {
            description.classList.add('input-error');
            descErr.textContent = 'Please describe your issue in at least 20 characters.';
            descErr.classList.add('show');
            valid = false;
        }

        if (!valid) { e.preventDefault(); return; }

        const btn = document.getElementById('submitBtn');
        btn.value = 'Submitting…';
        btn.classList.add('loading');
    });

    document.getElementById('category').addEventListener('change', function() {
        this.classList.remove('input-error');
        document.getElementById('categoryError').classList.remove('show');
    });

    /* Responsive: stack on small screens */
    function checkLayout() {
        var grid = document.querySelector('[style*="grid-template-columns:1fr 1fr"]');
        if (!grid) return;
        if (window.innerWidth < 768) {
            grid.style.gridTemplateColumns = '1fr';
        } else {
            grid.style.gridTemplateColumns = '1fr 1fr';
        }
    }
    checkLayout();
    window.addEventListener('resize', checkLayout);

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
