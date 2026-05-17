<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — Smart Hostel</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="page-wrapper">

<div class="container-narrow">

    <%
        String error   = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
    %>

    <div class="auth-card">

        <div class="auth-card-header">
            <div class="logo-mark">🏨</div>
            <h1>Smart Hostel</h1>
            <p>Sign in to your account</p>
        </div>

        <div class="auth-card-body">

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

            <form action="login" method="post" id="loginForm" novalidate>

                <div class="form-group">
                    <label for="email">Email / Username</label>
                    <input type="text" id="email" name="email"
                           placeholder="you@example.com"
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                           autocomplete="username">
                    <div class="field-error" id="emailError">Please enter your email or username.</div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password"
                               placeholder="••••••••"
                               autocomplete="current-password">
                        <button type="button" class="toggle-password" onclick="togglePassword('password', this)"
                                title="Show/hide password">👁</button>
                    </div>
                    <div class="field-error" id="passwordError">Please enter your password.</div>
                </div>

                <input type="submit" id="loginBtn" class="btn btn-primary btn-full" value="Sign In →">

            </form>

            <div class="auth-footer">
                Don't have an account? <a href="register">Create one here</a>
            </div>

        </div>
    </div>

</div>

<footer class="footer">
    &copy; 2025 Smart Hostel Management System. All rights reserved.
</footer>

<script>
    /* ── Form Validation ─────────────────────────── */
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        let valid = true;

        const email    = document.getElementById('email');
        const password = document.getElementById('password');
        const emailErr = document.getElementById('emailError');
        const passErr  = document.getElementById('passwordError');

        // Reset
        [email, password].forEach(el => el.classList.remove('input-error'));
        [emailErr, passErr].forEach(el => el.classList.remove('show'));

        if (!email.value.trim()) {
            email.classList.add('input-error');
            emailErr.classList.add('show');
            valid = false;
        }

        if (!password.value.trim()) {
            password.classList.add('input-error');
            passErr.classList.add('show');
            valid = false;
        }

        if (!valid) { e.preventDefault(); return; }

        // Loading state
        const btn = document.getElementById('loginBtn');
        btn.value = 'Signing in…';
        btn.classList.add('loading');
    });

    /* Live clear errors on input */
    ['email', 'password'].forEach(function(id) {
        document.getElementById(id).addEventListener('input', function() {
            this.classList.remove('input-error');
            document.getElementById(id + 'Error').classList.remove('show');
        });
    });\
    
    /* ── Toggle Password Visibility ─────────────── */
    function togglePassword(inputId, btn) {
        const input = document.getElementById(inputId);
        if (input.type === 'password') {
            input.type = 'text';
            btn.textContent = '🙈';
        } else {
            input.type = 'password';
            btn.textContent = '👁';
        }
    }

    /* Auto-dismiss alerts after 6 seconds */
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