<?php
require_once '../config/database.php';
require_once '../config/session_helper.php';

// Check if user is logged in and is an admin
if (!isLoggedIn() || !isAdmin()) {
    redirect('../public/login.php');
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_POST['user_id'];
    $enrollment_status = $_POST['enrollment_status'];
    
    try {
        $db = new Database();
        $conn = $db->getConnection();
        
        // Update enrollment status in users table
        $sql = "UPDATE users SET enrollment_status = :enrollment_status WHERE id = :user_id";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':enrollment_status', $enrollment_status);
        $stmt->bindParam(':user_id', $user_id);
        
        if ($stmt->execute()) {
            // If status is 'enrolled', add/update in enrolled_students table
            if ($enrollment_status == 'enrolled') {
                // Get student information
                $user_sql = "SELECT student_id FROM users WHERE id = :user_id";
                $user_stmt = $conn->prepare($user_sql);
                $user_stmt->bindParam(':user_id', $user_id);
                $user_stmt->execute();
                $user_data = $user_stmt->fetch(PDO::FETCH_ASSOC);
                
                if ($user_data) {
                    // Check if already in enrolled_students table
                    $check_sql = "SELECT id FROM enrolled_students WHERE user_id = :user_id";
                    $check_stmt = $conn->prepare($check_sql);
                    $check_stmt->bindParam(':user_id', $user_id);
                    $check_stmt->execute();
                    
                    if ($check_stmt->rowCount() == 0) {
                        // Insert into enrolled_students table
                        $enrolled_sql = "INSERT INTO enrolled_students (user_id, student_id, academic_year, semester) 
                                        VALUES (:user_id, :student_id, 'AY 2024-2025', 'Fall 2024')";
                        $enrolled_stmt = $conn->prepare($enrolled_sql);
                        $enrolled_stmt->bindParam(':user_id', $user_id);
                        $enrolled_stmt->bindParam(':student_id', $user_data['student_id']);
                        $enrolled_stmt->execute();
                    }
                }
            } else if ($enrollment_status == 'pending') {
                // If status changed to pending, remove from enrolled_students table
                $remove_sql = "DELETE FROM enrolled_students WHERE user_id = :user_id";
                $remove_stmt = $conn->prepare($remove_sql);
                $remove_stmt->bindParam(':user_id', $user_id);
                $remove_stmt->execute();
            }
            
            $_SESSION['message'] = 'Enrollment status updated successfully';
            
            // Redirect to appropriate section based on new status
            if ($enrollment_status == 'enrolled') {
                header('Location: dashboard.php#enrolled-students');
                exit;
            } else {
                header('Location: dashboard.php#pending-students');
                exit;
            }
        } else {
            $_SESSION['message'] = 'Failed to update enrollment status';
        }
        
    } catch(PDOException $e) {
        $_SESSION['message'] = 'Database error: ' . $e->getMessage();
    }
}

redirect('admin/dashboard.php');
?>

