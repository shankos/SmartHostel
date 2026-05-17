<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Management — Smart Hostel Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .amount-cell { font-family: 'Cormorant Garamond', serif; font-size: 1.05rem; font-weight: 700; color: #0d1b2a; }
        .paid-date   { font-size: .75rem; color: #2e9e6b; margin-top: 2px; }
        .status-select {
            font-size: .8rem; padding: 4px 10px; border-radius: 6px;
            border: 1.5px solid #e2ddd6; font-family: 'DM Sans', sans-serif;
            background: #f9f6f1; color: #1a2535; cursor: pointer;
        }
        .summary-bar {
            display: flex; gap: 0; background: #fff; border: 1px solid #e2ddd6;
            border-radius: 12px; overflow: hidden; margin-bottom: 24px;
            box-shadow: 0 2px 10px rgba(13,27,42,.07);
        }
        .summary-bar-item {
            flex: 1; padding: 18px 22px; border-right: 1px solid #e2ddd6;
            text-align: center;
        }
        .summary-bar-item:last-child { border-right: none; }
        .summary-bar-item .label { font-size: .72rem; font-weight: 700; text-transform: uppercase; letter-spacing: .07em; color: #5a6a7e; margin-bottom: 4px; }
        .summary-bar-item .value { font-family: 'Cormorant Garamond', serif; font-size: 1.6rem; font-weight: 700; color: #0d1b2a; }
        .action-group { display: flex; gap: 5px; flex-wrap: wrap; }
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
        <a href="payments" class="active">Payments</a>
        <a href="users">Users</a>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <%
        String error   = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        java.util.ArrayList<com.hostel.model.Payment> payments =
            (java.util.ArrayList<com.hostel.model.Payment>) request.getAttribute("payments");
        java.util.ArrayList<com.hostel.model.Student> students =
            (java.util.ArrayList<com.hostel.model.Student>) request.getAttribute("students");

        int totalPayments = (payments != null) ? payments.size() : 0;
        int paidCount = 0; int pendingCount = 0; int overdueCount = 0;
        double totalRevenue = 0;
        if (payments != null) {
            for (com.hostel.model.Payment p : payments) {
                if ("Paid".equals(p.getStatus()))    { paidCount++;    totalRevenue += p.getAmount(); }
                else if ("Overdue".equals(p.getStatus())) overdueCount++;
                else pendingCount++;
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

    <h1 class="page-title">Fee Payment Tracker</h1>
    <p class="page-subtitle">Manage and track all student fee payments across months.</p>

    <!-- Summary Bar -->
    <div class="summary-bar">
        <div class="summary-bar-item">
            <div class="label">Total Records</div>
            <div class="value"><%= totalPayments %></div>
        </div>
        <div class="summary-bar-item">
            <div class="label" style="color:#2e9e6b;">Paid</div>
            <div class="value" style="color:#2e9e6b;"><%= paidCount %></div>
        </div>
        <div class="summary-bar-item">
            <div class="label" style="color:#b07800;">Pending</div>
            <div class="value" style="color:#b07800;"><%= pendingCount %></div>
        </div>
        <div class="summary-bar-item">
            <div class="label" style="color:#d94f4f;">Overdue</div>
            <div class="value" style="color:#d94f4f;"><%= overdueCount %></div>
        </div>
        <div class="summary-bar-item">
            <div class="label">Revenue Collected</div>
            <div class="value">Rs. <%= String.format("%.0f", totalRevenue) %></div>
        </div>
    </div>

    <!-- Add Payment Form -->
    <div class="page-card">
        <div class="page-card-header">
            <h2>➕ Add Payment Record</h2>
        </div>
        <form action="payments" method="post" id="paymentForm" novalidate>
            <div class="form-row-2" style="gap:14px;">
                <div class="form-group" style="margin-bottom:0">
                    <label for="studentEmail">Student</label>
                    <select name="studentEmail" id="studentEmail" onchange="fillName(this)">
                        <option value="">— Select Student —</option>
                        <% if (students != null) {
                            for (com.hostel.model.Student s : students) { %>
                        <option value="<%= s.getEmail() %>" data-name="<%= s.getName() %>">
                            <%= s.getName() %> (<%= s.getEmail() %>)
                        </option>
                        <% } } %>
                    </select>
                    <input type="hidden" name="studentName" id="studentName">
                    <div class="field-error" id="studentErr">Please select a student.</div>
                </div>
                <div class="form-group" style="margin-bottom:0">
                    <label for="month">Month</label>
                    <input type="month" name="month" id="month"
                           value="<%= new java.text.SimpleDateFormat("yyyy-MM").format(new java.util.Date()) %>">
                    <div class="field-error" id="monthErr">Please select a month.</div>
                </div>
            </div>
            <div class="form-row-2" style="gap:14px; margin-top:14px;">
                <div class="form-group" style="margin-bottom:0">
                    <label for="amount">Amount (Rs.)</label>
                    <input type="number" name="amount" id="amount" placeholder="e.g. 5000" min="1" step="1">
                    <div class="field-error" id="amountErr">Please enter a valid positive amount.</div>
                </div>
                <div class="form-group" style="margin-bottom:0; display:flex; align-items:flex-end;">
                    <input type="submit" id="payBtn" value="Add Payment Record" style="width:100%; margin:0;">
                </div>
            </div>
        </form>
    </div>

    <!-- Payment Records Table -->
    <div class="page-card">
        <div class="page-card-header">
            <h2>All Payment Records</h2>
            <div style="display:flex; gap:6px; align-items:center;">
                <button class="filter-btn active" onclick="filterPay('all',this)">All</button>
                <button class="filter-btn" onclick="filterPay('Paid',this)">Paid</button>
                <button class="filter-btn" onclick="filterPay('Pending',this)">Pending</button>
                <button class="filter-btn" onclick="filterPay('Overdue',this)">Overdue</button>
            </div>
        </div>

        <% if (payments == null || payments.isEmpty()) { %>
        <div class="empty-state">
            <span class="empty-icon">💳</span>
            <p class="empty-title">No payment records yet</p>
            <p>Add payment records using the form above.</p>
        </div>
        <% } else { %>
        <div class="table-wrapper">
            <table id="payTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Student</th>
                        <th>Month</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Paid On</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (int i = 0; i < payments.size(); i++) {
                        com.hostel.model.Payment p = payments.get(i);
                        String sc = p.isPaid() ? "Paid" : p.isOverdue() ? "Overdue" : "Pending";
                    %>
                    <tr class="pay-row" data-status="<%= sc %>"
                        style="animation-delay:<%= i * 0.04 %>s">
                        <td style="color:#8a9ab0; font-size:.85rem;"><%= i + 1 %></td>
                        <td>
                            <div style="display:flex; align-items:center; gap:9px;">
                                <div style="width:30px; height:30px; border-radius:50%; background:#0d1b2a;
                                            display:flex; align-items:center; justify-content:center;
                                            font-size:12px; color:white; flex-shrink:0; font-weight:700;">
                                    <%= p.getStudentName().substring(0,1).toUpperCase() %>
                                </div>
                                <div>
                                    <div style="font-weight:600; font-size:.88rem; color:#0d1b2a;">
                                        <%= p.getStudentName() %>
                                    </div>
                                    <div style="font-size:.75rem; color:#5a6a7e;"><%= p.getStudentEmail() %></div>
                                </div>
                            </div>
                        </td>
                        <td style="font-weight:600; font-size:.88rem; color:#0d1b2a;">
                            <%= p.getMonth() %>
                        </td>
                        <td>
                            <span class="amount-cell">Rs. <%= String.format("%.0f", p.getAmount()) %></span>
                        </td>
                        <td>
                            <% if (p.isPaid()) { %>
                                <span class="badge badge-paid">✔ Paid</span>
                            <% } else if (p.isOverdue()) { %>
                                <span class="badge badge-overdue">⚠ Overdue</span>
                            <% } else { %>
                                <span class="badge badge-pending">⏳ Pending</span>
                            <% } %>
                        </td>
                        <td>
                            <% if (p.getPaidDate() != null) { %>
                                <span class="paid-date">✔ <%= p.getPaidDate() %></span>
                            <% } else { %>
                                <span style="color:#8a9ab0; font-size:.82rem;">—</span>
                            <% } %>
                        </td>
                        <td>
                            <div class="action-group">
                                <% if (!p.isPaid()) { %>
                                <a href="payments?markPaid=<%= i %>" class="action-link resolve"
                                   title="Mark as Paid">✔ Paid</a>
                                <% } %>
                                <% if (!p.isOverdue()) { %>
                                <a href="payments?markOverdue=<%= i %>" class="action-link deny"
                                   title="Mark as Overdue">⚠ Overdue</a>
                                <% } %>
                                <a href="#" class="action-link delete"
                                   onclick="confirmPayDelete(event,'payments?delete=<%= i %>','<%= p.getStudentName().replace("'","") %> - <%= p.getMonth() %>')">
                                   🗑</a>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <div id="noPayResults" style="display:none; padding:24px; text-align:center;
             color:#5a6a7e; font-size:.9rem;">No records match the selected filter.</div>
        <% } %>
    </div>

    <a href="home" class="back-link">← Back to Dashboard</a>
</div>

<!-- Confirm Delete Modal -->
<div id="payConfirmModal" style="display:none; position:fixed; inset:0;
     background:rgba(11,25,41,.55); z-index:1000; align-items:center; justify-content:center; padding:20px;">
    <div style="background:#fff; border-radius:14px; padding:32px 36px; max-width:380px; width:100%;
                box-shadow:0 24px 72px rgba(13,27,42,.22); text-align:center;">
        <div style="font-size:38px; margin-bottom:14px;">🗑️</div>
        <h3 style="font-family:'Cormorant Garamond',serif; font-size:1.3rem; color:#0d1b2a; margin-bottom:8px;">Delete Payment?</h3>
        <p id="payConfirmMsg" style="color:#5a6a7e; font-size:.9rem; margin-bottom:24px;"></p>
        <div style="display:flex; gap:12px; justify-content:center;">
            <button onclick="closePayModal()" class="btn btn-outline">Cancel</button>
            <a id="payConfirmAction" href="#" class="btn btn-danger">Yes, Delete</a>
        </div>
    </div>
</div>

<footer class="footer">&copy; 2025 Smart Hostel Management System. All rights reserved.</footer>

<script>
    function fillName(sel) {
        const opt = sel.options[sel.selectedIndex];
        document.getElementById('studentName').value = opt.getAttribute('data-name') || '';
        sel.classList.remove('input-error');
        document.getElementById('studentErr').classList.remove('show');
    }

    document.getElementById('paymentForm').addEventListener('submit', function(e) {
        let ok = true;
        const se = document.getElementById('studentEmail');
        const me = document.getElementById('month');
        const ae = document.getElementById('amount');
        if (!se.value) { se.classList.add('input-error'); document.getElementById('studentErr').classList.add('show'); ok = false; }
        if (!me.value) { me.classList.add('input-error'); document.getElementById('monthErr').classList.add('show'); ok = false; }
        const amt = parseFloat(ae.value);
        if (!ae.value || isNaN(amt) || amt <= 0) { ae.classList.add('input-error'); document.getElementById('amountErr').classList.add('show'); ok = false; }
        if (!ok) { e.preventDefault(); return; }
        document.getElementById('payBtn').value = 'Adding…'; 
        document.getElementById('payBtn').classList.add('loading');
    });

    function filterPay(status, btn) {
        document.querySelectorAll('.filter-btn').forEach(b => {
            b.classList.remove('active');
        });
        btn.classList.add('active');
        let vis = 0;
        document.querySelectorAll('.pay-row').forEach(r => {
            const show = status === 'all' || r.getAttribute('data-status') === status;
            r.style.display = show ? '' : 'none';
            if (show) vis++;
        });
        document.getElementById('noPayResults').style.display = vis === 0 ? 'block' : 'none';
    }

    function confirmPayDelete(e, url, label) {
        e.preventDefault();
        document.getElementById('payConfirmMsg').textContent =
            'Delete the payment record for "' + label + '"? This cannot be undone.';
        document.getElementById('payConfirmAction').href = url;
        document.getElementById('payConfirmModal').style.display = 'flex';
    }
    function closePayModal() { document.getElementById('payConfirmModal').style.display = 'none'; }
    document.getElementById('payConfirmModal').addEventListener('click', function(e) {
        if (e.target === this) closePayModal();
    });

    var alertBox = document.getElementById('alertBox');
    if (alertBox) {
        setTimeout(() => { alertBox.style.transition = 'opacity .5s'; alertBox.style.opacity = '0';
            setTimeout(() => alertBox.remove(), 500); }, 5000);
    }
</script>
</body>
</html>
