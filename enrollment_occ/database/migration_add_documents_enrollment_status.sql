-- Migration Script: Add Document Checklists and Enrollment Status
-- Run this script if you already have an existing enrollment_occ database

USE enrollment_occ;

-- Add enrollment_status field to users table if it doesn't exist
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS enrollment_status ENUM('enrolled', 'pending') DEFAULT 'pending' 
AFTER status;

-- Create document_checklists table if it doesn't exist
CREATE TABLE IF NOT EXISTS document_checklists (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    birth_certificate BOOLEAN DEFAULT FALSE,
    report_card BOOLEAN DEFAULT FALSE,
    good_moral BOOLEAN DEFAULT FALSE,
    id_photo BOOLEAN DEFAULT FALSE,
    certificate_of_enrollment BOOLEAN DEFAULT FALSE,
    medical_certificate BOOLEAN DEFAULT FALSE,
    transcript_of_records BOOLEAN DEFAULT FALSE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_checklist (user_id)
);

-- Create document checklists for existing students
INSERT IGNORE INTO document_checklists (user_id)
SELECT id FROM users WHERE role = 'student';

SELECT 'Migration completed successfully!' as message;

