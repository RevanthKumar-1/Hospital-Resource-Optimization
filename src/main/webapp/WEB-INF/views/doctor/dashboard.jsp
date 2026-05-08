<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hospital.model.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Doctor Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #fffdf5; min-height: 100vh; }
        .navbar { background: white; padding: 16px 40px; display: flex; justify-content: space-between; align-items: center; border-bottom: 3px solid #f5c518; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .navbar .logo { font-size: 22px; font-weight: 700; color: #333; }
        .navbar .logo span { color: #f5c518; }
        .nav-links { display: flex; gap: 8px; }
        .nav-link { padding: 8px 16px; border-radius: 8px; text-decoration: none; font-size: 14px; font-weight: 600; color: #666; transition: all 0.2s; }
        .nav-link:hover { background: #fff8dc; color: #b8860b; }
        .nav-link.active { background: #f5c518; color: #333; }
        .navbar-right { display: flex; align-items: center; gap: 20px; }
        .doctor-info { text-align: right; }
        .doctor-info .doc-name { font-weight: 600; color: #333; font-size: 15px; }
        .doctor-info .doc-dept { font-size: 12px; color: #888; }
        .logout-btn { background: #f5c518; color: #333; border: none; padding: 8px 18px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; text-decoration: none; }
        .logout-btn:hover { background: #e0b400; }
        .main { padding: 36px 40px; max-width: 1200px; margin: 0 auto; }
        .welcome-bar { margin-bottom: 28px; }
        .welcome-bar h1 { font-size: 26px; color: #333; font-weight: 700; }
        .welcome-bar p { color: #888; font-size: 14px; margin-top: 4px; }
        .profile-card { background: white; border-radius: 14px; padding: 28px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); margin-bottom: 24px; display: flex; align-items: center; gap: 28px; border-left: 6px solid #f5c518; }
        .profile-avatar { width: 72px; height: 72px; border-radius: 50%; background: #fff8dc; display: flex; align-items: center; justify-content: center; font-size: 32px; flex-shrink: 0; }
        .profile-details { flex: 1; }
        .profile-details h2 { font-size: 20px; font-weight: 700; color: #333; }
        .profile-tags { display: flex; gap: 8px; margin-top: 8px; flex-wrap: wrap; }
        .tag { background: #fff8dc; color: #b8860b; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .profile-meta { display: flex; gap: 28px; margin-top: 12px; flex-wrap: wrap; }
        .profile-meta .meta-item { font-size: 13px; color: #666; }
        .profile-meta .meta-item span { font-weight: 600; color: #333; }
        .stats-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 32px; }
        .stat-card { background: white; border-radius: 14px; padding: 24px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); border-top: 4px solid #f5c518; }
        .stat-card .icon { font-size: 28px; margin-bottom: 12px; }
        .stat-card .value { font-size: 34px; font-weight: 700; color: #333; }
        .stat-card .label { font-size: 13px; color: #888; margin-top: 4px; }
        .content-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
        .card { background: white; border-radius: 14px; padding: 24px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 14px; border-bottom: 2px solid #fff8dc; }
        .card-header h3 { font-size: 16px; font-weight: 700; color: #333; }
        .count-badge { background: #fff8dc; color: #b8860b; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; font-size: 11px; text-transform: uppercase; color: #aaa; padding: 8px 0; border-bottom: 1px solid #f5f5f5; }
        td { padding: 12px 0; font-size: 14px; color: #444; border-bottom: 1px solid #fafafa; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        .badge { padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; }
        .badge.yellow { background: #fff8dc; color: #b8860b; }
        .badge.green { background: #e8f5e9; color: #2e7d32; }
        .badge.red { background: #fdecea; color: #c62828; }
        .empty-state { text-align: center; padding: 32px 20px; color: #bbb; }
        .empty-state .empty-icon { font-size: 40px; margin-bottom: 10px; }
        .empty-state p { font-size: 14px; }
    </style>
</head>
<body>

<%
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    String name = (doctor != null) ? doctor.getName() : "Doctor";
    String dept = (doctor != null && doctor.getDepartment() != null) ? doctor.getDepartment() : "N/A";
    String spec = (doctor != null && doctor.getSpecialization() != null) ? doctor.getSpecialization() : "N/A";
    String qual = (doctor != null && doctor.getQualification() != null) ? doctor.getQualification() : "N/A";
    int exp = (doctor != null) ? doctor.getYearsOfExperience() : 0;
    String email = (doctor != null) ? doctor.getEmail() : "N/A";
    String phone = (doctor != null && doctor.getPhone() != null) ? doctor.getPhone() : "N/A";

    List<DoctorPatient> activeAssignments = (List<DoctorPatient>) request.getAttribute("activeAssignments");
    Map<Long, Patient> patientMap = (Map<Long, Patient>) request.getAttribute("patientMap");
    List<OtSchedule> todayOtSchedules = (List<OtSchedule>) request.getAttribute("todayOtSchedules");
    List<BedAdmission> bedAdmissions = (List<BedAdmission>) request.getAttribute("bedAdmissions");

    int totalPatients = (int) request.getAttribute("totalPatients");
    int todayAppointments = (int) request.getAttribute("todayAppointments");
    int activeBeds = (int) request.getAttribute("activeBeds");
%>

<!-- Navbar -->
<div class="navbar">
    <div class="logo">🏥 Hospital<span>System</span></div>
    <div class="nav-links">
        <a href="/doctor/dashboard" class="nav-link active">📊 Dashboard</a>
        <a href="/doctor/patients" class="nav-link">👥 My Patients</a>
    </div>
    <div class="navbar-right">
        <div class="doctor-info">
            <div class="doc-name">Dr. <%= name %></div>
            <div class="doc-dept"><%= dept %></div>
        </div>
        <a href="/logout" class="logout-btn">Logout</a>
    </div>
</div>

<!-- Main -->
<div class="main">
    <div class="welcome-bar">
        <h1>Good Day, Dr. <%= name %> 👋</h1>
        <p>Here's your overview for today.</p>
    </div>

    <!-- Profile -->
    <div class="profile-card">
        <div class="profile-avatar">👨‍⚕️</div>
        <div class="profile-details">
            <h2>Dr. <%= name %></h2>
            <div class="profile-tags">
                <span class="tag"><%= spec %></span>
                <span class="tag"><%= dept %></span>
                <span class="tag"><%= qual %></span>
            </div>
            <div class="profile-meta">
                <div class="meta-item">📧 <span><%= email %></span></div>
                <div class="meta-item">📞 <span><%= phone %></span></div>
                <div class="meta-item">🏅 <span><%= exp %> yrs experience</span></div>
            </div>
        </div>
    </div>

    <!-- Stats -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="icon">👥</div>
            <div class="value"><%= totalPatients %></div>
            <div class="label">Assigned Patients</div>
        </div>
        <div class="stat-card">
            <div class="icon">📅</div>
            <div class="value"><%= todayAppointments %></div>
            <div class="label">OT Procedures Today</div>
        </div>
        <div class="stat-card">
            <div class="icon">🛏️</div>
            <div class="value"><%= activeBeds %></div>
            <div class="label">Patients in Beds</div>
        </div>
    </div>

    <!-- Content Grid -->
    <div class="content-grid">

        <!-- My Patients -->
        <div class="card">
            <div class="card-header">
                <h3>👥 My Patients</h3>
                <span class="count-badge"><%= totalPatients %> patients</span>
            </div>
            <% if (activeAssignments == null || activeAssignments.isEmpty()) { %>
                <div class="empty-state"><div class="empty-icon">🙂</div><p>No patients assigned yet.</p></div>
            <% } else { %>
                <table>
                    <tr><th>Name</th><th>Age</th><th>Blood Group</th><th>Phone</th></tr>
                    <% for (DoctorPatient dp : activeAssignments) {
                        Patient p = patientMap != null ? patientMap.get(dp.getPatientId()) : null;
                        if (p != null) { %>
                    <tr>
                        <td><strong><%= p.getName() %></strong></td>
                        <td><%= p.getAge() %> yrs</td>
                        <td><span class="badge red"><%= p.getBloodGroup() %></span></td>
                        <td><%= p.getPhone() %></td>
                    </tr>
                    <% }} %>
                </table>
            <% } %>
        </div>

        <!-- Today's OT -->
        <div class="card">
            <div class="card-header">
                <h3>🔬 Today's Procedures</h3>
                <span class="count-badge"><%= todayAppointments %> scheduled</span>
            </div>
            <% if (todayOtSchedules == null || todayOtSchedules.isEmpty()) { %>
                <div class="empty-state"><div class="empty-icon">📭</div><p>No procedures today.</p></div>
            <% } else { %>
                <table>
                    <tr><th>Procedure</th><th>OT</th><th>Time</th><th>Status</th></tr>
                    <% for (OtSchedule os : todayOtSchedules) { %>
                    <tr>
                        <td><%= os.getProcedureName() %></td>
                        <td>OT-<%= os.getOtId() %></td>
                        <td><%= os.getStartTime() %>–<%= os.getEndTime() %></td>
                        <td><span class="badge yellow"><%= os.getStatus() %></span></td>
                    </tr>
                    <% } %>
                </table>
            <% } %>
        </div>

        <!-- Patients in Beds -->
        <div class="card">
            <div class="card-header">
                <h3>🛏️ Patients in Beds</h3>
                <span class="count-badge"><%= activeBeds %> active</span>
            </div>
            <% if (bedAdmissions == null || bedAdmissions.isEmpty()) { %>
                <div class="empty-state"><div class="empty-icon">🛏️</div><p>No patients in beds.</p></div>
            <% } else { %>
                <table>
                    <tr><th>Patient</th><th>Bed</th><th>Admitted</th><th>Discharge</th></tr>
                    <% for (BedAdmission ba : bedAdmissions) {
                        Patient p = patientMap != null ? patientMap.get(ba.getPatientId()) : null; %>
                    <tr>
                        <td><%= p != null ? p.getName() : "Unknown" %></td>
                        <td>Bed #<%= ba.getBedId() %></td>
                        <td><%= ba.getAdmittedDate() %></td>
                        <td><%= ba.getDischargeDate() %></td>
                    </tr>
                    <% } %>
                </table>
            <% } %>
        </div>

    </div>
</div>
</body>
</html>