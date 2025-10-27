<?php
require_once '../config/database.php';
require_once '../config/session_helper.php';
require_once '../classes/Course.php';
require_once '../classes/Enrollment.php';
require_once '../classes/User.php';

// Check if user is logged in and is a student
if (!isLoggedIn() || isAdmin()) {
    redirect('public/login.php');
}

$course = new Course();
$enrollment = new Enrollment();
$user = new User();

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

$available_courses = $course->getAllCourses();
$my_enrollments = $enrollment->getStudentEnrollments($_SESSION['user_id']);

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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
                    <a href="#" class="nav-link" onclick="showSection('courses')">
                        <i class="fas fa-book me-2"></i>Available Courses
                    </a>
                    <a href="#" class="nav-link" onclick="showSection('enrollments')">
                        <i class="fas fa-list me-2"></i>My Enrollments
                    </a>
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
                                    <i class="fas fa-book fa-3x text-primary mb-3"></i>
                                    <h3 class="text-primary"><?php echo count($my_enrollments); ?></h3>
                                    <p class="mb-0">Total Enrollments</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card text-center">
                                <div class="card-body">
                                    <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                                    <h3 class="text-success"><?php echo count(array_filter($my_enrollments, function($e) { return $e['status'] == 'enrolled'; })); ?></h3>
                                    <p class="mb-0">Enrolled Courses</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card text-center">
                                <div class="card-body">
                                    <i class="fas fa-clock fa-3x text-warning mb-3"></i>
                                    <h3 class="text-warning"><?php echo count(array_filter($my_enrollments, function($e) { return $e['status'] == 'waitlisted'; })); ?></h3>
                                    <p class="mb-0">Waitlisted</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-8 mb-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0"><i class="fas fa-calendar me-2"></i>Quick Overview</h5>
                                </div>
                                <div class="card-body">
                                    <h6>Recent Enrollments:</h6>
                                    <?php if (empty($my_enrollments)): ?>
                                        <p class="text-muted">No enrollments yet. Browse available courses to get started!</p>
                                    <?php else: ?>
                                        <div class="row">
                                            <?php foreach (array_slice($my_enrollments, 0, 3) as $enroll): ?>
                                                <div class="col-md-6 mb-2">
                                                    <div class="border rounded p-3">
                                                        <h6 class="mb-1"><?php echo htmlspecialchars($enroll['course_code']); ?></h6>
                                                        <p class="mb-1 small"><?php echo htmlspecialchars($enroll['course_name']); ?></p>
                                                        <span class="badge status-badge status-<?php echo $enroll['status']; ?>"><?php echo ucfirst($enroll['status']); ?></span>
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
                
                <!-- Available Courses Section -->
                <div id="courses" class="content-section" style="display: none;">
                    <h2 class="mb-4">Available Courses</h2>
                    
                    <div class="row">
                        <?php foreach ($available_courses as $course_item): ?>
                            <div class="col-md-6 col-lg-4 mb-4">
                                <div class="card h-100">
                                    <div class="card-header">
                                        <h6 class="mb-0"><?php echo htmlspecialchars($course_item['course_code']); ?></h6>
                                    </div>
                                    <div class="card-body">
                                        <h6><?php echo htmlspecialchars($course_item['course_name']); ?></h6>
                                        <p class="small text-muted"><?php echo htmlspecialchars($course_item['description']); ?></p>
                                        
                                        <div class="small mb-2">
                                            <strong>Department:</strong> <?php echo htmlspecialchars($course_item['department_name']); ?><br>
                                            <strong>Credits:</strong> <?php echo $course_item['credits']; ?><br>
                                            <strong>Instructor:</strong> <?php echo htmlspecialchars($course_item['instructor_name']); ?><br>
                                            <strong>Schedule:</strong> <?php echo htmlspecialchars($course_item['schedule_days'] . ' ' . $course_item['schedule_time']); ?><br>
                                            <strong>Capacity:</strong> <?php echo $course_item['enrolled_count']; ?>/<?php echo $course_item['max_capacity']; ?>
                                        </div>
                                        
                                        <?php if ($course_item['prerequisites']): ?>
                                            <div class="small text-warning mb-2">
                                                <strong>Prerequisites:</strong> <?php echo htmlspecialchars($course_item['prerequisites']); ?>
                                            </div>
                                        <?php endif; ?>
                                    </div>
                                    <div class="card-footer">
                                        <?php
                                        $already_enrolled = false;
                                        foreach ($my_enrollments as $my_enroll) {
                                            if ($my_enroll['course_id'] == $course_item['id']) {
                                                $already_enrolled = true;
                                                break;
                                            }
                                        }
                                        ?>
                                        
                                        <?php if ($already_enrolled): ?>
                                            <button class="btn btn-secondary btn-sm w-100" disabled>
                                                <i class="fas fa-check me-2"></i>Already Enrolled
                                            </button>
                                        <?php else: ?>
                                            <form method="POST" action="enroll.php" style="display: inline;">
                                                <input type="hidden" name="course_id" value="<?php echo $course_item['id']; ?>">
                                                <button type="submit" class="btn btn-enroll text-white btn-sm w-100">
                                                    <i class="fas fa-plus me-2"></i>Enroll
                                                </button>
                                            </form>
                                        <?php endif; ?>
                                    </div>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                </div>
                
                <!-- My Enrollments Section -->
                <div id="enrollments" class="content-section" style="display: none;">
                    <h2 class="mb-4">My Enrollments</h2>
                    
                    <?php if (empty($my_enrollments)): ?>
                        <div class="card">
                            <div class="card-body text-center">
                                <i class="fas fa-book-open fa-4x text-muted mb-3"></i>
                                <h5>No Enrollments Yet</h5>
                                <p class="text-muted">You haven't enrolled in any courses yet. Browse available courses to get started!</p>
                                <button class="btn btn-primary" onclick="showSection('courses')">Browse Courses</button>
                            </div>
                        </div>
                    <?php else: ?>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Course Code</th>
                                        <th>Course Name</th>
                                        <th>Instructor</th>
                                        <th>Schedule</th>
                                        <th>Credits</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($my_enrollments as $enroll): ?>
                                        <tr>
                                            <td><strong><?php echo htmlspecialchars($enroll['course_code']); ?></strong></td>
                                            <td><?php echo htmlspecialchars($enroll['course_name']); ?></td>
                                            <td><?php echo htmlspecialchars($enroll['instructor_name']); ?></td>
                                            <td><?php echo htmlspecialchars($enroll['schedule_days'] . ' ' . $enroll['schedule_time']); ?></td>
                                            <td><?php echo $enroll['credits']; ?></td>
                                            <td>
                                                <span class="badge status-badge status-<?php echo $enroll['status']; ?>">
                                                    <?php echo ucfirst($enroll['status']); ?>
                                                </span>
                                            </td>
                                            <td>
                                                <form method="POST" action="drop.php" style="display: inline;" 
                                                      onsubmit="return confirm('Are you sure you want to drop this course?')">
                                                    <input type="hidden" name="course_id" value="<?php echo $enroll['course_id']; ?>">
                                                    <button type="submit" class="btn btn-drop text-white btn-sm">
                                                        <i class="fas fa-times me-1"></i>Drop
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>
                    <?php endif; ?>
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
            
            // Add active class to clicked nav link
            event.target.classList.add('active');
        }
    </script>
    
    <?php inject_session_js(); ?>
</body>
</html>
