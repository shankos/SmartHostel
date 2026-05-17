<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Payments — Smart Hostel</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .payment-timeline { display: flex; flex-direction: column; gap: 0; }
        .pay-item {
            display: flex; align-items: center; gap: 18px;
            padding: 16px 20px; border-bottom: 1px solid #f0ede8;
            transition: background .14s;
        }
        .pay-item:last-child { border-bottom: none; }
        .pay-item:hover { background: #fafaf8; }
        .pay-icon {
            width: 44px; height: 44px; border-radius: 12px; flex-shrink: 0;
            display: flex; align-items: center; justify-content: center; font-size: 20px;
        }
        .pay-icon.paid    { background: #e8f5ee; }
        .pay-icon.pending { background: #fff3cc; }
        .pay-icon.overdue { background: #fdeaea; }
        .pay-meta { flex: 1; }
        .pay-meta .month  { font-weight: 700; font-size: .95rem; color: #0d1b2a; }
        .pay-meta .date   { font-size: .78rem; color: #5a6a7e; margin-top: 2px; }
        .pay-amount {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.3rem; font-weight: 700; color: #0d1b2a; text-align: right;
        }
        .pay-amount .sub { font-size: .72rem; color: #5a6a7e; font-family: 'DM Sans', sans-serif;
                           font-weight: 400; display: block; }
        .progress-bar-wrap { background: #f0ede8; border-radius: 20px; height: 8px; overflow: hidden; margin-top: 8px; }
        .progress-bar-fill { height: 100%; border-radius: 20px; background: linear-gradient(90deg, #2e9e6b, #58c98a); transition: width .6s ease; }
        .no-payments-art { text-align:center; padding:48px 20px; }
        .no-payments-art .big-icon { font-size:52px; margin-bottom:16px; }
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
        <a href="payments" class="active">My Payments</a>
        <a href="roomRequests">Room Request</a>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <%
        String error   = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        java.util.ArrayList<com.hostel.model.Payment> myPayments =
            (java.util.ArrayList<com.hostel.model.Payment>) request.getAttribute("myPayments");
        String userEmail = (String) session.getAttribute("userEmail");

        int total = (myPayments != null) ? myPayments.size() : 0;
        int paid = 0; int pending = 0; int overdue = 0; double totalAmt = 0; double paidAmt = 0;
        if (myPayments != null) {
            for (com.hostel.model.Payment p : myPayments) {
                totalAmt += p.getAmount();
                if ("Paid".equals(p.getStatus()))    { paid++;    paidAmt += p.getAmount(); }
                else if ("Overdue".equals(p.getStatus())) overdue++;
                else pending++;
            }
        }
        int paidPct = (total > 0) ? (int)((double)paid / total * 100) : 0;
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

    <h1 class="page-title">My Fee Payments</h1>
    <p class="page-subtitle">Track your hostel fee payment history and outstanding dues.</p>

    <!-- Stats -->
    <div class="dashboard-grid" style="margin-bottom:24px;">
        <div class="stat-card">
            <div class="stat-icon green">✔</div>
            <div class="stat-info">
                <p>Paid</p>
                <h3 style="color:#2e9e6b;"><%= paid %></h3>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon amber">⏳</div>
            <div class="stat-info">
                <p>Pending</p>
                <h3 style="color:#b07800;"><%= pending %></h3>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon red">⚠</div>
            <div class="stat-info">
                <p>Overdue</p>
                <h3 style="color:#d94f4f;"><%= overdue %></h3>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon navy">💰</div>
            <div class="stat-info">
                <p>Total Due</p>
                <h3 style="font-size:1.2rem;">Rs. <%= String.format("%.0f", totalAmt) %></h3>
            </div>
        </div>
    </div>

    <!-- Progress Card -->
    <% if (total > 0) { %>
    <div class="page-card" style="margin-bottom:24px;">
        <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:10px;">
            <div>
                <strong style="font-size:.95rem; color:#0d1b2a;">Payment Completion</strong>
                <p style="font-size:.82rem; color:#5a6a7e; margin-top:2px;">
                    <%= paid %> of <%= total %> payments settled
                </p>
            </div>
            <div style="font-family:'Cormorant Garamond',serif; font-size:2rem; font-weight:700;
                         color:<%= paidPct == 100 ? "#2e9e6b" : "#e8a020" %>;">
                <%= paidPct %>%
            </div>
        </div>
        <div class="progress-bar-wrap">
            <div class="progress-bar-fill" id="progressFill" style="width:0%"></div>
        </div>
    </div>
    <% } %>

    <!-- Payment List -->
    <div class="page-card">
        <div class="page-card-header">
            <h2>Payment History</h2>
            <% if (total > 0) { %>
            <div style="display:flex; gap:6px;">
                <button class="filter-btn active" onclick="filterMyPay('all',this)">All</button>
                <button class="filter-btn" onclick="filterMyPay('Paid',this)">Paid</button>
                <button class="filter-btn" onclick="filterMyPay('Pending',this)">Pending</button>
                <button class="filter-btn" onclick="filterMyPay('Overdue',this)">Overdue</button>
            </div>
            <% } %>
        </div>

        <% if (myPayments == null || myPayments.isEmpty()) { %>
        <div class="no-payments-art">
            <div class="big-icon">💳</div>
            <p style="font-weight:700; font-size:1.05rem; color:#0d1b2a; margin-bottom:6px;">
                No payment records assigned yet
            </p>
            <p style="color:#5a6a7e; font-size:.88rem; max-width:360px; margin:0 auto;">
                The administration will add your fee records here. Check back soon or contact the admin.
            </p>
        </div>
        <% } else { %>
        <div class="payment-timeline" id="payTimeline">
            <% for (int i = 0; i < myPayments.size(); i++) {
                com.hostel.model.Payment p = myPayments.get(i);
                String cls = p.isPaid() ? "paid" : p.isOverdue() ? "overdue" : "pending";
                String icon = p.isPaid() ? "✅" : p.isOverdue() ? "⚠️" : "⏳";
            %>
            <div class="pay-item" data-status="<%= p.getStatus() %>"
                 style="animation:fadeUp .4s ease both; animation-delay:<%= i * 0.06 %>s">
                <div class="pay-icon <%= cls %>"><%= icon %></div>
                <div class="pay-meta">
                    <div class="month"><%= p.getMonth() %></div>
                    <div class="date">
                        <% if (p.isPaid() && p.getPaidDate() != null) { %>
                            Paid on <%= p.getPaidDate() %>
                        <% } else if (p.isOverdue()) { %>
                            <span style="color:#d94f4f; font-weight:600;">⚠ Payment overdue — contact admin</span>
                        <% } else { %>
                            Awaiting payment
                        <% } %>
                    </div>
                </div>
                <div style="text-align:right;">
                    <div class="pay-amount">
                        Rs. <%= String.format("%.0f", p.getAmount()) %>
                    </div>
                    <div style="margin-top:6px;">
                        <% if (p.isPaid()) { %>
                            <span class="badge badge-paid">✔ Paid</span>
                        <% } else if (p.isOverdue()) { %>
                            <span class="badge badge-overdue">⚠ Overdue</span>
                        <% } else { %>
                            <span class="badge badge-pending">⏳ Pending</span>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <div id="noMyPayResults" style="display:none; padding:24px; text-align:center;
             color:#5a6a7e; font-size:.9rem;">No records match the selected filter.</div>
        <% } %>
    </div>

    <!-- Overdue Notice -->
    <% if (overdue > 0) { %>
    <div style="padding:16px 20px; background:#fdeaea; border:1px solid #f5c0c0; border-radius:10px;
                display:flex; align-items:flex-start; gap:12px; margin-bottom:24px;">
        <span style="font-size:22px; flex-shrink:0;">⚠️</span>
        <div>
            <strong style="color:#c0392b; font-size:.9rem;">You have <%= overdue %> overdue payment(s)</strong>
            <p style="color:#c0392b; font-size:.83rem; margin-top:3px; opacity:.85;">
                Please contact the hostel administration immediately to settle your outstanding dues
                and avoid any service disruption.
            </p>
        </div>
    </div>
    <% } %>

    <a href="studentHome" class="back-link">← Back to Dashboard</a>
</div>

<footer class="footer">&copy; 2025 Smart Hostel Management System. All rights reserved.</footer>

<script>
    // Progress bar animation
    const fill = document.getElementById('progressFill');
    if (fill) {
        setTimeout(() => { fill.style.width = '<%= paidPct %>%'; }, 300);
    }

    function filterMyPay(status, btn) {
        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        let vis = 0;
        document.querySelectorAll('.pay-item').forEach(r => {
            const show = status === 'all' || r.getAttribute('data-status') === status;
            r.style.display = show ? '' : 'none';
            if (show) vis++;
        });
        document.getElementById('noMyPayResults').style.display = vis === 0 ? 'block' : 'none';
    }

    var alertBox = document.getElementById('alertBox');
    if (alertBox) {
        setTimeout(() => { alertBox.style.transition = 'opacity .5s'; alertBox.style.opacity = '0';
            setTimeout(() => alertBox.remove(), 500); }, 6000);
    }
</script>
</body>
</html>
