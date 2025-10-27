-- Migration Script: Add Chatbot for Student Inquiries
-- This script creates tables for the chatbot FAQ system

USE enrollment_occ;

-- Create FAQ/Knowledge Base table for chatbot
CREATE TABLE IF NOT EXISTS chatbot_faqs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question VARCHAR(500) NOT NULL,
    answer TEXT NOT NULL,
    keywords TEXT,
    category VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    view_count INT DEFAULT 0,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES admins(id) ON DELETE SET NULL,
    INDEX idx_category (category),
    INDEX idx_active (is_active)
);

-- Create chat history table to track student inquiries
CREATE TABLE IF NOT EXISTS chatbot_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    question TEXT NOT NULL,
    answer TEXT,
    faq_id INT,
    was_helpful BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (faq_id) REFERENCES chatbot_faqs(id) ON DELETE SET NULL,
    INDEX idx_user (user_id),
    INDEX idx_created (created_at)
);

-- Insert sample FAQs
INSERT INTO chatbot_faqs (question, answer, keywords, category, created_by) VALUES
('How do I enroll?', 'To enroll, you need to: 1) Register an account, 2) Wait for admin approval, 3) Submit required documents, 4) Admin will assign you to sections. Once assigned, you can view your schedule in the "My Schedule" tab.', 'enroll,enrollment,register,how to enroll', 'Enrollment', NULL),
('What documents do I need?', 'Required documents include: Birth Certificate, Report Card (Form 138), Good Moral Certificate, ID Photo (2x2), Certificate of Enrollment, Medical Certificate, and Transcript of Records. You can check your document status in the Document Checklist section.', 'documents,requirements,needed,checklist', 'Requirements', NULL),
('How can I view my schedule?', 'Click on "My Schedule" in the left menu to view your class schedule. You can see a detailed table and weekly calendar view showing all your classes, times, rooms, and professors.', 'schedule,class schedule,view schedule,timetable', 'Schedule', NULL),
('What are my sections?', 'You can view all your assigned sections by clicking "My Sections" in the menu. Each section shows the program, year level, semester, and academic year.', 'sections,my sections,class sections', 'Sections', NULL),
('How do I check my enrollment status?', 'Click on "Enrollment Status" in the menu to see your complete enrollment information including your program, year level, semester, and current status.', 'enrollment status,status,check status', 'Enrollment', NULL),
('Who do I contact for help?', 'For enrollment concerns, contact the registrar''s office at registrar@occ.edu. For technical support, email support@occ.edu.', 'contact,help,support,email', 'General', NULL),
('What is my student ID?', 'Your Student ID is displayed at the top of the sidebar under your name. It was provided when you registered.', 'student id,id number', 'Account', NULL),
('How do I change my password?', 'Currently, password changes must be requested through the admin. Please contact the registrar''s office with your request.', 'password,change password,reset password', 'Account', NULL);

SELECT 'Chatbot tables created successfully!' as message;
SELECT COUNT(*) as total_faqs FROM chatbot_faqs;

