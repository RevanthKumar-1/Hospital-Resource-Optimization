<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hospital.model.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Schedule</title>
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

        .main { margin-left: 240px; padding: 32px 36px; }

        .alert {
            padding: 12px 16px; border-radius: 10px;
            font-size: 14px; margin-bottom: 20px;
        }
        .alert.success { background: #e8f5e9; color: #2e7d32; }
        .alert.error { background: #fdecea; color: #c62828; }

        .tabs {
            display: flex; gap: 8px; margin-bottom: 28px;
        }
        .tab-btn {
            padding: 10px 20px; border-radius: 8px;
            border: 2px solid #e0e0e0; background: white;
            color: #666; font-size: 14px; font-weight: 600;
            cursor: pointer; text-decoration: none; transition: all 0.2s;
        }
        .tab-btn:hover { border-color: #e53935; color: #e53935; }
        .tab-btn.active { background: #e53935; color: white; border-color: #e53935; }

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

        .add-form {
            background: #fdf4f4; border-radius: 10px; padding: 20px;
            margin-bottom: 24px; border: 1px solid #fdecea;
        }
        .add-form h4 { font-size: 14px; font-weight: 700; color: #e53935; margin-bottom: 14px; }

        .form-grid {
            display: grid; grid-template-columns: repeat(3, 1fr);
            gap: 14px; margin-bottom: 14px;
        }
        .form-group { display: flex; flex-direction: column; gap: 5px; }
        label { font-size: 12px; font-weight: 600; color: #666; }

        select, input {
            padding: 9px 12px; border: 1.5px solid #e0e0e0;
            border-radius: 8px; font-size: 13px; outline: none;
            transition: border 0.2s; background: white;
        }
        select:focus, input:focus { border-color: #e53935; }

        .btn {
            padding: 9px 18px; border-radius: 8px; border: none;
            font-size: 13px; font-weight: 600; cursor: pointer; transition: all 0.2s;
        }
        .btn-primary { background: #e53935; color: white; }
        .btn-primary:hover { background: #c62828; }
        .btn-success { background: #4caf50; color: white; }
        .btn-success:hover { background: #388e3c; }
        .btn-danger { background: #fdecea; color: #e53935; }
        .btn-danger:hover { background: #e53935; color: white; }
        .btn-sm { padding: 6px 12px; font-size: 12px; }

        table { width: 100%; border-collapse: collapse; }
        th {
            text-align: left; font-size: 11px; text-transform: uppercase;
            color: #aaa; padding: 8px 12px; border-bottom: 1px solid #f5f5f5;
        }
        td {
            padding: 12px; font-size: 14px; color: #444;
            border-bottom: 1px solid #fafafa; vertical-align: middle;
        }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #fffafa; }

        .badge {
            padding: 4px 10px; border-radius: 20px;
            font-size: 11px; font-weight: 600;
        }
        .badge.green { background: #e8f5e9; color: #2e7d32; }
        .badge.red { background: #fdecea; color: #c62828; }
        .badge.orange { background: #fff3e0; color: #e65100; }
        .badge.blue { background: #e3f2fd; color: #1565c0; }

        .inline-form { display: inline; }

        .empty-state { text-align: center; padding: 36px; color: #bbb; }
        .empty-state .icon { font-size: 40px; margin-bottom: 10px; }
        .empty-state p { font-size: 14px; }
    </style>
</head>
<body>

<%
    String activeTab = request.getParameter("tab") != null
                       ? request.getParameter("tab") : "bed";
    String successMsg = request.getParameter("success");
	String errorMsg = request.getParameter("error");

    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    List<Bed> availableBeds = (List<Bed>) request.getAttribute("availableBeds");
    List<Icu> availableIcus = (List<Icu>) request.getAttribute("availableIcus");
    List<Ot> availableOts = (List<Ot>) request.getAttribute("availableOts");
    List<BedAdmission> bedAdmissions = (List<BedAdmission>) request.getAttribute("bedAdmissions");
    List<IcuAdmission> icuAdmissions = (List<IcuAdmission>) request.getAttribute("icuAdmissions");
    List<OtSchedule> otSchedules = (List<OtSchedule>) request.getAttribute("otSchedules");

    // Helper maps
    java.util.Map<Long, String> patientNameMap = new java.util.HashMap<>();
    java.util.Map<Long, String> doctorNameMap = new java.util.HashMap<>();
    java.util.Map<Integer, String> bedNumberMap = new java.util.HashMap<>();

    if (patients != null)
        for (Patient p : patients) patientNameMap.put(p.getId(), p.getName());
    if (doctors != null)
        for (Doctor d : doctors) doctorNameMap.put(d.getId(), d.getName());
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
        <a href="/admin/patients">👥 Patients</a>
        <a href="/admin/schedule" class="active">📅 Schedule</a>
		<a href="/admin/labs">🔬 Labs</a>
		<a href="/admin/external">🌐 External Sources</a>
    </div>
    <div class="sidebar-bottom">
        <a href="/logout" class="logout-btn">🚪 Logout</a>
    </div>
</div>

<!-- Navbar -->
<div class="navbar">
    <h2>📅 Schedule & Resource Assignment</h2>
</div>

<!-- Main -->
<div class="main">


	    <% if (successMsg != null) { %>
	        <div class="alert success">✅ <%= successMsg %></div>
	    <% } %>

	    <% if ("otconflict".equals(errorMsg)) { %>
	        <div class="alert error">
	            ❌ OT Conflict! This OT is already booked during that time slot.
	            Please choose a different time or OT.
	        </div>
	    <% } else if ("doctorconflict".equals(errorMsg)) { %>
	        <div class="alert error">
	            ❌ Doctor Conflict! This doctor already has a procedure scheduled
	            during that time.
	        </div>
	    <% } else if ("invalidtime".equals(errorMsg)) { %>
	        <div class="alert error">
	            ❌ Invalid time! End time must be after start time.
	        </div>
	    <% } else if ("pastdate".equals(errorMsg)) { %>
	        <div class="alert error">
	            ❌ Cannot schedule OT in the past!
	        </div>
	    <% } else if ("bedoccupied".equals(errorMsg)) { %>
	        <div class="alert error">
	            ❌ This bed is already occupied! Please select a different bed.
	        </div>
	    <% } else if ("invaliddates".equals(errorMsg)) { %>
	        <div class="alert error">
	            ❌ Discharge date must be after admission date!
	        </div>
	    <% } %>

    <!-- Tabs -->
    <div class="tabs">
        <a href="?tab=bed" class="tab-btn <%= "bed".equals(activeTab) ? "active" : "" %>">🛏️ Bed Admission</a>
        <a href="?tab=icu" class="tab-btn <%= "icu".equals(activeTab) ? "active" : "" %>">🏥 ICU Admission</a>
        <a href="?tab=ot"  class="tab-btn <%= "ot".equals(activeTab)  ? "active" : "" %>">🔬 OT Schedule</a>
    </div>

    <!-- ═══ BED TAB ═══ -->
    <% if ("bed".equals(activeTab)) { %>

        <div class="add-form">
            <h4>➕ Assign Bed to Patient</h4>
            <form action="/admin/schedule/assign-bed" method="post">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Patient</label>
                        <select name="patientId" required>
                            <option value="" disabled selected>Select Patient</option>
                            <% if (patients != null) for (Patient p : patients) { %>
                                <option value="<%= p.getId() %>"><%= p.getName() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Doctor</label>
                        <select name="doctorId" required>
                            <option value="" disabled selected>Select Doctor</option>
                            <% if (doctors != null) for (Doctor d : doctors) { %>
                                <option value="<%= d.getId() %>">Dr. <%= d.getName() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Available Bed</label>
                        <select name="bedId" required>
                            <option value="" disabled selected>Select Bed</option>
                            <% if (availableBeds != null) for (Bed b : availableBeds) { %>
                                <option value="<%= b.getId() %>">
                                    <%= b.getBedNumber() %> — <%= b.getWard() %> (Floor <%= b.getFloor() %>)
                                </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Admitted Date</label>
                        <input type="date" name="admittedDate" required />
                    </div>
                    <div class="form-group">
                        <label>Expected Discharge</label>
                        <input type="date" name="dischargeDate" required />
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Assign Bed</button>
            </form>
        </div>

        <div class="card">
            <div class="card-header"><h3>Active Bed Admissions</h3></div>
            <% if (bedAdmissions == null || bedAdmissions.isEmpty()) { %>
                <div class="empty-state">
                    <div class="icon">🛏️</div>
                    <p>No active bed admissions.</p>
                </div>
            <% } else { %>
                <table>
                    <tr>
                        <th>Patient</th>
                        <th>Doctor</th>
                        <th>Bed ID</th>
                        <th>Admitted</th>
                        <th>Discharge</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    <% for (BedAdmission ba : bedAdmissions) { %>
                    <tr>
                        <td><%= patientNameMap.getOrDefault(ba.getPatientId(), "Unknown") %></td>
                        <td>Dr. <%= doctorNameMap.getOrDefault(ba.getDoctorId(), "Unknown") %></td>
                        <td>Bed #<%= ba.getBedId() %></td>
                        <td><%= ba.getAdmittedDate() %></td>
                        <td><%= ba.getDischargeDate() %></td>
                        <td><span class="badge green">Active</span></td>
                        <td>
                            <form action="/admin/schedule/release-bed" method="post"
                                  class="inline-form"
                                  onsubmit="return confirm('Discharge this patient?')">
                                <input type="hidden" name="admissionId" value="<%= ba.getId() %>" />
                                <button type="submit" class="btn btn-danger btn-sm">Discharge</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </table>
            <% } %>
        </div>

    <% } %>

    <!-- ═══ ICU TAB ═══ -->
    <% if ("icu".equals(activeTab)) { %>

        <div class="add-form">
            <h4>➕ Admit Patient to ICU</h4>
            <form action="/admin/schedule/assign-icu" method="post">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Patient</label>
                        <select name="patientId" required>
                            <option value="" disabled selected>Select Patient</option>
                            <% if (patients != null) for (Patient p : patients) { %>
                                <option value="<%= p.getId() %>"><%= p.getName() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Doctor</label>
                        <select name="doctorId" required>
                            <option value="" disabled selected>Select Doctor</option>
                            <% if (doctors != null) for (Doctor d : doctors) { %>
                                <option value="<%= d.getId() %>">Dr. <%= d.getName() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Available ICU Unit</label>
                        <select name="icuId" required>
                            <option value="" disabled selected>Select ICU</option>
                            <% if (availableIcus != null) for (Icu i : availableIcus) { %>
                                <option value="<%= i.getId() %>">
                                    ICU #<%= i.getId() %>
                                    <%= i.getVentilator() ? "— Ventilator" : "" %>
                                </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Admitted Date</label>
                        <input type="date" name="admittedDate" required />
                    </div>
                    <div class="form-group">
                        <label>Expected Release</label>
                        <input type="date" name="dischargeDate" required />
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Admit to ICU</button>
            </form>
        </div>

        <div class="card">
            <div class="card-header"><h3>Active ICU Admissions</h3></div>
            <% if (icuAdmissions == null || icuAdmissions.isEmpty()) { %>
                <div class="empty-state">
                    <div class="icon">🏥</div>
                    <p>No active ICU admissions.</p>
                </div>
            <% } else { %>
                <table>
                    <tr>
                        <th>Patient</th>
                        <th>Doctor</th>
                        <th>ICU Unit</th>
                        <th>Admitted</th>
                        <th>Expected Release</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    <% for (IcuAdmission ia : icuAdmissions) { %>
                    <tr>
                        <td><%= patientNameMap.getOrDefault(ia.getPatientId(), "Unknown") %></td>
                        <td>Dr. <%= doctorNameMap.getOrDefault(ia.getDoctorId(), "Unknown") %></td>
                        <td>ICU #<%= ia.getIcuId() %></td>
                        <td><%= ia.getAdmittedDate() %></td>
                        <td><%= ia.getDischargeDate() %></td>
                        <td><span class="badge red">Active</span></td>
                        <td>
                            <form action="/admin/schedule/release-icu" method="post"
                                  class="inline-form"
                                  onsubmit="return confirm('Discharge from ICU?')">
                                <input type="hidden" name="admissionId" value="<%= ia.getId() %>" />
                                <button type="submit" class="btn btn-danger btn-sm">Discharge</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </table>
            <% } %>
        </div>

    <% } %>

    <!-- ═══ OT TAB ═══ -->
    <% if ("ot".equals(activeTab)) { %>

        <div class="add-form">
            <h4>➕ Schedule Operation Theatre</h4>
            <form action="/admin/schedule/assign-ot" method="post">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Patient</label>
                        <select name="patientId" required>
                            <option value="" disabled selected>Select Patient</option>
                            <% if (patients != null) for (Patient p : patients) { %>
                                <option value="<%= p.getId() %>"><%= p.getName() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Doctor</label>
                        <select name="doctorId" required>
                            <option value="" disabled selected>Select Doctor</option>
                            <% if (doctors != null) for (Doctor d : doctors) { %>
                                <option value="<%= d.getId() %>">Dr. <%= d.getName() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Operation Theatre</label>
                        <select name="otId" required>
                            <option value="" disabled selected>Select OT</option>
                            <% if (availableOts != null) for (Ot o : availableOts) { %>
                                <option value="<%= o.getId() %>">OT-<%= o.getId() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Procedure Name</label>
                        <input type="text" name="procedureName" placeholder="e.g. Appendectomy" required />
                    </div>
                    <div class="form-group">
                        <label>Date</label>
                        <input type="date" name="scheduleDate" required />
                    </div>
                    <div class="form-group">
                        <label>Start Time</label>
                        <input type="time" name="startTime" required />
                    </div>
                    <div class="form-group">
                        <label>End Time</label>
                        <input type="time" name="endTime" required />
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Schedule OT</button>
            </form>
        </div>

        <div class="card">
            <div class="card-header"><h3>Scheduled Procedures</h3></div>
            <% if (otSchedules == null || otSchedules.isEmpty()) { %>
                <div class="empty-state">
                    <div class="icon">🔬</div>
                    <p>No OT procedures scheduled.</p>
                </div>
            <% } else { %>
                <table>
                    <tr>
                        <th>Patient</th>
                        <th>Doctor</th>
                        <th>OT</th>
                        <th>Procedure</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    <% for (OtSchedule os : otSchedules) { %>
                    <tr>
                        <td><%= patientNameMap.getOrDefault(os.getPatientId(), "Unknown") %></td>
                        <td>Dr. <%= doctorNameMap.getOrDefault(os.getDoctorId(), "Unknown") %></td>
                        <td>OT-<%= os.getOtId() %></td>
                        <td><%= os.getProcedureName() %></td>
                        <td><%= os.getScheduleDate() %></td>
                        <td><%= os.getStartTime() %> – <%= os.getEndTime() %></td>
                        <td><span class="badge orange">Scheduled</span></td>
                        <td>
                            <form action="/admin/schedule/update-ot" method="post" class="inline-form">
                                <input type="hidden" name="scheduleId" value="<%= os.getId() %>" />
                                <select name="status">
                                    <option value="COMPLETED">Completed</option>
                                    <option value="CANCELLED">Cancelled</option>
                                </select>
                                <button type="submit" class="btn btn-success btn-sm">Update</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </table>
            <% } %>
        </div>

    <% } %>

</div>

</body>
</html>