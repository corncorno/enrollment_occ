-- Migration Script: Separate Admin Accounts Table
-- This script creates a separate admins table and moves existing admin users

USE enrollment_occ;

-- Step 1: Create admins table if it doesn't exist
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

-- Step 2: Create indexes for admins table
CREATE INDEX IF NOT EXISTS idx_admins_email ON admins(email);
CREATE INDEX IF NOT EXISTS idx_admins_admin_id ON admins(admin_id);

-- Step 3: Migrate existing admin users from users table to admins table
-- This works if your users table has a 'role' column with admin users
INSERT INTO admins (admin_id, first_name, last_name, email, password, phone, role, status, created_at)
SELECT 
    CASE 
        WHEN student_id IS NOT NULL AND student_id != '' THEN student_id 
        ELSE CONCAT('ADMIN', LPAD(id, 3, '0'))
    END as admin_id,
    first_name,
    last_name,
    email,
    password,
    phone,
    'registrar' as role,
    CASE 
        WHEN status = 'active' THEN 'active'
        ELSE 'inactive'
    END as status,
    created_at
FROM users 
WHERE (role = 'admin' OR email = 'admin@occ.edu')
ON DUPLICATE KEY UPDATE 
    first_name = VALUES(first_name),
    last_name = VALUES(last_name),
    phone = VALUES(phone);

-- Step 4: Ensure default admin account exists
INSERT IGNORE INTO admins (admin_id, first_name, last_name, email, password, role, status) 
VALUES ('ADMIN001', 'System', 'Administrator', 'admin@occ.edu', 
        '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 
        'registrar', 'active');

-- Step 5: Delete admin accounts from users table
DELETE FROM users WHERE (role = 'admin' OR email LIKE '%@occ.edu');

-- Step 6: Optional - Remove role column from users table (all users are now students)
-- WARNING: This will permanently remove the role field. Uncomment to execute:
-- ALTER TABLE users DROP COLUMN IF EXISTS role;

-- Step 7: Verify the migration
SELECT 'Migration completed successfully!' as message;
SELECT '══════════════════════════════════════' as separator;
SELECT 'ADMINS TABLE:' as info;
SELECT id, admin_id, first_name, last_name, email, role, status FROM admins;
SELECT '══════════════════════════════════════' as separator;
SELECT 'USERS TABLE (Students only):' as info;
SELECT id, student_id, first_name, last_name, email, status, enrollment_status FROM users LIMIT 10;

