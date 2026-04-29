<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Patient - Fitness</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f4faf4; min-height: 100vh; }

        .navbar {
            background: white; padding: 16px 40px;
            display: flex; justify-content: space-between; align-items: center;
            border-bottom: 3px solid #4caf50;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .navbar .logo { font-size: 22px; font-weight: 700; color: #333; }
        .navbar .logo span { color: #4caf50; }
        .nav-links { display: flex; gap: 8px; }
        .nav-link {
            padding: 8px 16px; border-radius: 8px; text-decoration: none;
            font-size: 14px; font-weight: 600; color: #666; transition: all 0.2s;
        }
        .nav-link:hover { background: #e8f5e9; color: #2e7d32; }
        .nav-link.active { background: #4caf50; color: white; }
        .logout-btn {
            background: #4caf50; color: white; border: none;
            padding: 8px 18px; border-radius: 8px; font-size: 14px;
            font-weight: 600; cursor: pointer; text-decoration: none;
        }
        .logout-btn:hover { background: #388e3c; }

        .main { padding: 36px 40px; max-width: 1200px; margin: 0 auto; }
        .page-header { margin-bottom: 28px; }
        .page-header h1 { font-size: 26px; color: #333; font-weight: 700; }
        .page-header p { color: #888; font-size: 14px; margin-top: 4px; }

        .note { background: #e3f2fd; color: #1565c0; padding: 14px 18px; border-radius: 10px; font-size: 14px; margin-bottom: 28px; }

        /* Connected Apps */
        .apps-row {
            display: flex; gap: 16px; margin-bottom: 32px; flex-wrap: wrap;
        }
        .app-card {
            background: white; border-radius: 14px; padding: 16px 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            display: flex; align-items: center; gap: 12px;
            border: 2px solid #e0e0e0; cursor: pointer; transition: all 0.2s;
        }
        .app-card.connected { border-color: #4caf50; }
        .app-card:hover { transform: translateY(-2px); }
        .app-icon { font-size: 28px; }
        .app-info .app-name { font-size: 14px; font-weight: 700; color: #333; }
        .app-info .app-status { font-size: 12px; color: #888; margin-top: 2px; }
        .connected-badge {
            background: #e8f5e9; color: #2e7d32;
            padding: 3px 8px; border-radius: 12px;
            font-size: 11px; font-weight: 600; margin-left: auto;
        }

        /* Stats */
        .stats-row {
            display: grid; grid-template-columns: repeat(4, 1fr);
            gap: 20px; margin-bottom: 32px;
        }
        .stat-card {
            background: white; border-radius: 14px; padding: 22px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            border-top: 4px solid #4caf50; text-align: center;
        }
        .stat-card .icon { font-size: 28px; margin-bottom: 8px; }
        .stat-card .value { font-size: 28px; font-weight: 700; color: #333; }
        .stat-card .unit { font-size: 13px; color: #888; }
        .stat-card .label { font-size: 13px; color: #888; margin-top: 4px; }
        .stat-card .change { font-size: 12px; margin-top: 4px; }
        .stat-card .change.up { color: #2e7d32; }
        .stat-card .change.down { color: #c62828; }

        /* Content Grid */
        .content-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
        .card { background: white; border-radius: 14px; padding: 24px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); margin-bottom: 0; }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 14px; border-bottom: 2px solid #e8f5e9; }
        .card-header h3 { font-size: 16px; font-weight: 700; color: #333; }
        .card-header span { font-size: 12px; color: #888; }

        /* Activity Timeline */
        .activity-item {
            display: flex; align-items: center; gap: 14px;
            padding: 12px 0; border-bottom: 1px solid #fafafa;
        }
        .activity-item:last-child { border-bottom: none; }
        .activity-icon {
            width: 40px; height: 40px; border-radius: 50%;
            background: #e8f5e9; display: flex; align-items: center;
            justify-content: center; font-size: 18px; flex-shrink: 0;
        }
        .activity-info { flex: 1; }
        .activity-name { font-size: 14px; font-weight: 600; color: #333; }
        .activity-detail { font-size: 12px; color: #888; margin-top: 2px; }
        .activity-value { font-size: 14px; font-weight: 700; color: #2e7d32; }

        /* Progress Bars */
        .goal-item { margin-bottom: 16px; }
        .goal-item:last-child { margin-bottom: 0; }
        .goal-header { display: flex; justify-content: space-between; font-size: 14px; margin-bottom: 6px; }
        .goal-label { color: #555; font-weight: 500; }
        .goal-value { color: #333; font-weight: 700; }
        .progress-bar { height: 8px; background: #f0f0f0; border-radius: 4px; }
        .progress-fill { height: 100%; border-radius: 4px; background: #4caf50; }

        /* Vitals */
        .vital-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .vital-item {
            background: #f4faf4; border-radius: 10px; padding: 14px;
            text-align: center;
        }
        .vital-icon { font-size: 22px; margin-bottom: 6px; }
        .vital-value { font-size: 20px; font-weight: 700; color: #333; }
        .vital-unit { font-size: 11px; color: #888; }
        .vital-label { font-size: 12px; color: #888; margin-top: 4px; }
        .vital-status { font-size: 11px; font-weight: 600; margin-top: 4px; }
        .vital-status.normal { color: #2e7d32; }
        .vital-status.warning { color: #e65100; }

        /* Sleep */
        .sleep-bar {
            display: flex; gap: 4px; margin-bottom: 8px;
        }
        .sleep-segment {
            height: 32px; border-radius: 4px; display: flex;
            align-items: center; justify-content: center;
            font-size: 10px; color: white; font-weight: 600;
        }
    </style>
</head>
<body>

<%
    String patientName = (String) session.getAttribute("userName");
    if (patientName == null) patientName = "Patient";
%>

<!-- Navbar -->
<div class="navbar">
    <div class="logo">🏥 Hospital<span>System</span></div>
    <div class="nav-links">
        <a href="/patient/dashboard" class="nav-link">📊 Dashboard</a>
        <a href="/patient/fitness" class="nav-link active">💪 Fitness</a>
    </div>
    <a href="/logout" class="logout-btn">Logout</a>
</div>

<!-- Main -->
<div class="main">

    <div class="page-header">
        <h1>💪 Fitness & Health Tracker</h1>
        <p>Your health data synced from connected fitness apps.</p>
    </div>

    <div class="note">
        ℹ️ This page displays sample fitness data. Live sync with fitness apps
        like Google Fit, Apple Health, and Fitbit will be available in a future update.
    </div>

    <!-- Connected Apps -->
    <div class="apps-row">
        <div class="app-card connected">
            <div class="app-icon">🍎</div>
            <div class="app-info">
                <div class="app-name">Apple Health</div>
                <div class="app-status">Last synced: Today 8:00 AM</div>
            </div>
            <span class="connected-badge">✅ Connected</span>
        </div>
        <div class="app-card connected">
            <div class="app-icon">⌚</div>
            <div class="app-info">
                <div class="app-name">Fitbit</div>
                <div class="app-status">Last synced: Today 7:45 AM</div>
            </div>
            <span class="connected-badge">✅ Connected</span>
        </div>
        <div class="app-card">
            <div class="app-icon">🟢</div>
            <div class="app-info">
                <div class="app-name">Google Fit</div>
                <div class="app-status">Not connected</div>
            </div>
        </div>
        <div class="app-card">
            <div class="app-icon">🏃</div>
            <div class="app-info">
                <div class="app-name">Strava</div>
                <div class="app-status">Not connected</div>
            </div>
        </div>
    </div>

    <!-- Today's Stats -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="icon">👟</div>
            <div class="value">6,842</div>
            <div class="unit">steps</div>
            <div class="label">Today's Steps</div>
            <div class="change up">↑ 12% vs yesterday</div>
        </div>
        <div class="stat-card">
            <div class="icon">🔥</div>
            <div class="value">312</div>
            <div class="unit">kcal</div>
            <div class="label">Calories Burned</div>
            <div class="change up">↑ 8% vs yesterday</div>
        </div>
        <div class="stat-card">
            <div class="icon">❤️</div>
            <div class="value">72</div>
            <div class="unit">bpm</div>
            <div class="label">Resting Heart Rate</div>
            <div class="change down">↓ Normal range</div>
        </div>
        <div class="stat-card">
            <div class="icon">😴</div>
            <div class="value">7.2</div>
            <div class="unit">hours</div>
            <div class="label">Last Night Sleep</div>
            <div class="change up">↑ Good quality</div>
        </div>
    </div>

    <!-- Content Grid -->
    <div class="content-grid">

        <!-- Vitals -->
        <div class="card">
            <div class="card-header">
                <h3>❤️ Current Vitals</h3>
                <span>Updated: Today 8:00 AM</span>
            </div>
            <div class="vital-grid">
                <div class="vital-item">
                    <div class="vital-icon">❤️</div>
                    <div class="vital-value">72 <span class="vital-unit">bpm</span></div>
                    <div class="vital-label">Heart Rate</div>
                    <div class="vital-status normal">Normal</div>
                </div>
                <div class="vital-item">
                    <div class="vital-icon">🩺</div>
                    <div class="vital-value">118/76 <span class="vital-unit">mmHg</span></div>
                    <div class="vital-label">Blood Pressure</div>
                    <div class="vital-status normal">Normal</div>
                </div>
                <div class="vital-item">
                    <div class="vital-icon">🌡️</div>
                    <div class="vital-value">36.8 <span class="vital-unit">°C</span></div>
                    <div class="vital-label">Temperature</div>
                    <div class="vital-status normal">Normal</div>
                </div>
                <div class="vital-item">
                    <div class="vital-icon">💨</div>
                    <div class="vital-value">98 <span class="vital-unit">%</span></div>
                    <div class="vital-label">SpO2 (Oxygen)</div>
                    <div class="vital-status normal">Normal</div>
                </div>
                <div class="vital-item">
                    <div class="vital-icon">🩸</div>
                    <div class="vital-value">98 <span class="vital-unit">mg/dL</span></div>
                    <div class="vital-label">Blood Sugar</div>
                    <div class="vital-status normal">Normal</div>
                </div>
                <div class="vital-item">
                    <div class="vital-icon">⚖️</div>
                    <div class="vital-value">68 <span class="vital-unit">kg</span></div>
                    <div class="vital-label">Weight</div>
                    <div class="vital-status normal">Healthy BMI</div>
                </div>
            </div>
        </div>

        <!-- Daily Goals -->
        <div class="card">
            <div class="card-header">
                <h3>🎯 Daily Goals</h3>
                <span>Today's Progress</span>
            </div>
            <div class="goal-item">
                <div class="goal-header">
                    <span class="goal-label">👟 Steps</span>
                    <span class="goal-value">6,842 / 10,000</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 68%"></div>
                </div>
            </div>
            <div class="goal-item">
                <div class="goal-header">
                    <span class="goal-label">🔥 Calories</span>
                    <span class="goal-value">312 / 500 kcal</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 62%; background: #ff7043;"></div>
                </div>
            </div>
            <div class="goal-item">
                <div class="goal-header">
                    <span class="goal-label">💧 Water Intake</span>
                    <span class="goal-value">1.2L / 2.5L</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 48%; background: #1565c0;"></div>
                </div>
            </div>
            <div class="goal-item">
                <div class="goal-header">
                    <span class="goal-label">🏃 Active Minutes</span>
                    <span class="goal-value">28 / 45 min</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 62%"></div>
                </div>
            </div>
            <div class="goal-item">
                <div class="goal-header">
                    <span class="goal-label">😴 Sleep</span>
                    <span class="goal-value">7.2 / 8 hrs</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 90%; background: #7b1fa2;"></div>
                </div>
            </div>
        </div>

        <!-- Recent Activity -->
        <div class="card">
            <div class="card-header">
                <h3>🏃 Recent Activity</h3>
                <span>Last 7 days</span>
            </div>
            <div class="activity-item">
                <div class="activity-icon">🚶</div>
                <div class="activity-info">
                    <div class="activity-name">Morning Walk</div>
                    <div class="activity-detail">Today · 6:30 AM · 35 min</div>
                </div>
                <div class="activity-value">2.8 km</div>
            </div>
            <div class="activity-item">
                <div class="activity-icon">🧘</div>
                <div class="activity-info">
                    <div class="activity-name">Yoga</div>
                    <div class="activity-detail">Yesterday · 7:00 AM · 30 min</div>
                </div>
                <div class="activity-value">120 kcal</div>
            </div>
            <div class="activity-item">
                <div class="activity-icon">🏊</div>
                <div class="activity-info">
                    <div class="activity-name">Swimming</div>
                    <div class="activity-detail">2 days ago · 45 min</div>
                </div>
                <div class="activity-value">320 kcal</div>
            </div>
            <div class="activity-item">
                <div class="activity-icon">🚴</div>
                <div class="activity-info">
                    <div class="activity-name">Cycling</div>
                    <div class="activity-detail">3 days ago · 40 min</div>
                </div>
                <div class="activity-value">8.5 km</div>
            </div>
            <div class="activity-item">
                <div class="activity-icon">🚶</div>
                <div class="activity-info">
                    <div class="activity-name">Evening Walk</div>
                    <div class="activity-detail">4 days ago · 25 min</div>
                </div>
                <div class="activity-value">1.9 km</div>
            </div>
        </div>

        <!-- Sleep Analysis -->
        <div class="card">
            <div class="card-header">
                <h3>😴 Sleep Analysis</h3>
                <span>Last night</span>
            </div>

            <div style="margin-bottom:20px">
                <div style="font-size:13px; color:#888; margin-bottom:8px">Sleep Stages (10:30 PM – 6:00 AM)</div>
                <div class="sleep-bar">
                    <div class="sleep-segment" style="width:8%; background:#7b1fa2">Awake</div>
                    <div class="sleep-segment" style="width:22%; background:#5c6bc0">Light</div>
                    <div class="sleep-segment" style="width:40%; background:#1565c0">Deep</div>
                    <div class="sleep-segment" style="width:30%; background:#0288d1">REM</div>
                </div>
                <div style="display:flex; gap:16px; margin-top:6px">
                    <span style="font-size:11px; color:#888">🟣 Awake: 35 min</span>
                    <span style="font-size:11px; color:#888">🔵 Light: 1h 50m</span>
                    <span style="font-size:11px; color:#888">🔷 Deep: 2h 55m</span>
                    <span style="font-size:11px; color:#888">🩵 REM: 2h 0m</span>
                </div>
            </div>

            <div class="goal-item">
                <div class="goal-header">
                    <span class="goal-label">Sleep Score</span>
                    <span class="goal-value" style="color:#2e7d32">82 / 100 — Good</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width:82%; background:#7b1fa2"></div>
                </div>
            </div>

            <div style="margin-top:16px; display:grid; grid-template-columns:1fr 1fr 1fr; gap:12px; text-align:center">
                <div>
                    <div style="font-size:18px; font-weight:700; color:#333">10:32</div>
                    <div style="font-size:12px; color:#888">Bedtime</div>
                </div>
                <div>
                    <div style="font-size:18px; font-weight:700; color:#333">7.2 hrs</div>
                    <div style="font-size:12px; color:#888">Duration</div>
                </div>
                <div>
                    <div style="font-size:18px; font-weight:700; color:#333">06:01</div>
                    <div style="font-size:12px; color:#888">Wake up</div>
                </div>
            </div>
        </div>

    </div>
</div>

</body>
</html>