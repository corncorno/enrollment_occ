<?php
// Database configuration
class Database {
    private $host = 'localhost';
    private $db_name = 'enrollment_occ';
    private $username = 'root';  // Change this to your MySQL username
    private $password = '';      // Change this to your MySQL password
    private $conn;
    
    public function getConnection() {
        $this->conn = null;
        
        try {
            $this->conn = new PDO("mysql:host=" . $this->host . ";dbname=" . $this->db_name, 
                                $this->username, $this->password);
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch(PDOException $exception) {
            echo "Connection error: " . $exception->getMessage();
        }
        
        return $this->conn;
    }
}

// Session configuration
// Only configure and start session if one isn't already active
if (session_status() === PHP_SESSION_NONE) {
    // Enable multiple concurrent sessions in the same browser
    ini_set('session.use_only_cookies', 0);
    ini_set('session.use_trans_sid', 1);

    // Check if a session ID is passed via URL (for multi-session support)
    if (isset($_GET['session_id']) && !empty($_GET['session_id'])) {
        session_id($_GET['session_id']);
    } elseif (isset($_POST['session_id']) && !empty($_POST['session_id'])) {
        session_id($_POST['session_id']);
    }

    session_start();
}

// Store the current session ID for passing in URLs
define('CURRENT_SESSION_ID', session_id());

// Define constants
define('BASE_URL', 'http://localhost/enrollment_occ/');
define('SITE_NAME', 'OCC Enrollment System');

// Helper functions
function redirect($location) {
    // Add session ID to URL for multi-session support
    $separator = (strpos($location, '?') !== false) ? '&' : '?';
    $url = BASE_URL . $location . $separator . 'session_id=' . CURRENT_SESSION_ID;
    header("Location: " . $url);
    exit();
}

function isLoggedIn() {
    return isset($_SESSION['user_id']);
}

function isAdmin() {
    return isset($_SESSION['role']) && $_SESSION['role'] === 'admin';
}

function sanitizeInput($data) {
    return htmlspecialchars(strip_tags(trim($data)));
}

function generateStudentId() {
    return 'STU' . date('Y') . str_pad(rand(1, 9999), 4, '0', STR_PAD_LEFT);
}

function hashPassword($password) {
    return password_hash($password, PASSWORD_DEFAULT);
}

function verifyPassword($password, $hash) {
    return password_verify($password, $hash);
}
?>
