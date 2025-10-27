<?php
require_once '../config/database.php';
require_once '../config/session_helper.php';
require_once '../classes/Section.php';

// Check if user is logged in and is an admin
if (!isLoggedIn() || !isAdmin()) {
    http_response_code(403);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

if (!isset($_GET['section_id'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Section ID required']);
    exit;
}

$section_id = $_GET['section_id'];

try {
    $section = new Section();
    $schedule = $section->getSectionSchedule($section_id);
    
    header('Content-Type: application/json');
    echo json_encode(['schedule' => $schedule]);
    
} catch(Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Error: ' . $e->getMessage()]);
}
?>

