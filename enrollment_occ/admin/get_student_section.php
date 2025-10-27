<?php
require_once '../config/database.php';
require_once '../config/session_helper.php';

// Check if user is logged in and is an admin
if (!isLoggedIn() || !isAdmin()) {
    http_response_code(403);
    echo json_encode(['success' => false, 'message' => 'Unauthorized access']);
    exit();
}

$db = new Database();
$conn = $db->getConnection();

$user_id = $_GET['user_id'] ?? null;

if (!$user_id) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Missing user_id']);
    exit();
}

try {
    $query = "SELECT se.id as enrollment_id, se.section_id, se.enrolled_date, 
              s.section_name, s.year_level, s.semester, s.academic_year,
              p.program_code, p.program_name
              FROM section_enrollments se
              JOIN sections s ON se.section_id = s.id
              JOIN programs p ON s.program_id = p.id
              WHERE se.user_id = :user_id AND se.status = 'active'
              ORDER BY se.enrolled_date DESC";
    
    $stmt = $conn->prepare($query);
    $stmt->bindParam(':user_id', $user_id);
    $stmt->execute();
    
    $sections = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode(['success' => true, 'sections' => $sections]);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
?>

