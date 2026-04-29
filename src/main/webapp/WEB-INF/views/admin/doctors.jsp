<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hospital.model.Doctor" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Doctors</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body { font-family: 'Segoe UI', sans-serif; background: #fdf4f4; }

        .sidebar {
            width: 240px;
            background: white;
            height: 100vh;
            position: fixed;
            top: 0; left: 0;
            border-right: 3px solid #e53935;
            box-shadow: 2px 0 8px rgba(0,0,0,0.06);
            display: flex;
            flex-direction: column;
        }

        .sidebar-logo {
            padding: 24px 20px;
            font-size: 20px;
            font-weight: 700;
            color: #333;
            border-bottom: 1px solid #f5f5f5;
        }

        .sidebar-logo span { color: #e53935; }

        .sidebar-menu { flex: 1; padding: 16px 0; }

        .menu-label {
            font-size: 10px;
            text-transform: uppercase;
            color: #bbb;
            padding: 8px 20px;
            font-weight: 600;
            letter-spacing: 1px;
        }

        .sidebar-menu a {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #555;
            text-decoration: none;
            padding: 12px 20px;
            font-size: 14px;
            transition: all 0.2s;
            border-left: 3px solid transparent;
        }

        .sidebar-menu a:hover {
            background: #fdecea;
            color: #e53935;
            border-left-color: #e53935;
        }

        .sidebar-menu a.active {
            background: #fdecea;
            color: #e53935;
            border-left-color: #e53935;
            font-weight: 600;
        }

        .sidebar-bottom {
            padding: 16px 20px;
            border-top: 1px solid #f5f5f5;
        }

        .logout-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #e53935;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            padding: 10px 14px;
            border-radius: 8px;
            transition: background 0.2s;
        }

        .logout-btn:hover { background: #fdecea; }

        .navbar {
            margin-left: 240px;
            background: white;
            padding: 16px 36px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #f0f0f0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .navbar h2 { font-size: 20px; color: #333; font-weight: 700; }

        .main { margin-left: 240px; padding: 32px 36px; }

        /* Alert */
        .alert {
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .alert.success { background: #e8f5e9; color: #2e7d32; }
        .alert.error { background: #fdecea; color: #c62828; }

        /* Stats */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 28px;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border-top: 4px solid #e53935;
            text-align: center;
        }

        .stat-card .value { font-size: 28px; font-weight: 700; color: #333; }
        .stat-card .label { font-size: 13px; color: #888; margin-top: 4px; }

        /* Add Form */
        .add-form {
            background: white;
            border-radius: 14px;
            padding: 28px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            margin-bottom: 28px;
        }

        .add-form h3 {
            font-size: 16px;
            font-weight: 700;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #fdecea;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
        }

        .form-group { display: flex; flex-direction: column; gap: 6px; }

        label {
            font-size: 12px;
            font-weight: 600;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        input, select {
            padding: 10px 12px;
            border: 1.5px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
            transition: border 0.2s;
            background: #fafafa;
        }

        input:focus, select:focus {
            border-color: #e53935;
            background: white;
        }

        .btn {
            padding: 10px 22px;
            border-radius: 8px;
            border: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-primary { background: #e53935; color: white; }
        .btn-primary:hover { background: #c62828; }
        .btn-danger { background: #fdecea; color: #e53935; }
        .btn-danger:hover { background: #e53935; color: white; }
        .btn-sm { padding: 6px 14px; font-size: 12px; }

        /* Doctors Table */
        .card {
            background: white;
            border-radius: 14px;
            padding: 24px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 14px;
            border-bottom: 2px solid #fdecea;
        }

        .card-header h3 { font-size: 16px; font-weight: 700; color: #333; }

        .count-badge {
            background: #fdecea;
            color: #e53935;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        table { width: 100%; border-collapse: collapse; }

        th {
            text-align: left;
            font-size: 11px;
            text-transform: uppercase;
            color: #aaa;
            padding: 8px 12px;
            border-bottom: 1px solid #f5f5f5;
        }

        td {
            padding: 14px 12px;
            font-size: 14px;
            color: #444;
            border-bottom: 1px solid #fafafa;
            vertical-align: middle;
        }

        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #fffafa; }

        .doctor-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #fdecea;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            margin-right: 8px;
            vertical-align: middle;
        }

        .badge {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }

        .badge.blue { background: #e3f2fd; color: #1565c0; }
        .badge.green { background: #e8f5e9; color: #2e7d32; }
        .badge.purple { background: #f3e5f5; color: #6a1b9a; }

        .empty-state {
            text-align: center;
            padding: 48px 20px;
            color: #bbb;
        }

        .empty-state .icon { font-size: 48px; margin-bottom: 12px; }
        .empty-state p { font-size: 14px; }

        .inline-form { display: inline; }
    </style>
</head>
<body>

<%
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    long totalDoctors = (long) request.getAttribute("totalDoctors");
    String successMsg = request.getParameter("success");
    String errorMsg = request.getParameter("error");
%>

<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-logo">🏥 Hospital<span>System</span></div>
    <div class="sidebar-menu">
        <div class="menu-label">Overview</div>
        <a href="/admin/dashboard">📊 Dashboard</a>
        <div class="menu-label">Management</div>
        <a href="/admin/resources">🏥 Resources</a>
        <a href="/admin/doctors" class="active">👨‍⚕️ Doctors</a>
        <a href="/admin/patients">👥 Patients</a>
        <a href="/admin/schedule">📅 Schedule</a>
    </div>
    <div class="sidebar-bottom">
        <a href="/logout" class="logout-btn">🚪 Logout</a>
    </div>
</div>

<!-- Navbar -->
<div class="navbar">
    <h2>👨‍⚕️ Doctor Management</h2>
</div>

<!-- Main -->
<div class="main">

    <% if (successMsg != null) { %>
        <div class="alert success">✅ <%= successMsg %></div>
    <% } %>
    <% if ("emailexists".equals(errorMsg)) { %>
        <div class="alert error">⚠️ This email is already registered for another doctor.</div>
    <% } %>

    <!-- Stats -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="value"><%= totalDoctors %></div>
            <div class="label">Total Doctors</div>
        </div>
        <div class="stat-card">
            <div class="value"><%= totalDoctors %></div>
            <div class="label">Active Doctors</div>
        </div>
        <div class="stat-card">
            <div class="value">0</div>
            <div class="label">Assigned Patients</div>
        </div>
    </div>

    <!-- Add Doctor Form -->
    <div class="add-form">
        <h3>➕ Register New Doctor</h3>
        <form action="/admin/doctors/add" method="post">

            <div class="form-grid">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="name" placeholder="Dr. John Smith" required />
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" placeholder="doctor@hospital.com" required />
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="Set a password" required />
                </div>
                <div class="form-group">
                    <label>Phone</label>
                    <input type="tel" name="phone" placeholder="Phone number" required />
                </div>
                <div class="form-group">
                    <label>Department</label>
                    <select name="department" required>
                        <option value="" disabled selected>Select department</option>
                        <option value="General Medicine">General Medicine</option>
                        <option value="Orthopedics">Orthopedics</option>
                        <option value="Cardiology">Cardiology</option>
                        <option value="Neurology">Neurology</option>
                        <option value="Oncology">Oncology</option>
                        <option value="Pediatrics">Pediatrics</option>
                        <option value="Gynecology">Gynecology</option>
                        <option value="Emergency">Emergency</option>
                        <option value="Radiology">Radiology</option>
                        <option value="Anesthesiology">Anesthesiology</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Specialization</label>
                    <input type="text" name="specialization" placeholder="e.g. Cardiac Surgeon" required />
                </div>
                <div class="form-group">
                    <label>Qualification</label>
                    <input type="text" name="qualification" placeholder="e.g. MBBS, MD" required />
                </div>
                <div class="form-group">
                    <label>Practice Start Date</label>
                    <input type="date" name="practiceStartDate" required />
                </div>
            </div>

            <button type="submit" class="btn btn-primary">Register Doctor</button>
        </form>
    </div>

    <!-- Doctors Table -->
    <div class="card">
        <div class="card-header">
            <h3>All Doctors</h3>
            <span class="count-badge"><%= totalDoctors %> doctors</span>
        </div>

        <% if (doctors == null || doctors.isEmpty()) { %>
            <div class="empty-state">
                <div class="icon">👨‍⚕️</div>
                <p>No doctors registered yet. Add your first doctor above!</p>
            </div>
        <% } else { %>
            <table>
                <tr>
                    <th>Doctor</th>
                    <th>Department</th>
                    <th>Specialization</th>
                    <th>Qualification</th>
                    <th>Experience</th>
                    <th>Phone</th>
                    <th>Actions</th>
                </tr>
                <% for (Doctor doctor : doctors) { %>
                <tr>
                    <td>
                        <span class="doctor-avatar">👨‍⚕️</span>
                        <strong>Dr. <%= doctor.getName() %></strong>
                        <br/>
                        <small style="color:#888; margin-left:44px"><%= doctor.getEmail() %></small>
                    </td>
                    <td><span class="badge blue"><%= doctor.getDepartment() %></span></td>
                    <td><%= doctor.getSpecialization() %></td>
                    <td><span class="badge purple"><%= doctor.getQualification() %></span></td>
                    <td><span class="badge green"><%= doctor.getYearsOfExperience() %> yrs</span></td>
                    <td><%= doctor.getPhone() %></td>
                    <td>
                        <form action="/admin/doctors/delete" method="post" class="inline-form"
                              onsubmit="return confirm('Remove Dr. <%= doctor.getName() %>?')">
                            <input type="hidden" name="id" value="<%= doctor.getId() %>" />
                            <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </table>
        <% } %>
    </div>

</div>

</body>
</html>