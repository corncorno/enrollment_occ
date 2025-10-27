<?php
require_once '../config/database.php';
require_once '../config/session_helper.php';
require_once '../classes/Section.php';

// Check if user is logged in and is an admin
if (!isLoggedIn() || !isAdmin()) {
    redirect('public/login.php');
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = [
        'program_id' => (int)$_POST['program_id'],
        'year_level' => $_POST['year_level'],
        'semester' => $_POST['semester'],
        'section_name' => sanitizeInput($_POST['section_name']),
        'section_type' => $_POST['section_type'],
        'max_capacity' => (int)$_POST['max_capacity'],
        'academic_year' => sanitizeInput($_POST['academic_year']),
        'status' => 'active'
    ];
    
    $section = new Section();
    
    if ($section->addSection($data)) {
        $_SESSION['message'] = 'Section added successfully';
    } else {
        $_SESSION['message'] = 'Error adding section. Section may already exist.';
    }
}

redirect('dashboard.php#sections');
?>


