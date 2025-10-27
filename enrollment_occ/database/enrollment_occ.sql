-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 27, 2025 at 07:44 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `enrollment_occ`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `admin_id` varchar(20) DEFAULT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `role` varchar(50) DEFAULT 'registrar',
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `admin_id`, `first_name`, `last_name`, `email`, `password`, `phone`, `role`, `status`, `created_at`, `updated_at`) VALUES
(1, 'ADMIN001', 'System', 'Administrator', 'admin@occ.edu', '$2y$10$7nnzfuxaNSooAI9iyp2Z.OqG0UWgYbzIeG7CKP3IT3P87CY7m.gwe', NULL, 'registrar', 'active', '2025-09-29 16:50:59', '2025-10-07 11:12:24');

-- --------------------------------------------------------

--
-- Table structure for table `chatbot_faqs`
--

CREATE TABLE `chatbot_faqs` (
  `id` int(11) NOT NULL,
  `question` varchar(500) NOT NULL,
  `answer` text NOT NULL,
  `keywords` text DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `view_count` int(11) DEFAULT 0,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `chatbot_faqs`
--

INSERT INTO `chatbot_faqs` (`id`, `question`, `answer`, `keywords`, `category`, `is_active`, `view_count`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'How do I enroll?', 'To enroll, you need to: 1) Register an account, 2) Wait for admin approval, 3) Submit required documents, 4) Admin will assign you to sections. Once assigned, you can view your schedule in the \"My Schedule\" tab.', 'enroll,enrollment,register,how to enroll', 'Enrollment', 1, 3, NULL, '2025-10-27 12:34:47', '2025-10-27 12:35:45'),
(2, 'What documents do I need?', 'Required documents include: Birth Certificate, Report Card (Form 138), Good Moral Certificate, ID Photo (2x2), Certificate of Enrollment, Medical Certificate, and Transcript of Records. You can check your document status in the Document Checklist section.', 'documents,requirements,needed,checklist', 'Requirements', 1, 1, NULL, '2025-10-27 12:34:47', '2025-10-27 12:35:50'),
(3, 'How can I view my schedule?', 'Click on \"My Schedule\" in the left menu to view your class schedule. You can see a detailed table and weekly calendar view showing all your classes, times, rooms, and professors.', 'schedule,class schedule,view schedule,timetable', 'Schedule', 1, 1, NULL, '2025-10-27 12:34:47', '2025-10-27 18:43:25'),
(4, 'What are my sections?', 'You can view all your assigned sections by clicking \"My Sections\" in the menu. Each section shows the program, year level, semester, and academic year.', 'sections,my sections,class sections', 'Sections', 1, 0, NULL, '2025-10-27 12:34:47', '2025-10-27 12:34:47'),
(5, 'How do I check my enrollment status?', 'Click on \"Enrollment Status\" in the menu to see your complete enrollment information including your program, year level, semester, and current status.', 'enrollment status,status,check status', 'Enrollment', 1, 0, NULL, '2025-10-27 12:34:47', '2025-10-27 12:34:47'),
(6, 'Who do I contact for help?', 'For enrollment concerns, contact the registrar\'s office at registrar@occ.edu. For technical support, email support@occ.edu.', 'contact,help,support,email', 'General', 1, 2, NULL, '2025-10-27 12:34:47', '2025-10-27 12:35:48'),
(7, 'What is my student ID?', 'Your Student ID is displayed at the top of the sidebar under your name. It was provided when you registered.', 'student id,id number', 'Account', 1, 1, NULL, '2025-10-27 12:34:47', '2025-10-27 12:34:57'),
(8, 'How do I change my password?', 'Currently, password changes must be requested through the admin. Please contact the registrar\'s office with your request.', 'password,change password,reset password', 'Account', 1, 1, NULL, '2025-10-27 12:34:47', '2025-10-27 12:35:00');

-- --------------------------------------------------------

--
-- Table structure for table `chatbot_history`
--

CREATE TABLE `chatbot_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `question` text NOT NULL,
  `answer` text DEFAULT NULL,
  `faq_id` int(11) DEFAULT NULL,
  `was_helpful` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `chatbot_history`
--

INSERT INTO `chatbot_history` (`id`, `user_id`, `question`, `answer`, `faq_id`, `was_helpful`, `created_at`) VALUES
(1, 3, 'What is my student ID?', 'Your Student ID is displayed at the top of the sidebar under your name. It was provided when you registered.', 7, NULL, '2025-10-27 12:34:57'),
(2, 3, 'How do I change my password?', 'Currently, password changes must be requested through the admin. Please contact the registrar\'s office with your request.', 8, NULL, '2025-10-27 12:35:00'),
(3, 3, 'How do I enroll?', 'To enroll, you need to: 1) Register an account, 2) Wait for admin approval, 3) Submit required documents, 4) Admin will assign you to sections. Once assigned, you can view your schedule in the \"My Schedule\" tab.', 1, NULL, '2025-10-27 12:35:05'),
(4, 3, 'Who do I contact for help?', 'For enrollment concerns, contact the registrar\'s office at registrar@occ.edu. For technical support, email support@occ.edu.', 6, NULL, '2025-10-27 12:35:15'),
(5, 3, 'how do i enroll', 'To enroll, you need to: 1) Register an account, 2) Wait for admin approval, 3) Submit required documents, 4) Admin will assign you to sections. Once assigned, you can view your schedule in the \"My Schedule\" tab.', 1, NULL, '2025-10-27 12:35:42'),
(6, 3, 'enroll', 'To enroll, you need to: 1) Register an account, 2) Wait for admin approval, 3) Submit required documents, 4) Admin will assign you to sections. Once assigned, you can view your schedule in the \"My Schedule\" tab.', 1, NULL, '2025-10-27 12:35:45'),
(7, 3, 'Who do I contact for help?', 'For enrollment concerns, contact the registrar\'s office at registrar@occ.edu. For technical support, email support@occ.edu.', 6, NULL, '2025-10-27 12:35:48'),
(8, 3, 'What documents do I need?', 'Required documents include: Birth Certificate, Report Card (Form 138), Good Moral Certificate, ID Photo (2x2), Certificate of Enrollment, Medical Certificate, and Transcript of Records. You can check your document status in the Document Checklist section.', 2, NULL, '2025-10-27 12:35:50'),
(9, 8, 'How can I view my schedule?', 'Click on \"My Schedule\" in the left menu to view your class schedule. You can see a detailed table and weekly calendar view showing all your classes, times, rooms, and professors.', 3, NULL, '2025-10-27 18:43:25');

-- --------------------------------------------------------

--
-- Table structure for table `curriculum`
--

CREATE TABLE `curriculum` (
  `id` int(11) NOT NULL,
  `program_id` int(11) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `course_name` varchar(200) NOT NULL,
  `units` int(11) DEFAULT 3,
  `year_level` enum('1st Year','2nd Year','3rd Year','4th Year','5th Year') NOT NULL,
  `semester` enum('First Semester','Second Semester','Summer') NOT NULL,
  `is_required` tinyint(1) DEFAULT 1,
  `pre_requisites` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `curriculum`
--

INSERT INTO `curriculum` (`id`, `program_id`, `course_code`, `course_name`, `units`, `year_level`, `semester`, `is_required`, `pre_requisites`, `created_at`, `updated_at`) VALUES
(1, 1, 'BSE-C101', 'Entrepreneurship Behavior', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(2, 1, 'GE-100', 'Understanding the Self', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(3, 1, 'GE-101', 'Reading in Philippine History', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(4, 1, 'GE-107', 'The Contemporary World', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(5, 1, 'NSTP1', 'National Service Training Program 1', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(6, 1, 'PE1', 'Physical Fitness/Self-Testing Activities', 2, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(7, 1, 'BSE-C102', 'Microeconomics', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(8, 1, 'GE-104', 'Mathematics in the Modern World', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(9, 1, 'GE-103', 'Purposive Communication', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(10, 1, 'GE-102', 'Art Appreciation', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(11, 1, 'NSTP2', 'National Service Training Program 2', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(12, 1, 'PE2', 'Rhythmic Activities', 2, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(13, 1, 'BSE-C103', 'Opportunity Seeking', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(14, 1, 'GE-105', 'Science, Technology and Society', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(15, 1, 'GE-111', 'Ethics', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(16, 1, 'GE-106', 'Rizal\'s Life and Works', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(17, 1, 'BSE-C100', 'Entrepreneurial Leadership in an Organization', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(18, 1, 'PE3', 'Individual/Dual Combative Sports', 2, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(19, 1, 'BSE-C104', 'Market Research and Consumer Behavior', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(20, 1, 'BSE-C105', 'Innovation Management', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(21, 1, 'BSE-C106', 'Pricing and Costing', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(22, 1, 'BSE-C107', 'Human Resources Management', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(23, 1, 'BSE-GC101', 'Mathematics, Science and Technology', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(24, 1, 'BSE-GC102', 'Social Science and Philosophy', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(25, 1, 'BSE-OCC100', 'Living in the IT Era', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(26, 1, 'PE4', 'Team Sports', 2, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(27, 1, 'BSE-C108', 'Financial Management', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(28, 1, 'BSE-M101', 'Production and Operation Management', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(29, 1, 'BSE-GC103', 'Arts and Humanities', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(30, 1, 'BSE-ST101', 'Business Project Proposal 1 - Track 1: Small Business Consulting/Business Development Servicing 101', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(31, 1, 'BSE-E101', 'Elective 1: Franchising', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(32, 1, 'BSE-E102', 'Elective 2: Entrepreneurship Marketing Strategies', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(33, 1, 'BSE-C109', 'Program and Policies on Enterprise Development', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(34, 1, 'BSE-OCC101', 'Accounting 1 - Financial Accounting', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(35, 1, 'BSE-C110', 'Business Plan Preparation', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(36, 1, 'BSE-ST102', 'Track 2: Integrated Services of Consulting Services/Business Development', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(37, 1, 'BSE-E103', 'Elective 3: E-Commerce', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(38, 1, 'BSE-E104', 'Elective 4: Small Business Consulting/Business Development', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(39, 1, 'BSE-C111', 'International Business and Trade', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(40, 1, 'BSE-C112', 'Business Law and Tax', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(41, 1, 'BSE-M102', 'Strategic Management', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(42, 1, 'BSE-OCC102', 'Accounting II - Management Accounting', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(43, 1, 'BSE-C113', 'Business Plan Implementation 1', 5, '4th Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(44, 1, 'BSE-C114', 'Social Entrepreneurship', 3, '4th Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(45, 1, 'BSE-ST103', 'Track 3: Business Development: Small and Medium Enterprise Development/SMED', 3, '4th Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(46, 1, 'BSE-C115', 'Business Plan Implementation 2', 5, '4th Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(47, 1, 'BSE-ST104', 'Track 4: Business Development: Micro Enterprise Development/MED', 3, '4th Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(48, 2, 'GE-100', 'Understanding the Self', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(49, 2, 'GE-101', 'Reading in Philippine History', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(50, 2, 'GE-102', 'Art Appreciation', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(51, 2, 'GE-103', 'Purposive Communication', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(52, 2, 'GE-104', 'Mathematics in the Modern World', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(53, 2, 'GE-105', 'Science, Technology and Society', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(54, 2, 'GE-106', 'Rizal\'s Life and Works', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(55, 2, 'PE1', 'Physical Fitness/Self-Testing Activities', 2, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(56, 2, 'NSTP1', 'National Service Training Program 1', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(57, 2, 'GE-107', 'The Contemporary World', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(58, 2, 'GE-108', 'Panitikan', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(59, 2, 'GE-109', 'Philippine Popular Culture', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(60, 2, 'GE-110', 'Sining ng Pakipagtalastasan', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(61, 2, 'GE-111', 'Ethics', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(62, 2, 'EDUC-100', 'The Teaching Profession', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(63, 2, 'EDUC-101', 'The Child and Adolescent Learner and Learning Principles', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(64, 2, 'PE2', 'Rhythmic Activities', 2, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(65, 2, 'NSTP2', 'National Service Training Program 2', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(66, 2, 'EDUC-102', 'Facilitating Learner-Centered Teaching: The Learner-Centered Approach with Emphasis on Trainers Methodology 1', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(67, 2, 'EDUC-103', 'Technology for Teaching and Learning 1', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(68, 2, 'EDUC-104', 'Building and Enhancing Literacy Across the Curriculum with Emphasis on the 21st Century Skills', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(69, 2, 'EDUC-105', 'Andragogy of Learning including Principles of Trainers Methodology', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(70, 2, 'EDUC-106', 'Assessment in Learning 1', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(71, 2, 'BTVD-T101', 'Introduction to Agri-Fishery and Arts', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(72, 2, 'BTVD100', 'Computer System Servicing 1 - Computer Hardware Installation and Maintenance', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(73, 2, 'BTVD-T102', 'Entrepreneurship Behavior and Competencies', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(74, 2, 'PE3', 'Individual/Dual Combative Sports', 2, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(75, 2, 'TLE 100', 'Introduction to Industrial Arts', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(76, 2, 'EDUC-106', 'The Teacher in Community, School Culture and Organizational Leadership with focus on the Philippine TVET System', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(77, 2, 'EDUC-108', 'Technology for Teaching and Learning 2', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(78, 2, 'EDUC-109', 'Curriculum Development and Evaluation with Emphasis on Trainers Methodology II', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(79, 2, 'EDUC-110', 'Foundation of Special and Inclusive Education (Mandated)', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(80, 2, 'EDUC-111', 'Assessment in Learning 2 with focus on Trainers Methodology 1 & 2', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(81, 2, 'BTVD-T103', 'Teaching ICT as an Exploratory Course', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(82, 2, 'BTVE-101', 'Computer System Servicing 2 - Computer System Installation and Configuration', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(83, 2, 'PE4', 'Team Sports', 2, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(84, 2, 'TLE 104', 'Home Economics Literacy', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(85, 2, 'EDUC 112', 'Technology Research 1: Methods of Research', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(86, 2, 'TLE 1-5', 'Teaching Common Competencies in ICT', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(87, 2, 'TLE 106', 'Teaching in Common Competencies in IA', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(88, 2, 'BTVE 102', 'Visual Graphics Design 1 - Web Site Development and Digital Media Design - Print Media', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(89, 2, 'BTVE 103', 'Visual Graphics Design 2 - Web Site Development and Digital Media Design - Video Production', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(90, 2, 'BTVE 104', 'Visual Graphics Design 3 - Web Site Development and Digital Media Design - Audio Production', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(91, 2, 'BTVE-107', 'Computer Systems Servicing 3 - Computer System Servicing - Network Installation and Maintenance', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(92, 2, 'BTVE 109', 'Visual Graphics Design 4 - Web Site Development and Digital Media Design - Authoring Tools', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(93, 2, 'BTVE-106', 'Programming 1 - Program Logic Formulation', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(94, 2, 'BTVD-E113', 'Technology Research 2 - Undergraduate Thesis Writing/Research paper', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(95, 2, 'TLE 108', 'Teaching Common Competencies in HE', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(96, 2, 'BTVE 108', 'Visual Graphics Design 5 - Website Development and Digital Media Design - Web Site Creation (HTML5)', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(97, 2, 'BTVE 109', 'Visual Graphics Design 6 - Website Development and Digital Media Design - Internet Marketing', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(98, 2, 'BTVE 110', 'Visual Graphics Design 7 - Website Development and Digital Media Design - Web Site Creation (JavaScript & CSS3)', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(99, 2, 'BTVE 111', 'Programming 2 - Developing Web Applications (ASP.net)', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(100, 2, 'BTVE 112', 'Programming 3 - Object Oriented Programming (C++)', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(101, 2, 'EDUC 114', 'Work-Based Learning with Emphasis on Trainers Methodology', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(102, 2, 'TLE 107', 'Teaching Common Competencies in AFA', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(103, 2, 'EDUC 115', 'Field Study 1', 3, '4th Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(104, 2, 'EDUC 116', 'Field Study 2', 3, '4th Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(105, 2, 'TLE 109', 'Supervised Industry Training', 3, '4th Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(106, 2, 'EDUC 117', 'Practicum 2 - Practice Training', 6, '4th Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(107, 3, 'GE-100', 'Understanding the Self', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(108, 3, 'GE-101', 'Reading in Philippine History', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(109, 3, 'GE-107', 'The Contemporary World', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(110, 3, 'CC101', 'Introduction to Computing', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(111, 3, 'CC102', 'Computer Programming 1', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(112, 3, 'NSTP1', 'National Service Training Program 1', 3, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(113, 3, 'PE1', 'Physical Fitness/Self-Testing Activities', 2, '1st Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(114, 3, 'GE-102', 'Art Appreciation', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(115, 3, 'GE-103', 'Purposive Communication', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(116, 3, 'GE-104', 'Mathematics in the Modern World', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(117, 3, 'IS101', 'Fundamentals of Information Systems', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(118, 3, 'CC103', 'Computer Programming 2', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(119, 3, 'NSTP2', 'National Service Training Program 2', 3, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(120, 3, 'PE2', 'Rhythmic Activities', 2, '1st Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(121, 3, 'IS102', 'Professional Issues in Information Systems', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(122, 3, 'OCC101', 'Programming 3 (Object Oriented Programming)', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(123, 3, 'GE-105', 'Science, Technology and Society', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(124, 3, 'IS103', 'IT Infrastructure and Network Technologies', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(125, 3, 'IS104', 'Systems Analysis and Design', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(126, 3, 'DM101', 'Organization and Management Concepts', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(127, 3, 'PE3', 'Individual/Dual Combative Sports', 2, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(128, 3, 'GE9', 'The Life and Works of Rizal', 3, '2nd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(129, 3, 'OCC102', 'Multimedia', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(130, 3, 'GEE 2', 'Reading Visual Arts', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(131, 3, 'GEE 3', 'People and Earth\'s Ecosystem', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(132, 3, 'CC104', 'Data Structures and Algorithms Analysis', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(133, 3, 'IS105', 'Enterprise Architecture', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(134, 3, 'DM102', 'Financial Management', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(135, 3, 'IS106', 'IS Project Management', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(136, 3, 'PE4', 'Team Sports', 2, '2nd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(137, 3, 'DM103', 'Business Process Management', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(138, 3, 'CC105', 'Information Management', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(139, 3, 'ADV04', 'Business Intelligence', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(140, 3, 'ADV02', 'Enterprise Systems', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(141, 3, 'DCC106', 'Application Development and Emerging Technologies', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(142, 3, 'ADV01', 'IS Innovation and New Technologies', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(143, 3, 'ST101', 'Statistics', 3, '3rd Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(144, 3, 'BM201', 'Bookkeeping', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(145, 3, 'DM104', 'Evaluation of Business Performance', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(146, 3, 'QUAMET', 'Quantitative Methods', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(147, 3, 'ADV03', 'IT Security and Management', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(148, 3, 'OCC104', 'Data Communications and Networking', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(149, 3, 'GE 8', 'Ethics', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(150, 3, 'CAP 101', 'Capstone Project', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(151, 3, 'GEE 1', 'Living in the IT Era', 3, '4th Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(152, 3, 'OM101', 'Office Management', 3, '4th Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(153, 3, 'OCC103', 'Database Administration', 3, '4th Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(154, 3, 'OCC105', 'Web Development', 3, '4th Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(155, 3, 'IS 107', 'IS Strategy Management and Acquisition', 3, '4th Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(156, 3, 'CAP102', 'Capstone 2', 3, '4th Year', 'First Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12'),
(157, 3, 'PRAC 101', 'Practicum (500 Hours)', 6, '4th Year', 'Second Semester', 1, NULL, '2025-10-07 11:38:12', '2025-10-07 11:38:12');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(10) NOT NULL,
  `description` text DEFAULT NULL,
  `head_name` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `name`, `code`, `description`, `head_name`, `created_at`) VALUES
(1, 'Computer Science', 'CS', 'Computer Science and Information Technology', 'Dr. John Smith', '2025-09-29 16:50:59'),
(2, 'Mathematics', 'MATH', 'Mathematics and Statistics', 'Dr. Sarah Johnson', '2025-09-29 16:50:59'),
(3, 'Business Administration', 'BA', 'Business and Management Studies', 'Dr. Michael Brown', '2025-09-29 16:50:59'),
(4, 'Engineering', 'ENG', 'Engineering and Technical Studies', 'Dr. Lisa Wilson', '2025-09-29 16:50:59');

-- --------------------------------------------------------

--
-- Table structure for table `document_checklists`
--

CREATE TABLE `document_checklists` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `birth_certificate` tinyint(1) DEFAULT 0,
  `report_card` tinyint(1) DEFAULT 0,
  `good_moral` tinyint(1) DEFAULT 0,
  `id_photo` tinyint(1) DEFAULT 0,
  `certificate_of_enrollment` tinyint(1) DEFAULT 0,
  `medical_certificate` tinyint(1) DEFAULT 0,
  `transcript_of_records` tinyint(1) DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `document_checklists`
--

INSERT INTO `document_checklists` (`id`, `user_id`, `birth_certificate`, `report_card`, `good_moral`, `id_photo`, `certificate_of_enrollment`, `medical_certificate`, `transcript_of_records`, `updated_at`) VALUES
(1, 2, 0, 0, 0, 0, 0, 0, 0, '2025-10-23 14:55:45'),
(2, 3, 1, 1, 1, 1, 1, 1, 1, '2025-10-22 17:07:49'),
(3, 4, 0, 0, 0, 0, 0, 0, 0, '2025-10-27 12:05:03'),
(4, 8, 0, 0, 0, 0, 0, 0, 0, '2025-10-27 18:42:13');

-- --------------------------------------------------------

--
-- Table structure for table `enrolled_students`
--

CREATE TABLE `enrolled_students` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `student_id` varchar(20) NOT NULL,
  `course` varchar(100) DEFAULT NULL,
  `year_level` enum('1st Year','2nd Year','3rd Year','4th Year','5th Year') DEFAULT '1st Year',
  `student_type` enum('Regular','Irregular','Transferee') DEFAULT 'Regular',
  `enrolled_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `academic_year` varchar(20) DEFAULT NULL,
  `semester` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enrolled_students`
--

INSERT INTO `enrolled_students` (`id`, `user_id`, `first_name`, `last_name`, `email`, `phone`, `student_id`, `course`, `year_level`, `student_type`, `enrolled_date`, `academic_year`, `semester`, `created_at`, `updated_at`) VALUES
(14, 3, NULL, NULL, NULL, NULL, 'STU20252896', NULL, '1st Year', 'Regular', '2025-10-24 16:59:04', 'AY 2024-2025', 'Fall 2024', '2025-10-24 16:59:04', '2025-10-24 16:59:04'),
(17, 2, NULL, NULL, NULL, NULL, 'STU20254473', NULL, '1st Year', 'Regular', '2025-10-24 17:21:16', 'AY 2024-2025', 'Fall 2024', '2025-10-24 17:21:16', '2025-10-24 17:21:16'),
(22, 8, 'Juan', 'Dela Cruz', 'juan.delacruz@example.com', '09123456789', '2021001', 'BSE', '1st Year', 'Regular', '2025-10-27 18:40:34', '2023-2024', 'First Semester', '2025-10-27 18:40:34', '2025-10-27 18:41:52'),
(23, NULL, 'Maria', 'Santos', 'maria.santos@example.com', '09187654321', '2021002', 'BTVTED', '2nd Year', 'Regular', '2025-10-27 18:40:34', '2023-2024', 'First Semester', '2025-10-27 18:40:34', '2025-10-27 18:40:34'),
(24, NULL, 'Pedro', 'Reyes', 'pedro.reyes@example.com', '09161234567', '2021003', 'BSIS', '3rd Year', 'Transferee', '2025-10-27 18:40:34', '2023-2024', 'Second Semester', '2025-10-27 18:40:34', '2025-10-27 18:40:34');

-- --------------------------------------------------------

--
-- Table structure for table `programs`
--

CREATE TABLE `programs` (
  `id` int(11) NOT NULL,
  `program_code` varchar(20) NOT NULL,
  `program_name` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `total_units` int(11) DEFAULT 0,
  `years_to_complete` int(11) DEFAULT 4,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `programs`
--

INSERT INTO `programs` (`id`, `program_code`, `program_name`, `description`, `total_units`, `years_to_complete`, `status`, `created_at`, `updated_at`) VALUES
(1, 'BSE', 'Bachelor of Science in Entrepreneurship', 'Undergraduate program focusing on entrepreneurship and business development', 141, 4, 'active', '2025-10-07 11:37:53', '2025-10-07 11:37:53'),
(2, 'BTVTED', 'Bachelor in Technical Vocational Teacher Education', 'Teacher education program for technical and vocational subjects', 176, 4, 'active', '2025-10-07 11:37:53', '2025-10-07 11:37:53'),
(3, 'BSIS', 'Bachelor of Science in Information Systems', 'Information systems and technology program', 152, 4, 'active', '2025-10-07 11:37:53', '2025-10-07 11:37:53');

-- --------------------------------------------------------

--
-- Table structure for table `sections`
--

CREATE TABLE `sections` (
  `id` int(11) NOT NULL,
  `program_id` int(11) NOT NULL,
  `year_level` enum('1st Year','2nd Year','3rd Year','4th Year','5th Year') NOT NULL,
  `semester` enum('First Semester','Second Semester','Summer') NOT NULL,
  `section_name` varchar(50) NOT NULL,
  `section_type` enum('Morning','Afternoon','Evening') NOT NULL,
  `max_capacity` int(11) DEFAULT 50,
  `current_enrolled` int(11) DEFAULT 0,
  `academic_year` varchar(20) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sections`
--

INSERT INTO `sections` (`id`, `program_id`, `year_level`, `semester`, `section_name`, `section_type`, `max_capacity`, `current_enrolled`, `academic_year`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, '1st Year', 'First Semester', 'BSE 1A - Morning', 'Morning', 50, 1, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-24 17:04:14'),
(2, 1, '1st Year', 'First Semester', 'BSE 1B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(3, 1, '1st Year', 'First Semester', 'BSE 1C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(4, 1, '1st Year', 'Second Semester', 'BSE 1A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-24 16:43:51'),
(5, 1, '1st Year', 'Second Semester', 'BSE 1B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(6, 1, '1st Year', 'Second Semester', 'BSE 1C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(7, 1, '2nd Year', 'First Semester', 'BSE 2A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(8, 1, '2nd Year', 'First Semester', 'BSE 2B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(9, 1, '2nd Year', 'First Semester', 'BSE 2C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(10, 1, '2nd Year', 'Second Semester', 'BSE 2A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(11, 1, '2nd Year', 'Second Semester', 'BSE 2B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(12, 1, '2nd Year', 'Second Semester', 'BSE 2C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(13, 1, '3rd Year', 'First Semester', 'BSE 3A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(14, 1, '3rd Year', 'First Semester', 'BSE 3B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(15, 1, '3rd Year', 'First Semester', 'BSE 3C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(16, 1, '3rd Year', 'Second Semester', 'BSE 3A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(17, 1, '3rd Year', 'Second Semester', 'BSE 3B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(18, 1, '3rd Year', 'Second Semester', 'BSE 3C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(19, 1, '4th Year', 'First Semester', 'BSE 4A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(20, 1, '4th Year', 'First Semester', 'BSE 4B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(21, 1, '4th Year', 'First Semester', 'BSE 4C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(22, 1, '4th Year', 'Second Semester', 'BSE 4A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(23, 1, '4th Year', 'Second Semester', 'BSE 4B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(24, 1, '4th Year', 'Second Semester', 'BSE 4C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(25, 2, '1st Year', 'First Semester', 'BTVTED 1A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-23 14:55:33'),
(26, 2, '1st Year', 'First Semester', 'BTVTED 1B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(27, 2, '1st Year', 'First Semester', 'BTVTED 1C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(28, 2, '1st Year', 'Second Semester', 'BTVTED 1A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(29, 2, '1st Year', 'Second Semester', 'BTVTED 1B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(30, 2, '1st Year', 'Second Semester', 'BTVTED 1C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(31, 2, '2nd Year', 'First Semester', 'BTVTED 2A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(32, 2, '2nd Year', 'First Semester', 'BTVTED 2B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(33, 2, '2nd Year', 'First Semester', 'BTVTED 2C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(34, 2, '2nd Year', 'Second Semester', 'BTVTED 2A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(35, 2, '2nd Year', 'Second Semester', 'BTVTED 2B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(36, 2, '2nd Year', 'Second Semester', 'BTVTED 2C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(37, 2, '3rd Year', 'First Semester', 'BTVTED 3A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(38, 2, '3rd Year', 'First Semester', 'BTVTED 3B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(39, 2, '3rd Year', 'First Semester', 'BTVTED 3C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(40, 2, '3rd Year', 'Second Semester', 'BTVTED 3A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(41, 2, '3rd Year', 'Second Semester', 'BTVTED 3B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(42, 2, '3rd Year', 'Second Semester', 'BTVTED 3C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(43, 2, '4th Year', 'First Semester', 'BTVTED 4A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(44, 2, '4th Year', 'First Semester', 'BTVTED 4B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(45, 2, '4th Year', 'First Semester', 'BTVTED 4C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(46, 2, '4th Year', 'Second Semester', 'BTVTED 4A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(47, 2, '4th Year', 'Second Semester', 'BTVTED 4B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(48, 2, '4th Year', 'Second Semester', 'BTVTED 4C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(49, 3, '1st Year', 'First Semester', 'BSIS 1A - Morning', 'Morning', 50, 1, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-24 17:04:18'),
(50, 3, '1st Year', 'First Semester', 'BSIS 1B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(51, 3, '1st Year', 'First Semester', 'BSIS 1C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(52, 3, '1st Year', 'Second Semester', 'BSIS 1A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(53, 3, '1st Year', 'Second Semester', 'BSIS 1B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(54, 3, '1st Year', 'Second Semester', 'BSIS 1C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(55, 3, '2nd Year', 'First Semester', 'BSIS 2A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(56, 3, '2nd Year', 'First Semester', 'BSIS 2B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(57, 3, '2nd Year', 'First Semester', 'BSIS 2C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(58, 3, '2nd Year', 'Second Semester', 'BSIS 2A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(59, 3, '2nd Year', 'Second Semester', 'BSIS 2B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(60, 3, '2nd Year', 'Second Semester', 'BSIS 2C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(61, 3, '3rd Year', 'First Semester', 'BSIS 3A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(62, 3, '3rd Year', 'First Semester', 'BSIS 3B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(63, 3, '3rd Year', 'First Semester', 'BSIS 3C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(64, 3, '3rd Year', 'Second Semester', 'BSIS 3A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(65, 3, '3rd Year', 'Second Semester', 'BSIS 3B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(66, 3, '3rd Year', 'Second Semester', 'BSIS 3C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(67, 3, '4th Year', 'First Semester', 'BSIS 4A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(68, 3, '4th Year', 'First Semester', 'BSIS 4B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(69, 3, '4th Year', 'First Semester', 'BSIS 4C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(70, 3, '4th Year', 'Second Semester', 'BSIS 4A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(71, 3, '4th Year', 'Second Semester', 'BSIS 4B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(72, 3, '4th Year', 'Second Semester', 'BSIS 4C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17');

-- --------------------------------------------------------

--
-- Table structure for table `section_enrollments`
--

CREATE TABLE `section_enrollments` (
  `id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `enrolled_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('active','dropped') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `section_enrollments`
--

INSERT INTO `section_enrollments` (`id`, `section_id`, `user_id`, `enrolled_date`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 3, '2025-10-23 13:20:58', 'active', '2025-10-23 13:20:58', '2025-10-23 13:20:58'),
(2, 1, 2, '2025-10-24 16:56:37', 'dropped', '2025-10-23 13:27:35', '2025-10-24 17:04:14'),
(3, 25, 2, '2025-10-23 13:38:08', 'dropped', '2025-10-23 13:38:08', '2025-10-23 14:55:33'),
(4, 49, 2, '2025-10-24 17:04:18', 'active', '2025-10-24 16:37:12', '2025-10-24 17:04:18');

-- --------------------------------------------------------

--
-- Table structure for table `section_schedules`
--

CREATE TABLE `section_schedules` (
  `id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL,
  `curriculum_id` int(11) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `course_name` varchar(200) NOT NULL,
  `units` int(11) DEFAULT 3,
  `schedule_monday` tinyint(1) DEFAULT 0,
  `schedule_tuesday` tinyint(1) DEFAULT 0,
  `schedule_wednesday` tinyint(1) DEFAULT 0,
  `schedule_thursday` tinyint(1) DEFAULT 0,
  `schedule_friday` tinyint(1) DEFAULT 0,
  `schedule_saturday` tinyint(1) DEFAULT 0,
  `schedule_sunday` tinyint(1) DEFAULT 0,
  `time_start` varchar(10) DEFAULT NULL,
  `time_end` varchar(10) DEFAULT NULL,
  `room` varchar(50) DEFAULT NULL,
  `professor_name` varchar(100) DEFAULT NULL,
  `professor_initial` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `section_schedules`
--

INSERT INTO `section_schedules` (`id`, `section_id`, `curriculum_id`, `course_code`, `course_name`, `units`, `schedule_monday`, `schedule_tuesday`, `schedule_wednesday`, `schedule_thursday`, `schedule_friday`, `schedule_saturday`, `schedule_sunday`, `time_start`, `time_end`, `room`, `professor_name`, `professor_initial`, `created_at`, `updated_at`) VALUES
(2, 1, 1, 'BSE-C101', 'Entrepreneurship Behavior', 3, 0, 0, 0, 0, 0, 0, 1, '00:03', '03:02', 'yeah', 'asd', 'ha', '2025-10-07 15:03:33', '2025-10-07 15:03:33'),
(3, 1, 2, 'GE-100', 'Understanding the Self', 3, 0, 0, 0, 0, 0, 1, 0, '02:03', '02:34', '23', 'sfh', 'asdasf', '2025-10-07 15:15:47', '2025-10-07 15:15:47');

-- --------------------------------------------------------

--
-- Table structure for table `student_schedules`
--

CREATE TABLE `student_schedules` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `section_schedule_id` int(11) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `course_name` varchar(200) NOT NULL,
  `units` int(11) DEFAULT 3,
  `schedule_monday` tinyint(1) DEFAULT 0,
  `schedule_tuesday` tinyint(1) DEFAULT 0,
  `schedule_wednesday` tinyint(1) DEFAULT 0,
  `schedule_thursday` tinyint(1) DEFAULT 0,
  `schedule_friday` tinyint(1) DEFAULT 0,
  `schedule_saturday` tinyint(1) DEFAULT 0,
  `schedule_sunday` tinyint(1) DEFAULT 0,
  `time_start` varchar(10) DEFAULT NULL,
  `time_end` varchar(10) DEFAULT NULL,
  `room` varchar(50) DEFAULT NULL,
  `professor_name` varchar(100) DEFAULT NULL,
  `professor_initial` varchar(20) DEFAULT NULL,
  `status` enum('active','dropped','completed') DEFAULT 'active',
  `assigned_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `student_id` varchar(20) DEFAULT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `address` text DEFAULT NULL,
  `role` enum('student','admin') DEFAULT 'student',
  `status` enum('active','inactive','pending') DEFAULT 'pending',
  `enrollment_status` enum('enrolled','pending') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `activation_token` varchar(64) DEFAULT NULL,
  `token_expiry` datetime DEFAULT NULL,
  `is_imported` tinyint(1) DEFAULT 0,
  `imported_at` datetime DEFAULT NULL,
  `activated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `student_id`, `first_name`, `last_name`, `email`, `password`, `phone`, `date_of_birth`, `address`, `role`, `status`, `enrollment_status`, `created_at`, `updated_at`, `activation_token`, `token_expiry`, `is_imported`, `imported_at`, `activated_at`) VALUES
(2, 'STU20254473', 'lincoln', 'montojo', 'lin@gmail.com', '$2y$10$kiGDx5rfChSFCLt.l0XUTOi.3MH3gIzD1Kt8sWzSaPwZOh3qVIw/6', '123', '1999-09-17', 'asdasd', 'student', 'active', 'enrolled', '2025-09-29 16:54:42', '2025-10-24 17:21:16', NULL, NULL, 0, NULL, NULL),
(3, 'STU20252896', 'asd', 'asd', 'asd@gmail.com', '$2y$10$cfbux1TmJZ.2TOAvrclQ9eHZnlzfmH7dq9d.dAX37PyrR14oj4dBe', 'asd', '2002-10-22', 'asd', 'student', 'active', 'enrolled', '2025-10-01 16:22:25', '2025-10-24 16:59:04', NULL, NULL, 0, NULL, NULL),
(4, 'STU20259559', 'hatdog', 'asd', 'asdf@gmail.com', '$2y$10$IVVMQIvpz2hDBeopTx3vce15Dy5VmuXTgnj92yvR1YaBvsnPt6VIy', '123', '2025-10-23', 'asfasf', 'student', 'active', 'pending', '2025-10-27 12:04:52', '2025-10-27 12:56:39', NULL, NULL, 0, NULL, NULL),
(8, '2021001', 'Juan', 'Dela Cruz', 'juan.delacruz@example.com', '$2y$10$hj1ur1l1WlIBzOrdk6ib9eYOEidy/Ssr1OjsxU.8/gWwh3UHdPHO.', '09123456789', NULL, NULL, 'student', 'active', 'enrolled', '2025-10-27 18:41:52', '2025-10-27 18:41:52', NULL, NULL, 0, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `admin_id` (`admin_id`),
  ADD KEY `idx_admins_email` (`email`),
  ADD KEY `idx_admins_admin_id` (`admin_id`);

--
-- Indexes for table `chatbot_faqs`
--
ALTER TABLE `chatbot_faqs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_active` (`is_active`);

--
-- Indexes for table `chatbot_history`
--
ALTER TABLE `chatbot_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `faq_id` (`faq_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_created` (`created_at`);

--
-- Indexes for table `curriculum`
--
ALTER TABLE `curriculum`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_course_program` (`program_id`,`course_code`,`year_level`,`semester`),
  ADD KEY `idx_curriculum_program` (`program_id`),
  ADD KEY `idx_curriculum_year_sem` (`year_level`,`semester`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `document_checklists`
--
ALTER TABLE `document_checklists`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_checklist` (`user_id`);

--
-- Indexes for table `enrolled_students`
--
ALTER TABLE `enrolled_students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_student_id` (`student_id`),
  ADD KEY `fk_enrolled_user_id` (`user_id`);

--
-- Indexes for table `programs`
--
ALTER TABLE `programs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `program_code` (`program_code`),
  ADD KEY `idx_programs_code` (`program_code`);

--
-- Indexes for table `sections`
--
ALTER TABLE `sections`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_section` (`program_id`,`year_level`,`semester`,`section_type`,`academic_year`),
  ADD KEY `idx_sections_program` (`program_id`),
  ADD KEY `idx_sections_year_sem` (`year_level`,`semester`);

--
-- Indexes for table `section_enrollments`
--
ALTER TABLE `section_enrollments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_student_section` (`user_id`,`section_id`),
  ADD KEY `idx_section_enrollments_section` (`section_id`),
  ADD KEY `idx_section_enrollments_user` (`user_id`);

--
-- Indexes for table `section_schedules`
--
ALTER TABLE `section_schedules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_section_course` (`section_id`,`curriculum_id`),
  ADD KEY `idx_section_schedules_section` (`section_id`),
  ADD KEY `idx_section_schedules_curriculum` (`curriculum_id`);

--
-- Indexes for table `student_schedules`
--
ALTER TABLE `student_schedules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_student_course_schedule` (`user_id`,`section_schedule_id`),
  ADD KEY `section_schedule_id` (`section_schedule_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `student_id` (`student_id`),
  ADD UNIQUE KEY `activation_token` (`activation_token`),
  ADD KEY `idx_users_email` (`email`),
  ADD KEY `idx_users_student_id` (`student_id`),
  ADD KEY `idx_activation_token` (`activation_token`),
  ADD KEY `idx_is_imported` (`is_imported`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `chatbot_faqs`
--
ALTER TABLE `chatbot_faqs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `chatbot_history`
--
ALTER TABLE `chatbot_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `curriculum`
--
ALTER TABLE `curriculum`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=158;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `document_checklists`
--
ALTER TABLE `document_checklists`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `enrolled_students`
--
ALTER TABLE `enrolled_students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `programs`
--
ALTER TABLE `programs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `sections`
--
ALTER TABLE `sections`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT for table `section_enrollments`
--
ALTER TABLE `section_enrollments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `section_schedules`
--
ALTER TABLE `section_schedules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `student_schedules`
--
ALTER TABLE `student_schedules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `chatbot_faqs`
--
ALTER TABLE `chatbot_faqs`
  ADD CONSTRAINT `chatbot_faqs_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `admins` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `chatbot_history`
--
ALTER TABLE `chatbot_history`
  ADD CONSTRAINT `chatbot_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `chatbot_history_ibfk_2` FOREIGN KEY (`faq_id`) REFERENCES `chatbot_faqs` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `curriculum`
--
ALTER TABLE `curriculum`
  ADD CONSTRAINT `curriculum_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `document_checklists`
--
ALTER TABLE `document_checklists`
  ADD CONSTRAINT `document_checklists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `enrolled_students`
--
ALTER TABLE `enrolled_students`
  ADD CONSTRAINT `fk_enrolled_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `sections`
--
ALTER TABLE `sections`
  ADD CONSTRAINT `sections_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `section_enrollments`
--
ALTER TABLE `section_enrollments`
  ADD CONSTRAINT `section_enrollments_ibfk_1` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `section_enrollments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `section_schedules`
--
ALTER TABLE `section_schedules`
  ADD CONSTRAINT `section_schedules_ibfk_1` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `section_schedules_ibfk_2` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_schedules`
--
ALTER TABLE `student_schedules`
  ADD CONSTRAINT `student_schedules_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_schedules_ibfk_2` FOREIGN KEY (`section_schedule_id`) REFERENCES `section_schedules` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
