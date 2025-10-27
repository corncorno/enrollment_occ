-- Fix User Status Script
-- This script checks and fixes user statuses to allow login

USE enrollment_occ;

-- Check current user statuses
SELECT 'Current user statuses:' as info;
SELECT id, student_id, CONCAT(first_name, ' ', last_name) as name, email, status, enrollment_status, created_at 
FROM users 
ORDER BY created_at DESC 
LIMIT 10;

-- Update all pending users to active status (if you want to allow immediate login after registration)
SELECT '\nUpdating pending users to active:' as info;
UPDATE users SET status = 'active' WHERE status = 'pending';

-- Check updated statuses
SELECT '\nUpdated user statuses:' as info;
SELECT id, student_id, CONCAT(first_name, ' ', last_name) as name, email, status, enrollment_status 
FROM users 
ORDER BY created_at DESC 
LIMIT 10;

SELECT '\nAll users should now be able to log in!' as message;

