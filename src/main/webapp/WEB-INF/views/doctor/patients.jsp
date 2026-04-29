<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hospital.model.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Doctor - My Patients</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #fffdf5; min-height: 100vh; }

        .navbar {
            background: white; padding: 16px 40px;
            display: flex; justify-content: space-between; align-items: center;
            border-bottom: 3px solid #f5c518;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .navbar .logo { font-size: 22px; font-weight: 700; color: #333; }
        .navbar .logo span { color: #f5c518; }
        .nav-links { display: flex; gap: 8px; }
        .nav-link {
            padding: 8px 16px; border-radius: 8px; text-decoration: none;
            font-size: 14px; font-weight: 600; color: #666; transition: all 0.2s;
        }
        .nav-link:hover { background: #fff8dc; color: #b8860b; }
        .nav-link.active { background: #f5c518; color: #333; }
        .navbar-right { display: flex; align-items: center; gap: 12px; }
        .logout-btn {
            background: #f5c518; color: #333; border: none;
            padding: 8px 18px; border-radius: 8px; font-size: 14px;
            font-weight: 600; cursor: pointer; text-decoration: none;
        }
        .logout-btn:hover { background: #e0b400; }

        .main { padding: 36px 40px; max-width: 1300px; margin: 0 auto; }
        .page-header { margin-bottom: 28px; }
        .page-header h1 { font-size: 26px; color: #333; font-weight: 700; }
        .page-header p { color: #888; font-size: 14px; margin-top: 4px; }

        .stats-row {
            display: grid; grid-template-columns: repeat(3, 1fr);
            gap: 20px; margin-bottom: 32px;
        }
        .stat-card {
            background: white; border-radius: 14px; padding: 22px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            border-top: 4px solid #f5c518;
        }
        .stat-card .icon { font-size: 26px; margin-bottom: 10px; }
        .stat-card .value { font-size: 32px; font-weight: 700; color: #333; }
        .stat-card .label { font-size: 13px; color: #888; margin-top: 4px; }

        /* Patient Cards */
        .patients-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(580px, 1fr));
            gap: 24px;
        }

        .patient-card {
            background: white; border-radius: 14px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            overflow: hidden;
        }

        .patient-card-header {
            background: #fff8dc; padding: 20px 24px;
            display: flex; align-items: center; gap: 16px;
            border-bottom: 2px solid #f5c518;
        }

        .patient-avatar {
            width: 52px; height: 52px; border-radius: 50%;
            background: #f5c518; display: flex; align-items: center;
            justify-content: center; font-size: 22px; flex-shrink: 0;
        }

        .patient-header-info { flex: 1; }
        .patient-name { font-size: 18px; font-weight: 700; color: #333; }
        .patient-sub { font-size: 13px; color: #888; margin-top: 2px; }

        .patient-card-body { padding: 20px 24px; }

        .info-grid {
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 12px; margin-bottom: 16px;
        }

        .info-item { display: flex; flex-direction: column; gap: 3px; }
        .info-item .info-label { font-size: 11px; color: #aaa; text-transform: uppercase; font-weight: 600; }
        .info-item .info-value { font-size: 14px; color: #333; font-weight: 500; }

        .section-divider {
            height: 1px; background: #f5f5f5;
            margin: 16px 0;
        }

        .section-title {
            font-size: 13px; font-weight: 700; color: #b8860b;
            margin-bottom: 12px; display: flex; align-items: center; gap: 6px;
        }

        .resource-row {
            display: flex; justify-content: space-between; align-items: center;
            padding: 8px 0; font-size: 14px;
            border-bottom: 1px solid #fafafa;
        }
        .resource-row:last-child { border-bottom: none; }
        .resource-label { color: #888; font-size: 13px; }
        .resource-value { font-weight: 600; color: #333; font-size: 13px; }

        .ot-item {
            background: #fffdf0; border-radius: 8px;
            padding: 10px 14px; margin-bottom: 8px;
            border-left: 3px solid #f5c518;
        }
        .ot-item:last-child { margin-bottom: 0; }
        .ot-procedure { font-size: 14px; font-weight: 600; color: #333; }
        .ot-details { font-size: 12px; color: #888; margin-top: 3px; }

        .badge {
            padding: 4px 10px; border-radius: 20px;
            font-size: 11px; font-weight: 600;
        }
        .badge.green { background: #e8f5e9; color: #2e7d32; }
        .badge.red { background: #fdecea; color: #c62828; }
        .badge.orange { background: #fff3e0; color: #e65100; }
        .badge.yellow { background: #fff8dc; color: #b8860b; }
        .badge.grey { background: #f5f5f5; color: #757575; }
        .badge.blue { background: #e3f2fd; color: #1565c0; }

        .medical-history {
            background: #fafafa; border-radius: 8px; padding: 12px;
            font-size: 13px; color: #555; line-height: 1.6;
        }

        .empty-state { text-align: center; padding: 64px 20px; color: #bbb; }
        .empty-state .icon { font-size: 64px; margin-bottom: 16px; }
        .empty-state h2 { font-size: 20px; margin-bottom: 8px; color: #999; }
        .empty-state p { font-size: 14px; }
    </style>
</head>
<body>

<%
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    Map<Long, BedAdmission> patientBedMap = (Map<Long, BedAdmission>) request.getAttribute("patientBedMap");
    Map<Long, IcuAdmission> patientIcuMap = (Map<Long, IcuAdmission>) request.getAttribute("patientIcuMap");
    Map<Long, List<OtSchedule>> patientOtMap = (Map<Long, List<OtSchedule>>) request.getAttribute("patientOtMap");
    Map<Integer, Bed> bedMap = (Map<Integer, Bed>) request.getAttribute("bedMap");
    Map<Integer, Icu> icuMap = (Map<Integer, Icu>) request.getAttribute("icuMap");
    int totalPatients = (int) request.getAttribute("totalPatients");

    String doctorName = (String) session.getAttribute("userName");

    // Count patients in bed and ICU
    int inBed = patientBedMap != null ? patientBedMap.size() : 0;
    int inIcu = patientIcuMap != null ? patientIcuMap.size() : 0;
%>

<!-- Navbar -->
<div class="navbar">
    <div class="logo">🏥 Hospital<span>System</span></div>
    <div class="nav-links">
        <a href="/doctor/dashboard" class="nav-link">📊 Dashboard</a>
        <a href="/doctor/patients" class="nav-link active">👥 My Patients</a>
    </div>
    <div class="navbar-right">
        <span style="font-size:14px; color:#888">Dr. <%= doctorName %></span>
        <a href="/logout" class="logout-btn">Logout</a>
    </div>
</div>

<!-- Main -->
<div class="main">

    <div class="page-header">
        <h1>👥 My Patients</h1>
        <p>View and monitor all your assigned patients and their current status.</p>
    </div>

    <!-- Stats -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="icon">👥</div>
            <div class="value"><%= totalPatients %></div>
            <div class="label">Total Assigned Patients</div>
        </div>
        <div class="stat-card">
            <div class="icon">🛏️</div>
            <div class="value"><%= inBed %></div>
            <div class="label">Currently in Beds</div>
        </div>
        <div class="stat-card">
            <div class="icon">🏥</div>
            <div class="value"><%= inIcu %></div>
            <div class="label">Currently in ICU</div>
        </div>
    </div>

    <!-- Patient Cards -->
    <% if (patients == null || patients.isEmpty()) { %>
        <div class="empty-state">
            <div class="icon">👥</div>
            <h2>No patients assigned yet</h2>
            <p>Patients will appear here once the admin assigns them to you.</p>
        </div>
    <% } else { %>
        <div class="patients-grid">
            <% for (Patient p : patients) {
                BedAdmission bed = patientBedMap != null ? patientBedMap.get(p.getId()) : null;
                IcuAdmission icu = patientIcuMap != null ? patientIcuMap.get(p.getId()) : null;
                List<OtSchedule> ots = patientOtMap != null ? patientOtMap.get(p.getId()) : null;
                Bed bedDetails = (bed != null && bedMap != null) ? bedMap.get(bed.getBedId()) : null;
                Icu icuDetails = (icu != null && icuMap != null) ? icuMap.get(icu.getIcuId()) : null;
            %>
            <div class="patient-card">

                <!-- Card Header -->
                <div class="patient-card-header">
                    <div class="patient-avatar">🧑</div>
                    <div class="patient-header-info">
                        <div class="patient-name"><%= p.getName() %></div>
                        <div class="patient-sub">
                            <%= p.getAge() %> yrs · <%= p.getGender() %> ·
                            <strong><%= p.getBloodGroup() %></strong> ·
                            <%= p.getPhone() %>
                        </div>
                    </div>
                    <!-- Status badge -->
                    <% if (icu != null) { %>
                        <span class="badge red">ICU</span>
                    <% } else if (bed != null) { %>
                        <span class="badge orange">Admitted</span>
                    <% } else { %>
                        <span class="badge grey">Outpatient</span>
                    <% } %>
                </div>

                <div class="patient-card-body">

                    <!-- Personal Info -->
                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-label">Email</span>
                            <span class="info-value"><%= p.getEmail() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Emergency Contact</span>
                            <span class="info-value">
                                <%= p.getEmergencyContact() != null ? p.getEmergencyContact() : "N/A" %>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Address</span>
                            <span class="info-value">
                                <%= p.getAddress() != null ? p.getAddress() : "N/A" %>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Date of Birth</span>
                            <span class="info-value">
                                <%= p.getDateOfBirth() != null ? p.getDateOfBirth().toString() : "N/A" %>
                            </span>
                        </div>
                    </div>

                    <!-- Medical History -->
                    <% if (p.getMedicalHistory() != null && !p.getMedicalHistory().isEmpty()) { %>
                        <div class="section-divider"></div>
                        <div class="section-title">📋 Medical History</div>
                        <div class="medical-history"><%= p.getMedicalHistory() %></div>
                    <% } %>

                    <div class="section-divider"></div>

                    <!-- Resource Allocation -->
                    <div class="section-title">🏥 Current Allocation</div>

                    <div class="resource-row">
                        <span class="resource-label">🛏️ Bed</span>
                        <% if (bedDetails != null) { %>
                            <span class="resource-value">
                                <%= bedDetails.getBedNumber() %> — <%= bedDetails.getWard() %>,
                                Floor <%= bedDetails.getFloor() %>
                            </span>
                        <% } else { %>
                            <span class="badge grey">Not Assigned</span>
                        <% } %>
                    </div>

                    <div class="resource-row">
                        <span class="resource-label">🏥 ICU</span>
                        <% if (icuDetails != null) { %>
                            <span class="resource-value">
                                ICU #<%= icuDetails.getId() %>
                                <%= icuDetails.getVentilator() ? "· Ventilator" : "" %>
                            </span>
                        <% } else { %>
                            <span class="badge grey">Not in ICU</span>
                        <% } %>
                    </div>

                    <% if (bed != null) { %>
                    <div class="resource-row">
                        <span class="resource-label">📅 Admitted</span>
                        <span class="resource-value"><%= bed.getAdmittedDate() %></span>
                    </div>
                    <div class="resource-row">
                        <span class="resource-label">📅 Expected Discharge</span>
                        <span class="resource-value"><%= bed.getDischargeDate() %></span>
                    </div>
                    <% } %>

                    <!-- OT Schedules -->
                    <% if (ots != null && !ots.isEmpty()) { %>
                        <div class="section-divider"></div>
                        <div class="section-title">🔬 Upcoming Procedures</div>
                        <% for (OtSchedule os : ots) { %>
                        <div class="ot-item">
                            <div class="ot-procedure"><%= os.getProcedureName() %></div>
                            <div class="ot-details">
                                OT-<%= os.getOtId() %> ·
                                <%= os.getScheduleDate() %> ·
                                <%= os.getStartTime() %> – <%= os.getEndTime() %>
                            </div>
                        </div>
                        <% } %>
                    <% } %>

                </div>
            </div>
            <% } %>
        </div>
    <% } %>
</div>

</body>
</html>