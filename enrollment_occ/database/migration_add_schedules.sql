-- Migration Script: Add Section Schedules
-- This script creates the section_schedules table for managing class schedules

USE enrollment_occ;

-- Create section schedules table
CREATE TABLE IF NOT EXISTS section_schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    section_id INT NOT NULL,
    curriculum_id INT NOT NULL,
    course_code VARCHAR(20) NOT NULL,
    course_name VARCHAR(200) NOT NULL,
    units INT DEFAULT 3,
    schedule_monday BOOLEAN DEFAULT FALSE,
    schedule_tuesday BOOLEAN DEFAULT FALSE,
    schedule_wednesday BOOLEAN DEFAULT FALSE,
    schedule_thursday BOOLEAN DEFAULT FALSE,
    schedule_friday BOOLEAN DEFAULT FALSE,
    schedule_saturday BOOLEAN DEFAULT FALSE,
    schedule_sunday BOOLEAN DEFAULT FALSE,
    time_start VARCHAR(10),
    time_end VARCHAR(10),
    room VARCHAR(50),
    professor_name VARCHAR(100),
    professor_initial VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE,
    FOREIGN KEY (curriculum_id) REFERENCES curriculum(id) ON DELETE CASCADE,
    UNIQUE KEY unique_section_course (section_id, curriculum_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_section_schedules_section ON section_schedules(section_id);
CREATE INDEX IF NOT EXISTS idx_section_schedules_curriculum ON section_schedules(curriculum_id);

SELECT 'Section schedules table created successfully!' as message;
SELECT 'Admins can now create schedules for each section.' as info;

