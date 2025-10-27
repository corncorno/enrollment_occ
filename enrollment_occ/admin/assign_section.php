<?php
require_once '../config/database.php';
require_once '../config/session_helper.php';

// Check if user is logged in and is an admin
if (!isLoggedIn() || !isAdmin()) {
    http_response_code(403);
    echo json_encode(['success' => false, 'message' => 'Unauthorized access']);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    exit();
}

$db = new Database();
$conn = $db->getConnection();

try {
    $user_id = $_POST['user_id'] ?? null;
    $section_id = $_POST['section_id'] ?? null;
    
    if (!$user_id || !$section_id) {
        throw new Exception('Missing required parameters');
    }
    
    // Check if student exists
    $check_student = $conn->prepare("SELECT id, first_name, last_name FROM users WHERE id = :user_id AND role = 'student'");
    $check_student->bindParam(':user_id', $user_id);
    $check_student->execute();
    $student = $check_student->fetch(PDO::FETCH_ASSOC);
    
    if (!$student) {
        throw new Exception('Student not found');
    }
    
    // Check if section exists and has capacity
    $check_section = $conn->prepare("SELECT id, section_name, max_capacity, current_enrolled FROM sections WHERE id = :section_id");
    $check_section->bindParam(':section_id', $section_id);
    $check_section->execute();
    $section = $check_section->fetch(PDO::FETCH_ASSOC);
    
    if (!$section) {
        throw new Exception('Section not found');
    }
    
    if ($section['current_enrolled'] >= $section['max_capacity']) {
        throw new Exception('Section is full');
    }
    
    // Check if student has any enrollment record for this section (active or dropped)
    $check_any_enrollment = $conn->prepare("SELECT id, status FROM section_enrollments WHERE user_id = :user_id AND section_id = :section_id");
    $check_any_enrollment->bindParam(':user_id', $user_id);
    $check_any_enrollment->bindParam(':section_id', $section_id);
    $check_any_enrollment->execute();
    $existing_enrollment = $check_any_enrollment->fetch(PDO::FETCH_ASSOC);
    
    // If already actively enrolled, return error
    if ($existing_enrollment && $existing_enrollment['status'] === 'active') {
        throw new Exception('Student is already enrolled in this section');
    }
    
    // Check if student is enrolled in another section with same year level and semester
    $check_conflict = $conn->prepare("
        SELECT s.section_name, s.year_level, s.semester 
        FROM section_enrollments se 
        JOIN sections s ON se.section_id = s.id 
        WHERE se.user_id = :user_id 
        AND se.status = 'active'
        AND se.section_id != :section_id
        AND s.year_level = (SELECT year_level FROM sections WHERE id = :section_id)
        AND s.semester = (SELECT semester FROM sections WHERE id = :section_id)
    ");
    $check_conflict->bindParam(':user_id', $user_id);
    $check_conflict->bindParam(':section_id', $section_id);
    $check_conflict->execute();
    $conflict = $check_conflict->fetch(PDO::FETCH_ASSOC);
    
    if ($conflict) {
        throw new Exception('Student is already enrolled in section ' . $conflict['section_name'] . ' for ' . $conflict['year_level'] . ' - ' . $conflict['semester']);
    }
    
    // Begin transaction
    $conn->beginTransaction();
    
    // If there's a dropped enrollment, reactivate it
    if ($existing_enrollment && $existing_enrollment['status'] === 'dropped') {
        $reactivate_enrollment = $conn->prepare("
            UPDATE section_enrollments 
            SET status = 'active', enrolled_date = NOW() 
            WHERE id = :enrollment_id
        ");
        $reactivate_enrollment->bindParam(':enrollment_id', $existing_enrollment['id']);
        $reactivate_enrollment->execute();
    } else {
        // Insert new enrollment
        $insert_enrollment = $conn->prepare("
            INSERT INTO section_enrollments (section_id, user_id, enrolled_date, status) 
            VALUES (:section_id, :user_id, NOW(), 'active')
        ");
        $insert_enrollment->bindParam(':section_id', $section_id);
        $insert_enrollment->bindParam(':user_id', $user_id);
        $insert_enrollment->execute();
    }
    
    // Update section current_enrolled count
    $update_section = $conn->prepare("UPDATE sections SET current_enrolled = current_enrolled + 1 WHERE id = :section_id");
    $update_section->bindParam(':section_id', $section_id);
    $update_section->execute();
    
    // Commit transaction
    $conn->commit();
    
    $_SESSION['message'] = 'Section assigned successfully to ' . $student['first_name'] . ' ' . $student['last_name'];
    
    echo json_encode([
        'success' => true, 
        'message' => 'Section assigned successfully',
        'section_name' => $section['section_name']
    ]);
    
} catch (Exception $e) {
    if ($conn->inTransaction()) {
        $conn->rollBack();
    }
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
?>

