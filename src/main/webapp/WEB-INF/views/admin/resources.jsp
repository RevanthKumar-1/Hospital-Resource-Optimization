<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hospital.model.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Resources</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body { font-family: 'Segoe UI', sans-serif; background: #fdf4f4; }

        /* Sidebar - same as dashboard */
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

        /* Navbar */
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

        /* Main */
        .main { margin-left: 240px; padding: 32px 36px; }

        /* Tabs */
        .tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 28px;
            flex-wrap: wrap;
        }

        .tab-btn {
            padding: 10px 20px;
            border-radius: 8px;
            border: 2px solid #e0e0e0;
            background: white;
            color: #666;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s;
        }

        .tab-btn:hover { border-color: #e53935; color: #e53935; }
        .tab-btn.active { background: #e53935; color: white; border-color: #e53935; }

        /* Alert */
        .alert {
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .alert.success { background: #e8f5e9; color: #2e7d32; }

        /* Stats row */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 24px;
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

        /* Card */
        .card {
            background: white;
            border-radius: 14px;
            padding: 24px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            margin-bottom: 24px;
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

        /* Add Form */
        .add-form {
            background: #fdf4f4;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 24px;
            border: 1px solid #fdecea;
        }

        .add-form h4 {
            font-size: 14px;
            font-weight: 700;
            color: #e53935;
            margin-bottom: 14px;
        }

        .form-row {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            align-items: flex-end;
        }

        .form-group { display: flex; flex-direction: column; gap: 5px; }
        .form-group label { font-size: 12px; font-weight: 600; color: #666; }

        input, select {
            padding: 9px 12px;
            border: 1.5px solid #e0e0e0;
            border-radius: 8px;
            font-size: 13px;
            outline: none;
            transition: border 0.2s;
            background: white;
            min-width: 120px;
        }

        input:focus, select:focus { border-color: #e53935; }

        .btn {
            padding: 9px 18px;
            border-radius: 8px;
            border: none;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-primary { background: #e53935; color: white; }
        .btn-primary:hover { background: #c62828; }
        .btn-success { background: #4caf50; color: white; }
        .btn-success:hover { background: #388e3c; }
        .btn-danger { background: #fdecea; color: #e53935; }
        .btn-danger:hover { background: #e53935; color: white; }
        .btn-sm { padding: 6px 12px; font-size: 12px; }

        /* Table */
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
            padding: 12px;
            font-size: 14px;
            color: #444;
            border-bottom: 1px solid #fafafa;
            vertical-align: middle;
        }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #fffafa; }

        /* Badge */
        .badge {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }

        .badge.green { background: #e8f5e9; color: #2e7d32; }
        .badge.red { background: #fdecea; color: #c62828; }
        .badge.orange { background: #fff3e0; color: #e65100; }
        .badge.grey { background: #f5f5f5; color: #757575; }

        /* Empty */
        .empty-state {
            text-align: center;
            padding: 32px;
            color: #bbb;
        }

        .empty-state .icon { font-size: 36px; margin-bottom: 8px; }
        .empty-state p { font-size: 14px; }

        /* Inline form */
        .inline-form { display: inline; }
        .inline-form button { margin-left: 4px; }

        /* Section hidden by default */
        .tab-section { display: none; }
        .tab-section.active { display: block; }
    </style>
</head>
<body>

<%
    String activeTab = request.getParameter("tab") != null
                       ? request.getParameter("tab") : "beds";
    String successMsg = request.getParameter("success");

    List<Bed> beds = (List<Bed>) request.getAttribute("beds");
    List<Icu> icus = (List<Icu>) request.getAttribute("icus");
    List<Ot> ots = (List<Ot>) request.getAttribute("ots");
    List<OxygenTank> oxygenTanks = (List<OxygenTank>) request.getAttribute("oxygenTanks");
    List<BloodBank> bloodBanks = (List<BloodBank>) request.getAttribute("bloodBanks");

    long totalBeds = (long) request.getAttribute("totalBeds");
    long availableBeds = (long) request.getAttribute("availableBeds");
    long occupiedBeds = (long) request.getAttribute("occupiedBeds");

    long totalIcu = (long) request.getAttribute("totalIcu");
    long availableIcu = (long) request.getAttribute("availableIcu");
    long occupiedIcu = (long) request.getAttribute("occupiedIcu");

    long totalOt = (long) request.getAttribute("totalOt");
    long availableOt = (long) request.getAttribute("availableOt");

    long totalOxygen = (long) request.getAttribute("totalOxygen");
    long availableOxygen = (long) request.getAttribute("availableOxygen");
%>

<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-logo">🏥 Hospital<span>System</span></div>
    <div class="sidebar-menu">
        <div class="menu-label">Overview</div>
        <a href="/admin/dashboard">📊 Dashboard</a>
        <div class="menu-label">Management</div>
        <a href="/admin/resources" class="active">🏥 Resources</a>
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
    <h2>🏥 Resource Management</h2>
</div>

<!-- Main -->
<div class="main">

    <% if (successMsg != null) { %>
        <div class="alert success">✅ <%= successMsg %></div>
    <% } %>

    <!-- Tabs -->
    <div class="tabs">
        <a href="?tab=beds"   class="tab-btn <%= "beds".equals(activeTab)   ? "active" : "" %>">🛏️ Beds</a>
        <a href="?tab=icu"    class="tab-btn <%= "icu".equals(activeTab)    ? "active" : "" %>">🏥 ICU</a>
        <a href="?tab=ot"     class="tab-btn <%= "ot".equals(activeTab)     ? "active" : "" %>">🔬 OT</a>
        <a href="?tab=oxygen" class="tab-btn <%= "oxygen".equals(activeTab) ? "active" : "" %>">🫁 Oxygen</a>
        <a href="?tab=blood"  class="tab-btn <%= "blood".equals(activeTab)  ? "active" : "" %>">🩸 Blood Bank</a>
    </div>

    <!-- ═══ BEDS TAB ═══ -->
    <% if ("beds".equals(activeTab)) { %>

        <div class="stats-row">
            <div class="stat-card">
                <div class="value"><%= totalBeds %></div>
                <div class="label">Total Beds</div>
            </div>
            <div class="stat-card">
                <div class="value"><%= availableBeds %></div>
                <div class="label">Available</div>
            </div>
            <div class="stat-card">
                <div class="value"><%= occupiedBeds %></div>
                <div class="label">Occupied</div>
            </div>
        </div>

        <!-- Add Bed Form -->
        <div class="add-form">
            <h4>➕ Add New Bed</h4>
            <form action="/admin/resources/beds/add" method="post">
                <div class="form-row">
                    <div class="form-group">
                        <label>Bed Number</label>
                        <input type="text" name="bedNumber" placeholder="e.g. B101" required />
                    </div>
                    <div class="form-group">
                        <label>Ward</label>
                        <input type="text" name="ward" placeholder="e.g. General" required />
                    </div>
                    <div class="form-group">
                        <label>Floor</label>
                        <input type="number" name="floor" placeholder="e.g. 1" required />
                    </div>
                    <button type="submit" class="btn btn-primary">Add Bed</button>
                </div>
            </form>
        </div>

        <!-- Beds Table -->
        <div class="card">
            <div class="card-header">
                <h3>All Beds</h3>
            </div>
            <% if (beds == null || beds.isEmpty()) { %>
                <div class="empty-state">
                    <div class="icon">🛏️</div>
                    <p>No beds added yet.</p>
                </div>
            <% } else { %>
                <table>
                    <tr>
                        <th>ID</th>
                        <th>Bed Number</th>
                        <th>Ward</th>
                        <th>Floor</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    <% for (Bed bed : beds) { %>
                    <tr>
                        <td>#<%= bed.getId() %></td>
                        <td><strong><%= bed.getBedNumber() %></strong></td>
                        <td><%= bed.getWard() %></td>
                        <td>Floor <%= bed.getFloor() %></td>
                        <td>
                            <% if ("AVAILABLE".equals(bed.getStatus())) { %>
                                <span class="badge green">Available</span>
                            <% } else if ("OCCUPIED".equals(bed.getStatus())) { %>
                                <span class="badge red">Occupied</span>
                            <% } else { %>
                                <span class="badge orange">Maintenance</span>
                            <% } %>
                        </td>
                        <td>
                            <form action="/admin/resources/beds/status" method="post" class="inline-form">
                                <input type="hidden" name="id" value="<%= bed.getId() %>" />
                                <select name="status" style="min-width:80px">
                                    <option value="AVAILABLE">Available</option>
                                    <option value="OCCUPIED">Occupied</option>
                                    <option value="MAINTENANCE">Maintenance</option>
                                </select>
                                <button type="submit" class="btn btn-success btn-sm">Update</button>
                            </form>
                            <form action="/admin/resources/beds/delete" method="post" class="inline-form"
                                  onsubmit="return confirm('Delete this bed?')">
                                <input type="hidden" name="id" value="<%= bed.getId() %>" />
                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
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

        <div class="stats-row">
            <div class="stat-card">
                <div class="value"><%= totalIcu %></div>
                <div class="label">Total ICU Units</div>
            </div>
            <div class="stat-card">
                <div class="value"><%= availableIcu %></div>
                <div class="label">Available</div>
            </div>
            <div class="stat-card">
                <div class="value"><%= occupiedIcu %></div>
                <div class="label">Occupied</div>
            </div>
        </div>

        <div class="add-form">
            <h4>➕ Add New ICU Unit</h4>
            <form action="/admin/resources/icu/add" method="post">
                <div class="form-row">
                    <div class="form-group">
                        <label>Ventilator Support</label>
                        <select name="ventilator">
                            <option value="true">Yes</option>
                            <option value="false">No</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary">Add ICU Unit</button>
                </div>
            </form>
        </div>

        <div class="card">
            <div class="card-header"><h3>All ICU Units</h3></div>
            <% if (icus == null || icus.isEmpty()) { %>
                <div class="empty-state">
                    <div class="icon">🏥</div>
                    <p>No ICU units added yet.</p>
                </div>
            <% } else { %>
                <table>
                    <tr>
                        <th>ID</th>
                        <th>Ventilator</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    <% for (Icu icu : icus) { %>
                    <tr>
                        <td>#<%= icu.getId() %></td>
                        <td><%= icu.getVentilator() ? "✅ Yes" : "❌ No" %></td>
                        <td>
                            <% if ("AVAILABLE".equals(icu.getStatus())) { %>
                                <span class="badge green">Available</span>
                            <% } else if ("OCCUPIED".equals(icu.getStatus())) { %>
                                <span class="badge red">Occupied</span>
                            <% } else { %>
                                <span class="badge orange">Maintenance</span>
                            <% } %>
                        </td>
                        <td>
                            <form action="/admin/resources/icu/status" method="post" class="inline-form">
                                <input type="hidden" name="id" value="<%= icu.getId() %>" />
                                <select name="status">
                                    <option value="AVAILABLE">Available</option>
                                    <option value="OCCUPIED">Occupied</option>
                                    <option value="MAINTENANCE">Maintenance</option>
                                </select>
                                <button type="submit" class="btn btn-success btn-sm">Update</button>
                            </form>
                            <form action="/admin/resources/icu/delete" method="post" class="inline-form"
                                  onsubmit="return confirm('Delete this ICU unit?')">
                                <input type="hidden" name="id" value="<%= icu.getId() %>" />
                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
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

        <div class="stats-row">
            <div class="stat-card">
                <div class="value"><%= totalOt %></div>
                <div class="label">Total OTs</div>
            </div>
            <div class="stat-card">
                <div class="value"><%= availableOt %></div>
                <div class="label">Available</div>
            </div>
            <div class="stat-card">
                <div class="value"><%= totalOt - availableOt %></div>
                <div class="label">In Use / Maintenance</div>
            </div>
        </div>

        <div class="add-form">
            <h4>➕ Add New Operation Theatre</h4>
            <form action="/admin/resources/ot/add" method="post">
                <div class="form-row">
                    <button type="submit" class="btn btn-primary">Add OT</button>
                </div>
            </form>
        </div>

        <div class="card">
            <div class="card-header"><h3>All Operation Theatres</h3></div>
            <% if (ots == null || ots.isEmpty()) { %>
                <div class="empty-state">
                    <div class="icon">🔬</div>
                    <p>No OTs added yet.</p>
                </div>
            <% } else { %>
                <table>
                    <tr>
                        <th>OT ID</th>
                        <th>Name</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    <% for (Ot ot : ots) { %>
                    <tr>
                        <td>#<%= ot.getId() %></td>
                        <td><strong>OT-<%= ot.getId() %></strong></td>
                        <td>
                            <% if ("AVAILABLE".equals(ot.getStatus())) { %>
                                <span class="badge green">Available</span>
                            <% } else if ("OCCUPIED".equals(ot.getStatus())) { %>
                                <span class="badge red">In Use</span>
                            <% } else { %>
                                <span class="badge orange">Maintenance</span>
                            <% } %>
                        </td>
                        <td>
                            <form action="/admin/resources/ot/status" method="post" class="inline-form">
                                <input type="hidden" name="id" value="<%= ot.getId() %>" />
                                <select name="status">
                                    <option value="AVAILABLE">Available</option>
                                    <option value="OCCUPIED">In Use</option>
                                    <option value="MAINTENANCE">Maintenance</option>
                                </select>
                                <button type="submit" class="btn btn-success btn-sm">Update</button>
                            </form>
                            <form action="/admin/resources/ot/delete" method="post" class="inline-form"
                                  onsubmit="return confirm('Delete this OT?')">
                                <input type="hidden" name="id" value="<%= ot.getId() %>" />
                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </table>
            <% } %>
        </div>

    <% } %>

    <!-- ═══ OXYGEN TAB ═══ -->
    <% if ("oxygen".equals(activeTab)) { %>

        <div class="stats-row">
            <div class="stat-card">
                <div class="value"><%= totalOxygen %></div>
                <div class="label">Total Tanks</div>
            </div>
            <div class="stat-card">
                <div class="value"><%= availableOxygen %></div>
                <div class="label">Available</div>
            </div>
            <div class="stat-card">
                <div class="value"><%= totalOxygen - availableOxygen %></div>
                <div class="label">In Use / Empty</div>
            </div>
        </div>

        <div class="add-form">
            <h4>➕ Add New Oxygen Tank</h4>
            <form action="/admin/resources/oxygen/add" method="post">
                <div class="form-row">
                    <div class="form-group">
                        <label>Tank Number</label>
                        <input type="number" name="tankNo" placeholder="e.g. 101" required />
                    </div>
                    <div class="form-group">
                        <label>Capacity (L)</label>
                        <input type="number" name="capacity" placeholder="e.g. 50" required />
                    </div>
                    <div class="form-group">
                        <label>Current Level (L)</label>
                        <input type="number" step="0.1" name="currentLevel" placeholder="e.g. 45.5" required />
                    </div>
                    <button type="submit" class="btn btn-primary">Add Tank</button>
                </div>
            </form>
        </div>

        <div class="card">
            <div class="card-header"><h3>All Oxygen Tanks</h3></div>
            <% if (oxygenTanks == null || oxygenTanks.isEmpty()) { %>
                <div class="empty-state">
                    <div class="icon">🫁</div>
                    <p>No oxygen tanks added yet.</p>
                </div>
            <% } else { %>
                <table>
                    <tr>
                        <th>Tank No</th>
                        <th>Capacity</th>
                        <th>Current Level</th>
                        <th>Fill %</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    <% for (OxygenTank tank : oxygenTanks) { %>
                    <%
                        float fillPct = tank.getCapacity() != null && tank.getCapacity() > 0
                            ? (tank.getCurrentLevel() / tank.getCapacity()) * 100 : 0;
                    %>
                    <tr>
                        <td><strong>Tank #<%= tank.getTankNo() %></strong></td>
                        <td><%= tank.getCapacity() %> L</td>
                        <td><%= tank.getCurrentLevel() %> L</td>
                        <td>
                            <span class="badge <%= fillPct > 50 ? "green" : fillPct > 20 ? "orange" : "red" %>">
                                <%= String.format("%.0f", fillPct) %>%
                            </span>
                        </td>
                        <td>
                            <% if ("AVAILABLE".equals(tank.getStatus())) { %>
                                <span class="badge green">Available</span>
                            <% } else if ("IN_USE".equals(tank.getStatus())) { %>
                                <span class="badge orange">In Use</span>
                            <% } else { %>
                                <span class="badge red">Empty</span>
                            <% } %>
                        </td>
                        <td>
                            <form action="/admin/resources/oxygen/update" method="post" class="inline-form">
                                <input type="hidden" name="id" value="<%= tank.getId() %>" />
                                <input type="number" step="0.1" name="currentLevel"
                                       value="<%= tank.getCurrentLevel() %>" style="width:80px" />
                                <select name="status">
                                    <option value="AVAILABLE">Available</option>
                                    <option value="IN_USE">In Use</option>
                                    <option value="EMPTY">Empty</option>
                                </select>
                                <button type="submit" class="btn btn-success btn-sm">Update</button>
                            </form>
                            <form action="/admin/resources/oxygen/delete" method="post" class="inline-form"
                                  onsubmit="return confirm('Delete this tank?')">
                                <input type="hidden" name="id" value="<%= tank.getId() %>" />
                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </table>
            <% } %>
        </div>

    <% } %>

    <!-- ═══ BLOOD BANK TAB ═══ -->
    <% if ("blood".equals(activeTab)) { %>

        <div class="add-form">
            <h4>➕ Add Blood Component</h4>
            <form action="/admin/resources/blood/add" method="post">
                <div class="form-row">
                    <div class="form-group">
                        <label>Component</label>
                        <select name="component" required>
                            <option value="" disabled selected>Select</option>
                            <option value="Red Blood Cells">Red Blood Cells</option>
                            <option value="Platelets">Platelets</option>
                            <option value="Fresh Frozen Plasma">Fresh Frozen Plasma</option>
                            <option value="Cryoprecipitate">Cryoprecipitate</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Blood Group</label>
                        <select name="bloodGroup" required>
                            <option value="" disabled selected>Select</option>
                            <option value="A+">A+</option>
                            <option value="A-">A-</option>
                            <option value="B+">B+</option>
                            <option value="B-">B-</option>
                            <option value="O+">O+</option>
                            <option value="O-">O-</option>
                            <option value="AB+">AB+</option>
                            <option value="AB-">AB-</option>
                            <option value="ANY">ANY</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Units</label>
                        <input type="number" name="quantityUnits" placeholder="e.g. 10" required />
                    </div>
                    <div class="form-group">
                        <label>Collection Date</label>
                        <input type="date" name="collectionDate" required />
                    </div>
                    <div class="form-group">
                        <label>Expiry Date</label>
                        <input type="date" name="expiryDate" required />
                    </div>
                    <button type="submit" class="btn btn-primary">Add</button>
                </div>
            </form>
        </div>

        <div class="card">
            <div class="card-header"><h3>Blood Bank Inventory</h3></div>
            <% if (bloodBanks == null || bloodBanks.isEmpty()) { %>
                <div class="empty-state">
                    <div class="icon">🩸</div>
                    <p>No blood components added yet.</p>
                </div>
            <% } else { %>
                <table>
                    <tr>
                        <th>ID</th>
                        <th>Component</th>
                        <th>Blood Group</th>
                        <th>Units</th>
                        <th>Collection</th>
                        <th>Expiry</th>
                        <th>Days Left</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    <% for (BloodBank b : bloodBanks) { %>
                    <tr>
                        <td>#<%= b.getId() %></td>
                        <td><%= b.getComponent() %></td>
                        <td><strong><%= b.getBloodGroup() %></strong></td>
                        <td><%= b.getQuantityUnits() %> units</td>
                        <td><%= b.getCollectionDate() %></td>
                        <td><%= b.getExpiryDate() %></td>
                        <td>
                            <span class="badge <%= b.getDaysUntilExpiry() > 7 ? "green" : b.getDaysUntilExpiry() > 0 ? "orange" : "red" %>">
                                <%= b.isExpired() ? "Expired" : b.getDaysUntilExpiry() + " days" %>
                            </span>
                        </td>
                        <td>
                            <% if ("AVAILABLE".equals(b.getStatus())) { %>
                                <span class="badge green">Available</span>
                            <% } else { %>
                                <span class="badge red"><%= b.getStatus() %></span>
                            <% } %>
                        </td>
                        <td>
                            <form action="/admin/resources/blood/update" method="post" class="inline-form">
                                <input type="hidden" name="id" value="<%= b.getId() %>" />
                                <input type="number" name="quantityUnits"
                                       value="<%= b.getQuantityUnits() %>" style="width:60px" />
                                <select name="status">
                                    <option value="AVAILABLE">Available</option>
                                    <option value="RESERVED">Reserved</option>
                                    <option value="EXPIRED">Expired</option>
                                </select>
                                <button type="submit" class="btn btn-success btn-sm">Update</button>
                            </form>
                            <form action="/admin/resources/blood/delete" method="post" class="inline-form"
                                  onsubmit="return confirm('Delete this record?')">
                                <input type="hidden" name="id" value="<%= b.getId() %>" />
                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
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