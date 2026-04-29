<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Labs</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #fdf4f4; }

        .sidebar {
            width: 240px; background: white; height: 100vh;
            position: fixed; top: 0; left: 0;
            border-right: 3px solid #e53935;
            box-shadow: 2px 0 8px rgba(0,0,0,0.06);
            display: flex; flex-direction: column;
        }
        .sidebar-logo { padding: 24px 20px; font-size: 20px; font-weight: 700; color: #333; border-bottom: 1px solid #f5f5f5; }
        .sidebar-logo span { color: #e53935; }
        .sidebar-menu { flex: 1; padding: 16px 0; }
        .menu-label { font-size: 10px; text-transform: uppercase; color: #bbb; padding: 8px 20px; font-weight: 600; letter-spacing: 1px; }
        .sidebar-menu a { display: flex; align-items: center; gap: 12px; color: #555; text-decoration: none; padding: 12px 20px; font-size: 14px; transition: all 0.2s; border-left: 3px solid transparent; }
        .sidebar-menu a:hover { background: #fdecea; color: #e53935; border-left-color: #e53935; }
        .sidebar-menu a.active { background: #fdecea; color: #e53935; border-left-color: #e53935; font-weight: 600; }
        .sidebar-bottom { padding: 16px 20px; border-top: 1px solid #f5f5f5; }
        .logout-btn { display: flex; align-items: center; gap: 10px; color: #e53935; text-decoration: none; font-size: 14px; font-weight: 600; padding: 10px 14px; border-radius: 8px; transition: background 0.2s; }
        .logout-btn:hover { background: #fdecea; }

        .navbar { margin-left: 240px; background: white; padding: 16px 36px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #f0f0f0; box-shadow: 0 2px 8px rgba(0,0,0,0.04); position: sticky; top: 0; z-index: 10; }
        .navbar h2 { font-size: 20px; color: #333; font-weight: 700; }

        .main { margin-left: 240px; padding: 32px 36px; }

        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 28px; }
        .stat-card { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); border-top: 4px solid #e53935; text-align: center; }
        .stat-card .icon { font-size: 28px; margin-bottom: 8px; }
        .stat-card .value { font-size: 28px; font-weight: 700; color: #333; }
        .stat-card .label { font-size: 13px; color: #888; margin-top: 4px; }

        .content-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
        .card { background: white; border-radius: 14px; padding: 24px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); margin-bottom: 24px; }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 14px; border-bottom: 2px solid #fdecea; }
        .card-header h3 { font-size: 16px; font-weight: 700; color: #333; }

        .count-badge { background: #fdecea; color: #e53935; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }

        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; font-size: 11px; text-transform: uppercase; color: #aaa; padding: 8px 12px; border-bottom: 1px solid #f5f5f5; }
        td { padding: 14px 12px; font-size: 14px; color: #444; border-bottom: 1px solid #fafafa; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #fffafa; }

        .badge { padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; }
        .badge.green { background: #e8f5e9; color: #2e7d32; }
        .badge.red { background: #fdecea; color: #c62828; }
        .badge.orange { background: #fff3e0; color: #e65100; }
        .badge.blue { background: #e3f2fd; color: #1565c0; }
        .badge.grey { background: #f5f5f5; color: #757575; }

        .schedule-card {
            border: 1px solid #f5f5f5; border-radius: 10px;
            padding: 16px; margin-bottom: 12px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .schedule-card:last-child { margin-bottom: 0; }
        .schedule-info .title { font-size: 14px; font-weight: 600; color: #333; }
        .schedule-info .sub { font-size: 12px; color: #888; margin-top: 4px; }

        .note { background: #e3f2fd; color: #1565c0; padding: 14px 18px; border-radius: 10px; font-size: 14px; margin-bottom: 24px; }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-logo">🏥 Hospital<span>System</span></div>
    <div class="sidebar-menu">
        <div class="menu-label">Overview</div>
        <a href="/admin/dashboard">📊 Dashboard</a>
        <div class="menu-label">Management</div>
        <a href="/admin/resources">🏥 Resources</a>
        <a href="/admin/doctors">👨‍⚕️ Doctors</a>
        <a href="/admin/patients">👥 Patients</a>
        <a href="/admin/schedule">📅 Schedule</a>
        <a href="/admin/labs" class="active">🔬 Labs</a>
        <a href="/admin/external">🌐 External Sources</a>
    </div>
    <div class="sidebar-bottom">
        <a href="/logout" class="logout-btn">🚪 Logout</a>
    </div>
</div>

<!-- Navbar -->
<div class="navbar">
    <h2>🔬 Lab Management</h2>
</div>

<!-- Main -->
<div class="main">

    <div class="note">
        ℹ️ This page will be connected to lab data in a future update.
        Below is a preview of the lab management interface.
    </div>

    <!-- Stats -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="icon">🔬</div>
            <div class="value">4</div>
            <div class="label">Total Labs</div>
        </div>
        <div class="stat-card">
            <div class="icon">✅</div>
            <div class="value">3</div>
            <div class="label">Available</div>
        </div>
        <div class="stat-card">
            <div class="icon">🔄</div>
            <div class="value">2</div>
            <div class="label">Tests Today</div>
        </div>
        <div class="stat-card">
            <div class="icon">⏳</div>
            <div class="value">1</div>
            <div class="label">Pending Results</div>
        </div>
    </div>

    <div class="content-grid">

        <!-- Lab Units -->
        <div class="card">
            <div class="card-header">
                <h3>🔬 Lab Units</h3>
                <span class="count-badge">4 labs</span>
            </div>
            <table>
                <tr>
                    <th>Lab</th>
                    <th>Type</th>
                    <th>Status</th>
                    <th>Capacity</th>
                </tr>
                <tr>
                    <td><strong>Lab 1</strong></td>
                    <td><span class="badge blue">Pathology</span></td>
                    <td><span class="badge green">Available</span></td>
                    <td>10 tests/day</td>
                </tr>
                <tr>
                    <td><strong>Lab 2</strong></td>
                    <td><span class="badge blue">Radiology</span></td>
                    <td><span class="badge green">Available</span></td>
                    <td>8 tests/day</td>
                </tr>
                <tr>
                    <td><strong>Lab 3</strong></td>
                    <td><span class="badge blue">Microbiology</span></td>
                    <td><span class="badge orange">In Use</span></td>
                    <td>12 tests/day</td>
                </tr>
                <tr>
                    <td><strong>Lab 4</strong></td>
                    <td><span class="badge blue">Biochemistry</span></td>
                    <td><span class="badge green">Available</span></td>
                    <td>15 tests/day</td>
                </tr>
            </table>
        </div>

        <!-- Today's Schedule -->
        <div class="card">
            <div class="card-header">
                <h3>📅 Today's Lab Schedule</h3>
                <span class="count-badge">2 scheduled</span>
            </div>
            <div class="schedule-card">
                <div class="schedule-info">
                    <div class="title">Blood Culture Test</div>
                    <div class="sub">Lab 1 · Pathology · 10:00 AM · John Doe</div>
                </div>
                <span class="badge orange">Scheduled</span>
            </div>
            <div class="schedule-card">
                <div class="schedule-info">
                    <div class="title">X-Ray Chest</div>
                    <div class="sub">Lab 2 · Radiology · 02:00 PM · Mary Jane</div>
                </div>
                <span class="badge green">Completed</span>
            </div>
        </div>

        <!-- Pending Results -->
        <div class="card">
            <div class="card-header">
                <h3>⏳ Pending Results</h3>
                <span class="count-badge">1 pending</span>
            </div>
            <div class="schedule-card">
                <div class="schedule-info">
                    <div class="title">CBC Test — Robert Singh</div>
                    <div class="sub">Lab 3 · Microbiology · Collected yesterday</div>
                </div>
                <span class="badge orange">Pending</span>
            </div>
        </div>

        <!-- Lab Types -->
        <div class="card">
            <div class="card-header">
                <h3>🧪 Common Tests Offered</h3>
            </div>
            <table>
                <tr><th>Test Name</th><th>Lab</th><th>Avg Duration</th></tr>
                <tr><td>Complete Blood Count (CBC)</td><td>Pathology</td><td>2 hrs</td></tr>
                <tr><td>Blood Culture</td><td>Microbiology</td><td>24-48 hrs</td></tr>
                <tr><td>X-Ray</td><td>Radiology</td><td>30 min</td></tr>
                <tr><td>MRI Scan</td><td>Radiology</td><td>1-2 hrs</td></tr>
                <tr><td>Liver Function Test</td><td>Biochemistry</td><td>4 hrs</td></tr>
                <tr><td>Urine Analysis</td><td>Pathology</td><td>1 hr</td></tr>
            </table>
        </div>

    </div>
</div>

</body>
</html>