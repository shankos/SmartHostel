<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — Smart Hostel</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="page-wrapper">

<div class="container-narrow">

    <%
        String error = (String) request.getAttribute("error");
    %>

    <div class="auth-card">

        <div class="auth-card-header">
            <div class="logo-mark">✏️</div>
            <h1>Create Account</h1>
            <p>Register as a new hostel resident</p>
        </div>

        <div class="auth-card-body">

            <% if (error != null) { %>
            <div class="alert alert-error" id="alertBox">
                <span class="alert-icon">⚠</span>
                <span><%= error %></span>
                <button class="alert-close" onclick="this.parentElement.remove()">✕</button>
            </div>
            <% } %>

            <form action="register" method="post" id="registerForm" novalidate>

                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name"
                           placeholder="e.g. John Doe"
                           value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>"
                           autocomplete="name">
                    <div class="field-error" id="nameError">Please enter your full name.</div>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="text" id="email" name="email"
                           placeholder="you@example.com"
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                           autocomplete="email">
                    <div class="field-error" id="emailError">Please enter a valid email address.</div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password"
                               placeholder="Create a strong password"
                               autocomplete="new-password">
                        <button type="button" class="toggle-password" onclick="togglePassword('password', this)"
                                title="Show/hide password">👁</button>
                    </div>
                    <div class="password-strength" id="strengthMeter" style="display:none;">
                        <div class="strength-bar" id="bar1"></div>
                        <div class="strength-bar" id="bar2"></div>
                        <div class="strength-bar" id="bar3"></div>
                        <span class="strength-label" id="strengthLabel"></span>
                    </div>
                    <div class="field-error" id="passwordError">Password must be at least 6 characters.</div>
                </div>

                <input type="submit" id="registerBtn" class="btn btn-primary btn-full" value="Create Account →">

            </form>

            <div class="auth-footer">
                Already have an account? <a href="login">Sign in here</a>
            </div>

        </div>
    </div>

</div>

<footer class="footer">
    &copy; 2025 Smart Hostel Management System. All rights reserved.
</footer>

<script>
    /* ── Password Strength Meter ─────────────────── */
    document.getElementById('password').addEventListener('input', function() {
        const val    = this.value;
        const meter  = document.getElementById('strengthMeter');
        const label  = document.getElementById('strengthLabel');
        const bars   = [document.getElementById('bar1'),
                        document.getElementById('bar2'),
                        document.getElementById('bar3')];

        if (!val) { meter.style.display = 'none'; return; }
        meter.style.display = 'flex';

        let score = 0;
        if (val.length >= 6)  score++;
        if (val.length >= 10) score++;
        if (/[A-Z]/.test(val) && /[0-9]/.test(val)) score++;

        bars.forEach(b => { b.className = 'strength-bar'; });

        if (score === 1) {
            bars[0].classList.add('weak');
            label.textContent = 'Weak'; label.className = 'strength-label weak';
        } else if (score === 2) {
            bars[0].classList.add('medium');
            bars[1].classList.add('medium');
            label.textContent = 'Fair'; label.className = 'strength-label medium';
        } else if (score === 3) {
            bars.forEach(b => b.classList.add('strong'));
            label.textContent = 'Strong'; label.className = 'strength-label strong';
        }

        // Clear error on input
        this.classList.remove('input-error');
        document.getElementById('passwordError').classList.remove('show');
    });

    /* ── Form Validation ─────────────────────────── */
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        let valid = true;

        const name      = document.getElementById('name');
        const email     = document.getElementById('email');
        const password  = document.getElementById('password');
        const nameErr   = document.getElementById('nameError');
        const emailErr  = document.getElementById('emailError');
        const passErr   = document.getElementById('passwordError');

        // Reset
        [name, email, password].forEach(el => el.classList.remove('input-error'));
        [nameErr, emailErr, passErr].forEach(el => el.classList.remove('show'));

        if (!name.value.trim() || name.value.trim().length < 2) {
            name.classList.add('input-error');
            nameErr.textContent = 'Please enter your full name (at least 2 characters).';
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

        if (!password.value || password.value.length < 6) {
            password.classList.add('input-error');
            passErr.textContent = 'Password must be at least 6 characters.';
            passErr.classList.add('show');
            valid = false;
        }

        if (!valid) { e.preventDefault(); return; }

        const btn = document.getElementById('registerBtn');
        btn.value = 'Creating account…';
        btn.classList.add('loading');
    });

    /* Live clear errors */
    ['name', 'email'].forEach(function(id) {
        document.getElementById(id).addEventListener('input', function() {
            this.classList.remove('input-error');
            document.getElementById(id + 'Error').classList.remove('show');
        });
    });

    function togglePassword(inputId, btn) {
        const input = document.getElementById(inputId);
        input.type  = input.type === 'password' ? 'text' : 'password';
        btn.textContent = input.type === 'password' ? '👁' : '🙈';
    }

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
