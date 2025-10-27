-- Migration Script: Add Enrolled Students Table
-- Run this script if you already have an existing enrollment_occ database

USE enrollment_occ;

-- Create enrolled_students table if it doesn't exist
CREATE TABLE IF NOT EXISTS enrolled_students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    student_id VARCHAR(20) NOT NULL,
    course VARCHAR(100),
    year_level ENUM('1st Year', '2nd Year', '3rd Year', '4th Year', '5th Year') DEFAULT '1st Year',
    student_type ENUM('Regular', 'Irregular') DEFAULT 'Regular',
    enrolled_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    academic_year VARCHAR(20),
    semester VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrolled_student (user_id)
);

-- Migrate existing enrolled students (those with enrollment_status = 'enrolled')
INSERT IGNORE INTO enrolled_students (user_id, student_id, academic_year, semester)
SELECT 
    id, 
    student_id, 
    'AY 2024-2025',
    'Fall 2024'
FROM users 
WHERE role = 'student' AND enrollment_status = 'enrolled';

SELECT 'Migration completed successfully!' as message;
SELECT COUNT(*) as enrolled_students_count FROM enrolled_students;

