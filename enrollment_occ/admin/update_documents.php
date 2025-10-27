<?php
require_once '../config/database.php';
require_once '../config/session_helper.php';

// Check if user is logged in and is an admin
if (!isLoggedIn() || !isAdmin()) {
    redirect('../public/login.php');
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_POST['user_id'];
    
    // Get checkbox values (unchecked boxes won't be in $_POST)
    $birth_certificate = isset($_POST['birth_certificate']) ? 1 : 0;
    $report_card = isset($_POST['report_card']) ? 1 : 0;
    $good_moral = isset($_POST['good_moral']) ? 1 : 0;
    $id_photo = isset($_POST['id_photo']) ? 1 : 0;
    $certificate_of_enrollment = isset($_POST['certificate_of_enrollment']) ? 1 : 0;
    $medical_certificate = isset($_POST['medical_certificate']) ? 1 : 0;
    $transcript_of_records = isset($_POST['transcript_of_records']) ? 1 : 0;
    
    try {
        $db = new Database();
        $conn = $db->getConnection();
        
        // Check if checklist exists
        $check_sql = "SELECT id FROM document_checklists WHERE user_id = :user_id";
        $check_stmt = $conn->prepare($check_sql);
        $check_stmt->bindParam(':user_id', $user_id);
        $check_stmt->execute();
        
        if ($check_stmt->rowCount() > 0) {
            // Update existing checklist
            $sql = "UPDATE document_checklists SET 
                    birth_certificate = :birth_certificate,
                    report_card = :report_card,
                    good_moral = :good_moral,
                    id_photo = :id_photo,
                    certificate_of_enrollment = :certificate_of_enrollment,
                    medical_certificate = :medical_certificate,
                    transcript_of_records = :transcript_of_records
                    WHERE user_id = :user_id";
        } else {
            // Insert new checklist
            $sql = "INSERT INTO document_checklists 
                    (user_id, birth_certificate, report_card, good_moral, id_photo, 
                     certificate_of_enrollment, medical_certificate, transcript_of_records) 
                    VALUES 
                    (:user_id, :birth_certificate, :report_card, :good_moral, :id_photo, 
                     :certificate_of_enrollment, :medical_certificate, :transcript_of_records)";
        }
        
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':user_id', $user_id);
        $stmt->bindParam(':birth_certificate', $birth_certificate);
        $stmt->bindParam(':report_card', $report_card);
        $stmt->bindParam(':good_moral', $good_moral);
        $stmt->bindParam(':id_photo', $id_photo);
        $stmt->bindParam(':certificate_of_enrollment', $certificate_of_enrollment);
        $stmt->bindParam(':medical_certificate', $medical_certificate);
        $stmt->bindParam(':transcript_of_records', $transcript_of_records);
        
        if ($stmt->execute()) {
            $_SESSION['message'] = 'Document checklist updated successfully';
        } else {
            $_SESSION['message'] = 'Failed to update document checklist';
        }
        
    } catch(PDOException $e) {
        $_SESSION['message'] = 'Database error: ' . $e->getMessage();
    }
}

redirect('admin/dashboard.php');
?>

