-- SIMPLE Migration Script: Separate Admin Accounts Table
-- Use this if the main migration script has issues
-- Run this step-by-step in phpMyAdmin

USE enrollment_occ;

-- Step 1: Create admins table
CREATE TABLE IF NOT EXISTS admins (
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

-- Step 2: Create indexes
CREATE INDEX idx_admins_email ON admins(email);
CREATE INDEX idx_admins_admin_id ON admins(admin_id);

-- Step 3: Insert default admin account
-- Password: admin123
INSERT IGNORE INTO admins (admin_id, first_name, last_name, email, password, role, status) 
VALUES (
    'ADMIN001', 
    'System', 
    'Administrator', 
    'admin@occ.edu', 
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 
    'registrar', 
    'active'
);

-- Step 4: If you have existing admin accounts in users table, copy them manually
-- Replace the values below with your actual admin account details
-- Uncomment and modify as needed:

-- INSERT INTO admins (admin_id, first_name, last_name, email, password, phone, role, status)
-- VALUES (
--     'ADMIN002',
--     'Your',
--     'Name',
--     'your.email@domain.com',
--     'your_hashed_password_from_users_table',
--     'your_phone',
--     'registrar',
--     'active'
-- );

-- Step 5: Delete admin accounts from users table
-- First, check what will be deleted:
SELECT 'These admin accounts will be deleted from users table:' as warning;
SELECT id, student_id, first_name, last_name, email FROM users WHERE role = 'admin' OR email LIKE '%@occ.edu';

-- If the above looks correct, uncomment the line below:
-- DELETE FROM users WHERE role = 'admin' OR email LIKE '%@occ.edu';

-- Step 6: Verify the setup
SELECT 'Setup completed!' as message;
SELECT '═══ ADMINS TABLE ═══' as section;
SELECT * FROM admins;
SELECT '═══ USERS TABLE (Students) ═══' as section;
SELECT id, student_id, first_name, last_name, email, status, enrollment_status FROM users;

