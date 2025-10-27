-- Curriculum Data for OCC Programs
-- This file contains the complete curriculum for all programs

USE enrollment_occ;

-- Insert BSE (Bachelor of Science in Entrepreneurship) Curriculum
-- First Year - First Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(1, 'BSE-C101', 'Entrepreneurship Behavior', 3, '1st Year', 'First Semester', TRUE),
(1, 'GE-100', 'Understanding the Self', 3, '1st Year', 'First Semester', TRUE),
(1, 'GE-101', 'Reading in Philippine History', 3, '1st Year', 'First Semester', TRUE),
(1, 'GE-107', 'The Contemporary World', 3, '1st Year', 'First Semester', TRUE),
(1, 'NSTP1', 'National Service Training Program 1', 3, '1st Year', 'First Semester', TRUE),
(1, 'PE1', 'Physical Fitness/Self-Testing Activities', 2, '1st Year', 'First Semester', TRUE);

-- First Year - Second Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(1, 'BSE-C102', 'Microeconomics', 3, '1st Year', 'Second Semester', TRUE),
(1, 'GE-104', 'Mathematics in the Modern World', 3, '1st Year', 'Second Semester', TRUE),
(1, 'GE-103', 'Purposive Communication', 3, '1st Year', 'Second Semester', TRUE),
(1, 'GE-102', 'Art Appreciation', 3, '1st Year', 'Second Semester', TRUE),
(1, 'NSTP2', 'National Service Training Program 2', 3, '1st Year', 'Second Semester', TRUE),
(1, 'PE2', 'Rhythmic Activities', 2, '1st Year', 'Second Semester', TRUE);

-- Second Year - First Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(1, 'BSE-C103', 'Opportunity Seeking', 3, '2nd Year', 'First Semester', TRUE),
(1, 'GE-105', 'Science, Technology and Society', 3, '2nd Year', 'First Semester', TRUE),
(1, 'GE-111', 'Ethics', 3, '2nd Year', 'First Semester', TRUE),
(1, 'GE-106', 'Rizal''s Life and Works', 3, '2nd Year', 'First Semester', TRUE),
(1, 'BSE-C100', 'Entrepreneurial Leadership in an Organization', 3, '2nd Year', 'First Semester', TRUE),
(1, 'PE3', 'Individual/Dual Combative Sports', 2, '2nd Year', 'First Semester', TRUE);

-- Second Year - Second Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(1, 'BSE-C104', 'Market Research and Consumer Behavior', 3, '2nd Year', 'Second Semester', TRUE),
(1, 'BSE-C105', 'Innovation Management', 3, '2nd Year', 'Second Semester', TRUE),
(1, 'BSE-C106', 'Pricing and Costing', 3, '2nd Year', 'Second Semester', TRUE),
(1, 'BSE-C107', 'Human Resources Management', 3, '2nd Year', 'Second Semester', TRUE),
(1, 'BSE-GC101', 'Mathematics, Science and Technology', 3, '2nd Year', 'Second Semester', TRUE),
(1, 'BSE-GC102', 'Social Science and Philosophy', 3, '2nd Year', 'Second Semester', TRUE),
(1, 'BSE-OCC100', 'Living in the IT Era', 3, '2nd Year', 'Second Semester', TRUE),
(1, 'PE4', 'Team Sports', 2, '2nd Year', 'Second Semester', TRUE);

-- Third Year - First Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(1, 'BSE-C108', 'Financial Management', 3, '3rd Year', 'First Semester', TRUE),
(1, 'BSE-M101', 'Production and Operation Management', 3, '3rd Year', 'First Semester', TRUE),
(1, 'BSE-GC103', 'Arts and Humanities', 3, '3rd Year', 'First Semester', TRUE),
(1, 'BSE-ST101', 'Business Project Proposal 1 - Track 1: Small Business Consulting/Business Development Servicing 101', 3, '3rd Year', 'First Semester', TRUE),
(1, 'BSE-E101', 'Elective 1: Franchising', 3, '3rd Year', 'First Semester', TRUE),
(1, 'BSE-E102', 'Elective 2: Entrepreneurship Marketing Strategies', 3, '3rd Year', 'First Semester', TRUE),
(1, 'BSE-C109', 'Program and Policies on Enterprise Development', 3, '3rd Year', 'First Semester', TRUE),
(1, 'BSE-OCC101', 'Accounting 1 - Financial Accounting', 3, '3rd Year', 'First Semester', TRUE);

-- Third Year - Second Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(1, 'BSE-C110', 'Business Plan Preparation', 3, '3rd Year', 'Second Semester', TRUE),
(1, 'BSE-ST102', 'Track 2: Integrated Services of Consulting Services/Business Development', 3, '3rd Year', 'Second Semester', TRUE),
(1, 'BSE-E103', 'Elective 3: E-Commerce', 3, '3rd Year', 'Second Semester', TRUE),
(1, 'BSE-E104', 'Elective 4: Small Business Consulting/Business Development', 3, '3rd Year', 'Second Semester', TRUE),
(1, 'BSE-C111', 'International Business and Trade', 3, '3rd Year', 'Second Semester', TRUE),
(1, 'BSE-C112', 'Business Law and Tax', 3, '3rd Year', 'Second Semester', TRUE),
(1, 'BSE-M102', 'Strategic Management', 3, '3rd Year', 'Second Semester', TRUE),
(1, 'BSE-OCC102', 'Accounting II - Management Accounting', 3, '3rd Year', 'Second Semester', TRUE);

-- Fourth Year - First Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(1, 'BSE-C113', 'Business Plan Implementation 1', 5, '4th Year', 'First Semester', TRUE),
(1, 'BSE-C114', 'Social Entrepreneurship', 3, '4th Year', 'First Semester', TRUE),
(1, 'BSE-ST103', 'Track 3: Business Development: Small and Medium Enterprise Development/SMED', 3, '4th Year', 'First Semester', TRUE);

-- Fourth Year - Second Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(1, 'BSE-C115', 'Business Plan Implementation 2', 5, '4th Year', 'Second Semester', TRUE),
(1, 'BSE-ST104', 'Track 4: Business Development: Micro Enterprise Development/MED', 3, '4th Year', 'Second Semester', TRUE);

-- =========================================================================
-- BTVTED (Bachelor in Technical Vocational Teacher Education) Curriculum
-- =========================================================================

-- First Year - First Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(2, 'GE-100', 'Understanding the Self', 3, '1st Year', 'First Semester', TRUE),
(2, 'GE-101', 'Reading in Philippine History', 3, '1st Year', 'First Semester', TRUE),
(2, 'GE-102', 'Art Appreciation', 3, '1st Year', 'First Semester', TRUE),
(2, 'GE-103', 'Purposive Communication', 3, '1st Year', 'First Semester', TRUE),
(2, 'GE-104', 'Mathematics in the Modern World', 3, '1st Year', 'First Semester', TRUE),
(2, 'GE-105', 'Science, Technology and Society', 3, '1st Year', 'First Semester', TRUE),
(2, 'GE-106', 'Rizal''s Life and Works', 3, '1st Year', 'First Semester', TRUE),
(2, 'PE1', 'Physical Fitness/Self-Testing Activities', 2, '1st Year', 'First Semester', TRUE),
(2, 'NSTP1', 'National Service Training Program 1', 3, '1st Year', 'First Semester', TRUE);

-- First Year - Second Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(2, 'GE-107', 'The Contemporary World', 3, '1st Year', 'Second Semester', TRUE),
(2, 'GE-108', 'Panitikan', 3, '1st Year', 'Second Semester', TRUE),
(2, 'GE-109', 'Philippine Popular Culture', 3, '1st Year', 'Second Semester', TRUE),
(2, 'GE-110', 'Sining ng Pakipagtalastasan', 3, '1st Year', 'Second Semester', TRUE),
(2, 'GE-111', 'Ethics', 3, '1st Year', 'Second Semester', TRUE),
(2, 'EDUC-100', 'The Teaching Profession', 3, '1st Year', 'Second Semester', TRUE),
(2, 'EDUC-101', 'The Child and Adolescent Learner and Learning Principles', 3, '1st Year', 'Second Semester', TRUE),
(2, 'PE2', 'Rhythmic Activities', 2, '1st Year', 'Second Semester', TRUE),
(2, 'NSTP2', 'National Service Training Program 2', 3, '1st Year', 'Second Semester', TRUE);

-- Second Year - First Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(2, 'EDUC-102', 'Facilitating Learner-Centered Teaching: The Learner-Centered Approach with Emphasis on Trainers Methodology 1', 3, '2nd Year', 'First Semester', TRUE),
(2, 'EDUC-103', 'Technology for Teaching and Learning 1', 3, '2nd Year', 'First Semester', TRUE),
(2, 'EDUC-104', 'Building and Enhancing Literacy Across the Curriculum with Emphasis on the 21st Century Skills', 3, '2nd Year', 'First Semester', TRUE),
(2, 'EDUC-105', 'Andragogy of Learning including Principles of Trainers Methodology', 3, '2nd Year', 'First Semester', TRUE),
(2, 'EDUC-106', 'Assessment in Learning 1', 3, '2nd Year', 'First Semester', TRUE),
(2, 'BTVD-T101', 'Introduction to Agri-Fishery and Arts', 3, '2nd Year', 'First Semester', TRUE),
(2, 'BTVD100', 'Computer System Servicing 1 - Computer Hardware Installation and Maintenance', 3, '2nd Year', 'First Semester', TRUE),
(2, 'BTVD-T102', 'Entrepreneurship Behavior and Competencies', 3, '2nd Year', 'First Semester', TRUE),
(2, 'PE3', 'Individual/Dual Combative Sports', 2, '2nd Year', 'First Semester', TRUE),
(2, 'TLE 100', 'Introduction to Industrial Arts', 3, '2nd Year', 'First Semester', TRUE);

-- Second Year - Second Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(2, 'EDUC-106', 'The Teacher in Community, School Culture and Organizational Leadership with focus on the Philippine TVET System', 3, '2nd Year', 'Second Semester', TRUE),
(2, 'EDUC-108', 'Technology for Teaching and Learning 2', 3, '2nd Year', 'Second Semester', TRUE),
(2, 'EDUC-109', 'Curriculum Development and Evaluation with Emphasis on Trainers Methodology II', 3, '2nd Year', 'Second Semester', TRUE),
(2, 'EDUC-110', 'Foundation of Special and Inclusive Education (Mandated)', 3, '2nd Year', 'Second Semester', TRUE),
(2, 'EDUC-111', 'Assessment in Learning 2 with focus on Trainers Methodology 1 & 2', 3, '2nd Year', 'Second Semester', TRUE),
(2, 'BTVD-T103', 'Teaching ICT as an Exploratory Course', 3, '2nd Year', 'Second Semester', TRUE),
(2, 'BTVE-101', 'Computer System Servicing 2 - Computer System Installation and Configuration', 3, '2nd Year', 'Second Semester', TRUE),
(2, 'PE4', 'Team Sports', 2, '2nd Year', 'Second Semester', TRUE),
(2, 'TLE 104', 'Home Economics Literacy', 3, '2nd Year', 'Second Semester', TRUE);

-- Third Year - First Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(2, 'EDUC 112', 'Technology Research 1: Methods of Research', 3, '3rd Year', 'First Semester', TRUE),
(2, 'TLE 1-5', 'Teaching Common Competencies in ICT', 3, '3rd Year', 'First Semester', TRUE),
(2, 'TLE 106', 'Teaching in Common Competencies in IA', 3, '3rd Year', 'First Semester', TRUE),
(2, 'BTVE 102', 'Visual Graphics Design 1 - Web Site Development and Digital Media Design - Print Media', 3, '3rd Year', 'First Semester', TRUE),
(2, 'BTVE 103', 'Visual Graphics Design 2 - Web Site Development and Digital Media Design - Video Production', 3, '3rd Year', 'First Semester', TRUE),
(2, 'BTVE 104', 'Visual Graphics Design 3 - Web Site Development and Digital Media Design - Audio Production', 3, '3rd Year', 'First Semester', TRUE),
(2, 'BTVE-107', 'Computer Systems Servicing 3 - Computer System Servicing - Network Installation and Maintenance', 3, '3rd Year', 'First Semester', TRUE),
(2, 'BTVE 109', 'Visual Graphics Design 4 - Web Site Development and Digital Media Design - Authoring Tools', 3, '3rd Year', 'First Semester', TRUE),
(2, 'BTVE-106', 'Programming 1 - Program Logic Formulation', 3, '3rd Year', 'First Semester', TRUE);

-- Third Year - Second Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(2, 'BTVD-E113', 'Technology Research 2 - Undergraduate Thesis Writing/Research paper', 3, '3rd Year', 'Second Semester', TRUE),
(2, 'TLE 108', 'Teaching Common Competencies in HE', 3, '3rd Year', 'Second Semester', TRUE),
(2, 'BTVE 108', 'Visual Graphics Design 5 - Website Development and Digital Media Design - Web Site Creation (HTML5)', 3, '3rd Year', 'Second Semester', TRUE),
(2, 'BTVE 109', 'Visual Graphics Design 6 - Website Development and Digital Media Design - Internet Marketing', 3, '3rd Year', 'Second Semester', TRUE),
(2, 'BTVE 110', 'Visual Graphics Design 7 - Website Development and Digital Media Design - Web Site Creation (JavaScript & CSS3)', 3, '3rd Year', 'Second Semester', TRUE),
(2, 'BTVE 111', 'Programming 2 - Developing Web Applications (ASP.net)', 3, '3rd Year', 'Second Semester', TRUE),
(2, 'BTVE 112', 'Programming 3 - Object Oriented Programming (C++)', 3, '3rd Year', 'Second Semester', TRUE),
(2, 'EDUC 114', 'Work-Based Learning with Emphasis on Trainers Methodology', 3, '3rd Year', 'Second Semester', TRUE),
(2, 'TLE 107', 'Teaching Common Competencies in AFA', 3, '3rd Year', 'Second Semester', TRUE);

-- Fourth Year - First Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(2, 'EDUC 115', 'Field Study 1', 3, '4th Year', 'First Semester', TRUE),
(2, 'EDUC 116', 'Field Study 2', 3, '4th Year', 'First Semester', TRUE),
(2, 'TLE 109', 'Supervised Industry Training', 3, '4th Year', 'First Semester', TRUE);

-- Fourth Year - Second Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(2, 'EDUC 117', 'Practicum 2 - Practice Training', 6, '4th Year', 'Second Semester', TRUE);

-- =========================================================================
-- BSIS (Bachelor of Science in Information Systems) Curriculum
-- =========================================================================

-- First Year - First Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(3, 'GE-100', 'Understanding the Self', 3, '1st Year', 'First Semester', TRUE),
(3, 'GE-101', 'Reading in Philippine History', 3, '1st Year', 'First Semester', TRUE),
(3, 'GE-107', 'The Contemporary World', 3, '1st Year', 'First Semester', TRUE),
(3, 'CC101', 'Introduction to Computing', 3, '1st Year', 'First Semester', TRUE),
(3, 'CC102', 'Computer Programming 1', 3, '1st Year', 'First Semester', TRUE),
(3, 'NSTP1', 'National Service Training Program 1', 3, '1st Year', 'First Semester', TRUE),
(3, 'PE1', 'Physical Fitness/Self-Testing Activities', 2, '1st Year', 'First Semester', TRUE);

-- First Year - Second Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(3, 'GE-102', 'Art Appreciation', 3, '1st Year', 'Second Semester', TRUE),
(3, 'GE-103', 'Purposive Communication', 3, '1st Year', 'Second Semester', TRUE),
(3, 'GE-104', 'Mathematics in the Modern World', 3, '1st Year', 'Second Semester', TRUE),
(3, 'IS101', 'Fundamentals of Information Systems', 3, '1st Year', 'Second Semester', TRUE),
(3, 'CC103', 'Computer Programming 2', 3, '1st Year', 'Second Semester', TRUE),
(3, 'NSTP2', 'National Service Training Program 2', 3, '1st Year', 'Second Semester', TRUE),
(3, 'PE2', 'Rhythmic Activities', 2, '1st Year', 'Second Semester', TRUE);

-- Second Year - First Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(3, 'IS102', 'Professional Issues in Information Systems', 3, '2nd Year', 'First Semester', TRUE),
(3, 'OCC101', 'Programming 3 (Object Oriented Programming)', 3, '2nd Year', 'First Semester', TRUE),
(3, 'GE-105', 'Science, Technology and Society', 3, '2nd Year', 'First Semester', TRUE),
(3, 'IS103', 'IT Infrastructure and Network Technologies', 3, '2nd Year', 'First Semester', TRUE),
(3, 'IS104', 'Systems Analysis and Design', 3, '2nd Year', 'First Semester', TRUE),
(3, 'DM101', 'Organization and Management Concepts', 3, '2nd Year', 'First Semester', TRUE),
(3, 'PE3', 'Individual/Dual Combative Sports', 2, '2nd Year', 'First Semester', TRUE),
(3, 'GE9', 'The Life and Works of Rizal', 3, '2nd Year', 'First Semester', TRUE);

-- Second Year - Second Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(3, 'OCC102', 'Multimedia', 3, '2nd Year', 'Second Semester', TRUE),
(3, 'GEE 2', 'Reading Visual Arts', 3, '2nd Year', 'Second Semester', TRUE),
(3, 'GEE 3', 'People and Earth''s Ecosystem', 3, '2nd Year', 'Second Semester', TRUE),
(3, 'CC104', 'Data Structures and Algorithms Analysis', 3, '2nd Year', 'Second Semester', TRUE),
(3, 'IS105', 'Enterprise Architecture', 3, '2nd Year', 'Second Semester', TRUE),
(3, 'DM102', 'Financial Management', 3, '2nd Year', 'Second Semester', TRUE),
(3, 'IS106', 'IS Project Management', 3, '2nd Year', 'Second Semester', TRUE),
(3, 'PE4', 'Team Sports', 2, '2nd Year', 'Second Semester', TRUE);

-- Third Year - First Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(3, 'DM103', 'Business Process Management', 3, '3rd Year', 'First Semester', TRUE),
(3, 'CC105', 'Information Management', 3, '3rd Year', 'First Semester', TRUE),
(3, 'ADV04', 'Business Intelligence', 3, '3rd Year', 'First Semester', TRUE),
(3, 'ADV02', 'Enterprise Systems', 3, '3rd Year', 'First Semester', TRUE),
(3, 'DCC106', 'Application Development and Emerging Technologies', 3, '3rd Year', 'First Semester', TRUE),
(3, 'ADV01', 'IS Innovation and New Technologies', 3, '3rd Year', 'First Semester', TRUE),
(3, 'ST101', 'Statistics', 3, '3rd Year', 'First Semester', TRUE);

-- Third Year - Second Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(3, 'BM201', 'Bookkeeping', 3, '3rd Year', 'Second Semester', TRUE),
(3, 'DM104', 'Evaluation of Business Performance', 3, '3rd Year', 'Second Semester', TRUE),
(3, 'QUAMET', 'Quantitative Methods', 3, '3rd Year', 'Second Semester', TRUE),
(3, 'ADV03', 'IT Security and Management', 3, '3rd Year', 'Second Semester', TRUE),
(3, 'OCC104', 'Data Communications and Networking', 3, '3rd Year', 'Second Semester', TRUE),
(3, 'GE 8', 'Ethics', 3, '3rd Year', 'Second Semester', TRUE),
(3, 'CAP 101', 'Capstone Project', 3, '3rd Year', 'Second Semester', TRUE);

-- Fourth Year - First Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(3, 'GEE 1', 'Living in the IT Era', 3, '4th Year', 'First Semester', TRUE),
(3, 'OM101', 'Office Management', 3, '4th Year', 'First Semester', TRUE),
(3, 'OCC103', 'Database Administration', 3, '4th Year', 'First Semester', TRUE),
(3, 'OCC105', 'Web Development', 3, '4th Year', 'First Semester', TRUE),
(3, 'IS 107', 'IS Strategy Management and Acquisition', 3, '4th Year', 'First Semester', TRUE),
(3, 'CAP102', 'Capstone 2', 3, '4th Year', 'First Semester', TRUE);

-- Fourth Year - Second Semester
INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required) VALUES
(3, 'PRAC 101', 'Practicum (500 Hours)', 6, '4th Year', 'Second Semester', TRUE);

-- Verify curriculum data
SELECT 'Curriculum data loaded successfully!' as message;
SELECT program_code, COUNT(*) as course_count, SUM(units) as total_units
FROM curriculum c
JOIN programs p ON c.program_id = p.id
GROUP BY program_id, program_code;

