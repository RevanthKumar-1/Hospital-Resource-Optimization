<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Hospital Login</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f0f4f8;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-card {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            width: 380px;
        }

        .login-card h2 {
            text-align: center;
            color: #1a73e8;
            margin-bottom: 8px;
        }

        .login-card p {
            text-align: center;
            color: #666;
            margin-bottom: 28px;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            color: #333;
            font-size: 14px;
            font-weight: 600;
        }

        input {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
            transition: border 0.2s;
        }

        input:focus { border-color: #1a73e8; }

        button {
            width: 100%;
            padding: 12px;
            background: #1a73e8;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 8px;
        }

        button:hover { background: #1558b0; }

        .error {
            background: #fdecea;
            color: #c62828;
            padding: 10px;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 16px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <h2>🏥 Hospital System</h2>
        <p>Intelligent Resource Optimization</p>

        <% if ("true".equals(request.getParameter("error"))) { %>
            <div class="error">Invalid email or password. Please try again.</div>
        <% } %>

        <form action="/login" method="post">
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" placeholder="Enter your email" required />
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Enter your password" required />
            </div>
            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>