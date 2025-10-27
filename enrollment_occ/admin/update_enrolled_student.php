<?php
require_once '../config/database.php';
require_once '../config/session_helper.php';

// Check if user is logged in and is an admin
if (!isLoggedIn() || !isAdmin()) {
    redirect('../public/login.php');
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_POST['user_id'];
    $course = $_POST['course'] ?? '';
    $year_level = $_POST['year_level'] ?? '1st Year';
    $student_type = $_POST['student_type'] ?? 'Regular';
    $academic_year = $_POST['academic_year'] ?? 'AY 2024-2025';
    $semester = $_POST['semester'] ?? 'Fall 2024';
    
    try {
        $db = new Database();
        $conn = $db->getConnection();
        
        // Check if record exists
        $check_sql = "SELECT id FROM enrolled_students WHERE user_id = :user_id";
        $check_stmt = $conn->prepare($check_sql);
        $check_stmt->bindParam(':user_id', $user_id);
        $check_stmt->execute();
        
        if ($check_stmt->rowCount() > 0) {
            // Update existing record
            $sql = "UPDATE enrolled_students 
                    SET course = :course, 
                        year_level = :year_level, 
                        student_type = :student_type,
                        academic_year = :academic_year,
                        semester = :semester
                    WHERE user_id = :user_id";
        } else {
            // Get student_id
            $user_sql = "SELECT student_id FROM users WHERE id = :user_id";
            $user_stmt = $conn->prepare($user_sql);
            $user_stmt->bindParam(':user_id', $user_id);
            $user_stmt->execute();
            $user_data = $user_stmt->fetch(PDO::FETCH_ASSOC);
            
            // Insert new record
            $sql = "INSERT INTO enrolled_students 
                    (user_id, student_id, course, year_level, student_type, academic_year, semester) 
                    VALUES 
                    (:user_id, :student_id, :course, :year_level, :student_type, :academic_year, :semester)";
        }
        
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':user_id', $user_id);
        if ($check_stmt->rowCount() == 0) {
            $stmt->bindParam(':student_id', $user_data['student_id']);
        }
        $stmt->bindParam(':course', $course);
        $stmt->bindParam(':year_level', $year_level);
        $stmt->bindParam(':student_type', $student_type);
        $stmt->bindParam(':academic_year', $academic_year);
        $stmt->bindParam(':semester', $semester);
        
        if ($stmt->execute()) {
            $_SESSION['message'] = 'Enrolled student information updated successfully';
        } else {
            $_SESSION['message'] = 'Failed to update enrolled student information';
        }
        
    } catch(PDOException $e) {
        $_SESSION['message'] = 'Database error: ' . $e->getMessage();
    }
}

redirect('admin/dashboard.php');
?>

