<?php
require_once '../config/database.php';
require_once '../config/session_helper.php';
require_once '../classes/User.php';

// Check if user is logged in and is an admin
if (!isLoggedIn() || !isAdmin()) {
    redirect('public/login.php');
}

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['user_id']) && isset($_POST['status'])) {
    $user = new User();
    $user_id = (int)$_POST['user_id'];
    $status = $_POST['status'];
    
    if ($user->updateUserStatus($user_id, $status)) {
        $_SESSION['message'] = 'User status updated successfully.';
    } else {
        $_SESSION['message'] = 'Error updating user status.';
    }
}

redirect('admin/dashboard.php');
?>
