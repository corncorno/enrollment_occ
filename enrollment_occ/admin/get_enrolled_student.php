<?php
require_once '../config/database.php';
require_once '../config/session_helper.php';

// Check if user is logged in and is an admin
if (!isLoggedIn() || !isAdmin()) {
    http_response_code(403);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

if (!isset($_GET['user_id'])) {
    http_response_code(400);
    echo json_encode(['error' => 'User ID required']);
    exit;
}

$user_id = $_GET['user_id'];

try {
    $db = new Database();
    $conn = $db->getConnection();
    
    // Get enrolled student data along with section information
    $sql = "SELECT es.*, 
            GROUP_CONCAT(DISTINCT p.program_code ORDER BY p.program_code SEPARATOR ', ') as section_programs,
            GROUP_CONCAT(DISTINCT s.year_level ORDER BY s.year_level SEPARATOR ', ') as section_year_levels,
            GROUP_CONCAT(DISTINCT s.semester ORDER BY s.semester SEPARATOR ', ') as section_semesters,
            GROUP_CONCAT(DISTINCT s.academic_year ORDER BY s.academic_year SEPARATOR ', ') as section_academic_years,
            GROUP_CONCAT(DISTINCT s.section_name ORDER BY s.section_name SEPARATOR ', ') as section_names
            FROM enrolled_students es
            LEFT JOIN section_enrollments se ON es.user_id = se.user_id AND se.status = 'active'
            LEFT JOIN sections s ON se.section_id = s.id
            LEFT JOIN programs p ON s.program_id = p.id
            WHERE es.user_id = :user_id
            GROUP BY es.id";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':user_id', $user_id);
    $stmt->execute();
    
    $enrolled_student = $stmt->fetch(PDO::FETCH_ASSOC);
    
    // If no record exists, return default values
    if (!$enrolled_student) {
        $enrolled_student = [
            'course' => '',
            'year_level' => '1st Year',
            'student_type' => 'Regular',
            'academic_year' => 'AY 2024-2025',
            'semester' => 'Fall 2024',
            'section_programs' => null,
            'section_year_levels' => null,
            'section_semesters' => null,
            'section_academic_years' => null,
            'section_names' => null
        ];
    } else {
        // Use section data if available, otherwise use enrolled_students data
        $enrolled_student['display_course'] = $enrolled_student['section_programs'] ?? $enrolled_student['course'] ?? '';
        $enrolled_student['display_year_level'] = $enrolled_student['section_year_levels'] ?? $enrolled_student['year_level'] ?? '1st Year';
        $enrolled_student['display_semester'] = $enrolled_student['section_semesters'] ?? $enrolled_student['semester'] ?? 'Fall 2024';
        $enrolled_student['display_academic_year'] = $enrolled_student['section_academic_years'] ?? $enrolled_student['academic_year'] ?? 'AY 2024-2025';
    }
    
    header('Content-Type: application/json');
    echo json_encode($enrolled_student);
    
} catch(PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
?>

