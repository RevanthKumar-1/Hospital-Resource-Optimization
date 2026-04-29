<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hospital.model.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
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
        .sidebar-logo {
            padding: 24px 20px; font-size: 20px;
            font-weight: 700; color: #333;
            border-bottom: 1px solid #f5f5f5;
        }
        .sidebar-logo span { color: #e53935; }
        .sidebar-admin {
            padding: 16px 20px; background: #fdecea;
            display: flex; align-items: center; gap: 12px;
            border-bottom: 1px solid #f5f5f5;
        }
        .admin-avatar {
            width: 40px; height: 40px; border-radius: 50%;
            background: #e53935; display: flex;
            align-items: center; justify-content: center;
            font-size: 18px; flex-shrink: 0;
        }
        .admin-name { font-size: 14px; font-weight: 600; color: #333; }
        .admin-role { font-size: 11px; color: #e53935; font-weight: 600; text-transform: uppercase; }
        .sidebar-menu { flex: 1; padding: 16px 0; }
        .menu-label {
            font-size: 10px; text-transform: uppercase; color: #bbb;
            padding: 8px 20px; font-weight: 600; letter-spacing: 1px;
        }
        .sidebar-menu a {
            display: flex; align-items: center; gap: 12px; color: #555;
            text-decoration: none; padding: 12px 20px; font-size: 14px;
            transition: all 0.2s; border-left: 3px solid transparent;
        }
        .sidebar-menu a:hover { background: #fdecea; color: #e53935; border-left-color: #e53935; }
        .sidebar-menu a.active { background: #fdecea; color: #e53935; border-left-color: #e53935; font-weight: 600; }
        .sidebar-bottom { padding: 16px 20px; border-top: 1px solid #f5f5f5; }
        .logout-btn {
            display: flex; align-items: center; gap: 10px; color: #e53935;
            text-decoration: none; font-size: 14px; font-weight: 600;
            padding: 10px 14px; border-radius: 8px; transition: background 0.2s;
        }
        .logout-btn:hover { background: #fdecea; }

        .navbar {
            margin-left: 240px; background: white; padding: 16px 36px;
            display: flex; justify-content: space-between; align-items: center;
            border-bottom: 1px solid #f0f0f0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            position: sticky; top: 0; z-index: 10;
        }
        .navbar h2 { font-size: 20px; color: #333; font-weight: 700; }
        .navbar .date { font-size: 13px; color: #888; }

        .main { margin-left: 240px; padding: 32px 36px; }
        .welcome-bar { margin-bottom: 28px; }
        .welcome-bar h1 { font-size: 24px; color: #333; font-weight: 700; }
        .welcome-bar p { color: #888; font-size: 14px; margin-top: 4px; }

        .stats-row {
            display: grid; grid-template-columns: repeat(4, 1fr);
            gap: 20px; margin-bottom: 28px;
        }
        .stat-card {
            background: white; border-radius: 14px; padding: 22px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            border-top: 4px solid #e53935; transition: transform 0.2s;
        }
        .stat-card:hover { transform: translateY(-2px); }
        .stat-card .icon { font-size: 26px; margin-bottom: 10px; }
        .stat-card .value { font-size: 32px; font-weight: 700; color: #333; }
        .stat-card .label { font-size: 13px; color: #888; margin-top: 4px; }
        .stat-card .sub { font-size: 11px; color: #bbb; margin-top: 4px; }

        .content-grid {
            display: grid; grid-template-columns: 1fr 1fr; gap: 24px;
        }
        .card {
            background: white; border-radius: 14px; padding: 24px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
        }
        .card-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 20px; padding-bottom: 14px; border-bottom: 2px solid #fdecea;
        }
        .card-header h3 { font-size: 16px; font-weight: 700; color: #333; }
        .count-badge {
            background: #fdecea; color: #e53935;
            padding: 4px 12px; border-radius: 20px;
            font-size: 12px; font-weight: 600;
        }

        .resource-row {
            display: flex; justify-content: space-between; align-items: center;
            padding: 10px 0; border-bottom: 1px solid #fafafa; font-size: 14px;
        }
        .resource-row:last-child { border-bottom: none; }
        .resource-label { color: #555; }

        .progress-bar {
            height: 6px; background: #f5f5f5;
            border-radius: 4px; margin-top: 4px;
        }
        .progress-fill { height: 100%; border-radius: 4px; }

        table { width: 100%; border-collapse: collapse; }
        th {
            text-align: left; font-size: 11px; text-transform: uppercase;
            color: #aaa; padding: 8px 0; border-bottom: 1px solid #f5f5f5;
        }
        td {
            padding: 10px 0; font-size: 14px; color: #444;
            border-bottom: 1px solid #fafafa; vertical-align: middle;
        }
        tr:last-child td { border-bottom: none; }

        .badge {
            padding: 4px 10px; border-radius: 20px;
            font-size: 11px; font-weight: 600;
        }
        .badge.green { background: #e8f5e9; color: #2e7d32; }
        .badge.red { background: #fdecea; color: #c62828; }
        .badge.orange { background: #fff3e0; color: #e65100; }
        .badge.blue { background: #e3f2fd; color: #1565c0; }
        .badge.grey { background: #f5f5f5; color: #757575; }

        .alert-item {
            padding: 12px 14px; border-radius: 10px;
            font-size: 13px; margin-bottom: 8px;
        }
        .alert-item.warning { background: #fff3e0; color: #e65100; }
        .alert-item.danger { background: #fdecea; color: #c62828; }
        .alert-item.success { background: #e8f5e9; color: #2e7d32; }
        .alert-item.info { background: #e3f2fd; color: #1565c0; }

        .empty-state { text-align: center; padding: 28px; color: #bbb; }
        .empty-state .icon { font-size: 36px; margin-bottom: 8px; }
        .empty-state p { font-size: 14px; }
    </style>
</head>
<body>

<%
    Admin admin = (Admin) request.getAttribute("admin");
    String name = (admin != null) ? admin.getName() : "Admin";

    long totalBeds = (long) request.getAttribute("totalBeds");
    long availableBeds = (long) request.getAttribute("availableBeds");
    long occupiedBeds = (long) request.getAttribute("occupiedBeds");
    long totalIcu = (long) request.getAttribute("totalIcu");
    long availableIcu = (long) request.getAttribute("availableIcu");
    long occupiedIcu = (long) request.getAttribute("occupiedIcu");
    long totalOt = (long) request.getAttribute("totalOt");
    long availableOt = (long) request.getAttribute("availableOt");
    long totalOxygen = (long) request.getAttribute("totalOxygen");
    long totalDoctors = (long) request.getAttribute("totalDoctors");
    long totalPatients = (long) request.getAttribute("totalPatients");

    List<Doctor> recentDoctors = (List<Doctor>) request.getAttribute("recentDoctors");
    List<Patient> recentPatients = (List<Patient>) request.getAttribute("recentPatients");
    List<OtSchedule> todayOtSchedules = (List<OtSchedule>) request.getAttribute("todayOtSchedules");
    List<BedAdmission> activeBedAdmissions = (List<BedAdmission>) request.getAttribute("activeBedAdmissions");
    List<BloodBank> bloodBanks = (List<BloodBank>) request.getAttribute("bloodBanks");
    Map<Long, String> patientNameMap = (Map<Long, String>) request.getAttribute("patientNameMap");
    Map<Long, String> doctorNameMap = (Map<Long, String>) request.getAttribute("doctorNameMap");

    // Utilization percentages
    int bedPct = totalBeds > 0 ? (int)((occupiedBeds * 100) / totalBeds) : 0;
    int icuPct = totalIcu > 0 ? (int)((occupiedIcu * 100) / totalIcu) : 0;
    int otPct = totalOt > 0 ? (int)(((totalOt - availableOt) * 100) / totalOt) : 0;

    java.time.format.DateTimeFormatter fmt =
        java.time.format.DateTimeFormatter.ofPattern("EEEE, MMMM dd yyyy");
    String today = java.time.LocalDate.now().format(fmt);
%>

<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-logo">🏥 Hospital<span>System</span></div>
    <div class="sidebar-admin">
        <div class="admin-avatar">👤</div>
        <div>
            <div class="admin-name"><%= name %></div>
            <div class="admin-role">Administrator</div>
        </div>
    </div>
    <div class="sidebar-menu">
        <div class="menu-label">Overview</div>
        <a href="/admin/dashboard" class="active">📊 Dashboard</a>
        <div class="menu-label">Management</div>
        <a href="/admin/resources">🏥 Resources</a>
        <a href="/admin/doctors">👨‍⚕️ Doctors</a>
        <a href="/admin/patients">👥 Patients</a>
        <a href="/admin/schedule">📅 Schedule</a>
    </div>
    <div class="sidebar-bottom">
        <a href="/logout" class="logout-btn">🚪 Logout</a>
    </div>
</div>

<!-- Navbar -->
<div class="navbar">
    <h2>Dashboard Overview</h2>
    <span class="date">📅 <%= today %></span>
</div>

<!-- Main -->
<div class="main">

    <div class="welcome-bar">
        <h1>Welcome back, <%= name %> 👋</h1>
        <p>Here's what's happening in the hospital today.</p>
    </div>

    <!-- Stats Row 1 - Resources -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="icon">🛏️</div>
            <div class="value"><%= totalBeds %></div>
            <div class="label">Total Beds</div>
            <div class="sub"><%= availableBeds %> Available · <%= occupiedBeds %> Occupied</div>
        </div>
        <div class="stat-card">
            <div class="icon">🏥</div>
            <div class="value"><%= totalIcu %></div>
            <div class="label">ICU Units</div>
            <div class="sub"><%= availableIcu %> Available · <%= occupiedIcu %> Occupied</div>
        </div>
        <div class="stat-card">
            <div class="icon">🔬</div>
            <div class="value"><%= totalOt %></div>
            <div class="label">Operation Theatres</div>
            <div class="sub"><%= availableOt %> Available</div>
        </div>
        <div class="stat-card">
            <div class="icon">🫁</div>
            <div class="value"><%= totalOxygen %></div>
            <div class="label">Oxygen Tanks</div>
            <div class="sub">Total tanks</div>
        </div>
    </div>

    <!-- Stats Row 2 - People -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="icon">👨‍⚕️</div>
            <div class="value"><%= totalDoctors %></div>
            <div class="label">Doctors</div>
            <div class="sub">Active staff</div>
        </div>
        <div class="stat-card">
            <div class="icon">👥</div>
            <div class="value"><%= totalPatients %></div>
            <div class="label">Patients</div>
            <div class="sub">Registered patients</div>
        </div>
        <div class="stat-card">
            <div class="icon">🛏️</div>
            <div class="value"><%= activeBedAdmissions != null ? activeBedAdmissions.size() : 0 %></div>
            <div class="label">Active Admissions</div>
            <div class="sub">Currently admitted</div>
        </div>
        <div class="stat-card">
            <div class="icon">📅</div>
            <div class="value"><%= todayOtSchedules != null ? todayOtSchedules.size() : 0 %></div>
            <div class="label">OT Today</div>
            <div class="sub">Procedures scheduled</div>
        </div>
    </div>

    <!-- Content Grid -->
    <div class="content-grid">

        <!-- Resource Utilization -->
        <div class="card">
            <div class="card-header">
                <h3>📊 Resource Utilization</h3>
            </div>
            <div class="resource-row">
                <span class="resource-label">General Beds</span>
                <span class="badge <%= bedPct > 80 ? "red" : bedPct > 60 ? "orange" : "green" %>">
                    <%= bedPct %>%
                </span>
            </div>
            <div class="progress-bar">
                <div class="progress-fill"
                     style="width:<%= bedPct %>%;
                     background:<%= bedPct > 80 ? "#c62828" : bedPct > 60 ? "#e65100" : "#2e7d32" %>">
                </div>
            </div>

            <div class="resource-row" style="margin-top:12px">
                <span class="resource-label">ICU Units</span>
                <span class="badge <%= icuPct > 80 ? "red" : icuPct > 60 ? "orange" : "green" %>">
                    <%= icuPct %>%
                </span>
            </div>
            <div class="progress-bar">
                <div class="progress-fill"
                     style="width:<%= icuPct %>%;
                     background:<%= icuPct > 80 ? "#c62828" : icuPct > 60 ? "#e65100" : "#2e7d32" %>">
                </div>
            </div>

            <div class="resource-row" style="margin-top:12px">
                <span class="resource-label">Operation Theatres</span>
                <span class="badge <%= otPct > 80 ? "red" : otPct > 60 ? "orange" : "green" %>">
                    <%= otPct %>%
                </span>
            </div>
            <div class="progress-bar">
                <div class="progress-fill"
                     style="width:<%= otPct %>%;
                     background:<%= otPct > 80 ? "#c62828" : otPct > 60 ? "#e65100" : "#2e7d32" %>">
                </div>
            </div>
        </div>

        <!-- AI Recommendations -->
        <div class="card">
            <div class="card-header">
                <h3>🤖 AI Recommendations</h3>
            </div>
            <% if (bedPct > 80) { %>
                <div class="alert-item danger">
                    🚨 Bed utilization critical (<%= bedPct %>%) — consider emergency capacity measures
                </div>
            <% } else if (bedPct > 60) { %>
                <div class="alert-item warning">
                    ⚠️ Bed utilization high (<%= bedPct %>%) — monitor closely
                </div>
            <% } else { %>
                <div class="alert-item success">
                    ✅ Bed utilization is optimal (<%= bedPct %>%)
                </div>
            <% } %>

            <% if (icuPct > 80) { %>
                <div class="alert-item danger">
                    🚨 ICU utilization critical (<%= icuPct %>%) — alert medical team immediately
                </div>
            <% } else if (icuPct > 60) { %>
                <div class="alert-item warning">
                    ⚠️ ICU utilization high (<%= icuPct %>%) — prepare additional units
                </div>
            <% } else { %>
                <div class="alert-item success">
                    ✅ ICU utilization is optimal (<%= icuPct %>%)
                </div>
            <% } %>

            <% if (totalOt == 0) { %>
                <div class="alert-item info">ℹ️ No OTs configured — add OTs in Resources</div>
            <% } else if (availableOt == 0) { %>
                <div class="alert-item danger">🚨 All OTs are occupied or under maintenance</div>
            <% } else { %>
                <div class="alert-item success">✅ <%= availableOt %> OT(s) available for scheduling</div>
            <% } %>

            <%-- Blood bank alerts --%>
            <% if (bloodBanks != null) {
                for (BloodBank b : bloodBanks) {
                    if (b.getDaysUntilExpiry() <= 3 && !b.isExpired()) { %>
                        <div class="alert-item warning">
                            ⚠️ <%= b.getComponent() %> (<%= b.getBloodGroup() %>) expires in <%= b.getDaysUntilExpiry() %> day(s)
                        </div>
                    <% } else if (b.isExpired()) { %>
                        <div class="alert-item danger">
                            🚨 <%= b.getComponent() %> (<%= b.getBloodGroup() %>) has expired — remove immediately
                        </div>
                <% }}} %>
        </div>

        <!-- Today's OT Schedule -->
        <div class="card">
            <div class="card-header">
                <h3>📅 Today's OT Schedule</h3>
                <span class="count-badge">
                    <%= todayOtSchedules != null ? todayOtSchedules.size() : 0 %> scheduled
                </span>
            </div>
            <% if (todayOtSchedules == null || todayOtSchedules.isEmpty()) { %>
                <div class="empty-state">
                    <div class="icon">📭</div>
                    <p>No OT procedures scheduled for today.</p>
                </div>
            <% } else { %>
                <table>
                    <tr>
                        <th>Patient</th>
                        <th>Doctor</th>
                        <th>OT</th>
                        <th>Time</th>
                        <th>Status</th>
                    </tr>
                    <% for (OtSchedule os : todayOtSchedules) { %>
                    <tr>
                        <td><%= patientNameMap != null ? patientNameMap.getOrDefault(os.getPatientId(), "Unknown") : "Unknown" %></td>
                        <td>Dr. <%= doctorNameMap != null ? doctorNameMap.getOrDefault(os.getDoctorId(), "Unknown") : "Unknown" %></td>
                        <td>OT-<%= os.getOtId() %></td>
                        <td><%= os.getStartTime() %>–<%= os.getEndTime() %></td>
                        <td><span class="badge orange"><%= os.getStatus() %></span></td>
                    </tr>
                    <% } %>
                </table>
            <% } %>
        </div>

        <!-- Active Bed Admissions -->
        <div class="card">
            <div class="card-header">
                <h3>🛏️ Active Admissions</h3>
                <span class="count-badge">
                    <%= activeBedAdmissions != null ? activeBedAdmissions.size() : 0 %> admitted
                </span>
            </div>
            <% if (activeBedAdmissions == null || activeBedAdmissions.isEmpty()) { %>
                <div class="empty-state">
                    <div class="icon">🛏️</div>
                    <p>No active bed admissions.</p>
                </div>
            <% } else { %>
                <table>
                    <tr>
                        <th>Patient</th>
                        <th>Doctor</th>
                        <th>Bed</th>
                        <th>Discharge</th>
                    </tr>
                    <% for (BedAdmission ba : activeBedAdmissions) { %>
                    <tr>
                        <td><%= patientNameMap != null ? patientNameMap.getOrDefault(ba.getPatientId(), "Unknown") : "Unknown" %></td>
                        <td>Dr. <%= doctorNameMap != null ? doctorNameMap.getOrDefault(ba.getDoctorId(), "Unknown") : "Unknown" %></td>
                        <td>Bed #<%= ba.getBedId() %></td>
                        <td><%= ba.getDischargeDate() %></td>
                    </tr>
                    <% } %>
                </table>
            <% } %>
        </div>

        <!-- Recent Doctors -->
        <div class="card">
            <div class="card-header">
                <h3>👨‍⚕️ Recent Doctors</h3>
                <span class="count-badge"><%= totalDoctors %> total</span>
            </div>
            <% if (recentDoctors == null || recentDoctors.isEmpty()) { %>
                <div class="empty-state">
                    <div class="icon">👨‍⚕️</div>
                    <p>No doctors registered yet.</p>
                </div>
            <% } else { %>
                <table>
                    <tr><th>Name</th><th>Department</th><th>Experience</th></tr>
                    <% for (Doctor d : recentDoctors) { %>
                    <tr>
                        <td><strong>Dr. <%= d.getName() %></strong></td>
                        <td><span class="badge blue"><%= d.getDepartment() %></span></td>
                        <td><%= d.getYearsOfExperience() %> yrs</td>
                    </tr>
                    <% } %>
                </table>
            <% } %>
        </div>

        <!-- Recent Patients -->
        <div class="card">
            <div class="card-header">
                <h3>👥 Recent Patients</h3>
                <span class="count-badge"><%= totalPatients %> total</span>
            </div>
            <% if (recentPatients == null || recentPatients.isEmpty()) { %>
                <div class="empty-state">
                    <div class="icon">👥</div>
                    <p>No patients registered yet.</p>
                </div>
            <% } else { %>
                <table>
                    <tr><th>Name</th><th>Blood Group</th><th>Age</th></tr>
                    <% for (Patient p : recentPatients) { %>
                    <tr>
                        <td><strong><%= p.getName() %></strong></td>
                        <td><span class="badge red"><%= p.getBloodGroup() %></span></td>
                        <td><%= p.getAge() %> yrs</td>
                    </tr>
                    <% } %>
                </table>
            <% } %>
        </div>

    </div>
</div>

</body>
</html>