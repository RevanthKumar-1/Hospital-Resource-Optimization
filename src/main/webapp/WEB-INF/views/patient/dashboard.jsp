<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hospital.model.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Dashboard</title>
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
        .navbar-right { display: flex; align-items: center; gap: 20px; }
        .patient-info { text-align: right; }
        .patient-info .pat-name { font-weight: 600; color: #333; font-size: 15px; }
        .patient-info .pat-sub { font-size: 12px; color: #888; }
        .logout-btn { background: #4caf50; color: white; border: none; padding: 8px 18px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; text-decoration: none; }
        .logout-btn:hover { background: #388e3c; }
        .main { padding: 36px 40px; max-width: 1200px; margin: 0 auto; }
        .welcome-bar { margin-bottom: 28px; }
        .welcome-bar h1 { font-size: 26px; color: #333; font-weight: 700; }
        .welcome-bar p { color: #888; font-size: 14px; margin-top: 4px; }
        .profile-card { background: white; border-radius: 14px; padding: 28px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); margin-bottom: 24px; display: flex; align-items: center; gap: 28px; border-left: 6px solid #4caf50; }
        .profile-avatar { width: 72px; height: 72px; border-radius: 50%; background: #e8f5e9; display: flex; align-items: center; justify-content: center; font-size: 32px; flex-shrink: 0; }
        .profile-details { flex: 1; }
        .profile-details h2 { font-size: 20px; font-weight: 700; color: #333; }
        .profile-tags { display: flex; gap: 8px; margin-top: 8px; flex-wrap: wrap; }
        .tag { background: #e8f5e9; color: #2e7d32; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .profile-meta { display: flex; gap: 28px; margin-top: 12px; flex-wrap: wrap; }
        .profile-meta .meta-item { font-size: 13px; color: #666; }
        .profile-meta .meta-item span { font-weight: 600; color: #333; }
        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 32px; }
        .stat-card { background: white; border-radius: 14px; padding: 24px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); border-top: 4px solid #4caf50; }
        .stat-card .icon { font-size: 28px; margin-bottom: 12px; }
        .stat-card .value { font-size: 18px; font-weight: 700; color: #333; }
        .stat-card .label { font-size: 13px; color: #888; margin-top: 4px; }
        .content-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
        .card { background: white; border-radius: 14px; padding: 24px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 14px; border-bottom: 2px solid #e8f5e9; }
        .card-header h3 { font-size: 16px; font-weight: 700; color: #333; }
        .info-row { display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid #f5f5f5; font-size: 14px; }
        .info-row:last-child { border-bottom: none; }
        .info-label { color: #888; font-size: 13px; }
        .info-value { font-weight: 600; color: #333; }
        .badge { padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; }
        .badge.green { background: #e8f5e9; color: #2e7d32; }
        .badge.red { background: #fdecea; color: #c62828; }
        .badge.orange { background: #fff3e0; color: #e65100; }
        .badge.grey { background: #f5f5f5; color: #757575; }
        .timeline { position: relative; padding-left: 24px; }
        .timeline-item { position: relative; padding-bottom: 20px; }
        .timeline-item::before { content: ''; position: absolute; left: -18px; top: 6px; width: 10px; height: 10px; border-radius: 50%; background: #4caf50; }
        .timeline-item::after { content: ''; position: absolute; left: -14px; top: 16px; width: 2px; height: calc(100% - 10px); background: #e0e0e0; }
        .timeline-item:last-child::after { display: none; }
        .timeline-item .time { font-size: 12px; color: #aaa; }
        .timeline-item .event { font-size: 14px; color: #333; font-weight: 500; margin-top: 2px; }
        .timeline-item .desc { font-size: 13px; color: #888; margin-top: 2px; }
        .empty-state { text-align: center; padding: 32px 20px; color: #bbb; }
        .empty-state .empty-icon { font-size: 40px; margin-bottom: 10px; }
        .empty-state p { font-size: 14px; }
    </style>
</head>
<body>

<%
    Patient patient = (Patient) request.getAttribute("patient");
    String name = (patient != null) ? patient.getName() : "Patient";
    String email = (patient != null) ? patient.getEmail() : "N/A";
    String phone = (patient != null && patient.getPhone() != null) ? patient.getPhone() : "N/A";
    String gender = (patient != null && patient.getGender() != null) ? patient.getGender() : "N/A";
    String bloodGroup = (patient != null && patient.getBloodGroup() != null) ? patient.getBloodGroup() : "N/A";
    String address = (patient != null && patient.getAddress() != null) ? patient.getAddress() : "N/A";
    String emergencyContact = (patient != null && patient.getEmergencyContact() != null) ? patient.getEmergencyContact() : "N/A";
    String medicalHistory = (patient != null && patient.getMedicalHistory() != null) ? patient.getMedicalHistory() : "None recorded";
    int age = (patient != null) ? patient.getAge() : 0;

    Doctor assignedDoctor = (Doctor) request.getAttribute("assignedDoctor");
    BedAdmission bedAdmission = (BedAdmission) request.getAttribute("bedAdmission");
    Bed assignedBed = (Bed) request.getAttribute("assignedBed");
    IcuAdmission icuAdmission = (IcuAdmission) request.getAttribute("icuAdmission");
    Icu assignedIcu = (Icu) request.getAttribute("assignedIcu");
    List<OtSchedule> upcomingOtSchedules = (List<OtSchedule>) request.getAttribute("upcomingOtSchedules");
    OtSchedule nextOt = (upcomingOtSchedules != null && !upcomingOtSchedules.isEmpty()) ? upcomingOtSchedules.get(0) : null;
%>

<!-- Navbar -->
<div class="navbar">
    <div class="logo">🏥 Hospital<span>System</span></div>
    <div class="nav-links">
        <a href="/patient/dashboard" class="nav-link active">📊 Dashboard</a>
        <a href="/patient/fitness" class="nav-link">💪 Fitness</a>
    </div>
    <div class="navbar-right">
        <div class="patient-info">
            <div class="pat-name"><%= name %></div>
            <div class="pat-sub">Patient Portal</div>
        </div>
        <a href="/logout" class="logout-btn">Logout</a>
    </div>
</div>

<!-- Main -->
<div class="main">
    <div class="welcome-bar">
        <h1>Welcome, <%= name %> 👋</h1>
        <p>Here's your health overview and hospital status.</p>
    </div>

    <!-- Profile -->
    <div class="profile-card">
        <div class="profile-avatar">🧑‍🤝‍🧑</div>
        <div class="profile-details">
            <h2><%= name %></h2>
            <div class="profile-tags">
                <span class="tag"><%= gender %></span>
                <span class="tag">Age: <%= age %></span>
                <span class="tag">Blood: <%= bloodGroup %></span>
                <% if (assignedDoctor != null) { %>
                    <span class="tag">Dr. <%= assignedDoctor.getName() %></span>
                <% } %>
            </div>
            <div class="profile-meta">
                <div class="meta-item">📧 <span><%= email %></span></div>
                <div class="meta-item">📞 <span><%= phone %></span></div>
                <div class="meta-item">🚨 Emergency: <span><%= emergencyContact %></span></div>
            </div>
        </div>
    </div>

    <!-- Stats -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="icon">👨‍⚕️</div>
            <div class="value"><%= assignedDoctor != null ? "Dr. " + assignedDoctor.getName() : "Not Assigned" %></div>
            <div class="label">Assigned Doctor</div>
        </div>
        <div class="stat-card">
            <div class="icon">🛏️</div>
            <div class="value"><%= assignedBed != null ? assignedBed.getBedNumber() : "Not Assigned" %></div>
            <div class="label">Assigned Bed</div>
        </div>
        <div class="stat-card">
            <div class="icon">🏥</div>
            <div class="value"><%= assignedIcu != null ? "ICU #" + assignedIcu.getId() : "Not Required" %></div>
            <div class="label">ICU Status</div>
        </div>
        <div class="stat-card">
            <div class="icon">🔬</div>
            <div class="value"><%= nextOt != null ? nextOt.getScheduleDate().toString() : "None" %></div>
            <div class="label">Next Procedure</div>
        </div>
    </div>

    <!-- Content Grid -->
    <div class="content-grid">

        <!-- Personal Details -->
        <div class="card">
            <div class="card-header"><h3>👤 Personal Details</h3></div>
            <div class="info-row"><span class="info-label">Full Name</span><span class="info-value"><%= name %></span></div>
            <div class="info-row"><span class="info-label">Age</span><span class="info-value"><%= age %> years</span></div>
            <div class="info-row"><span class="info-label">Gender</span><span class="info-value"><%= gender %></span></div>
            <div class="info-row"><span class="info-label">Blood Group</span><span class="info-value"><%= bloodGroup %></span></div>
            <div class="info-row"><span class="info-label">Phone</span><span class="info-value"><%= phone %></span></div>
            <div class="info-row"><span class="info-label">Address</span><span class="info-value"><%= address %></span></div>
            <div class="info-row"><span class="info-label">Emergency Contact</span><span class="info-value"><%= emergencyContact %></span></div>
        </div>

        <!-- Allocated Resources -->
        <div class="card">
            <div class="card-header"><h3>🏥 Allocated Resources</h3></div>
            <div class="info-row">
                <span class="info-label">Assigned Doctor</span>
                <% if (assignedDoctor != null) { %><span class="badge green">Dr. <%= assignedDoctor.getName() %></span>
                <% } else { %><span class="badge grey">Not Assigned</span><% } %>
            </div>
            <div class="info-row">
                <span class="info-label">Department</span>
                <span class="info-value"><%= assignedDoctor != null ? assignedDoctor.getDepartment() : "N/A" %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Bed</span>
                <% if (assignedBed != null) { %><span class="badge green"><%= assignedBed.getBedNumber() %> — <%= assignedBed.getWard() %></span>
                <% } else { %><span class="badge grey">Not Assigned</span><% } %>
            </div>
            <div class="info-row">
                <span class="info-label">ICU</span>
                <% if (assignedIcu != null) { %><span class="badge red">ICU #<%= assignedIcu.getId() %></span>
                <% } else { %><span class="badge grey">Not Required</span><% } %>
            </div>
            <div class="info-row">
                <span class="info-label">Admitted Date</span>
                <span class="info-value"><%= bedAdmission != null ? bedAdmission.getAdmittedDate() : "N/A" %></span>
            </div>
            <div class="info-row">
                <span class="info-label">Expected Discharge</span>
                <span class="info-value"><%= bedAdmission != null ? bedAdmission.getDischargeDate() : "N/A" %></span>
            </div>
        </div>

        <!-- Medical History -->
        <div class="card">
            <div class="card-header"><h3>📋 Medical History</h3></div>
            <% if ("None recorded".equals(medicalHistory)) { %>
                <div class="empty-state"><div class="empty-icon">📋</div><p>No medical history recorded.</p></div>
            <% } else { %>
                <p style="font-size:14px; color:#555; line-height:1.7;"><%= medicalHistory %></p>
            <% } %>
        </div>

        <!-- Upcoming Procedures -->
        <div class="card">
            <div class="card-header"><h3>🔬 Upcoming Procedures</h3></div>
            <% if (upcomingOtSchedules == null || upcomingOtSchedules.isEmpty()) { %>
                <div class="empty-state"><div class="empty-icon">📭</div><p>No upcoming procedures.</p></div>
            <% } else { %>
                <% for (OtSchedule os : upcomingOtSchedules) { %>
                <div class="info-row">
                    <div>
                        <div style="font-weight:600; font-size:14px"><%= os.getProcedureName() %></div>
                        <div style="font-size:12px; color:#888">OT-<%= os.getOtId() %> · <%= os.getScheduleDate() %> · <%= os.getStartTime() %>–<%= os.getEndTime() %></div>
                    </div>
                    <span class="badge orange">Scheduled</span>
                </div>
                <% } %>
            <% } %>
        </div>

        <!-- Treatment Journey -->
        <div class="card" style="grid-column: 1 / -1;">
            <div class="card-header"><h3>📋 Treatment Journey</h3></div>
            <% if (bedAdmission == null && icuAdmission == null && (upcomingOtSchedules == null || upcomingOtSchedules.isEmpty())) { %>
                <div class="empty-state"><div class="empty-icon">🗺️</div><p>Your treatment journey will appear here once admitted.</p></div>
            <% } else { %>
                <div class="timeline">
                    <% if (bedAdmission != null) { %>
                        <div class="timeline-item">
                            <div class="time"><%= bedAdmission.getAdmittedDate() %></div>
                            <div class="event">✅ Admitted to Hospital</div>
                            <div class="desc"><%= assignedBed != null ? "Bed " + assignedBed.getBedNumber() + " — " + assignedBed.getWard() : "Bed assigned" %><% if (assignedDoctor != null) { %> · Dr. <%= assignedDoctor.getName() %><% } %></div>
                        </div>
                    <% } %>
                    <% if (icuAdmission != null) { %>
                        <div class="timeline-item">
                            <div class="time"><%= icuAdmission.getAdmittedDate() %></div>
                            <div class="event">🏥 Admitted to ICU</div>
                            <div class="desc">ICU #<%= icuAdmission.getIcuId() %></div>
                        </div>
                    <% } %>
                    <% if (upcomingOtSchedules != null) { for (OtSchedule os : upcomingOtSchedules) { %>
                        <div class="timeline-item">
                            <div class="time"><%= os.getScheduleDate() %> · <%= os.getStartTime() %></div>
                            <div class="event">⏳ <%= os.getProcedureName() %></div>
                            <div class="desc">OT-<%= os.getOtId() %> · Scheduled</div>
                        </div>
                    <% }} %>
                    <% if (bedAdmission != null) { %>
                        <div class="timeline-item">
                            <div class="time"><%= bedAdmission.getDischargeDate() %></div>
                            <div class="event">🔵 Expected Discharge</div>
                            <div class="desc">Planned discharge date</div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>

    </div>
</div>
</body>
</html>