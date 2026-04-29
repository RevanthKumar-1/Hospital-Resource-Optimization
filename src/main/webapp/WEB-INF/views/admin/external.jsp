<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - External Sources</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #fdf4f4; }

        .sidebar { width: 240px; background: white; height: 100vh; position: fixed; top: 0; left: 0; border-right: 3px solid #e53935; box-shadow: 2px 0 8px rgba(0,0,0,0.06); display: flex; flex-direction: column; }
        .sidebar-logo { padding: 24px 20px; font-size: 20px; font-weight: 700; color: #333; border-bottom: 1px solid #f5f5f5; }
        .sidebar-logo span { color: #e53935; }
        .sidebar-menu { flex: 1; padding: 16px 0; }
        .menu-label { font-size: 10px; text-transform: uppercase; color: #bbb; padding: 8px 20px; font-weight: 600; letter-spacing: 1px; }
        .sidebar-menu a { display: flex; align-items: center; gap: 12px; color: #555; text-decoration: none; padding: 12px 20px; font-size: 14px; transition: all 0.2s; border-left: 3px solid transparent; }
        .sidebar-menu a:hover { background: #fdecea; color: #e53935; border-left-color: #e53935; }
        .sidebar-menu a.active { background: #fdecea; color: #e53935; border-left-color: #e53935; font-weight: 600; }
        .sidebar-bottom { padding: 16px 20px; border-top: 1px solid #f5f5f5; }
        .logout-btn { display: flex; align-items: center; gap: 10px; color: #e53935; text-decoration: none; font-size: 14px; font-weight: 600; padding: 10px 14px; border-radius: 8px; }
        .logout-btn:hover { background: #fdecea; }

        .navbar { margin-left: 240px; background: white; padding: 16px 36px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #f0f0f0; box-shadow: 0 2px 8px rgba(0,0,0,0.04); position: sticky; top: 0; z-index: 10; }
        .navbar h2 { font-size: 20px; color: #333; font-weight: 700; }

        .main { margin-left: 240px; padding: 32px 36px; }

        .note { background: #e3f2fd; color: #1565c0; padding: 14px 18px; border-radius: 10px; font-size: 14px; margin-bottom: 24px; }

        /* Search Bar */
        .search-section {
            background: white; border-radius: 14px; padding: 24px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06); margin-bottom: 28px;
        }
        .search-section h3 { font-size: 16px; font-weight: 700; color: #333; margin-bottom: 16px; }
        .search-row { display: flex; gap: 12px; align-items: center; }
        .search-row select, .search-row input {
            padding: 10px 14px; border: 1.5px solid #e0e0e0;
            border-radius: 8px; font-size: 14px; outline: none;
            transition: border 0.2s; background: white;
        }
        .search-row select:focus, .search-row input:focus { border-color: #e53935; }
        .search-row input { flex: 1; }
        .search-btn {
            padding: 10px 24px; background: #e53935; color: white;
            border: none; border-radius: 8px; font-size: 14px;
            font-weight: 600; cursor: pointer;
        }
        .search-btn:hover { background: #c62828; }

        .tabs { display: flex; gap: 8px; margin-bottom: 24px; }
        .tab-btn { padding: 10px 20px; border-radius: 8px; border: 2px solid #e0e0e0; background: white; color: #666; font-size: 14px; font-weight: 600; cursor: pointer; text-decoration: none; transition: all 0.2s; }
        .tab-btn:hover { border-color: #e53935; color: #e53935; }
        .tab-btn.active { background: #e53935; color: white; border-color: #e53935; }

        .source-card {
            background: white; border-radius: 14px; padding: 20px 24px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06); margin-bottom: 16px;
            display: flex; justify-content: space-between; align-items: center;
            border-left: 5px solid #e53935; transition: transform 0.2s;
        }
        .source-card:hover { transform: translateY(-2px); }
        .source-info { flex: 1; }
        .source-name { font-size: 16px; font-weight: 700; color: #333; }
        .source-address { font-size: 13px; color: #888; margin-top: 4px; }
        .source-tags { display: flex; gap: 8px; margin-top: 8px; flex-wrap: wrap; }

        .source-meta { text-align: right; min-width: 160px; }
        .source-distance { font-size: 18px; font-weight: 700; color: #e53935; }
        .source-distance-label { font-size: 11px; color: #aaa; }
        .source-price { font-size: 14px; font-weight: 600; color: #2e7d32; margin-top: 6px; }
        .source-availability { font-size: 12px; color: #888; margin-top: 2px; }

        .contact-btn {
            padding: 8px 16px; background: #fdecea; color: #e53935;
            border: none; border-radius: 8px; font-size: 13px;
            font-weight: 600; cursor: pointer; margin-top: 8px;
            text-decoration: none; display: inline-block;
        }
        .contact-btn:hover { background: #e53935; color: white; }

        .badge { padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; }
        .badge.green { background: #e8f5e9; color: #2e7d32; }
        .badge.red { background: #fdecea; color: #c62828; }
        .badge.orange { background: #fff3e0; color: #e65100; }
        .badge.blue { background: #e3f2fd; color: #1565c0; }

        .sort-row {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 16px;
        }
        .sort-row span { font-size: 14px; color: #888; }
        .sort-row select { padding: 6px 12px; border: 1.5px solid #e0e0e0; border-radius: 8px; font-size: 13px; outline: none; }
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
        <a href="/admin/labs">🔬 Labs</a>
        <a href="/admin/external" class="active">🌐 External Sources</a>
    </div>
    <div class="sidebar-bottom">
        <a href="/logout" class="logout-btn">🚪 Logout</a>
    </div>
</div>

<!-- Navbar -->
<div class="navbar">
    <h2>🌐 External Sources</h2>
</div>

<!-- Main -->
<div class="main">

    <div class="note">
        ℹ️ This page will connect to live APIs for real-time data in a future update.
        Results below are sorted by distance from the hospital by default.
    </div>

    <!-- Search -->
    <div class="search-section">
        <h3>🔍 Search for Blood Components or Medicines</h3>
        <div class="search-row">
            <select>
                <option>Blood Bank</option>
                <option>Pharmacy</option>
            </select>
            <input type="text" placeholder="e.g. O+ Red Blood Cells, Paracetamol 500mg..." />
            <button class="search-btn">Search</button>
        </div>
    </div>

    <!-- Tabs -->
    <div class="tabs">
        <a href="#" class="tab-btn active" onclick="showTab('blood', this)">🩸 Blood Banks</a>
        <a href="#" class="tab-btn" onclick="showTab('pharmacy', this)">💊 Pharmacies</a>
    </div>

    <!-- Blood Banks -->
    <div id="blood-tab">

        <div class="sort-row">
            <span>Showing 5 blood banks near hospital</span>
            <select onchange="sortSources(this.value)">
                <option value="distance">Sort by Distance</option>
                <option value="price">Sort by Price</option>
                <option value="availability">Sort by Availability</option>
            </select>
        </div>

        <div class="source-card">
            <div class="source-info">
                <div class="source-name">City Blood Bank</div>
                <div class="source-address">📍 12 MG Road, Bengaluru — 1.2 km away</div>
                <div class="source-tags">
                    <span class="badge green">O+ Available</span>
                    <span class="badge green">A+ Available</span>
                    <span class="badge red">AB- Not Available</span>
                </div>
                <a href="#" class="contact-btn">📞 Contact: 080-2345-6789</a>
            </div>
            <div class="source-meta">
                <div class="source-distance">1.2 km</div>
                <div class="source-distance-label">from hospital</div>
                <div class="source-price">₹1,200 / unit</div>
                <div class="source-availability">Open 24/7</div>
            </div>
        </div>

        <div class="source-card">
            <div class="source-info">
                <div class="source-name">Red Cross Blood Centre</div>
                <div class="source-address">📍 45 Brigade Road, Bengaluru — 2.8 km away</div>
                <div class="source-tags">
                    <span class="badge green">All Groups Available</span>
                    <span class="badge blue">Platelets Available</span>
                </div>
                <a href="#" class="contact-btn">📞 Contact: 080-9876-5432</a>
            </div>
            <div class="source-meta">
                <div class="source-distance">2.8 km</div>
                <div class="source-distance-label">from hospital</div>
                <div class="source-price">₹1,050 / unit</div>
                <div class="source-availability">Open 8AM–10PM</div>
            </div>
        </div>

        <div class="source-card">
            <div class="source-info">
                <div class="source-name">Apollo Blood Bank</div>
                <div class="source-address">📍 Apollo Hospital, Bannerghatta Road — 4.1 km away</div>
                <div class="source-tags">
                    <span class="badge green">O+ Available</span>
                    <span class="badge green">B+ Available</span>
                    <span class="badge orange">A- Limited</span>
                </div>
                <a href="#" class="contact-btn">📞 Contact: 080-1122-3344</a>
            </div>
            <div class="source-meta">
                <div class="source-distance">4.1 km</div>
                <div class="source-distance-label">from hospital</div>
                <div class="source-price">₹1,400 / unit</div>
                <div class="source-availability">Open 24/7</div>
            </div>
        </div>

        <div class="source-card">
            <div class="source-info">
                <div class="source-name">Manipal Blood Centre</div>
                <div class="source-address">📍 Old Airport Road, Bengaluru — 5.6 km away</div>
                <div class="source-tags">
                    <span class="badge green">FFP Available</span>
                    <span class="badge green">Platelets Available</span>
                    <span class="badge red">O- Not Available</span>
                </div>
                <a href="#" class="contact-btn">📞 Contact: 080-5566-7788</a>
            </div>
            <div class="source-meta">
                <div class="source-distance">5.6 km</div>
                <div class="source-distance-label">from hospital</div>
                <div class="source-price">₹990 / unit</div>
                <div class="source-availability">Open 24/7</div>
            </div>
        </div>

    </div>

    <!-- Pharmacies (hidden by default) -->
    <div id="pharmacy-tab" style="display:none">

        <div class="sort-row">
            <span>Showing 4 pharmacies near hospital</span>
            <select>
                <option value="distance">Sort by Distance</option>
                <option value="price">Sort by Price</option>
                <option value="availability">Sort by Availability</option>
            </select>
        </div>

        <div class="source-card">
            <div class="source-info">
                <div class="source-name">MedPlus Pharmacy</div>
                <div class="source-address">📍 Ground Floor, Hospital Complex — 0.1 km away</div>
                <div class="source-tags">
                    <span class="badge green">In Stock</span>
                    <span class="badge blue">Home Delivery</span>
                </div>
                <a href="#" class="contact-btn">📞 Contact: 080-1111-2222</a>
            </div>
            <div class="source-meta">
                <div class="source-distance">0.1 km</div>
                <div class="source-distance-label">from hospital</div>
                <div class="source-price">Market Price</div>
                <div class="source-availability">Open 7AM–11PM</div>
            </div>
        </div>

        <div class="source-card">
            <div class="source-info">
                <div class="source-name">Apollo Pharmacy</div>
                <div class="source-address">📍 15 Park Street, Bengaluru — 0.8 km away</div>
                <div class="source-tags">
                    <span class="badge green">In Stock</span>
                    <span class="badge green">Generics Available</span>
                    <span class="badge blue">Home Delivery</span>
                </div>
                <a href="#" class="contact-btn">📞 Contact: 080-3333-4444</a>
            </div>
            <div class="source-meta">
                <div class="source-distance">0.8 km</div>
                <div class="source-distance-label">from hospital</div>
                <div class="source-price">10% Discount</div>
                <div class="source-availability">Open 24/7</div>
            </div>
        </div>

        <div class="source-card">
            <div class="source-info">
                <div class="source-name">Netmeds Local Store</div>
                <div class="source-address">📍 22 Commercial Street — 1.4 km away</div>
                <div class="source-tags">
                    <span class="badge orange">Limited Stock</span>
                    <span class="badge blue">Online Order</span>
                </div>
                <a href="#" class="contact-btn">📞 Contact: 080-5555-6666</a>
            </div>
            <div class="source-meta">
                <div class="source-distance">1.4 km</div>
                <div class="source-distance-label">from hospital</div>
                <div class="source-price">15% Cheaper</div>
                <div class="source-availability">Open 9AM–9PM</div>
            </div>
        </div>

        <div class="source-card">
            <div class="source-info">
                <div class="source-name">Wellness Forever</div>
                <div class="source-address">📍 35 Residency Road — 2.1 km away</div>
                <div class="source-tags">
                    <span class="badge green">In Stock</span>
                    <span class="badge green">Surgical Supplies</span>
                </div>
                <a href="#" class="contact-btn">📞 Contact: 080-7777-8888</a>
            </div>
            <div class="source-meta">
                <div class="source-distance">2.1 km</div>
                <div class="source-distance-label">from hospital</div>
                <div class="source-price">Market Price</div>
                <div class="source-availability">Open 8AM–10PM</div>
            </div>
        </div>

    </div>

</div>

<script>
    function showTab(tab, btn) {
        document.getElementById('blood-tab').style.display = tab === 'blood' ? 'block' : 'none';
        document.getElementById('pharmacy-tab').style.display = tab === 'pharmacy' ? 'block' : 'none';
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
    }

    function sortSources(by) {
        // Static page - sorting will be implemented with real data
        console.log('Sort by:', by);
    }
</script>

</body>
</html>