<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Sign Up</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f4f8ff;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Navbar */
        .navbar {
            background: white;
            padding: 16px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 3px solid #1a73e8;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        .logo { font-size: 20px; font-weight: 700; color: #333; }
        .logo span { color: #1a73e8; }

        .navbar-right { font-size: 14px; color: #888; }
        .navbar-right a { color: #1a73e8; font-weight: 600; text-decoration: none; }
        .navbar-right a:hover { text-decoration: underline; }

        /* Page Content */
        .page-content {
            flex: 1;
            display: flex;
            align-items: flex-start;
            justify-content: center;
            padding: 40px 20px;
        }

        .signup-container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
            width: 100%;
            max-width: 720px;
            overflow: hidden;
        }

        .signup-header {
            background: #1a73e8;
            padding: 32px 40px;
            color: white;
        }

        .signup-header h1 { font-size: 24px; font-weight: 700; }
        .signup-header p { font-size: 14px; opacity: 0.85; margin-top: 6px; }

        .signup-body { padding: 36px 40px; }

        /* Error / Success */
        .alert {
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 14px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .alert.error { background: #fdecea; color: #c62828; }

        /* Section Titles */
        .section-title {
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #1a73e8;
            margin-bottom: 16px;
            margin-top: 28px;
            padding-bottom: 8px;
            border-bottom: 2px solid #e8f0fe;
        }

        .section-title:first-of-type { margin-top: 0; }

        /* Form Grid */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .form-grid.single { grid-template-columns: 1fr; }

        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full { grid-column: 1 / -1; }

        label {
            font-size: 13px;
            font-weight: 600;
            color: #555;
        }

        input, select, textarea {
            padding: 10px 14px;
            border: 1.5px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            font-family: 'Segoe UI', sans-serif;
            outline: none;
            transition: border 0.2s;
            background: #fafafa;
        }

        input:focus, select:focus, textarea:focus {
            border-color: #1a73e8;
            background: white;
        }

        textarea { resize: vertical; min-height: 80px; }

        /* Submit */
        .submit-row {
            margin-top: 28px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 14px;
        }

        .submit-btn {
            width: 100%;
            padding: 14px;
            background: #1a73e8;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }

        .submit-btn:hover { background: #1558b0; }

        .login-link {
            font-size: 14px;
            color: #888;
        }

        .login-link a {
            color: #1a73e8;
            font-weight: 600;
            text-decoration: none;
        }

        .login-link a:hover { text-decoration: underline; }
    </style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <div class="logo">🏥 Hospital<span>System</span></div>
    <div class="navbar-right">
        Already have an account? <a href="/">Login here</a>
    </div>
</div>

<!-- Content -->
<div class="page-content">
    <div class="signup-container">

        <div class="signup-header">
            <h1>Patient Registration</h1>
            <p>Create your account to access the hospital patient portal.</p>
        </div>

        <div class="signup-body">

            <% if ("emailexists".equals(request.getParameter("error"))) { %>
                <div class="alert error">
                    ⚠️ This email is already registered. Please use a different email or login.
                </div>
            <% } %>

            <form action="/signup" method="post">

                <!-- Personal Info -->
                <div class="section-title">Personal Information</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label>Full Name *</label>
                        <input type="text" name="name" placeholder="Enter your full name" required />
                    </div>
                    <div class="form-group">
                        <label>Email Address *</label>
                        <input type="email" name="email" placeholder="Enter your email" required />
                    </div>
                    <div class="form-group">
                        <label>Password *</label>
                        <input type="password" name="password" placeholder="Create a password" required />
                    </div>
                    <div class="form-group">
                        <label>Phone Number *</label>
                        <input type="tel" name="phone" placeholder="Enter phone number" required />
                    </div>
                    <div class="form-group">
                        <label>Date of Birth *</label>
                        <input type="date" name="dateOfBirth" required />
                    </div>
                    <div class="form-group">
                        <label>Gender *</label>
                        <select name="gender" required>
                            <option value="" disabled selected>Select gender</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                </div>

                <!-- Medical Info -->
                <div class="section-title">Medical Information</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label>Blood Group *</label>
                        <select name="bloodGroup" required>
                            <option value="" disabled selected>Select blood group</option>
                            <option value="A+">A+</option>
                            <option value="A-">A-</option>
                            <option value="B+">B+</option>
                            <option value="B-">B-</option>
                            <option value="O+">O+</option>
                            <option value="O-">O-</option>
                            <option value="AB+">AB+</option>
                            <option value="AB-">AB-</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Emergency Contact *</label>
                        <input type="tel" name="emergencyContact" placeholder="Emergency contact number" required />
                    </div>
                    <div class="form-group full">
                        <label>Medical History</label>
                        <textarea name="medicalHistory" placeholder="Any existing conditions, allergies or past surgeries (optional)"></textarea>
                    </div>
                </div>

                <!-- Address -->
                <div class="section-title">Address</div>
                <div class="form-grid single">
                    <div class="form-group">
                        <label>Full Address *</label>
                        <textarea name="address" placeholder="Enter your full address" required></textarea>
                    </div>
                </div>

                <div class="submit-row">
                    <button type="submit" class="submit-btn">Create Account</button>
                    <span class="login-link">
                        Already registered? <a href="/">Login here</a>
                    </span>
                </div>

            </form>
        </div>
    </div>
</div>

</body>
</html>