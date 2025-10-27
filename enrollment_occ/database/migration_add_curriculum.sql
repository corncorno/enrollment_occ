-- Migration Script: Add Curriculum Management Tables
-- Run this if you already have an existing enrollment_occ database

USE enrollment_occ;

-- Step 1: Create programs table
CREATE TABLE IF NOT EXISTS programs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    program_code VARCHAR(20) UNIQUE NOT NULL,
    program_name VARCHAR(200) NOT NULL,
    description TEXT,
    total_units INT DEFAULT 0,
    years_to_complete INT DEFAULT 4,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Step 2: Create curriculum table
CREATE TABLE IF NOT EXISTS curriculum (
    id INT AUTO_INCREMENT PRIMARY KEY,
    program_id INT NOT NULL,
    course_code VARCHAR(20) NOT NULL,
    course_name VARCHAR(200) NOT NULL,
    units INT DEFAULT 3,
    year_level ENUM('1st Year', '2nd Year', '3rd Year', '4th Year', '5th Year') NOT NULL,
    semester ENUM('First Semester', 'Second Semester', 'Summer') NOT NULL,
    is_required BOOLEAN DEFAULT TRUE,
    pre_requisites TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE,
    UNIQUE KEY unique_course_program (program_id, course_code, year_level, semester)
);

-- Step 3: Create indexes
CREATE INDEX IF NOT EXISTS idx_curriculum_program ON curriculum(program_id);
CREATE INDEX IF NOT EXISTS idx_curriculum_year_sem ON curriculum(year_level, semester);
CREATE INDEX IF NOT EXISTS idx_programs_code ON programs(program_code);

-- Step 4: Insert programs
INSERT INTO programs (program_code, program_name, description, total_units, years_to_complete, status) VALUES
('BSE', 'Bachelor of Science in Entrepreneurship', 'Undergraduate program focusing on entrepreneurship and business development', 141, 4, 'active'),
('BTVTED', 'Bachelor in Technical Vocational Teacher Education', 'Teacher education program for technical and vocational subjects', 176, 4, 'active'),
('BSIS', 'Bachelor of Science in Information Systems', 'Information systems and technology program', 152, 4, 'active')
ON DUPLICATE KEY UPDATE 
    program_name = VALUES(program_name),
    description = VALUES(description),
    total_units = VALUES(total_units);

SELECT 'Migration completed! Programs table created.' as message;
SELECT 'Next step: Import curriculum_data.sql to load all curriculum courses' as next_step;
SELECT * FROM programs;

