<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hospital.model.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Patient - Fitness</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f4faf4; min-height: 100vh; }
        .navbar { background: white; padding: 16px 40px; display: flex; justify-content: space-between; align-items: center; border-bottom: 3px solid #4caf50; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .navbar .logo { font-size: 22px; font-weight: 700; color: #333; }
        .navbar .logo span { color: #4caf50; }
        .nav-links { display: flex; gap: 8px; }
        .nav-link { padding: 8px 16px; border-radius: 8px; text-decoration: none; font-size: 14px; font-weight: 600; color: #666; transition: all 0.2s; }
        .nav-link:hover { background: #e8f5e9; color: #2e7d32; }
        .nav-link.active { background: #4caf50; color: white; }
        .logout-btn { background: #4caf50; color: white; border: none; padding: 8px 18px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; text-decoration: none; }
        .logout-btn:hover { background: #388e3c; }
        .main { padding: 36px 40px; max-width: 1200px; margin: 0 auto; }
        .page-header { margin-bottom: 28px; }
        .page-header h1 { font-size: 26px; color: #333; font-weight: 700; }
        .page-header p { color: #888; font-size: 14px; margin-top: 4px; }
        .connect-section { background: white; border-radius: 14px; padding: 40px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); text-align: center; margin-bottom: 28px; border: 2px dashed #c8e6c9; }
        .connect-section h2 { font-size: 22px; color: #333; margin-bottom: 12px; }
        .connect-section p { color: #888; font-size: 14px; margin-bottom: 28px; line-height: 1.7; }
        .connect-btn { background: #4caf50; color: white; border: none; padding: 14px 36px; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-block; transition: background 0.2s; }
        .connect-btn:hover { background: #388e3c; }
        .connected-banner { background: #e8f5e9; border-radius: 12px; padding: 14px 20px; display: flex; align-items: center; gap: 12px; margin-bottom: 28px; border: 1px solid #a5d6a7; }
        .connected-banner .icon { font-size: 24px; }
        .connected-banner .info { flex: 1; }
        .connected-banner .title { font-size: 14px; font-weight: 700; color: #2e7d32; }
        .connected-banner .sub { font-size: 12px; color: #666; margin-top: 2px; }
        .reconnect-btn { background: white; color: #2e7d32; border: 1.5px solid #4caf50; padding: 7px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; text-decoration: none; }
        .stats-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 32px; }
        .stat-card { background: white; border-radius: 14px; padding: 22px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); border-top: 4px solid #4caf50; text-align: center; }
        .stat-card .icon { font-size: 28px; margin-bottom: 8px; }
        .stat-card .value { font-size: 28px; font-weight: 700; color: #333; }
        .stat-card .unit { font-size: 12px; color: #888; }
        .stat-card .label { font-size: 13px; color: #888; margin-top: 4px; }
        .stat-card .no-data { font-size: 13px; color: #bbb; font-style: italic; }
        .content-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
        .card { background: white; border-radius: 14px; padding: 24px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 14px; border-bottom: 2px solid #e8f5e9; }
        .card-header h3 { font-size: 16px; font-weight: 700; color: #333; }
        .goal-item { margin-bottom: 16px; }
        .goal-header { display: flex; justify-content: space-between; font-size: 14px; margin-bottom: 6px; }
        .progress-bar { height: 8px; background: #f0f0f0; border-radius: 4px; }
        .progress-fill { height: 100%; border-radius: 4px; background: #4caf50; }
        .alert { padding: 12px 16px; border-radius: 10px; font-size: 14px; margin-bottom: 20px; }
        .alert.success { background: #e8f5e9; color: #2e7d32; }
    </style>
</head>
<body>

<%
    // Updated attribute retrieval
    boolean isConnected = (request.getAttribute("isConnected") != null) ? (boolean) request.getAttribute("isConnected") : false;
    String authUrl = (String) request.getAttribute("authUrl");
    
    int steps = (request.getAttribute("steps") != null) ? (int) request.getAttribute("steps") : 0;
    int calories = (request.getAttribute("calories") != null) ? (int) request.getAttribute("calories") : 0;
    int heartRate = (request.getAttribute("heartRate") != null) ? (int) request.getAttribute("heartRate") : 0;

    int stepsPct = Math.min((steps * 100) / 10000, 100);
    int calPct = Math.min((calories * 100) / 500, 100);
%>

<div class="navbar">
    <div class="logo">🏥 Hospital<span>System</span></div>
    <div class="nav-links">
        <a href="/patient/dashboard" class="nav-link">📊 Dashboard</a>
        <a href="/patient/fitness" class="nav-link active">💪 Fitness</a>
    </div>
    <a href="/logout" class="logout-btn">Logout</a>
</div>

<div class="main">
    <div class="page-header">
        <h1>💪 Fitness & Health Tracker</h1>
        <p>Sync your Google Fit account to share data with your medical team.</p>
    </div>

    <% if ("true".equals(request.getParameter("connected"))) { %>
        <div class="alert success">✅ Google Fit connected successfully!</div>
    <% } %>

    <% if (!isConnected) { %>
        <div class="connect-section">
            <div class="icon" style="font-size: 50px; margin-bottom: 20px;">🟢</div>
            <h2>Connect Google Fit</h2>
            <p>Link your Google account to automatically sync your daily activity.</p>
            <% if (authUrl != null) { %>
                <a href="<%= authUrl %>" class="connect-btn">🔗 Connect Google Fit</a>
            <% } else { %>
                <p style="color:#e53935;">⚠️ Authentication Service Unavailable.</p>
            <% } %>
        </div>
    <% } else { %>
        
        <div class="connected-banner">
            <div class="icon">✅</div>
            <div class="info">
                <div class="title">Google Fit Connected</div>
                <div class="sub">Your activity data is currently syncing.</div>
            </div>
            <% if (authUrl != null) { %>
                <a href="<%= authUrl %>" class="reconnect-btn">🔄 Reconnect</a>
            <% } %>
        </div>

        <div class="stats-row">
            <div class="stat-card">
                <div class="icon">👟</div>
                <div class="value"><%= String.format("%,d", steps) %></div>
                <div class="unit">steps today</div>
                <div class="label">Daily Steps</div>
            </div>
            <div class="stat-card">
                <div class="icon">🔥</div>
                <div class="value"><%= calories %></div>
                <div class="unit">kcal burned</div>
                <div class="label">Calories</div>
            </div>
            <div class="stat-card">
                <div class="icon">❤️</div>
                <div class="value"><%= heartRate %></div>
                <div class="unit">bpm (current)</div>
                <div class="label">Heart Rate</div>
            </div>
        </div>

        <div class="content-grid">
            <div class="card">
                <div class="card-header">
                    <h3>🎯 Daily Goals</h3>
                </div>
                <div class="goal-item">
                    <div class="goal-header">
                        <span>👟 Steps</span>
                        <span><%= String.format("%,d", steps) %> / 10,000</span>
                    </div>
                    <div class="progress-bar"><div class="progress-fill" style="width:<%= stepsPct %>%"></div></div>
                </div>
                <div class="goal-item">
                    <div class="goal-header">
                        <span>🔥 Calories</span>
                        <span><%= calories %> / 500 kcal</span>
                    </div>
                    <div class="progress-bar"><div class="progress-fill" style="width:<%= calPct %>%; background:#ff7043;"></div></div>
                </div>
            </div>
        </div>
    <% } %>
</div>
</body>
</html>