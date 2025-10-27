<?php
// Database configuration will be included by the calling file

class User {
    private $conn;
    
    public function __construct() {
        $database = new Database();
        $this->conn = $database->getConnection();
    }
    
    public function register($data) {
        try {
            $sql = "INSERT INTO users (student_id, first_name, last_name, email, password, phone, date_of_birth, address, status) 
                    VALUES (:student_id, :first_name, :last_name, :email, :password, :phone, :date_of_birth, :address, 'active')";
            
            $stmt = $this->conn->prepare($sql);
            
            $student_id = generateStudentId();
            $hashed_password = hashPassword($data['password']);
            
            $stmt->bindParam(':student_id', $student_id);
            $stmt->bindParam(':first_name', $data['first_name']);
            $stmt->bindParam(':last_name', $data['last_name']);
            $stmt->bindParam(':email', $data['email']);
            $stmt->bindParam(':password', $hashed_password);
            $stmt->bindParam(':phone', $data['phone']);
            $stmt->bindParam(':date_of_birth', $data['date_of_birth']);
            $stmt->bindParam(':address', $data['address']);
            
            if ($stmt->execute()) {
                return ['success' => true, 'student_id' => $student_id];
            }
            
            return ['success' => false, 'message' => 'Registration failed'];
            
        } catch(PDOException $e) {
            if ($e->getCode() == 23000) {
                return ['success' => false, 'message' => 'Email already exists'];
            }
            return ['success' => false, 'message' => 'Database error: ' . $e->getMessage()];
        }
    }
    
    public function login($email, $password) {
        try {
            $sql = "SELECT id, student_id, first_name, last_name, email, password, status FROM users WHERE email = :email";
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':email', $email);
            $stmt->execute();
            
            if ($stmt->rowCount() == 1) {
                $user = $stmt->fetch(PDO::FETCH_ASSOC);
                
                if ($user['status'] !== 'active') {
                    return ['success' => false, 'message' => 'Account is not active. Please contact administration.'];
                }
                
                if (verifyPassword($password, $user['password'])) {
                    $_SESSION['user_id'] = $user['id'];
                    $_SESSION['student_id'] = $user['student_id'];
                    $_SESSION['first_name'] = $user['first_name'];
                    $_SESSION['last_name'] = $user['last_name'];
                    $_SESSION['email'] = $user['email'];
                    $_SESSION['role'] = 'student';
                    $_SESSION['is_admin'] = false;
                    
                    return ['success' => true, 'user' => $user];
                } else {
                    return ['success' => false, 'message' => 'Invalid password'];
                }
            } else {
                return ['success' => false, 'message' => 'Student account not found'];
            }
            
        } catch(PDOException $e) {
            return ['success' => false, 'message' => 'Database error: ' . $e->getMessage()];
        }
    }
    
    public function getAllUsers() {
        try {
            $sql = "SELECT id, student_id, first_name, last_name, email, phone, status, enrollment_status, created_at FROM users ORDER BY created_at DESC";
            $stmt = $this->conn->prepare($sql);
            $stmt->execute();
            
            // Add 'role' field for compatibility (all users are students)
            $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
            foreach ($users as &$user) {
                $user['role'] = 'student';
            }
            
            return $users;
            
        } catch(PDOException $e) {
            return [];
        }
    }
    
    public function updateUserStatus($user_id, $status) {
        try {
            $sql = "UPDATE users SET status = :status WHERE id = :user_id";
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':status', $status);
            $stmt->bindParam(':user_id', $user_id);
            
            return $stmt->execute();
            
        } catch(PDOException $e) {
            return false;
        }
    }
    
    public function getUserById($user_id) {
        try {
            $sql = "SELECT * FROM users WHERE id = :user_id";
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':user_id', $user_id);
            $stmt->execute();
            
            return $stmt->fetch(PDO::FETCH_ASSOC);
            
        } catch(PDOException $e) {
            return null;
        }
    }
    
    public function logout() {
        session_destroy();
        return true;
    }
}
?>
