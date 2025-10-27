<?php
// Section class for managing class sections

class Section {
    private $conn;
    
    public function __construct() {
        $database = new Database();
        $this->conn = $database->getConnection();
    }
    
    // Get all sections
    public function getAllSections() {
        try {
            $sql = "SELECT s.*, p.program_code, p.program_name
                    FROM sections s
                    JOIN programs p ON s.program_id = p.id
                    ORDER BY p.program_code, s.year_level, s.semester, s.section_type";
            $stmt = $this->conn->prepare($sql);
            $stmt->execute();
            
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
            
        } catch(PDOException $e) {
            return [];
        }
    }
    
    // Get sections by program
    public function getSectionsByProgram($program_id) {
        try {
            $sql = "SELECT * FROM sections 
                    WHERE program_id = :program_id 
                    ORDER BY year_level, semester, section_type";
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':program_id', $program_id);
            $stmt->execute();
            
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
            
        } catch(PDOException $e) {
            return [];
        }
    }
    
    // Get section by ID
    public function getSectionById($section_id) {
        try {
            $sql = "SELECT s.*, p.program_code, p.program_name
                    FROM sections s
                    JOIN programs p ON s.program_id = p.id
                    WHERE s.id = :section_id";
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':section_id', $section_id);
            $stmt->execute();
            
            return $stmt->fetch(PDO::FETCH_ASSOC);
            
        } catch(PDOException $e) {
            return null;
        }
    }
    
    // Add new section
    public function addSection($data) {
        try {
            $sql = "INSERT INTO sections (program_id, year_level, semester, section_name, section_type, max_capacity, academic_year, status)
                    VALUES (:program_id, :year_level, :semester, :section_name, :section_type, :max_capacity, :academic_year, :status)";
            
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':program_id', $data['program_id']);
            $stmt->bindParam(':year_level', $data['year_level']);
            $stmt->bindParam(':semester', $data['semester']);
            $stmt->bindParam(':section_name', $data['section_name']);
            $stmt->bindParam(':section_type', $data['section_type']);
            $stmt->bindParam(':max_capacity', $data['max_capacity']);
            $stmt->bindParam(':academic_year', $data['academic_year']);
            $stmt->bindParam(':status', $data['status']);
            
            return $stmt->execute();
            
        } catch(PDOException $e) {
            return false;
        }
    }
    
    // Update section
    public function updateSection($section_id, $data) {
        try {
            $sql = "UPDATE sections 
                    SET section_name = :section_name,
                        max_capacity = :max_capacity,
                        status = :status
                    WHERE id = :section_id";
            
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':section_id', $section_id);
            $stmt->bindParam(':section_name', $data['section_name']);
            $stmt->bindParam(':max_capacity', $data['max_capacity']);
            $stmt->bindParam(':status', $data['status']);
            
            return $stmt->execute();
            
        } catch(PDOException $e) {
            return false;
        }
    }
    
    // Delete section
    public function deleteSection($section_id) {
        try {
            $sql = "DELETE FROM sections WHERE id = :section_id";
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':section_id', $section_id);
            
            return $stmt->execute();
            
        } catch(PDOException $e) {
            return false;
        }
    }
    
    // Get students in a section
    public function getStudentsInSection($section_id) {
        try {
            $sql = "SELECT u.id, u.student_id, u.first_name, u.last_name, u.email, se.enrolled_date
                    FROM section_enrollments se
                    JOIN users u ON se.user_id = u.id
                    WHERE se.section_id = :section_id AND se.status = 'active'
                    ORDER BY u.last_name, u.first_name";
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':section_id', $section_id);
            $stmt->execute();
            
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
            
        } catch(PDOException $e) {
            return [];
        }
    }
    
    // ===== SCHEDULE MANAGEMENT =====
    
    // Get schedule for a section
    public function getSectionSchedule($section_id) {
        try {
            $sql = "SELECT * FROM section_schedules 
                    WHERE section_id = :section_id 
                    ORDER BY course_code";
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':section_id', $section_id);
            $stmt->execute();
            
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
            
        } catch(PDOException $e) {
            return [];
        }
    }
    
    // Add course to section schedule
    public function addSchedule($data) {
        try {
            $sql = "INSERT INTO section_schedules 
                    (section_id, curriculum_id, course_code, course_name, units, 
                     schedule_monday, schedule_tuesday, schedule_wednesday, schedule_thursday, 
                     schedule_friday, schedule_saturday, schedule_sunday,
                     time_start, time_end, room, professor_name, professor_initial)
                    VALUES 
                    (:section_id, :curriculum_id, :course_code, :course_name, :units,
                     :schedule_monday, :schedule_tuesday, :schedule_wednesday, :schedule_thursday,
                     :schedule_friday, :schedule_saturday, :schedule_sunday,
                     :time_start, :time_end, :room, :professor_name, :professor_initial)";
            
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':section_id', $data['section_id']);
            $stmt->bindParam(':curriculum_id', $data['curriculum_id']);
            $stmt->bindParam(':course_code', $data['course_code']);
            $stmt->bindParam(':course_name', $data['course_name']);
            $stmt->bindParam(':units', $data['units']);
            $stmt->bindParam(':schedule_monday', $data['schedule_monday']);
            $stmt->bindParam(':schedule_tuesday', $data['schedule_tuesday']);
            $stmt->bindParam(':schedule_wednesday', $data['schedule_wednesday']);
            $stmt->bindParam(':schedule_thursday', $data['schedule_thursday']);
            $stmt->bindParam(':schedule_friday', $data['schedule_friday']);
            $stmt->bindParam(':schedule_saturday', $data['schedule_saturday']);
            $stmt->bindParam(':schedule_sunday', $data['schedule_sunday']);
            $stmt->bindParam(':time_start', $data['time_start']);
            $stmt->bindParam(':time_end', $data['time_end']);
            $stmt->bindParam(':room', $data['room']);
            $stmt->bindParam(':professor_name', $data['professor_name']);
            $stmt->bindParam(':professor_initial', $data['professor_initial']);
            
            return $stmt->execute();
            
        } catch(PDOException $e) {
            return false;
        }
    }
    
    // Update schedule
    public function updateSchedule($schedule_id, $data) {
        try {
            $sql = "UPDATE section_schedules 
                    SET schedule_monday = :schedule_monday,
                        schedule_tuesday = :schedule_tuesday,
                        schedule_wednesday = :schedule_wednesday,
                        schedule_thursday = :schedule_thursday,
                        schedule_friday = :schedule_friday,
                        schedule_saturday = :schedule_saturday,
                        schedule_sunday = :schedule_sunday,
                        time_start = :time_start,
                        time_end = :time_end,
                        room = :room,
                        professor_name = :professor_name,
                        professor_initial = :professor_initial
                    WHERE id = :schedule_id";
            
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':schedule_id', $schedule_id);
            $stmt->bindParam(':schedule_monday', $data['schedule_monday']);
            $stmt->bindParam(':schedule_tuesday', $data['schedule_tuesday']);
            $stmt->bindParam(':schedule_wednesday', $data['schedule_wednesday']);
            $stmt->bindParam(':schedule_thursday', $data['schedule_thursday']);
            $stmt->bindParam(':schedule_friday', $data['schedule_friday']);
            $stmt->bindParam(':schedule_saturday', $data['schedule_saturday']);
            $stmt->bindParam(':schedule_sunday', $data['schedule_sunday']);
            $stmt->bindParam(':time_start', $data['time_start']);
            $stmt->bindParam(':time_end', $data['time_end']);
            $stmt->bindParam(':room', $data['room']);
            $stmt->bindParam(':professor_name', $data['professor_name']);
            $stmt->bindParam(':professor_initial', $data['professor_initial']);
            
            return $stmt->execute();
            
        } catch(PDOException $e) {
            return false;
        }
    }
    
    // Delete schedule entry
    public function deleteSchedule($schedule_id) {
        try {
            $sql = "DELETE FROM section_schedules WHERE id = :schedule_id";
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':schedule_id', $schedule_id);
            
            return $stmt->execute();
            
        } catch(PDOException $e) {
            return false;
        }
    }
    
    // Get available curriculum courses for a section
    public function getAvailableCurriculumCourses($program_id, $year_level, $semester) {
        try {
            $sql = "SELECT * FROM curriculum 
                    WHERE program_id = :program_id 
                    AND year_level = :year_level 
                    AND semester = :semester
                    ORDER BY course_code";
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':program_id', $program_id);
            $stmt->bindParam(':year_level', $year_level);
            $stmt->bindParam(':semester', $semester);
            $stmt->execute();
            
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
            
        } catch(PDOException $e) {
            return [];
        }
    }
    
    // ===== STUDENT ENROLLMENT IN SECTIONS =====
    
    // Assign student to section
    public function assignStudentToSection($user_id, $section_id) {
        try {
            // Check if section exists and has capacity
            $section = $this->getSectionById($section_id);
            if (!$section) {
                return ['success' => false, 'message' => 'Section not found'];
            }
            
            if ($section['current_enrolled'] >= $section['max_capacity']) {
                return ['success' => false, 'message' => 'Section is full'];
            }
            
            // Check if student is already enrolled in this section
            $check_sql = "SELECT id FROM section_enrollments 
                         WHERE user_id = :user_id AND section_id = :section_id AND status = 'active'";
            $check_stmt = $this->conn->prepare($check_sql);
            $check_stmt->bindParam(':user_id', $user_id);
            $check_stmt->bindParam(':section_id', $section_id);
            $check_stmt->execute();
            
            if ($check_stmt->fetch()) {
                return ['success' => false, 'message' => 'Student is already enrolled in this section'];
            }
            
            // Begin transaction
            $this->conn->beginTransaction();
            
            // Insert into section_enrollments
            $insert_sql = "INSERT INTO section_enrollments (section_id, user_id, enrolled_date, status) 
                          VALUES (:section_id, :user_id, NOW(), 'active')";
            $insert_stmt = $this->conn->prepare($insert_sql);
            $insert_stmt->bindParam(':section_id', $section_id);
            $insert_stmt->bindParam(':user_id', $user_id);
            $insert_stmt->execute();
            
            // Update section current_enrolled count
            $update_sql = "UPDATE sections SET current_enrolled = current_enrolled + 1 WHERE id = :section_id";
            $update_stmt = $this->conn->prepare($update_sql);
            $update_stmt->bindParam(':section_id', $section_id);
            $update_stmt->execute();
            
            // Commit transaction
            $this->conn->commit();
            
            return ['success' => true, 'message' => 'Student assigned to section successfully'];
            
        } catch(PDOException $e) {
            if ($this->conn->inTransaction()) {
                $this->conn->rollBack();
            }
            return ['success' => false, 'message' => 'Database error: ' . $e->getMessage()];
        }
    }
    
    // Remove student from section
    public function removeStudentFromSection($user_id, $section_id) {
        try {
            // Begin transaction
            $this->conn->beginTransaction();
            
            // Update section_enrollments status to 'dropped'
            $update_sql = "UPDATE section_enrollments 
                          SET status = 'dropped' 
                          WHERE user_id = :user_id AND section_id = :section_id AND status = 'active'";
            $update_stmt = $this->conn->prepare($update_sql);
            $update_stmt->bindParam(':user_id', $user_id);
            $update_stmt->bindParam(':section_id', $section_id);
            $update_stmt->execute();
            
            if ($update_stmt->rowCount() == 0) {
                $this->conn->rollBack();
                return ['success' => false, 'message' => 'Section enrollment not found'];
            }
            
            // Update section current_enrolled count
            $update_section_sql = "UPDATE sections SET current_enrolled = current_enrolled - 1 WHERE id = :section_id";
            $update_section_stmt = $this->conn->prepare($update_section_sql);
            $update_section_stmt->bindParam(':section_id', $section_id);
            $update_section_stmt->execute();
            
            // Commit transaction
            $this->conn->commit();
            
            return ['success' => true, 'message' => 'Student removed from section successfully'];
            
        } catch(PDOException $e) {
            if ($this->conn->inTransaction()) {
                $this->conn->rollBack();
            }
            return ['success' => false, 'message' => 'Database error: ' . $e->getMessage()];
        }
    }
    
    // Get student's assigned sections
    public function getStudentSections($user_id) {
        try {
            $sql = "SELECT se.id as enrollment_id, se.section_id, se.enrolled_date, 
                    s.section_name, s.year_level, s.semester, s.academic_year,
                    p.program_code, p.program_name
                    FROM section_enrollments se
                    JOIN sections s ON se.section_id = s.id
                    JOIN programs p ON s.program_id = p.id
                    WHERE se.user_id = :user_id AND se.status = 'active'
                    ORDER BY se.enrolled_date DESC";
            
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':user_id', $user_id);
            $stmt->execute();
            
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
            
        } catch(PDOException $e) {
            return [];
        }
    }
    
}
?>


