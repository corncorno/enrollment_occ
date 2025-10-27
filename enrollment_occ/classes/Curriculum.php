<?php
// Curriculum class for managing academic programs and curriculum

class Curriculum {
    private $conn;
    
    public function __construct() {
        $database = new Database();
        $this->conn = $database->getConnection();
    }
    
    // Get all programs
    public function getAllPrograms() {
        try {
            $sql = "SELECT * FROM programs ORDER BY program_code";
            $stmt = $this->conn->prepare($sql);
            $stmt->execute();
            
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
            
        } catch(PDOException $e) {
            return [];
        }
    }
    
    // Get program by ID
    public function getProgramById($program_id) {
        try {
            $sql = "SELECT * FROM programs WHERE id = :program_id";
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':program_id', $program_id);
            $stmt->execute();
            
            return $stmt->fetch(PDO::FETCH_ASSOC);
            
        } catch(PDOException $e) {
            return null;
        }
    }
    
    // Get curriculum by program
    public function getCurriculumByProgram($program_id) {
        try {
            $sql = "SELECT * FROM curriculum 
                    WHERE program_id = :program_id 
                    ORDER BY 
                        FIELD(year_level, '1st Year', '2nd Year', '3rd Year', '4th Year', '5th Year'),
                        FIELD(semester, 'First Semester', 'Second Semester', 'Summer'),
                        course_code";
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':program_id', $program_id);
            $stmt->execute();
            
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
            
        } catch(PDOException $e) {
            return [];
        }
    }
    
    // Get curriculum by program, year, and semester
    public function getCurriculumByYearSemester($program_id, $year_level, $semester) {
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
    
    // Add course to curriculum
    public function addCurriculumCourse($data) {
        try {
            $sql = "INSERT INTO curriculum (program_id, course_code, course_name, units, year_level, semester, is_required, pre_requisites)
                    VALUES (:program_id, :course_code, :course_name, :units, :year_level, :semester, :is_required, :pre_requisites)";
            
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':program_id', $data['program_id']);
            $stmt->bindParam(':course_code', $data['course_code']);
            $stmt->bindParam(':course_name', $data['course_name']);
            $stmt->bindParam(':units', $data['units']);
            $stmt->bindParam(':year_level', $data['year_level']);
            $stmt->bindParam(':semester', $data['semester']);
            $stmt->bindParam(':is_required', $data['is_required']);
            $stmt->bindParam(':pre_requisites', $data['pre_requisites']);
            
            return $stmt->execute();
            
        } catch(PDOException $e) {
            return false;
        }
    }
    
    // Update curriculum course
    public function updateCurriculumCourse($id, $data) {
        try {
            $sql = "UPDATE curriculum 
                    SET course_code = :course_code,
                        course_name = :course_name,
                        units = :units,
                        year_level = :year_level,
                        semester = :semester,
                        is_required = :is_required,
                        pre_requisites = :pre_requisites
                    WHERE id = :id";
            
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':id', $id);
            $stmt->bindParam(':course_code', $data['course_code']);
            $stmt->bindParam(':course_name', $data['course_name']);
            $stmt->bindParam(':units', $data['units']);
            $stmt->bindParam(':year_level', $data['year_level']);
            $stmt->bindParam(':semester', $data['semester']);
            $stmt->bindParam(':is_required', $data['is_required']);
            $stmt->bindParam(':pre_requisites', $data['pre_requisites']);
            
            return $stmt->execute();
            
        } catch(PDOException $e) {
            return false;
        }
    }
    
    // Delete curriculum course
    public function deleteCurriculumCourse($id) {
        try {
            $sql = "DELETE FROM curriculum WHERE id = :id";
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':id', $id);
            
            return $stmt->execute();
            
        } catch(PDOException $e) {
            return false;
        }
    }
    
    // Get curriculum summary (total units per year/semester)
    public function getCurriculumSummary($program_id) {
        try {
            $sql = "SELECT 
                        year_level, 
                        semester, 
                        COUNT(*) as course_count,
                        SUM(units) as total_units
                    FROM curriculum 
                    WHERE program_id = :program_id
                    GROUP BY year_level, semester
                    ORDER BY 
                        FIELD(year_level, '1st Year', '2nd Year', '3rd Year', '4th Year', '5th Year'),
                        FIELD(semester, 'First Semester', 'Second Semester', 'Summer')";
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':program_id', $program_id);
            $stmt->execute();
            
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
            
        } catch(PDOException $e) {
            return [];
        }
    }
}
?>

