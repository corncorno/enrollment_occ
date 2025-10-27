<?php
require_once '../config/database.php';
require_once '../config/session_helper.php';
require_once '../classes/Admin.php';
require_once '../classes/User.php';
require_once '../classes/Curriculum.php';
require_once '../classes/Section.php';
require_once '../classes/Chatbot.php';

// Check if user is logged in and is an admin
if (!isLoggedIn() || !isAdmin()) {
    redirect('public/login.php');
}

$admin = new Admin();
$user = new User();
$curriculum = new Curriculum();
$section = new Section();
$chatbot = new Chatbot();

// Validate session against admins table to prevent session confusion
$current_admin_info = $admin->getAdminById($_SESSION['user_id']);
if (!$current_admin_info) {
    // Admin not found in database, logout
    session_destroy();
    redirect('public/login.php');
}

// Update session role if it somehow got corrupted
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'admin') {
    $_SESSION['role'] = 'admin';
}

// Update session to ensure admin flag is set
if (!isset($_SESSION['is_admin']) || $_SESSION['is_admin'] !== true) {
    $_SESSION['is_admin'] = true;
}

$all_users = $user->getAllUsers();
$all_programs = $curriculum->getAllPrograms();
$all_sections = $section->getAllSections();

// Get all student document checklists
$db = new Database();
$conn = $db->getConnection();
$checklist_query = "SELECT dc.*, u.student_id, u.first_name, u.last_name, u.enrollment_status 
                    FROM users u 
                    LEFT JOIN document_checklists dc ON u.id = dc.user_id 
                    WHERE u.role = 'student' 
                    ORDER BY u.last_name, u.first_name";
$stmt = $conn->prepare($checklist_query);
$stmt->execute();
$all_checklists = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Get enrolled students with their details and program information from assigned sections
$enrolled_query = "SELECT es.*, u.first_name, u.last_name, u.email, u.phone, u.status, u.created_at,
                   GROUP_CONCAT(DISTINCT p.program_code ORDER BY p.program_code SEPARATOR ', ') as program_codes,
                   GROUP_CONCAT(DISTINCT p.program_name ORDER BY p.program_code SEPARATOR ', ') as program_names,
                   GROUP_CONCAT(DISTINCT s.year_level ORDER BY s.year_level SEPARATOR ', ') as section_year_levels,
                   GROUP_CONCAT(DISTINCT s.semester ORDER BY s.semester SEPARATOR ', ') as section_semesters,
                   GROUP_CONCAT(DISTINCT s.academic_year ORDER BY s.academic_year SEPARATOR ', ') as section_academic_years
                   FROM enrolled_students es
                   JOIN users u ON es.user_id = u.id
                   LEFT JOIN section_enrollments se ON u.id = se.user_id AND se.status = 'active'
                   LEFT JOIN sections s ON se.section_id = s.id
                   LEFT JOIN programs p ON s.program_id = p.id
                   GROUP BY es.user_id, es.id, u.first_name, u.last_name, u.email, u.phone, u.status, u.created_at,
                            es.course, es.year_level, es.student_type, es.academic_year, es.semester, es.enrolled_date
                   ORDER BY es.enrolled_date DESC";
$enrolled_stmt = $conn->prepare($enrolled_query);
$enrolled_stmt->execute();
$all_enrolled_students = $enrolled_stmt->fetchAll(PDO::FETCH_ASSOC);

// Get section assignments for all students
$section_assignments_query = "SELECT se.user_id, se.section_id, se.enrolled_date,
                               s.section_name, s.year_level, s.semester, s.academic_year,
                               p.program_code, p.program_name
                               FROM section_enrollments se
                               JOIN sections s ON se.section_id = s.id
                               JOIN programs p ON s.program_id = p.id
                               WHERE se.status = 'active'";
$section_assignments_stmt = $conn->prepare($section_assignments_query);
$section_assignments_stmt->execute();
$section_assignments_raw = $section_assignments_stmt->fetchAll(PDO::FETCH_ASSOC);

// Group section assignments by user_id
$section_assignments = [];
foreach ($section_assignments_raw as $assignment) {
    $user_id = $assignment['user_id'];
    if (!isset($section_assignments[$user_id])) {
        $section_assignments[$user_id] = [];
    }
    $section_assignments[$user_id][] = $assignment;
}

$message = '';
if (isset($_SESSION['message'])) {
    $message = $_SESSION['message'];
    unset($_SESSION['message']);
}

// Count statistics
$total_students = count(array_filter($all_users, function($u) { return $u['role'] == 'student'; }));
$active_students = count(array_filter($all_users, function($u) { return $u['role'] == 'student' && $u['status'] == 'active'; }));
$pending_students = count(array_filter($all_users, function($u) { return $u['role'] == 'student' && ($u['enrollment_status'] ?? 'pending') == 'pending'; }));
$enrolled_students = count($all_enrolled_students);

// Get total courses from curriculum
$curriculum_courses_query = "SELECT COUNT(DISTINCT course_code) as total FROM curriculum";
$curriculum_courses_stmt = $conn->prepare($curriculum_courses_query);
$curriculum_courses_stmt->execute();
$total_courses = $curriculum_courses_stmt->fetch(PDO::FETCH_ASSOC)['total'];

// Course enrollments = enrolled students count
$total_enrollments = $enrolled_students;

// Get latest enrollments from enrolled_students
$latest_enrollments_query = "SELECT es.*, u.first_name, u.last_name, u.student_id, u.email
                             FROM enrolled_students es
                             JOIN users u ON es.user_id = u.id
                             ORDER BY es.enrolled_date DESC
                             LIMIT 5";
$latest_enrollments_stmt = $conn->prepare($latest_enrollments_query);
$latest_enrollments_stmt->execute();
$latest_enrollments = $latest_enrollments_stmt->fetchAll(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - <?php echo SITE_NAME; ?></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .sidebar {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            min-height: 100vh;
            color: white;
        }
        .nav-link {
            color: rgba(255,255,255,0.8);
            border-radius: 10px;
            margin: 5px 0;
        }
        .nav-link:hover, .nav-link.active {
            background: rgba(255,255,255,0.2);
            color: white;
        }
        .card {
            border: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-radius: 15px;
        }
        .card-header {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
        }
        .stat-card {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: white;
            border-radius: 15px;
        }
        .btn-action {
            border-radius: 20px;
            padding: 5px 15px;
            margin: 2px;
        }
        
        /* Filter Section Styles */
        .filter-card {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .filter-card .card-header {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: white;
            border-radius: 8px 8px 0 0;
            transition: background-color 0.3s ease;
        }
        
        .filter-card .card-header:hover {
            background: linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%);
        }
        
        #filter-toggle-icon {
            transition: transform 0.3s ease;
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
            font-size: 0.9rem;
        }
        
        .form-select:focus, .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .input-group-text {
            background-color: #f8f9fa;
            border-color: #ced4da;
        }
        
        /* Sortable Column Headers */
        th[data-sort] {
            position: relative;
            user-select: none;
        }
        
        th[data-sort]:hover {
            background-color: rgba(255,255,255,0.1);
        }
        
        th[data-sort] i {
            opacity: 0.5;
            margin-left: 5px;
        }
        
        th[data-sort]:hover i {
            opacity: 0.8;
        }
        
        /* No Results Styling */
        #no-results {
            background-color: #f8f9fa;
            border-radius: 8px;
            border: 2px dashed #dee2e6;
        }
        
        /* Responsive Filter Layout */
        @media (max-width: 768px) {
            .filter-card .row .col-md-2 {
                margin-bottom: 1rem;
            }
        }
        
        /* Filter Summary */
        .filter-summary {
            background-color: #e9ecef;
            border-radius: 4px;
            padding: 8px 12px;
            font-size: 0.875rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar p-3">
                <div class="text-center mb-4">
                    <i class="fas fa-cog fa-3x mb-2"></i>
                    <h5>Admin Panel</h5>
                </div>
                
                <div class="mb-4">
                    <h6 class="text-white-50">Welcome,</h6>
                    <h5><?php echo $_SESSION['first_name'] . ' ' . $_SESSION['last_name']; ?></h5>
                    <small class="text-white-50">ID: <?php echo $_SESSION['admin_id'] ?? 'N/A'; ?></small><br>
                    <small class="text-white-50">Registrar/Admin</small>
                </div>
                
                <nav class="nav flex-column">
                    <a href="#" class="nav-link active" onclick="showSection('dashboard')">
                        <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                    </a>
                    <a href="#" class="nav-link" onclick="showSection('pending-students')">
                        <i class="fas fa-user-clock me-2"></i>Pending Students
                    </a>
                    <a href="#" class="nav-link" onclick="showSection('enrolled-students')">
                        <i class="fas fa-user-graduate me-2"></i>Enrolled Students
                    </a>
                    <a href="#" class="nav-link" onclick="showSection('sections')">
                        <i class="fas fa-users-class me-2"></i>Sections
                    </a>
                    <a href="#" class="nav-link" onclick="showSection('documents')">
                        <i class="fas fa-file-alt me-2"></i>Document Checklists
                    </a>
                    <a href="#" class="nav-link" onclick="showSection('curriculum')">
                        <i class="fas fa-graduation-cap me-2"></i>Curriculum
                    </a>
                    <a href="#" class="nav-link" onclick="showSection('chatbot')">
                        <i class="fas fa-robot me-2"></i>Chatbot FAQs
                    </a>
                    <a href="bulk_import.php" class="nav-link">
                        <i class="fas fa-file-import me-2"></i>Bulk Import
                    </a>
                    <a href="../student/logout.php" class="nav-link">
                        <i class="fas fa-sign-out-alt me-2"></i>Logout
                    </a>
                </nav>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 p-4">
                <?php if ($message): ?>
                    <div class="alert alert-info alert-dismissible fade show" role="alert">
                        <?php echo $message; ?>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <?php endif; ?>
                
                <!-- Dashboard Section -->
                <div id="dashboard" class="content-section">
                    <h2 class="mb-4">Admin Dashboard</h2>
                    
                    <div class="row mb-4">
                        <div class="col-md-3 mb-3">
                            <div class="card stat-card text-center">
                                <div class="card-body">
                                    <i class="fas fa-user-clock fa-3x mb-3"></i>
                                    <h3><?php echo $pending_students; ?></h3>
                                    <p class="mb-0">Pending Students</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card stat-card text-center">
                                <div class="card-body">
                                    <i class="fas fa-user-graduate fa-3x mb-3"></i>
                                    <h3><?php echo $enrolled_students; ?></h3>
                                    <p class="mb-0">Enrolled Students</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card stat-card text-center">
                                <div class="card-body">
                                    <i class="fas fa-book fa-3x mb-3"></i>
                                    <h3><?php echo $total_courses; ?></h3>
                                    <p class="mb-0">Total Courses</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card stat-card text-center">
                                <div class="card-body">
                                    <i class="fas fa-clipboard-list fa-3x mb-3"></i>
                                    <h3><?php echo $total_enrollments; ?></h3>
                                    <p class="mb-0">Course Enrollments</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0"><i class="fas fa-user-clock me-2"></i>Pending Approvals</h5>
                                </div>
                                <div class="card-body">
                                    <?php if ($pending_students > 0): ?>
                                        <p class="mb-2">You have <strong><?php echo $pending_students; ?></strong> student(s) waiting for approval.</p>
                        <button class="btn btn-warning btn-sm" onclick="showSection('pending-students')">
                                            <i class="fas fa-eye me-1"></i>Review Students
                                        </button>
                                    <?php else: ?>
                                        <p class="text-muted mb-0">No pending approvals at this time.</p>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i>Recent Activity</h5>
                                </div>
                                <div class="card-body">
                                    <p class="mb-1"><strong>Latest Enrollments:</strong></p>
                                    <?php if (empty($latest_enrollments)): ?>
                                        <p class="text-muted mb-0">No recent enrollment activity.</p>
                                    <?php else: ?>
                                        <?php foreach (array_slice($latest_enrollments, 0, 5) as $recent): ?>
                                            <small class="d-block mb-2">
                                                <i class="fas fa-user-graduate text-primary me-1"></i>
                                                <strong><?php echo htmlspecialchars($recent['student_id']); ?></strong> - 
                                                <?php echo htmlspecialchars($recent['first_name'] . ' ' . $recent['last_name']); ?>
                                                <br>
                                                <span class="text-muted ms-3">
                                                    <?php echo !empty($recent['course']) ? htmlspecialchars($recent['course']) : 'Program enrollment'; ?> - 
                                                    <?php echo date('M j, Y', strtotime($recent['enrolled_date'])); ?>
                                                </span>
                                            </small>
                                        <?php endforeach; ?>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Users Management Section (Hidden - Content moved to Pending Students) -->
                <div id="users" class="content-section" style="display: none;">
                    <script>
                        // Redirect to pending students section
                        window.location.hash = 'pending-students';
                        showSection('pending-students');
                    </script>
                </div>
                
        <!-- Sections Management Section -->
        <div id="sections" class="content-section" style="display: none;">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Class Sections</h2>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addSectionModal">
                    <i class="fas fa-plus me-2"></i>Add New Section
                </button>
            </div>
            
            <!-- Filters Section -->
            <div class="card mb-4">
                <div class="card-header" style="cursor: pointer;" onclick="toggleFilters()">
                    <h5 class="mb-0">
                        <i class="fas fa-filter me-2"></i>Filter Sections
                        <i class="fas fa-chevron-down float-end" id="filter-toggle-icon"></i>
                    </h5>
                </div>
                <div class="card-body" id="filter-body" style="display: none;">
                    <div class="row g-3">
                        <!-- Program Filter -->
                        <div class="col-md-2">
                            <label for="filter_program" class="form-label">Program</label>
                            <select class="form-select" id="filter_program" onchange="filterSections()">
                                <option value="">All Programs</option>
                                <?php foreach ($all_programs as $program): ?>
                                    <option value="<?php echo htmlspecialchars($program['program_code']); ?>">
                                        <?php echo htmlspecialchars($program['program_code']); ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        
                        <!-- Year Level Filter -->
                        <div class="col-md-2">
                            <label for="filter_year" class="form-label">Year Level</label>
                            <select class="form-select" id="filter_year" onchange="filterSections()">
                                <option value="">All Years</option>
                                <option value="1st Year">1st Year</option>
                                <option value="2nd Year">2nd Year</option>
                                <option value="3rd Year">3rd Year</option>
                                <option value="4th Year">4th Year</option>
                                <option value="5th Year">5th Year</option>
                            </select>
                        </div>
                        
                        <!-- Semester Filter -->
                        <div class="col-md-2">
                            <label for="filter_semester" class="form-label">Semester</label>
                            <select class="form-select" id="filter_semester" onchange="filterSections()">
                                <option value="">All Semesters</option>
                                <option value="First Semester">First Semester</option>
                                <option value="Second Semester">Second Semester</option>
                                <option value="Summer">Summer</option>
                            </select>
                        </div>
                        
                        <!-- Section Type Filter -->
                        <div class="col-md-2">
                            <label for="filter_type" class="form-label">Section Type</label>
                            <select class="form-select" id="filter_type" onchange="filterSections()">
                                <option value="">All Types</option>
                                <option value="Morning">Morning</option>
                                <option value="Afternoon">Afternoon</option>
                                <option value="Evening">Evening</option>
                            </select>
                        </div>
                        
                        <!-- Status Filter -->
                        <div class="col-md-2">
                            <label for="filter_status" class="form-label">Status</label>
                            <select class="form-select" id="filter_status" onchange="filterSections()">
                                <option value="">All Status</option>
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
                            </select>
                        </div>
                        
                        <!-- Capacity Filter -->
                        <div class="col-md-2">
                            <label for="filter_capacity" class="form-label">Capacity</label>
                            <select class="form-select" id="filter_capacity" onchange="filterSections()">
                                <option value="">All Capacities</option>
                                <option value="available">Has Space</option>
                                <option value="full">Full</option>
                                <option value="almost-full">Almost Full (90%+)</option>
                            </select>
                        </div>
                    </div>
                    
                    <!-- Search and Sort Row -->
                    <div class="row g-3 mt-2">
                        <!-- Search -->
                        <div class="col-md-6">
                            <label for="search_sections" class="form-label">Search Sections</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-search"></i></span>
                                <input type="text" class="form-control" id="search_sections" 
                                       placeholder="Search by section name, program, or room..." 
                                       onkeyup="filterSections()">
                            </div>
                        </div>
                        
                        <!-- Sort Options -->
                        <div class="col-md-3">
                            <label for="sort_sections" class="form-label">Sort By</label>
                            <select class="form-select" id="sort_sections" onchange="filterSections()">
                                <option value="program">Program</option>
                                <option value="year">Year Level</option>
                                <option value="semester">Semester</option>
                                <option value="type">Section Type</option>
                                <option value="capacity">Capacity</option>
                                <option value="enrolled">Enrollment</option>
                                <option value="status">Status</option>
                            </select>
                        </div>
                        
                        <!-- Sort Direction -->
                        <div class="col-md-2">
                            <label for="sort_direction" class="form-label">Direction</label>
                            <select class="form-select" id="sort_direction" onchange="filterSections()">
                                <option value="asc">Ascending</option>
                                <option value="desc">Descending</option>
                            </select>
                        </div>
                        
                        <!-- Clear Filters -->
                        <div class="col-md-1">
                            <label class="form-label">&nbsp;</label>
                            <button type="button" class="btn btn-outline-secondary w-100" onclick="clearFilters()" 
                                    title="Clear all filters">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    </div>
                    
                    <!-- Filter Results Summary -->
                    <div class="mt-3">
                        <small class="text-muted">
                            Showing <span id="filtered-count"><?php echo count($all_sections); ?></span> of 
                            <span id="total-count"><?php echo count($all_sections); ?></span> sections
                        </small>
                    </div>
                </div>
            </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover" id="sections-table">
                            <thead class="table-dark">
                                <tr>
                                    <th data-sort="program">Program <i class="fas fa-sort"></i></th>
                                    <th data-sort="year">Year Level <i class="fas fa-sort"></i></th>
                                    <th data-sort="semester">Semester <i class="fas fa-sort"></i></th>
                                    <th data-sort="section">Section Name <i class="fas fa-sort"></i></th>
                                    <th data-sort="type">Type <i class="fas fa-sort"></i></th>
                                    <th data-sort="capacity">Capacity <i class="fas fa-sort"></i></th>
                                    <th data-sort="enrolled">Enrolled <i class="fas fa-sort"></i></th>
                                    <th data-sort="available">Available <i class="fas fa-sort"></i></th>
                                    <th data-sort="status">Status <i class="fas fa-sort"></i></th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="sections-table-body">
                                <?php foreach ($all_sections as $sec): ?>
                                    <?php 
                                    $available = $sec['max_capacity'] - $sec['current_enrolled'];
                                    $percentage = ($sec['current_enrolled'] / $sec['max_capacity']) * 100;
                                    $status_class = $percentage >= 90 ? 'bg-danger' : ($percentage >= 70 ? 'bg-warning' : 'bg-success');
                                    ?>
                                    <tr class="section-row" 
                                        data-program="<?php echo htmlspecialchars($sec['program_code']); ?>"
                                        data-year="<?php echo htmlspecialchars($sec['year_level']); ?>"
                                        data-semester="<?php echo htmlspecialchars($sec['semester']); ?>"
                                        data-section="<?php echo htmlspecialchars($sec['section_name']); ?>"
                                        data-type="<?php echo htmlspecialchars($sec['section_type']); ?>"
                                        data-capacity="<?php echo $sec['max_capacity']; ?>"
                                        data-enrolled="<?php echo $sec['current_enrolled']; ?>"
                                        data-available="<?php echo $available; ?>"
                                        data-status="<?php echo $sec['status']; ?>"
                                        data-percentage="<?php echo $percentage; ?>"
                                        data-search-text="<?php echo htmlspecialchars(strtolower($sec['program_code'] . ' ' . $sec['year_level'] . ' ' . $sec['semester'] . ' ' . $sec['section_name'] . ' ' . $sec['section_type'])); ?>">
                                        <td><strong><?php echo htmlspecialchars($sec['program_code']); ?></strong></td>
                                        <td><?php echo htmlspecialchars($sec['year_level']); ?></td>
                                        <td><?php echo htmlspecialchars($sec['semester']); ?></td>
                                        <td><?php echo htmlspecialchars($sec['section_name']); ?></td>
                                        <td>
                                            <span class="badge <?php echo $sec['section_type'] == 'Morning' ? 'bg-info' : ($sec['section_type'] == 'Afternoon' ? 'bg-warning' : 'bg-dark'); ?>">
                                                <?php echo htmlspecialchars($sec['section_type']); ?>
                                            </span>
                                        </td>
                                        <td><?php echo $sec['max_capacity']; ?></td>
                                        <td><?php echo $sec['current_enrolled']; ?></td>
                                        <td><span class="badge <?php echo $status_class; ?>"><?php echo $available; ?></span></td>
                                        <td>
                                            <span class="badge <?php echo $sec['status'] == 'active' ? 'bg-success' : 'bg-secondary'; ?>">
                                                <?php echo ucfirst($sec['status']); ?>
                                            </span>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-success btn-action" onclick="manageSchedule(<?php echo $sec['id']; ?>, '<?php echo htmlspecialchars($sec['section_name']); ?>', <?php echo $sec['program_id']; ?>, '<?php echo $sec['year_level']; ?>', '<?php echo $sec['semester']; ?>')">
                                                <i class="fas fa-calendar-alt"></i> Schedule
                                            </button>
                                            <button class="btn btn-sm btn-primary btn-action" onclick="editSection(<?php echo $sec['id']; ?>, '<?php echo htmlspecialchars($sec['section_name']); ?>', <?php echo $sec['max_capacity']; ?>, '<?php echo $sec['status']; ?>')">
                                                <i class="fas fa-edit"></i> Edit
                                            </button>
                                            <button class="btn btn-sm btn-info btn-action" onclick="viewSectionStudents(<?php echo $sec['id']; ?>, '<?php echo htmlspecialchars($sec['section_name']); ?>')">
                                                <i class="fas fa-users"></i> Students
                                            </button>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- No Results Message -->
                    <div id="no-results" class="text-center py-4" style="display: none;">
                        <i class="fas fa-search fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">No sections found</h5>
                        <p class="text-muted">Try adjusting your filters or search terms.</p>
                        <button class="btn btn-outline-primary" onclick="clearFilters()">
                            <i class="fas fa-refresh me-2"></i>Clear Filters
                        </button>
                    </div>
                </div>
                
                <!-- Document Checklists Section -->
                <div id="documents" class="content-section" style="display: none;">
                    <h2 class="mb-4">Student Document Checklists</h2>
                    
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>Student ID</th>
                                    <th>Name</th>
                                    <th>Enrollment Status</th>
                                    <th>Birth Cert.</th>
                                    <th>Report Card</th>
                                    <th>Good Moral</th>
                                    <th>ID Photo</th>
                                    <th>COE</th>
                                    <th>Medical</th>
                                    <th>TOR</th>
                                    <th>Progress</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($all_checklists as $check): ?>
                                    <?php
                                    $docs = ['birth_certificate', 'report_card', 'good_moral', 'id_photo', 
                                             'certificate_of_enrollment', 'medical_certificate', 'transcript_of_records'];
                                    $completed = 0;
                                    foreach ($docs as $doc) {
                                        if (isset($check[$doc]) && $check[$doc]) $completed++;
                                    }
                                    $progress = round(($completed / count($docs)) * 100);
                                    ?>
                                    <tr>
                                        <td><strong><?php echo htmlspecialchars($check['student_id']); ?></strong></td>
                                        <td><?php echo htmlspecialchars($check['first_name'] . ' ' . $check['last_name']); ?></td>
                                        <td>
                                            <form method="POST" action="update_enrollment_status.php" style="display: inline;">
                                                <input type="hidden" name="user_id" value="<?php echo $check['user_id']; ?>">
                                                <select name="enrollment_status" class="form-select form-select-sm" onchange="this.form.submit()">
                                                    <option value="pending" <?php echo ($check['enrollment_status'] ?? 'pending') == 'pending' ? 'selected' : ''; ?>>Pending</option>
                                                    <option value="enrolled" <?php echo ($check['enrollment_status'] ?? 'pending') == 'enrolled' ? 'selected' : ''; ?>>Enrolled</option>
                                                </select>
                                            </form>
                                        </td>
                                        <td class="text-center">
                                            <?php echo isset($check['birth_certificate']) && $check['birth_certificate'] ? '<i class="fas fa-check-circle text-success"></i>' : '<i class="fas fa-times-circle text-danger"></i>'; ?>
                                        </td>
                                        <td class="text-center">
                                            <?php echo isset($check['report_card']) && $check['report_card'] ? '<i class="fas fa-check-circle text-success"></i>' : '<i class="fas fa-times-circle text-danger"></i>'; ?>
                                        </td>
                                        <td class="text-center">
                                            <?php echo isset($check['good_moral']) && $check['good_moral'] ? '<i class="fas fa-check-circle text-success"></i>' : '<i class="fas fa-times-circle text-danger"></i>'; ?>
                                        </td>
                                        <td class="text-center">
                                            <?php echo isset($check['id_photo']) && $check['id_photo'] ? '<i class="fas fa-check-circle text-success"></i>' : '<i class="fas fa-times-circle text-danger"></i>'; ?>
                                        </td>
                                        <td class="text-center">
                                            <?php echo isset($check['certificate_of_enrollment']) && $check['certificate_of_enrollment'] ? '<i class="fas fa-check-circle text-success"></i>' : '<i class="fas fa-times-circle text-danger"></i>'; ?>
                                        </td>
                                        <td class="text-center">
                                            <?php echo isset($check['medical_certificate']) && $check['medical_certificate'] ? '<i class="fas fa-check-circle text-success"></i>' : '<i class="fas fa-times-circle text-danger"></i>'; ?>
                                        </td>
                                        <td class="text-center">
                                            <?php echo isset($check['transcript_of_records']) && $check['transcript_of_records'] ? '<i class="fas fa-check-circle text-success"></i>' : '<i class="fas fa-times-circle text-danger"></i>'; ?>
                                        </td>
                                        <td>
                                            <div class="progress" style="height: 20px;">
                                                <div class="progress-bar <?php echo $progress == 100 ? 'bg-success' : ($progress >= 50 ? 'bg-warning' : 'bg-danger'); ?>" 
                                                     role="progressbar" 
                                                     style="width: <?php echo $progress; ?>%">
                                                    <?php echo $progress; ?>%
                                                </div>
                                            </div>
                                            </td>
                                        <td>
                                            <button class="btn btn-primary btn-action btn-sm" 
                                                    onclick="editDocuments(<?php echo $check['user_id']; ?>, '<?php echo htmlspecialchars($check['first_name'] . ' ' . $check['last_name']); ?>')">
                                                <i class="fas fa-edit"></i> Edit
                                                        </button>
                                            </td>
                                        </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Curriculum Management Section -->
                <div id="curriculum" class="content-section" style="display: none;">
                    <h2 class="mb-4">Curriculum Management</h2>
                    
                    <!-- Program Selector -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-book-open me-2"></i>Select Program</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <?php foreach ($all_programs as $program): ?>
                                    <div class="col-md-4 mb-3">
                                        <div class="card h-100" style="cursor: pointer;" onclick="viewCurriculum(<?php echo $program['id']; ?>, '<?php echo htmlspecialchars($program['program_code']); ?>')">
                                            <div class="card-body text-center">
                                                <i class="fas fa-graduation-cap fa-3x text-primary mb-3"></i>
                                                <h5><?php echo htmlspecialchars($program['program_code']); ?></h5>
                                                <p class="small text-muted"><?php echo htmlspecialchars($program['program_name']); ?></p>
                                                <div class="mt-2">
                                                    <span class="badge bg-info"><?php echo $program['total_units']; ?> units</span>
                                                    <span class="badge bg-secondary"><?php echo $program['years_to_complete']; ?> years</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <?php endforeach; ?>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Curriculum Display Area -->
                    <div id="curriculum-display" style="display: none;">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h3 id="curriculum-title">Program Curriculum</h3>
                            <button class="btn btn-primary" onclick="showAddCurriculumModal()">
                                <i class="fas fa-plus me-2"></i>Add Course to Curriculum
                            </button>
                        </div>
                        <div id="curriculum-content"></div>
                    </div>
                </div>
                
                <!-- Chatbot FAQs Management Section -->
                <div id="chatbot" class="content-section" style="display: none;">
                    <h2 class="mb-4"><i class="fas fa-robot me-2"></i>Chatbot FAQs Management</h2>
                    
                    <!-- Statistics Cards -->
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="card text-center bg-primary text-white">
                                <div class="card-body">
                                    <i class="fas fa-question-circle fa-2x mb-2"></i>
                                    <h3 id="totalFAQs">0</h3>
                                    <p class="mb-0">Total FAQs</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card text-center bg-success text-white">
                                <div class="card-body">
                                    <i class="fas fa-comments fa-2x mb-2"></i>
                                    <h3 id="totalInquiries">0</h3>
                                    <p class="mb-0">Student Inquiries</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card text-center bg-info text-white">
                                <div class="card-body">
                                    <i class="fas fa-eye fa-2x mb-2"></i>
                                    <h3 id="mostViewedCount">0</h3>
                                    <p class="mb-0">Most Viewed</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card text-center bg-warning text-white">
                                <div class="card-body">
                                    <i class="fas fa-layer-group fa-2x mb-2"></i>
                                    <h3 id="categoriesCount">0</h3>
                                    <p class="mb-0">Categories</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- FAQs Management -->
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="fas fa-list me-2"></i>All FAQs</h5>
                            <button class="btn btn-primary" onclick="showAddFAQModal()">
                                <i class="fas fa-plus me-2"></i>Add New FAQ
                        </button>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th style="width: 25%;">Question</th>
                                            <th style="width: 30%;">Answer</th>
                                            <th style="width: 10%;">Category</th>
                                            <th style="width: 10%;">Keywords</th>
                                            <th style="width: 5%;" class="text-center">Views</th>
                                            <th style="width: 8%;" class="text-center">Status</th>
                                            <th style="width: 12%;" class="text-end">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="faqsTableBody">
                                        <tr>
                                            <td colspan="7" class="text-center">Loading FAQs...</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Recent Inquiries -->
                    <div class="card mt-4">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-history me-2"></i>Recent Student Inquiries</h5>
                        </div>
                        <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Student</th>
                                            <th>Question</th>
                                            <th>Answer</th>
                                            <th>Date</th>
                                </tr>
                            </thead>
                                    <tbody id="inquiriesTableBody">
                                        <tr>
                                            <td colspan="4" class="text-center">Loading inquiries...</td>
                                    </tr>
                            </tbody>
                        </table>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Pending Students Section -->
                <div id="pending-students" class="content-section" style="display: none;">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>Pending Students</h2>
                        <span class="text-muted">Students awaiting enrollment approval</span>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>Student ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Account Status</th>
                                    <th>Assigned Sections</th>
                                    <th>Registered</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php 
                                $has_pending = false;
                                foreach ($all_users as $student): 
                                    if ($student['role'] == 'student' && ($student['enrollment_status'] ?? 'pending') == 'pending'):
                                        $has_pending = true;
                                        $student_sections = $section_assignments[$student['id']] ?? [];
                                ?>
                                        <tr>
                                            <td><strong><?php echo htmlspecialchars($student['student_id']); ?></strong></td>
                                            <td><?php echo htmlspecialchars($student['first_name'] . ' ' . $student['last_name']); ?></td>
                                            <td><?php echo htmlspecialchars($student['email']); ?></td>
                                            <td><?php echo htmlspecialchars($student['phone']); ?></td>
                                            <td>
                                                <span class="badge <?php echo $student['status'] == 'active' ? 'bg-success' : ($student['status'] == 'pending' ? 'bg-warning' : 'bg-secondary'); ?>">
                                                    <?php echo ucfirst($student['status']); ?>
                                                </span>
                                            </td>
                                            <td>
                                                <?php if (empty($student_sections)): ?>
                                                    <span class="text-muted small">No section assigned</span>
                                                <?php else: ?>
                                                    <?php foreach ($student_sections as $section_info): ?>
                                                        <div class="badge bg-primary mb-1" style="display: block; text-align: left;">
                                                            <strong><?php echo htmlspecialchars($section_info['section_name']); ?></strong><br>
                                                            <small><?php echo htmlspecialchars($section_info['year_level'] . ' - ' . $section_info['semester']); ?></small>
                                                        </div>
                                                    <?php endforeach; ?>
                                                <?php endif; ?>
                                            </td>
                                            <td><?php echo date('M j, Y', strtotime($student['created_at'])); ?></td>
                                            <td>
                                                <button class="btn btn-primary btn-action btn-sm mb-1" onclick="assignSection(<?php echo $student['id']; ?>, '<?php echo htmlspecialchars($student['first_name'] . ' ' . $student['last_name']); ?>')">
                                                    <i class="fas fa-users"></i> Assign Section
                                                </button>
                                                <br>
                                                
                                                <?php if ($student['status'] == 'pending'): ?>
                                                    <form method="POST" action="update_user.php" style="display: inline;">
                                                        <input type="hidden" name="user_id" value="<?php echo $student['id']; ?>">
                                                        <input type="hidden" name="status" value="active">
                                                        <button type="submit" class="btn btn-success btn-action btn-sm mb-1">
                                                            <i class="fas fa-check"></i> Approve
                                                        </button>
                                                    </form>
                                                <?php endif; ?>
                                                
                                                <?php if ($student['status'] == 'active'): ?>
                                                    <form method="POST" action="update_user.php" style="display: inline;">
                                                        <input type="hidden" name="user_id" value="<?php echo $student['id']; ?>">
                                                        <input type="hidden" name="status" value="inactive">
                                                        <button type="submit" class="btn btn-warning btn-action btn-sm mb-1">
                                                            <i class="fas fa-pause"></i> Suspend
                                                        </button>
                                                    </form>
                                                <?php endif; ?>
                                                
                                                <?php if ($student['status'] == 'inactive'): ?>
                                                    <form method="POST" action="update_user.php" style="display: inline;">
                                                        <input type="hidden" name="user_id" value="<?php echo $student['id']; ?>">
                                                        <input type="hidden" name="status" value="active">
                                                        <button type="submit" class="btn btn-success btn-action btn-sm mb-1">
                                                            <i class="fas fa-play"></i> Activate
                                                        </button>
                                                    </form>
                                                <?php endif; ?>
                                                <br>
                                                
                                                <form method="POST" action="update_enrollment_status.php" style="display: inline;">
                                                    <input type="hidden" name="user_id" value="<?php echo $student['id']; ?>">
                                                    <select name="enrollment_status" class="form-select form-select-sm d-inline-block mb-1" style="width: auto;" onchange="this.form.submit()">
                                                        <option value="pending" selected>Pending</option>
                                                        <option value="enrolled">Enroll Student</option>
                                                    </select>
                                                </form>
                                                
                                                <button class="btn btn-info btn-action btn-sm" onclick="viewStudentDocuments(<?php echo $student['id']; ?>, '<?php echo htmlspecialchars($student['first_name'] . ' ' . $student['last_name']); ?>')">
                                                    <i class="fas fa-file-alt"></i> Documents
                                                </button>
                                            </td>
                                        </tr>
                                    <?php endif; ?>
                                <?php endforeach; ?>
                                <?php if (!$has_pending): ?>
                                    <tr>
                                        <td colspan="8" class="text-center py-4">
                                            <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                                            <p class="text-muted">No pending students. All students are either enrolled or inactive.</p>
                                        </td>
                                    </tr>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Enrolled Students Section -->
                <div id="enrolled-students" class="content-section" style="display: none;">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>Enrolled Students</h2>
                        <span class="text-muted">Students officially enrolled in the institution</span>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>Student ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Course/Program</th>
                                    <th>Year Level</th>
                                    <th>Student Type</th>
                                    <th>Academic Year</th>
                                    <th>Semester</th>
                                    <th>Enrolled Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if (empty($all_enrolled_students)): ?>
                                    <tr>
                                        <td colspan="10" class="text-center py-4">
                                            <i class="fas fa-user-graduate fa-3x text-muted mb-3"></i>
                                            <p class="text-muted">No enrolled students yet. Go to Pending Students to enroll students.</p>
                                        </td>
                                    </tr>
                                <?php else: ?>
                                <?php foreach ($all_enrolled_students as $enrolled): ?>
                                    <tr>
                                        <td><strong><?php echo htmlspecialchars($enrolled['student_id']); ?></strong></td>
                                        <td><?php echo htmlspecialchars($enrolled['first_name'] . ' ' . $enrolled['last_name']); ?></td>
                                        <td><?php echo htmlspecialchars($enrolled['email']); ?></td>
                                        <td><?php 
                                            // Display program from assigned sections, fallback to course field if no sections assigned
                                            if (!empty($enrolled['program_codes'])) {
                                                echo htmlspecialchars($enrolled['program_codes']);
                                            } elseif (!empty($enrolled['course'])) {
                                                echo htmlspecialchars($enrolled['course']);
                                            } else {
                                                echo '-';
                                            }
                                        ?></td>
                                        <td><?php 
                                            // Display year level from sections, fallback to enrolled_students data
                                            if (!empty($enrolled['section_year_levels'])) {
                                                echo htmlspecialchars($enrolled['section_year_levels']);
                                            } elseif (!empty($enrolled['year_level'])) {
                                                echo htmlspecialchars($enrolled['year_level']);
                                            } else {
                                                echo '1st Year';
                                            }
                                        ?></td>
                                        <td>
                                            <span class="badge <?php echo ($enrolled['student_type'] ?? 'Regular') == 'Regular' ? 'bg-success' : 'bg-warning'; ?>">
                                                <?php echo htmlspecialchars($enrolled['student_type'] ?? 'Regular'); ?>
                                            </span>
                                        </td>
                                        <td><?php 
                                            // Display academic year from sections, fallback to enrolled_students data
                                            if (!empty($enrolled['section_academic_years'])) {
                                                echo htmlspecialchars($enrolled['section_academic_years']);
                                            } elseif (!empty($enrolled['academic_year'])) {
                                                echo htmlspecialchars($enrolled['academic_year']);
                                            } else {
                                                echo 'AY 2024-2025';
                                            }
                                        ?></td>
                                        <td><?php 
                                            // Display semester from sections, fallback to enrolled_students data
                                            if (!empty($enrolled['section_semesters'])) {
                                                echo htmlspecialchars($enrolled['section_semesters']);
                                            } elseif (!empty($enrolled['semester'])) {
                                                echo htmlspecialchars($enrolled['semester']);
                                            } else {
                                                echo 'Fall 2024';
                                            }
                                        ?></td>
                                        <td><?php echo date('M j, Y', strtotime($enrolled['enrolled_date'])); ?></td>
                                        <td>
                                            <button class="btn btn-primary btn-action btn-sm" onclick="editEnrolledStudent(<?php echo $enrolled['user_id']; ?>, '<?php echo htmlspecialchars($enrolled['first_name'] . ' ' . $enrolled['last_name']); ?>')">
                                                <i class="fas fa-edit"></i> Edit
                                            </button>
                                            
                                            <form method="POST" action="update_enrollment_status.php" style="display: inline;">
                                                <input type="hidden" name="user_id" value="<?php echo $enrolled['user_id']; ?>">
                                                <input type="hidden" name="enrollment_status" value="pending">
                                                <button type="submit" class="btn btn-warning btn-action btn-sm" onclick="return confirm('Are you sure you want to revert this student to pending status?')">
                                                    <i class="fas fa-undo"></i> Revert
                                                </button>
                                            </form>
                                            
                                            <button class="btn btn-info btn-action btn-sm" onclick="viewStudentDocuments(<?php echo $enrolled['user_id']; ?>, '<?php echo htmlspecialchars($enrolled['first_name'] . ' ' . $enrolled['last_name']); ?>')">
                                                <i class="fas fa-file-alt"></i> Docs
                                            </button>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Edit Documents Modal -->
    <div class="modal fade" id="editDocumentsModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Document Checklist</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST" action="update_documents.php" id="documentForm">
                    <div class="modal-body">
                        <input type="hidden" name="user_id" id="edit_user_id">
                        <h6 id="student_name" class="mb-3"></h6>
                        
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" name="birth_certificate" id="birth_certificate" value="1">
                            <label class="form-check-label" for="birth_certificate">Birth Certificate</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" name="report_card" id="report_card" value="1">
                            <label class="form-check-label" for="report_card">Report Card (Form 138)</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" name="good_moral" id="good_moral" value="1">
                            <label class="form-check-label" for="good_moral">Good Moral Certificate</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" name="id_photo" id="id_photo" value="1">
                            <label class="form-check-label" for="id_photo">ID Photo (2x2)</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" name="certificate_of_enrollment" id="certificate_of_enrollment" value="1">
                            <label class="form-check-label" for="certificate_of_enrollment">Certificate of Enrollment</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" name="medical_certificate" id="medical_certificate" value="1">
                            <label class="form-check-label" for="medical_certificate">Medical Certificate</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" name="transcript_of_records" id="transcript_of_records" value="1">
                            <label class="form-check-label" for="transcript_of_records">Transcript of Records</label>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Add Section Modal -->
    <div class="modal fade" id="addSectionModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Section</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST" action="add_section.php">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="section_program_id" class="form-label">Program *</label>
                            <select class="form-select" name="program_id" id="section_program_id" required>
                                <option value="">Select Program</option>
                                <?php foreach ($all_programs as $prog): ?>
                                    <option value="<?php echo $prog['id']; ?>"><?php echo htmlspecialchars($prog['program_code'] . ' - ' . $prog['program_name']); ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="section_year_level" class="form-label">Year Level *</label>
                                <select class="form-select" name="year_level" id="section_year_level" required>
                                    <option value="1st Year">1st Year</option>
                                    <option value="2nd Year">2nd Year</option>
                                    <option value="3rd Year">3rd Year</option>
                                    <option value="4th Year">4th Year</option>
                                    <option value="5th Year">5th Year</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="section_semester" class="form-label">Semester *</label>
                                <select class="form-select" name="semester" id="section_semester" required>
                                    <option value="First Semester">First Semester</option>
                                    <option value="Second Semester">Second Semester</option>
                                    <option value="Summer">Summer</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="section_name" class="form-label">Section Name *</label>
                            <input type="text" class="form-control" name="section_name" id="section_name" required placeholder="e.g., BSE 1A - Morning">
                        </div>
                        
                        <div class="mb-3">
                            <label for="section_type" class="form-label">Section Type *</label>
                            <select class="form-select" name="section_type" id="section_type" required>
                                <option value="Morning">Morning Section</option>
                                <option value="Afternoon">Afternoon Section</option>
                                <option value="Evening">Evening Section</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="section_max_capacity" class="form-label">Max Capacity *</label>
                            <input type="number" class="form-control" name="max_capacity" id="section_max_capacity" value="50" min="1" max="100" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="section_academic_year" class="form-label">Academic Year *</label>
                            <input type="text" class="form-control" name="academic_year" id="section_academic_year" value="AY 2024-2025" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Section</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Edit Section Modal -->
    <div class="modal fade" id="editSectionModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Section</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST" action="update_section.php">
                    <div class="modal-body">
                        <input type="hidden" name="section_id" id="edit_section_id">
                        
                        <div class="mb-3">
                            <label for="edit_section_name" class="form-label">Section Name *</label>
                            <input type="text" class="form-control" name="section_name" id="edit_section_name" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="edit_max_capacity" class="form-label">Max Capacity *</label>
                            <input type="number" class="form-control" name="max_capacity" id="edit_max_capacity" min="1" max="100" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="edit_status" class="form-label">Status</label>
                            <select class="form-select" name="status" id="edit_status">
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Manage Schedule Modal -->
    <div class="modal fade" id="manageScheduleModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="schedule_modal_title">Manage Section Schedule</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 id="schedule_section_info"></h6>
                        <button class="btn btn-sm btn-primary" onclick="showAddScheduleForm()">
                            <i class="fas fa-plus me-1"></i>Add Course to Schedule
                        </button>
                    </div>
                    
                    <!-- Add Schedule Form (hidden initially) -->
                    <div id="add-schedule-form" style="display: none;" class="card mb-3">
                        <div class="card-header bg-primary text-white">
                            <h6 class="mb-0">Add Course to Schedule</h6>
                        </div>
                        <div class="card-body">
                            <form id="addScheduleForm" method="POST" action="add_schedule.php">
                                <input type="hidden" name="section_id" id="schedule_section_id">
                                
                                <div class="mb-3">
                                    <label for="schedule_curriculum_id" class="form-label">Select Course from Curriculum *</label>
                                    <select class="form-select" name="curriculum_id" id="schedule_curriculum_id" required onchange="loadCourseInfo(this)">
                                        <option value="">-- Select Course --</option>
                                    </select>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Course Code</label>
                                        <input type="text" class="form-control" id="display_course_code" readonly>
                                        <input type="hidden" name="course_code" id="schedule_course_code">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Course Name</label>
                                        <input type="text" class="form-control" id="display_course_name" readonly>
                                        <input type="hidden" name="course_name" id="schedule_course_name">
                                    </div>
                                    <div class="col-md-2 mb-3">
                                        <label class="form-label">Units</label>
                                        <input type="number" class="form-control" id="display_units" readonly>
                                        <input type="hidden" name="units" id="schedule_units">
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Schedule Days *</label>
                                    <div class="row">
                                        <div class="col-md-auto">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="schedule_monday" value="1" id="schedule_monday">
                                                <label class="form-check-label" for="schedule_monday">Monday</label>
                                            </div>
                                        </div>
                                        <div class="col-md-auto">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="schedule_tuesday" value="1" id="schedule_tuesday">
                                                <label class="form-check-label" for="schedule_tuesday">Tuesday</label>
                                            </div>
                                        </div>
                                        <div class="col-md-auto">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="schedule_wednesday" value="1" id="schedule_wednesday">
                                                <label class="form-check-label" for="schedule_wednesday">Wednesday</label>
                                            </div>
                                        </div>
                                        <div class="col-md-auto">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="schedule_thursday" value="1" id="schedule_thursday">
                                                <label class="form-check-label" for="schedule_thursday">Thursday</label>
                                            </div>
                                        </div>
                                        <div class="col-md-auto">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="schedule_friday" value="1" id="schedule_friday">
                                                <label class="form-check-label" for="schedule_friday">Friday</label>
                                            </div>
                                        </div>
                                        <div class="col-md-auto">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="schedule_saturday" value="1" id="schedule_saturday">
                                                <label class="form-check-label" for="schedule_saturday">Saturday</label>
                                            </div>
                                        </div>
                                        <div class="col-md-auto">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="schedule_sunday" value="1" id="schedule_sunday">
                                                <label class="form-check-label" for="schedule_sunday">Sunday</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-3 mb-3">
                                        <label for="schedule_time_start" class="form-label">Time Start *</label>
                                        <input type="time" class="form-control" name="time_start" id="schedule_time_start" required>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <label for="schedule_time_end" class="form-label">Time End *</label>
                                        <input type="time" class="form-control" name="time_end" id="schedule_time_end" required>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <label for="schedule_room" class="form-label">Room *</label>
                                        <input type="text" class="form-control" name="room" id="schedule_room" required placeholder="e.g., Room 101">
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <label for="schedule_professor_initial" class="form-label">Professor's Initial *</label>
                                        <input type="text" class="form-control" name="professor_initial" id="schedule_professor_initial" required placeholder="e.g., JAB">
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="schedule_professor_name" class="form-label">Professor's Full Name</label>
                                    <input type="text" class="form-control" name="professor_name" id="schedule_professor_name" placeholder="e.g., Dr. John A. Brown">
                                </div>
                                
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-success">
                                        <i class="fas fa-save me-1"></i>Save to Schedule
                                    </button>
                                    <button type="button" class="btn btn-secondary" onclick="hideAddScheduleForm()">
                                        Cancel
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Schedule Table -->
                    <div id="schedule-table-container">
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover" id="schedule-table">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Code</th>
                                        <th>Subject Title</th>
                                        <th>Units/Hrs.</th>
                                        <th>M</th>
                                        <th>T</th>
                                        <th>W</th>
                                        <th>Th</th>
                                        <th>F</th>
                                        <th>Sat</th>
                                        <th>Sun</th>
                                        <th>Time</th>
                                        <th>Rm</th>
                                        <th>Professor</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="schedule-table-body">
                                    <tr>
                                        <td colspan="14" class="text-center">Loading schedule...</td>
                                    </tr>
                                </tbody>
                                <tfoot class="table-secondary">
                                    <tr>
                                        <td colspan="2" class="text-end"><strong>TOTAL UNITS/HRS.</strong></td>
                                        <td id="total-units"><strong>0</strong></td>
                                        <td colspan="11"></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    
    <!-- Add/Edit FAQ Modal -->
    <div class="modal fade" id="faqModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="faqModalTitle">Add New FAQ</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form id="faqForm">
                    <div class="modal-body">
                        <input type="hidden" id="faq_id" name="id">
                        
                        <div class="mb-3">
                            <label for="faq_question" class="form-label">Question *</label>
                            <input type="text" class="form-control" id="faq_question" name="question" required maxlength="500">
                        </div>
                        
                        <div class="mb-3">
                            <label for="faq_answer" class="form-label">Answer *</label>
                            <textarea class="form-control" id="faq_answer" name="answer" required rows="5"></textarea>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="faq_category" class="form-label">Category</label>
                                <select class="form-select" id="faq_category" name="category">
                                    <option value="General">General</option>
                                    <option value="Enrollment">Enrollment</option>
                                    <option value="Requirements">Requirements</option>
                                    <option value="Schedule">Schedule</option>
                                    <option value="Sections">Sections</option>
                                    <option value="Account">Account</option>
                                    <option value="Documents">Documents</option>
                                </select>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Status</label>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="faq_is_active" name="is_active" checked>
                                    <label class="form-check-label" for="faq_is_active">Active</label>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="faq_keywords" class="form-label">Keywords</label>
                            <input type="text" class="form-control" id="faq_keywords" name="keywords" 
                                   placeholder="Enter comma-separated keywords (e.g., enroll, enrollment, register)">
                            <small class="text-muted">Keywords help students find this FAQ when searching</small>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save FAQ</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Add Curriculum Course Modal -->
    <div class="modal fade" id="addCurriculumModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add Course to Curriculum</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST" action="add_curriculum_course.php">
                    <div class="modal-body">
                        <input type="hidden" name="program_id" id="add_program_id">
                        
                        <div class="mb-3">
                            <label for="add_course_code" class="form-label">Course Code *</label>
                            <input type="text" class="form-control" name="course_code" id="add_course_code" required placeholder="e.g., BSE-C101">
                        </div>
                        
                        <div class="mb-3">
                            <label for="add_course_name" class="form-label">Course Name *</label>
                            <input type="text" class="form-control" name="course_name" id="add_course_name" required placeholder="e.g., Entrepreneurship Behavior">
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="add_units" class="form-label">Units *</label>
                                <input type="number" class="form-control" name="units" id="add_units" value="3" min="1" max="10" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Required Course?</label>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="is_required" id="add_is_required" value="1" checked>
                                    <label class="form-check-label" for="add_is_required">This course is required</label>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="add_year_level" class="form-label">Year Level *</label>
                                <select class="form-select" name="year_level" id="add_year_level" required>
                                    <option value="1st Year">1st Year</option>
                                    <option value="2nd Year">2nd Year</option>
                                    <option value="3rd Year">3rd Year</option>
                                    <option value="4th Year">4th Year</option>
                                    <option value="5th Year">5th Year</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="add_semester" class="form-label">Semester *</label>
                                <select class="form-select" name="semester" id="add_semester" required>
                                    <option value="First Semester">First Semester</option>
                                    <option value="Second Semester">Second Semester</option>
                                    <option value="Summer">Summer</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="add_pre_requisites" class="form-label">Pre-requisites</label>
                            <input type="text" class="form-control" name="pre_requisites" id="add_pre_requisites" placeholder="e.g., BSE-C100, GE-100">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Course</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Edit Enrolled Student Modal -->
    <div class="modal fade" id="editEnrolledStudentModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Enrolled Student - Manage Sections</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                    <div class="modal-body">
                    <input type="hidden" id="enrolled_user_id">
                        <h6 id="enrolled_student_name" class="mb-3"></h6>
                        
                    <!-- Current Sections -->
                    <div class="mb-4">
                        <h6 class="text-primary"><i class="fas fa-users me-2"></i>Current Section Assignments</h6>
                        <div id="edit_current_sections_list" class="mb-3">
                            <p class="text-muted">Loading...</p>
                        </div>
                        </div>
                        
                    <hr>
                    
                    <!-- Section Details Display -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6 class="card-title"><i class="fas fa-graduation-cap me-2"></i>Current Details</h6>
                                    <p class="mb-1"><strong>Course/Program:</strong> <span id="display_course">-</span></p>
                                    <p class="mb-1"><strong>Year Level:</strong> <span id="display_year_level">-</span></p>
                                    <p class="mb-1"><strong>Semester:</strong> <span id="display_semester">-</span></p>
                                    <p class="mb-0"><strong>Academic Year:</strong> <span id="display_academic_year">-</span></p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body">
                                    <h6 class="card-title">Student Type</h6>
                                    <form method="POST" action="update_enrolled_student.php" id="studentTypeForm">
                                        <input type="hidden" name="user_id" id="student_type_user_id">
                                        <select class="form-select" name="student_type" id="student_type">
                                            <option value="Regular">Regular Student</option>
                                            <option value="Irregular">Irregular Student</option>
                                        </select>
                                        <button type="submit" class="btn btn-sm btn-primary mt-2">
                                            <i class="fas fa-save"></i> Update Type
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <hr>
                    
                    <!-- Change/Add Section -->
                        <div class="mb-3">
                        <h6 class="text-success"><i class="fas fa-exchange-alt me-2"></i>Change or Add Section</h6>
                        <p class="text-muted small">Select criteria to find and assign a different section</p>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="edit_filter_program" class="form-label small">Program:</label>
                                <select class="form-select form-select-sm" id="edit_filter_program" onchange="filterEditSections()">
                                    <option value="">Select Program</option>
                                    <?php foreach ($all_programs as $program): ?>
                                        <option value="<?php echo $program['id']; ?>"><?php echo htmlspecialchars($program['program_code'] . ' - ' . $program['program_name']); ?></option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="edit_filter_year" class="form-label small">Year Level:</label>
                                <select class="form-select form-select-sm" id="edit_filter_year" onchange="filterEditSections()">
                                    <option value="">Select Year Level</option>
                                <option value="1st Year">1st Year</option>
                                <option value="2nd Year">2nd Year</option>
                                <option value="3rd Year">3rd Year</option>
                                <option value="4th Year">4th Year</option>
                                <option value="5th Year">5th Year</option>
                            </select>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="edit_filter_semester" class="form-label small">Semester:</label>
                                <select class="form-select form-select-sm" id="edit_filter_semester" onchange="filterEditSections()">
                                    <option value="">Select Semester</option>
                                    <option value="First Semester">First Semester</option>
                                    <option value="Second Semester">Second Semester</option>
                                    <option value="Summer">Summer</option>
                            </select>
                            </div>
                            <div class="col-md-6">
                                <label for="edit_filter_type" class="form-label small">Section Type:</label>
                                <select class="form-select form-select-sm" id="edit_filter_type" onchange="filterEditSections()">
                                    <option value="">Any Type</option>
                                    <option value="Morning">Morning</option>
                                    <option value="Afternoon">Afternoon</option>
                                    <option value="Evening">Evening</option>
                                </select>
                            </div>
                        </div>
                        
                        <!-- Available Sections List -->
                        <div id="edit_sections_container" style="display: none;">
                            <label class="form-label small">Available Sections:</label>
                            <div id="edit_sections_list" style="max-height: 300px; overflow-y: auto; border: 1px solid #dee2e6; border-radius: 4px; padding: 10px;">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
                        </div>
                        
    <!-- View Section Students Modal -->
    <div class="modal fade" id="viewSectionStudentsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="section_students_title">Section Students</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="section_info" class="mb-3"></div>
                    
                    <div class="table-responsive" id="section_students_table_container">
                        <table class="table table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>#</th>
                                    <th>Student ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Enrolled Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="section_students_list">
                                <tr>
                                    <td colspan="6" class="text-center">
                                        <div class="spinner-border text-primary" role="status">
                                            <span class="visually-hidden">Loading...</span>
                                        </div>
                                        <p class="mt-2">Loading students...</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    
                    <div id="no_students_message" style="display: none;" class="text-center py-4">
                        <i class="fas fa-users fa-3x text-muted mb-3"></i>
                        <p class="text-muted">No students enrolled in this section yet.</p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Assign Section Modal -->
    <div class="modal fade" id="assignSectionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Assign Section to Student</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="assign_student_id">
                    <h6 id="assign_student_name" class="mb-3 text-primary"></h6>
                    
                    <!-- Current Sections -->
                    <div id="current_sections_container" class="mb-4" style="display: none;">
                        <h6 class="text-success"><i class="fas fa-check-circle me-2"></i>Currently Assigned Sections:</h6>
                        <div id="current_sections_list" class="mb-3"></div>
                    </div>
                    
                    <!-- Section Selection -->
                        <div class="mb-3">
                        <label class="form-label"><strong>Select Section to Assign:</strong></label>
                        
                        <!-- Filters Card -->
                        <div class="card mb-3">
                            <div class="card-header bg-light">
                                <h6 class="mb-0"><i class="fas fa-filter me-2"></i>Filter Sections</h6>
                            </div>
                            <div class="card-body">
                                <!-- First Row of Filters -->
                                <div class="row mb-3">
                                    <div class="col-md-3">
                                        <label class="form-label small">Program:</label>
                                        <select class="form-select form-select-sm" id="assign_filter_program" onchange="filterAssignSections()">
                                            <option value="">All Programs</option>
                                            <?php foreach ($all_programs as $program): ?>
                                                <option value="<?php echo $program['id']; ?>"><?php echo htmlspecialchars($program['program_code']); ?></option>
                                            <?php endforeach; ?>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label small">Year Level:</label>
                                        <select class="form-select form-select-sm" id="assign_filter_year" onchange="filterAssignSections()">
                                            <option value="">All Years</option>
                                            <option value="1st Year">1st Year</option>
                                            <option value="2nd Year">2nd Year</option>
                                            <option value="3rd Year">3rd Year</option>
                                            <option value="4th Year">4th Year</option>
                                            <option value="5th Year">5th Year</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label small">Semester:</label>
                                        <select class="form-select form-select-sm" id="assign_filter_semester" onchange="filterAssignSections()">
                                            <option value="">All Semesters</option>
                                            <option value="First Semester">First Semester</option>
                                            <option value="Second Semester">Second Semester</option>
                                            <option value="Summer">Summer</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label small">Section Type:</label>
                                        <select class="form-select form-select-sm" id="assign_filter_type" onchange="filterAssignSections()">
                                            <option value="">All Types</option>
                                            <option value="Morning">Morning</option>
                                            <option value="Afternoon">Afternoon</option>
                                            <option value="Evening">Evening</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <!-- Second Row: Search and Clear -->
                                <div class="row">
                                    <div class="col-md-9">
                                        <label class="form-label small">Search:</label>
                                        <div class="input-group input-group-sm">
                                            <span class="input-group-text"><i class="fas fa-search"></i></span>
                                            <input type="text" class="form-control" id="assign_search" 
                                                   placeholder="Search by section name..." 
                                                   onkeyup="filterAssignSections()">
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label small">&nbsp;</label>
                                        <button class="btn btn-sm btn-outline-secondary w-100" onclick="clearAssignFilters()">
                                            <i class="fas fa-times-circle me-1"></i>Clear Filters
                                        </button>
                                    </div>
                                </div>
                                
                                <!-- Filter Summary -->
                                <div class="mt-2">
                                    <small class="text-muted">
                                        <i class="fas fa-info-circle me-1"></i>
                                        Showing <strong id="assign_sections_count">0</strong> section(s)
                                    </small>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Sections List -->
                        <div id="sections_list" style="max-height: 400px; overflow-y: auto; border: 1px solid #dee2e6; border-radius: 4px; padding: 10px;">
                            <p class="text-muted text-center">Loading sections...</p>
                        </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showSection(sectionId) {
            // Hide all sections
            document.querySelectorAll('.content-section').forEach(section => {
                section.style.display = 'none';
            });
            
            // Remove active class from all nav links
            document.querySelectorAll('.nav-link').forEach(link => {
                link.classList.remove('active');
            });
            
            // Show selected section
            document.getElementById(sectionId).style.display = 'block';
            
            // Add active class to corresponding nav link
            document.querySelectorAll('.nav-link').forEach(link => {
                if (link.getAttribute('onclick') && link.getAttribute('onclick').includes(sectionId)) {
                    link.classList.add('active');
                }
            });
        }
        
        // Handle hash navigation on page load
        window.addEventListener('DOMContentLoaded', function() {
            if (window.location.hash) {
                var sectionId = window.location.hash.substring(1);
                if (document.getElementById(sectionId)) {
                    showSection(sectionId);
                }
            }
        });
        
        function editDocuments(userId, studentName) {
            // Set user ID and name
            document.getElementById('edit_user_id').value = userId;
            document.getElementById('student_name').textContent = 'Student: ' + studentName;
            
            // Fetch current document status
            fetch('get_documents.php?user_id=' + userId)
                .then(response => response.json())
                .then(data => {
                    // Update checkboxes
                    document.getElementById('birth_certificate').checked = data.birth_certificate == 1;
                    document.getElementById('report_card').checked = data.report_card == 1;
                    document.getElementById('good_moral').checked = data.good_moral == 1;
                    document.getElementById('id_photo').checked = data.id_photo == 1;
                    document.getElementById('certificate_of_enrollment').checked = data.certificate_of_enrollment == 1;
                    document.getElementById('medical_certificate').checked = data.medical_certificate == 1;
                    document.getElementById('transcript_of_records').checked = data.transcript_of_records == 1;
                    
                    // Show modal
                    var modal = new bootstrap.Modal(document.getElementById('editDocumentsModal'));
                    modal.show();
                })
                .catch(error => {
                    alert('Error loading document data: ' + error);
                });
        }
        
        function viewStudentDocuments(userId, studentName) {
            editDocuments(userId, studentName);
        }
        
        let currentProgramId = null;
        let currentProgramCode = null;
        
        function viewCurriculum(programId, programCode) {
            currentProgramId = programId;
            currentProgramCode = programCode;
            
            document.getElementById('curriculum-title').textContent = programCode + ' Curriculum';
            document.getElementById('curriculum-display').style.display = 'block';
            
            // Fetch curriculum data
            fetch('get_curriculum.php?program_id=' + programId)
                .then(response => response.json())
                .then(data => {
                    let html = '';
                    let currentYear = '';
                    let currentSemester = '';
                    let semesterUnits = 0;
                    
                    data.courses.forEach(function(course, index) {
                        // Check if we need a new year heading
                        if (course.year_level !== currentYear) {
                            if (currentYear !== '') {
                                html += '</tbody></table></div>';
                            }
                            currentYear = course.year_level;
                            currentSemester = '';
                            html += '<h4 class="mt-4 mb-3 text-primary"><i class="fas fa-calendar-alt me-2"></i>' + currentYear + '</h4>';
                        }
                        
                        // Check if we need a new semester table
                        if (course.semester !== currentSemester) {
                            if (currentSemester !== '') {
                                html += '<tr class="table-dark"><td colspan="2" class="text-end"><strong>Semester Total:</strong></td><td><strong>' + semesterUnits + ' units</strong></td><td></td></tr>';
                                html += '</tbody></table></div>';
                            }
                            currentSemester = course.semester;
                            semesterUnits = 0;
                            
                            html += '<div class="card mb-3">';
                            html += '<div class="card-header bg-success text-white">';
                            html += '<h5 class="mb-0">' + currentSemester + '</h5>';
                            html += '</div>';
                            html += '<div class="card-body p-0">';
                            html += '<table class="table table-hover mb-0">';
                            html += '<thead><tr><th>Course Code</th><th>Course Name</th><th>Units</th><th>Actions</th></tr></thead>';
                            html += '<tbody>';
                        }
                        
                        semesterUnits += parseInt(course.units);
                        
                        html += '<tr>';
                        html += '<td><strong>' + course.course_code + '</strong></td>';
                        html += '<td>' + course.course_name + '</td>';
                        html += '<td>' + course.units + '</td>';
                        html += '<td>';
                        html += '<button class="btn btn-sm btn-warning" onclick="editCurriculumCourse(' + course.id + ')"><i class="fas fa-edit"></i></button> ';
                        html += '<button class="btn btn-sm btn-danger" onclick="deleteCurriculumCourse(' + course.id + ', \'' + programCode + '\')"><i class="fas fa-trash"></i></button>';
                        html += '</td>';
                        html += '</tr>';
                    });
                    
                    // Close last semester
                    if (currentSemester !== '') {
                        html += '<tr class="table-dark"><td colspan="2" class="text-end"><strong>Semester Total:</strong></td><td><strong>' + semesterUnits + ' units</strong></td><td></td></tr>';
                        html += '</tbody></table></div></div>';
                    }
                    
                    // Add grand total
                    html += '<div class="alert alert-info mt-4">';
                    html += '<h5><i class="fas fa-calculator me-2"></i>Program Total: ' + data.program.total_units + ' units</h5>';
                    html += '</div>';
                    
                    document.getElementById('curriculum-content').innerHTML = html;
                })
                .catch(error => {
                    alert('Error loading curriculum: ' + error);
                });
        }
        
        function showAddCurriculumModal() {
            if (!currentProgramId) {
                alert('Please select a program first');
                return;
            }
            
            // Set program ID in the form
            document.getElementById('add_program_id').value = currentProgramId;
            
            // Show modal
            var modal = new bootstrap.Modal(document.getElementById('addCurriculumModal'));
            modal.show();
        }
        
        function editCurriculumCourse(courseId) {
            alert('Edit curriculum course ID: ' + courseId);
        }
        
        function deleteCurriculumCourse(courseId, programCode) {
            if (confirm('Are you sure you want to delete this course from the curriculum?')) {
                fetch('delete_curriculum_course.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'course_id=' + courseId + '&session_id=<?php echo CURRENT_SESSION_ID; ?>'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        // Reload the page to show updated curriculum
                        location.reload();
                    } else {
                        alert('Error: ' + data.message);
                    }
                })
                .catch(error => {
                    alert('Error deleting course: ' + error);
                });
            }
        }
        
        function editSection(sectionId, sectionName, maxCapacity, status) {
            document.getElementById('edit_section_id').value = sectionId;
            document.getElementById('edit_section_name').value = sectionName;
            document.getElementById('edit_max_capacity').value = maxCapacity;
            document.getElementById('edit_status').value = status;
            
            var modal = new bootstrap.Modal(document.getElementById('editSectionModal'));
            modal.show();
        }
        
        function viewSectionStudents(sectionId, sectionName) {
            // Store current section info for removal functionality
            currentViewingSectionId = sectionId;
            currentViewingSectionName = sectionName;
            
            // Set modal title
            document.getElementById('section_students_title').textContent = 'Students in ' + sectionName;
            
            // Reset loading state
            document.getElementById('section_students_list').innerHTML = `
                <tr>
                    <td colspan="6" class="text-center">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <p class="mt-2">Loading students...</p>
                    </td>
                </tr>
            `;
            document.getElementById('section_students_table_container').style.display = 'block';
            document.getElementById('no_students_message').style.display = 'none';
            
            // Show modal
            var modal = new bootstrap.Modal(document.getElementById('viewSectionStudentsModal'));
            modal.show();
            
            // Fetch students
            fetch('get_section_students.php?section_id=' + sectionId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        displaySectionInfo(data.section);
                        displaySectionStudents(data.students);
                    } else {
                        alert('Error: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('section_students_list').innerHTML = `
                        <tr>
                            <td colspan="6" class="text-center text-danger">
                                <i class="fas fa-exclamation-triangle"></i> Error loading students
                            </td>
                        </tr>
                    `;
                });
        }
        
        function displaySectionInfo(section) {
            const infoHtml = `
                <div class="card bg-light">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Program:</strong> ${section.program_code} - ${section.program_name}</p>
                                <p class="mb-1"><strong>Year Level:</strong> ${section.year_level}</p>
                                <p class="mb-1"><strong>Semester:</strong> ${section.semester}</p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Section Type:</strong> <span class="badge bg-info">${section.section_type}</span></p>
                                <p class="mb-1"><strong>Academic Year:</strong> ${section.academic_year}</p>
                                <p class="mb-1"><strong>Capacity:</strong> <span class="${section.current_enrolled >= section.max_capacity ? 'text-danger' : 'text-success'}">${section.current_enrolled}/${section.max_capacity}</span></p>
                            </div>
                        </div>
                    </div>
                </div>
            `;
            document.getElementById('section_info').innerHTML = infoHtml;
        }
        
        function displaySectionStudents(students) {
            if (students.length === 0) {
                document.getElementById('section_students_table_container').style.display = 'none';
                document.getElementById('no_students_message').style.display = 'block';
                return;
            }
            
            let html = '';
            students.forEach((student, index) => {
                const enrolledDate = new Date(student.enrolled_date).toLocaleDateString('en-US', {
                    year: 'numeric',
                    month: 'short',
                    day: 'numeric'
                });
                
                html += `
                    <tr>
                        <td>${index + 1}</td>
                        <td><strong>${student.student_id}</strong></td>
                        <td>${student.first_name} ${student.last_name}</td>
                        <td>${student.email}</td>
                        <td>${enrolledDate}</td>
                        <td>
                            <button class="btn btn-sm btn-danger" onclick="removeStudentFromSectionView(${student.id}, '${student.first_name} ${student.last_name}')" 
                                    title="Remove from section">
                                <i class="fas fa-user-minus"></i> Remove
                            </button>
                        </td>
                    </tr>
                `;
            });
            
            document.getElementById('section_students_list').innerHTML = html;
        }
        
        function removeStudentFromSectionView(userId, studentName) {
            if (!confirm('Remove ' + studentName + ' from this section?')) {
                return;
            }
            
            // Get current section ID from the modal (we'll need to store it)
            const sectionId = currentViewingSectionId;
            
            const formData = new FormData();
            formData.append('user_id', userId);
            formData.append('section_id', sectionId);
            
            fetch('remove_section.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Student removed from section successfully!');
                    // Reload the student list
                    viewSectionStudents(sectionId, currentViewingSectionName);
                } else {
                    alert('Error: ' + data.message);
                }
            })
            .catch(error => {
                alert('Error removing student: ' + error);
            });
        }
        
        // Store current viewing section for removal
        let currentViewingSectionId = null;
        let currentViewingSectionName = null;
        
        
        let currentSectionId = null;
        let currentSectionProgramId = null;
        let currentSectionYearLevel = null;
        let currentSectionSemester = null;
        
        function manageSchedule(sectionId, sectionName, programId, yearLevel, semester) {
            currentSectionId = sectionId;
            currentSectionProgramId = programId;
            currentSectionYearLevel = yearLevel;
            currentSectionSemester = semester;
            
            document.getElementById('schedule_modal_title').textContent = 'Manage Schedule';
            document.getElementById('schedule_section_info').textContent = 'Section: ' + sectionName;
            document.getElementById('schedule_section_id').value = sectionId;
            
            // Load available curriculum courses for this section
            loadCurriculumCourses(programId, yearLevel, semester);
            
            // Load existing schedule
            loadSectionSchedule(sectionId);
            
            // Show modal
            var modal = new bootstrap.Modal(document.getElementById('manageScheduleModal'));
            modal.show();
        }
        
        function loadCurriculumCourses(programId, yearLevel, semester) {
            fetch('get_curriculum_courses.php?program_id=' + programId + '&year_level=' + encodeURIComponent(yearLevel) + '&semester=' + encodeURIComponent(semester) + '&session_id=<?php echo CURRENT_SESSION_ID; ?>')
                .then(response => response.json())
                .then(data => {
                    let select = document.getElementById('schedule_curriculum_id');
                    select.innerHTML = '<option value="">-- Select Course --</option>';
                    
                    data.courses.forEach(function(course) {
                        let option = document.createElement('option');
                        option.value = course.id;
                        option.setAttribute('data-code', course.course_code);
                        option.setAttribute('data-name', course.course_name);
                        option.setAttribute('data-units', course.units);
                        option.textContent = course.course_code + ' - ' + course.course_name + ' (' + course.units + ' units)';
                        select.appendChild(option);
                    });
                })
                .catch(error => {
                    console.error('Error loading curriculum courses:', error);
                });
        }
        
        function loadCourseInfo(select) {
            if (select.value) {
                let selectedOption = select.options[select.selectedIndex];
                document.getElementById('display_course_code').value = selectedOption.getAttribute('data-code');
                document.getElementById('schedule_course_code').value = selectedOption.getAttribute('data-code');
                document.getElementById('display_course_name').value = selectedOption.getAttribute('data-name');
                document.getElementById('schedule_course_name').value = selectedOption.getAttribute('data-name');
                document.getElementById('display_units').value = selectedOption.getAttribute('data-units');
                document.getElementById('schedule_units').value = selectedOption.getAttribute('data-units');
            }
        }
        
        function loadSectionSchedule(sectionId) {
            fetch('get_section_schedule.php?section_id=' + sectionId + '&session_id=<?php echo CURRENT_SESSION_ID; ?>')
                .then(response => response.json())
                .then(data => {
                    let tbody = document.getElementById('schedule-table-body');
                    let html = '';
                    let totalUnits = 0;
                    
                    if (data.schedule.length === 0) {
                        html = '<tr><td colspan="14" class="text-center text-muted">No courses scheduled yet. Click "Add Course to Schedule" to begin.</td></tr>';
                    } else {
                        data.schedule.forEach(function(item) {
                            totalUnits += parseInt(item.units);
                            let days = '';
                            if (item.schedule_monday) days += 'M ';
                            if (item.schedule_tuesday) days += 'T ';
                            if (item.schedule_wednesday) days += 'W ';
                            if (item.schedule_thursday) days += 'Th ';
                            if (item.schedule_friday) days += 'F ';
                            if (item.schedule_saturday) days += 'Sat ';
                            if (item.schedule_sunday) days += 'Sun ';
                            
                            html += '<tr>';
                            html += '<td><strong>' + item.course_code + '</strong></td>';
                            html += '<td>' + item.course_name + '</td>';
                            html += '<td class="text-center">' + item.units + '</td>';
                            html += '<td class="text-center">' + (item.schedule_monday ? '✓' : '') + '</td>';
                            html += '<td class="text-center">' + (item.schedule_tuesday ? '✓' : '') + '</td>';
                            html += '<td class="text-center">' + (item.schedule_wednesday ? '✓' : '') + '</td>';
                            html += '<td class="text-center">' + (item.schedule_thursday ? '✓' : '') + '</td>';
                            html += '<td class="text-center">' + (item.schedule_friday ? '✓' : '') + '</td>';
                            html += '<td class="text-center">' + (item.schedule_saturday ? '✓' : '') + '</td>';
                            html += '<td class="text-center">' + (item.schedule_sunday ? '✓' : '') + '</td>';
                            html += '<td>' + item.time_start + '-' + item.time_end + '</td>';
                            html += '<td>' + item.room + '</td>';
                            html += '<td>' + item.professor_initial + '</td>';
                            html += '<td>';
                            html += '<button class="btn btn-sm btn-danger" onclick="deleteScheduleEntry(' + item.id + ')"><i class="fas fa-trash"></i></button>';
                            html += '</td>';
                            html += '</tr>';
                        });
                    }
                    
                    tbody.innerHTML = html;
                    document.getElementById('total-units').innerHTML = '<strong>' + totalUnits + '</strong>';
                })
                .catch(error => {
                    console.error('Error loading schedule:', error);
                });
        }
        
        function showAddScheduleForm() {
            document.getElementById('add-schedule-form').style.display = 'block';
        }
        
        function hideAddScheduleForm() {
            document.getElementById('add-schedule-form').style.display = 'none';
            document.getElementById('addScheduleForm').reset();
        }
        
        function deleteScheduleEntry(scheduleId) {
            if (confirm('Are you sure you want to remove this course from the schedule?')) {
                fetch('delete_schedule.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'schedule_id=' + scheduleId + '&session_id=<?php echo CURRENT_SESSION_ID; ?>'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        loadSectionSchedule(currentSectionId);
                        alert('Course removed from schedule');
                    } else {
                        alert('Error: ' + data.message);
                    }
                })
                .catch(error => {
                    alert('Error deleting schedule entry: ' + error);
                });
            }
        }
        
        // ===== SECTION FILTERING AND SORTING =====
        
        function filterSections() {
            const program = document.getElementById('filter_program').value;
            const year = document.getElementById('filter_year').value;
            const semester = document.getElementById('filter_semester').value;
            const type = document.getElementById('filter_type').value;
            const status = document.getElementById('filter_status').value;
            const capacity = document.getElementById('filter_capacity').value;
            const search = document.getElementById('search_sections').value.toLowerCase();
            const sortBy = document.getElementById('sort_sections').value;
            const sortDirection = document.getElementById('sort_direction').value;
            
            const rows = document.querySelectorAll('.section-row');
            let visibleRows = [];
            
            // Filter rows
            rows.forEach(row => {
                let show = true;
                
                // Program filter
                if (program && row.dataset.program !== program) {
                    show = false;
                }
                
                // Year filter
                if (year && row.dataset.year !== year) {
                    show = false;
                }
                
                // Semester filter
                if (semester && row.dataset.semester !== semester) {
                    show = false;
                }
                
                // Type filter
                if (type && row.dataset.type !== type) {
                    show = false;
                }
                
                // Status filter
                if (status && row.dataset.status !== status) {
                    show = false;
                }
                
                // Capacity filter
                if (capacity) {
                    const percentage = parseFloat(row.dataset.percentage);
                    if (capacity === 'available' && percentage >= 100) {
                        show = false;
                    } else if (capacity === 'full' && percentage < 100) {
                        show = false;
                    } else if (capacity === 'almost-full' && percentage < 90) {
                        show = false;
                    }
                }
                
                // Search filter
                if (search && !row.dataset.searchText.includes(search)) {
                    show = false;
                }
                
                if (show) {
                    visibleRows.push(row);
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
            
            // Sort visible rows
            visibleRows.sort((a, b) => {
                let aVal, bVal;
                
                switch (sortBy) {
                    case 'program':
                        aVal = a.dataset.program;
                        bVal = b.dataset.program;
                        break;
                    case 'year':
                        aVal = a.dataset.year;
                        bVal = b.dataset.year;
                        break;
                    case 'semester':
                        aVal = a.dataset.semester;
                        bVal = b.dataset.semester;
                        break;
                    case 'section':
                        aVal = a.dataset.section;
                        bVal = b.dataset.section;
                        break;
                    case 'type':
                        aVal = a.dataset.type;
                        bVal = b.dataset.type;
                        break;
                    case 'capacity':
                        aVal = parseInt(a.dataset.capacity);
                        bVal = parseInt(b.dataset.capacity);
                        break;
                    case 'enrolled':
                        aVal = parseInt(a.dataset.enrolled);
                        bVal = parseInt(b.dataset.enrolled);
                        break;
                    case 'available':
                        aVal = parseInt(a.dataset.available);
                        bVal = parseInt(b.dataset.available);
                        break;
                    case 'status':
                        aVal = a.dataset.status;
                        bVal = b.dataset.status;
                        break;
                    default:
                        aVal = a.dataset.program;
                        bVal = b.dataset.program;
                }
                
                if (typeof aVal === 'string') {
                    return sortDirection === 'asc' ? 
                        aVal.localeCompare(bVal) : bVal.localeCompare(aVal);
                } else {
                    return sortDirection === 'asc' ? aVal - bVal : bVal - aVal;
                }
            });
            
            // Reorder rows in table
            const tbody = document.getElementById('sections-table-body');
            visibleRows.forEach(row => {
                tbody.appendChild(row);
            });
            
            // Update counts
            document.getElementById('filtered-count').textContent = visibleRows.length;
            
            // Show/hide no results message
            const noResults = document.getElementById('no-results');
            if (visibleRows.length === 0) {
                noResults.style.display = 'block';
            } else {
                noResults.style.display = 'none';
            }
            
            // Update sort indicators
            updateSortIndicators(sortBy, sortDirection);
        }
        
        function clearFilters() {
            document.getElementById('filter_program').value = '';
            document.getElementById('filter_year').value = '';
            document.getElementById('filter_semester').value = '';
            document.getElementById('filter_type').value = '';
            document.getElementById('filter_status').value = '';
            document.getElementById('filter_capacity').value = '';
            document.getElementById('search_sections').value = '';
            document.getElementById('sort_sections').value = 'program';
            document.getElementById('sort_direction').value = 'asc';
            
            filterSections();
        }
        
        function updateSortIndicators(sortBy, direction) {
            // Remove all sort indicators
            document.querySelectorAll('th[data-sort] i').forEach(icon => {
                icon.className = 'fas fa-sort';
            });
            
            // Add indicator to current sort column
            const sortColumn = document.querySelector(`th[data-sort="${sortBy}"] i`);
            if (sortColumn) {
                sortColumn.className = direction === 'asc' ? 'fas fa-sort-up' : 'fas fa-sort-down';
            }
        }
        
        // Toggle filter visibility
        function toggleFilters() {
            const filterBody = document.getElementById('filter-body');
            const toggleIcon = document.getElementById('filter-toggle-icon');
            
            if (filterBody.style.display === 'none') {
                filterBody.style.display = 'block';
                toggleIcon.className = 'fas fa-chevron-up float-end';
            } else {
                filterBody.style.display = 'none';
                toggleIcon.className = 'fas fa-chevron-down float-end';
            }
        }
        
        // Add click handlers to sortable columns
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('th[data-sort]').forEach(th => {
                th.style.cursor = 'pointer';
                th.addEventListener('click', function() {
                    const sortBy = this.dataset.sort;
                    const currentSort = document.getElementById('sort_sections').value;
                    const currentDirection = document.getElementById('sort_direction').value;
                    
                    if (currentSort === sortBy) {
                        // Toggle direction if same column
                        document.getElementById('sort_direction').value = 
                            currentDirection === 'asc' ? 'desc' : 'asc';
                    } else {
                        // New column, default to ascending
                        document.getElementById('sort_sections').value = sortBy;
                        document.getElementById('sort_direction').value = 'asc';
                    }
                    
                    filterSections();
                });
            });
        });
        
        let currentEditingUserId = null;
        
        function editEnrolledStudent(userId, studentName) {
            currentEditingUserId = userId;
            
            // Set user ID and name
            document.getElementById('enrolled_user_id').value = userId;
            document.getElementById('student_type_user_id').value = userId;
            document.getElementById('enrolled_student_name').textContent = 'Student: ' + studentName;
            
            // Reset filters
            document.getElementById('edit_filter_program').value = '';
            document.getElementById('edit_filter_year').value = '';
            document.getElementById('edit_filter_semester').value = '';
            document.getElementById('edit_filter_type').value = '';
            document.getElementById('edit_sections_container').style.display = 'none';
            
            // Fetch current enrolled student data
            fetch('get_enrolled_student.php?user_id=' + userId)
                .then(response => response.json())
                .then(data => {
                    // Update display fields
                    document.getElementById('display_course').textContent = data.display_course || data.course || '-';
                    document.getElementById('display_year_level').textContent = data.display_year_level || data.year_level || '1st Year';
                    document.getElementById('display_semester').textContent = data.display_semester || data.semester || 'Fall 2024';
                    document.getElementById('display_academic_year').textContent = data.display_academic_year || data.academic_year || 'AY 2024-2025';
                    document.getElementById('student_type').value = data.student_type || 'Regular';
                    
                    // Load and display current sections
                    loadEditCurrentSections(userId);
                    
                    // Show modal
                    var modal = new bootstrap.Modal(document.getElementById('editEnrolledStudentModal'));
                    modal.show();
                })
                .catch(error => {
                    alert('Error loading enrolled student data: ' + error);
                });
        }
        
        function loadEditCurrentSections(userId) {
            fetch('get_student_section.php?user_id=' + userId)
                .then(response => response.json())
                .then(data => {
                    const container = document.getElementById('edit_current_sections_list');
                    
                    if (data.success && data.sections && data.sections.length > 0) {
                        let html = '';
                        data.sections.forEach(section => {
                            html += '<div class="alert alert-success d-flex justify-content-between align-items-center mb-2">';
                            html += '<div>';
                            html += '<strong>' + section.section_name + '</strong><br>';
                            html += '<small class="text-muted">' + section.program_code + ' | ' + section.year_level + ' | ' + section.semester + ' | ' + section.academic_year + '</small>';
                            html += '</div>';
                            html += '<button class="btn btn-sm btn-danger" onclick="removeEditSection(' + userId + ', ' + section.section_id + ', \'' + section.section_name.replace(/'/g, "\\'") + '\')">';
                            html += '<i class="fas fa-times"></i> Remove</button>';
                            html += '</div>';
                        });
                        container.innerHTML = html;
                    } else {
                        container.innerHTML = '<p class="text-muted">No sections assigned yet.</p>';
                    }
                })
                .catch(error => {
                    console.error('Error loading sections:', error);
                    document.getElementById('edit_current_sections_list').innerHTML = '<p class="text-danger">Error loading sections</p>';
                });
        }
        
        function filterEditSections() {
            const programId = document.getElementById('edit_filter_program').value;
            const yearLevel = document.getElementById('edit_filter_year').value;
            const semester = document.getElementById('edit_filter_semester').value;
            const sectionType = document.getElementById('edit_filter_type').value;
            
            // Need at least program, year, and semester
            if (!programId || !yearLevel || !semester) {
                document.getElementById('edit_sections_container').style.display = 'none';
                return;
            }
            
            // Filter sections
            const matchingSections = allSectionsData.filter(section => {
                if (section.program_id != programId) return false;
                if (section.year_level != yearLevel) return false;
                if (section.semester != semester) return false;
                if (sectionType && section.section_type != sectionType) return false;
                return true;
            });
            
            displayEditSections(matchingSections);
        }
        
        function displayEditSections(sections) {
            const container = document.getElementById('edit_sections_container');
            const list = document.getElementById('edit_sections_list');
            
            if (sections.length === 0) {
                list.innerHTML = '<p class="text-muted small mb-0">No sections found matching these criteria.</p>';
                container.style.display = 'block';
                return;
            }
            
            let html = '';
            sections.forEach(section => {
                const isFull = section.current_enrolled >= section.max_capacity;
                const capacity = section.max_capacity - section.current_enrolled;
                
                html += '<div class="card mb-2 ' + (isFull ? 'border-danger' : '') + '">';
                html += '<div class="card-body p-2">';
                html += '<div class="d-flex justify-content-between align-items-center">';
                html += '<div>';
                html += '<strong>' + section.section_name + '</strong>';
                if (isFull) {
                    html += ' <span class="badge bg-danger ms-1">FULL</span>';
                }
                html += '<br><small class="text-muted">';
                html += '<span class="badge bg-info">' + section.section_type + '</span> ';
                html += section.academic_year + ' | Capacity: ' + section.current_enrolled + '/' + section.max_capacity;
                html += '</small>';
                html += '</div>';
                html += '<div>';
                if (isFull) {
                    html += '<button class="btn btn-sm btn-secondary" disabled>Full</button>';
                } else {
                    html += '<button class="btn btn-sm btn-primary" onclick="assignEditSection(' + section.id + ', \'' + section.section_name.replace(/'/g, "\\'") + '\')">';
                    html += '<i class="fas fa-plus"></i> Assign</button>';
                }
                html += '</div>';
                html += '</div>';
                html += '</div>';
                html += '</div>';
            });
            
            list.innerHTML = html;
            container.style.display = 'block';
        }
        
        function assignEditSection(sectionId, sectionName) {
            if (!currentEditingUserId) {
                alert('Error: No student selected');
                return;
            }
            
            if (!confirm('Assign student to section "' + sectionName + '"?')) {
                return;
            }
            
            const formData = new FormData();
            formData.append('user_id', currentEditingUserId);
            formData.append('section_id', sectionId);
            
            fetch('assign_section.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Section assigned successfully!');
                    // Reload current sections
                    loadEditCurrentSections(currentEditingUserId);
                    // Update display
                    fetch('get_enrolled_student.php?user_id=' + currentEditingUserId)
                        .then(r => r.json())
                        .then(d => {
                            document.getElementById('display_course').textContent = d.display_course || d.course || '-';
                            document.getElementById('display_year_level').textContent = d.display_year_level || d.year_level || '1st Year';
                            document.getElementById('display_semester').textContent = d.display_semester || d.semester || 'Fall 2024';
                            document.getElementById('display_academic_year').textContent = d.display_academic_year || d.academic_year || 'AY 2024-2025';
                        });
                    // Reset filters
                    document.getElementById('edit_filter_program').value = '';
                    document.getElementById('edit_filter_year').value = '';
                    document.getElementById('edit_filter_semester').value = '';
                    document.getElementById('edit_filter_type').value = '';
                    document.getElementById('edit_sections_container').style.display = 'none';
                } else {
                    alert('Error: ' + data.message);
                }
            })
            .catch(error => {
                alert('Error assigning section: ' + error);
            });
        }
        
        function removeEditSection(userId, sectionId, sectionName) {
            if (!confirm('Remove student from section "' + sectionName + '"?')) {
                return;
            }
            
            const formData = new FormData();
            formData.append('user_id', userId);
            formData.append('section_id', sectionId);
            
            fetch('remove_section.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Section removed successfully!');
                    // Reload current sections
                    loadEditCurrentSections(userId);
                    // Update display
                    fetch('get_enrolled_student.php?user_id=' + userId)
                        .then(r => r.json())
                        .then(d => {
                            document.getElementById('display_course').textContent = d.display_course || d.course || '-';
                            document.getElementById('display_year_level').textContent = d.display_year_level || d.year_level || '1st Year';
                            document.getElementById('display_semester').textContent = d.display_semester || d.semester || 'Fall 2024';
                            document.getElementById('display_academic_year').textContent = d.display_academic_year || d.academic_year || 'AY 2024-2025';
                        });
                } else {
                    alert('Error: ' + data.message);
                }
            })
            .catch(error => {
                alert('Error removing section: ' + error);
            });
        }
        
        // Section Assignment Functions
        let allSectionsData = [];
        let currentStudentId = null;
        
        // Load sections data on page load
        document.addEventListener('DOMContentLoaded', function() {
            allSectionsData = <?php echo json_encode($all_sections); ?>;
        });
        
        function assignSection(userId, studentName) {
            currentStudentId = userId;
            document.getElementById('assign_student_id').value = userId;
            document.getElementById('assign_student_name').textContent = 'Student: ' + studentName;
            
            // Load all sections
            loadAllSections();
            
            // Load current sections for this student
            loadCurrentSections(userId);
            
            // Show modal
            var modal = new bootstrap.Modal(document.getElementById('assignSectionModal'));
            modal.show();
        }
        
        function loadAllSections() {
            allSectionsData = <?php echo json_encode($all_sections); ?>;
            filterAssignSections();
        }
        
        function loadCurrentSections(userId) {
            fetch('get_student_section.php?user_id=' + userId)
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.sections.length > 0) {
                        let html = '';
                        data.sections.forEach(section => {
                            html += '<div class="alert alert-success d-flex justify-content-between align-items-center">';
                            html += '<div>';
                            html += '<strong>' + section.section_name + '</strong><br>';
                            html += '<small>' + section.program_code + ' - ' + section.year_level + ' - ' + section.semester + '</small>';
                            html += '</div>';
                            html += '<button class="btn btn-sm btn-danger" onclick="removeSectionAssignment(' + userId + ', ' + section.section_id + ')">';
                            html += '<i class="fas fa-times"></i> Remove</button>';
                            html += '</div>';
                        });
                        document.getElementById('current_sections_list').innerHTML = html;
                        document.getElementById('current_sections_container').style.display = 'block';
                    } else {
                        document.getElementById('current_sections_container').style.display = 'none';
                    }
                })
                .catch(error => {
                    console.error('Error loading current sections:', error);
                });
        }
        
        function filterAssignSections() {
            const programFilter = document.getElementById('assign_filter_program').value;
            const yearFilter = document.getElementById('assign_filter_year').value;
            const semesterFilter = document.getElementById('assign_filter_semester').value;
            const typeFilter = document.getElementById('assign_filter_type').value;
            const searchText = document.getElementById('assign_search').value.toLowerCase();
            
            let filteredSections = allSectionsData.filter(section => {
                // Program filter
                if (programFilter && section.program_id != programFilter) return false;
                
                // Year level filter
                if (yearFilter && section.year_level != yearFilter) return false;
                
                // Semester filter
                if (semesterFilter && section.semester != semesterFilter) return false;
                
                // Section type filter
                if (typeFilter && section.section_type != typeFilter) return false;
                
                // Search filter
                if (searchText) {
                    const sectionName = section.section_name.toLowerCase();
                    const programCode = section.program_code.toLowerCase();
                    const searchIn = sectionName + ' ' + programCode;
                    if (!searchIn.includes(searchText)) return false;
                }
                
                return true;
            });
            
            displaySectionsList(filteredSections);
        }
        
        function clearAssignFilters() {
            document.getElementById('assign_filter_program').value = '';
            document.getElementById('assign_filter_year').value = '';
            document.getElementById('assign_filter_semester').value = '';
            document.getElementById('assign_filter_type').value = '';
            document.getElementById('assign_search').value = '';
            filterAssignSections();
        }
        
        function displaySectionsList(sections) {
            let html = '';
            
            // Update count display
            document.getElementById('assign_sections_count').textContent = sections.length;
            
            if (sections.length === 0) {
                html = '<div class="text-center py-4">';
                html += '<i class="fas fa-search fa-3x text-muted mb-3"></i>';
                html += '<p class="text-muted mb-0">No sections found matching the filters.</p>';
                html += '<small class="text-muted">Try adjusting your filter criteria.</small>';
                html += '</div>';
            } else {
                sections.forEach(section => {
                    const capacity = section.max_capacity - section.current_enrolled;
                    const isFull = capacity <= 0;
                    const isAlmostFull = !isFull && (section.current_enrolled / section.max_capacity) >= 0.9;
                    
                    html += '<div class="card mb-2 ' + (isFull ? 'border-danger' : (isAlmostFull ? 'border-warning' : '')) + '">';
                    html += '<div class="card-body p-3">';
                    html += '<div class="row align-items-center">';
                    html += '<div class="col-md-7">';
                    html += '<h6 class="mb-1">';
                    html += '<i class="fas fa-users me-2 text-primary"></i>' + section.section_name;
                    if (isFull) {
                        html += ' <span class="badge bg-danger ms-2">FULL</span>';
                    } else if (isAlmostFull) {
                        html += ' <span class="badge bg-warning ms-2">Almost Full</span>';
                    }
                    html += '</h6>';
                    html += '<small class="text-muted">';
                    html += '<strong>' + section.program_code + '</strong> | ';
                    html += section.year_level + ' | ';
                    html += section.semester;
                    html += '</small><br>';
                    html += '<small class="text-muted">';
                    html += '<span class="badge bg-info">' + section.section_type + '</span> ';
                    html += section.academic_year;
                    html += '</small>';
                    html += '</div>';
                    html += '<div class="col-md-3">';
                    html += '<small class="d-block"><strong>Capacity:</strong></small>';
                    html += '<span class="' + (isFull ? 'text-danger' : (isAlmostFull ? 'text-warning' : 'text-success')) + '">';
                    html += '<strong>' + section.current_enrolled + '/' + section.max_capacity + '</strong></span>';
                    if (!isFull) {
                        html += '<br><small class="text-muted">' + capacity + ' slot(s) available</small>';
                    }
                    html += '</div>';
                    html += '<div class="col-md-2 text-end">';
                    
                    if (isFull) {
                        html += '<button class="btn btn-sm btn-secondary" disabled>';
                        html += '<i class="fas fa-ban"></i> Full</button>';
                    } else {
                        html += '<button class="btn btn-sm btn-primary" onclick="performSectionAssignment(' + section.id + ', \'' + section.section_name.replace(/'/g, "\\'") + '\')">';
                        html += '<i class="fas fa-plus"></i> Assign</button>';
                    }
                    
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';
                });
            }
            
            document.getElementById('sections_list').innerHTML = html;
        }
        
        function performSectionAssignment(sectionId, sectionName) {
            if (!currentStudentId) {
                alert('Error: No student selected');
                return;
            }
            
            if (!confirm('Assign section "' + sectionName + '" to this student?')) {
                return;
            }
            
            const formData = new FormData();
            formData.append('user_id', currentStudentId);
            formData.append('section_id', sectionId);
            
            fetch('assign_section.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Section assigned successfully!');
                    location.reload(); // Reload to show updated section assignments
                } else {
                    alert('Error: ' + data.message);
                }
            })
            .catch(error => {
                alert('Error assigning section: ' + error);
            });
        }
        
        function removeSectionAssignment(userId, sectionId) {
            if (!confirm('Remove this section assignment?')) {
                return;
            }
            
            const formData = new FormData();
            formData.append('user_id', userId);
            formData.append('section_id', sectionId);
            
            fetch('remove_section.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Section assignment removed successfully!');
                    location.reload(); // Reload to show updated section assignments
                } else {
                    alert('Error: ' + data.message);
                }
            })
            .catch(error => {
                alert('Error removing section: ' + error);
            });
        }
        
        // Chatbot FAQ Management Functions
        function loadChatbotStatistics() {
            fetch('chatbot_manage.php?action=statistics')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.getElementById('totalFAQs').textContent = data.stats.total_faqs || 0;
                        document.getElementById('totalInquiries').textContent = data.stats.total_inquiries || 0;
                        document.getElementById('mostViewedCount').textContent = data.stats.most_viewed ? data.stats.most_viewed.view_count : 0;
                    }
                })
                .catch(error => console.error('Error:', error));
        }
        
        function loadChatbotFAQs() {
            fetch('chatbot_manage.php?action=get_all')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        displayFAQs(data.faqs);
                        
                        // Count categories
                        const categories = new Set(data.faqs.map(faq => faq.category));
                        document.getElementById('categoriesCount').textContent = categories.size;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('faqsTableBody').innerHTML = '<tr><td colspan="6" class="text-center text-danger">Error loading FAQs</td></tr>';
                });
        }
        
        function displayFAQs(faqs) {
            const tbody = document.getElementById('faqsTableBody');
            
            if (faqs.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" class="text-center">No FAQs found. Click "Add New FAQ" to create one.</td></tr>';
                return;
            }
            
            tbody.innerHTML = '';
            faqs.forEach(faq => {
                const row = document.createElement('tr');
                
                const statusBadge = faq.is_active == 1 ? 
                    '<span class="badge bg-success">Active</span>' : 
                    '<span class="badge bg-secondary">Inactive</span>';
                
                row.innerHTML = `
                    <td><strong>${escapeHtml(faq.question)}</strong></td>
                    <td><small class="text-muted">${escapeHtml(faq.answer.substring(0, 120))}${faq.answer.length > 120 ? '...' : ''}</small></td>
                    <td><span class="badge bg-info">${escapeHtml(faq.category || 'General')}</span></td>
                    <td><small>${escapeHtml((faq.keywords || 'N/A').substring(0, 30))}${faq.keywords && faq.keywords.length > 30 ? '...' : ''}</small></td>
                    <td class="text-center"><span class="badge bg-primary">${faq.view_count || 0}</span></td>
                    <td class="text-center">${statusBadge}</td>
                    <td class="text-end">
                        <button class="btn btn-sm btn-warning" onclick="editFAQ(${faq.id})" title="Edit">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="deleteFAQ(${faq.id})" title="Delete">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                `;
                tbody.appendChild(row);
            });
        }
        
        function showAddFAQModal() {
            document.getElementById('faqModalTitle').textContent = 'Add New FAQ';
            document.getElementById('faqForm').reset();
            document.getElementById('faq_id').value = '';
            document.getElementById('faq_is_active').checked = true;
            
            const modal = new bootstrap.Modal(document.getElementById('faqModal'));
            modal.show();
        }
        
        function editFAQ(faqId) {
            fetch(`chatbot_manage.php?action=get_one&id=${faqId}`)
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.faq) {
                        document.getElementById('faqModalTitle').textContent = 'Edit FAQ';
                        document.getElementById('faq_id').value = data.faq.id;
                        document.getElementById('faq_question').value = data.faq.question;
                        document.getElementById('faq_answer').value = data.faq.answer;
                        document.getElementById('faq_category').value = data.faq.category || 'General';
                        document.getElementById('faq_keywords').value = data.faq.keywords || '';
                        document.getElementById('faq_is_active').checked = data.faq.is_active == 1;
                        
                        const modal = new bootstrap.Modal(document.getElementById('faqModal'));
                        modal.show();
                    }
                })
                .catch(error => console.error('Error:', error));
        }
        
        function deleteFAQ(faqId) {
            if (!confirm('Are you sure you want to delete this FAQ?')) {
                return;
            }
            
            const formData = new FormData();
            formData.append('action', 'delete');
            formData.append('id', faqId);
            
            fetch('chatbot_manage.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('FAQ deleted successfully!');
                    loadChatbotFAQs();
                    loadChatbotStatistics();
                } else {
                    alert('Error: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error deleting FAQ');
            });
        }
        
        function loadRecentInquiries() {
            fetch('chatbot_manage.php?action=recent_inquiries')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        displayInquiries(data.inquiries);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('inquiriesTableBody').innerHTML = '<tr><td colspan="4" class="text-center text-danger">Error loading inquiries</td></tr>';
                });
        }
        
        function displayInquiries(inquiries) {
            const tbody = document.getElementById('inquiriesTableBody');
            
            if (inquiries.length === 0) {
                tbody.innerHTML = '<tr><td colspan="4" class="text-center">No student inquiries yet.</td></tr>';
                return;
            }
            
            tbody.innerHTML = '';
            inquiries.forEach(inquiry => {
                const row = document.createElement('tr');
                const createdDate = new Date(inquiry.created_at).toLocaleString();
                
                row.innerHTML = `
                    <td>
                        <strong>${escapeHtml(inquiry.student_id)}</strong>
                        <br><small>${escapeHtml(inquiry.first_name + ' ' + inquiry.last_name)}</small>
                    </td>
                    <td>${escapeHtml(inquiry.question)}</td>
                    <td><small>${escapeHtml((inquiry.answer || 'N/A').substring(0, 100))}${inquiry.answer && inquiry.answer.length > 100 ? '...' : ''}</small></td>
                    <td><small>${createdDate}</small></td>
                `;
                tbody.appendChild(row);
            });
        }
        
        // FAQ Form submission
        document.addEventListener('DOMContentLoaded', function() {
            const faqForm = document.getElementById('faqForm');
            if (faqForm) {
                faqForm.addEventListener('submit', function(e) {
                    e.preventDefault();
                    
                    const formData = new FormData(this);
                    const faqId = document.getElementById('faq_id').value;
                    
                    if (faqId) {
                        formData.append('action', 'update');
                    } else {
                        formData.append('action', 'add');
                    }
                    
                    fetch('chatbot_manage.php', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert(data.message);
                            bootstrap.Modal.getInstance(document.getElementById('faqModal')).hide();
                            loadChatbotFAQs();
                            loadChatbotStatistics();
                        } else {
                            alert('Error: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Error saving FAQ');
                    });
                });
            }
        });
        
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
        
        // Update showSection to load chatbot data
        const originalShowSection = showSection;
        showSection = function(sectionId) {
            originalShowSection(sectionId);
            
            // Load chatbot FAQs if viewing chatbot section
            if (sectionId === 'chatbot') {
                loadChatbotFAQs();
                loadChatbotStatistics();
                loadRecentInquiries();
            }
        };
    </script>
    
    <?php inject_session_js(); ?>
</body>
</html>
