-- Enrollment System Database Schema
-- Create database and tables for the enrollment system

CREATE DATABASE IF NOT EXISTS enrollment_occ;
USE enrollment_occ;

-- Admins table for admin/registrar accounts
CREATE TABLE admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id VARCHAR(20) UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(50) DEFAULT 'registrar',
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Users table for student accounts only
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20) UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    address TEXT,
    status ENUM('active', 'inactive', 'pending') DEFAULT 'pending',
    enrollment_status ENUM('enrolled', 'pending') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Departments table
CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10) UNIQUE NOT NULL,
    description TEXT,
    head_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Programs table
CREATE TABLE programs (
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

-- Courses table
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    description TEXT,
    department_id INT,
    credits INT DEFAULT 3,
    max_capacity INT DEFAULT 30,
    instructor_name VARCHAR(100),
    schedule_days VARCHAR(20), -- e.g., 'MWF', 'TTH'
    schedule_time VARCHAR(20), -- e.g., '09:00-10:30'
    semester VARCHAR(20), -- e.g., 'Fall 2024'
    prerequisites TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
);

-- Enrollments table
CREATE TABLE enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('enrolled', 'waitlisted', 'dropped', 'completed') DEFAULT 'enrolled',
    grade VARCHAR(5) DEFAULT NULL,
    grade_points DECIMAL(3,2) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (user_id, course_id)
);

-- Enrollment history for tracking changes
CREATE TABLE enrollment_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    action ENUM('enrolled', 'dropped', 'grade_updated') NOT NULL,
    previous_status VARCHAR(20),
    new_status VARCHAR(20),
    notes TEXT,
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(id) ON DELETE CASCADE
);

-- Document checklists for students
CREATE TABLE document_checklists (
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

-- Enrolled students table
CREATE TABLE enrolled_students (
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

-- Curriculum table - Links courses to programs by year and semester
CREATE TABLE curriculum (
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

-- Sections table - Class sections for each program/year/semester
CREATE TABLE sections (
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

-- Section enrollments - Track which students are in which sections
CREATE TABLE section_enrollments (
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

-- Section schedules - Course schedules for each section
CREATE TABLE section_schedules (
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

-- Insert sample departments
INSERT INTO departments (name, code, description, head_name) VALUES
('Computer Science', 'CS', 'Computer Science and Information Technology', 'Dr. John Smith'),
('Mathematics', 'MATH', 'Mathematics and Statistics', 'Dr. Sarah Johnson'),
('Business Administration', 'BA', 'Business and Management Studies', 'Dr. Michael Brown'),
('Engineering', 'ENG', 'Engineering and Technical Studies', 'Dr. Lisa Wilson');

-- Insert academic programs
INSERT INTO programs (program_code, program_name, description, total_units, years_to_complete, status) VALUES
('BSE', 'Bachelor of Science in Entrepreneurship', 'Undergraduate program focusing on entrepreneurship and business development', 141, 4, 'active'),
('BTVTED', 'Bachelor in Technical Vocational Teacher Education', 'Teacher education program for technical and vocational subjects', 176, 4, 'active'),
('BSIS', 'Bachelor of Science in Information Systems', 'Information systems and technology program', 152, 4, 'active');

-- Insert sample courses
INSERT INTO courses (course_code, course_name, description, department_id, credits, max_capacity, instructor_name, schedule_days, schedule_time, semester, prerequisites) VALUES
('CS101', 'Introduction to Programming', 'Basic programming concepts using Python', 1, 3, 25, 'Prof. Alice Cooper', 'MWF', '09:00-10:00', 'Fall 2024', 'None'),
('CS102', 'Data Structures', 'Introduction to data structures and algorithms', 1, 3, 25, 'Prof. Bob Davis', 'TTH', '10:30-12:00', 'Fall 2024', 'CS101'),
('MATH101', 'Calculus I', 'Differential and integral calculus', 2, 4, 30, 'Prof. Carol White', 'MTWF', '08:00-09:00', 'Fall 2024', 'High School Algebra'),
('BA101', 'Business Fundamentals', 'Introduction to business principles', 3, 3, 35, 'Prof. David Green', 'MW', '14:00-15:30', 'Fall 2024', 'None'),
('ENG101', 'Engineering Design', 'Basic engineering design principles', 4, 3, 20, 'Prof. Emma Taylor', 'TTH', '13:00-14:30', 'Fall 2024', 'MATH101');

-- Insert default admin user (password: admin123 - hashed)
INSERT INTO admins (admin_id, first_name, last_name, email, password, role, status) VALUES
('ADMIN001', 'System', 'Administrator', 'admin@occ.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'registrar', 'active');

-- Create indexes for better performance
CREATE INDEX idx_admins_email ON admins(email);
CREATE INDEX idx_admins_admin_id ON admins(admin_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_student_id ON users(student_id);
CREATE INDEX idx_courses_code ON courses(course_code);
CREATE INDEX idx_enrollments_user_course ON enrollments(user_id, course_id);
CREATE INDEX idx_enrollments_status ON enrollments(status);
