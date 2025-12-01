-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 01, 2025 at 02:26 PM
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_dean` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `admin_id`, `first_name`, `last_name`, `email`, `password`, `phone`, `role`, `status`, `created_at`, `updated_at`, `is_dean`) VALUES
(1, 'ADMIN001', 'System', 'Administrator', 'admin@occ.edu.ph', '$2y$10$9oECk75rk/6sqrKUoGy6keM5nCPmINkmmHnPHq8GGAj0kNZXJwW1a', NULL, 'registrar', 'active', '2025-09-29 16:50:59', '2025-11-25 08:58:51', 0),
(5, 'DEAN001', 'Dean', 'Administrator', 'dean@occ.edu.ph', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 'dean', 'active', '2025-11-25 08:11:40', '2025-11-25 08:11:40', 1);

-- --------------------------------------------------------

--
-- Table structure for table `admissions`
--

CREATE TABLE `admissions` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admissions`
--

INSERT INTO `admissions` (`id`, `username`, `email`, `password`, `first_name`, `last_name`, `status`, `created_at`, `updated_at`) VALUES
(1, 'admission', 'admission@occ.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admission', 'Officer', 'active', '2025-11-11 06:35:09', '2025-11-11 06:35:09');

-- --------------------------------------------------------

--
-- Table structure for table `application_workflow`
--

CREATE TABLE `application_workflow` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `admission_status` enum('pending_review','documents_incomplete','approved','rejected') DEFAULT 'pending_review',
  `admission_remarks` text DEFAULT NULL,
  `documents_verified` tinyint(1) DEFAULT 0,
  `student_number_assigned` tinyint(1) DEFAULT 0,
  `enrollment_scheduled` tinyint(1) DEFAULT 0,
  `admission_approved_by` int(11) DEFAULT NULL,
  `admission_approved_at` timestamp NULL DEFAULT NULL,
  `passed_to_registrar` tinyint(1) DEFAULT 0,
  `passed_to_registrar_at` timestamp NULL DEFAULT NULL,
  `registrar_status` enum('pending','verified','enrolled') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `application_workflow`
--

INSERT INTO `application_workflow` (`id`, `user_id`, `admission_status`, `admission_remarks`, `documents_verified`, `student_number_assigned`, `enrollment_scheduled`, `admission_approved_by`, `admission_approved_at`, `passed_to_registrar`, `passed_to_registrar_at`, `registrar_status`, `created_at`, `updated_at`) VALUES
(25, 49, 'pending_review', NULL, 0, 1, 0, 1, '2025-12-01 09:50:47', 1, '2025-12-01 09:50:47', 'pending', '2025-12-01 09:50:33', '2025-12-01 09:50:47'),
(26, 50, 'pending_review', NULL, 0, 1, 0, 1, '2025-12-01 10:27:58', 1, '2025-12-01 10:27:58', 'pending', '2025-12-01 09:51:29', '2025-12-01 10:27:58'),
(27, 51, 'pending_review', NULL, 0, 1, 0, 1, '2025-12-01 10:09:17', 1, '2025-12-01 10:09:17', 'pending', '2025-12-01 09:53:42', '2025-12-01 10:09:17'),
(28, 52, 'pending_review', NULL, 0, 1, 0, 1, '2025-12-01 10:27:54', 1, '2025-12-01 10:27:54', 'pending', '2025-12-01 10:02:30', '2025-12-01 10:27:54'),
(29, 53, 'pending_review', NULL, 0, 1, 0, 1, '2025-12-01 10:14:42', 1, '2025-12-01 10:14:42', 'pending', '2025-12-01 10:11:09', '2025-12-01 10:14:42'),
(30, 54, 'pending_review', NULL, 0, 1, 0, 1, '2025-12-01 10:20:59', 1, '2025-12-01 10:20:59', 'pending', '2025-12-01 10:19:59', '2025-12-01 10:20:59'),
(31, 55, 'pending_review', NULL, 0, 1, 0, 1, '2025-12-01 11:16:33', 1, '2025-12-01 11:16:33', 'pending', '2025-12-01 10:51:14', '2025-12-01 11:16:33'),
(32, 56, 'pending_review', NULL, 0, 0, 0, NULL, NULL, 0, NULL, 'pending', '2025-12-01 11:39:20', '2025-12-01 11:39:20');

-- --------------------------------------------------------

--
-- Table structure for table `certificate_of_registration`
--

CREATE TABLE `certificate_of_registration` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL COMMENT 'Student user ID',
  `enrollment_id` int(11) DEFAULT NULL,
  `program_id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL,
  `student_number` varchar(50) DEFAULT NULL,
  `student_last_name` varchar(100) NOT NULL,
  `student_first_name` varchar(100) NOT NULL,
  `student_middle_name` varchar(100) DEFAULT NULL,
  `student_address` text DEFAULT NULL,
  `academic_year` varchar(20) NOT NULL,
  `year_level` varchar(20) NOT NULL,
  `semester` varchar(20) NOT NULL,
  `section_name` varchar(100) NOT NULL,
  `registration_date` date NOT NULL,
  `college_name` varchar(200) DEFAULT 'One Cainta College',
  `registrar_name` varchar(200) DEFAULT 'Mr. Christopher De Veyra',
  `dean_name` varchar(200) DEFAULT 'Dr. Marygin E. Sarmento',
  `adviser_name` varchar(200) DEFAULT NULL,
  `prepared_by` varchar(200) DEFAULT NULL,
  `subjects_json` text NOT NULL COMMENT 'JSON array of subjects with course_code, course_name, units',
  `total_units` decimal(5,2) NOT NULL,
  `created_by` int(11) DEFAULT NULL COMMENT 'Admin user ID who created the COR',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `certificate_of_registration`
--

INSERT INTO `certificate_of_registration` (`id`, `user_id`, `enrollment_id`, `program_id`, `section_id`, `student_number`, `student_last_name`, `student_first_name`, `student_middle_name`, `student_address`, `academic_year`, `year_level`, `semester`, `section_name`, `registration_date`, `college_name`, `registrar_name`, `dean_name`, `adviser_name`, `prepared_by`, `subjects_json`, `total_units`, `created_by`, `created_at`) VALUES
(55, 49, NULL, 3, 49, '2025-00001', 'hatdog', 'hatdog', NULL, NULL, 'AY 2024-2025', '1st Year', 'First Semester', 'BSIS 1A - Morning', '2025-12-01', 'One Cainta College', 'Mr. Christopher De Veyra', 'Dr. Cristine M. Tabien', NULL, 'Registrar Staff', '[{\"course_code\":\"CC101\",\"course_name\":\"INTRODUCTION TO COMPUTING\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"CC102\",\"course_name\":\"COMPUTER PROGRAMMING 1\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE1\",\"course_name\":\"UNDERSTANDING THE SELF\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE2\",\"course_name\":\"READING IN PHILIPPINE HISTORY\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE3\",\"course_name\":\"THE CONTEMPORARY WORLD\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"NSTP 1\",\"course_name\":\"CWTS\\/ROTC1\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"PE 1\",\"course_name\":\"PHYSYCAL FITNESS \\/ SELF-TESTING ACTIVITIES\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null}]', 21.00, 1, '2025-12-01 09:51:39'),
(56, 51, NULL, 3, 49, '2025-00002', 'Feca', 'Reymond', 'Lalice', '831 Bottom Feeder Lane in Bikini Bottom', 'AY 2024-2025', '1st Year', 'First Semester', 'BSIS 1A - Morning', '2025-12-01', 'One Cainta College', 'Mr. Christopher De Veyra', 'Dr. Cristine M. Tabien', NULL, 'Registrar Staff', '[{\"course_code\":\"CC101\",\"course_name\":\"INTRODUCTION TO COMPUTING\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"CC102\",\"course_name\":\"COMPUTER PROGRAMMING 1\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE1\",\"course_name\":\"UNDERSTANDING THE SELF\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE2\",\"course_name\":\"READING IN PHILIPPINE HISTORY\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE3\",\"course_name\":\"THE CONTEMPORARY WORLD\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"NSTP 1\",\"course_name\":\"CWTS\\/ROTC1\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"PE 1\",\"course_name\":\"PHYSYCAL FITNESS \\/ SELF-TESTING ACTIVITIES\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null}]', 21.00, 1, '2025-12-01 10:09:29'),
(57, 51, 49, 3, 52, '2025-00002', 'Feca', 'Reymond', 'Lalice', '831 Bottom Feeder Lane in Bikini Bottom', 'AY 2024-2025', '1st Year', 'Second Semester', 'BSIS 1A - Morning', '2025-12-01', 'One Cainta College', 'Mr. Christopher De Veyra', 'Dr. Cristine M. Tabien', NULL, 'Registrar Staff', '[{\"course_code\":\"GE4\",\"course_name\":\"MATHEMATICS IN THE MODERN WORLD\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE5\",\"course_name\":\"PURPOSIVE COMMUNICATION\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE6\",\"course_name\":\"ART APPRECIATION\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"NSTP 2\",\"course_name\":\"CWTS\\/ROTC2\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"PE 2\",\"course_name\":\"RHYTHMIC ACTIVITIES\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null}]', 15.00, 1, '2025-12-01 10:13:39'),
(58, 53, NULL, 3, 49, '2025-00003', 'Cheeks', 'Sandy', 'Cheeks', '831 Bottom Feeder Lane in Bikini Bottom', 'AY 2024-2025', '1st Year', 'First Semester', 'BSIS 1A - Morning', '2025-12-01', 'One Cainta College', 'Mr. Christopher De Veyra', 'Dr. Cristine M. Tabien', NULL, 'Registrar Staff', '[{\"course_code\":\"CC101\",\"course_name\":\"INTRODUCTION TO COMPUTING\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"CC102\",\"course_name\":\"COMPUTER PROGRAMMING 1\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE1\",\"course_name\":\"UNDERSTANDING THE SELF\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE2\",\"course_name\":\"READING IN PHILIPPINE HISTORY\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE3\",\"course_name\":\"THE CONTEMPORARY WORLD\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"NSTP 1\",\"course_name\":\"CWTS\\/ROTC1\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"PE 1\",\"course_name\":\"PHYSYCAL FITNESS \\/ SELF-TESTING ACTIVITIES\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null}]', 21.00, 1, '2025-12-01 10:17:06'),
(59, 54, NULL, 3, 49, '2025-00004', 'SquarePants', 'SpongeBob', 'Joy', '831 Bottom Feeder Lane in Bikini Bottom', 'AY 2024-2025', '1st Year', 'First Semester', 'BSIS 1A - Morning', '2025-12-01', 'One Cainta College', 'Mr. Christopher De Veyra', 'Dr. Cristine M. Tabien', NULL, 'Registrar Staff', '[{\"course_code\":\"CC101\",\"course_name\":\"INTRODUCTION TO COMPUTING\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"CC102\",\"course_name\":\"COMPUTER PROGRAMMING 1\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE1\",\"course_name\":\"UNDERSTANDING THE SELF\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE2\",\"course_name\":\"READING IN PHILIPPINE HISTORY\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE3\",\"course_name\":\"THE CONTEMPORARY WORLD\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"NSTP 1\",\"course_name\":\"CWTS\\/ROTC1\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"PE 1\",\"course_name\":\"PHYSYCAL FITNESS \\/ SELF-TESTING ACTIVITIES\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null}]', 21.00, 1, '2025-12-01 10:22:07'),
(60, 50, NULL, 3, 49, '2025-00006', 'Asterisk', 'Enigma', 'Recon', 'Sa Bahay', 'AY 2024-2025', '1st Year', 'First Semester', 'BSIS 1A - Morning', '2025-12-01', 'One Cainta College', 'Mr. Christopher De Veyra', 'Dr. Cristine M. Tabien', NULL, 'Registrar Staff', '[{\"course_code\":\"CC101\",\"course_name\":\"INTRODUCTION TO COMPUTING\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"CC102\",\"course_name\":\"COMPUTER PROGRAMMING 1\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE1\",\"course_name\":\"UNDERSTANDING THE SELF\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE2\",\"course_name\":\"READING IN PHILIPPINE HISTORY\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE3\",\"course_name\":\"THE CONTEMPORARY WORLD\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"NSTP 1\",\"course_name\":\"CWTS\\/ROTC1\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"PE 1\",\"course_name\":\"PHYSYCAL FITNESS \\/ SELF-TESTING ACTIVITIES\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null}]', 21.00, 1, '2025-12-01 10:29:00'),
(61, 52, NULL, 3, 49, '2025-00005', 'Star', 'Patrick', 'Star', '831 bottom feeder lane in bikini bottom', 'AY 2024-2025', '1st Year', 'First Semester', 'BSIS 1A - Morning', '2025-12-01', 'One Cainta College', 'Mr. Christopher De Veyra', 'Dr. Cristine M. Tabien', NULL, 'System Administrator', '[{\"course_code\":\"CC101\",\"course_name\":\"INTRODUCTION TO COMPUTING\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"CC102\",\"course_name\":\"COMPUTER PROGRAMMING 1\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE1\",\"course_name\":\"UNDERSTANDING THE SELF\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE2\",\"course_name\":\"READING IN PHILIPPINE HISTORY\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE3\",\"course_name\":\"THE CONTEMPORARY WORLD\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"NSTP 1\",\"course_name\":\"CWTS\\/ROTC1\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"PE 1\",\"course_name\":\"PHYSYCAL FITNESS \\/ SELF-TESTING ACTIVITIES\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null}]', 21.00, 1, '2025-12-01 10:31:11'),
(62, 51, 50, 3, 55, '2025-00002', 'Feca', 'Reymond', 'Lalice', '831 Bottom Feeder Lane in Bikini Bottom', 'AY 2024-2025', '2nd Year', 'First Semester', 'BSIS 2A - Morning', '2025-12-01', 'One Cainta College', 'Mr. Christopher De Veyra', 'Dr. Cristine M. Tabien', NULL, 'Registrar Staff', '[{\"course_code\":\"GEE 1\",\"course_name\":\"FILIPINO\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"IS104\",\"course_name\":\"SYSTEMS ANALYSIS AND DESIGN\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"OCC101\",\"course_name\":\"DISCRETE STRUCTURES\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"PE 3\",\"course_name\":\"INDIVIDUAL & DUAL SPORTS\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null}]', 12.00, 1, '2025-12-01 10:42:02'),
(63, 50, NULL, 3, 52, '2025-00006', 'Asterisk', 'Enigma', 'Recon', 'Sa Bahay', 'AY 2024-2025', '1st Year', 'Second Semester', 'BSIS 1A - Morning', '2025-12-01', 'One Cainta College', 'Mr. Christopher De Veyra', 'Dr. Cristine M. Tabien', NULL, 'Registrar Staff', '[{\"course_code\":\"CC103\",\"course_name\":\"COMPUTER PROGRAMMING 2\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE4\",\"course_name\":\"MATHEMATICS IN THE MODERN WORLD\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE5\",\"course_name\":\"PURPOSIVE COMMUNICATION\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE6\",\"course_name\":\"ART APPRECIATION\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"IS101\",\"course_name\":\"FUNDAMENTALS OF INFORMATION SYSTEMS\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"NSTP 2\",\"course_name\":\"CWTS\\/ROTC2\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"PE 2\",\"course_name\":\"RHYTHMIC ACTIVITIES\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null}]', 21.00, 1, '2025-12-01 10:54:42'),
(64, 50, NULL, 3, 61, '2025-00006', 'Asterisk', 'Enigma', 'Recon', 'Sa Bahay', 'AY 2024-2025', '3rd Year', 'First Semester', 'BSIS 3A - Morning', '2025-12-01', 'One Cainta College', 'Mr. Christopher De Veyra', 'Dr. Cristine M. Tabien', NULL, 'Registrar Staff', '[{\"course_code\":\"ADV01\",\"course_name\":\"BUSINESS INTELLIGENCE\",\"units\":3,\"year_level\":\"3rd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"ADV02\",\"course_name\":\"ENTERPRISE SYSTEM\",\"units\":3,\"year_level\":\"3rd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"CC105\",\"course_name\":\"INFORMATION MANAGEMENT\",\"units\":3,\"year_level\":\"3rd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"DM103\",\"course_name\":\"BUSINESS PROCESS MANAGEMENT\",\"units\":3,\"year_level\":\"3rd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"IS109\",\"course_name\":\"SYSTEMS ANALYSIS AND DESIGN 2\",\"units\":3,\"year_level\":\"3rd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"OCC103\",\"course_name\":\"DATA COMMUNICATIIONS AND NETWORKING\",\"units\":3,\"year_level\":\"3rd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"OCC104\",\"course_name\":\"WEB DEVELOPMENT\",\"units\":3,\"year_level\":\"3rd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null}]', 21.00, 1, '2025-12-01 11:05:05'),
(65, 50, NULL, 3, 55, '2025-00006', 'Asterisk', 'Enigma', 'Recon', 'Sa Bahay', 'AY 2024-2025', '2nd Year', 'First Semester', 'BSIS 2A - Morning', '2025-12-01', 'One Cainta College', 'Mr. Christopher De Veyra', 'Dr. Cristine M. Tabien', NULL, 'Registrar Staff', '[{\"course_code\":\"DM101\",\"course_name\":\"ORGANIZATION AND MANAGEMENT CONCEPTS\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GEE 1\",\"course_name\":\"FILIPINO\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"IS102\",\"course_name\":\"PROFESSIONAL-ISSUES IN INFORMATION SYSTEM\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"IS103\",\"course_name\":\"IT INFRASTRUCTURE AND NETWORK TECHNOLOGIES\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"IS104\",\"course_name\":\"SYSTEMS ANALYSIS AND DESIGN\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"OCC101\",\"course_name\":\"DISCRETE STRUCTURES\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"PE 3\",\"course_name\":\"INDIVIDUAL & DUAL SPORTS\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null}]', 21.00, 1, '2025-12-01 11:05:43'),
(66, 52, 53, 3, 52, '2025-00005', 'Star', 'Patrick', 'Star', '831 bottom feeder lane in bikini bottom', 'AY 2024-2025', '1st Year', 'Second Semester', 'BSIS 1A - Morning', '2025-12-01', 'One Cainta College', 'Mr. Christopher De Veyra', 'Dr. Cristine M. Tabien', NULL, 'Registrar Staff', '[{\"course_code\":\"GE4\",\"course_name\":\"MATHEMATICS IN THE MODERN WORLD\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE5\",\"course_name\":\"PURPOSIVE COMMUNICATION\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE6\",\"course_name\":\"ART APPRECIATION\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"NSTP 2\",\"course_name\":\"CWTS\\/ROTC2\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"PE 2\",\"course_name\":\"RHYTHMIC ACTIVITIES\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null}]', 15.00, 1, '2025-12-01 11:11:53'),
(67, 55, NULL, 3, 49, '2025-00007', 'Plankton', 'Sheldon', 'J', '831 Bottom Feeder Lane in Bikini Bottom', 'AY 2024-2025', '1st Year', 'First Semester', 'BSIS 1A - Morning', '2025-12-01', 'One Cainta College', 'Mr. Christopher De Veyra', 'Dr. Cristine M. Tabien', NULL, 'Registrar Staff', '[{\"course_code\":\"CC101\",\"course_name\":\"INTRODUCTION TO COMPUTING\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"CC102\",\"course_name\":\"COMPUTER PROGRAMMING 1\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE1\",\"course_name\":\"UNDERSTANDING THE SELF\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE2\",\"course_name\":\"READING IN PHILIPPINE HISTORY\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE3\",\"course_name\":\"THE CONTEMPORARY WORLD\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"NSTP 1\",\"course_name\":\"CWTS\\/ROTC1\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"PE 1\",\"course_name\":\"PHYSYCAL FITNESS \\/ SELF-TESTING ACTIVITIES\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null}]', 21.00, 1, '2025-12-01 11:17:28'),
(68, 55, NULL, 3, 52, '2025-00007', 'Plankton', 'Sheldon', 'J', '831 Bottom Feeder Lane in Bikini Bottom', 'AY 2024-2025', '1st Year', 'Second Semester', 'BSIS 1A - Morning', '2025-12-01', 'One Cainta College', 'Mr. Christopher De Veyra', 'Dr. Cristine M. Tabien', NULL, 'Registrar Staff', '[{\"course_code\":\"CC103\",\"course_name\":\"COMPUTER PROGRAMMING 2\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE4\",\"course_name\":\"MATHEMATICS IN THE MODERN WORLD\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE5\",\"course_name\":\"PURPOSIVE COMMUNICATION\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GE6\",\"course_name\":\"ART APPRECIATION\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"IS101\",\"course_name\":\"FUNDAMENTALS OF INFORMATION SYSTEMS\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"NSTP 2\",\"course_name\":\"CWTS\\/ROTC2\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"PE 2\",\"course_name\":\"RHYTHMIC ACTIVITIES\",\"units\":3,\"year_level\":\"1st Year\",\"semester\":\"Second Semester\",\"is_backload\":false,\"backload_year_level\":null}]', 21.00, 1, '2025-12-01 11:25:44'),
(69, 55, NULL, 3, 55, '2025-00007', 'Plankton', 'Sheldon', 'J', '831 Bottom Feeder Lane in Bikini Bottom', 'AY 2024-2025', '2nd Year', 'First Semester', 'BSIS 2A - Morning', '2025-12-01', 'One Cainta College', 'Mr. Christopher De Veyra', 'Dr. Cristine M. Tabien', NULL, 'Registrar Staff', '[{\"course_code\":\"DM101\",\"course_name\":\"ORGANIZATION AND MANAGEMENT CONCEPTS\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GEE 1\",\"course_name\":\"FILIPINO\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"IS102\",\"course_name\":\"PROFESSIONAL-ISSUES IN INFORMATION SYSTEM\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"IS103\",\"course_name\":\"IT INFRASTRUCTURE AND NETWORK TECHNOLOGIES\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"IS104\",\"course_name\":\"SYSTEMS ANALYSIS AND DESIGN\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"OCC101\",\"course_name\":\"DISCRETE STRUCTURES\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"PE 3\",\"course_name\":\"INDIVIDUAL & DUAL SPORTS\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null}]', 21.00, 1, '2025-12-01 11:33:50'),
(70, 52, NULL, 3, 55, '2025-00005', 'Star', 'Patrick', 'Star', '831 bottom feeder lane in bikini bottom', 'AY 2024-2025', '2nd Year', 'First Semester', 'BSIS 2A - Morning', '2025-12-01', 'One Cainta College', 'Mr. Christopher De Veyra', 'Dr. Cristine M. Tabien', NULL, 'Registrar Staff', '[{\"course_code\":\"DM101\",\"course_name\":\"ORGANIZATION AND MANAGEMENT CONCEPTS\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"GEE 1\",\"course_name\":\"FILIPINO\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"IS102\",\"course_name\":\"PROFESSIONAL-ISSUES IN INFORMATION SYSTEM\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"IS103\",\"course_name\":\"IT INFRASTRUCTURE AND NETWORK TECHNOLOGIES\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"IS104\",\"course_name\":\"SYSTEMS ANALYSIS AND DESIGN\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"OCC101\",\"course_name\":\"DISCRETE STRUCTURES\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null},{\"course_code\":\"PE 3\",\"course_name\":\"INDIVIDUAL & DUAL SPORTS\",\"units\":3,\"year_level\":\"2nd Year\",\"semester\":\"First Semester\",\"is_backload\":false,\"backload_year_level\":null}]', 21.00, 1, '2025-12-01 12:09:35');

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
(1, 'How do I enroll?', 'To enroll, you need to: 1) Register an account, 2) Wait for admin approval, 3) Submit required documents, 4) Admin will assign you to sections. Once assigned, you can view your schedule in the \"My Schedule\" tab.', 'enroll,enrollment,register,how to enroll', 'Enrollment', 1, 7, NULL, '2025-10-27 12:34:47', '2025-11-24 21:16:03'),
(2, 'What documents do I need?', 'Required documents include: Birth Certificate, Report Card (Form 138), Good Moral Certificate, ID Photo (2x2), Certificate of Enrollment, Medical Certificate, and Transcript of Records. You can check your document status in the Document Checklist section.', 'documents,requirements,needed,checklist', 'Requirements', 1, 2, NULL, '2025-10-27 12:34:47', '2025-12-01 11:40:00'),
(3, 'How can I view my schedule?', 'Click on \"My Schedule\" in the left menu to view your class schedule. You can see a detailed table and weekly calendar view showing all your classes, times, rooms, and professors.', 'schedule,class schedule,view schedule,timetable', 'Schedule', 1, 2, NULL, '2025-10-27 12:34:47', '2025-11-14 18:30:18'),
(4, 'What are my sections?', 'You can view all your assigned sections by clicking \"My Sections\" in the menu. Each section shows the program, year level, semester, and academic year.', 'sections,my sections,class sections', 'Sections', 1, 1, NULL, '2025-10-27 12:34:47', '2025-11-18 04:38:42'),
(5, 'How do I check my enrollment status?', 'Click on \"Enrollment Status\" in the menu to see your complete enrollment information including your program, year level, semester, and current status.', 'enrollment status,status,check status', 'Enrollment', 1, 2, NULL, '2025-10-27 12:34:47', '2025-11-05 10:10:06'),
(6, 'Who do I contact for help?', 'For enrollment concerns, contact the registrar\'s office at registrar@occ.edu. For technical support, email support@occ.edu.', 'contact,help,support,email', 'General', 1, 2, NULL, '2025-10-27 12:34:47', '2025-10-27 12:35:48'),
(7, 'What is my student ID?', 'Your Student ID is displayed at the top of the sidebar under your name. It was provided when you registered.', 'student id,id number', 'Account', 1, 3, NULL, '2025-10-27 12:34:47', '2025-12-01 10:20:58'),
(8, 'How do I change my password?', 'Currently, password changes must be requested through the admin. Please contact the registrar\'s office with your request.', 'password,change password,reset password', 'Account', 1, 3, NULL, '2025-10-27 12:34:47', '2025-12-01 11:18:36');

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
(25, 51, 'What is my student ID?', 'Your Student ID is displayed at the top of the sidebar under your name. It was provided when you registered.', 7, NULL, '2025-12-01 10:20:58'),
(26, 51, 'How do I change my password?', 'Currently, password changes must be requested through the admin. Please contact the registrar\'s office with your request.', 8, NULL, '2025-12-01 11:18:36'),
(27, 51, 'okay', 'No answer found', NULL, NULL, '2025-12-01 11:18:42'),
(28, 51, 'what is the requirements', 'No answer found', NULL, NULL, '2025-12-01 11:18:54'),
(29, 56, 'What documents do I need?', 'Required documents include: Birth Certificate, Report Card (Form 138), Good Moral Certificate, ID Photo (2x2), Certificate of Enrollment, Medical Certificate, and Transcript of Records. You can check your document status in the Document Checklist section.', 2, NULL, '2025-12-01 11:40:00');

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
(185, 1, 'BSE-C101', 'Entrepreneurship Behavior', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(186, 1, 'GE-100', 'Understanding the Self', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(187, 1, 'GE-101', 'Reading in Philippine History', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(188, 1, 'GE-107', 'The Contemporary World', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(189, 1, 'NSTP1', 'National Service Training Program 1', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(190, 1, 'PE1', 'Physical Fitness/Self-Testing Activities', 2, '1st Year', 'First Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(191, 1, 'BSE-C102', 'Microeconomics', 3, '1st Year', 'Second Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(192, 1, 'GE-104', 'Mathematics in the Modern World', 3, '1st Year', 'Second Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(193, 1, 'GE-103', 'Purposive Communication', 3, '1st Year', 'Second Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(194, 1, 'GE-102', 'Art Appreciation', 3, '1st Year', 'Second Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(195, 1, 'NSTP2', 'National Service Training Program 2', 3, '1st Year', 'Second Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(196, 1, 'PE2', 'Rhythmic Activities', 2, '1st Year', 'Second Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(197, 1, 'BSE-C103', 'Opportunity Seeking', 3, '2nd Year', 'First Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(198, 1, 'GE-105', 'Science', 3, '3rd Year', '', 1, 'Yes', '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(199, 1, 'GE-111', 'Ethics', 3, '2nd Year', 'First Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(200, 1, 'GE-106', 'Rizal\'s Life and Works', 3, '2nd Year', 'First Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(201, 1, 'BSE-C100', 'Entrepreneurial Leadership in an Organization', 3, '2nd Year', 'First Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(202, 1, 'PE3', 'Individual/Dual Combative Sports', 2, '2nd Year', 'First Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(203, 1, 'BSE-C104', 'Market Research and Consumer Behavior', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(204, 1, 'BSE-C105', 'Innovation Management', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(205, 1, 'BSE-C106', 'Pricing and Costing', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(206, 1, 'BSE-C107', 'Human Resources Management', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(207, 1, 'BSE-GC101', 'Mathematics', 3, '3rd Year', '', 1, 'Yes', '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(208, 1, 'BSE-GC102', 'Social Science and Philosophy', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(209, 1, 'BSE-OCC100', 'Living in the IT Era', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(210, 1, 'PE4', 'Team Sports', 2, '2nd Year', 'Second Semester', 1, NULL, '2025-11-14 08:17:39', '2025-11-14 08:17:39'),
(211, 2, 'GE-100', 'Understanding the Self', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(212, 2, 'GE-101', 'Reading in Philippine History', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(213, 2, 'GE-102', 'Art Appreciation', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(214, 2, 'GE-103', 'Purposive Communication', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(215, 2, 'GE-104', 'Mathematics in the Modern World', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(216, 2, 'PE1', 'Physical Fitness/Self-Testing Activities', 2, '1st Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(217, 2, 'NSTP1', 'National Service Training Program 1', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(218, 2, 'GE-107', 'The Contemporary World', 3, '1st Year', 'Second Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(219, 2, 'GE-111', 'Ethics', 3, '1st Year', 'Second Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(220, 2, 'EDUC-100', 'The Teaching Profession', 3, '1st Year', 'Second Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(221, 2, 'EDUC-101', 'The Child and Adolescent Learner and Learning Principles', 3, '1st Year', 'Second Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(222, 2, 'PE2', 'Rhythmic Activities', 2, '1st Year', 'Second Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(223, 2, 'NSTP2', 'National Service Training Program 2', 3, '1st Year', 'Second Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(224, 2, 'EDUC-102', 'Facilitating Learner-Centered Teaching: The Learner-Centered Approach with Emphasis on Trainers Methodology 1', 3, '2nd Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(225, 2, 'EDUC-103', 'Technology for Teaching and Learning 1', 3, '2nd Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(226, 2, 'EDUC-104', 'Building and Enhancing Literacy Across the Curriculum with Emphasis on the 21st Century Skills', 3, '2nd Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(227, 2, 'EDUC-105', 'Andragogy of Learning including Principles of Trainers Methodology', 3, '2nd Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(228, 2, 'EDUC-106', 'Assessment in Learning 1', 3, '2nd Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(229, 2, 'BTVD-T101', 'Introduction to Agri-Fishery and Arts', 3, '2nd Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(230, 2, 'BTVD100', 'Computer System Servicing 1 - Computer Hardware Installation and Maintenance', 3, '2nd Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(231, 2, 'PE3', 'Individual/Dual Combative Sports', 2, '2nd Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(232, 2, 'EDUC-109', 'Curriculum Development and Evaluation with Emphasis on Trainers Methodology II', 3, '2nd Year', 'Second Semester', 1, 'EDUC-102', '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(233, 2, 'EDUC-110', 'Foundation of Special and Inclusive Education (Mandated)', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(234, 2, 'EDUC-111', 'Assessment in Learning 2 with focus on Trainers Methodology 1 & 2', 3, '2nd Year', 'Second Semester', 1, 'EDUC-106', '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(235, 2, 'BTVE-101', 'Computer System Servicing 2 - Computer System Installation and Configuration', 3, '2nd Year', 'Second Semester', 1, 'BTVD100', '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(236, 2, 'PE4', 'Team Sports', 2, '2nd Year', 'Second Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(237, 2, 'EDUC 112', 'Technology Research 1: Methods of Research', 3, '3rd Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(238, 2, 'TLE 1-5', 'Teaching Common Competencies in ICT', 3, '3rd Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(239, 2, 'BTVE 102', 'Visual Graphics Design 1 - Web Site Development and Digital Media Design - Print Media', 3, '3rd Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(240, 2, 'BTVE 103', 'Visual Graphics Design 2 - Web Site Development and Digital Media Design - Video Production', 3, '3rd Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(241, 2, 'BTVE 104', 'Visual Graphics Design 3 - Web Site Development and Digital Media Design - Audio Production', 3, '3rd Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(242, 2, 'BTVE-107', 'Computer Systems Servicing 3 - Computer System Servicing - Network Installation and Maintenance', 3, '3rd Year', 'First Semester', 1, 'BTVE-101', '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(243, 2, 'BTVE-106', 'Programming 1 - Program Logic Formulation', 3, '3rd Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(244, 2, 'BTVD-E113', 'Technology Research 2 - Undergraduate Thesis Writing/Research paper', 3, '3rd Year', 'Second Semester', 1, 'EDUC 112', '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(245, 2, 'BTVE 108', 'Visual Graphics Design 5 - Website Development and Digital Media Design - Web Site Creation (HTML5)', 3, '3rd Year', 'Second Semester', 1, 'BTVE 102', '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(246, 2, 'BTVE 111', 'Programming 2 - Developing Web Applications (ASP.net)', 3, '3rd Year', 'Second Semester', 1, 'BTVE-106', '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(247, 2, 'EDUC-200', 'Field Study 1 - Observations of Teaching-Learning in Actual School Environment', 3, '4th Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(248, 2, 'EDUC-201', 'Field Study 2 - Participation and Teaching Assistantship', 3, '4th Year', 'First Semester', 1, NULL, '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(249, 2, 'EDUC-202', 'Teaching Internship', 6, '4th Year', 'Second Semester', 1, 'EDUC-201', '2025-11-14 08:18:48', '2025-11-14 08:18:48'),
(250, 3, 'CC101', 'INTRODUCTION TO COMPUTING', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(251, 3, 'CC102', 'COMPUTER PROGRAMMING 1', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(252, 3, 'GE1', 'UNDERSTANDING THE SELF', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(253, 3, 'GE2', 'READING IN PHILIPPINE HISTORY', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(254, 3, 'GE3', 'THE CONTEMPORARY WORLD', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(255, 3, 'NSTP 1', 'CWTS/ROTC1', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(256, 3, 'PE 1', 'PHYSYCAL FITNESS / SELF-TESTING ACTIVITIES', 3, '1st Year', 'First Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(257, 3, 'CC103', 'COMPUTER PROGRAMMING 2', 3, '1st Year', 'Second Semester', 1, 'CC102', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(258, 3, 'GE4', 'MATHEMATICS IN THE MODERN WORLD', 3, '1st Year', 'Second Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(259, 3, 'GE5', 'PURPOSIVE COMMUNICATION', 3, '1st Year', 'Second Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(260, 3, 'GE6', 'ART APPRECIATION', 3, '1st Year', 'Second Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(261, 3, 'IS101', 'FUNDAMENTALS OF INFORMATION SYSTEMS', 3, '1st Year', 'Second Semester', 1, 'CC101', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(262, 3, 'NSTP 2', 'CWTS/ROTC2', 3, '1st Year', 'Second Semester', 1, 'NSTP 1', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(263, 3, 'PE 2', 'RHYTHMIC ACTIVITIES', 3, '1st Year', 'Second Semester', 1, 'PE 1', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(264, 3, 'DM101', 'ORGANIZATION AND MANAGEMENT CONCEPTS', 3, '2nd Year', 'First Semester', 1, 'CC101', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(265, 3, 'GEE 1', 'FILIPINO', 3, '2nd Year', 'First Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(266, 3, 'IS102', 'PROFESSIONAL-ISSUES IN INFORMATION SYSTEM', 3, '2nd Year', 'First Semester', 1, 'CC101', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(267, 3, 'IS103', 'IT INFRASTRUCTURE AND NETWORK TECHNOLOGIES', 3, '2nd Year', 'First Semester', 1, 'CC101', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(268, 3, 'IS104', 'SYSTEMS ANALYSIS AND DESIGN', 3, '2nd Year', 'First Semester', 1, '2ND YEAR STANDING', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(269, 3, 'OCC101', 'DISCRETE STRUCTURES', 3, '2nd Year', 'First Semester', 1, 'GE4', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(270, 3, 'PE 3', 'INDIVIDUAL & DUAL SPORTS', 3, '2nd Year', 'First Semester', 1, 'PE 2', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(271, 3, 'CC104', 'DATA STRUCTURES AND ALGORITHMS ANALYSIS', 3, '2nd Year', 'Second Semester', 1, 'CC103', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(272, 3, 'DM102', 'FINANCIAL MANAGEMENT', 3, '2nd Year', 'Second Semester', 1, 'DM101', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(273, 3, 'GEE 2', 'PANITIKAN', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(274, 3, 'IS105', 'ENTERPRISE ARCHITECTURE', 3, '2nd Year', 'Second Semester', 1, 'IS103', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(275, 3, 'IS106', 'IS PROJECT MANAGEMENT 1', 3, '2nd Year', 'Second Semester', 1, 'IS104', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(276, 3, 'IS108', 'IT INFRASTRUCTURE AND NETWORK TECHNOLOGY 2', 3, '2nd Year', 'Second Semester', 1, 'IS103', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(277, 3, 'OCC102', 'MULTIMEDIA', 3, '2nd Year', 'Second Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(278, 3, 'PE 4', 'TEAM SPORTS', 3, '2nd Year', 'Second Semester', 1, 'PE 3', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(279, 3, 'ADV01', 'BUSINESS INTELLIGENCE', 3, '3rd Year', 'First Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(280, 3, 'ADV02', 'ENTERPRISE SYSTEM', 3, '3rd Year', 'First Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(281, 3, 'CC105', 'INFORMATION MANAGEMENT', 3, '3rd Year', 'First Semester', 1, 'CC104', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(282, 3, 'DM103', 'BUSINESS PROCESS MANAGEMENT', 3, '3rd Year', 'First Semester', 1, 'DM102', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(283, 3, 'IS109', 'SYSTEMS ANALYSIS AND DESIGN 2', 3, '3rd Year', 'First Semester', 1, 'IS104', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(284, 3, 'OCC103', 'DATA COMMUNICATIIONS AND NETWORKING', 3, '3rd Year', 'First Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(285, 3, 'OCC104', 'WEB DEVELOPMENT', 3, '3rd Year', 'First Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(286, 3, 'ADV03', 'IT SECURITY AND MANAGEMENT', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(287, 3, 'ADV04', 'SUPPLY CHAIN MANAGEMENT', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(288, 3, 'CAP101', 'CAPSTONE PROJECT 1', 3, '3rd Year', 'Second Semester', 1, 'All major subjects below 3rd year Second Semester', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(289, 3, 'DM104', 'EVALUATION OF BUSINESS PERFORMANCE', 3, '3rd Year', 'Second Semester', 1, 'DM103', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(290, 3, 'GE8', 'ETHICS', 3, '3rd Year', 'Second Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(291, 3, 'QUAMET', 'QUANTITATIVE METHODS', 3, '3rd Year', 'Second Semester', 1, '3rd Year Standing', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(292, 3, 'CAP102', 'CAPSTONE PROJECT 2', 3, '4th Year', 'First Semester', 1, 'CAP101', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(293, 3, 'CC106', 'APPLICATION DEVELOPMENT AND EMERGING TECHNOLOGIES', 3, '4th Year', 'First Semester', 1, '4TH YEAR', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(294, 3, 'GE 7', 'SCIENCE, TECHNOLOGY, AND SOCIETY', 3, '4th Year', 'First Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(295, 3, 'GE 9', 'THE LIFE AND WORKS OF RIZAL', 3, '4th Year', 'First Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(296, 3, 'GEE 3', 'LIVING IN THE IT ERA', 3, '4th Year', 'First Semester', 1, NULL, '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(297, 3, 'IS107', 'IS STRATEGY, MANAGEMENT AND AQUISITION', 3, '4th Year', 'First Semester', 1, '4TH YEAR', '2025-11-25 16:10:07', '2025-11-25 16:10:07'),
(298, 3, 'PRAC101', 'PRACTICUM (500 hours)', 6, '4th Year', 'Second Semester', 1, 'ALL MAJOR SUBJECTS', '2025-11-25 16:10:07', '2025-11-25 16:10:07');

-- --------------------------------------------------------

--
-- Table structure for table `curriculum_submissions`
--

CREATE TABLE `curriculum_submissions` (
  `id` int(11) NOT NULL,
  `program_head_id` int(11) NOT NULL,
  `program_id` int(11) NOT NULL,
  `submission_title` varchar(200) NOT NULL,
  `submission_description` text DEFAULT NULL,
  `academic_year` varchar(20) NOT NULL,
  `semester` varchar(50) NOT NULL,
  `status` enum('draft','submitted','approved','rejected') DEFAULT 'draft',
  `submitted_at` timestamp NULL DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `reviewed_by` int(11) DEFAULT NULL,
  `reviewer_comments` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `dean_approved` tinyint(1) DEFAULT 0,
  `dean_approved_by` int(11) DEFAULT NULL,
  `dean_approved_at` timestamp NULL DEFAULT NULL,
  `dean_notes` text DEFAULT NULL,
  `submitted_by` int(11) DEFAULT NULL,
  `admin_approved_at` timestamp NULL DEFAULT NULL,
  `admin_approved` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `curriculum_submissions`
--

INSERT INTO `curriculum_submissions` (`id`, `program_head_id`, `program_id`, `submission_title`, `submission_description`, `academic_year`, `semester`, `status`, `submitted_at`, `reviewed_at`, `reviewed_by`, `reviewer_comments`, `created_at`, `updated_at`, `dean_approved`, `dean_approved_by`, `dean_approved_at`, `dean_notes`, `submitted_by`, `admin_approved_at`, `admin_approved`) VALUES
(1, 1, 1, 'Bulk Import - 2025-11-11 11:58:12', 'Bulk imported curriculum from CSV file', 'AY 2024-2025', 'First Semester', 'approved', '2025-11-11 11:15:04', '2025-11-11 11:15:27', 1, 'Approved and added to curriculum', '2025-11-11 10:58:12', '2025-11-11 11:15:27', 0, NULL, NULL, NULL, NULL, NULL, 0),
(2, 2, 2, 'Bulk Import - 2025-11-14 09:01:29', 'Bulk imported curriculum from CSV file', 'AY 2024-2025', 'First Semester', 'approved', '2025-11-14 08:02:14', '2025-11-14 08:02:24', 1, 'Approved and added to curriculum', '2025-11-14 08:01:29', '2025-11-14 08:02:24', 0, NULL, NULL, NULL, NULL, NULL, 0),
(3, 1, 1, 'Bulk Import - 2025-11-14 09:17:39', 'Bulk imported curriculum from CSV file', 'AY 2024-2025', 'Mixed', 'approved', '2025-11-14 08:17:39', '2025-11-14 08:17:39', NULL, 'Auto-approved: Bulk imported and added directly to curriculum', '2025-11-14 08:17:39', '2025-11-14 08:17:39', 0, NULL, NULL, NULL, NULL, NULL, 0),
(4, 2, 2, 'Bulk Import - 2025-11-14 09:18:48', 'Bulk imported curriculum from CSV file', 'AY 2024-2025', 'Mixed', 'approved', '2025-11-14 08:18:48', '2025-11-14 08:18:48', NULL, 'Auto-approved: Bulk imported and added directly to curriculum', '2025-11-14 08:18:48', '2025-11-14 08:18:48', 0, NULL, NULL, NULL, NULL, NULL, 0),
(5, 3, 3, 'Bulk Import - 2025-11-25 17:01:16', 'Bulk imported curriculum from CSV file', '2024-2025', 'Mixed', 'approved', '2025-11-25 16:01:16', NULL, NULL, NULL, '2025-11-25 16:01:16', '2025-11-25 16:02:05', 1, 5, '2025-11-25 16:02:05', '', 3, '2025-11-25 16:01:16', 1);

-- --------------------------------------------------------

--
-- Table structure for table `curriculum_submission_items`
--

CREATE TABLE `curriculum_submission_items` (
  `id` int(11) NOT NULL,
  `submission_id` int(11) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `course_name` varchar(200) NOT NULL,
  `units` int(11) DEFAULT 3,
  `year_level` enum('1st Year','2nd Year','3rd Year','4th Year','5th Year') NOT NULL,
  `semester` enum('First Semester','Second Semester','Summer') NOT NULL,
  `is_required` tinyint(1) DEFAULT 1,
  `pre_requisites` text DEFAULT NULL,
  `status` enum('pending','added','rejected') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `curriculum_submission_items`
--

INSERT INTO `curriculum_submission_items` (`id`, `submission_id`, `course_code`, `course_name`, `units`, `year_level`, `semester`, `is_required`, `pre_requisites`, `status`, `created_at`) VALUES
(1, 1, 'BSE-C101', 'Entrepreneurship Behavior', 3, '1st Year', 'First Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(2, 1, 'GE-100', 'Understanding the Self', 3, '1st Year', 'First Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(3, 1, 'GE-101', 'Reading in Philippine History', 3, '1st Year', 'First Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(4, 1, 'GE-107', 'The Contemporary World', 3, '1st Year', 'First Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(5, 1, 'NSTP1', 'National Service Training Program 1', 3, '1st Year', 'First Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(6, 1, 'PE1', 'Physical Fitness/Self-Testing Activities', 2, '1st Year', 'First Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(7, 1, 'BSE-C102', 'Microeconomics', 3, '1st Year', 'Second Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(8, 1, 'GE-104', 'Mathematics in the Modern World', 3, '1st Year', 'Second Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(9, 1, 'GE-103', 'Purposive Communication', 3, '1st Year', 'Second Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(10, 1, 'GE-102', 'Art Appreciation', 3, '1st Year', 'Second Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(11, 1, 'NSTP2', 'National Service Training Program 2', 3, '1st Year', 'Second Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(12, 1, 'PE2', 'Rhythmic Activities', 2, '1st Year', 'Second Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(13, 1, 'BSE-C103', 'Opportunity Seeking', 3, '2nd Year', 'First Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(14, 1, 'GE-105', 'Science', 0, '3rd Year', '', 0, 'Yes', 'added', '2025-11-11 10:58:12'),
(15, 1, 'GE-111', 'Ethics', 3, '2nd Year', 'First Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(16, 1, 'GE-106', 'Rizal\'s Life and Works', 3, '2nd Year', 'First Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(17, 1, 'BSE-C100', 'Entrepreneurial Leadership in an Organization', 3, '2nd Year', 'First Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(18, 1, 'PE3', 'Individual/Dual Combative Sports', 2, '2nd Year', 'First Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(19, 1, 'BSE-C104', 'Market Research and Consumer Behavior', 3, '2nd Year', 'Second Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(20, 1, 'BSE-C105', 'Innovation Management', 3, '2nd Year', 'Second Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(21, 1, 'BSE-C106', 'Pricing and Costing', 3, '2nd Year', 'Second Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(22, 1, 'BSE-C107', 'Human Resources Management', 3, '2nd Year', 'Second Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(23, 1, 'BSE-GC101', 'Mathematics', 0, '3rd Year', '', 0, 'Yes', 'added', '2025-11-11 10:58:12'),
(24, 1, 'BSE-GC102', 'Social Science and Philosophy', 3, '2nd Year', 'Second Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(25, 1, 'BSE-OCC100', 'Living in the IT Era', 3, '2nd Year', 'Second Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(26, 1, 'PE4', 'Team Sports', 2, '2nd Year', 'Second Semester', 1, '', 'added', '2025-11-11 10:58:12'),
(27, 2, 'BTVTED', 'GE-100', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(28, 2, 'BTVTED', 'GE-101', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(29, 2, 'BTVTED', 'GE-102', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(30, 2, 'BTVTED', 'GE-103', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(31, 2, 'BTVTED', 'GE-104', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(32, 2, 'BTVTED', 'PE1', 0, '2nd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(33, 2, 'BTVTED', 'NSTP1', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(34, 2, 'BTVTED', 'GE-107', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(35, 2, 'BTVTED', 'GE-111', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(36, 2, 'BTVTED', 'EDUC-100', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(37, 2, 'BTVTED', 'EDUC-101', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(38, 2, 'BTVTED', 'PE2', 0, '2nd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(39, 2, 'BTVTED', 'NSTP2', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(40, 2, 'BTVTED', 'EDUC-102', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(41, 2, 'BTVTED', 'EDUC-103', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(42, 2, 'BTVTED', 'EDUC-104', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(43, 2, 'BTVTED', 'EDUC-105', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(44, 2, 'BTVTED', 'EDUC-106', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(45, 2, 'BTVTED', 'BTVD-T101', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(46, 2, 'BTVTED', 'BTVD100', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(47, 2, 'BTVTED', 'PE3', 0, '2nd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(48, 2, 'BTVTED', 'EDUC-109', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(49, 2, 'BTVTED', 'EDUC-110', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(50, 2, 'BTVTED', 'EDUC-111', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(51, 2, 'BTVTED', 'BTVE-101', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(52, 2, 'BTVTED', 'PE4', 0, '2nd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(53, 2, 'BTVTED', 'EDUC 112', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(54, 2, 'BTVTED', 'TLE 1-5', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(55, 2, 'BTVTED', 'BTVE 102', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(56, 2, 'BTVTED', 'BTVE 103', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(57, 2, 'BTVTED', 'BTVE 104', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(58, 2, 'BTVTED', 'BTVE-107', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(59, 2, 'BTVTED', 'BTVE-106', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(60, 2, 'BTVTED', 'BTVD-E113', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(61, 2, 'BTVTED', 'BTVE 108', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(62, 2, 'BTVTED', 'BTVE 111', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(63, 2, 'BTVTED', 'EDUC-200', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(64, 2, 'BTVTED', 'EDUC-201', 0, '3rd Year', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(65, 2, 'BTVTED', 'EDUC-202', 0, '', '', 0, '1', 'added', '2025-11-14 08:01:29'),
(66, 3, 'BSE-C101', 'Entrepreneurship Behavior', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(67, 3, 'GE-100', 'Understanding the Self', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(68, 3, 'GE-101', 'Reading in Philippine History', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(69, 3, 'GE-107', 'The Contemporary World', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(70, 3, 'NSTP1', 'National Service Training Program 1', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(71, 3, 'PE1', 'Physical Fitness/Self-Testing Activities', 2, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(72, 3, 'BSE-C102', 'Microeconomics', 3, '1st Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(73, 3, 'GE-104', 'Mathematics in the Modern World', 3, '1st Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(74, 3, 'GE-103', 'Purposive Communication', 3, '1st Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(75, 3, 'GE-102', 'Art Appreciation', 3, '1st Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(76, 3, 'NSTP2', 'National Service Training Program 2', 3, '1st Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(77, 3, 'PE2', 'Rhythmic Activities', 2, '1st Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(78, 3, 'BSE-C103', 'Opportunity Seeking', 3, '2nd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(79, 3, 'GE-105', 'Science', 3, '3rd Year', '', 1, 'Yes', 'pending', '2025-11-14 08:17:39'),
(80, 3, 'GE-111', 'Ethics', 3, '2nd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(81, 3, 'GE-106', 'Rizal\'s Life and Works', 3, '2nd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(82, 3, 'BSE-C100', 'Entrepreneurial Leadership in an Organization', 3, '2nd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(83, 3, 'PE3', 'Individual/Dual Combative Sports', 2, '2nd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(84, 3, 'BSE-C104', 'Market Research and Consumer Behavior', 3, '2nd Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(85, 3, 'BSE-C105', 'Innovation Management', 3, '2nd Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(86, 3, 'BSE-C106', 'Pricing and Costing', 3, '2nd Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(87, 3, 'BSE-C107', 'Human Resources Management', 3, '2nd Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(88, 3, 'BSE-GC101', 'Mathematics', 3, '3rd Year', '', 1, 'Yes', 'pending', '2025-11-14 08:17:39'),
(89, 3, 'BSE-GC102', 'Social Science and Philosophy', 3, '2nd Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(90, 3, 'BSE-OCC100', 'Living in the IT Era', 3, '2nd Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(91, 3, 'PE4', 'Team Sports', 2, '2nd Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:17:39'),
(92, 4, 'GE-100', 'Understanding the Self', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(93, 4, 'GE-101', 'Reading in Philippine History', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(94, 4, 'GE-102', 'Art Appreciation', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(95, 4, 'GE-103', 'Purposive Communication', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(96, 4, 'GE-104', 'Mathematics in the Modern World', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(97, 4, 'PE1', 'Physical Fitness/Self-Testing Activities', 2, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(98, 4, 'NSTP1', 'National Service Training Program 1', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(99, 4, 'GE-107', 'The Contemporary World', 3, '1st Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(100, 4, 'GE-111', 'Ethics', 3, '1st Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(101, 4, 'EDUC-100', 'The Teaching Profession', 3, '1st Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(102, 4, 'EDUC-101', 'The Child and Adolescent Learner and Learning Principles', 3, '1st Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(103, 4, 'PE2', 'Rhythmic Activities', 2, '1st Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(104, 4, 'NSTP2', 'National Service Training Program 2', 3, '1st Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(105, 4, 'EDUC-102', 'Facilitating Learner-Centered Teaching: The Learner-Centered Approach with Emphasis on Trainers Methodology 1', 3, '2nd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(106, 4, 'EDUC-103', 'Technology for Teaching and Learning 1', 3, '2nd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(107, 4, 'EDUC-104', 'Building and Enhancing Literacy Across the Curriculum with Emphasis on the 21st Century Skills', 3, '2nd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(108, 4, 'EDUC-105', 'Andragogy of Learning including Principles of Trainers Methodology', 3, '2nd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(109, 4, 'EDUC-106', 'Assessment in Learning 1', 3, '2nd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(110, 4, 'BTVD-T101', 'Introduction to Agri-Fishery and Arts', 3, '2nd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(111, 4, 'BTVD100', 'Computer System Servicing 1 - Computer Hardware Installation and Maintenance', 3, '2nd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(112, 4, 'PE3', 'Individual/Dual Combative Sports', 2, '2nd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(113, 4, 'EDUC-109', 'Curriculum Development and Evaluation with Emphasis on Trainers Methodology II', 3, '2nd Year', 'Second Semester', 1, 'EDUC-102', 'pending', '2025-11-14 08:18:48'),
(114, 4, 'EDUC-110', 'Foundation of Special and Inclusive Education (Mandated)', 3, '2nd Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(115, 4, 'EDUC-111', 'Assessment in Learning 2 with focus on Trainers Methodology 1 & 2', 3, '2nd Year', 'Second Semester', 1, 'EDUC-106', 'pending', '2025-11-14 08:18:48'),
(116, 4, 'BTVE-101', 'Computer System Servicing 2 - Computer System Installation and Configuration', 3, '2nd Year', 'Second Semester', 1, 'BTVD100', 'pending', '2025-11-14 08:18:48'),
(117, 4, 'PE4', 'Team Sports', 2, '2nd Year', 'Second Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(118, 4, 'EDUC 112', 'Technology Research 1: Methods of Research', 3, '3rd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(119, 4, 'TLE 1-5', 'Teaching Common Competencies in ICT', 3, '3rd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(120, 4, 'BTVE 102', 'Visual Graphics Design 1 - Web Site Development and Digital Media Design - Print Media', 3, '3rd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(121, 4, 'BTVE 103', 'Visual Graphics Design 2 - Web Site Development and Digital Media Design - Video Production', 3, '3rd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(122, 4, 'BTVE 104', 'Visual Graphics Design 3 - Web Site Development and Digital Media Design - Audio Production', 3, '3rd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(123, 4, 'BTVE-107', 'Computer Systems Servicing 3 - Computer System Servicing - Network Installation and Maintenance', 3, '3rd Year', 'First Semester', 1, 'BTVE-101', 'pending', '2025-11-14 08:18:48'),
(124, 4, 'BTVE-106', 'Programming 1 - Program Logic Formulation', 3, '3rd Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(125, 4, 'BTVD-E113', 'Technology Research 2 - Undergraduate Thesis Writing/Research paper', 3, '3rd Year', 'Second Semester', 1, 'EDUC 112', 'pending', '2025-11-14 08:18:48'),
(126, 4, 'BTVE 108', 'Visual Graphics Design 5 - Website Development and Digital Media Design - Web Site Creation (HTML5)', 3, '3rd Year', 'Second Semester', 1, 'BTVE 102', 'pending', '2025-11-14 08:18:48'),
(127, 4, 'BTVE 111', 'Programming 2 - Developing Web Applications (ASP.net)', 3, '3rd Year', 'Second Semester', 1, 'BTVE-106', 'pending', '2025-11-14 08:18:48'),
(128, 4, 'EDUC-200', 'Field Study 1 - Observations of Teaching-Learning in Actual School Environment', 3, '4th Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(129, 4, 'EDUC-201', 'Field Study 2 - Participation and Teaching Assistantship', 3, '4th Year', 'First Semester', 1, NULL, 'pending', '2025-11-14 08:18:48'),
(130, 4, 'EDUC-202', 'Teaching Internship', 6, '4th Year', 'Second Semester', 1, 'EDUC-201', 'pending', '2025-11-14 08:18:48'),
(131, 5, 'GE1', 'UNDERSTANDING THE SELF', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(132, 5, 'GE2', 'READING IN PHILIPPINE HISTORY', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(133, 5, 'GE3', 'THE CONTEMPORARY WORLD', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(134, 5, 'CC101', 'INTRODUCTION TO COMPUTING', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(135, 5, 'CC102', 'COMPUTER PROGRAMMING 1', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(136, 5, 'PE 1', 'PHYSYCAL FITNESS / SELF-TESTING ACTIVITIES', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(137, 5, 'NSTP 1', 'CWTS/ROTC1', 3, '1st Year', 'First Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(138, 5, 'GE4', 'MATHEMATICS IN THE MODERN WORLD', 3, '1st Year', 'Second Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(139, 5, 'GE5', 'PURPOSIVE COMMUNICATION', 3, '1st Year', 'Second Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(140, 5, 'GE6', 'ART APPRECIATION', 3, '1st Year', 'Second Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(141, 5, 'IS101', 'FUNDAMENTALS OF INFORMATION SYSTEMS', 3, '1st Year', 'Second Semester', 1, 'CC101', 'pending', '2025-11-25 16:01:16'),
(142, 5, 'CC103', 'COMPUTER PROGRAMMING 2', 3, '1st Year', 'Second Semester', 1, 'CC102', 'pending', '2025-11-25 16:01:16'),
(143, 5, 'PE 2', 'RHYTHMIC ACTIVITIES', 3, '1st Year', 'Second Semester', 1, 'PE 1', 'pending', '2025-11-25 16:01:16'),
(144, 5, 'NSTP 2', 'CWTS/ROTC2', 3, '1st Year', 'Second Semester', 1, 'NSTP 1', 'pending', '2025-11-25 16:01:16'),
(145, 5, 'OCC101', 'DISCRETE STRUCTURES', 3, '2nd Year', 'First Semester', 1, 'GE4', 'pending', '2025-11-25 16:01:16'),
(146, 5, 'GEE 1', 'FILIPINO', 3, '2nd Year', 'First Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(147, 5, 'IS104', 'SYSTEMS ANALYSIS AND DESIGN', 3, '2nd Year', 'First Semester', 1, '2ND YEAR STANDING', 'pending', '2025-11-25 16:01:16'),
(148, 5, 'IS102', 'PROFESSIONAL-ISSUES IN INFORMATION SYSTEM', 3, '2nd Year', 'First Semester', 1, 'CC101', 'pending', '2025-11-25 16:01:16'),
(149, 5, 'IS103', 'IT INFRASTRUCTURE AND NETWORK TECHNOLOGIES', 3, '2nd Year', 'First Semester', 1, 'CC101', 'pending', '2025-11-25 16:01:16'),
(150, 5, 'DM101', 'ORGANIZATION AND MANAGEMENT CONCEPTS', 3, '2nd Year', 'First Semester', 1, 'CC101', 'pending', '2025-11-25 16:01:16'),
(151, 5, 'PE 3', 'INDIVIDUAL & DUAL SPORTS', 3, '2nd Year', 'First Semester', 1, 'PE 2', 'pending', '2025-11-25 16:01:16'),
(152, 5, 'OCC102', 'MULTIMEDIA', 3, '2nd Year', 'Second Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(153, 5, 'CC104', 'DATA STRUCTURES AND ALGORITHMS ANALYSIS', 3, '2nd Year', 'Second Semester', 1, 'CC103', 'pending', '2025-11-25 16:01:16'),
(154, 5, 'IS108', 'IT INFRASTRUCTURE AND NETWORK TECHNOLOGY 2', 3, '2nd Year', 'Second Semester', 1, 'IS103', 'pending', '2025-11-25 16:01:16'),
(155, 5, 'GEE 2', 'PANITIKAN', 3, '2nd Year', 'Second Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(156, 5, 'IS105', 'ENTERPRISE ARCHITECTURE', 3, '2nd Year', 'Second Semester', 1, 'IS103', 'pending', '2025-11-25 16:01:16'),
(157, 5, 'DM102', 'FINANCIAL MANAGEMENT', 3, '2nd Year', 'Second Semester', 1, 'DM101', 'pending', '2025-11-25 16:01:16'),
(158, 5, 'IS106', 'IS PROJECT MANAGEMENT 1', 3, '2nd Year', 'Second Semester', 1, 'IS104', 'pending', '2025-11-25 16:01:16'),
(159, 5, 'PE 4', 'TEAM SPORTS', 3, '2nd Year', 'Second Semester', 1, 'PE 3', 'pending', '2025-11-25 16:01:16'),
(160, 5, 'DM103', 'BUSINESS PROCESS MANAGEMENT', 3, '3rd Year', 'First Semester', 1, 'DM102', 'pending', '2025-11-25 16:01:16'),
(161, 5, 'CC105', 'INFORMATION MANAGEMENT', 3, '3rd Year', 'First Semester', 1, 'CC104', 'pending', '2025-11-25 16:01:16'),
(162, 5, 'IS109', 'SYSTEMS ANALYSIS AND DESIGN 2', 3, '3rd Year', 'First Semester', 1, 'IS104', 'pending', '2025-11-25 16:01:16'),
(163, 5, 'ADV01', 'BUSINESS INTELLIGENCE', 3, '3rd Year', 'First Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(164, 5, 'ADV02', 'ENTERPRISE SYSTEM', 3, '3rd Year', 'First Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(165, 5, 'OCC103', 'DATA COMMUNICATIIONS AND NETWORKING', 3, '3rd Year', 'First Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(166, 5, 'OCC104', 'WEB DEVELOPMENT', 3, '3rd Year', 'First Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(167, 5, 'GE8', 'ETHICS', 3, '3rd Year', 'Second Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(168, 5, 'DM104', 'EVALUATION OF BUSINESS PERFORMANCE', 3, '3rd Year', 'Second Semester', 1, 'DM103', 'pending', '2025-11-25 16:01:16'),
(169, 5, 'QUAMET', 'QUANTITATIVE METHODS', 3, '3rd Year', 'Second Semester', 1, '3rd Year Standing', 'pending', '2025-11-25 16:01:16'),
(170, 5, 'ADV03', 'IT SECURITY AND MANAGEMENT', 3, '3rd Year', 'Second Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(171, 5, 'ADV04', 'SUPPLY CHAIN MANAGEMENT', 3, '3rd Year', 'Second Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(172, 5, 'CAP101', 'CAPSTONE PROJECT 1', 3, '3rd Year', 'Second Semester', 1, 'All major subjects below 3rd year Second Semester', 'pending', '2025-11-25 16:01:16'),
(173, 5, 'GEE 3', 'LIVING IN THE IT ERA', 3, '4th Year', 'First Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(174, 5, 'GE 7', 'SCIENCE, TECHNOLOGY, AND SOCIETY', 3, '4th Year', 'First Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(175, 5, 'GE 9', 'THE LIFE AND WORKS OF RIZAL', 3, '4th Year', 'First Semester', 1, NULL, 'pending', '2025-11-25 16:01:16'),
(176, 5, 'IS107', 'IS STRATEGY, MANAGEMENT AND AQUISITION', 3, '4th Year', 'First Semester', 1, '4TH YEAR', 'pending', '2025-11-25 16:01:16'),
(177, 5, 'CC106', 'APPLICATION DEVELOPMENT AND EMERGING TECHNOLOGIES', 3, '4th Year', 'First Semester', 1, '4TH YEAR', 'pending', '2025-11-25 16:01:16'),
(178, 5, 'CAP102', 'CAPSTONE PROJECT 2', 3, '4th Year', 'First Semester', 1, 'CAP101', 'pending', '2025-11-25 16:01:16'),
(179, 5, 'PRAC101', 'PRACTICUM (500 hours)', 6, '4th Year', 'Second Semester', 1, 'ALL MAJOR SUBJECTS', 'pending', '2025-11-25 16:01:16');

-- --------------------------------------------------------

--
-- Table structure for table `curriculum_submission_logs`
--

CREATE TABLE `curriculum_submission_logs` (
  `id` int(11) NOT NULL,
  `submission_id` int(11) NOT NULL,
  `action` varchar(50) NOT NULL COMMENT 'submitted, program_head_approved, dean_approved, admin_approved, rejected',
  `performed_by` int(11) NOT NULL,
  `role` varchar(50) NOT NULL COMMENT 'program_head, dean, admin',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `curriculum_submission_logs`
--

INSERT INTO `curriculum_submission_logs` (`id`, `submission_id`, `action`, `performed_by`, `role`, `notes`, `created_at`) VALUES
(1, 5, 'approve', 5, 'dean', '', '2025-11-25 16:02:05');

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
  `id_pictures` tinyint(1) DEFAULT 0 COMMENT 'Four (4) pieces of 2x2 colored ID pictures',
  `psa_birth_certificate` tinyint(1) DEFAULT 0 COMMENT 'PSA Birth Certificate (Original)',
  `barangay_certificate` tinyint(1) DEFAULT 0 COMMENT 'Barangay Certificate of Residency (Original)',
  `voters_id` tinyint(1) DEFAULT 0 COMMENT 'Voter''s ID or Registration Stub (Photocopy)',
  `high_school_diploma` tinyint(1) DEFAULT 0 COMMENT 'High School Diploma (Photocopy)',
  `sf10_form` tinyint(1) DEFAULT 0 COMMENT 'SF10 (Senior High School Student Permanent Record) - Original',
  `form_138` tinyint(1) DEFAULT 0 COMMENT 'Form 138 (Report Card) - Original',
  `good_moral` tinyint(1) DEFAULT 0 COMMENT 'Certificate of Good Moral Character - Original',
  `documents_submitted` tinyint(1) DEFAULT 0 COMMENT 'All documents in long brown envelope',
  `photocopies_submitted` tinyint(1) DEFAULT 0 COMMENT 'Photocopies in separate envelope',
  `notes` text DEFAULT NULL COMMENT 'Additional notes from admin',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `document_checklists`
--

INSERT INTO `document_checklists` (`id`, `user_id`, `id_pictures`, `psa_birth_certificate`, `barangay_certificate`, `voters_id`, `high_school_diploma`, `sf10_form`, `form_138`, `good_moral`, `documents_submitted`, `photocopies_submitted`, `notes`, `updated_at`, `created_at`) VALUES
(23, 49, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, '2025-12-01 09:51:27', '2025-12-01 09:51:27'),
(24, 51, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, '2025-12-01 09:55:57', '2025-12-01 09:55:57'),
(25, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, '2025-12-01 10:03:48', '2025-12-01 10:03:48'),
(26, 53, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, '2025-12-01 10:11:20', '2025-12-01 10:11:20'),
(27, 54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, '2025-12-01 10:21:18', '2025-12-01 10:21:18'),
(28, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, '2025-12-01 10:28:48', '2025-12-01 10:28:48'),
(29, 55, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, '2025-12-01 11:17:04', '2025-12-01 11:17:04'),
(30, 56, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, '2025-12-01 11:39:31', '2025-12-01 11:39:31');

-- --------------------------------------------------------

--
-- Table structure for table `document_rejection_history`
--

CREATE TABLE `document_rejection_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `document_type` varchar(100) NOT NULL,
  `rejection_reason` text NOT NULL,
  `rejected_by` int(11) NOT NULL,
  `rejected_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `resolved` tinyint(1) DEFAULT 0,
  `resolved_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `document_uploads`
--

CREATE TABLE `document_uploads` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `document_type` varchar(100) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `file_size` int(11) DEFAULT NULL,
  `upload_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `verification_status` enum('pending','verified','rejected') DEFAULT 'pending',
  `rejection_reason` text DEFAULT NULL,
  `verified_by` int(11) DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `document_uploads`
--

INSERT INTO `document_uploads` (`id`, `user_id`, `document_type`, `file_name`, `file_path`, `file_size`, `upload_date`, `verification_status`, `rejection_reason`, `verified_by`, `verified_at`) VALUES
(7, 51, 'id_pictures', 'id_pictures_1764585515.png', 'uploads/documents/51/id_pictures_1764585515.png', 1624299, '2025-12-01 10:38:35', 'pending', NULL, NULL, NULL),
(8, 51, 'psa_birth_certificate', 'psa_birth_certificate_1764585544.png', 'uploads/documents/51/psa_birth_certificate_1764585544.png', 1624299, '2025-12-01 10:39:04', 'pending', NULL, NULL, NULL),
(9, 51, 'barangay_certificate', 'barangay_certificate_1764585720.png', 'uploads/documents/51/barangay_certificate_1764585720.png', 1624299, '2025-12-01 10:42:00', 'pending', NULL, NULL, NULL);

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
  `enrollment_date` date DEFAULT NULL,
  `academic_year` varchar(20) DEFAULT NULL,
  `semester` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `date_of_birth` date DEFAULT NULL,
  `address` text DEFAULT NULL,
  `status` enum('active','inactive','pending') DEFAULT 'pending',
  `enrollment_status` enum('enrolled','pending') DEFAULT 'pending',
  `lrn` varchar(20) DEFAULT NULL COMMENT 'Learner Reference Number',
  `occ_examinee_number` varchar(50) DEFAULT NULL COMMENT 'OCC Examinee Number',
  `middle_name` varchar(50) DEFAULT NULL,
  `sex_at_birth` enum('Male','Female') DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `civil_status` enum('Single','Married','Widowed','Separated','Divorced') DEFAULT NULL,
  `spouse_name` varchar(100) DEFAULT NULL COMMENT 'Name of Spouse (if married)',
  `contact_number` varchar(20) DEFAULT NULL,
  `father_name` varchar(100) DEFAULT NULL,
  `father_occupation` varchar(100) DEFAULT NULL,
  `father_education` varchar(100) DEFAULT NULL COMMENT 'Father''s Highest Educational Attainment',
  `mother_maiden_name` varchar(100) DEFAULT NULL,
  `mother_occupation` varchar(100) DEFAULT NULL,
  `mother_education` varchar(100) DEFAULT NULL COMMENT 'Mother''s Highest Educational Attainment',
  `number_of_brothers` int(11) DEFAULT 0,
  `number_of_sisters` int(11) DEFAULT 0,
  `combined_family_income` varchar(50) DEFAULT NULL,
  `guardian_name` varchar(100) DEFAULT NULL COMMENT 'Name of Guardian (If Applicable)',
  `school_last_attended` varchar(150) DEFAULT NULL,
  `school_address` text DEFAULT NULL COMMENT 'Address of School Last Attended',
  `is_pwd` tinyint(1) DEFAULT 0 COMMENT 'Person with Disability',
  `hearing_disability` tinyint(1) DEFAULT 0,
  `physical_disability` tinyint(1) DEFAULT 0,
  `mental_disability` tinyint(1) DEFAULT 0,
  `intellectual_disability` tinyint(1) DEFAULT 0,
  `psychosocial_disability` tinyint(1) DEFAULT 0,
  `chronic_illness_disability` tinyint(1) DEFAULT 0,
  `learning_disability` tinyint(1) DEFAULT 0,
  `shs_track` varchar(100) DEFAULT NULL COMMENT 'Senior High School Track',
  `shs_strand` varchar(100) DEFAULT NULL COMMENT 'Senior High School Strand',
  `is_working_student` tinyint(1) DEFAULT 0,
  `employer` varchar(150) DEFAULT NULL,
  `work_position` varchar(100) DEFAULT NULL,
  `working_hours` varchar(50) DEFAULT NULL,
  `municipality_city` varchar(100) DEFAULT NULL,
  `permanent_address` text DEFAULT NULL COMMENT 'Permanent Address No. (Bldg Number, Lot No. Street)',
  `barangay` varchar(100) DEFAULT NULL,
  `preferred_program` varchar(150) DEFAULT NULL COMMENT 'Preferred degree/program course'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enrolled_students`
--

INSERT INTO `enrolled_students` (`id`, `user_id`, `first_name`, `last_name`, `email`, `phone`, `student_id`, `course`, `year_level`, `student_type`, `enrolled_date`, `enrollment_date`, `academic_year`, `semester`, `created_at`, `updated_at`, `date_of_birth`, `address`, `status`, `enrollment_status`, `lrn`, `occ_examinee_number`, `middle_name`, `sex_at_birth`, `age`, `civil_status`, `spouse_name`, `contact_number`, `father_name`, `father_occupation`, `father_education`, `mother_maiden_name`, `mother_occupation`, `mother_education`, `number_of_brothers`, `number_of_sisters`, `combined_family_income`, `guardian_name`, `school_last_attended`, `school_address`, `is_pwd`, `hearing_disability`, `physical_disability`, `mental_disability`, `intellectual_disability`, `psychosocial_disability`, `chronic_illness_disability`, `learning_disability`, `shs_track`, `shs_strand`, `is_working_student`, `employer`, `work_position`, `working_hours`, `municipality_city`, `permanent_address`, `barangay`, `preferred_program`) VALUES
(80, 49, 'hatdog', 'hatdog', 'hatdog@gmail.com', '', '2025-00001', 'BSIS', '1st Year', 'Regular', '2025-12-01 09:51:35', NULL, 'AY 2024-2025', 'First Semester', '2025-12-01 09:51:35', '2025-12-01 10:32:28', '2025-12-17', '', 'active', 'enrolled', '123123123123', '1231', '', 'Male', 23, 'Single', '', '', '', '', '', '', '', '', 0, 0, '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', '', '', '', '', 'Bachelor of Science in Information System'),
(81, 51, 'Reymond', 'Feca', 'A@gmail.com', '', '2025-00002', 'BSIS', '1st Year', 'Regular', '2025-12-01 10:09:26', NULL, 'AY 2024-2025', 'First Semester', '2025-12-01 10:09:26', '2025-12-01 10:42:21', '2025-12-03', '', 'active', 'enrolled', '323154051234', '2025 - 777', 'Lalice', 'Male', 25, '', '', '091234567890', 'Jyp Feca', 'Dancer', 'College', 'Jenny Feca', 'Dancer', 'College', 5, 1, '10,000', 'Black Pink in your areaaaaa', 'One cainta College', 'One Cainta College, H4H9+8QF, Cainta, 1900 Rizal', 0, 0, 0, 0, 0, 0, 0, 0, 'Technical-Vocational Livelihood Track', 'Information and Communication Technology (ICT) Strand', 1, 'Mr. Eugene Krabs', 'Chef', '7 am - 5 pm', 'Cainta', '831 Bottom Feeder Lane in Bikini Bottom', 'Sto. Domingo', 'Bachelor of Science in Information System'),
(82, 53, 'Sandy', 'Cheeks', 'C@gmail.com', '', '2025-00003', 'BSIS', '1st Year', 'Regular', '2025-12-01 10:16:58', NULL, 'AY 2024-2025', 'First Semester', '2025-12-01 10:16:58', '2025-12-01 10:17:48', '2025-12-16', '', 'active', 'enrolled', '123656479812', '2025 - 1112', 'Cheeks', 'Female', 25, 'Single', '', '0912355955', 'Pa Cheesk', 'Looking for Job', 'College', 'Ma Cheeks', 'Looking for Job', 'College', 2, 1, '15,000', 'Cheeks Guardian', 'One cainta College', 'One Cainta College, H4H9+8QF, Cainta, 1900 Rizal', 0, 0, 0, 0, 0, 0, 0, 0, 'Arts and Design Track', '', 1, 'Mr. Eugene Krabs', 'Chef', '10 AM - 2 PM', 'Binangonan', '831 Bottom Feeder Lane in Bikini Bottom', 'San Isidro', 'Bachelor in Technical Vocational Teacher Education'),
(83, 54, 'SpongeBob', 'SquarePants', 'D@gmail.com', '', '2025-00004', 'BSIS', '1st Year', 'Regular', '2025-12-01 10:21:55', NULL, 'AY 2024-2025', 'First Semester', '2025-12-01 10:21:55', '2025-12-01 10:23:33', '2025-12-26', '', 'active', 'enrolled', '182312391239', '2025 - 1223', 'Joy', 'Male', 25, 'Single', '', '1231283127', 'Harold SquarePants', 'Looking for Job', 'College', 'Margaret SquarePants', 'Looking for Job', 'college', 2, 1, '25,000', 'SquarePants', 'One cainta College', 'One Cainta College, H4H9+8QF, Cainta, 1900 Rizal', 0, 0, 0, 0, 0, 0, 0, 0, 'Technical-Vocational Livelihood Track', 'Information and Communication Technology (ICT) Strand', 1, 'Mr. Eugene Krabs', 'Chef', '7 am - 5 pm', 'Taytay', '831 Bottom Feeder Lane in Bikini Bottom', 'Sto. Domingo', 'Bachelor of Science in Information System'),
(84, 50, 'Enigma', 'Asterisk', 'something@yahoo.co', '', '2025-00006', 'BSIS', '1st Year', 'Regular', '2025-12-01 10:28:54', NULL, 'AY 2024-2025', 'First Semester', '2025-12-01 10:28:54', '2025-12-01 11:06:17', '1999-02-22', '', 'active', 'enrolled', '121222222222', '', 'Recon', 'Male', 18, 'Divorced', '', '09999999999', 'People Asterisk', 'Gamer', 'PUP Graduate', 'Shinobu Kobayashi', 'Ninja', 'Assassination Classroom Graduate', 2, 2, '50000 CAD', 'Guardian Angel', 'SKT T1 LoL School', 'Korea', 1, 0, 0, 0, 1, 0, 0, 0, 'Arts and Design Track', '', 1, 'Reddit Mod', 'Reddit Mod', '12AM - 11:59PM 24/7', 'Cainta', 'Sa Bahay', 'San Andres', 'Bachelor of Science in Information System'),
(85, 52, 'Patrick', 'Star', 'B@gmail.com', '', '2025-00005', 'BSIS', '1st Year', 'Regular', '2025-12-01 10:29:46', NULL, 'AY 2024-2025', 'First Semester', '2025-12-01 10:29:46', '2025-12-01 12:25:53', '2025-08-06', '', 'active', 'enrolled', '123456789101', '2025-111', 'Star', 'Male', 25, 'Single', '', '12345678912', 'Patwerk', 'Stone heads', 'College', 'Patricia', 'Stone stroke', 'College', 2, 3, '20,000', 'Star Guardian', 'One Cainta college', 'Bikini Bottom', 0, 0, 0, 0, 0, 0, 0, 0, 'Academic Track', '', 0, '', '', '', 'Morong', '831 bottom feeder lane in bikini bottom', 'San Isidro', 'Bachelor of Science in Entrepreneurship'),
(86, 55, 'Sheldon', 'Plankton', 'E@gmail.com', '', '2025-00007', 'BSIS', '1st Year', 'Regular', '2025-12-01 11:17:21', NULL, 'AY 2024-2025', 'First Semester', '2025-12-01 11:17:21', '2025-12-01 11:35:16', '2025-12-28', '', 'active', 'enrolled', '324324322632', '2025 - 666', 'J', 'Male', 25, 'Married', 'Karen', '0912355955', 'Papa Plankton', 'Looking for Job', 'College', 'Mama Plankton', 'Looking for Job', 'College', 2, 1, '25,000', 'Plankton Guardian', 'One cainta College', 'One Cainta College, H4H9+8QF, Cainta, 1900 Rizal', 0, 0, 0, 0, 0, 0, 0, 0, 'Technical-Vocational Livelihood Track', 'Information and Communication Technology (ICT) Strand', 1, 'Mr. Eugene Krabs', 'Chef', '7 am - 5 pm', 'Rodriguez', '831 Bottom Feeder Lane in Bikini Bottom', 'Sto. Domingo', 'Bachelor of Science in Information System');

-- --------------------------------------------------------

--
-- Table structure for table `enrollment_approvals`
--

CREATE TABLE `enrollment_approvals` (
  `id` int(11) NOT NULL,
  `enrollment_id` int(11) NOT NULL COMMENT 'References next_semester_enrollments.id',
  `approver_role` enum('program_head','registrar','admin') NOT NULL,
  `approver_id` int(11) NOT NULL COMMENT 'User ID of the approver',
  `action` enum('approved','rejected','modified') NOT NULL,
  `remarks` text DEFAULT NULL,
  `approved_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `enrollment_control`
--

CREATE TABLE `enrollment_control` (
  `id` int(11) NOT NULL,
  `academic_year` varchar(20) NOT NULL,
  `semester` varchar(50) NOT NULL,
  `enrollment_type` enum('regular','next_semester') DEFAULT 'regular',
  `enrollment_status` enum('open','closed') DEFAULT 'closed',
  `opening_date` date DEFAULT NULL,
  `closing_date` date DEFAULT NULL,
  `announcement` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL COMMENT 'Can be admin_id or admission_id',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enrollment_control`
--

INSERT INTO `enrollment_control` (`id`, `academic_year`, `semester`, `enrollment_type`, `enrollment_status`, `opening_date`, `closing_date`, `announcement`, `created_by`, `created_at`, `updated_at`) VALUES
(6, 'AY 2024-2025', 'First Semester', 'next_semester', 'open', '2025-12-01', '2025-12-02', '', 1, '2025-12-01 07:12:25', '2025-12-01 07:12:25');

-- --------------------------------------------------------

--
-- Table structure for table `enrollment_reports`
--

CREATE TABLE `enrollment_reports` (
  `id` int(11) NOT NULL,
  `report_title` varchar(255) NOT NULL,
  `report_type` varchar(50) NOT NULL COMMENT 'monthly, semester, annual, custom',
  `academic_year` varchar(20) DEFAULT NULL,
  `semester` varchar(50) DEFAULT NULL,
  `generated_by` int(11) NOT NULL COMMENT 'Admin who generated it',
  `report_data` longtext DEFAULT NULL COMMENT 'JSON data of the report',
  `total_enrollments` int(11) DEFAULT 0,
  `total_pending` int(11) DEFAULT 0,
  `total_approved` int(11) DEFAULT 0,
  `status` varchar(20) DEFAULT 'pending' COMMENT 'pending, reviewed, archived',
  `reviewed_by` int(11) DEFAULT NULL COMMENT 'Dean who reviewed',
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `program_code` varchar(20) DEFAULT NULL,
  `report_file` varchar(255) DEFAULT NULL,
  `dean_comment` text DEFAULT NULL,
  `generated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enrollment_reports`
--

INSERT INTO `enrollment_reports` (`id`, `report_title`, `report_type`, `academic_year`, `semester`, `generated_by`, `report_data`, `total_enrollments`, `total_pending`, `total_approved`, `status`, `reviewed_by`, `reviewed_at`, `notes`, `created_at`, `updated_at`, `program_code`, `report_file`, `dean_comment`, `generated_at`) VALUES
(4, 'Oh yeah', '', 'All Years', NULL, 1, '{\"text\":\"ENROLLMENT REPORT\\n=================\\n\\nGenerated: 2025-11-25 15:16:42\\nGenerated By: System Administrator\\nReport Title: Oh yeah\\n\\n\\nTotal Enrollments: 5\\n\\nPROGRAM DISTRIBUTION\\n====================\\nBTVTED: 3 (60%)\\nBSE: 2 (40%)\\n\\nYEAR LEVEL DISTRIBUTION\\n=======================\\n3rd Year: 2\\n2nd Year: 1\\n1st Year: 2\\n\\nENROLLMENT DETAILS\\n==================\\n\\n1. 2025-00011 - Dewey Mon\\n   Program: Bachelor in Technical Vocational Teacher Education\\n   Year Level: 3rd Year\\n   Section: BTVTED 1A - Morning\\n   Enrolled: Nov 25, 2025\\n\\n2. 2025-00010 - Corn Korn\\n   Program: Bachelor in Technical Vocational Teacher Education\\n   Year Level: 3rd Year\\n   Section: BTVTED 1A - Morning\\n   Enrolled: Nov 25, 2025\\n\\n3. 2025-00009 - Jude Cruz\\n   Program: Bachelor in Technical Vocational Teacher Education\\n   Year Level: 2nd Year\\n   Section: BTVTED 1A - Morning\\n   Enrolled: Nov 25, 2025\\n\\n4. 2025-00008 - Gerson Cruz\\n   Program: Bachelor of Science in Entrepreneurship\\n   Year Level: 1st Year\\n   Section: BSE 1A - Morning\\n   Enrolled: Nov 19, 2025\\n\\n5. 2025-00007 - John Montenegro\\n   Program: Bachelor of Science in Entrepreneurship\\n   Year Level: 1st Year\\n   Section: BSE 1A - Morning\\n   Enrolled: Nov 17, 2025\\n\\n\",\"analytics\":{\"total_enrollments\":5,\"program_distribution\":{\"BTVTED\":3,\"BSE\":2},\"year_level_distribution\":{\"3rd Year\":2,\"2nd Year\":1,\"1st Year\":2},\"student_type_distribution\":{\"Regular\":5},\"section_distribution\":{\"BTVTED 1A - Morning\":3,\"BSE 1A - Morning\":2},\"enrollment_by_date\":{\"2025-11-25\":3,\"2025-11-19\":1,\"2025-11-17\":1},\"program_stats\":[{\"program_code\":\"BTVTED\",\"count\":3,\"percentage\":60},{\"program_code\":\"BSE\",\"count\":2,\"percentage\":40}]},\"enrollments\":[{\"id\":\"70\",\"user_id\":\"34\",\"first_name\":\"Dewey\",\"last_name\":\"Mon\",\"email\":\"doo@gmail.com\",\"phone\":\"\",\"student_id\":\"2025-00011\",\"course\":\"BTVTED\",\"year_level\":\"3rd Year\",\"student_type\":\"Regular\",\"enrolled_date\":\"2025-11-25 15:07:40\",\"enrollment_date\":null,\"academic_year\":\"AY 2024-2025\",\"semester\":\"Second Semester\",\"created_at\":\"2025-11-25 15:07:40\",\"updated_at\":\"2025-11-25 15:47:18\",\"date_of_birth\":\"2025-11-24\",\"address\":\"\",\"status\":\"active\",\"enrollment_status\":\"pending\",\"lrn\":\"232352352352\",\"occ_examinee_number\":\"34\",\"middle_name\":\"M\",\"sex_at_birth\":\"Male\",\"age\":\"5\",\"civil_status\":\"Single\",\"spouse_name\":\"\",\"contact_number\":\"12341241\",\"father_name\":\"asdg\",\"father_occupation\":\"adsg\",\"father_education\":\"adgs\",\"mother_maiden_name\":\"adgs\",\"mother_occupation\":\"\",\"mother_education\":\"\",\"number_of_brothers\":\"0\",\"number_of_sisters\":\"0\",\"combined_family_income\":\"\",\"guardian_name\":\"\",\"school_last_attended\":\"\",\"school_address\":\"\",\"is_pwd\":\"0\",\"hearing_disability\":\"0\",\"physical_disability\":\"0\",\"mental_disability\":\"0\",\"intellectual_disability\":\"0\",\"psychosocial_disability\":\"0\",\"chronic_illness_disability\":\"0\",\"learning_disability\":\"0\",\"shs_track\":\"\",\"shs_strand\":\"\",\"is_working_student\":\"0\",\"employer\":\"\",\"work_position\":\"\",\"working_hours\":\"\",\"municipality_city\":\"\",\"permanent_address\":\"\",\"barangay\":\"\",\"preferred_program\":\"Bachelor in Technical Vocational Teacher Education\",\"program_name\":\"Bachelor in Technical Vocational Teacher Education\",\"program_code\":\"BTVTED\",\"section_name\":\"BTVTED 1A - Morning\"},{\"id\":\"69\",\"user_id\":\"33\",\"first_name\":\"Corn\",\"last_name\":\"Korn\",\"email\":\"corn@gmail.com\",\"phone\":\"\",\"student_id\":\"2025-00010\",\"course\":\"BTVTED\",\"year_level\":\"3rd Year\",\"student_type\":\"Regular\",\"enrolled_date\":\"2025-11-25 13:36:44\",\"enrollment_date\":null,\"academic_year\":\"AY 2024-2025\",\"semester\":\"Second Semester\",\"created_at\":\"2025-11-25 13:36:44\",\"updated_at\":\"2025-11-25 15:04:35\",\"date_of_birth\":\"2025-11-18\",\"address\":\"\",\"status\":\"active\",\"enrollment_status\":\"pending\",\"lrn\":\"234135135135\",\"occ_examinee_number\":\"3\",\"middle_name\":\"corn\",\"sex_at_birth\":\"Male\",\"age\":\"2\",\"civil_status\":\"Single\",\"spouse_name\":\"\",\"contact_number\":\"123\",\"father_name\":\"af\",\"father_occupation\":\"asdg\",\"father_education\":\"asdg\",\"mother_maiden_name\":\"dgsa\",\"mother_occupation\":\"asdg\",\"mother_education\":\"sdag\",\"number_of_brothers\":\"2\",\"number_of_sisters\":\"1\",\"combined_family_income\":\"24\",\"guardian_name\":\"\",\"school_last_attended\":\"\",\"school_address\":\"\",\"is_pwd\":\"0\",\"hearing_disability\":\"0\",\"physical_disability\":\"0\",\"mental_disability\":\"0\",\"intellectual_disability\":\"0\",\"psychosocial_disability\":\"0\",\"chronic_illness_disability\":\"0\",\"learning_disability\":\"0\",\"shs_track\":\"\",\"shs_strand\":\"\",\"is_working_student\":\"0\",\"employer\":\"\",\"work_position\":\"\",\"working_hours\":\"\",\"municipality_city\":\"Binangonan\",\"permanent_address\":\"\",\"barangay\":\"San Andres\",\"preferred_program\":\"Bachelor in Technical Vocational Teacher Education\",\"program_name\":\"Bachelor in Technical Vocational Teacher Education\",\"program_code\":\"BTVTED\",\"section_name\":\"BTVTED 1A - Morning\"},{\"id\":\"68\",\"user_id\":\"32\",\"first_name\":\"Jude\",\"last_name\":\"Cruz\",\"email\":\"judec@gmail.com\",\"phone\":\"\",\"student_id\":\"2025-00009\",\"course\":\"BTVTED\",\"year_level\":\"2nd Year\",\"student_type\":\"Regular\",\"enrolled_date\":\"2025-11-25 04:46:21\",\"enrollment_date\":null,\"academic_year\":\"AY 2024-2025\",\"semester\":\"First Semester\",\"created_at\":\"2025-11-25 04:46:21\",\"updated_at\":\"2025-11-25 05:03:38\",\"date_of_birth\":\"2025-11-18\",\"address\":\"\",\"status\":\"active\",\"enrollment_status\":\"enrolled\",\"lrn\":\"124153136631\",\"occ_examinee_number\":\"3\",\"middle_name\":\"\",\"sex_at_birth\":\"Male\",\"age\":\"2\",\"civil_status\":\"Single\",\"spouse_name\":\"\",\"contact_number\":\"09123124\",\"father_name\":\"mama\",\"father_occupation\":\"ASF\",\"father_education\":\"asd\",\"mother_maiden_name\":\"papa\",\"mother_occupation\":\"ad\",\"mother_education\":\"\",\"number_of_brothers\":\"1\",\"number_of_sisters\":\"0\",\"combined_family_income\":\"235235\",\"guardian_name\":\"sdg\",\"school_last_attended\":\"afdg\",\"school_address\":\"adfg\",\"is_pwd\":\"0\",\"hearing_disability\":\"0\",\"physical_disability\":\"0\",\"mental_disability\":\"0\",\"intellectual_disability\":\"0\",\"psychosocial_disability\":\"0\",\"chronic_illness_disability\":\"0\",\"learning_disability\":\"0\",\"shs_track\":\"\",\"shs_strand\":\"\",\"is_working_student\":\"0\",\"employer\":\"\",\"work_position\":\"\",\"working_hours\":\"\",\"municipality_city\":\"\",\"permanent_address\":\"\",\"barangay\":\"\",\"preferred_program\":\"Bachelor in Technical Vocational Teacher Education\",\"program_name\":\"Bachelor in Technical Vocational Teacher Education\",\"program_code\":\"BTVTED\",\"section_name\":\"BTVTED 1A - Morning\"},{\"id\":\"67\",\"user_id\":\"31\",\"first_name\":\"Gerson\",\"last_name\":\"Cruz\",\"email\":\"ger@gmail.com\",\"phone\":\"\",\"student_id\":\"2025-00008\",\"course\":\"BSE\",\"year_level\":\"1st Year\",\"student_type\":\"Regular\",\"enrolled_date\":\"2025-11-19 23:38:11\",\"enrollment_date\":null,\"academic_year\":\"AY 2024-2025\",\"semester\":\"First Semester\",\"created_at\":\"2025-11-19 23:38:11\",\"updated_at\":\"2025-11-19 23:38:11\",\"date_of_birth\":\"2025-11-18\",\"address\":\"\",\"status\":\"active\",\"enrollment_status\":\"pending\",\"lrn\":\"123123123124\",\"occ_examinee_number\":\"2\",\"middle_name\":\"S\",\"sex_at_birth\":\"Male\",\"age\":\"23\",\"civil_status\":\"Single\",\"spouse_name\":\"\",\"contact_number\":\"123124\",\"father_name\":\"asd\",\"father_occupation\":\"asdg\",\"father_education\":\"adsg\",\"mother_maiden_name\":\"asdg\",\"mother_occupation\":\"asdg\",\"mother_education\":\"asdg\",\"number_of_brothers\":\"3\",\"number_of_sisters\":\"1\",\"combined_family_income\":\"234234\",\"guardian_name\":\"asgasg\",\"school_last_attended\":\"adsg\",\"school_address\":\"adg\",\"is_pwd\":\"0\",\"hearing_disability\":\"0\",\"physical_disability\":\"0\",\"mental_disability\":\"0\",\"intellectual_disability\":\"0\",\"psychosocial_disability\":\"0\",\"chronic_illness_disability\":\"0\",\"learning_disability\":\"0\",\"shs_track\":\"\",\"shs_strand\":\"\",\"is_working_student\":\"0\",\"employer\":\"\",\"work_position\":\"\",\"working_hours\":\"\",\"municipality_city\":\"Cainta\",\"permanent_address\":\"asdg\",\"barangay\":\"San Andres\",\"preferred_program\":\"Bachelor of Science in Information System\",\"program_name\":\"Bachelor of Science in Entrepreneurship\",\"program_code\":\"BSE\",\"section_name\":\"BSE 1A - Morning\"},{\"id\":\"66\",\"user_id\":\"30\",\"first_name\":\"John\",\"last_name\":\"Montenegro\",\"email\":\"johnm@gmail.com\",\"phone\":\"\",\"student_id\":\"2025-00007\",\"course\":\"BSE\",\"year_level\":\"1st Year\",\"student_type\":\"Regular\",\"enrolled_date\":\"2025-11-17 11:49:13\",\"enrollment_date\":null,\"academic_year\":\"AY 2024-2025\",\"semester\":\"Second Semester\",\"created_at\":\"2025-11-17 11:49:13\",\"updated_at\":\"2025-11-18 12:37:00\",\"date_of_birth\":\"2025-11-05\",\"address\":\"\",\"status\":\"active\",\"enrollment_status\":\"enrolled\",\"lrn\":\"135\",\"occ_examinee_number\":\"124412\",\"middle_name\":\"M\",\"sex_at_birth\":\"Male\",\"age\":\"23\",\"civil_status\":\"Single\",\"spouse_name\":\"\",\"contact_number\":\"01923\",\"father_name\":\"mama\",\"father_occupation\":\"\",\"father_education\":\"\",\"mother_maiden_name\":\"\",\"mother_occupation\":\"\",\"mother_education\":\"\",\"number_of_brothers\":\"0\",\"number_of_sisters\":\"0\",\"combined_family_income\":\"\",\"guardian_name\":\"\",\"school_last_attended\":\"\",\"school_address\":\"\",\"is_pwd\":\"0\",\"hearing_disability\":\"0\",\"physical_disability\":\"0\",\"mental_disability\":\"0\",\"intellectual_disability\":\"0\",\"psychosocial_disability\":\"0\",\"chronic_illness_disability\":\"0\",\"learning_disability\":\"0\",\"shs_track\":\"Academic Track\",\"shs_strand\":\"\",\"is_working_student\":\"0\",\"employer\":\"\",\"work_position\":\"\",\"working_hours\":\"\",\"municipality_city\":\"\",\"permanent_address\":\"\",\"barangay\":\"\",\"preferred_program\":\"Bachelor of Science in Entrepreneurship\",\"program_name\":\"Bachelor of Science in Entrepreneurship\",\"program_code\":\"BSE\",\"section_name\":\"BSE 1A - Morning\"}],\"metadata\":{\"generated_at\":\"2025-11-25 15:16:42\",\"generated_by\":\"System Administrator\",\"report_title\":\"Oh yeah\",\"filters\":{\"program_code\":null,\"academic_year\":null,\"semester\":null}}}', 0, 0, 0, 'draft', NULL, NULL, NULL, '2025-11-25 14:16:42', '2025-11-25 14:16:42', NULL, NULL, NULL, '2025-11-25 14:16:42');

-- --------------------------------------------------------

--
-- Table structure for table `enrollment_schedules`
--

CREATE TABLE `enrollment_schedules` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `scheduled_date` date NOT NULL,
  `scheduled_time` time NOT NULL,
  `status` enum('scheduled','completed','cancelled','no_show') DEFAULT 'scheduled',
  `notes` text DEFAULT NULL,
  `scheduled_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `enrollment_verification`
--

CREATE TABLE `enrollment_verification` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pre_registration_completed` tinyint(1) DEFAULT 0,
  `admissions_visit_completed` tinyint(1) DEFAULT 0,
  `interview_completed` tinyint(1) DEFAULT 0,
  `academic_requirements_verified` tinyint(1) DEFAULT 0,
  `library_requirement_verified` tinyint(1) DEFAULT 0,
  `medical_assessment_verified` tinyint(1) DEFAULT 0,
  `section_assigned` tinyint(1) DEFAULT 0,
  `cor_ready` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grade_scale`
--

CREATE TABLE `grade_scale` (
  `id` int(11) NOT NULL,
  `grade_numeric` decimal(3,2) NOT NULL,
  `grade_letter` varchar(5) NOT NULL,
  `grade_description` varchar(50) NOT NULL,
  `is_passing` tinyint(1) DEFAULT 1,
  `equivalent_percentage_min` decimal(5,2) DEFAULT NULL,
  `equivalent_percentage_max` decimal(5,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `grade_scale`
--

INSERT INTO `grade_scale` (`id`, `grade_numeric`, `grade_letter`, `grade_description`, `is_passing`, `equivalent_percentage_min`, `equivalent_percentage_max`, `created_at`) VALUES
(1, 1.00, 'A', 'Excellent', 1, 97.00, 100.00, '2025-10-29 01:44:37'),
(2, 1.25, 'A-', 'Excellent', 1, 94.00, 96.99, '2025-10-29 01:44:37'),
(3, 1.50, 'B+', 'Very Good', 1, 91.00, 93.99, '2025-10-29 01:44:37'),
(4, 1.75, 'B', 'Very Good', 1, 88.00, 90.99, '2025-10-29 01:44:37'),
(5, 2.00, 'B-', 'Good', 1, 85.00, 87.99, '2025-10-29 01:44:37'),
(6, 2.25, 'C+', 'Good', 1, 82.00, 84.99, '2025-10-29 01:44:37'),
(7, 2.50, 'C', 'Satisfactory', 1, 79.00, 81.99, '2025-10-29 01:44:37'),
(8, 2.75, 'C-', 'Satisfactory', 1, 76.00, 78.99, '2025-10-29 01:44:37'),
(9, 3.00, 'D', 'Passing', 1, 75.00, 75.99, '2025-10-29 01:44:37'),
(10, 4.00, 'F', 'Failed', 0, 0.00, 74.99, '2025-10-29 01:44:37'),
(11, 5.00, 'INC', 'Incomplete', 0, NULL, NULL, '2025-10-29 01:44:37'),
(12, 0.00, 'W', 'Withdrawn', 0, NULL, NULL, '2025-10-29 01:44:37');

-- --------------------------------------------------------

--
-- Table structure for table `next_semester_enrollments`
--

CREATE TABLE `next_semester_enrollments` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `target_academic_year` varchar(20) NOT NULL,
  `target_semester` varchar(20) NOT NULL,
  `current_year_level` varchar(20) NOT NULL,
  `enrollment_type` enum('regular','irregular') DEFAULT 'regular',
  `selected_section_id` int(11) DEFAULT NULL,
  `preferred_schedule` varchar(50) DEFAULT NULL,
  `request_status` enum('draft','pending_program_head','pending_registrar','pending_admin','confirmed','rejected') DEFAULT 'draft',
  `grades_verified` tinyint(1) DEFAULT 0,
  `prerequisites_checked` tinyint(1) DEFAULT 0,
  `clearance_verified` tinyint(1) DEFAULT 0,
  `payment_verified` tinyint(1) DEFAULT 0,
  `schedule_generated` tinyint(1) DEFAULT 0,
  `cor_generated` tinyint(1) DEFAULT 0,
  `cor_generated_at` timestamp NULL DEFAULT NULL,
  `cor_generated_by` int(11) DEFAULT NULL,
  `enrollment_date` date DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `processed_by` int(11) DEFAULT NULL COMMENT 'Admin user ID',
  `processed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `next_semester_enrollments`
--

INSERT INTO `next_semester_enrollments` (`id`, `user_id`, `target_academic_year`, `target_semester`, `current_year_level`, `enrollment_type`, `selected_section_id`, `preferred_schedule`, `request_status`, `grades_verified`, `prerequisites_checked`, `clearance_verified`, `payment_verified`, `schedule_generated`, `cor_generated`, `cor_generated_at`, `cor_generated_by`, `enrollment_date`, `rejection_reason`, `processed_by`, `processed_at`, `created_at`, `updated_at`) VALUES
(48, 49, 'AY 2024-2025', 'Second Semester', '1st Year', 'irregular', 52, '', 'pending_registrar', 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-01 09:59:58', '2025-12-01 10:01:51'),
(49, 51, 'AY 2024-2025', 'Second Semester', '1st Year', 'irregular', 52, '', 'pending_registrar', 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-01 10:11:03', '2025-12-01 10:13:21'),
(50, 51, 'AY 2024-2025', 'First Semester', '1st Year', 'irregular', 55, 'Morning', 'pending_registrar', 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-01 10:37:27', '2025-12-01 10:41:48'),
(51, 50, 'AY 2024-2025', 'Second Semester', '1st Year', 'regular', 52, '', 'pending_registrar', 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-01 10:51:32', '2025-12-01 10:51:32'),
(52, 50, 'AY 2024-2025', 'First Semester', '1st Year', 'regular', 55, '', 'pending_registrar', 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-01 11:03:15', '2025-12-01 11:03:15'),
(53, 52, 'AY 2024-2025', 'Second Semester', '1st Year', 'irregular', 52, '', 'pending_registrar', 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-01 11:09:18', '2025-12-01 11:11:34'),
(54, 52, 'AY 2024-2025', 'First Semester', '1st Year', 'irregular', 55, '', 'pending_registrar', 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-01 11:16:55', '2025-12-01 12:08:50'),
(55, 55, 'AY 2024-2025', 'Second Semester', '1st Year', 'regular', 52, '', 'pending_registrar', 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-01 11:23:44', '2025-12-01 11:23:44'),
(56, 55, 'AY 2024-2025', 'First Semester', '1st Year', 'regular', 55, '', 'pending_registrar', 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-01 11:30:50', '2025-12-01 11:30:50');

-- --------------------------------------------------------

--
-- Table structure for table `next_semester_subject_selections`
--

CREATE TABLE `next_semester_subject_selections` (
  `id` int(11) NOT NULL,
  `enrollment_request_id` int(11) NOT NULL,
  `curriculum_id` int(11) NOT NULL COMMENT 'References curriculum table',
  `section_id` int(11) DEFAULT NULL,
  `prerequisite_met` tinyint(1) DEFAULT 0,
  `prerequisite_grade` decimal(3,2) DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `rejection_reason` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `next_semester_subject_selections`
--

INSERT INTO `next_semester_subject_selections` (`id`, `enrollment_request_id`, `curriculum_id`, `section_id`, `prerequisite_met`, `prerequisite_grade`, `status`, `rejection_reason`, `created_at`, `updated_at`) VALUES
(279, 49, 258, NULL, 0, NULL, 'approved', NULL, '2025-12-01 10:13:21', '2025-12-01 10:13:21'),
(280, 49, 259, NULL, 0, NULL, 'approved', NULL, '2025-12-01 10:13:21', '2025-12-01 10:13:21'),
(281, 49, 260, NULL, 0, NULL, 'approved', NULL, '2025-12-01 10:13:21', '2025-12-01 10:13:21'),
(282, 49, 262, NULL, 0, NULL, 'approved', NULL, '2025-12-01 10:13:21', '2025-12-01 10:13:21'),
(283, 49, 263, NULL, 0, NULL, 'approved', NULL, '2025-12-01 10:13:21', '2025-12-01 10:13:21'),
(288, 50, 265, NULL, 0, NULL, 'approved', NULL, '2025-12-01 10:41:48', '2025-12-01 10:41:48'),
(289, 50, 268, NULL, 0, NULL, 'approved', NULL, '2025-12-01 10:41:48', '2025-12-01 10:41:48'),
(290, 50, 269, NULL, 0, NULL, 'approved', NULL, '2025-12-01 10:41:48', '2025-12-01 10:41:48'),
(291, 50, 270, NULL, 0, NULL, 'approved', NULL, '2025-12-01 10:41:48', '2025-12-01 10:41:48'),
(292, 51, 257, NULL, 0, NULL, 'approved', NULL, '2025-12-01 10:52:40', '2025-12-01 10:52:40'),
(293, 51, 258, NULL, 0, NULL, 'approved', NULL, '2025-12-01 10:52:40', '2025-12-01 10:52:40'),
(294, 51, 259, NULL, 0, NULL, 'approved', NULL, '2025-12-01 10:52:40', '2025-12-01 10:52:40'),
(295, 51, 260, NULL, 0, NULL, 'approved', NULL, '2025-12-01 10:52:40', '2025-12-01 10:52:40'),
(296, 51, 261, NULL, 0, NULL, 'approved', NULL, '2025-12-01 10:52:40', '2025-12-01 10:52:40'),
(297, 51, 262, NULL, 0, NULL, 'approved', NULL, '2025-12-01 10:52:40', '2025-12-01 10:52:40'),
(298, 51, 263, NULL, 0, NULL, 'approved', NULL, '2025-12-01 10:52:40', '2025-12-01 10:52:40'),
(299, 52, 264, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:03:39', '2025-12-01 11:03:39'),
(300, 52, 265, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:03:39', '2025-12-01 11:03:39'),
(301, 52, 266, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:03:39', '2025-12-01 11:03:39'),
(302, 52, 267, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:03:39', '2025-12-01 11:03:39'),
(303, 52, 268, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:03:39', '2025-12-01 11:03:39'),
(304, 52, 269, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:03:39', '2025-12-01 11:03:39'),
(305, 52, 270, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:03:39', '2025-12-01 11:03:39'),
(311, 53, 258, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:11:34', '2025-12-01 11:11:34'),
(312, 53, 259, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:11:34', '2025-12-01 11:11:34'),
(313, 53, 260, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:11:34', '2025-12-01 11:11:34'),
(314, 53, 262, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:11:34', '2025-12-01 11:11:34'),
(315, 53, 263, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:11:34', '2025-12-01 11:11:34'),
(322, 56, 264, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:31:28', '2025-12-01 11:31:28'),
(323, 56, 265, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:31:28', '2025-12-01 11:31:28'),
(324, 56, 266, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:31:28', '2025-12-01 11:31:28'),
(325, 56, 267, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:31:28', '2025-12-01 11:31:28'),
(326, 56, 268, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:31:28', '2025-12-01 11:31:28'),
(327, 56, 269, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:31:28', '2025-12-01 11:31:28'),
(328, 56, 270, NULL, 0, NULL, 'approved', NULL, '2025-12-01 11:31:28', '2025-12-01 11:31:28'),
(329, 54, 250, NULL, 0, NULL, 'approved', NULL, '2025-12-01 12:08:50', '2025-12-01 12:08:50'),
(330, 54, 251, NULL, 0, NULL, 'approved', NULL, '2025-12-01 12:08:50', '2025-12-01 12:08:50'),
(331, 54, 265, NULL, 0, NULL, 'approved', NULL, '2025-12-01 12:08:50', '2025-12-01 12:08:50'),
(332, 54, 268, NULL, 0, NULL, 'approved', NULL, '2025-12-01 12:08:50', '2025-12-01 12:08:50'),
(333, 54, 269, NULL, 0, NULL, 'approved', NULL, '2025-12-01 12:08:50', '2025-12-01 12:08:50'),
(334, 54, 270, NULL, 0, NULL, 'approved', NULL, '2025-12-01 12:08:50', '2025-12-01 12:08:50');

-- --------------------------------------------------------

--
-- Table structure for table `pre_enrollment_forms`
--

CREATE TABLE `pre_enrollment_forms` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `enrollment_request_id` int(11) DEFAULT NULL COMMENT 'Links to next_semester_enrollments if exists',
  `last_name` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `middle_initial` varchar(10) DEFAULT NULL,
  `student_number` varchar(20) NOT NULL,
  `complete_address` text NOT NULL,
  `birth_date` date NOT NULL,
  `sex` enum('Male','Female') NOT NULL,
  `father_name` varchar(100) DEFAULT NULL,
  `mother_name` varchar(100) DEFAULT NULL,
  `is_4ps_beneficiary` tinyint(1) DEFAULT 0,
  `is_listahan_beneficiary` tinyint(1) DEFAULT 0,
  `is_pwd` tinyint(1) DEFAULT 0,
  `disability_type` varchar(200) DEFAULT NULL,
  `is_working_student` tinyint(1) DEFAULT 0,
  `company_name` varchar(150) DEFAULT NULL,
  `work_position` varchar(100) DEFAULT NULL,
  `current_course` enum('BSE','BSIS','BTVTEd') NOT NULL,
  `year_level` enum('1st Year','2nd Year','3rd Year','4th Year') NOT NULL,
  `preferred_shift` enum('Morning','Afternoon','Evening') NOT NULL,
  `form_status` enum('draft','submitted','approved','rejected') DEFAULT 'draft',
  `submitted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pre_enrollment_forms`
--

INSERT INTO `pre_enrollment_forms` (`id`, `user_id`, `enrollment_request_id`, `last_name`, `first_name`, `middle_initial`, `student_number`, `complete_address`, `birth_date`, `sex`, `father_name`, `mother_name`, `is_4ps_beneficiary`, `is_listahan_beneficiary`, `is_pwd`, `disability_type`, `is_working_student`, `company_name`, `work_position`, `current_course`, `year_level`, `preferred_shift`, `form_status`, `submitted_at`, `created_at`, `updated_at`) VALUES
(17, 49, 48, 'hatdog', 'hatdog', '', '2025-00001', 'cainta', '2025-12-17', 'Male', '', '', 0, 0, 0, NULL, 0, NULL, NULL, 'BSIS', '1st Year', 'Morning', 'submitted', '2025-12-01 09:59:55', '2025-12-01 09:59:55', '2025-12-01 09:59:58'),
(18, 51, 50, 'Feca', 'Reymond', 'L', '2025-00002', '831 Bottom Feeder Lane in Bikini Bottom, Sto. Domingo, Cainta', '2025-12-03', 'Male', 'Jyp Feca', 'Jenny Feca', 0, 0, 0, NULL, 1, 'Mr. Eugene Krabs', 'Chef', 'BSIS', '1st Year', 'Morning', 'submitted', '2025-12-01 10:11:01', '2025-12-01 10:11:01', '2025-12-01 10:37:27'),
(19, 50, 52, 'Asterisk', 'Enigma', 'R', '2025-00006', 'Sa Bahay, San Andres, Cainta', '1999-02-22', 'Male', 'People Asterisk', 'Shinobu Kobayashi', 0, 0, 1, 'Intellectual', 1, 'Reddit Mod', 'Reddit Mod', 'BSIS', '1st Year', 'Morning', 'submitted', '2025-12-01 10:51:25', '2025-12-01 10:51:25', '2025-12-01 11:03:15'),
(20, 52, 54, 'Star', 'Patrick', 'S', '2025-00005', '831 bottom feeder lane in bikini bottom, San Isidro, Morong', '2025-08-06', 'Male', 'Patwerk', 'Patricia', 0, 0, 0, NULL, 0, NULL, NULL, 'BSIS', '1st Year', 'Morning', 'submitted', '2025-12-01 11:09:16', '2025-12-01 11:09:16', '2025-12-01 11:16:55'),
(21, 55, 56, 'Plankton', 'Sheldon', 'J', '2025-00007', '831 Bottom Feeder Lane in Bikini Bottom, Sto. Domingo, Rodriguez', '2025-12-28', 'Male', 'Papa Plankton', 'Mama Plankton', 0, 0, 0, NULL, 1, 'Mr. Eugene Krabs', 'Chef', 'BSIS', '1st Year', 'Morning', 'submitted', '2025-12-01 11:23:26', '2025-12-01 11:23:26', '2025-12-01 11:30:50');

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
-- Table structure for table `program_heads`
--

CREATE TABLE `program_heads` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `program_id` int(11) NOT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `program_heads`
--

INSERT INTO `program_heads` (`id`, `username`, `email`, `password`, `first_name`, `last_name`, `program_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'bse_head', 'bse.head@occ.edu', '$2y$10$ISg88lWf1eZWrRCFbKZGE.LH4SXcnP40KYWU1tPHkaimPt.WGtT2q', 'Maria', 'Santos', 1, 'active', '2025-11-11 10:20:51', '2025-11-11 10:30:24'),
(2, 'btvted_head', 'btvted.head@occ.edu', '$2y$10$ISg88lWf1eZWrRCFbKZGE.LH4SXcnP40KYWU1tPHkaimPt.WGtT2q', 'Juan', 'Dela Cruz', 2, 'active', '2025-11-11 10:20:51', '2025-11-11 10:30:24'),
(3, 'bsis_head', 'bsis.head@occ.edu', '$2y$10$ISg88lWf1eZWrRCFbKZGE.LH4SXcnP40KYWU1tPHkaimPt.WGtT2q', 'Ana', 'Reyes', 3, 'active', '2025-11-11 10:20:51', '2025-11-11 10:30:24');

-- --------------------------------------------------------

--
-- Table structure for table `registrar_staff`
--

CREATE TABLE `registrar_staff` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `staff_id` varchar(50) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `registrar_staff`
--

INSERT INTO `registrar_staff` (`id`, `username`, `email`, `password`, `first_name`, `last_name`, `staff_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'registrar', 'registrar@occ.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Registrar', 'Staff', 'REG001', 'active', '2025-11-14 10:41:06', '2025-11-14 10:41:06');

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
(1, 1, '1st Year', 'First Semester', 'BSE 1A - Morning', 'Morning', 50, 7, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-12-01 10:29:53'),
(2, 1, '1st Year', 'First Semester', 'BSE 1B - Afternoon', 'Afternoon', 50, 1, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-11-05 11:32:12'),
(3, 1, '1st Year', 'First Semester', 'BSE 1C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-11-05 09:37:48'),
(4, 1, '1st Year', 'Second Semester', 'BSE 1A - Morning', 'Morning', 50, 5, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-11-17 14:32:40'),
(5, 1, '1st Year', 'Second Semester', 'BSE 1B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(6, 1, '1st Year', 'Second Semester', 'BSE 1C - Evening', 'Evening', 50, 1, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-11-05 11:41:29'),
(7, 1, '2nd Year', 'First Semester', 'BSE 2A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(8, 1, '2nd Year', 'First Semester', 'BSE 2B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-11-05 09:38:15'),
(9, 1, '2nd Year', 'First Semester', 'BSE 2C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(10, 1, '2nd Year', 'Second Semester', 'BSE 2A - Morning', 'Morning', 50, 1, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-29 01:10:12'),
(11, 1, '2nd Year', 'Second Semester', 'BSE 2B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(12, 1, '2nd Year', 'Second Semester', 'BSE 2C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(13, 1, '3rd Year', 'First Semester', 'BSE 3A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(14, 1, '3rd Year', 'First Semester', 'BSE 3B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(15, 1, '3rd Year', 'First Semester', 'BSE 3C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(16, 1, '3rd Year', 'Second Semester', 'BSE 3A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(17, 1, '3rd Year', 'Second Semester', 'BSE 3B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(18, 1, '3rd Year', 'Second Semester', 'BSE 3C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(19, 1, '4th Year', 'First Semester', 'BSE 4A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-29 02:35:11'),
(20, 1, '4th Year', 'First Semester', 'BSE 4B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(21, 1, '4th Year', 'First Semester', 'BSE 4C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(22, 1, '4th Year', 'Second Semester', 'BSE 4A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(23, 1, '4th Year', 'Second Semester', 'BSE 4B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(24, 1, '4th Year', 'Second Semester', 'BSE 4C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(25, 2, '1st Year', 'First Semester', 'BTVTED 1A - Morning', 'Morning', 50, 8, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-11-25 07:07:40'),
(26, 2, '1st Year', 'First Semester', 'BTVTED 1B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(27, 2, '1st Year', 'First Semester', 'BTVTED 1C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(28, 2, '1st Year', 'Second Semester', 'BTVTED 1A - Morning', 'Morning', 50, 4, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-11-25 07:12:32'),
(29, 2, '1st Year', 'Second Semester', 'BTVTED 1B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(30, 2, '1st Year', 'Second Semester', 'BTVTED 1C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(31, 2, '2nd Year', 'First Semester', 'BTVTED 2A - Morning', 'Morning', 50, 3, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-11-25 07:15:11'),
(32, 2, '2nd Year', 'First Semester', 'BTVTED 2B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(33, 2, '2nd Year', 'First Semester', 'BTVTED 2C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(34, 2, '2nd Year', 'Second Semester', 'BTVTED 2A - Morning', 'Morning', 50, 2, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-11-25 07:31:34'),
(35, 2, '2nd Year', 'Second Semester', 'BTVTED 2B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(36, 2, '2nd Year', 'Second Semester', 'BTVTED 2C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-11-14 07:20:37'),
(37, 2, '3rd Year', 'First Semester', 'BTVTED 3A - Morning', 'Morning', 50, 2, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-11-25 07:45:09'),
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
(49, 3, '1st Year', 'First Semester', 'BSIS 1A - Morning', 'Morning', 50, 19, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-12-01 11:17:21'),
(50, 3, '1st Year', 'First Semester', 'BSIS 1B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(51, 3, '1st Year', 'First Semester', 'BSIS 1C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(52, 3, '1st Year', 'Second Semester', 'BSIS 1A - Morning', 'Morning', 50, 11, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-12-01 11:25:35'),
(53, 3, '1st Year', 'Second Semester', 'BSIS 1B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(54, 3, '1st Year', 'Second Semester', 'BSIS 1C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(55, 3, '2nd Year', 'First Semester', 'BSIS 2A - Morning', 'Morning', 50, 8, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-12-01 12:08:50'),
(56, 3, '2nd Year', 'First Semester', 'BSIS 2B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(57, 3, '2nd Year', 'First Semester', 'BSIS 2C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(58, 3, '2nd Year', 'Second Semester', 'BSIS 2A - Morning', 'Morning', 50, 2, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-11-30 14:28:38'),
(59, 3, '2nd Year', 'Second Semester', 'BSIS 2B - Afternoon', 'Afternoon', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(60, 3, '2nd Year', 'Second Semester', 'BSIS 2C - Evening', 'Evening', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-10-07 13:25:17'),
(61, 3, '3rd Year', 'First Semester', 'BSIS 3A - Morning', 'Morning', 50, 0, 'AY 2024-2025', 'active', '2025-10-07 13:25:17', '2025-12-01 11:05:29'),
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
(114, 49, 49, '2025-12-01 09:51:35', 'active', '2025-12-01 09:51:35', '2025-12-01 09:51:35'),
(116, 52, 49, '2025-12-01 10:01:51', 'active', '2025-12-01 10:01:51', '2025-12-01 10:01:51'),
(117, 49, 51, '2025-12-01 10:09:26', 'active', '2025-12-01 10:09:26', '2025-12-01 10:09:26'),
(119, 52, 51, '2025-12-01 10:13:21', 'active', '2025-12-01 10:13:21', '2025-12-01 10:13:21'),
(120, 49, 53, '2025-12-01 10:16:58', 'active', '2025-12-01 10:16:58', '2025-12-01 10:16:58'),
(121, 49, 54, '2025-12-01 10:21:55', 'active', '2025-12-01 10:21:55', '2025-12-01 10:21:55'),
(122, 49, 50, '2025-12-01 10:28:54', 'active', '2025-12-01 10:28:54', '2025-12-01 10:28:54'),
(123, 1, 52, '2025-12-01 10:29:46', 'dropped', '2025-12-01 10:29:46', '2025-12-01 10:29:53'),
(124, 49, 52, '2025-12-01 10:40:49', 'active', '2025-12-01 10:29:59', '2025-12-01 10:40:49'),
(125, 55, 51, '2025-12-01 10:41:48', 'active', '2025-12-01 10:41:48', '2025-12-01 10:41:48'),
(127, 52, 50, '2025-12-01 10:55:18', 'active', '2025-12-01 10:55:18', '2025-12-01 10:55:18'),
(128, 61, 50, '2025-12-01 11:04:57', 'dropped', '2025-12-01 11:04:57', '2025-12-01 11:05:29'),
(129, 55, 50, '2025-12-01 11:05:37', 'active', '2025-12-01 11:05:37', '2025-12-01 11:05:37'),
(131, 52, 52, '2025-12-01 11:11:34', 'active', '2025-12-01 11:11:34', '2025-12-01 11:11:34'),
(132, 49, 55, '2025-12-01 11:17:21', 'active', '2025-12-01 11:17:21', '2025-12-01 11:17:21'),
(134, 52, 55, '2025-12-01 11:25:35', 'active', '2025-12-01 11:25:35', '2025-12-01 11:25:35'),
(135, 55, 55, '2025-12-01 11:31:57', 'active', '2025-12-01 11:31:57', '2025-12-01 11:31:57'),
(136, 55, 52, '2025-12-01 12:08:50', 'active', '2025-12-01 12:08:50', '2025-12-01 12:08:50');

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
(13, 25, 211, 'GE-100', 'Understanding the Self', 3, 0, 1, 0, 0, 0, 0, 0, '02:32', '02:34', '2', 'Ralph Cruz', 'RC', '2025-11-14 18:07:21', '2025-11-14 18:07:21'),
(14, 1, 185, 'BSE-C101', 'Entrepreneurship Behavior', 3, 0, 0, 1, 0, 0, 0, 0, '14:32', '14:32', '22', 'Armado Mone', 'AM', '2025-11-16 14:28:16', '2025-11-16 14:28:16'),
(15, 1, 186, 'GE-100', 'Understanding the Self', 3, 0, 1, 0, 0, 0, 0, 0, '02:32', '12:31', '', '', '', '2025-11-16 14:54:04', '2025-11-16 14:54:04'),
(16, 1, 187, 'GE-101', 'Reading in Philippine History', 3, 0, 0, 0, 0, 0, 1, 0, '02:46', '08:34', '', '', '', '2025-11-16 14:54:20', '2025-11-16 14:54:20'),
(17, 1, 188, 'GE-107', 'The Contemporary World', 3, 0, 0, 0, 1, 0, 0, 0, '03:04', '15:03', '', '', '', '2025-11-16 14:54:38', '2025-11-16 14:54:38'),
(18, 1, 189, 'NSTP1', 'National Service Training Program 1', 3, 0, 0, 0, 0, 0, 0, 1, '05:55', '17:55', '', '', '', '2025-11-16 14:55:05', '2025-11-16 14:55:05'),
(19, 1, 190, 'PE1', 'Physical Fitness/Self-Testing Activities', 2, 0, 0, 0, 0, 0, 1, 0, '05:12', '17:13', '', '', '', '2025-11-16 14:55:20', '2025-11-16 14:55:20'),
(20, 4, 191, 'BSE-C102', 'Microeconomics', 3, 0, 1, 0, 0, 0, 0, 0, '02:03', '14:04', '2', '2', '2', '2025-11-18 04:38:08', '2025-11-18 04:38:08'),
(21, 4, 194, 'GE-102', 'Art Appreciation', 3, 0, 1, 0, 0, 0, 0, 0, '03:45', '07:06', '3', '', 'JB', '2025-11-24 20:14:46', '2025-11-24 20:14:46'),
(22, 4, 193, 'GE-103', 'Purposive Communication', 3, 0, 0, 1, 0, 0, 0, 0, '05:55', '05:05', '3', '', '', '2025-11-24 20:15:10', '2025-11-24 20:15:10'),
(23, 4, 192, 'GE-104', 'Mathematics in the Modern World', 3, 0, 0, 0, 0, 1, 0, 0, '03:43', '05:06', '3', '', '', '2025-11-24 20:15:36', '2025-11-24 20:15:36'),
(24, 4, 195, 'NSTP2', 'National Service Training Program 2', 3, 0, 0, 0, 1, 0, 0, 0, '05:05', '17:06', '', '', '', '2025-11-24 20:15:50', '2025-11-24 20:15:50'),
(25, 4, 196, 'PE2', 'Rhythmic Activities', 2, 0, 0, 0, 0, 0, 0, 0, '03:53', '05:56', '', '', '', '2025-11-24 20:16:01', '2025-11-24 20:16:01'),
(26, 7, 201, 'BSE-C100', 'Entrepreneurial Leadership in an Organization', 3, 1, 0, 0, 0, 0, 0, 0, '05:06', '07:07', '', '', '', '2025-11-24 20:27:26', '2025-11-24 20:27:26'),
(27, 7, 197, 'BSE-C103', 'Opportunity Seeking', 3, 0, 1, 0, 0, 0, 0, 0, '14:36', '14:36', '', '', '', '2025-11-24 20:27:54', '2025-11-24 20:27:54'),
(28, 7, 200, 'GE-106', 'Rizal\'s Life and Works', 3, 0, 0, 0, 1, 0, 0, 0, '14:36', '15:26', '', '', '', '2025-11-24 20:28:01', '2025-11-24 20:28:01'),
(29, 7, 199, 'GE-111', 'Ethics', 3, 0, 0, 0, 0, 0, 1, 0, '14:36', '14:36', '', '', '', '2025-11-24 20:28:10', '2025-11-24 20:28:10'),
(30, 7, 202, 'PE3', 'Individual/Dual Combative Sports', 2, 0, 0, 0, 0, 0, 1, 0, '14:36', '14:36', '', '', '', '2025-11-24 20:28:17', '2025-11-24 20:28:17'),
(31, 10, 203, 'BSE-C104', 'Market Research and Consumer Behavior', 3, 0, 0, 0, 0, 0, 1, 0, '01:06', '01:06', '', '', '', '2025-11-24 20:29:01', '2025-11-24 20:29:01'),
(32, 10, 204, 'BSE-C105', 'Innovation Management', 3, 0, 0, 0, 0, 1, 0, 0, '01:06', '01:06', '', '', '', '2025-11-24 20:29:08', '2025-11-24 20:29:08'),
(33, 10, 205, 'BSE-C106', 'Pricing and Costing', 3, 0, 1, 0, 0, 0, 0, 0, '01:06', '01:06', '', '', '', '2025-11-24 20:29:13', '2025-11-24 20:29:13'),
(34, 10, 206, 'BSE-C107', 'Human Resources Management', 3, 0, 0, 0, 0, 0, 1, 0, '13:06', '01:06', '', '', '', '2025-11-24 20:29:22', '2025-11-24 20:29:22'),
(35, 10, 208, 'BSE-GC102', 'Social Science and Philosophy', 3, 0, 0, 0, 0, 0, 1, 0, '04:06', '02:06', '', '', '', '2025-11-24 20:29:29', '2025-11-24 20:29:29'),
(36, 10, 209, 'BSE-OCC100', 'Living in the IT Era', 3, 0, 0, 0, 0, 0, 0, 1, '02:06', '02:06', '', '', '', '2025-11-24 20:29:37', '2025-11-24 20:29:37'),
(37, 10, 210, 'PE4', 'Team Sports', 2, 0, 0, 0, 0, 0, 1, 0, '02:07', '02:07', '', '', '', '2025-11-24 20:29:44', '2025-11-24 20:29:44'),
(38, 25, 212, 'GE-101', 'Reading in Philippine History', 3, 0, 0, 1, 0, 0, 0, 0, '13:05', '15:03', '', '', '', '2025-11-24 20:32:02', '2025-11-24 20:32:02'),
(39, 25, 213, 'GE-102', 'Art Appreciation', 3, 0, 0, 0, 1, 0, 0, 0, '04:06', '02:06', '', '', '', '2025-11-24 20:32:08', '2025-11-24 20:32:08'),
(40, 25, 214, 'GE-103', 'Purposive Communication', 3, 0, 0, 0, 0, 0, 1, 0, '14:06', '04:06', '', '', '', '2025-11-24 20:32:16', '2025-11-24 20:32:16'),
(41, 25, 215, 'GE-104', 'Mathematics in the Modern World', 3, 0, 1, 0, 0, 0, 0, 0, '02:06', '02:06', '', '', '', '2025-11-24 20:32:22', '2025-11-24 20:32:22'),
(42, 25, 217, 'NSTP1', 'National Service Training Program 1', 3, 0, 0, 0, 0, 1, 0, 0, '02:06', '16:41', '', '', '', '2025-11-24 20:32:29', '2025-11-24 20:32:29'),
(43, 25, 216, 'PE1', 'Physical Fitness/Self-Testing Activities', 2, 0, 0, 0, 0, 0, 0, 1, '02:06', '02:06', '', '', '', '2025-11-24 20:32:37', '2025-11-24 20:32:37'),
(44, 28, 220, 'EDUC-100', 'The Teaching Profession', 3, 0, 1, 0, 0, 0, 0, 0, '02:06', '02:06', '', '', '', '2025-11-24 20:32:50', '2025-11-24 20:32:50'),
(45, 28, 221, 'EDUC-101', 'The Child and Adolescent Learner and Learning Principles', 3, 1, 0, 0, 0, 0, 0, 0, '03:57', '06:08', '', '', '', '2025-11-24 20:32:59', '2025-11-24 20:32:59'),
(46, 28, 218, 'GE-107', 'The Contemporary World', 3, 0, 0, 0, 1, 0, 0, 0, '16:07', '16:36', '', '', '', '2025-11-24 20:33:11', '2025-11-24 20:33:11'),
(47, 28, 219, 'GE-111', 'Ethics', 3, 0, 0, 0, 0, 1, 0, 0, '14:35', '14:35', '', '', '', '2025-11-24 20:33:18', '2025-11-24 20:33:18'),
(48, 28, 223, 'NSTP2', 'National Service Training Program 2', 3, 0, 0, 0, 0, 0, 1, 0, '12:31', '12:41', '', '', '', '2025-11-24 20:33:25', '2025-11-24 20:33:25'),
(49, 28, 222, 'PE2', 'Rhythmic Activities', 2, 0, 1, 0, 0, 0, 0, 0, '12:41', '18:45', '', '', '', '2025-11-24 20:33:32', '2025-11-24 20:33:32'),
(50, 31, 229, 'BTVD-T101', 'Introduction to Agri-Fishery and Arts', 3, 0, 1, 0, 0, 0, 0, 0, '13:51', '13:51', '', '', '', '2025-11-24 20:34:01', '2025-11-24 20:34:01'),
(51, 31, 230, 'BTVD100', 'Computer System Servicing 1 - Computer Hardware Installation and Maintenance', 3, 1, 0, 0, 0, 0, 0, 0, '01:51', '13:51', '', '', '', '2025-11-24 20:34:06', '2025-11-24 20:34:06'),
(52, 31, 224, 'EDUC-102', 'Facilitating Learner-Centered Teaching: The Learner-Centered Approach with Emphasis on Trainers Methodology 1', 3, 0, 0, 0, 1, 0, 0, 0, '01:51', '13:51', '', '', '', '2025-11-24 20:34:13', '2025-11-24 20:34:13'),
(53, 31, 225, 'EDUC-103', 'Technology for Teaching and Learning 1', 3, 0, 0, 0, 0, 0, 1, 0, '01:51', '13:51', '', '', '', '2025-11-24 20:34:19', '2025-11-24 20:34:19'),
(54, 31, 226, 'EDUC-104', 'Building and Enhancing Literacy Across the Curriculum with Emphasis on the 21st Century Skills', 3, 0, 1, 0, 0, 0, 0, 0, '13:51', '06:13', '', '', '', '2025-11-24 20:34:26', '2025-11-24 20:34:26'),
(55, 31, 227, 'EDUC-105', 'Andragogy of Learning including Principles of Trainers Methodology', 3, 0, 0, 0, 0, 1, 0, 0, '03:46', '03:46', '', '', '', '2025-11-24 20:34:33', '2025-11-24 20:34:33'),
(56, 31, 228, 'EDUC-106', 'Assessment in Learning 1', 3, 0, 0, 0, 0, 0, 0, 1, '12:41', '06:43', '', '', '', '2025-11-24 20:34:41', '2025-11-24 20:34:41'),
(57, 31, 231, 'PE3', 'Individual/Dual Combative Sports', 2, 0, 1, 0, 0, 0, 0, 0, '14:46', '13:51', '', '', '', '2025-11-24 20:34:48', '2025-11-24 20:34:48'),
(58, 34, 235, 'BTVE-101', 'Computer System Servicing 2 - Computer System Installation and Configuration', 3, 0, 1, 0, 0, 0, 0, 0, '13:51', '18:53', '', '', '', '2025-11-24 20:35:32', '2025-11-24 20:35:32'),
(59, 34, 232, 'EDUC-109', 'Curriculum Development and Evaluation with Emphasis on Trainers Methodology II', 3, 0, 0, 0, 0, 1, 0, 0, '14:46', '14:46', '', '', '', '2025-11-24 20:35:39', '2025-11-24 20:35:39'),
(60, 34, 233, 'EDUC-110', 'Foundation of Special and Inclusive Education (Mandated)', 3, 0, 0, 0, 0, 0, 0, 1, '18:24', '14:46', '', '', '', '2025-11-24 20:35:47', '2025-11-24 20:35:47'),
(61, 34, 234, 'EDUC-111', 'Assessment in Learning 2 with focus on Trainers Methodology 1 & 2', 3, 0, 1, 0, 0, 0, 0, 0, '14:46', '07:56', '', '', '', '2025-11-24 20:35:54', '2025-11-24 20:35:54'),
(62, 34, 236, 'PE4', 'Team Sports', 2, 0, 1, 0, 0, 0, 0, 0, '14:35', '14:35', '', '', '', '2025-11-24 20:36:02', '2025-11-24 20:36:02'),
(63, 37, 239, 'BTVE 102', 'Visual Graphics Design 1 - Web Site Development and Digital Media Design - Print Media', 3, 0, 0, 1, 0, 0, 0, 0, '12:04', '14:41', '', '', '', '2025-11-25 06:50:40', '2025-11-25 06:50:40'),
(64, 37, 240, 'BTVE 103', 'Visual Graphics Design 2 - Web Site Development and Digital Media Design - Video Production', 3, 1, 0, 0, 0, 0, 0, 0, '12:41', '12:41', '', '', '', '2025-11-25 06:50:46', '2025-11-25 06:50:46'),
(65, 37, 241, 'BTVE 104', 'Visual Graphics Design 3 - Web Site Development and Digital Media Design - Audio Production', 3, 0, 0, 1, 0, 0, 0, 0, '12:41', '12:41', '', '', '', '2025-11-25 06:50:54', '2025-11-25 06:50:54'),
(66, 37, 243, 'BTVE-106', 'Programming 1 - Program Logic Formulation', 3, 0, 0, 0, 1, 0, 0, 0, '12:41', '12:41', '', '', '', '2025-11-25 06:51:01', '2025-11-25 06:51:01'),
(67, 37, 242, 'BTVE-107', 'Computer Systems Servicing 3 - Computer System Servicing - Network Installation and Maintenance', 3, 0, 0, 0, 0, 0, 1, 0, '05:12', '16:16', '', '', '', '2025-11-25 06:51:08', '2025-11-25 06:51:08'),
(68, 37, 237, 'EDUC 112', 'Technology Research 1: Methods of Research', 3, 0, 0, 0, 0, 0, 1, 0, '14:35', '14:35', '', '', '', '2025-11-25 06:51:15', '2025-11-25 06:51:15'),
(69, 37, 238, 'TLE 1-5', 'Teaching Common Competencies in ICT', 3, 0, 0, 0, 0, 1, 0, 0, '14:35', '14:35', '', '', '', '2025-11-25 06:51:22', '2025-11-25 06:51:22'),
(70, 49, 250, 'CC101', 'INTRODUCTION TO COMPUTING', 3, 0, 1, 0, 0, 0, 0, 0, '03:43', '16:34', '', '', '', '2025-11-25 16:16:34', '2025-11-25 16:16:34'),
(71, 49, 251, 'CC102', 'COMPUTER PROGRAMMING 1', 3, 0, 0, 0, 1, 0, 0, 0, '04:31', '04:21', '', '', '', '2025-11-25 16:16:49', '2025-11-25 16:16:49'),
(72, 49, 252, 'GE1', 'UNDERSTANDING THE SELF', 3, 0, 0, 0, 1, 0, 0, 0, '16:21', '12:41', '', '', '', '2025-11-25 16:17:03', '2025-11-25 16:17:03'),
(73, 49, 253, 'GE2', 'READING IN PHILIPPINE HISTORY', 3, 0, 0, 0, 0, 1, 0, 0, '12:31', '12:41', '', '', '', '2025-11-25 16:17:19', '2025-11-25 16:17:19'),
(74, 49, 254, 'GE3', 'THE CONTEMPORARY WORLD', 3, 0, 0, 0, 0, 0, 0, 1, '13:41', '13:41', '', '', '', '2025-11-25 16:18:02', '2025-11-25 16:18:02'),
(75, 49, 255, 'NSTP 1', 'CWTS/ROTC1', 3, 0, 1, 0, 0, 0, 0, 0, '12:51', '13:51', '', '', '', '2025-11-25 16:18:09', '2025-11-25 16:18:09'),
(76, 49, 256, 'PE 1', 'PHYSYCAL FITNESS / SELF-TESTING ACTIVITIES', 3, 0, 0, 0, 0, 0, 0, 1, '13:51', '03:16', '', '', '', '2025-11-25 16:18:17', '2025-11-25 16:18:17'),
(77, 52, 257, 'CC103', 'COMPUTER PROGRAMMING 2', 3, 0, 1, 0, 0, 0, 0, 0, '12:51', '12:51', '', '', '', '2025-11-25 16:18:43', '2025-11-25 16:18:43'),
(78, 52, 258, 'GE4', 'MATHEMATICS IN THE MODERN WORLD', 3, 0, 0, 0, 0, 1, 0, 0, '00:41', '01:06', '', '', '', '2025-11-25 16:18:50', '2025-11-25 16:18:50'),
(79, 52, 259, 'GE5', 'PURPOSIVE COMMUNICATION', 3, 0, 1, 0, 0, 0, 0, 0, '00:51', '03:13', '', '', '', '2025-11-25 16:18:58', '2025-11-25 16:18:58'),
(80, 52, 260, 'GE6', 'ART APPRECIATION', 3, 0, 0, 0, 0, 1, 0, 0, '12:51', '12:51', '', '', '', '2025-11-25 16:19:05', '2025-11-25 16:19:05'),
(81, 52, 261, 'IS101', 'FUNDAMENTALS OF INFORMATION SYSTEMS', 3, 0, 1, 0, 0, 0, 0, 0, '01:51', '13:51', '', '', '', '2025-11-25 16:19:11', '2025-11-25 16:19:11'),
(82, 52, 262, 'NSTP 2', 'CWTS/ROTC2', 3, 0, 0, 0, 0, 0, 0, 1, '13:51', '17:09', '', '', '', '2025-11-25 16:19:20', '2025-11-25 16:19:20'),
(83, 52, 263, 'PE 2', 'RHYTHMIC ACTIVITIES', 3, 0, 1, 0, 0, 0, 0, 0, '12:31', '12:51', '', '', '', '2025-11-25 16:19:29', '2025-11-25 16:19:29'),
(84, 55, 264, 'DM101', 'ORGANIZATION AND MANAGEMENT CONCEPTS', 3, 0, 0, 0, 1, 0, 0, 0, '13:51', '13:51', '', '', '', '2025-11-25 16:19:47', '2025-11-25 16:19:47'),
(85, 55, 265, 'GEE 1', 'FILIPINO', 3, 0, 1, 0, 0, 0, 0, 0, '12:41', '02:42', '', '', '', '2025-11-25 16:19:57', '2025-11-25 16:19:57'),
(86, 55, 266, 'IS102', 'PROFESSIONAL-ISSUES IN INFORMATION SYSTEM', 3, 0, 0, 0, 0, 1, 0, 0, '12:51', '00:51', '', '', '', '2025-11-25 16:20:05', '2025-11-25 16:20:05'),
(87, 55, 267, 'IS103', 'IT INFRASTRUCTURE AND NETWORK TECHNOLOGIES', 3, 0, 0, 1, 0, 0, 0, 0, '15:25', '14:35', '', '', '', '2025-11-25 16:20:12', '2025-11-25 16:20:12'),
(88, 55, 268, 'IS104', 'SYSTEMS ANALYSIS AND DESIGN', 3, 0, 0, 0, 0, 1, 0, 0, '01:51', '01:51', '', '', '', '2025-11-25 16:20:19', '2025-11-25 16:20:19'),
(89, 55, 269, 'OCC101', 'DISCRETE STRUCTURES', 3, 0, 1, 0, 0, 0, 0, 0, '01:51', '13:51', '', '', '', '2025-11-25 16:20:25', '2025-11-25 16:20:25'),
(90, 55, 270, 'PE 3', 'INDIVIDUAL & DUAL SPORTS', 3, 0, 0, 0, 0, 1, 0, 0, '01:51', '13:51', '', '', '', '2025-11-25 16:20:33', '2025-11-25 16:20:33'),
(91, 58, 271, 'CC104', 'DATA STRUCTURES AND ALGORITHMS ANALYSIS', 3, 0, 0, 0, 1, 0, 0, 0, '13:51', '13:51', '', '', '', '2025-11-25 16:21:27', '2025-11-25 16:21:27'),
(92, 58, 272, 'DM102', 'FINANCIAL MANAGEMENT', 3, 0, 0, 1, 0, 0, 0, 0, '15:13', '13:51', '', '', '', '2025-11-25 16:21:33', '2025-11-25 16:21:33'),
(93, 58, 273, 'GEE 2', 'PANITIKAN', 3, 0, 0, 0, 1, 0, 0, 0, '13:51', '13:51', '', '', '', '2025-11-25 16:21:39', '2025-11-25 16:21:39'),
(94, 58, 274, 'IS105', 'ENTERPRISE ARCHITECTURE', 3, 0, 0, 0, 0, 0, 1, 0, '13:51', '13:51', '', '', '', '2025-11-25 16:21:48', '2025-11-25 16:21:48'),
(95, 58, 275, 'IS106', 'IS PROJECT MANAGEMENT 1', 3, 0, 0, 0, 0, 0, 0, 1, '12:41', '12:51', '', '', '', '2025-11-25 16:21:58', '2025-11-25 16:21:58'),
(96, 58, 276, 'IS108', 'IT INFRASTRUCTURE AND NETWORK TECHNOLOGY 2', 3, 0, 0, 0, 0, 0, 1, 0, '12:05', '12:05', '', '', '', '2025-11-25 16:22:11', '2025-11-25 16:22:11'),
(97, 58, 277, 'OCC102', 'MULTIMEDIA', 3, 0, 0, 1, 0, 0, 0, 0, '12:51', '12:51', '', '', '', '2025-11-25 16:22:22', '2025-11-25 16:22:22'),
(98, 58, 278, 'PE 4', 'TEAM SPORTS', 3, 0, 0, 1, 0, 0, 0, 0, '12:41', '12:41', '', '', '', '2025-11-25 16:22:30', '2025-11-25 16:22:30'),
(99, 61, 279, 'ADV01', 'BUSINESS INTELLIGENCE', 3, 0, 0, 1, 0, 0, 0, 0, '12:31', '05:31', '', '', '', '2025-11-25 16:23:09', '2025-11-25 16:23:09'),
(100, 61, 280, 'ADV02', 'ENTERPRISE SYSTEM', 3, 0, 0, 1, 0, 0, 0, 0, '12:51', '12:51', '', '', '', '2025-11-25 16:23:17', '2025-11-25 16:23:17'),
(101, 61, 281, 'CC105', 'INFORMATION MANAGEMENT', 3, 0, 0, 1, 0, 0, 0, 0, '12:41', '12:41', '', '', '', '2025-11-25 16:23:24', '2025-11-25 16:23:24'),
(102, 61, 282, 'DM103', 'BUSINESS PROCESS MANAGEMENT', 3, 0, 0, 0, 0, 1, 0, 0, '12:41', '12:41', '', '', '', '2025-11-25 16:23:31', '2025-11-25 16:23:31'),
(103, 61, 283, 'IS109', 'SYSTEMS ANALYSIS AND DESIGN 2', 3, 0, 0, 1, 0, 0, 0, 0, '13:51', '04:26', '', '', '', '2025-11-25 16:23:39', '2025-11-25 16:23:39'),
(104, 61, 284, 'OCC103', 'DATA COMMUNICATIIONS AND NETWORKING', 3, 0, 0, 0, 0, 0, 1, 0, '12:31', '16:25', '', '', '', '2025-11-25 16:23:47', '2025-11-25 16:23:47'),
(105, 61, 285, 'OCC104', 'WEB DEVELOPMENT', 3, 0, 0, 0, 0, 0, 1, 0, '12:51', '04:15', '', '', '', '2025-11-25 16:23:56', '2025-11-25 16:23:56'),
(106, 64, 286, 'ADV03', 'IT SECURITY AND MANAGEMENT', 3, 0, 0, 1, 0, 0, 0, 0, '14:32', '16:31', '', '', '', '2025-11-25 16:24:31', '2025-11-25 16:24:31'),
(107, 64, 287, 'ADV04', 'SUPPLY CHAIN MANAGEMENT', 3, 0, 0, 0, 1, 0, 0, 0, '12:41', '06:34', '', '', '', '2025-11-25 16:24:38', '2025-11-25 16:24:38'),
(108, 64, 288, 'CAP101', 'CAPSTONE PROJECT 1', 3, 0, 0, 1, 0, 0, 0, 0, '03:43', '03:15', '', '', '', '2025-11-25 16:24:45', '2025-11-25 16:24:45'),
(109, 64, 289, 'DM104', 'EVALUATION OF BUSINESS PERFORMANCE', 3, 0, 1, 0, 0, 0, 0, 0, '02:52', '14:51', '', '', '', '2025-11-25 16:24:53', '2025-11-25 16:24:53'),
(110, 64, 290, 'GE8', 'ETHICS', 3, 0, 0, 1, 0, 0, 0, 0, '13:51', '01:06', '', '', '', '2025-11-25 16:25:30', '2025-11-25 16:25:30'),
(111, 64, 291, 'QUAMET', 'QUANTITATIVE METHODS', 3, 0, 0, 0, 1, 0, 0, 0, '13:51', '03:46', '', '', '', '2025-11-25 16:25:38', '2025-11-25 16:25:38'),
(112, 67, 292, 'CAP102', 'CAPSTONE PROJECT 2', 3, 0, 0, 0, 0, 0, 1, 0, '03:43', '06:06', '', '', '', '2025-11-25 16:25:56', '2025-11-25 16:25:56'),
(113, 67, 293, 'CC106', 'APPLICATION DEVELOPMENT AND EMERGING TECHNOLOGIES', 3, 0, 0, 1, 0, 0, 0, 0, '12:41', '12:41', '', '', '', '2025-11-25 16:26:03', '2025-11-25 16:26:03'),
(114, 67, 294, 'GE 7', 'SCIENCE, TECHNOLOGY, AND SOCIETY', 3, 0, 0, 1, 0, 0, 0, 0, '00:31', '13:51', '', '', '', '2025-11-25 16:26:12', '2025-11-25 16:26:12'),
(115, 67, 295, 'GE 9', 'THE LIFE AND WORKS OF RIZAL', 3, 0, 1, 0, 0, 0, 0, 0, '12:31', '00:41', '', '', '', '2025-11-25 16:26:18', '2025-11-25 16:26:18'),
(116, 67, 296, 'GEE 3', 'LIVING IN THE IT ERA', 3, 0, 0, 0, 0, 0, 1, 0, '12:31', '14:35', '', '', '', '2025-11-25 16:26:24', '2025-11-25 16:26:24'),
(117, 67, 297, 'IS107', 'IS STRATEGY, MANAGEMENT AND AQUISITION', 3, 0, 0, 1, 0, 0, 0, 0, '01:41', '04:36', '', '', '', '2025-11-25 16:26:34', '2025-11-25 16:26:34'),
(118, 70, 298, 'PRAC101', 'PRACTICUM (500 hours)', 6, 1, 1, 1, 1, 1, 1, 1, '02:15', '14:35', '', '', '', '2025-11-25 16:26:56', '2025-11-25 16:26:56');

-- --------------------------------------------------------

--
-- Table structure for table `student_grades`
--

CREATE TABLE `student_grades` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `curriculum_id` int(11) NOT NULL COMMENT 'References curriculum table for subjects',
  `academic_year` varchar(20) NOT NULL,
  `semester` varchar(20) NOT NULL,
  `grade` decimal(3,2) DEFAULT NULL COMMENT 'Numeric grade (e.g., 1.00, 1.25, 2.50, 5.00)',
  `grade_letter` varchar(5) DEFAULT NULL COMMENT 'Letter grade (e.g., A, B+, C, INC, F)',
  `status` enum('pending','verified','finalized') DEFAULT 'pending',
  `remarks` text DEFAULT NULL,
  `verified_by` int(11) DEFAULT NULL COMMENT 'Admin user ID who verified',
  `verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_grades`
--

INSERT INTO `student_grades` (`id`, `user_id`, `curriculum_id`, `academic_year`, `semester`, `grade`, `grade_letter`, `status`, `remarks`, `verified_by`, `verified_at`, `created_at`, `updated_at`) VALUES
(293, 49, 250, 'AY 2024-2025', 'First Semester', 5.00, 'INC', 'verified', NULL, 1, '2025-12-01 09:59:27', '2025-12-01 09:59:22', '2025-12-01 09:59:27'),
(294, 49, 251, 'AY 2024-2025', 'First Semester', 5.00, 'INC', 'verified', NULL, 1, '2025-12-01 09:59:28', '2025-12-01 09:59:22', '2025-12-01 09:59:28'),
(295, 49, 252, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 09:59:28', '2025-12-01 09:59:23', '2025-12-01 09:59:28'),
(296, 49, 253, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 09:59:29', '2025-12-01 09:59:24', '2025-12-01 09:59:29'),
(297, 49, 254, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 09:59:29', '2025-12-01 09:59:24', '2025-12-01 09:59:29'),
(298, 49, 255, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 09:59:30', '2025-12-01 09:59:25', '2025-12-01 09:59:30'),
(299, 49, 256, 'AY 2024-2025', 'First Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 09:59:30', '2025-12-01 09:59:26', '2025-12-01 09:59:30'),
(300, 51, 250, 'AY 2024-2025', 'First Semester', 5.00, 'INC', 'verified', NULL, 1, '2025-12-01 10:10:13', '2025-12-01 10:10:05', '2025-12-01 10:10:13'),
(301, 51, 251, 'AY 2024-2025', 'First Semester', 5.00, 'INC', 'verified', NULL, 1, '2025-12-01 10:10:14', '2025-12-01 10:10:07', '2025-12-01 10:10:14'),
(302, 51, 252, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:10:14', '2025-12-01 10:10:08', '2025-12-01 10:10:14'),
(303, 51, 253, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:10:15', '2025-12-01 10:10:08', '2025-12-01 10:10:15'),
(304, 51, 254, 'AY 2024-2025', 'First Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 10:10:16', '2025-12-01 10:10:09', '2025-12-01 10:10:16'),
(305, 51, 255, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:10:16', '2025-12-01 10:10:09', '2025-12-01 10:10:16'),
(306, 51, 256, 'AY 2024-2025', 'First Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 10:10:16', '2025-12-01 10:10:10', '2025-12-01 10:10:16'),
(307, 51, 257, 'AY 2024-2025', 'Second Semester', 5.00, 'INC', 'verified', NULL, 1, '2025-12-01 10:14:35', '2025-12-01 10:14:20', '2025-12-01 10:14:35'),
(308, 51, 258, 'AY 2024-2025', 'Second Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:14:36', '2025-12-01 10:14:21', '2025-12-01 10:14:36'),
(309, 51, 259, 'AY 2024-2025', 'Second Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:14:36', '2025-12-01 10:14:23', '2025-12-01 10:14:36'),
(310, 51, 261, 'AY 2024-2025', 'Second Semester', 5.00, 'INC', 'verified', NULL, 1, '2025-12-01 10:14:37', '2025-12-01 10:14:26', '2025-12-01 10:14:37'),
(312, 51, 260, 'AY 2024-2025', 'Second Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:14:37', '2025-12-01 10:14:30', '2025-12-01 10:14:37'),
(313, 51, 262, 'AY 2024-2025', 'Second Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:14:38', '2025-12-01 10:14:32', '2025-12-01 10:14:38'),
(314, 51, 263, 'AY 2024-2025', 'Second Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:14:38', '2025-12-01 10:14:33', '2025-12-01 10:14:38'),
(315, 51, 264, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:42:46', '2025-12-01 10:42:34', '2025-12-01 10:42:46'),
(316, 51, 265, 'AY 2024-2025', 'First Semester', 5.00, 'INC', 'verified', NULL, 1, '2025-12-01 10:42:46', '2025-12-01 10:42:37', '2025-12-01 10:42:46'),
(317, 51, 266, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:42:47', '2025-12-01 10:42:38', '2025-12-01 10:42:47'),
(318, 51, 267, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:42:47', '2025-12-01 10:42:40', '2025-12-01 10:42:47'),
(319, 51, 268, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:42:48', '2025-12-01 10:42:40', '2025-12-01 10:42:48'),
(320, 51, 269, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:42:49', '2025-12-01 10:42:42', '2025-12-01 10:42:49'),
(321, 51, 270, 'AY 2024-2025', 'First Semester', 5.00, 'INC', 'verified', NULL, 1, '2025-12-01 10:42:50', '2025-12-01 10:42:43', '2025-12-01 10:42:50'),
(322, 50, 250, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:50:04', '2025-12-01 10:49:45', '2025-12-01 10:50:04'),
(323, 50, 251, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:50:07', '2025-12-01 10:49:46', '2025-12-01 10:50:07'),
(325, 50, 252, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:50:07', '2025-12-01 10:49:49', '2025-12-01 10:50:07'),
(326, 50, 253, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 10:50:08', '2025-12-01 10:49:50', '2025-12-01 10:50:08'),
(327, 50, 254, 'AY 2024-2025', 'First Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 10:50:08', '2025-12-01 10:49:51', '2025-12-01 10:50:08'),
(328, 50, 255, 'AY 2024-2025', 'First Semester', 1.00, 'A', 'verified', NULL, 1, '2025-12-01 10:50:09', '2025-12-01 10:49:54', '2025-12-01 10:50:09'),
(329, 50, 256, 'AY 2024-2025', 'First Semester', 1.00, 'A', 'verified', NULL, 1, '2025-12-01 10:50:10', '2025-12-01 10:49:55', '2025-12-01 10:50:10'),
(330, 50, 257, 'AY 2024-2025', 'Second Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:01:59', '2025-12-01 11:01:41', '2025-12-01 11:01:59'),
(332, 50, 258, 'AY 2024-2025', 'Second Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:02:00', '2025-12-01 11:01:45', '2025-12-01 11:02:00'),
(333, 50, 259, 'AY 2024-2025', 'Second Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:02:01', '2025-12-01 11:01:45', '2025-12-01 11:02:01'),
(334, 50, 260, 'AY 2024-2025', 'Second Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:02:02', '2025-12-01 11:01:46', '2025-12-01 11:02:02'),
(335, 50, 261, 'AY 2024-2025', 'Second Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 11:02:02', '2025-12-01 11:01:48', '2025-12-01 11:02:02'),
(336, 50, 262, 'AY 2024-2025', 'Second Semester', 1.00, 'A', 'verified', NULL, 1, '2025-12-01 11:02:03', '2025-12-01 11:01:49', '2025-12-01 11:02:03'),
(337, 50, 263, 'AY 2024-2025', 'Second Semester', 1.00, 'A', 'verified', NULL, 1, '2025-12-01 11:02:03', '2025-12-01 11:01:51', '2025-12-01 11:02:03'),
(338, 50, 264, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:08:43', '2025-12-01 11:08:04', '2025-12-01 11:08:43'),
(339, 50, 265, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:08:44', '2025-12-01 11:08:04', '2025-12-01 11:08:44'),
(341, 50, 266, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:08:45', '2025-12-01 11:08:07', '2025-12-01 11:08:45'),
(343, 50, 267, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:08:45', '2025-12-01 11:08:09', '2025-12-01 11:08:45'),
(348, 50, 268, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:08:47', '2025-12-01 11:08:29', '2025-12-01 11:08:47'),
(350, 50, 269, 'AY 2024-2025', 'First Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 11:08:48', '2025-12-01 11:08:31', '2025-12-01 11:08:48'),
(352, 50, 270, 'AY 2024-2025', 'First Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 11:08:49', '2025-12-01 11:08:33', '2025-12-01 11:08:49'),
(354, 52, 250, 'AY 2024-2025', 'First Semester', 5.00, 'INC', 'verified', NULL, 1, '2025-12-01 11:09:05', '2025-12-01 11:08:43', '2025-12-01 11:09:05'),
(355, 52, 251, 'AY 2024-2025', 'First Semester', 0.00, 'W', 'verified', NULL, 1, '2025-12-01 11:09:06', '2025-12-01 11:08:44', '2025-12-01 11:09:06'),
(356, 52, 252, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:08:50', '2025-12-01 11:08:44', '2025-12-01 11:08:50'),
(357, 52, 253, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:08:50', '2025-12-01 11:08:44', '2025-12-01 11:08:50'),
(358, 52, 254, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:08:51', '2025-12-01 11:08:45', '2025-12-01 11:08:51'),
(359, 52, 255, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:08:51', '2025-12-01 11:08:45', '2025-12-01 11:08:51'),
(360, 52, 256, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:08:52', '2025-12-01 11:08:46', '2025-12-01 11:08:52'),
(361, 52, 257, 'AY 2024-2025', 'Second Semester', 5.00, 'INC', 'verified', NULL, 1, '2025-12-01 11:14:17', '2025-12-01 11:14:03', '2025-12-01 11:14:17'),
(362, 52, 258, 'AY 2024-2025', 'Second Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:14:17', '2025-12-01 11:14:05', '2025-12-01 11:14:17'),
(363, 52, 259, 'AY 2024-2025', 'Second Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:14:18', '2025-12-01 11:14:07', '2025-12-01 11:14:18'),
(364, 52, 260, 'AY 2024-2025', 'Second Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:14:18', '2025-12-01 11:14:08', '2025-12-01 11:14:18'),
(365, 52, 261, 'AY 2024-2025', 'Second Semester', 5.00, 'INC', 'verified', NULL, 1, '2025-12-01 11:14:18', '2025-12-01 11:14:10', '2025-12-01 11:14:18'),
(366, 52, 262, 'AY 2024-2025', 'Second Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 11:14:19', '2025-12-01 11:14:11', '2025-12-01 11:14:19'),
(367, 52, 263, 'AY 2024-2025', 'Second Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 11:14:19', '2025-12-01 11:14:14', '2025-12-01 11:14:19'),
(368, 55, 250, 'AY 2024-2025', 'First Semester', 1.00, 'A', 'verified', NULL, 1, '2025-12-01 11:18:35', '2025-12-01 11:18:21', '2025-12-01 11:18:35'),
(370, 55, 251, 'AY 2024-2025', 'First Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 11:18:35', '2025-12-01 11:18:24', '2025-12-01 11:18:35'),
(371, 55, 252, 'AY 2024-2025', 'First Semester', 1.00, 'A', 'verified', NULL, 1, '2025-12-01 11:18:36', '2025-12-01 11:18:25', '2025-12-01 11:18:36'),
(372, 55, 253, 'AY 2024-2025', 'First Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 11:18:37', '2025-12-01 11:18:26', '2025-12-01 11:18:37'),
(373, 55, 254, 'AY 2024-2025', 'First Semester', 1.00, 'A', 'verified', NULL, 1, '2025-12-01 11:18:38', '2025-12-01 11:18:27', '2025-12-01 11:18:38'),
(374, 55, 255, 'AY 2024-2025', 'First Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 11:18:39', '2025-12-01 11:18:28', '2025-12-01 11:18:39'),
(375, 55, 256, 'AY 2024-2025', 'First Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 11:18:39', '2025-12-01 11:18:29', '2025-12-01 11:18:39'),
(376, 55, 257, 'AY 2024-2025', 'Second Semester', 1.00, 'A', 'verified', NULL, 1, '2025-12-01 11:27:04', '2025-12-01 11:26:51', '2025-12-01 11:27:04'),
(377, 55, 258, 'AY 2024-2025', 'Second Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 11:27:05', '2025-12-01 11:26:52', '2025-12-01 11:27:05'),
(378, 55, 259, 'AY 2024-2025', 'Second Semester', 1.00, 'A', 'verified', NULL, 1, '2025-12-01 11:27:05', '2025-12-01 11:26:53', '2025-12-01 11:27:05'),
(379, 55, 260, 'AY 2024-2025', 'Second Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 11:27:06', '2025-12-01 11:26:54', '2025-12-01 11:27:06'),
(380, 55, 261, 'AY 2024-2025', 'Second Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 11:27:06', '2025-12-01 11:26:55', '2025-12-01 11:27:06'),
(381, 55, 262, 'AY 2024-2025', 'Second Semester', 1.00, 'A', 'verified', NULL, 1, '2025-12-01 11:27:07', '2025-12-01 11:26:56', '2025-12-01 11:27:07'),
(382, 55, 263, 'AY 2024-2025', 'Second Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 11:27:07', '2025-12-01 11:26:58', '2025-12-01 11:27:07'),
(383, 55, 264, 'AY 2024-2025', 'First Semester', 1.00, 'A', 'verified', NULL, 1, '2025-12-01 11:35:42', '2025-12-01 11:35:26', '2025-12-01 11:35:42'),
(384, 55, 265, 'AY 2024-2025', 'First Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 11:35:43', '2025-12-01 11:35:27', '2025-12-01 11:35:43'),
(385, 55, 266, 'AY 2024-2025', 'First Semester', 1.00, 'A', 'verified', NULL, 1, '2025-12-01 11:35:44', '2025-12-01 11:35:28', '2025-12-01 11:35:44'),
(386, 55, 267, 'AY 2024-2025', 'First Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 11:35:44', '2025-12-01 11:35:28', '2025-12-01 11:35:44'),
(387, 55, 268, 'AY 2024-2025', 'First Semester', 1.00, 'A', 'verified', NULL, 1, '2025-12-01 11:35:45', '2025-12-01 11:35:29', '2025-12-01 11:35:45'),
(388, 55, 269, 'AY 2024-2025', 'First Semester', 1.00, 'A', 'verified', NULL, 1, '2025-12-01 11:35:47', '2025-12-01 11:35:31', '2025-12-01 11:35:47'),
(389, 55, 270, 'AY 2024-2025', 'First Semester', 2.00, 'B-', 'verified', NULL, 1, '2025-12-01 11:35:48', '2025-12-01 11:35:34', '2025-12-01 11:35:48'),
(390, 52, 264, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 12:26:32', '2025-12-01 12:26:19', '2025-12-01 12:26:32'),
(391, 52, 265, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 12:26:32', '2025-12-01 12:26:20', '2025-12-01 12:26:32'),
(392, 52, 266, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 12:26:33', '2025-12-01 12:26:21', '2025-12-01 12:26:33'),
(393, 52, 267, 'AY 2024-2025', 'First Semester', 0.00, 'W', 'verified', NULL, 1, '2025-12-01 12:26:33', '2025-12-01 12:26:23', '2025-12-01 12:26:33'),
(394, 52, 268, 'AY 2024-2025', 'First Semester', 0.00, 'W', 'verified', NULL, 1, '2025-12-01 12:26:34', '2025-12-01 12:26:26', '2025-12-01 12:26:34'),
(395, 52, 269, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 12:26:35', '2025-12-01 12:26:27', '2025-12-01 12:26:35'),
(396, 52, 270, 'AY 2024-2025', 'First Semester', 3.00, 'D', 'verified', NULL, 1, '2025-12-01 12:26:36', '2025-12-01 12:26:28', '2025-12-01 12:26:36');

-- --------------------------------------------------------

--
-- Table structure for table `student_number_sequence`
--

CREATE TABLE `student_number_sequence` (
  `id` int(11) NOT NULL,
  `year` int(4) NOT NULL,
  `last_number` int(5) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_number_sequence`
--

INSERT INTO `student_number_sequence` (`id`, `year`, `last_number`, `created_at`, `updated_at`) VALUES
(1, 2025, 7, '2025-11-11 06:35:09', '2025-12-01 11:16:28');

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

--
-- Dumping data for table `student_schedules`
--

INSERT INTO `student_schedules` (`id`, `user_id`, `section_schedule_id`, `course_code`, `course_name`, `units`, `schedule_monday`, `schedule_tuesday`, `schedule_wednesday`, `schedule_thursday`, `schedule_friday`, `schedule_saturday`, `schedule_sunday`, `time_start`, `time_end`, `room`, `professor_name`, `professor_initial`, `status`, `assigned_date`, `updated_at`) VALUES
(320, 49, 70, 'CC101', 'INTRODUCTION TO COMPUTING', 3, 0, 1, 0, 0, 0, 0, 0, '03:43', '16:34', '', '', '', 'active', '2025-12-01 09:51:35', '2025-12-01 09:51:35'),
(321, 49, 71, 'CC102', 'COMPUTER PROGRAMMING 1', 3, 0, 0, 0, 1, 0, 0, 0, '04:31', '04:21', '', '', '', 'active', '2025-12-01 09:51:35', '2025-12-01 09:51:35'),
(322, 49, 72, 'GE1', 'UNDERSTANDING THE SELF', 3, 0, 0, 0, 1, 0, 0, 0, '16:21', '12:41', '', '', '', 'active', '2025-12-01 09:51:35', '2025-12-01 09:51:35'),
(323, 49, 73, 'GE2', 'READING IN PHILIPPINE HISTORY', 3, 0, 0, 0, 0, 1, 0, 0, '12:31', '12:41', '', '', '', 'active', '2025-12-01 09:51:35', '2025-12-01 09:51:35'),
(324, 49, 74, 'GE3', 'THE CONTEMPORARY WORLD', 3, 0, 0, 0, 0, 0, 0, 1, '13:41', '13:41', '', '', '', 'active', '2025-12-01 09:51:35', '2025-12-01 09:51:35'),
(325, 49, 75, 'NSTP 1', 'CWTS/ROTC1', 3, 0, 1, 0, 0, 0, 0, 0, '12:51', '13:51', '', '', '', 'active', '2025-12-01 09:51:35', '2025-12-01 09:51:35'),
(326, 49, 76, 'PE 1', 'PHYSYCAL FITNESS / SELF-TESTING ACTIVITIES', 3, 0, 0, 0, 0, 0, 0, 1, '13:51', '03:16', '', '', '', 'active', '2025-12-01 09:51:35', '2025-12-01 09:51:35'),
(327, 51, 70, 'CC101', 'INTRODUCTION TO COMPUTING', 3, 0, 1, 0, 0, 0, 0, 0, '03:43', '16:34', '', '', '', 'active', '2025-12-01 10:09:26', '2025-12-01 10:09:26'),
(328, 51, 71, 'CC102', 'COMPUTER PROGRAMMING 1', 3, 0, 0, 0, 1, 0, 0, 0, '04:31', '04:21', '', '', '', 'active', '2025-12-01 10:09:26', '2025-12-01 10:09:26'),
(329, 51, 72, 'GE1', 'UNDERSTANDING THE SELF', 3, 0, 0, 0, 1, 0, 0, 0, '16:21', '12:41', '', '', '', 'active', '2025-12-01 10:09:26', '2025-12-01 10:09:26'),
(330, 51, 73, 'GE2', 'READING IN PHILIPPINE HISTORY', 3, 0, 0, 0, 0, 1, 0, 0, '12:31', '12:41', '', '', '', 'active', '2025-12-01 10:09:26', '2025-12-01 10:09:26'),
(331, 51, 74, 'GE3', 'THE CONTEMPORARY WORLD', 3, 0, 0, 0, 0, 0, 0, 1, '13:41', '13:41', '', '', '', 'active', '2025-12-01 10:09:26', '2025-12-01 10:09:26'),
(332, 51, 75, 'NSTP 1', 'CWTS/ROTC1', 3, 0, 1, 0, 0, 0, 0, 0, '12:51', '13:51', '', '', '', 'active', '2025-12-01 10:09:26', '2025-12-01 10:09:26'),
(333, 51, 76, 'PE 1', 'PHYSYCAL FITNESS / SELF-TESTING ACTIVITIES', 3, 0, 0, 0, 0, 0, 0, 1, '13:51', '03:16', '', '', '', 'active', '2025-12-01 10:09:26', '2025-12-01 10:09:26'),
(334, 51, 78, 'GE4', 'MATHEMATICS IN THE MODERN WORLD', 3, 0, 0, 0, 0, 1, 0, 0, '00:41', '01:06', '', '', '', 'active', '2025-12-01 10:13:21', '2025-12-01 10:13:21'),
(335, 51, 79, 'GE5', 'PURPOSIVE COMMUNICATION', 3, 0, 1, 0, 0, 0, 0, 0, '00:51', '03:13', '', '', '', 'active', '2025-12-01 10:13:21', '2025-12-01 10:13:21'),
(336, 51, 80, 'GE6', 'ART APPRECIATION', 3, 0, 0, 0, 0, 1, 0, 0, '12:51', '12:51', '', '', '', 'active', '2025-12-01 10:13:21', '2025-12-01 10:13:21'),
(337, 51, 82, 'NSTP 2', 'CWTS/ROTC2', 3, 0, 0, 0, 0, 0, 0, 1, '13:51', '17:09', '', '', '', 'active', '2025-12-01 10:13:21', '2025-12-01 10:13:21'),
(338, 51, 83, 'PE 2', 'RHYTHMIC ACTIVITIES', 3, 0, 1, 0, 0, 0, 0, 0, '12:31', '12:51', '', '', '', 'active', '2025-12-01 10:13:21', '2025-12-01 10:13:21'),
(339, 53, 70, 'CC101', 'INTRODUCTION TO COMPUTING', 3, 0, 1, 0, 0, 0, 0, 0, '03:43', '16:34', '', '', '', 'active', '2025-12-01 10:16:58', '2025-12-01 10:16:58'),
(340, 53, 71, 'CC102', 'COMPUTER PROGRAMMING 1', 3, 0, 0, 0, 1, 0, 0, 0, '04:31', '04:21', '', '', '', 'active', '2025-12-01 10:16:58', '2025-12-01 10:16:58'),
(341, 53, 72, 'GE1', 'UNDERSTANDING THE SELF', 3, 0, 0, 0, 1, 0, 0, 0, '16:21', '12:41', '', '', '', 'active', '2025-12-01 10:16:58', '2025-12-01 10:16:58'),
(342, 53, 73, 'GE2', 'READING IN PHILIPPINE HISTORY', 3, 0, 0, 0, 0, 1, 0, 0, '12:31', '12:41', '', '', '', 'active', '2025-12-01 10:16:58', '2025-12-01 10:16:58'),
(343, 53, 74, 'GE3', 'THE CONTEMPORARY WORLD', 3, 0, 0, 0, 0, 0, 0, 1, '13:41', '13:41', '', '', '', 'active', '2025-12-01 10:16:58', '2025-12-01 10:16:58'),
(344, 53, 75, 'NSTP 1', 'CWTS/ROTC1', 3, 0, 1, 0, 0, 0, 0, 0, '12:51', '13:51', '', '', '', 'active', '2025-12-01 10:16:58', '2025-12-01 10:16:58'),
(345, 53, 76, 'PE 1', 'PHYSYCAL FITNESS / SELF-TESTING ACTIVITIES', 3, 0, 0, 0, 0, 0, 0, 1, '13:51', '03:16', '', '', '', 'active', '2025-12-01 10:16:58', '2025-12-01 10:16:58'),
(346, 54, 70, 'CC101', 'INTRODUCTION TO COMPUTING', 3, 0, 1, 0, 0, 0, 0, 0, '03:43', '16:34', '', '', '', 'active', '2025-12-01 10:21:55', '2025-12-01 10:21:55'),
(347, 54, 71, 'CC102', 'COMPUTER PROGRAMMING 1', 3, 0, 0, 0, 1, 0, 0, 0, '04:31', '04:21', '', '', '', 'active', '2025-12-01 10:21:55', '2025-12-01 10:21:55'),
(348, 54, 72, 'GE1', 'UNDERSTANDING THE SELF', 3, 0, 0, 0, 1, 0, 0, 0, '16:21', '12:41', '', '', '', 'active', '2025-12-01 10:21:55', '2025-12-01 10:21:55'),
(349, 54, 73, 'GE2', 'READING IN PHILIPPINE HISTORY', 3, 0, 0, 0, 0, 1, 0, 0, '12:31', '12:41', '', '', '', 'active', '2025-12-01 10:21:55', '2025-12-01 10:21:55'),
(350, 54, 74, 'GE3', 'THE CONTEMPORARY WORLD', 3, 0, 0, 0, 0, 0, 0, 1, '13:41', '13:41', '', '', '', 'active', '2025-12-01 10:21:55', '2025-12-01 10:21:55'),
(351, 54, 75, 'NSTP 1', 'CWTS/ROTC1', 3, 0, 1, 0, 0, 0, 0, 0, '12:51', '13:51', '', '', '', 'active', '2025-12-01 10:21:55', '2025-12-01 10:21:55'),
(352, 54, 76, 'PE 1', 'PHYSYCAL FITNESS / SELF-TESTING ACTIVITIES', 3, 0, 0, 0, 0, 0, 0, 1, '13:51', '03:16', '', '', '', 'active', '2025-12-01 10:21:55', '2025-12-01 10:21:55'),
(353, 50, 70, 'CC101', 'INTRODUCTION TO COMPUTING', 3, 0, 1, 0, 0, 0, 0, 0, '03:43', '16:34', '', '', '', 'active', '2025-12-01 10:28:54', '2025-12-01 10:28:54'),
(354, 50, 71, 'CC102', 'COMPUTER PROGRAMMING 1', 3, 0, 0, 0, 1, 0, 0, 0, '04:31', '04:21', '', '', '', 'active', '2025-12-01 10:28:54', '2025-12-01 10:28:54'),
(355, 50, 72, 'GE1', 'UNDERSTANDING THE SELF', 3, 0, 0, 0, 1, 0, 0, 0, '16:21', '12:41', '', '', '', 'active', '2025-12-01 10:28:54', '2025-12-01 10:28:54'),
(356, 50, 73, 'GE2', 'READING IN PHILIPPINE HISTORY', 3, 0, 0, 0, 0, 1, 0, 0, '12:31', '12:41', '', '', '', 'active', '2025-12-01 10:28:54', '2025-12-01 10:28:54'),
(357, 50, 74, 'GE3', 'THE CONTEMPORARY WORLD', 3, 0, 0, 0, 0, 0, 0, 1, '13:41', '13:41', '', '', '', 'active', '2025-12-01 10:28:54', '2025-12-01 10:28:54'),
(358, 50, 75, 'NSTP 1', 'CWTS/ROTC1', 3, 0, 1, 0, 0, 0, 0, 0, '12:51', '13:51', '', '', '', 'active', '2025-12-01 10:28:54', '2025-12-01 10:28:54'),
(359, 50, 76, 'PE 1', 'PHYSYCAL FITNESS / SELF-TESTING ACTIVITIES', 3, 0, 0, 0, 0, 0, 0, 1, '13:51', '03:16', '', '', '', 'active', '2025-12-01 10:28:54', '2025-12-01 10:28:54'),
(360, 52, 14, 'BSE-C101', 'Entrepreneurship Behavior', 3, 0, 0, 1, 0, 0, 0, 0, '14:32', '14:32', '22', 'Armado Mone', 'AM', 'active', '2025-12-01 10:29:46', '2025-12-01 10:29:46'),
(361, 52, 15, 'GE-100', 'Understanding the Self', 3, 0, 1, 0, 0, 0, 0, 0, '02:32', '12:31', '', '', '', 'active', '2025-12-01 10:29:46', '2025-12-01 10:29:46'),
(362, 52, 16, 'GE-101', 'Reading in Philippine History', 3, 0, 0, 0, 0, 0, 1, 0, '02:46', '08:34', '', '', '', 'active', '2025-12-01 10:29:46', '2025-12-01 10:29:46'),
(363, 52, 17, 'GE-107', 'The Contemporary World', 3, 0, 0, 0, 1, 0, 0, 0, '03:04', '15:03', '', '', '', 'active', '2025-12-01 10:29:46', '2025-12-01 10:29:46'),
(364, 52, 18, 'NSTP1', 'National Service Training Program 1', 3, 0, 0, 0, 0, 0, 0, 1, '05:55', '17:55', '', '', '', 'active', '2025-12-01 10:29:46', '2025-12-01 10:29:46'),
(365, 52, 19, 'PE1', 'Physical Fitness/Self-Testing Activities', 2, 0, 0, 0, 0, 0, 1, 0, '05:12', '17:13', '', '', '', 'active', '2025-12-01 10:29:46', '2025-12-01 10:29:46'),
(366, 52, 70, 'CC101', 'INTRODUCTION TO COMPUTING', 3, 0, 1, 0, 0, 0, 0, 0, '03:43', '16:34', '', '', '', 'active', '2025-12-01 10:29:59', '2025-12-01 10:29:59'),
(367, 52, 71, 'CC102', 'COMPUTER PROGRAMMING 1', 3, 0, 0, 0, 1, 0, 0, 0, '04:31', '04:21', '', '', '', 'active', '2025-12-01 10:29:59', '2025-12-01 10:29:59'),
(368, 52, 72, 'GE1', 'UNDERSTANDING THE SELF', 3, 0, 0, 0, 1, 0, 0, 0, '16:21', '12:41', '', '', '', 'active', '2025-12-01 10:29:59', '2025-12-01 10:29:59'),
(369, 52, 73, 'GE2', 'READING IN PHILIPPINE HISTORY', 3, 0, 0, 0, 0, 1, 0, 0, '12:31', '12:41', '', '', '', 'active', '2025-12-01 10:29:59', '2025-12-01 10:29:59'),
(370, 52, 74, 'GE3', 'THE CONTEMPORARY WORLD', 3, 0, 0, 0, 0, 0, 0, 1, '13:41', '13:41', '', '', '', 'active', '2025-12-01 10:29:59', '2025-12-01 10:29:59'),
(371, 52, 75, 'NSTP 1', 'CWTS/ROTC1', 3, 0, 1, 0, 0, 0, 0, 0, '12:51', '13:51', '', '', '', 'active', '2025-12-01 10:29:59', '2025-12-01 10:29:59'),
(372, 52, 76, 'PE 1', 'PHYSYCAL FITNESS / SELF-TESTING ACTIVITIES', 3, 0, 0, 0, 0, 0, 0, 1, '13:51', '03:16', '', '', '', 'active', '2025-12-01 10:29:59', '2025-12-01 10:29:59'),
(373, 51, 85, 'GEE 1', 'FILIPINO', 3, 0, 1, 0, 0, 0, 0, 0, '12:41', '02:42', '', '', '', 'active', '2025-12-01 10:41:48', '2025-12-01 10:41:48'),
(374, 51, 88, 'IS104', 'SYSTEMS ANALYSIS AND DESIGN', 3, 0, 0, 0, 0, 1, 0, 0, '01:51', '01:51', '', '', '', 'active', '2025-12-01 10:41:48', '2025-12-01 10:41:48'),
(375, 51, 89, 'OCC101', 'DISCRETE STRUCTURES', 3, 0, 1, 0, 0, 0, 0, 0, '01:51', '13:51', '', '', '', 'active', '2025-12-01 10:41:48', '2025-12-01 10:41:48'),
(376, 51, 90, 'PE 3', 'INDIVIDUAL & DUAL SPORTS', 3, 0, 0, 0, 0, 1, 0, 0, '01:51', '13:51', '', '', '', 'active', '2025-12-01 10:41:48', '2025-12-01 10:41:48'),
(377, 50, 77, 'CC103', 'COMPUTER PROGRAMMING 2', 3, 0, 1, 0, 0, 0, 0, 0, '12:51', '12:51', '', '', '', 'active', '2025-12-01 10:55:18', '2025-12-01 10:55:18'),
(378, 50, 78, 'GE4', 'MATHEMATICS IN THE MODERN WORLD', 3, 0, 0, 0, 0, 1, 0, 0, '00:41', '01:06', '', '', '', 'active', '2025-12-01 10:55:18', '2025-12-01 10:55:18'),
(379, 50, 79, 'GE5', 'PURPOSIVE COMMUNICATION', 3, 0, 1, 0, 0, 0, 0, 0, '00:51', '03:13', '', '', '', 'active', '2025-12-01 10:55:18', '2025-12-01 10:55:18'),
(380, 50, 80, 'GE6', 'ART APPRECIATION', 3, 0, 0, 0, 0, 1, 0, 0, '12:51', '12:51', '', '', '', 'active', '2025-12-01 10:55:18', '2025-12-01 10:55:18'),
(381, 50, 81, 'IS101', 'FUNDAMENTALS OF INFORMATION SYSTEMS', 3, 0, 1, 0, 0, 0, 0, 0, '01:51', '13:51', '', '', '', 'active', '2025-12-01 10:55:18', '2025-12-01 10:55:18'),
(382, 50, 82, 'NSTP 2', 'CWTS/ROTC2', 3, 0, 0, 0, 0, 0, 0, 1, '13:51', '17:09', '', '', '', 'active', '2025-12-01 10:55:18', '2025-12-01 10:55:18'),
(383, 50, 83, 'PE 2', 'RHYTHMIC ACTIVITIES', 3, 0, 1, 0, 0, 0, 0, 0, '12:31', '12:51', '', '', '', 'active', '2025-12-01 10:55:18', '2025-12-01 10:55:18'),
(384, 50, 99, 'ADV01', 'BUSINESS INTELLIGENCE', 3, 0, 0, 1, 0, 0, 0, 0, '12:31', '05:31', '', '', '', 'active', '2025-12-01 11:04:57', '2025-12-01 11:04:57'),
(385, 50, 100, 'ADV02', 'ENTERPRISE SYSTEM', 3, 0, 0, 1, 0, 0, 0, 0, '12:51', '12:51', '', '', '', 'active', '2025-12-01 11:04:57', '2025-12-01 11:04:57'),
(386, 50, 101, 'CC105', 'INFORMATION MANAGEMENT', 3, 0, 0, 1, 0, 0, 0, 0, '12:41', '12:41', '', '', '', 'active', '2025-12-01 11:04:57', '2025-12-01 11:04:57'),
(387, 50, 102, 'DM103', 'BUSINESS PROCESS MANAGEMENT', 3, 0, 0, 0, 0, 1, 0, 0, '12:41', '12:41', '', '', '', 'active', '2025-12-01 11:04:57', '2025-12-01 11:04:57'),
(388, 50, 103, 'IS109', 'SYSTEMS ANALYSIS AND DESIGN 2', 3, 0, 0, 1, 0, 0, 0, 0, '13:51', '04:26', '', '', '', 'active', '2025-12-01 11:04:57', '2025-12-01 11:04:57'),
(389, 50, 104, 'OCC103', 'DATA COMMUNICATIIONS AND NETWORKING', 3, 0, 0, 0, 0, 0, 1, 0, '12:31', '16:25', '', '', '', 'active', '2025-12-01 11:04:57', '2025-12-01 11:04:57'),
(390, 50, 105, 'OCC104', 'WEB DEVELOPMENT', 3, 0, 0, 0, 0, 0, 1, 0, '12:51', '04:15', '', '', '', 'active', '2025-12-01 11:04:57', '2025-12-01 11:04:57'),
(391, 50, 84, 'DM101', 'ORGANIZATION AND MANAGEMENT CONCEPTS', 3, 0, 0, 0, 1, 0, 0, 0, '13:51', '13:51', '', '', '', 'active', '2025-12-01 11:05:37', '2025-12-01 11:05:37'),
(392, 50, 85, 'GEE 1', 'FILIPINO', 3, 0, 1, 0, 0, 0, 0, 0, '12:41', '02:42', '', '', '', 'active', '2025-12-01 11:05:37', '2025-12-01 11:05:37'),
(393, 50, 86, 'IS102', 'PROFESSIONAL-ISSUES IN INFORMATION SYSTEM', 3, 0, 0, 0, 0, 1, 0, 0, '12:51', '00:51', '', '', '', 'active', '2025-12-01 11:05:37', '2025-12-01 11:05:37'),
(394, 50, 87, 'IS103', 'IT INFRASTRUCTURE AND NETWORK TECHNOLOGIES', 3, 0, 0, 1, 0, 0, 0, 0, '15:25', '14:35', '', '', '', 'active', '2025-12-01 11:05:37', '2025-12-01 11:05:37'),
(395, 50, 88, 'IS104', 'SYSTEMS ANALYSIS AND DESIGN', 3, 0, 0, 0, 0, 1, 0, 0, '01:51', '01:51', '', '', '', 'active', '2025-12-01 11:05:37', '2025-12-01 11:05:37'),
(396, 50, 89, 'OCC101', 'DISCRETE STRUCTURES', 3, 0, 1, 0, 0, 0, 0, 0, '01:51', '13:51', '', '', '', 'active', '2025-12-01 11:05:37', '2025-12-01 11:05:37'),
(397, 50, 90, 'PE 3', 'INDIVIDUAL & DUAL SPORTS', 3, 0, 0, 0, 0, 1, 0, 0, '01:51', '13:51', '', '', '', 'active', '2025-12-01 11:05:37', '2025-12-01 11:05:37'),
(398, 52, 78, 'GE4', 'MATHEMATICS IN THE MODERN WORLD', 3, 0, 0, 0, 0, 1, 0, 0, '00:41', '01:06', '', '', '', 'active', '2025-12-01 11:11:34', '2025-12-01 11:11:34'),
(399, 52, 79, 'GE5', 'PURPOSIVE COMMUNICATION', 3, 0, 1, 0, 0, 0, 0, 0, '00:51', '03:13', '', '', '', 'active', '2025-12-01 11:11:34', '2025-12-01 11:11:34'),
(400, 52, 80, 'GE6', 'ART APPRECIATION', 3, 0, 0, 0, 0, 1, 0, 0, '12:51', '12:51', '', '', '', 'active', '2025-12-01 11:11:34', '2025-12-01 11:11:34'),
(401, 52, 82, 'NSTP 2', 'CWTS/ROTC2', 3, 0, 0, 0, 0, 0, 0, 1, '13:51', '17:09', '', '', '', 'active', '2025-12-01 11:11:34', '2025-12-01 11:11:34'),
(402, 52, 83, 'PE 2', 'RHYTHMIC ACTIVITIES', 3, 0, 1, 0, 0, 0, 0, 0, '12:31', '12:51', '', '', '', 'active', '2025-12-01 11:11:34', '2025-12-01 11:11:34'),
(403, 55, 70, 'CC101', 'INTRODUCTION TO COMPUTING', 3, 0, 1, 0, 0, 0, 0, 0, '03:43', '16:34', '', '', '', 'active', '2025-12-01 11:17:21', '2025-12-01 11:17:21'),
(404, 55, 71, 'CC102', 'COMPUTER PROGRAMMING 1', 3, 0, 0, 0, 1, 0, 0, 0, '04:31', '04:21', '', '', '', 'active', '2025-12-01 11:17:21', '2025-12-01 11:17:21'),
(405, 55, 72, 'GE1', 'UNDERSTANDING THE SELF', 3, 0, 0, 0, 1, 0, 0, 0, '16:21', '12:41', '', '', '', 'active', '2025-12-01 11:17:21', '2025-12-01 11:17:21'),
(406, 55, 73, 'GE2', 'READING IN PHILIPPINE HISTORY', 3, 0, 0, 0, 0, 1, 0, 0, '12:31', '12:41', '', '', '', 'active', '2025-12-01 11:17:21', '2025-12-01 11:17:21'),
(407, 55, 74, 'GE3', 'THE CONTEMPORARY WORLD', 3, 0, 0, 0, 0, 0, 0, 1, '13:41', '13:41', '', '', '', 'active', '2025-12-01 11:17:21', '2025-12-01 11:17:21'),
(408, 55, 75, 'NSTP 1', 'CWTS/ROTC1', 3, 0, 1, 0, 0, 0, 0, 0, '12:51', '13:51', '', '', '', 'active', '2025-12-01 11:17:21', '2025-12-01 11:17:21'),
(409, 55, 76, 'PE 1', 'PHYSYCAL FITNESS / SELF-TESTING ACTIVITIES', 3, 0, 0, 0, 0, 0, 0, 1, '13:51', '03:16', '', '', '', 'active', '2025-12-01 11:17:21', '2025-12-01 11:17:21'),
(410, 55, 77, 'CC103', 'COMPUTER PROGRAMMING 2', 3, 0, 1, 0, 0, 0, 0, 0, '12:51', '12:51', '', '', '', 'active', '2025-12-01 11:25:35', '2025-12-01 11:25:35'),
(411, 55, 78, 'GE4', 'MATHEMATICS IN THE MODERN WORLD', 3, 0, 0, 0, 0, 1, 0, 0, '00:41', '01:06', '', '', '', 'active', '2025-12-01 11:25:35', '2025-12-01 11:25:35'),
(412, 55, 79, 'GE5', 'PURPOSIVE COMMUNICATION', 3, 0, 1, 0, 0, 0, 0, 0, '00:51', '03:13', '', '', '', 'active', '2025-12-01 11:25:35', '2025-12-01 11:25:35'),
(413, 55, 80, 'GE6', 'ART APPRECIATION', 3, 0, 0, 0, 0, 1, 0, 0, '12:51', '12:51', '', '', '', 'active', '2025-12-01 11:25:35', '2025-12-01 11:25:35'),
(414, 55, 81, 'IS101', 'FUNDAMENTALS OF INFORMATION SYSTEMS', 3, 0, 1, 0, 0, 0, 0, 0, '01:51', '13:51', '', '', '', 'active', '2025-12-01 11:25:35', '2025-12-01 11:25:35'),
(415, 55, 82, 'NSTP 2', 'CWTS/ROTC2', 3, 0, 0, 0, 0, 0, 0, 1, '13:51', '17:09', '', '', '', 'active', '2025-12-01 11:25:35', '2025-12-01 11:25:35'),
(416, 55, 83, 'PE 2', 'RHYTHMIC ACTIVITIES', 3, 0, 1, 0, 0, 0, 0, 0, '12:31', '12:51', '', '', '', 'active', '2025-12-01 11:25:35', '2025-12-01 11:25:35'),
(417, 55, 84, 'DM101', 'ORGANIZATION AND MANAGEMENT CONCEPTS', 3, 0, 0, 0, 1, 0, 0, 0, '13:51', '13:51', '', '', '', 'active', '2025-12-01 11:31:57', '2025-12-01 11:31:57'),
(418, 55, 85, 'GEE 1', 'FILIPINO', 3, 0, 1, 0, 0, 0, 0, 0, '12:41', '02:42', '', '', '', 'active', '2025-12-01 11:31:57', '2025-12-01 11:31:57'),
(419, 55, 86, 'IS102', 'PROFESSIONAL-ISSUES IN INFORMATION SYSTEM', 3, 0, 0, 0, 0, 1, 0, 0, '12:51', '00:51', '', '', '', 'active', '2025-12-01 11:31:57', '2025-12-01 11:31:57'),
(420, 55, 87, 'IS103', 'IT INFRASTRUCTURE AND NETWORK TECHNOLOGIES', 3, 0, 0, 1, 0, 0, 0, 0, '15:25', '14:35', '', '', '', 'active', '2025-12-01 11:31:57', '2025-12-01 11:31:57'),
(421, 55, 88, 'IS104', 'SYSTEMS ANALYSIS AND DESIGN', 3, 0, 0, 0, 0, 1, 0, 0, '01:51', '01:51', '', '', '', 'active', '2025-12-01 11:31:57', '2025-12-01 11:31:57'),
(422, 55, 89, 'OCC101', 'DISCRETE STRUCTURES', 3, 0, 1, 0, 0, 0, 0, 0, '01:51', '13:51', '', '', '', 'active', '2025-12-01 11:31:57', '2025-12-01 11:31:57'),
(423, 55, 90, 'PE 3', 'INDIVIDUAL & DUAL SPORTS', 3, 0, 0, 0, 0, 1, 0, 0, '01:51', '13:51', '', '', '', 'active', '2025-12-01 11:31:57', '2025-12-01 11:31:57'),
(424, 52, 85, 'GEE 1', 'FILIPINO', 3, 0, 1, 0, 0, 0, 0, 0, '12:41', '02:42', '', '', '', 'active', '2025-12-01 12:08:50', '2025-12-01 12:08:50'),
(425, 52, 88, 'IS104', 'SYSTEMS ANALYSIS AND DESIGN', 3, 0, 0, 0, 0, 1, 0, 0, '01:51', '01:51', '', '', '', 'active', '2025-12-01 12:08:50', '2025-12-01 12:08:50'),
(426, 52, 89, 'OCC101', 'DISCRETE STRUCTURES', 3, 0, 1, 0, 0, 0, 0, 0, '01:51', '13:51', '', '', '', 'active', '2025-12-01 12:08:50', '2025-12-01 12:08:50'),
(427, 52, 90, 'PE 3', 'INDIVIDUAL & DUAL SPORTS', 3, 0, 0, 0, 0, 1, 0, 0, '01:51', '13:51', '', '', '', 'active', '2025-12-01 12:08:50', '2025-12-01 12:08:50');

-- --------------------------------------------------------

--
-- Table structure for table `subject_prerequisites`
--

CREATE TABLE `subject_prerequisites` (
  `id` int(11) NOT NULL,
  `curriculum_id` int(11) NOT NULL COMMENT 'The subject that requires prerequisites',
  `prerequisite_curriculum_id` int(11) NOT NULL COMMENT 'The prerequisite subject',
  `minimum_grade` decimal(3,2) DEFAULT 3.00 COMMENT 'Minimum passing grade (e.g., 3.00)',
  `is_required` tinyint(1) DEFAULT 1 COMMENT 'Whether this prerequisite is mandatory',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subject_prerequisites`
--

INSERT INTO `subject_prerequisites` (`id`, `curriculum_id`, `prerequisite_curriculum_id`, `minimum_grade`, `is_required`, `created_at`, `updated_at`) VALUES
(1, 232, 224, 3.00, 1, '2025-11-25 17:44:44', '2025-11-25 17:44:44'),
(2, 234, 228, 3.00, 1, '2025-11-25 17:44:44', '2025-11-25 17:44:44'),
(3, 235, 230, 3.00, 1, '2025-11-25 17:44:44', '2025-11-25 17:44:44'),
(4, 242, 235, 3.00, 1, '2025-11-25 17:44:44', '2025-11-25 17:44:44'),
(5, 244, 237, 3.00, 1, '2025-11-25 17:44:44', '2025-11-25 17:44:44'),
(6, 245, 239, 3.00, 1, '2025-11-25 17:44:44', '2025-11-25 17:44:44'),
(7, 246, 243, 3.00, 1, '2025-11-25 17:44:44', '2025-11-25 17:44:44'),
(8, 249, 248, 3.00, 1, '2025-11-25 17:44:44', '2025-11-25 17:44:44'),
(9, 257, 251, 3.00, 1, '2025-11-25 17:44:44', '2025-11-25 17:44:44'),
(10, 261, 250, 3.00, 1, '2025-11-25 17:44:44', '2025-11-25 17:44:44'),
(11, 262, 255, 3.00, 1, '2025-11-25 17:44:44', '2025-11-25 17:44:44'),
(12, 263, 256, 3.00, 1, '2025-11-25 17:44:44', '2025-11-25 17:44:44'),
(13, 264, 250, 3.00, 1, '2025-11-25 17:44:44', '2025-11-25 17:44:44'),
(14, 266, 250, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42'),
(15, 267, 250, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42'),
(16, 269, 258, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42'),
(17, 270, 263, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42'),
(18, 271, 257, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42'),
(19, 272, 264, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42'),
(20, 274, 267, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42'),
(21, 275, 268, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42'),
(22, 276, 267, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42'),
(23, 278, 270, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42'),
(24, 281, 271, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42'),
(25, 282, 272, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42'),
(26, 283, 268, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42'),
(27, 289, 282, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42'),
(28, 292, 288, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42'),
(29, 195, 189, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42'),
(30, 223, 217, 3.00, 1, '2025-11-25 17:45:42', '2025-11-25 17:45:42');

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
  `activated_at` datetime DEFAULT NULL,
  `lrn` varchar(20) DEFAULT NULL COMMENT 'Learner Reference Number',
  `occ_examinee_number` varchar(50) DEFAULT NULL COMMENT 'OCC Examinee Number',
  `middle_name` varchar(50) DEFAULT NULL,
  `sex_at_birth` enum('Male','Female') DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `civil_status` enum('Single','Married','Widowed','Separated','Divorced') DEFAULT NULL,
  `spouse_name` varchar(100) DEFAULT NULL COMMENT 'Name of Spouse (if married)',
  `contact_number` varchar(20) DEFAULT NULL,
  `father_name` varchar(100) DEFAULT NULL,
  `father_occupation` varchar(100) DEFAULT NULL,
  `father_education` varchar(100) DEFAULT NULL COMMENT 'Father''s Highest Educational Attainment',
  `mother_maiden_name` varchar(100) DEFAULT NULL,
  `mother_occupation` varchar(100) DEFAULT NULL,
  `mother_education` varchar(100) DEFAULT NULL COMMENT 'Mother''s Highest Educational Attainment',
  `number_of_brothers` int(11) DEFAULT 0,
  `number_of_sisters` int(11) DEFAULT 0,
  `combined_family_income` varchar(50) DEFAULT NULL,
  `guardian_name` varchar(100) DEFAULT NULL COMMENT 'Name of Guardian (If Applicable)',
  `school_last_attended` varchar(150) DEFAULT NULL,
  `school_address` text DEFAULT NULL COMMENT 'Address of School Last Attended',
  `is_pwd` tinyint(1) DEFAULT 0 COMMENT 'Person with Disability',
  `hearing_disability` tinyint(1) DEFAULT 0,
  `physical_disability` tinyint(1) DEFAULT 0,
  `mental_disability` tinyint(1) DEFAULT 0,
  `intellectual_disability` tinyint(1) DEFAULT 0,
  `psychosocial_disability` tinyint(1) DEFAULT 0,
  `chronic_illness_disability` tinyint(1) DEFAULT 0,
  `learning_disability` tinyint(1) DEFAULT 0,
  `shs_track` varchar(100) DEFAULT NULL COMMENT 'Senior High School Track',
  `shs_strand` varchar(100) DEFAULT NULL COMMENT 'Senior High School Strand',
  `is_working_student` tinyint(1) DEFAULT 0,
  `employer` varchar(150) DEFAULT NULL,
  `work_position` varchar(100) DEFAULT NULL,
  `working_hours` varchar(50) DEFAULT NULL,
  `municipality_city` varchar(100) DEFAULT NULL,
  `permanent_address` text DEFAULT NULL COMMENT 'Permanent Address No. (Bldg Number, Lot No. Street)',
  `barangay` varchar(100) DEFAULT NULL,
  `preferred_program` varchar(150) DEFAULT NULL COMMENT 'Preferred degree/program course'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `student_id`, `first_name`, `last_name`, `email`, `password`, `phone`, `date_of_birth`, `address`, `role`, `status`, `enrollment_status`, `created_at`, `updated_at`, `activation_token`, `token_expiry`, `is_imported`, `imported_at`, `activated_at`, `lrn`, `occ_examinee_number`, `middle_name`, `sex_at_birth`, `age`, `civil_status`, `spouse_name`, `contact_number`, `father_name`, `father_occupation`, `father_education`, `mother_maiden_name`, `mother_occupation`, `mother_education`, `number_of_brothers`, `number_of_sisters`, `combined_family_income`, `guardian_name`, `school_last_attended`, `school_address`, `is_pwd`, `hearing_disability`, `physical_disability`, `mental_disability`, `intellectual_disability`, `psychosocial_disability`, `chronic_illness_disability`, `learning_disability`, `shs_track`, `shs_strand`, `is_working_student`, `employer`, `work_position`, `working_hours`, `municipality_city`, `permanent_address`, `barangay`, `preferred_program`) VALUES
(49, '2025-00001', 'hatdog', 'hatdog', 'hatdog@gmail.com', '$2y$10$Lg413wPtrxsg8Xb2nXIvsO6nhvX32y3r0i62k/BUNuL75Ta/czt9m', '', '2025-12-17', '', 'student', 'active', 'enrolled', '2025-12-01 09:50:33', '2025-12-01 10:32:27', NULL, NULL, 0, NULL, NULL, '123123123123', '1231', '', 'Male', 23, 'Single', '', '', '', '', '', '', '', '', 0, 0, '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '', '', '', '', '', 'Bachelor of Science in Information System'),
(50, '2025-00006', 'Enigma', 'Asterisk', 'something@yahoo.co', '$2y$10$ZND03JMQX7YYKJAXmXBuRed47H7WpXznpYTI0MHryj.lQCN5wm8LG', '', '1999-02-22', '', 'student', 'active', 'enrolled', '2025-12-01 09:51:28', '2025-12-01 11:06:17', NULL, NULL, 0, NULL, NULL, '121222222222', '', 'Recon', 'Male', 18, 'Divorced', '', '09999999999', 'People Asterisk', 'Gamer', 'PUP Graduate', 'Shinobu Kobayashi', 'Ninja', 'Assassination Classroom Graduate', 2, 2, '50000 CAD', 'Guardian Angel', 'SKT T1 LoL School', 'Korea', 1, 0, 0, 0, 1, 0, 0, 0, 'Arts and Design Track', '', 1, 'Reddit Mod', 'Reddit Mod', '12AM - 11:59PM 24/7', 'Cainta', 'Sa Bahay', 'San Andres', 'Bachelor of Science in Information System'),
(51, '2025-00002', 'Reymond', 'Feca', 'A@gmail.com', '$2y$10$3EDCRThyPm/zpKp9Lk6vpeYDrZLS/J7de5M1GUUxdh6jSap6NXPei', '', '2025-12-03', '', 'student', 'active', 'enrolled', '2025-12-01 09:53:42', '2025-12-01 10:42:21', NULL, NULL, 0, NULL, NULL, '323154051234', '2025 - 777', 'Lalice', 'Male', 25, '', '', '091234567890', 'Jyp Feca', 'Dancer', 'College', 'Jenny Feca', 'Dancer', 'College', 5, 1, '10,000', 'Black Pink in your areaaaaa', 'One cainta College', 'One Cainta College, H4H9+8QF, Cainta, 1900 Rizal', 0, 0, 0, 0, 0, 0, 0, 0, 'Technical-Vocational Livelihood Track', 'Information and Communication Technology (ICT) Strand', 1, 'Mr. Eugene Krabs', 'Chef', '7 am - 5 pm', 'Cainta', '831 Bottom Feeder Lane in Bikini Bottom', 'Sto. Domingo', 'Bachelor of Science in Information System'),
(52, '2025-00005', 'Patrick', 'Star', 'B@gmail.com', '$2y$10$oaNeR9TaEgKgMLvHVJ5MIez9.hey/fYC80yCbrJTgUWqO8G7QZAeW', '', '2025-08-06', '', 'student', 'active', 'enrolled', '2025-12-01 10:02:30', '2025-12-01 12:25:53', NULL, NULL, 0, NULL, NULL, '123456789101', '2025-111', 'Star', 'Male', 25, 'Single', '', '12345678912', 'Patwerk', 'Stone heads', 'College', 'Patricia', 'Stone stroke', 'College', 2, 3, '20,000', 'Star Guardian', 'One Cainta college', 'Bikini Bottom', 0, 0, 0, 0, 0, 0, 0, 0, 'Academic Track', '', 0, '', '', '', 'Morong', '831 bottom feeder lane in bikini bottom', 'San Isidro', 'Bachelor of Science in Entrepreneurship'),
(53, '2025-00003', 'Sandy', 'Cheeks', 'C@gmail.com', '$2y$10$mM2UCyRqluNLrOjvJCpr6umcNSyE2jdqwtVkBRvSoOkGz4KtwW9Cq', '', '2025-12-16', '', 'student', 'active', 'enrolled', '2025-12-01 10:11:09', '2025-12-01 10:17:48', NULL, NULL, 0, NULL, NULL, '123656479812', '2025 - 1112', 'Cheeks', 'Female', 25, 'Single', '', '0912355955', 'Pa Cheesk', 'Looking for Job', 'College', 'Ma Cheeks', 'Looking for Job', 'College', 2, 1, '15,000', 'Cheeks Guardian', 'One cainta College', 'One Cainta College, H4H9+8QF, Cainta, 1900 Rizal', 0, 0, 0, 0, 0, 0, 0, 0, 'Arts and Design Track', '', 1, 'Mr. Eugene Krabs', 'Chef', '10 AM - 2 PM', 'Binangonan', '831 Bottom Feeder Lane in Bikini Bottom', 'San Isidro', 'Bachelor in Technical Vocational Teacher Education'),
(54, '2025-00004', 'SpongeBob', 'SquarePants', 'D@gmail.com', '$2y$10$uwmK9RfiEH.E/WinrBJy..BfTXDVh0xv1EAzLXw57W8AlC0b3fgHC', '', '2025-12-26', '', 'student', 'active', 'enrolled', '2025-12-01 10:19:59', '2025-12-01 10:23:33', NULL, NULL, 0, NULL, NULL, '182312391239', '2025 - 1223', 'Joy', 'Male', 25, 'Single', '', '1231283127', 'Harold SquarePants', 'Looking for Job', 'College', 'Margaret SquarePants', 'Looking for Job', 'college', 2, 1, '25,000', 'SquarePants', 'One cainta College', 'One Cainta College, H4H9+8QF, Cainta, 1900 Rizal', 0, 0, 0, 0, 0, 0, 0, 0, 'Technical-Vocational Livelihood Track', 'Information and Communication Technology (ICT) Strand', 1, 'Mr. Eugene Krabs', 'Chef', '7 am - 5 pm', 'Taytay', '831 Bottom Feeder Lane in Bikini Bottom', 'Sto. Domingo', 'Bachelor of Science in Information System'),
(55, '2025-00007', 'Sheldon', 'Plankton', 'E@gmail.com', '$2y$10$Er/mn2cdVClpSup3Yd0WdONKBgRLpEM9p.QH9YC1U.irQWgoClP9O', '', '2025-12-28', '', 'student', 'active', 'enrolled', '2025-12-01 10:51:14', '2025-12-01 11:35:16', NULL, NULL, 0, NULL, NULL, '324324322632', '2025 - 666', 'J', 'Male', 25, 'Married', 'Karen', '0912355955', 'Papa Plankton', 'Looking for Job', 'College', 'Mama Plankton', 'Looking for Job', 'College', 2, 1, '25,000', 'Plankton Guardian', 'One cainta College', 'One Cainta College, H4H9+8QF, Cainta, 1900 Rizal', 0, 0, 0, 0, 0, 0, 0, 0, 'Technical-Vocational Livelihood Track', 'Information and Communication Technology (ICT) Strand', 1, 'Mr. Eugene Krabs', 'Chef', '7 am - 5 pm', 'Rodriguez', '831 Bottom Feeder Lane in Bikini Bottom', 'Sto. Domingo', 'Bachelor of Science in Information System'),
(56, NULL, 'reymon', 'feca', 'fecareymon03@gmail.com', '$2y$10$0WRb0zeRztE0mfYFJdXZyOEvLDVGnv12cyTlnUsixPKPXwqX1Ia32', '', '2000-12-03', '', 'student', 'active', 'pending', '2025-12-01 11:39:20', '2025-12-01 11:39:20', NULL, NULL, 0, NULL, NULL, '109402060143', '2025', 'amang', 'Male', 24, 'Single', '', '09913569566', 'Reynaldo', 'none', 'highschool', 'rosalinda', 'retired', 'elementary', 2, 1, '30000', 'rosalinda', 'one cainta college', 'Hunter\'s Avenue, Barangay San Juan, Cainta, Rizal', 0, 0, 0, 0, 0, 0, 0, 0, 'Technical-Vocational Livelihood Track', 'Information and Communication Technology (ICT) Strand', 1, 'Jollibee', 'service', '8-9 hrs', 'Cainta', 'BLK 27 Bermai San Andres Kabisig Cainta Rizal', 'San Andres', 'Bachelor of Science in Information System');

-- --------------------------------------------------------

--
-- Table structure for table `verification_logs`
--

CREATE TABLE `verification_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `verified_by` int(11) NOT NULL,
  `verification_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `verification_type` varchar(50) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
-- Indexes for table `admissions`
--
ALTER TABLE `admissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `application_workflow`
--
ALTER TABLE `application_workflow`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `admission_approved_by` (`admission_approved_by`);

--
-- Indexes for table `certificate_of_registration`
--
ALTER TABLE `certificate_of_registration`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_cor_user` (`user_id`),
  ADD KEY `fk_cor_program` (`program_id`),
  ADD KEY `fk_cor_section` (`section_id`),
  ADD KEY `fk_cor_created_by` (`created_by`),
  ADD KEY `idx_user_academic_semester` (`user_id`,`academic_year`,`semester`),
  ADD KEY `idx_cor_enrollment` (`enrollment_id`);

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
-- Indexes for table `curriculum_submissions`
--
ALTER TABLE `curriculum_submissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_curriculum_submission_program_head` (`program_head_id`),
  ADD KEY `fk_curriculum_submission_program` (`program_id`),
  ADD KEY `fk_curriculum_submission_reviewer` (`reviewed_by`),
  ADD KEY `idx_dean_approved` (`dean_approved`);

--
-- Indexes for table `curriculum_submission_items`
--
ALTER TABLE `curriculum_submission_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_curriculum_item_submission` (`submission_id`);

--
-- Indexes for table `curriculum_submission_logs`
--
ALTER TABLE `curriculum_submission_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_submission_id` (`submission_id`);

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
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `document_rejection_history`
--
ALTER TABLE `document_rejection_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `rejected_by` (`rejected_by`);

--
-- Indexes for table `document_uploads`
--
ALTER TABLE `document_uploads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `verified_by` (`verified_by`);

--
-- Indexes for table `enrolled_students`
--
ALTER TABLE `enrolled_students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_student_id` (`student_id`),
  ADD KEY `fk_enrolled_user_id` (`user_id`),
  ADD KEY `idx_enrollment_date` (`enrollment_date`),
  ADD KEY `idx_lrn` (`lrn`),
  ADD KEY `idx_occ_examinee_number` (`occ_examinee_number`),
  ADD KEY `idx_municipality_city` (`municipality_city`),
  ADD KEY `idx_barangay` (`barangay`),
  ADD KEY `idx_preferred_program` (`preferred_program`);

--
-- Indexes for table `enrollment_approvals`
--
ALTER TABLE `enrollment_approvals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_enrollment_approvals_enrollment` (`enrollment_id`),
  ADD KEY `idx_enrollment_approvals_approver` (`approver_id`);

--
-- Indexes for table `enrollment_control`
--
ALTER TABLE `enrollment_control`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_enrollment_control_admission` (`created_by`),
  ADD KEY `idx_enrollment_type` (`enrollment_type`);

--
-- Indexes for table `enrollment_reports`
--
ALTER TABLE `enrollment_reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_academic_year` (`academic_year`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_generated_by` (`generated_by`),
  ADD KEY `idx_reviewed_by` (`reviewed_by`);

--
-- Indexes for table `enrollment_schedules`
--
ALTER TABLE `enrollment_schedules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_user` (`user_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `scheduled_by` (`scheduled_by`);

--
-- Indexes for table `enrollment_verification`
--
ALTER TABLE `enrollment_verification`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_verification` (`user_id`),
  ADD KEY `idx_verification_user_id` (`user_id`);

--
-- Indexes for table `grade_scale`
--
ALTER TABLE `grade_scale`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `next_semester_enrollments`
--
ALTER TABLE `next_semester_enrollments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_enrollment_request` (`user_id`,`target_academic_year`,`target_semester`),
  ADD KEY `processed_by` (`processed_by`),
  ADD KEY `idx_next_semester_user` (`user_id`),
  ADD KEY `idx_next_semester_status` (`request_status`),
  ADD KEY `selected_section_id` (`selected_section_id`),
  ADD KEY `cor_generated_by` (`cor_generated_by`);

--
-- Indexes for table `next_semester_subject_selections`
--
ALTER TABLE `next_semester_subject_selections`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_subject_selection` (`enrollment_request_id`,`curriculum_id`),
  ADD KEY `curriculum_id` (`curriculum_id`),
  ADD KEY `section_id` (`section_id`);

--
-- Indexes for table `pre_enrollment_forms`
--
ALTER TABLE `pre_enrollment_forms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_enrollment_request` (`user_id`,`enrollment_request_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_enrollment_request_id` (`enrollment_request_id`);

--
-- Indexes for table `programs`
--
ALTER TABLE `programs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `program_code` (`program_code`),
  ADD KEY `idx_programs_code` (`program_code`);

--
-- Indexes for table `program_heads`
--
ALTER TABLE `program_heads`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_program_head_program` (`program_id`);

--
-- Indexes for table `registrar_staff`
--
ALTER TABLE `registrar_staff`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `unique_username` (`username`),
  ADD UNIQUE KEY `unique_email` (`email`),
  ADD KEY `idx_status` (`status`);

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
-- Indexes for table `student_grades`
--
ALTER TABLE `student_grades`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_student_subject_term` (`user_id`,`curriculum_id`,`academic_year`,`semester`),
  ADD KEY `verified_by` (`verified_by`),
  ADD KEY `idx_student_grades_user` (`user_id`),
  ADD KEY `idx_student_grades_curriculum` (`curriculum_id`),
  ADD KEY `idx_student_grades_status` (`status`);

--
-- Indexes for table `student_number_sequence`
--
ALTER TABLE `student_number_sequence`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `year` (`year`);

--
-- Indexes for table `student_schedules`
--
ALTER TABLE `student_schedules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_student_course_schedule` (`user_id`,`section_schedule_id`),
  ADD KEY `section_schedule_id` (`section_schedule_id`);

--
-- Indexes for table `subject_prerequisites`
--
ALTER TABLE `subject_prerequisites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_prerequisite` (`curriculum_id`,`prerequisite_curriculum_id`),
  ADD KEY `prerequisite_curriculum_id` (`prerequisite_curriculum_id`),
  ADD KEY `idx_prerequisites_curriculum` (`curriculum_id`);

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
  ADD KEY `idx_is_imported` (`is_imported`),
  ADD KEY `idx_lrn` (`lrn`),
  ADD KEY `idx_occ_examinee_number` (`occ_examinee_number`),
  ADD KEY `idx_municipality_city` (`municipality_city`),
  ADD KEY `idx_barangay` (`barangay`),
  ADD KEY `idx_preferred_program` (`preferred_program`);

--
-- Indexes for table `verification_logs`
--
ALTER TABLE `verification_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `verified_by` (`verified_by`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `admissions`
--
ALTER TABLE `admissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `application_workflow`
--
ALTER TABLE `application_workflow`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `certificate_of_registration`
--
ALTER TABLE `certificate_of_registration`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `chatbot_faqs`
--
ALTER TABLE `chatbot_faqs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `chatbot_history`
--
ALTER TABLE `chatbot_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `curriculum`
--
ALTER TABLE `curriculum`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=299;

--
-- AUTO_INCREMENT for table `curriculum_submissions`
--
ALTER TABLE `curriculum_submissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `curriculum_submission_items`
--
ALTER TABLE `curriculum_submission_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=180;

--
-- AUTO_INCREMENT for table `curriculum_submission_logs`
--
ALTER TABLE `curriculum_submission_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `document_checklists`
--
ALTER TABLE `document_checklists`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `document_rejection_history`
--
ALTER TABLE `document_rejection_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `document_uploads`
--
ALTER TABLE `document_uploads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `enrolled_students`
--
ALTER TABLE `enrolled_students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT for table `enrollment_approvals`
--
ALTER TABLE `enrollment_approvals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `enrollment_control`
--
ALTER TABLE `enrollment_control`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `enrollment_reports`
--
ALTER TABLE `enrollment_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `enrollment_schedules`
--
ALTER TABLE `enrollment_schedules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `enrollment_verification`
--
ALTER TABLE `enrollment_verification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `grade_scale`
--
ALTER TABLE `grade_scale`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `next_semester_enrollments`
--
ALTER TABLE `next_semester_enrollments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `next_semester_subject_selections`
--
ALTER TABLE `next_semester_subject_selections`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=335;

--
-- AUTO_INCREMENT for table `pre_enrollment_forms`
--
ALTER TABLE `pre_enrollment_forms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `programs`
--
ALTER TABLE `programs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `program_heads`
--
ALTER TABLE `program_heads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `registrar_staff`
--
ALTER TABLE `registrar_staff`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `sections`
--
ALTER TABLE `sections`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT for table `section_enrollments`
--
ALTER TABLE `section_enrollments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=137;

--
-- AUTO_INCREMENT for table `section_schedules`
--
ALTER TABLE `section_schedules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=119;

--
-- AUTO_INCREMENT for table `student_grades`
--
ALTER TABLE `student_grades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=397;

--
-- AUTO_INCREMENT for table `student_number_sequence`
--
ALTER TABLE `student_number_sequence`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `student_schedules`
--
ALTER TABLE `student_schedules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=428;

--
-- AUTO_INCREMENT for table `subject_prerequisites`
--
ALTER TABLE `subject_prerequisites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `verification_logs`
--
ALTER TABLE `verification_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `application_workflow`
--
ALTER TABLE `application_workflow`
  ADD CONSTRAINT `fk_workflow_admission` FOREIGN KEY (`admission_approved_by`) REFERENCES `admissions` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_workflow_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `certificate_of_registration`
--
ALTER TABLE `certificate_of_registration`
  ADD CONSTRAINT `certificate_of_registration_ibfk_1` FOREIGN KEY (`enrollment_id`) REFERENCES `next_semester_enrollments` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cor_created_by` FOREIGN KEY (`created_by`) REFERENCES `admins` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cor_program` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cor_section` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cor_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

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
-- Constraints for table `curriculum_submissions`
--
ALTER TABLE `curriculum_submissions`
  ADD CONSTRAINT `fk_curriculum_submission_program` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_curriculum_submission_program_head` FOREIGN KEY (`program_head_id`) REFERENCES `program_heads` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_curriculum_submission_reviewer` FOREIGN KEY (`reviewed_by`) REFERENCES `admins` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `curriculum_submission_items`
--
ALTER TABLE `curriculum_submission_items`
  ADD CONSTRAINT `fk_curriculum_item_submission` FOREIGN KEY (`submission_id`) REFERENCES `curriculum_submissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `document_checklists`
--
ALTER TABLE `document_checklists`
  ADD CONSTRAINT `fk_document_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `document_rejection_history`
--
ALTER TABLE `document_rejection_history`
  ADD CONSTRAINT `fk_rejection_admission` FOREIGN KEY (`rejected_by`) REFERENCES `admissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rejection_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `document_uploads`
--
ALTER TABLE `document_uploads`
  ADD CONSTRAINT `fk_document_uploads_admission` FOREIGN KEY (`verified_by`) REFERENCES `admissions` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_document_uploads_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `enrolled_students`
--
ALTER TABLE `enrolled_students`
  ADD CONSTRAINT `fk_enrolled_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `enrollment_approvals`
--
ALTER TABLE `enrollment_approvals`
  ADD CONSTRAINT `enrollment_approvals_ibfk_1` FOREIGN KEY (`enrollment_id`) REFERENCES `next_semester_enrollments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `enrollment_approvals_ibfk_2` FOREIGN KEY (`approver_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `enrollment_schedules`
--
ALTER TABLE `enrollment_schedules`
  ADD CONSTRAINT `fk_enrollment_schedule_admission` FOREIGN KEY (`scheduled_by`) REFERENCES `admissions` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_enrollment_schedule_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `enrollment_verification`
--
ALTER TABLE `enrollment_verification`
  ADD CONSTRAINT `enrollment_verification_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `next_semester_enrollments`
--
ALTER TABLE `next_semester_enrollments`
  ADD CONSTRAINT `next_semester_enrollments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `next_semester_enrollments_ibfk_2` FOREIGN KEY (`processed_by`) REFERENCES `admins` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `next_semester_enrollments_ibfk_3` FOREIGN KEY (`selected_section_id`) REFERENCES `sections` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `next_semester_enrollments_ibfk_4` FOREIGN KEY (`cor_generated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `next_semester_subject_selections`
--
ALTER TABLE `next_semester_subject_selections`
  ADD CONSTRAINT `next_semester_subject_selections_ibfk_1` FOREIGN KEY (`enrollment_request_id`) REFERENCES `next_semester_enrollments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `next_semester_subject_selections_ibfk_2` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `next_semester_subject_selections_ibfk_3` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `pre_enrollment_forms`
--
ALTER TABLE `pre_enrollment_forms`
  ADD CONSTRAINT `pre_enrollment_forms_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `pre_enrollment_forms_ibfk_2` FOREIGN KEY (`enrollment_request_id`) REFERENCES `next_semester_enrollments` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `program_heads`
--
ALTER TABLE `program_heads`
  ADD CONSTRAINT `fk_program_head_program` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE;

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
-- Constraints for table `student_grades`
--
ALTER TABLE `student_grades`
  ADD CONSTRAINT `student_grades_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_grades_ibfk_2` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_grades_ibfk_3` FOREIGN KEY (`verified_by`) REFERENCES `admins` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `student_schedules`
--
ALTER TABLE `student_schedules`
  ADD CONSTRAINT `student_schedules_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_schedules_ibfk_2` FOREIGN KEY (`section_schedule_id`) REFERENCES `section_schedules` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `subject_prerequisites`
--
ALTER TABLE `subject_prerequisites`
  ADD CONSTRAINT `subject_prerequisites_ibfk_1` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `subject_prerequisites_ibfk_2` FOREIGN KEY (`prerequisite_curriculum_id`) REFERENCES `curriculum` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `verification_logs`
--
ALTER TABLE `verification_logs`
  ADD CONSTRAINT `verification_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `verification_logs_ibfk_2` FOREIGN KEY (`verified_by`) REFERENCES `admins` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
