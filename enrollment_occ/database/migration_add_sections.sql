-- Migration Script: Add Sections Management
-- This script creates sections tables and adds default sections

USE enrollment_occ;

-- Step 1: Create sections table
CREATE TABLE IF NOT EXISTS sections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    program_id INT NOT NULL,
    year_level ENUM('1st Year', '2nd Year', '3rd Year', '4th Year', '5th Year') NOT NULL,
    semester ENUM('First Semester', 'Second Semester', 'Summer') NOT NULL,
    section_name VARCHAR(50) NOT NULL,
    section_type ENUM('Morning', 'Afternoon', 'Evening') NOT NULL,
    max_capacity INT DEFAULT 50,
    current_enrolled INT DEFAULT 0,
    academic_year VARCHAR(20),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE,
    UNIQUE KEY unique_section (program_id, year_level, semester, section_type, academic_year)
);

-- Step 2: Create section enrollments table
CREATE TABLE IF NOT EXISTS section_enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    section_id INT NOT NULL,
    user_id INT NOT NULL,
    enrolled_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active', 'dropped') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_student_section (user_id, section_id)
);

-- Step 3: Create indexes
CREATE INDEX IF NOT EXISTS idx_sections_program ON sections(program_id);
CREATE INDEX IF NOT EXISTS idx_sections_year_sem ON sections(year_level, semester);
CREATE INDEX IF NOT EXISTS idx_section_enrollments_section ON section_enrollments(section_id);
CREATE INDEX IF NOT EXISTS idx_section_enrollments_user ON section_enrollments(user_id);

-- Step 4: Insert default sections for BSE program (program_id = 1)
-- First Year
INSERT IGNORE INTO sections (program_id, year_level, semester, section_name, section_type, max_capacity, academic_year, status) VALUES
(1, '1st Year', 'First Semester', 'BSE 1A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(1, '1st Year', 'First Semester', 'BSE 1B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(1, '1st Year', 'First Semester', 'BSE 1C - Evening', 'Evening', 50, 'AY 2024-2025', 'active'),
(1, '1st Year', 'Second Semester', 'BSE 1A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(1, '1st Year', 'Second Semester', 'BSE 1B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(1, '1st Year', 'Second Semester', 'BSE 1C - Evening', 'Evening', 50, 'AY 2024-2025', 'active');

-- Second Year
INSERT IGNORE INTO sections (program_id, year_level, semester, section_name, section_type, max_capacity, academic_year, status) VALUES
(1, '2nd Year', 'First Semester', 'BSE 2A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(1, '2nd Year', 'First Semester', 'BSE 2B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(1, '2nd Year', 'First Semester', 'BSE 2C - Evening', 'Evening', 50, 'AY 2024-2025', 'active'),
(1, '2nd Year', 'Second Semester', 'BSE 2A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(1, '2nd Year', 'Second Semester', 'BSE 2B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(1, '2nd Year', 'Second Semester', 'BSE 2C - Evening', 'Evening', 50, 'AY 2024-2025', 'active');

-- Third Year
INSERT IGNORE INTO sections (program_id, year_level, semester, section_name, section_type, max_capacity, academic_year, status) VALUES
(1, '3rd Year', 'First Semester', 'BSE 3A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(1, '3rd Year', 'First Semester', 'BSE 3B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(1, '3rd Year', 'First Semester', 'BSE 3C - Evening', 'Evening', 50, 'AY 2024-2025', 'active'),
(1, '3rd Year', 'Second Semester', 'BSE 3A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(1, '3rd Year', 'Second Semester', 'BSE 3B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(1, '3rd Year', 'Second Semester', 'BSE 3C - Evening', 'Evening', 50, 'AY 2024-2025', 'active');

-- Fourth Year
INSERT IGNORE INTO sections (program_id, year_level, semester, section_name, section_type, max_capacity, academic_year, status) VALUES
(1, '4th Year', 'First Semester', 'BSE 4A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(1, '4th Year', 'First Semester', 'BSE 4B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(1, '4th Year', 'First Semester', 'BSE 4C - Evening', 'Evening', 50, 'AY 2024-2025', 'active'),
(1, '4th Year', 'Second Semester', 'BSE 4A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(1, '4th Year', 'Second Semester', 'BSE 4B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(1, '4th Year', 'Second Semester', 'BSE 4C - Evening', 'Evening', 50, 'AY 2024-2025', 'active');

-- Step 5: Insert default sections for BTVTED program (program_id = 2)
-- First Year
INSERT IGNORE INTO sections (program_id, year_level, semester, section_name, section_type, max_capacity, academic_year, status) VALUES
(2, '1st Year', 'First Semester', 'BTVTED 1A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(2, '1st Year', 'First Semester', 'BTVTED 1B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(2, '1st Year', 'First Semester', 'BTVTED 1C - Evening', 'Evening', 50, 'AY 2024-2025', 'active'),
(2, '1st Year', 'Second Semester', 'BTVTED 1A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(2, '1st Year', 'Second Semester', 'BTVTED 1B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(2, '1st Year', 'Second Semester', 'BTVTED 1C - Evening', 'Evening', 50, 'AY 2024-2025', 'active');

-- Second Year
INSERT IGNORE INTO sections (program_id, year_level, semester, section_name, section_type, max_capacity, academic_year, status) VALUES
(2, '2nd Year', 'First Semester', 'BTVTED 2A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(2, '2nd Year', 'First Semester', 'BTVTED 2B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(2, '2nd Year', 'First Semester', 'BTVTED 2C - Evening', 'Evening', 50, 'AY 2024-2025', 'active'),
(2, '2nd Year', 'Second Semester', 'BTVTED 2A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(2, '2nd Year', 'Second Semester', 'BTVTED 2B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(2, '2nd Year', 'Second Semester', 'BTVTED 2C - Evening', 'Evening', 50, 'AY 2024-2025', 'active');

-- Third Year
INSERT IGNORE INTO sections (program_id, year_level, semester, section_name, section_type, max_capacity, academic_year, status) VALUES
(2, '3rd Year', 'First Semester', 'BTVTED 3A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(2, '3rd Year', 'First Semester', 'BTVTED 3B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(2, '3rd Year', 'First Semester', 'BTVTED 3C - Evening', 'Evening', 50, 'AY 2024-2025', 'active'),
(2, '3rd Year', 'Second Semester', 'BTVTED 3A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(2, '3rd Year', 'Second Semester', 'BTVTED 3B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(2, '3rd Year', 'Second Semester', 'BTVTED 3C - Evening', 'Evening', 50, 'AY 2024-2025', 'active');

-- Fourth Year
INSERT IGNORE INTO sections (program_id, year_level, semester, section_name, section_type, max_capacity, academic_year, status) VALUES
(2, '4th Year', 'First Semester', 'BTVTED 4A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(2, '4th Year', 'First Semester', 'BTVTED 4B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(2, '4th Year', 'First Semester', 'BTVTED 4C - Evening', 'Evening', 50, 'AY 2024-2025', 'active'),
(2, '4th Year', 'Second Semester', 'BTVTED 4A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(2, '4th Year', 'Second Semester', 'BTVTED 4B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(2, '4th Year', 'Second Semester', 'BTVTED 4C - Evening', 'Evening', 50, 'AY 2024-2025', 'active');

-- Step 6: Insert default sections for BSIS program (program_id = 3)
-- First Year
INSERT IGNORE INTO sections (program_id, year_level, semester, section_name, section_type, max_capacity, academic_year, status) VALUES
(3, '1st Year', 'First Semester', 'BSIS 1A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(3, '1st Year', 'First Semester', 'BSIS 1B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(3, '1st Year', 'First Semester', 'BSIS 1C - Evening', 'Evening', 50, 'AY 2024-2025', 'active'),
(3, '1st Year', 'Second Semester', 'BSIS 1A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(3, '1st Year', 'Second Semester', 'BSIS 1B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(3, '1st Year', 'Second Semester', 'BSIS 1C - Evening', 'Evening', 50, 'AY 2024-2025', 'active');

-- Second Year
INSERT IGNORE INTO sections (program_id, year_level, semester, section_name, section_type, max_capacity, academic_year, status) VALUES
(3, '2nd Year', 'First Semester', 'BSIS 2A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(3, '2nd Year', 'First Semester', 'BSIS 2B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(3, '2nd Year', 'First Semester', 'BSIS 2C - Evening', 'Evening', 50, 'AY 2024-2025', 'active'),
(3, '2nd Year', 'Second Semester', 'BSIS 2A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(3, '2nd Year', 'Second Semester', 'BSIS 2B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(3, '2nd Year', 'Second Semester', 'BSIS 2C - Evening', 'Evening', 50, 'AY 2024-2025', 'active');

-- Third Year
INSERT IGNORE INTO sections (program_id, year_level, semester, section_name, section_type, max_capacity, academic_year, status) VALUES
(3, '3rd Year', 'First Semester', 'BSIS 3A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(3, '3rd Year', 'First Semester', 'BSIS 3B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(3, '3rd Year', 'First Semester', 'BSIS 3C - Evening', 'Evening', 50, 'AY 2024-2025', 'active'),
(3, '3rd Year', 'Second Semester', 'BSIS 3A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(3, '3rd Year', 'Second Semester', 'BSIS 3B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(3, '3rd Year', 'Second Semester', 'BSIS 3C - Evening', 'Evening', 50, 'AY 2024-2025', 'active');

-- Fourth Year
INSERT IGNORE INTO sections (program_id, year_level, semester, section_name, section_type, max_capacity, academic_year, status) VALUES
(3, '4th Year', 'First Semester', 'BSIS 4A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(3, '4th Year', 'First Semester', 'BSIS 4B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(3, '4th Year', 'First Semester', 'BSIS 4C - Evening', 'Evening', 50, 'AY 2024-2025', 'active'),
(3, '4th Year', 'Second Semester', 'BSIS 4A - Morning', 'Morning', 50, 'AY 2024-2025', 'active'),
(3, '4th Year', 'Second Semester', 'BSIS 4B - Afternoon', 'Afternoon', 50, 'AY 2024-2025', 'active'),
(3, '4th Year', 'Second Semester', 'BSIS 4C - Evening', 'Evening', 50, 'AY 2024-2025', 'active');

-- Step 7: Verify sections created
SELECT 'Sections created successfully!' as message;
SELECT 'Total sections per program:' as info;
SELECT 
    p.program_code, 
    COUNT(s.id) as total_sections,
    SUM(s.max_capacity) as total_capacity
FROM programs p
LEFT JOIN sections s ON p.id = s.program_id
GROUP BY p.id, p.program_code;


