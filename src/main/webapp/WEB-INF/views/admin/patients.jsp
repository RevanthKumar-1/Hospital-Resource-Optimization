<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hospital.model.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Patients</title>
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
        .sidebar-menu { flex: 1; padding: 16px 0; }
        .menu-label {
            font-size: 10px; text-transform: uppercase;
            color: #bbb; padding: 8px 20px;
            font-weight: 600; letter-spacing: 1px;
        }
        .sidebar-menu a {
            display: flex; align-items: center; gap: 12px;
            color: #555; text-decoration: none;
            padding: 12px 20px; font-size: 14px;
            transition: all 0.2s;
            border-left: 3px solid transparent;
        }
        .sidebar-menu a:hover { background: #fdecea; color: #e53935; border-left-color: #e53935; }
        .sidebar-menu a.active { background: #fdecea; color: #e53935; border-left-color: #e53935; font-weight: 600; }
        .sidebar-bottom { padding: 16px 20px; border-top: 1px solid #f5f5f5; }
        .logout-btn {
            display: flex; align-items: center; gap: 10px;
            color: #e53935; text-decoration: none;
            font-size: 14px; font-weight: 600;
            padding: 10px 14px; border-radius: 8px; transition: background 0.2s;
        }
        .logout-btn:hover { background: #fdecea; }

        .navbar {
            margin-left: 240px; background: white;
            padding: 16px 36px;
            display: flex; justify-content: space-between; align-items: center;
            border-bottom: 1px solid #f0f0f0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            position: sticky; top: 0; z-index: 10;
        }
        .navbar h2 { font-size: 20px; color: #333; font-weight: 700; }

        .main { margin-left: 240px; padding: 32px 36px; }

        .alert {
            padding: 12px 16px; border-radius: 10px;
            font-size: 14px; margin-bottom: 20px;
        }
        .alert.success { background: #e8f5e9; color: #2e7d32; }
        .alert.error { background: #fdecea; color: #c62828; }

        .stats-row {
            display: grid; grid-template-columns: repeat(3, 1fr);
            gap: 16px; margin-bottom: 28px;
        }
        .stat-card {
            background: white; border-radius: 12px; padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border-top: 4px solid #e53935; text-align: center;
        }
        .stat-card .value { font-size: 28px; font-weight: 700; color: #333; }
        .stat-card .label { font-size: 13px; color: #888; margin-top: 4px; }

        .card {
            background: white; border-radius: 14px; padding: 24px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06); margin-bottom: 24px;
        }
        .card-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 20px; padding-bottom: 14px;
            border-bottom: 2px solid #fdecea;
        }
        .card-header h3 { font-size: 16px; font-weight: 700; color: #333; }

        .count-badge {
            background: #fdecea; color: #e53935;
            padding: 4px 12px; border-radius: 20px;
            font-size: 12px; font-weight: 600;
        }

        table { width: 100%; border-collapse: collapse; }
        th {
            text-align: left; font-size: 11px;
            text-transform: uppercase; color: #aaa;
            padding: 8px 12px; border-bottom: 1px solid #f5f5f5;
        }
        td {
            padding: 14px 12px; font-size: 14px;
            color: #444; border-bottom: 1px solid #fafafa;
            vertical-align: middle;
        }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #fffafa; }

        .badge {
            padding: 4px 10px; border-radius: 20px;
            font-size: 11px; font-weight: 600;
        }
        .badge.green { background: #e8f5e9; color: #2e7d32; }
        .badge.red { background: #fdecea; color: #c62828; }
        .badge.blue { background: #e3f2fd; color: #1565c0; }
        .badge.grey { background: #f5f5f5; color: #757575; }

        select, input {
            padding: 8px 10px; border: 1.5px solid #e0e0e0;
            border-radius: 8px; font-size: 13px; outline: none;
            transition: border 0.2s; background: white;
        }
        select:focus, input:focus { border-color: #e53935; }

        .btn {
            padding: 8px 16px; border-radius: 8px; border: none;
            font-size: 13px; font-weight: 600;
            cursor: pointer; transition: all 0.2s;
        }
        .btn-primary { background: #e53935; color: white; }
        .btn-primary:hover { background: #c62828; }
        .btn-danger { background: #fdecea; color: #e53935; }
        .btn-danger:hover { background: #e53935; color: white; }
        .btn-sm { padding: 6px 12px; font-size: 12px; }

        .inline-form { display: inline; }

        .empty-state { text-align: center; padding: 48px 20px; color: #bbb; }
        .empty-state .icon { font-size: 48px; margin-bottom: 12px; }
        .empty-state p { font-size: 14px; }

        .assign-row { display: flex; gap: 8px; align-items: center; }
    </style>
</head>
<body>

<%
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    List<DoctorPatient> assignments = (List<DoctorPatient>) request.getAttribute("assignments");
    long totalPatients = (long) request.getAttribute("totalPatients");
    String successMsg = request.getParameter("success");
    String errorMsg = request.getParameter("error");

    // Helper to find assigned doctor for a patient
    java.util.Map<Long, Long> patientDoctorMap = new java.util.HashMap<>();
    if (assignments != null) {
        for (DoctorPatient dp : assignments) {
            if ("ACTIVE".equals(dp.getStatus())) {
                patientDoctorMap.put(dp.getPatientId(), dp.getDoctorId());
            }
        }
    }

    // Helper to get doctor name by id
    java.util.Map<Long, String> doctorNameMap = new java.util.HashMap<>();
    if (doctors != null) {
        for (Doctor d : doctors) {
            doctorNameMap.put(d.getId(), d.getName());
        }
    }
%>

<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-logo">🏥 Hospital<span>System</span></div>
    <div class="sidebar-menu">
        <div class="menu-label">Overview</div>
        <a href="/admin/dashboard">📊 Dashboard</a>
        <div class="menu-label">Management</div>
        <a href="/admin/resources">🏥 Resources</a>
        <a href="/admin/doctors">👨‍⚕️ Doctors</a>
        <a href="/admin/patients" class="active">👥 Patients</a>
        <a href="/admin/schedule">📅 Schedule</a>
		<a href="/admin/labs">🔬 Labs</a>
		<a href="/admin/external" class="active">🌐 External Sources</a>
    </div>
    <div class="sidebar-bottom">
        <a href="/logout" class="logout-btn">🚪 Logout</a>
    </div>
</div>

<!-- Navbar -->
<div class="navbar">
    <h2>👥 Patient Management</h2>
</div>

<!-- Main -->
<div class="main">

    <% if (successMsg != null) { %>
        <div class="alert success">✅ <%= successMsg %></div>
    <% } %>
    <% if ("alreadyassigned".equals(errorMsg)) { %>
        <div class="alert error">⚠️ This doctor is already assigned to this patient.</div>
    <% } %>

    <!-- Stats -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="value"><%= totalPatients %></div>
            <div class="label">Total Patients</div>
        </div>
        <div class="stat-card">
            <div class="value"><%= patientDoctorMap.size() %></div>
            <div class="label">Assigned to Doctor</div>
        </div>
        <div class="stat-card">
            <div class="value"><%= totalPatients - patientDoctorMap.size() %></div>
            <div class="label">Unassigned</div>
        </div>
    </div>

    <!-- Patients Table -->
    <div class="card">
        <div class="card-header">
            <h3>All Patients</h3>
            <span class="count-badge"><%= totalPatients %> patients</span>
        </div>

        <% if (patients == null || patients.isEmpty()) { %>
            <div class="empty-state">
                <div class="icon">👥</div>
                <p>No patients registered yet.</p>
            </div>
        <% } else { %>
            <table>
                <tr>
                    <th>Patient</th>
                    <th>Age</th>
                    <th>Blood Group</th>
                    <th>Phone</th>
                    <th>Assigned Doctor</th>
                    <th>Assign / Change Doctor</th>
                </tr>
                <% for (Patient patient : patients) {
                    Long assignedDoctorId = patientDoctorMap.get(patient.getId());
                    String assignedDoctorName = assignedDoctorId != null
                        ? doctorNameMap.get(assignedDoctorId) : null;
                %>
                <tr>
                    <td>
                        <strong><%= patient.getName() %></strong><br/>
                        <small style="color:#888"><%= patient.getEmail() %></small>
                    </td>
                    <td><%= patient.getAge() %> yrs</td>
                    <td><span class="badge red"><%= patient.getBloodGroup() %></span></td>
                    <td><%= patient.getPhone() %></td>
                    <td>
                        <% if (assignedDoctorName != null) { %>
                            <span class="badge green">Dr. <%= assignedDoctorName %></span>
                        <% } else { %>
                            <span class="badge grey">Not Assigned</span>
                        <% } %>
                    </td>
                    <td>
                        <form action="/admin/patients/assign-doctor" method="post" class="inline-form">
                            <input type="hidden" name="patientId" value="<%= patient.getId() %>" />
                            <div class="assign-row">
                                <select name="doctorId" required>
                                    <option value="" disabled selected>Select Doctor</option>
                                    <% if (doctors != null) {
                                        for (Doctor doc : doctors) { %>
                                        <option value="<%= doc.getId() %>">
                                            Dr. <%= doc.getName() %> — <%= doc.getDepartment() %>
                                        </option>
                                    <% }} %>
                                </select>
                                <button type="submit" class="btn btn-primary btn-sm">Assign</button>
                            </div>
                        </form>
                        <% if (assignedDoctorName != null) { %>
                            <form action="/admin/patients/remove-doctor" method="post"
                                  class="inline-form" style="margin-top:6px"
                                  onsubmit="return confirm('Remove doctor assignment?')">
                                <input type="hidden" name="patientId" value="<%= patient.getId() %>" />
                                <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                            </form>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </table>
        <% } %>
    </div>

</div>

</body>
</html>