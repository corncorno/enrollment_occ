<?php
// Admin class for admin/registrar operations

class Admin {
    private $conn;
    
    public function __construct() {
        $database = new Database();
        $this->conn = $database->getConnection();
    }
    
    public function login($email, $password) {
        try {
            $sql = "SELECT id, admin_id, first_name, last_name, email, password, role, status FROM admins WHERE email = :email";
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':email', $email);
            $stmt->execute();
            
            if ($stmt->rowCount() == 1) {
                $admin = $stmt->fetch(PDO::FETCH_ASSOC);
                
                if ($admin['status'] !== 'active') {
                    return ['success' => false, 'message' => 'Account is not active. Please contact system administrator.'];
                }
                
                if (password_verify($password, $admin['password'])) {
                    $_SESSION['user_id'] = $admin['id'];
                    $_SESSION['admin_id'] = $admin['admin_id'];
                    $_SESSION['first_name'] = $admin['first_name'];
                    $_SESSION['last_name'] = $admin['last_name'];
                    $_SESSION['email'] = $admin['email'];
                    $_SESSION['role'] = 'admin';
                    $_SESSION['is_admin'] = true;
                    
                    return ['success' => true, 'user' => $admin];
                } else {
                    return ['success' => false, 'message' => 'Invalid password'];
                }
            } else {
                return ['success' => false, 'message' => 'Admin account not found'];
            }
            
        } catch(PDOException $e) {
            return ['success' => false, 'message' => 'Database error: ' . $e->getMessage()];
        }
    }
    
    public function getAdminById($admin_id) {
        try {
            $sql = "SELECT * FROM admins WHERE id = :admin_id";
            $stmt = $this->conn->prepare($sql);
            $stmt->bindParam(':admin_id', $admin_id);
            $stmt->execute();
            
            return $stmt->fetch(PDO::FETCH_ASSOC);
            
        } catch(PDOException $e) {
            return null;
        }
    }
    
    public function getAllAdmins() {
        try {
            $sql = "SELECT id, admin_id, first_name, last_name, email, phone, role, status, created_at FROM admins ORDER BY created_at DESC";
            $stmt = $this->conn->prepare($sql);
            $stmt->execute();
            
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
            
        } catch(PDOException $e) {
            return [];
        }
    }
    
    public function logout() {
        session_destroy();
        return true;
    }
}
?>

