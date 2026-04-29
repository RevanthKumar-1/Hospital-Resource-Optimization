<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Hospital Login</title>
	<style>
	    * { margin: 0; padding: 0; box-sizing: border-box; }

	    body {
	        font-family: 'Segoe UI', sans-serif;
	        background: #1a73e8;
	        min-height: 100vh;
	        display: flex;
	        flex-direction: column;
	    }

	    /* Navbar - Changed justify-content to center */
	    .navbar {
	        background: #1558b0;
	        padding: 16px 40px;
	        display: flex;
	        justify-content: center; 
	        align-items: center;
	        border-bottom: 3px solid rgba(255,255,255,0.2);
	    }

	    .logo { font-size: 20px; font-weight: 700; color: white; }
	    .logo span { color: #ffd54f; }

	    /* Page Content - Changed to column to stack elements vertically */
	    .page-content {
	        flex: 1;
	        display: flex;
	        align-items: center;
	        justify-content: center;
	        padding: 40px 20px;
	    }

	    .login-wrapper {
	        display: flex;
	        flex-direction: column; /* Stacks Left Content over Card */
	        align-items: center;
	        gap: 40px; /* Reduced gap for vertical flow */
	        max-width: 900px;
	        width: 100%;
	    }

	    /* Left side text - Center aligned for the top position */
	    .login-left {
	        flex: none;
	        color: white;
	        text-align: center; 
	    }

	    .login-left h1 {
	        font-size: 36px;
	        font-weight: 700;
	        line-height: 1.3;
	        margin-bottom: 16px;
	    }

	    .login-left h1 span { color: #ffd54f; }

	    .login-left p {
	        font-size: 15px;
	        opacity: 0.85;
	        line-height: 1.7;
	        margin-bottom: 0; /* Removed bottom margin since it's now on top */
	        max-width: 500px; /* Keeps the text readable in the center */
	    }

	    /* Login Card */
	    .login-card {
	        background: white;
	        border-radius: 16px;
	        box-shadow: 0 8px 32px rgba(0,0,0,0.2);
	        width: 100%;
	        max-width: 380px;
	        overflow: hidden;
	        flex-shrink: 0;
	    }

	    .card-header {
	        background: white;
	        padding: 28px 32px 0;
	        text-align: center;
	    }

	    .card-header h2 { font-size: 22px; color: #333; font-weight: 700; }
	    .card-header p { font-size: 13px; color: #888; margin-top: 6px; }

	    .card-body { padding: 24px 32px 32px; }

	    /* Alert */
	    .alert {
	        padding: 10px 14px;
	        border-radius: 8px;
	        font-size: 13px;
	        margin-bottom: 18px;
	        text-align: center;
	    }

	    .alert.error { background: #fdecea; color: #c62828; }
	    .alert.success { background: #e8f5e9; color: #2e7d32; }

	    /* Form */
	    .form-group { margin-bottom: 16px; }

	    label {
	        display: block;
	        font-size: 13px;
	        font-weight: 600;
	        color: #555;
	        margin-bottom: 6px;
	    }

	    input {
	        width: 100%;
	        padding: 11px 14px;
	        border: 1.5px solid #e0e0e0;
	        border-radius: 8px;
	        font-size: 14px;
	        outline: none;
	        transition: border 0.2s;
	        background: #fafafa;
	    }

	    input:focus {
	        border-color: #1a73e8;
	        background: white;
	    }

	    .submit-btn {
	        width: 100%;
	        padding: 13px;
	        background: #1a73e8;
	        color: white;
	        border: none;
	        border-radius: 10px;
	        font-size: 15px;
	        font-weight: 600;
	        cursor: pointer;
	        margin-top: 8px;
	        transition: background 0.2s;
	    }

	    .submit-btn:hover { background: #1558b0; }

	    .card-footer {
	        text-align: center;
	        padding: 0 32px 24px;
	        font-size: 13px;
	        color: #888;
	    }

	    .card-footer a {
	        color: #1a73e8;
	        font-weight: 600;
	        text-decoration: none;
	    }

	    .card-footer a:hover { text-decoration: underline; }

	    .divider {
	        height: 1px;
	        background: #f0f0f0;
	        margin: 16px 0;
	    }
	</style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <div class="logo">🏥 Hospital<span>System</span></div>
</div>

<!-- Content -->
<div class="page-content">
    <div class="login-wrapper">

        <!-- Left -->
        <div class="login-left">
            <h1>Intelligent <span>Hospital</span><br/>Resource System</h1>
            <p>A smart, unified platform for managing hospital resources, scheduling, and patient care efficiently.</p>
        </div>

        <!-- Login Card -->
        <div class="login-card">
            <div class="card-header">
                <h2>Welcome Back 👋</h2>
                <p>Login to access your portal</p>
            </div>

            <div class="card-body">

                <% if ("true".equals(request.getParameter("error"))) { %>
                    <div class="alert error">⚠️ Invalid email or password.</div>
                <% } %>

                <% if ("true".equals(request.getParameter("success"))) { %>
                    <div class="alert success">✅ Account created! You can now login.</div>
                <% } %>

                <form action="/login" method="post">
                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" name="email" placeholder="Enter your email" required />
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" name="password" placeholder="Enter your password" required />
                    </div>
                    <button type="submit" class="submit-btn">Login</button>
                </form>
            </div>

            <div class="divider"></div>

            <div class="card-footer">
                New patient? <a href="/signup">Create an account</a>
            </div>
        </div>

    </div>
</div>

</body>
</html>