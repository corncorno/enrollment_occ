<?php
require_once '../config/database.php';
require_once '../config/session_helper.php';
require_once '../classes/User.php';
require_once '../classes/Section.php';

// Check if user is logged in and is a student
if (!isLoggedIn() || isAdmin()) {
    redirect('public/login.php');
}

$user = new User();
$section = new Section();

// Validate session against users table to prevent session confusion
$user_info = $user->getUserById($_SESSION['user_id']);
if (!$user_info) {
    // User not found in database, logout
    session_destroy();
    redirect('public/login.php');
}

// Update session role if it somehow got corrupted
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'student') {
    $_SESSION['role'] = 'student';
}

// Update session to ensure is_admin flag is set correctly
if (!isset($_SESSION['is_admin']) || $_SESSION['is_admin'] !== false) {
    $_SESSION['is_admin'] = false;
}

// Get database connection
$conn = (new Database())->getConnection();

// Get student's sections
$my_sections = $section->getStudentSections($_SESSION['user_id']);

// Get student's schedules
$schedules_query = "SELECT ss.*, s.section_name, s.year_level, s.semester, p.program_code
                    FROM section_schedules ss
                    JOIN section_enrollments se ON ss.section_id = se.section_id
                    JOIN sections s ON ss.section_id = s.id
                    JOIN programs p ON s.program_id = p.id
                    WHERE se.user_id = :user_id AND se.status = 'active'
                    ORDER BY ss.course_code";
$schedules_stmt = $conn->prepare($schedules_query);
$schedules_stmt->bindParam(':user_id', $_SESSION['user_id']);
$schedules_stmt->execute();
$my_schedules = $schedules_stmt->fetchAll(PDO::FETCH_ASSOC);

// Get enrollment status from enrolled_students table joined with users
$enrolled_query = "SELECT es.*, u.enrollment_status,
                   CASE 
                       WHEN es.course IS NOT NULL THEN es.course
                       ELSE p.program_code 
                   END as display_program
                   FROM enrolled_students es
                   JOIN users u ON es.user_id = u.id
                   LEFT JOIN (
                       SELECT se.user_id, pr.program_code
                       FROM section_enrollments se
                       JOIN sections s ON se.section_id = s.id
                       JOIN programs pr ON s.program_id = pr.id
                       WHERE se.status = 'active'
                       LIMIT 1
                   ) p ON es.user_id = p.user_id
                   WHERE es.user_id = :user_id";
$enrolled_stmt = $conn->prepare($enrolled_query);
$enrolled_stmt->bindParam(':user_id', $_SESSION['user_id']);
$enrolled_stmt->execute();
$enrollment_info = $enrolled_stmt->fetch(PDO::FETCH_ASSOC);

// If no enrolled_students record, get enrollment_status from users table
if (!$enrollment_info) {
    $user_query = "SELECT u.enrollment_status, u.created_at as enrolled_date, 
                   p.program_code as display_program,
                   NULL as student_type, NULL as year_level, 
                   NULL as academic_year, NULL as semester, NULL as course
                   FROM users u
                   LEFT JOIN (
                       SELECT se.user_id, pr.program_code
                       FROM section_enrollments se
                       JOIN sections s ON se.section_id = s.id
                       JOIN programs pr ON s.program_id = pr.id
                       WHERE se.status = 'active'
                       LIMIT 1
                   ) p ON u.id = p.user_id
                   WHERE u.id = :user_id";
    $user_stmt = $conn->prepare($user_query);
    $user_stmt->bindParam(':user_id', $_SESSION['user_id']);
    $user_stmt->execute();
    $enrollment_info = $user_stmt->fetch(PDO::FETCH_ASSOC);
}

// Get document checklist
$checklist_query = "SELECT * FROM document_checklists WHERE user_id = :user_id";
$stmt = (new Database())->getConnection()->prepare($checklist_query);
$stmt->bindParam(':user_id', $_SESSION['user_id']);
$stmt->execute();
$checklist = $stmt->fetch(PDO::FETCH_ASSOC);

// If no checklist exists, create one
if (!$checklist) {
    $create_checklist = "INSERT INTO document_checklists (user_id) VALUES (:user_id)";
    $create_stmt = (new Database())->getConnection()->prepare($create_checklist);
    $create_stmt->bindParam(':user_id', $_SESSION['user_id']);
    $create_stmt->execute();
    
    // Fetch the newly created checklist
    $stmt->execute();
    $checklist = $stmt->fetch(PDO::FETCH_ASSOC);
}

// Check if student is eligible for next enrollment
// Eligible if currently in 1st Year Second Semester or higher
$can_enroll_next = false;
$next_enrollment_info = [];

if ($enrollment_info && isset($enrollment_info['year_level']) && isset($enrollment_info['semester'])) {
    $current_year = $enrollment_info['year_level'];
    $current_semester = $enrollment_info['semester'];
    
    // Helper function to check if semester is "second" (handles multiple formats)
    // Second semester: "Second Semester", "2nd Semester", "Spring"
    // First semester: "First Semester", "1st Semester", "Fall"
    $isSecondSemester = (
        stripos($current_semester, 'Second') !== false || 
        stripos($current_semester, '2nd') !== false ||
        stripos($current_semester, 'Spring') !== false
    );
    $isFirstSemester = (
        stripos($current_semester, 'First') !== false || 
        stripos($current_semester, '1st') !== false ||
        stripos($current_semester, 'Fall') !== false
    );
    
    // Determine if eligible (1st Year Second Semester or higher)
    if ($current_year === '1st Year' && $isSecondSemester) {
        $can_enroll_next = true;
        $next_enrollment_info = ['year_level' => '2nd Year', 'semester' => 'First Semester'];
    } elseif ($current_year === '2nd Year' && $isFirstSemester) {
        $can_enroll_next = true;
        $next_enrollment_info = ['year_level' => '2nd Year', 'semester' => 'Second Semester'];
    } elseif ($current_year === '2nd Year' && $isSecondSemester) {
        $can_enroll_next = true;
        $next_enrollment_info = ['year_level' => '3rd Year', 'semester' => 'First Semester'];
    } elseif ($current_year === '3rd Year' && $isFirstSemester) {
        $can_enroll_next = true;
        $next_enrollment_info = ['year_level' => '3rd Year', 'semester' => 'Second Semester'];
    } elseif ($current_year === '3rd Year' && $isSecondSemester) {
        $can_enroll_next = true;
        $next_enrollment_info = ['year_level' => '4th Year', 'semester' => 'First Semester'];
    } elseif ($current_year === '4th Year' && $isFirstSemester) {
        $can_enroll_next = true;
        $next_enrollment_info = ['year_level' => '4th Year', 'semester' => 'Second Semester'];
    } elseif ($current_year === '4th Year' && $isSecondSemester) {
        $can_enroll_next = true;
        $next_enrollment_info = ['year_level' => '5th Year', 'semester' => 'First Semester'];
    } elseif ($current_year === '5th Year' && $isFirstSemester) {
        $can_enroll_next = true;
        $next_enrollment_info = ['year_level' => '5th Year', 'semester' => 'Second Semester'];
    }
}

$message = '';
if (isset($_SESSION['message'])) {
    $message = $_SESSION['message'];
    unset($_SESSION['message']);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - <?php echo SITE_NAME; ?></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .sidebar {
            background: linear-gradient(135deg, #1e40af 0%, #1e3a8a 100%);
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
        .btn-enroll {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            border-radius: 20px;
        }
        .btn-drop {
            background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
            border: none;
            border-radius: 20px;
        }
        .status-badge {
            border-radius: 20px;
            padding: 5px 15px;
        }
        .status-enrolled {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        .status-waitlisted {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
        }
        .status-pending {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
        }
        .checklist-item {
            padding: 10px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .checklist-item:last-child {
            border-bottom: none;
        }
        .checklist-icon {
            font-size: 1.2em;
        }
        .enrollment-status-card {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: white;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 20px;
        }
        
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar p-3">
                <div class="text-center mb-4">
                    <i class="fas fa-graduation-cap fa-3x mb-2"></i>
                    <h5><?php echo SITE_NAME; ?></h5>
                </div>
                
                <div class="mb-4">
                    <h6 class="text-white-50">Welcome,</h6>
                    <h5><?php echo $_SESSION['first_name'] . ' ' . $_SESSION['last_name']; ?></h5>
                    <small class="text-white-50">ID: <?php echo $_SESSION['student_id']; ?></small>
                </div>
                
                <nav class="nav flex-column">
                    <a href="#" class="nav-link active" onclick="showSection('dashboard')">
                        <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                    </a>
                    <a href="#" class="nav-link" onclick="showSection('schedule')">
                        <i class="fas fa-calendar-week me-2"></i>My Schedule
                    </a>
                    <a href="#" class="nav-link" onclick="showSection('sections')">
                        <i class="fas fa-users-class me-2"></i>My Sections
                    </a>
                    <a href="#" class="nav-link" onclick="showSection('enrollment')">
                        <i class="fas fa-clipboard-check me-2"></i>Enrollment Status
                    </a>
                    <?php if ($can_enroll_next): ?>
                    <a href="#" class="nav-link" onclick="showSection('next-enrollment')">
                        <i class="fas fa-calendar-plus me-2"></i>Enroll for Next Semester
                    </a>
                    <?php endif; ?>
                    <a href="logout.php" class="nav-link">
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
                    <h2 class="mb-4">Dashboard</h2>
                    
                    <!-- Enrollment Status Card -->
                    <div class="enrollment-status-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="mb-1"><i class="fas fa-user-graduate me-2"></i>Enrollment Status</h5>
                                <p class="mb-0 small">Your current enrollment status with the institution</p>
                            </div>
                            <div class="text-end">
                                <h3 class="mb-0">
                                    <span class="badge bg-<?php echo $user_info['enrollment_status'] == 'enrolled' ? 'success' : 'warning'; ?> fs-5">
                                        <?php echo strtoupper($user_info['enrollment_status']); ?>
                                    </span>
                                </h3>
                                <?php if ($user_info['enrollment_status'] == 'pending'): ?>
                                    <small>Awaiting admin approval</small>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                    
                    
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <div class="card text-center">
                                <div class="card-body">
                                    <i class="fas fa-users-class fa-3x text-primary mb-3"></i>
                                    <h3 class="text-primary"><?php echo count($my_sections); ?></h3>
                                    <p class="mb-0">My Sections</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card text-center">
                                <div class="card-body">
                                    <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                                    <h3 class="text-success"><?php echo $enrollment_info && isset($enrollment_info['enrollment_status']) && $enrollment_info['enrollment_status'] == 'enrolled' ? 1 : 0; ?></h3>
                                    <p class="mb-0">Enrollment Status</p>
                                    <?php if ($enrollment_info && isset($enrollment_info['enrollment_status']) && $enrollment_info['enrollment_status'] == 'enrolled'): ?>
                                        <small class="text-success">Enrolled</small>
                                    <?php else: ?>
                                        <small class="text-muted">Not Enrolled</small>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card text-center">
                                <div class="card-body">
                                    <i class="fas fa-graduation-cap fa-3x text-info mb-3"></i>
                                    <h3 class="text-info"><?php echo $enrollment_info ? htmlspecialchars($enrollment_info['display_program'] ?? 'N/A') : 'N/A'; ?></h3>
                                    <p class="mb-0">Program</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-8 mb-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0"><i class="fas fa-calendar me-2"></i>My Sections</h5>
                                </div>
                                <div class="card-body">
                                    <?php if (empty($my_sections)): ?>
                                        <p class="text-muted">You are not enrolled in any sections yet. Contact the admin to assign you to sections.</p>
                                    <?php else: ?>
                                        <div class="row">
                                            <?php foreach (array_slice($my_sections, 0, 4) as $sec): ?>
                                                <div class="col-md-6 mb-3">
                                                    <div class="border rounded p-3 bg-light">
                                                        <h6 class="mb-1 text-primary"><?php echo htmlspecialchars($sec['section_name']); ?></h6>
                                                        <p class="mb-1 small"><strong><?php echo htmlspecialchars($sec['program_code']); ?></strong></p>
                                                        <div class="small text-muted">
                                                            <i class="fas fa-layer-group me-1"></i>Year <?php echo $sec['year_level']; ?> - 
                                                            <?php echo $sec['semester'] == 1 ? '1st' : '2nd'; ?> Semester<br>
                                                            <i class="fas fa-calendar me-1"></i>AY <?php echo htmlspecialchars($sec['academic_year']); ?>
                                                        </div>
                                                    </div>
                                                </div>
                                            <?php endforeach; ?>
                                        </div>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-4 mb-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0"><i class="fas fa-file-alt me-2"></i>Document Checklist</h5>
                                </div>
                                <div class="card-body p-0">
                                    <?php
                                    $documents = [
                                        'birth_certificate' => 'Birth Certificate',
                                        'report_card' => 'Report Card (Form 138)',
                                        'good_moral' => 'Good Moral Certificate',
                                        'id_photo' => 'ID Photo (2x2)',
                                        'certificate_of_enrollment' => 'Certificate of Enrollment',
                                        'medical_certificate' => 'Medical Certificate',
                                        'transcript_of_records' => 'Transcript of Records'
                                    ];
                                    
                                    $completed = 0;
                                    foreach ($documents as $key => $label) {
                                        if ($checklist[$key]) $completed++;
                                    }
                                    ?>
                                    <div class="p-3 bg-light">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span class="small"><strong>Progress:</strong></span>
                                            <span class="badge bg-primary"><?php echo $completed; ?>/<?php echo count($documents); ?></span>
                                        </div>
                                        <div class="progress" style="height: 8px;">
                                            <div class="progress-bar" role="progressbar" 
                                                 style="width: <?php echo ($completed / count($documents)) * 100; ?>%"
                                                 aria-valuenow="<?php echo $completed; ?>" 
                                                 aria-valuemin="0" 
                                                 aria-valuemax="<?php echo count($documents); ?>"></div>
                                        </div>
                                    </div>
                                    
                                    <?php foreach ($documents as $key => $label): ?>
                                        <div class="checklist-item">
                                            <span class="small"><?php echo $label; ?></span>
                                            <span class="checklist-icon">
                                                <?php if ($checklist[$key]): ?>
                                                    <i class="fas fa-check-circle text-success"></i>
                                                <?php else: ?>
                                                    <i class="fas fa-times-circle text-danger"></i>
                                                <?php endif; ?>
                                            </span>
                                        </div>
                                    <?php endforeach; ?>
                                    
                                    <div class="p-3 bg-light">
                                        <small class="text-muted">
                                            <i class="fas fa-info-circle me-1"></i>
                                            Documents are verified by the registrar's office.
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- My Schedule Section -->
                <div id="schedule" class="content-section" style="display: none;">
                    <h2 class="mb-4"><i class="fas fa-calendar-week me-2"></i>My Class Schedule</h2>
                    
                    <?php if (empty($my_schedules)): ?>
                        <div class="card">
                            <div class="card-body text-center py-5">
                                <i class="fas fa-calendar-times fa-4x text-muted mb-3"></i>
                                <h5>No Schedule Available</h5>
                                <p class="text-muted">You don't have any class schedules yet. Schedules will appear here once the admin assigns them to your sections.</p>
                            </div>
                        </div>
                    <?php else: ?>
                        <!-- Summary Cards -->
                        <div class="row mb-4">
                            <div class="col-md-3">
                                <div class="card text-center bg-primary text-white">
                                    <div class="card-body">
                                        <h3><?php echo count($my_schedules); ?></h3>
                                        <p class="mb-0">Total Subjects</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card text-center bg-success text-white">
                                    <div class="card-body">
                                        <h3><?php echo array_sum(array_column($my_schedules, 'units')); ?></h3>
                                        <p class="mb-0">Total Units</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card text-center bg-info text-white">
                                    <div class="card-body">
                                        <h3><?php echo count(array_unique(array_column($my_schedules, 'section_id'))); ?></h3>
                                        <p class="mb-0">Sections</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card text-center bg-warning text-white">
                                    <div class="card-body">
                                        <h3><?php echo count(array_unique(array_column($my_schedules, 'professor_name'))); ?></h3>
                                        <p class="mb-0">Professors</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Schedule Table -->
                        <div class="card">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0"><i class="fas fa-list me-2"></i>Class Schedule Details</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Course Code</th>
                                                <th>Course Name</th>
                                                <th>Units</th>
                                                <th>Schedule</th>
                                                <th>Time</th>
                                                <th>Room</th>
                                                <th>Professor</th>
                                                <th>Section</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php foreach ($my_schedules as $sched): ?>
                                                <?php
                                                // Build schedule days string
                                                $days = [];
                                                if ($sched['schedule_monday']) $days[] = 'Mon';
                                                if ($sched['schedule_tuesday']) $days[] = 'Tue';
                                                if ($sched['schedule_wednesday']) $days[] = 'Wed';
                                                if ($sched['schedule_thursday']) $days[] = 'Thu';
                                                if ($sched['schedule_friday']) $days[] = 'Fri';
                                                if ($sched['schedule_saturday']) $days[] = 'Sat';
                                                if ($sched['schedule_sunday']) $days[] = 'Sun';
                                                $schedule_days = !empty($days) ? implode(', ', $days) : 'TBA';
                                                
                                                // Format time
                                                $time_display = 'TBA';
                                                if (!empty($sched['time_start']) && !empty($sched['time_end'])) {
                                                    $time_display = date('g:i A', strtotime($sched['time_start'])) . ' - ' . date('g:i A', strtotime($sched['time_end']));
                                                }
                                                ?>
                                                <tr>
                                                    <td><strong class="text-primary"><?php echo htmlspecialchars($sched['course_code']); ?></strong></td>
                                                    <td><?php echo htmlspecialchars($sched['course_name']); ?></td>
                                                    <td><span class="badge bg-success"><?php echo $sched['units']; ?></span></td>
                                                    <td><span class="badge bg-info"><?php echo $schedule_days; ?></span></td>
                                                    <td><?php echo $time_display; ?></td>
                                                    <td><?php echo htmlspecialchars($sched['room'] ?? 'TBA'); ?></td>
                                                    <td>
                                                        <?php if (!empty($sched['professor_name'])): ?>
                                                            <div><?php echo htmlspecialchars($sched['professor_name']); ?></div>
                                                            <?php if (!empty($sched['professor_initial'])): ?>
                                                                <small class="text-muted"><?php echo htmlspecialchars($sched['professor_initial']); ?></small>
                                                            <?php endif; ?>
                                                        <?php else: ?>
                                                            <span class="text-muted">TBA</span>
                                                        <?php endif; ?>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-secondary"><?php echo htmlspecialchars($sched['section_name']); ?></span>
                                                    </td>
                                                </tr>
                                            <?php endforeach; ?>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Weekly Calendar View -->
                        <div class="card mt-4">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0"><i class="fas fa-calendar-alt me-2"></i>Weekly Calendar View</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered">
                                        <thead class="table-light">
                                            <tr>
                                                <th style="width: 100px;">Time</th>
                                                <th>Monday</th>
                                                <th>Tuesday</th>
                                                <th>Wednesday</th>
                                                <th>Thursday</th>
                                                <th>Friday</th>
                                                <th>Saturday</th>
                                                <th>Sunday</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php
                                            // Create time slots from schedules
                                            $time_slots = [];
                                            foreach ($my_schedules as $sched) {
                                                if (!empty($sched['time_start'])) {
                                                    $time_slots[$sched['time_start']] = $sched['time_start'];
                                                }
                                            }
                                            ksort($time_slots);
                                            
                                            if (empty($time_slots)) {
                                                echo '<tr><td colspan="8" class="text-center text-muted">No scheduled time slots</td></tr>';
                                            } else {
                                                foreach ($time_slots as $time_start) {
                                                    echo '<tr>';
                                                    // Find the matching schedule for end time
                                                    $time_end = '';
                                                    foreach ($my_schedules as $s) {
                                                        if ($s['time_start'] == $time_start && !empty($s['time_end'])) {
                                                            $time_end = $s['time_end'];
                                                            break;
                                                        }
                                                    }
                                                    $time_display = date('g:i A', strtotime($time_start));
                                                    if ($time_end) {
                                                        $time_display .= '<br><small class="text-muted">' . date('g:i A', strtotime($time_end)) . '</small>';
                                                    }
                                                    echo '<td class="text-center">' . $time_display . '</td>';
                                                    
                                                    // Days
                                                    $days_cols = ['schedule_monday', 'schedule_tuesday', 'schedule_wednesday', 'schedule_thursday', 'schedule_friday', 'schedule_saturday', 'schedule_sunday'];
                                                    foreach ($days_cols as $day_col) {
                                                        $found = false;
                                                        foreach ($my_schedules as $sched) {
                                                            if ($sched['time_start'] == $time_start && $sched[$day_col]) {
                                                                echo '<td class="bg-light">';
                                                                echo '<strong class="text-primary">' . htmlspecialchars($sched['course_code']) . '</strong><br>';
                                                                echo '<small>' . htmlspecialchars($sched['course_name']) . '</small><br>';
                                                                echo '<small class="text-muted">' . htmlspecialchars($sched['room'] ?? 'TBA') . '</small><br>';
                                                                echo '<small class="text-info">' . htmlspecialchars($sched['professor_initial'] ?? '') . '</small>';
                                                                echo '</td>';
                                                                $found = true;
                                                                break;
                                                            }
                                                        }
                                                        if (!$found) {
                                                            echo '<td></td>';
                                                        }
                                                    }
                                                    echo '</tr>';
                                                }
                                            }
                                            ?>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    <?php endif; ?>
                </div>
                
                <!-- My Sections Section -->
                <div id="sections" class="content-section" style="display: none;">
                    <h2 class="mb-4">My Sections</h2>
                    
                    <?php if (empty($my_sections)): ?>
                        <div class="card">
                            <div class="card-body text-center py-5">
                                <i class="fas fa-users-class fa-4x text-muted mb-3"></i>
                                <h5>No Sections Assigned</h5>
                                <p class="text-muted">You are not enrolled in any sections yet. Please contact the admin to assign you to sections.</p>
                            </div>
                        </div>
                    <?php else: ?>
                    <div class="row">
                            <?php foreach ($my_sections as $sec): ?>
                            <div class="col-md-6 col-lg-4 mb-4">
                                <div class="card h-100">
                                        <div class="card-header bg-primary text-white">
                                            <h5 class="mb-0"><?php echo htmlspecialchars($sec['section_name']); ?></h5>
                                        </div>
                                        <div class="card-body">
                                            <h6 class="text-primary mb-3"><?php echo htmlspecialchars($sec['program_code']); ?></h6>
                                            
                                            <div class="mb-2">
                                                <i class="fas fa-layer-group text-primary me-2"></i>
                                                <strong>Year Level:</strong> <?php echo $sec['year_level']; ?>
                                            </div>
                                            <div class="mb-2">
                                                <i class="fas fa-calendar-alt text-primary me-2"></i>
                                                <strong>Semester:</strong> <?php echo $sec['semester'] == 1 ? '1st Semester' : '2nd Semester'; ?>
                                            </div>
                                            <div class="mb-2">
                                                <i class="fas fa-calendar text-primary me-2"></i>
                                                <strong>Academic Year:</strong> <?php echo htmlspecialchars($sec['academic_year']); ?>
                                            </div>
                                            <div class="mb-2">
                                                <i class="fas fa-users text-primary me-2"></i>
                                                <strong>Capacity:</strong> <?php echo $sec['current_enrolled'] ?? 0; ?>/<?php echo $sec['max_capacity'] ?? 0; ?>
                                            </div>
                                            <div class="mb-2">
                                                <i class="fas fa-tag text-primary me-2"></i>
                                                <strong>Type:</strong> 
                                                <span class="badge bg-info"><?php echo ucfirst($sec['section_type'] ?? 'regular'); ?></span>
                                            </div>
                                            <div class="mt-3 pt-3 border-top">
                                                <small class="text-muted">
                                                    <i class="fas fa-clock me-1"></i>
                                                    Enrolled: <?php echo date('M j, Y', strtotime($sec['enrolled_date'])); ?>
                                                </small>
                                    </div>
                                    </div>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                    <?php endif; ?>
                </div>
                
                <!-- Enrollment Status Section -->
                <div id="enrollment" class="content-section" style="display: none;">
                    <h2 class="mb-4">Enrollment Status</h2>
                    
                    <?php if (!$enrollment_info): ?>
                        <div class="card">
                            <div class="card-body text-center py-5">
                                <i class="fas fa-user-clock fa-4x text-muted mb-3"></i>
                                <h5>No Enrollment Record</h5>
                                <p class="text-muted">You don't have an enrollment record yet. Please contact the admin for assistance.</p>
                            </div>
                        </div>
                    <?php else: ?>
                        <div class="row">
                            <div class="col-md-8">
                                <div class="card mb-4">
                                    <div class="card-header bg-primary text-white">
                                        <h5 class="mb-0"><i class="fas fa-user-graduate me-2"></i>Enrollment Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <h6 class="text-muted mb-2">Program/Course</h6>
                                                <p class="h5"><?php echo htmlspecialchars($enrollment_info['display_program'] ?? 'N/A'); ?></p>
                                            </div>
                                            <div class="col-md-6">
                                                <h6 class="text-muted mb-2">Student Type</h6>
                                                <p class="h5"><?php echo htmlspecialchars($enrollment_info['student_type'] ?? 'N/A'); ?></p>
                                            </div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <h6 class="text-muted mb-2">Year Level</h6>
                                                <p class="h5"><?php echo htmlspecialchars($enrollment_info['year_level'] ?? 'N/A'); ?></p>
                                            </div>
                                            <div class="col-md-6">
                                                <h6 class="text-muted mb-2">Academic Year</h6>
                                                <p class="h5"><?php echo htmlspecialchars($enrollment_info['academic_year'] ?? 'N/A'); ?></p>
                                            </div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <h6 class="text-muted mb-2">Semester</h6>
                                                <p class="h5"><?php echo htmlspecialchars($enrollment_info['semester'] ?? 'N/A'); ?></p>
                                            </div>
                                            <div class="col-md-6">
                                                <h6 class="text-muted mb-2">Enrollment Status</h6>
                                                <p>
                                                    <?php if (isset($enrollment_info['enrollment_status']) && $enrollment_info['enrollment_status'] == 'enrolled'): ?>
                                                        <span class="badge bg-success" style="font-size: 1.1rem;">
                                                            <i class="fas fa-check-circle me-1"></i>Enrolled
                                                        </span>
                                                    <?php elseif (isset($enrollment_info['enrollment_status']) && $enrollment_info['enrollment_status'] == 'pending'): ?>
                                                        <span class="badge bg-warning" style="font-size: 1.1rem;">
                                                            <i class="fas fa-clock me-1"></i>Pending
                                                        </span>
                                                    <?php else: ?>
                                                        <span class="badge bg-secondary" style="font-size: 1.1rem;">
                                                            <?php echo htmlspecialchars(ucfirst($enrollment_info['enrollment_status'] ?? 'Unknown')); ?>
                                                        </span>
                                                    <?php endif; ?>
                                                </p>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-12">
                                                <h6 class="text-muted mb-2">Registration Date</h6>
                                                <p><i class="fas fa-calendar me-2"></i>
                                                    <?php 
                                                    if (isset($enrollment_info['enrolled_date']) && $enrollment_info['enrolled_date']) {
                                                        echo date('F j, Y', strtotime($enrollment_info['enrolled_date'])); 
                                                    } else {
                                                        echo 'N/A';
                                                    }
                                                    ?>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card">
                                    <div class="card-header bg-info text-white">
                                        <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>Quick Stats</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3 pb-3 border-bottom">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span class="text-muted">Total Sections</span>
                                                <span class="h4 mb-0 text-primary"><?php echo count($my_sections); ?></span>
                                            </div>
                                        </div>
                                        <div class="mb-3 pb-3 border-bottom">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span class="text-muted">Document Progress</span>
                                                <span class="h4 mb-0 text-success">
                                                    <?php 
                                                    $docs = ['birth_certificate', 'report_card', 'good_moral', 'id_photo', 'certificate_of_enrollment', 'medical_certificate', 'transcript_of_records'];
                                                    $completed = 0;
                                                    foreach ($docs as $doc) {
                                                        if ($checklist[$doc]) $completed++;
                                                    }
                                                    echo $completed . '/' . count($docs);
                                                    ?>
                                                </span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span class="text-muted">Enrollment Status</span>
                                                <span class="badge bg-<?php echo (isset($enrollment_info['enrollment_status']) && $enrollment_info['enrollment_status'] == 'enrolled') ? 'success' : 'warning'; ?>">
                                                    <?php echo ucfirst($enrollment_info['enrollment_status'] ?? 'pending'); ?>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <?php endif; ?>
                </div>
            </div>
            
            <?php if ($can_enroll_next): ?>
            <!-- Next Enrollment Section -->
            <div id="next-enrollment" class="content-section" style="display: none;">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2><i class="fas fa-calendar-plus me-2"></i>Enroll for Next Semester</h2>
                        <p class="text-muted">Select sections for <?php echo htmlspecialchars($next_enrollment_info['year_level'] . ' - ' . $next_enrollment_info['semester']); ?></p>
                    </div>
                </div>
                
                <?php
                // Get current program from enrollment info
                $current_program = $enrollment_info['display_program'] ?? $enrollment_info['course'] ?? '';
                $next_year = $next_enrollment_info['year_level'];
                $next_semester = $next_enrollment_info['semester'];
                
                // Get available sections for next semester
                $sections_query = "SELECT 
                    s.id,
                    s.section_name,
                    s.year_level,
                    s.semester,
                    s.academic_year,
                    s.max_capacity,
                    s.current_enrolled,
                    s.section_type,
                    p.program_code,
                    p.program_name
                FROM sections s
                JOIN programs p ON s.program_id = p.id
                WHERE s.year_level = :year_level
                AND s.semester = :semester
                ORDER BY p.program_code, s.section_name";
                
                $sections_stmt = $conn->prepare($sections_query);
                $sections_stmt->bindParam(':year_level', $next_year);
                $sections_stmt->bindParam(':semester', $next_semester);
                $sections_stmt->execute();
                $available_sections = $sections_stmt->fetchAll(PDO::FETCH_ASSOC);
                
                // Check if student already enrolled for next semester
                $check_next_enrollment = "SELECT se.*, s.section_name, s.year_level, s.semester
                                         FROM section_enrollments se
                                         JOIN sections s ON se.section_id = s.id
                                         WHERE se.user_id = :user_id
                                         AND s.year_level = :year_level
                                         AND s.semester = :semester
                                         AND se.status = 'active'";
                $check_stmt = $conn->prepare($check_next_enrollment);
                $check_stmt->bindParam(':user_id', $_SESSION['user_id']);
                $check_stmt->bindParam(':year_level', $next_year);
                $check_stmt->bindParam(':semester', $next_semester);
                $check_stmt->execute();
                $next_enrollments = $check_stmt->fetchAll(PDO::FETCH_ASSOC);
                ?>
                
                <?php if (count($next_enrollments) > 0): ?>
                    <!-- Already Enrolled -->
                    <div class="alert alert-success">
                        <h5><i class="fas fa-check-circle me-2"></i>You're Already Enrolled for Next Semester!</h5>
                        <p class="mb-2">You have successfully enrolled in the following sections:</p>
                        <ul class="mb-0">
                            <?php foreach ($next_enrollments as $enrollment): ?>
                                <li>
                                    <strong><?php echo htmlspecialchars($enrollment['section_name']); ?></strong>
                                    - <?php echo htmlspecialchars($enrollment['year_level'] . ' - ' . $enrollment['semester']); ?>
                                </li>
                            <?php endforeach; ?>
                        </ul>
                    </div>
                <?php else: ?>
                    <!-- Enrollment Form -->
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Next Enrollment Period:</strong> You can now enroll for <?php echo htmlspecialchars($next_year . ' - ' . $next_semester); ?>
                    </div>
                    
                    <!-- Filters -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-filter me-2"></i>Filter Sections</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-4">
                                    <label class="form-label">Program</label>
                                    <select class="form-select" id="filter_next_program" onchange="filterNextSections()">
                                        <option value="">All Programs</option>
                                        <?php
                                        $programs_list = [];
                                        foreach ($available_sections as $sec) {
                                            if (!in_array($sec['program_code'], $programs_list)) {
                                                $programs_list[] = $sec['program_code'];
                                                $selected = ($sec['program_code'] === $current_program) ? 'selected' : '';
                                                echo '<option value="' . htmlspecialchars($sec['program_code']) . '" ' . $selected . '>' . htmlspecialchars($sec['program_code']) . '</option>';
                                            }
                                        }
                                        ?>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Section Type</label>
                                    <select class="form-select" id="filter_next_type" onchange="filterNextSections()">
                                        <option value="">All Types</option>
                                        <option value="Regular">Regular</option>
                                        <option value="Irregular">Irregular</option>
                                        <option value="Special">Special</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Search Section</label>
                                    <input type="text" class="form-control" id="search_next_section" placeholder="Search..." onkeyup="filterNextSections()">
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Available Sections -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-list me-2"></i>Available Sections</h5>
                        </div>
                        <div class="card-body">
                            <div id="next_sections_list" class="row">
                                <?php if (count($available_sections) > 0): ?>
                                    <?php foreach ($available_sections as $section): ?>
                                        <?php
                                        $is_full = $section['current_enrolled'] >= $section['max_capacity'];
                                        $percentage = ($section['max_capacity'] > 0) ? ($section['current_enrolled'] / $section['max_capacity']) * 100 : 0;
                                        ?>
                                        <div class="col-md-6 mb-3 section-card" 
                                             data-program="<?php echo htmlspecialchars($section['program_code']); ?>"
                                             data-type="<?php echo htmlspecialchars($section['section_type']); ?>"
                                             data-name="<?php echo htmlspecialchars($section['section_name']); ?>">
                                            <div class="card h-100 <?php echo $is_full ? 'border-danger' : 'border-primary'; ?>">
                                                <div class="card-body">
                                                    <h5 class="card-title">
                                                        <?php echo htmlspecialchars($section['section_name']); ?>
                                                        <?php if ($is_full): ?>
                                                            <span class="badge bg-danger ms-2">Full</span>
                                                        <?php endif; ?>
                                                    </h5>
                                                    <p class="mb-2">
                                                        <i class="fas fa-graduation-cap me-2"></i>
                                                        <strong><?php echo htmlspecialchars($section['program_code']); ?></strong>
                                                        - <?php echo htmlspecialchars($section['program_name']); ?>
                                                    </p>
                                                    <p class="mb-2">
                                                        <i class="fas fa-calendar me-2"></i>
                                                        <?php echo htmlspecialchars($section['year_level'] . ' - ' . $section['semester']); ?>
                                                    </p>
                                                    <p class="mb-2">
                                                        <i class="fas fa-clock me-2"></i>
                                                        <?php echo htmlspecialchars($section['academic_year']); ?>
                                                    </p>
                                                    <p class="mb-2">
                                                        <i class="fas fa-tag me-2"></i>
                                                        Type: <?php echo htmlspecialchars($section['section_type']); ?>
                                                    </p>
                                                    <div class="mb-3">
                                                        <small class="text-muted">Capacity:</small>
                                                        <div class="progress">
                                                            <div class="progress-bar <?php echo $percentage >= 90 ? 'bg-danger' : ($percentage >= 70 ? 'bg-warning' : 'bg-success'); ?>" 
                                                                 style="width: <?php echo $percentage . '%'; ?>">
                                                                <?php echo $section['current_enrolled']; ?> / <?php echo $section['max_capacity']; ?>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <?php if (!$is_full): ?>
                                                        <button class="btn btn-primary w-100" 
                                                                onclick="enrollNextSemester(<?php echo $section['id']; ?>, '<?php echo htmlspecialchars($section['section_name'], ENT_QUOTES); ?>')">
                                                            <i class="fas fa-check me-2"></i>Enroll in This Section
                                                        </button>
                                                    <?php else: ?>
                                                        <button class="btn btn-secondary w-100" disabled>
                                                            <i class="fas fa-times me-2"></i>Section Full
                                                        </button>
                                                    <?php endif; ?>
                                                </div>
                                            </div>
                                        </div>
                                    <?php endforeach; ?>
                                <?php else: ?>
                                    <div class="col-12">
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            No sections available for <?php echo htmlspecialchars($next_year . ' - ' . $next_semester); ?> yet.
                                            Please check back later.
                                        </div>
                                    </div>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                <?php endif; ?>
            </div>
            <?php endif; ?>
        </div>
    </div>
    
    <!-- Chatbot Floating Button -->
    <button id="chatbotToggle" class="chatbot-toggle" onclick="toggleChatbot()">
        <i class="fas fa-comments"></i>
    </button>
    
    <!-- Chatbot Widget -->
    <div id="chatbotWidget" class="chatbot-widget" style="display: none;">
        <div class="chatbot-header">
            <h6 class="mb-0"><i class="fas fa-robot me-2"></i>Ask me anything!</h6>
            <button class="btn-close btn-close-white" onclick="toggleChatbot()"></button>
        </div>
        <div class="chatbot-body" id="chatbotBody">
            <div class="chatbot-welcome">
                <div class="text-center mb-3">
                    <i class="fas fa-robot fa-3x text-primary"></i>
                </div>
                <h6>Hello! I'm your virtual assistant ðŸ‘‹</h6>
                <p class="small text-muted">I can help you with:</p>
                <ul class="small text-muted">
                    <li>Enrollment information</li>
                    <li>Document requirements</li>
                    <li>Schedule inquiries</li>
                    <li>General questions</li>
                </ul>
                <p class="small"><strong>Type your question below or browse categories:</strong></p>
                <div id="categoriesContainer"></div>
            </div>
            <div id="chatMessages"></div>
        </div>
        <div class="chatbot-footer">
            <form id="chatForm" onsubmit="sendMessage(event)">
                <div class="input-group">
                    <input type="text" class="form-control" id="chatInput" placeholder="Type your question..." required>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <style>
        .chatbot-toggle {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: white;
            border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            font-size: 24px;
            cursor: pointer;
            z-index: 1000;
            transition: all 0.3s;
        }
        
        .chatbot-toggle:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 16px rgba(0,0,0,0.2);
        }
        
        .chatbot-widget {
            position: fixed;
            bottom: 100px;
            right: 30px;
            width: 380px;
            height: 550px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
            z-index: 1001;
            display: flex;
            flex-direction: column;
            animation: slideUp 0.3s;
        }
        
        @keyframes slideUp {
            from {
                transform: translateY(20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        .chatbot-header {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: white;
            padding: 15px;
            border-radius: 15px 15px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .chatbot-body {
            flex: 1;
            padding: 15px;
            overflow-y: auto;
        }
        
        .chatbot-welcome {
            text-align: left;
        }
        
        .chatbot-footer {
            padding: 15px;
            border-top: 1px solid #ddd;
        }
        
        .chat-message {
            margin-bottom: 15px;
            animation: fadeIn 0.3s;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .message-user {
            text-align: right;
        }
        
        .message-user .message-bubble {
            background: #667eea;
            color: white;
            display: inline-block;
            padding: 10px 15px;
            border-radius: 18px 18px 0 18px;
            max-width: 80%;
            word-wrap: break-word;
        }
        
        .message-bot {
            text-align: left;
        }
        
        .message-bot .message-bubble {
            background: #f1f1f1;
            color: #333;
            display: inline-block;
            padding: 10px 15px;
            border-radius: 18px 18px 18px 0;
            max-width: 80%;
            word-wrap: break-word;
        }
        
        .message-time {
            font-size: 11px;
            color: #999;
            margin-top: 5px;
        }
        
        .category-btn {
            display: inline-block;
            margin: 5px;
            padding: 5px 12px;
            background: #f0f0f0;
            border: 1px solid #ddd;
            border-radius: 15px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .category-btn:hover {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        
        .quick-question {
            padding: 8px 12px;
            margin: 5px 0;
            background: #f8f9fa;
            border-left: 3px solid #667eea;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            transition: all 0.2s;
        }
        
        .quick-question:hover {
            background: #e9ecef;
            transform: translateX(5px);
        }
        
        .typing-indicator {
            padding: 10px;
            background: #f1f1f1;
            border-radius: 18px;
            display: inline-block;
        }
        
        .typing-indicator span {
            height: 8px;
            width: 8px;
            background: #999;
            border-radius: 50%;
            display: inline-block;
            margin: 0 2px;
            animation: typing 1.4s infinite;
        }
        
        .typing-indicator span:nth-child(2) {
            animation-delay: 0.2s;
        }
        
        .typing-indicator span:nth-child(3) {
            animation-delay: 0.4s;
        }
        
        @keyframes typing {
            0%, 60%, 100% { transform: translateY(0); }
            30% { transform: translateY(-10px); }
        }
    </style>
    
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
            
            // Add active class to clicked nav link
            event.target.classList.add('active');
        }
        
        // Chatbot functions
        function toggleChatbot() {
            const widget = document.getElementById('chatbotWidget');
            if (widget.style.display === 'none') {
                widget.style.display = 'flex';
                loadCategories();
            } else {
                widget.style.display = 'none';
            }
        }
        
        function loadCategories() {
            fetch('chatbot_query.php?action=get_categories')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const container = document.getElementById('categoriesContainer');
                        container.innerHTML = '';
                        
                        Object.keys(data.categories).forEach(category => {
                            const btn = document.createElement('span');
                            btn.className = 'category-btn';
                            btn.textContent = category;
                            btn.onclick = () => showCategory(category, data.categories[category]);
                            container.appendChild(btn);
                        });
                    }
                })
                .catch(error => console.error('Error:', error));
        }
        
        function showCategory(category, faqs) {
            const welcome = document.querySelector('.chatbot-welcome');
            welcome.style.display = 'none';
            
            const chatMessages = document.getElementById('chatMessages');
            chatMessages.innerHTML = '<div class="mb-3"><button class="btn btn-sm btn-outline-secondary" onclick="resetChat()"><i class="fas fa-arrow-left me-1"></i>Back</button></div>';
            
            const categoryDiv = document.createElement('div');
            categoryDiv.innerHTML = `<h6 class="mb-3"><i class="fas fa-folder me-2"></i>${category}</h6>`;
            
            faqs.forEach(faq => {
                const questionDiv = document.createElement('div');
                questionDiv.className = 'quick-question';
                questionDiv.textContent = faq.question;
                questionDiv.onclick = () => selectQuestion(faq.question);
                categoryDiv.appendChild(questionDiv);
            });
            
            chatMessages.appendChild(categoryDiv);
        }
        
        function resetChat() {
            document.querySelector('.chatbot-welcome').style.display = 'block';
            document.getElementById('chatMessages').innerHTML = '';
        }
        
        function selectQuestion(question) {
            document.getElementById('chatInput').value = question;
            const event = new Event('submit', { bubbles: true, cancelable: true });
            document.getElementById('chatForm').dispatchEvent(event);
        }
        
        function sendMessage(event) {
            event.preventDefault();
            
            const input = document.getElementById('chatInput');
            const question = input.value.trim();
            
            if (!question) return;
            
            // Hide welcome message
            document.querySelector('.chatbot-welcome').style.display = 'none';
            
            // Display user message
            addMessage(question, 'user');
            input.value = '';
            
            // Show typing indicator
            const chatMessages = document.getElementById('chatMessages');
            const typingDiv = document.createElement('div');
            typingDiv.className = 'chat-message message-bot';
            typingDiv.id = 'typingIndicator';
            typingDiv.innerHTML = '<div class="typing-indicator"><span></span><span></span><span></span></div>';
            chatMessages.appendChild(typingDiv);
            chatMessages.scrollTop = chatMessages.scrollHeight;
            
            // Send query to server
            const formData = new FormData();
            formData.append('action', 'search');
            formData.append('query', question);
            
            fetch('chatbot_query.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                // Remove typing indicator
                document.getElementById('typingIndicator')?.remove();
                
                if (data.success) {
                    if (data.results && data.results.length > 0) {
                        // Display best match
                        const answer = data.results[0].answer;
                        addMessage(answer, 'bot');
                        
                        // Show other matches if available
                        if (data.results.length > 1) {
                            const moreDiv = document.createElement('div');
                            moreDiv.className = 'chat-message message-bot';
                            moreDiv.innerHTML = '<div class="message-bubble"><small><strong>Related questions:</strong></small></div>';
                            
                            const relatedDiv = document.createElement('div');
                            relatedDiv.className = 'mt-2';
                            data.results.slice(1, 3).forEach(result => {
                                const relatedQ = document.createElement('div');
                                relatedQ.className = 'quick-question';
                                relatedQ.textContent = result.question;
                                relatedQ.onclick = () => selectQuestion(result.question);
                                relatedDiv.appendChild(relatedQ);
                            });
                            
                            moreDiv.appendChild(relatedDiv);
                            chatMessages.appendChild(moreDiv);
                        }
                    } else {
                        // No results
                        addMessage(data.message || 'I couldn\'t find an answer to that question. Please contact the admin for assistance.', 'bot');
                    }
                } else {
                    addMessage('Sorry, something went wrong. Please try again.', 'bot');
                }
                
                chatMessages.scrollTop = chatMessages.scrollHeight;
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('typingIndicator')?.remove();
                addMessage('Sorry, I\'m having trouble connecting. Please try again later.', 'bot');
            });
        }
        
        function addMessage(text, type) {
            const chatMessages = document.getElementById('chatMessages');
            const messageDiv = document.createElement('div');
            messageDiv.className = `chat-message message-${type}`;
            
            const bubble = document.createElement('div');
            bubble.className = 'message-bubble';
            bubble.textContent = text;
            
            messageDiv.appendChild(bubble);
            
            const time = document.createElement('div');
            time.className = 'message-time';
            time.textContent = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
            messageDiv.appendChild(time);
            
            chatMessages.appendChild(messageDiv);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }
        
        // Next Enrollment Functions
        function filterNextSections() {
            const programFilter = document.getElementById('filter_next_program').value.toLowerCase();
            const typeFilter = document.getElementById('filter_next_type').value.toLowerCase();
            const searchText = document.getElementById('search_next_section').value.toLowerCase();
            
            const sectionCards = document.querySelectorAll('#next_sections_list .section-card');
            
            sectionCards.forEach(card => {
                const program = card.getAttribute('data-program').toLowerCase();
                const type = card.getAttribute('data-type').toLowerCase();
                const name = card.getAttribute('data-name').toLowerCase();
                
                const programMatch = !programFilter || program === programFilter;
                const typeMatch = !typeFilter || type === typeFilter;
                const searchMatch = !searchText || name.includes(searchText);
                
                if (programMatch && typeMatch && searchMatch) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }
        
        function enrollNextSemester(sectionId, sectionName) {
            if (!confirm('Are you sure you want to enroll in ' + sectionName + ' for next semester?')) {
                return;
            }
            
            const formData = new FormData();
            formData.append('section_id', sectionId);
            
            fetch('process_next_enrollment.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Success! You have been enrolled for next semester.');
                    location.reload();
                } else {
                    alert('Error: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred while enrolling. Please try again.');
            });
        }
    </script>
    
    <?php inject_session_js(); ?>
</body>
</html>
