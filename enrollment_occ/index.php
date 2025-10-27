<?php
require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/classes/User.php';

// Redirect if already logged in
if (isLoggedIn()) {
    if (isAdmin()) {
        redirect('admin/dashboard.php');
    } else {
        redirect('student/dashboard.php');
    }
}

$error_message = '';
$success_message = '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = [
        'first_name' => sanitizeInput($_POST['first_name']),
        'last_name' => sanitizeInput($_POST['last_name']),
        'email' => sanitizeInput($_POST['email']),
        'password' => $_POST['password'],
        'confirm_password' => $_POST['confirm_password'],
        'phone' => sanitizeInput($_POST['phone']),
        'date_of_birth' => $_POST['date_of_birth'],
        'address' => sanitizeInput($_POST['address'])
    ];
    
    // Validation
    if (empty($data['first_name']) || empty($data['last_name']) || empty($data['email']) || empty($data['password'])) {
        $error_message = 'Please fill in all required fields';
    } elseif ($data['password'] !== $data['confirm_password']) {
        $error_message = 'Passwords do not match';
    } elseif (strlen($data['password']) < 6) {
        $error_message = 'Password must be at least 6 characters long';
    } else {
        $user = new User();
        $result = $user->register($data);
        
        if ($result['success']) {
            $success_message = 'Registration successful! Your Student ID is: ' . $result['student_id'] . '. You can now login with your email and password.';
        } else {
            $error_message = $result['message'];
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to <?php echo SITE_NAME; ?> - Enroll Today!</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Poppins', sans-serif;
        }
        
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><polygon fill="%23ffffff" fill-opacity="0.1" points="0,1000 1000,0 1000,1000"/></svg>');
            background-size: cover;
        }
        
        .hero-content {
            position: relative;
            z-index: 2;
        }
        
        .floating-shapes {
            position: absolute;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: 1;
        }
        
        .shape {
            position: absolute;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }
        
        .shape:nth-child(1) {
            width: 80px;
            height: 80px;
            top: 10%;
            left: 10%;
            animation-delay: 0s;
        }
        
        .shape:nth-child(2) {
            width: 120px;
            height: 120px;
            top: 20%;
            right: 10%;
            animation-delay: 2s;
        }
        
        .shape:nth-child(3) {
            width: 60px;
            height: 60px;
            bottom: 20%;
            left: 20%;
            animation-delay: 4s;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(10deg); }
        }
        
        .enrollment-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .welcome-text {
            color: white;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }
        
        .welcome-text h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            line-height: 1.2;
        }
        
        .welcome-text p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }
        
        .feature-icon {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 60px;
            height: 60px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            font-size: 1.5rem;
        }
        
        .btn-enroll-now {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            border-radius: 50px;
            padding: 15px 30px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }
        
        .btn-enroll-now:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.4);
        }
        
        .form-control {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
        }
        
        .stats-section {
            background: white;
            padding: 80px 0;
        }
        
        .stat-item {
            text-align: center;
            padding: 30px 20px;
            border-radius: 15px;
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
            transition: transform 0.3s ease;
        }
        
        .stat-item:hover {
            transform: translateY(-5px);
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 10px;
        }
        
        .login-link {
            color: white;
            text-decoration: none;
            font-weight: 600;
            padding: 10px 20px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 25px;
            transition: all 0.3s ease;
        }
        
        .login-link:hover {
            color: #667eea;
            background: white;
            text-decoration: none;
        }
        
        .section-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 3rem;
            text-align: center;
        }
        
        @media (max-width: 768px) {
            .welcome-text h1 {
                font-size: 2.5rem;
            }
            .hero-section {
                padding: 20px 0;
            }
        }
    </style>
</head>
<body>
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="floating-shapes">
            <div class="shape"></div>
            <div class="shape"></div>
            <div class="shape"></div>
        </div>
        
        <div class="container hero-content">
            <div class="row align-items-center">
                <!-- Welcome Content -->
                <div class="col-lg-6 mb-5 mb-lg-0">
                    <div class="welcome-text">
                        <h1><i class="fas fa-graduation-cap me-3"></i>Welcome to OCC</h1>
                        <p class="lead">Start your academic journey with us! Join thousands of students who have transformed their lives through quality education.</p>
                        
                        <div class="row g-4 mb-4">
                            <div class="col-md-6">
                                <div class="feature-icon">
                                    <i class="fas fa-star"></i>
                                </div>
                                <h5>Excellence in Education</h5>
                                <p class="mb-0 opacity-75">Top-rated courses and experienced faculty</p>
                            </div>
                            <div class="col-md-6">
                                <div class="feature-icon">
                                    <i class="fas fa-users"></i>
                                </div>
                                <h5>Vibrant Community</h5>
                                <p class="mb-0 opacity-75">Join a diverse and supportive student body</p>
                            </div>
                        </div>
                        
                        <div class="d-flex flex-wrap gap-3 align-items-center">
                            <button class="btn btn-enroll-now text-white" onclick="scrollToEnrollment()">
                                <i class="fas fa-rocket me-2"></i>Enroll Now
                            </button>
                            <a href="public/login.php" class="login-link">
                                <i class="fas fa-sign-in-alt me-2"></i>Already a Student? Login
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Stats -->
                <div class="col-lg-6">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="stat-item">
                                <div class="stat-number">500+</div>
                                <div class="text-muted">Active Students</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-item">
                                <div class="stat-number">50+</div>
                                <div class="text-muted">Courses</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-item">
                                <div class="stat-number">95%</div>
                                <div class="text-muted">Success Rate</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-item">
                                <div class="stat-number">4.8</div>
                                <div class="text-muted">Rating</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Enrollment Form Section -->
    <section id="enrollment-section" class="stats-section">
        <div class="container">
            <div class="section-title">
                <i class="fas fa-edit text-primary me-3"></i>Start Your Journey Today
            </div>
            
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="enrollment-card p-5">
                        <?php if ($error_message): ?>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <?php echo $error_message; ?>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <?php endif; ?>
                        
                        <?php if ($success_message): ?>
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                <?php echo $success_message; ?>
                                <hr>
                                <div class="d-flex gap-2">
                                    <a href="public/login.php" class="btn btn-success btn-sm">
                                        <i class="fas fa-sign-in-alt me-1"></i>Login Now
                                    </a>
                                    <button type="button" class="btn btn-outline-success btn-sm" onclick="location.reload()">
                                        <i class="fas fa-plus me-1"></i>Register Another Student
                                    </button>
                                </div>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <?php endif; ?>
                        
                        <div class="text-center mb-4">
                            <h3 class="text-primary mb-2">Student Enrollment Form</h3>
                            <p class="text-muted">Fill out the form below to create your student account and begin your academic journey with us.</p>
                        </div>
                        
                        <form method="POST" action="">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="first_name" class="form-label">
                                        <i class="fas fa-user me-1 text-primary"></i>First Name *
                                    </label>
                                    <input type="text" class="form-control" id="first_name" name="first_name" required
                                           value="<?php echo isset($_POST['first_name']) ? htmlspecialchars($_POST['first_name']) : ''; ?>"
                                           placeholder="Enter your first name">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="last_name" class="form-label">
                                        <i class="fas fa-user me-1 text-primary"></i>Last Name *
                                    </label>
                                    <input type="text" class="form-control" id="last_name" name="last_name" required
                                           value="<?php echo isset($_POST['last_name']) ? htmlspecialchars($_POST['last_name']) : ''; ?>"
                                           placeholder="Enter your last name">
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label">
                                    <i class="fas fa-envelope me-1 text-primary"></i>Email Address *
                                </label>
                                <input type="email" class="form-control" id="email" name="email" required
                                       value="<?php echo isset($_POST['email']) ? htmlspecialchars($_POST['email']) : ''; ?>"
                                       placeholder="Enter your email address">
                                <div class="form-text">We'll use this email for all important communications.</div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="password" class="form-label">
                                        <i class="fas fa-lock me-1 text-primary"></i>Password *
                                    </label>
                                    <input type="password" class="form-control" id="password" name="password" required
                                           placeholder="Create a secure password">
                                    <div class="form-text">Minimum 6 characters required.</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="confirm_password" class="form-label">
                                        <i class="fas fa-lock me-1 text-primary"></i>Confirm Password *
                                    </label>
                                    <input type="password" class="form-control" id="confirm_password" name="confirm_password" required
                                           placeholder="Confirm your password">
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">
                                        <i class="fas fa-phone me-1 text-primary"></i>Phone Number
                                    </label>
                                    <input type="tel" class="form-control" id="phone" name="phone"
                                           value="<?php echo isset($_POST['phone']) ? htmlspecialchars($_POST['phone']) : ''; ?>"
                                           placeholder="Your contact number">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="date_of_birth" class="form-label">
                                        <i class="fas fa-calendar me-1 text-primary"></i>Date of Birth
                                    </label>
                                    <input type="date" class="form-control" id="date_of_birth" name="date_of_birth"
                                           value="<?php echo isset($_POST['date_of_birth']) ? $_POST['date_of_birth'] : ''; ?>">
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label for="address" class="form-label">
                                    <i class="fas fa-map-marker-alt me-1 text-primary"></i>Address
                                </label>
                                <textarea class="form-control" id="address" name="address" rows="3"
                                          placeholder="Your full address"><?php echo isset($_POST['address']) ? htmlspecialchars($_POST['address']) : ''; ?></textarea>
                            </div>
                            
                            <div class="mb-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="terms" required>
                                    <label class="form-check-label" for="terms">
                                        I agree to the <a href="#" class="text-primary">Terms and Conditions</a> and <a href="#" class="text-primary">Privacy Policy</a> *
                                    </label>
                                </div>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-enroll-now text-white btn-lg">
                                    <i class="fas fa-user-plus me-2"></i>Complete Enrollment
                                </button>
                            </div>
                            
                            <div class="text-center mt-4">
                                <p class="mb-0 text-muted">Already have an account? 
                                    <a href="public/login.php" class="text-primary fw-bold text-decoration-none">Login here</a>
                                </p>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function scrollToEnrollment() {
            document.getElementById('enrollment-section').scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
        
        // Add some interactive effects
        document.addEventListener('DOMContentLoaded', function() {
            // Animate stats on scroll
            const statItems = document.querySelectorAll('.stat-item');
            
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };
            
            const observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.animation = 'fadeInUp 0.6s ease forwards';
                    }
                });
            }, observerOptions);
            
            statItems.forEach(item => {
                observer.observe(item);
            });
        });
        
        // Add CSS for animations
        const style = document.createElement('style');
        style.textContent = `
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>
