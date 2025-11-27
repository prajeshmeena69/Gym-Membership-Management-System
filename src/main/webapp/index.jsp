<!-- index.jsp -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FitZone Gym - Transform Your Body, Transform Your Life</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* Custom Scrollbar - Purple Theme */
        ::-webkit-scrollbar {
            width: 12px;
        }

        ::-webkit-scrollbar-track {
            background: rgba(31, 41, 55, 0.4);
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 10px;
            border: 2px solid rgba(31, 41, 55, 0.4);
        }

        ::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(135deg, #7c8ef0 0%, #8b5cb8 100%);
            box-shadow: 0 0 10px rgba(102, 126, 234, 0.5);
        }

        /* For Firefox */
        html {
            scrollbar-width: thin;
            scrollbar-color: #667eea rgba(31, 41, 55, 0.4);
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: #ffffff;
            overflow-x: hidden;
            background: #0a0a0a;
        }

        /* Navigation */
        nav {
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
            padding: 20px 60px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(10, 10, 10, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }

        nav.scrolled {
            padding: 15px 60px;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.5);
            background: rgba(10, 10, 10, 0.98);
        }

        .logo {
            font-size: 32px;
            font-weight: 900;
            background: linear-gradient(135deg, #667eea 0%, #f093fb 50%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -1px;
            display: flex;
            align-items: center;
            gap: 10px;
            text-shadow: 0 0 30px rgba(102, 126, 234, 0.5);
        }

        .nav-links {
            display: flex;
            gap: 40px;
            align-items: center;
        }

        .nav-links a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s;
            position: relative;
        }

        .nav-links a:hover {
            color: #ffffff;
        }

        .nav-links a::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 0;
            height: 2px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            transition: width 0.3s;
        }

        .nav-links a:hover::after {
            width: 100%;
        }

        .auth-buttons {
            display: flex;
            gap: 15px;
        }

        .btn-signin, .btn-signup {
            padding: 12px 28px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 14px;
            text-decoration: none;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-signin {
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
            border: 2px solid rgba(255, 255, 255, 0.2);
        }

        .btn-signin:hover {
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(255, 255, 255, 0.1);
        }

        .btn-signup {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #ffffff;
            box-shadow: 0 4px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-signup:hover {
            box-shadow: 0 8px 30px rgba(102, 126, 234, 0.6);
            transform: translateY(-2px);
        }

        /* Hero Section */
        .hero {
            height: 100vh;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg,
                rgba(102, 126, 234, 0.3) 0%,
                rgba(118, 75, 162, 0.4) 50%,
                rgba(15, 12, 41, 0.8) 100%);
            z-index: 1;
        }

        .hero-background {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
            overflow: hidden;
        }

        .hero-background::before {
            content: '';
            position: absolute;
            width: 800px;
            height: 800px;
            background: radial-gradient(circle, rgba(102, 126, 234, 0.2) 0%, transparent 70%);
            border-radius: 50%;
            top: -200px;
            left: -200px;
            animation: float1 20s ease-in-out infinite;
        }

        .hero-background::after {
            content: '';
            position: absolute;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(118, 75, 162, 0.2) 0%, transparent 70%);
            border-radius: 50%;
            bottom: -150px;
            right: -150px;
            animation: float2 25s ease-in-out infinite;
        }

        @keyframes backgroundFloat {
            0%, 100% { transform: scale(1) rotate(0deg); }
            50% { transform: scale(1.05) rotate(1deg); }
        }

        @keyframes float1 {
            0%, 100% { transform: translate(0, 0); }
            50% { transform: translate(100px, 100px); }
        }

        @keyframes float2 {
            0%, 100% { transform: translate(0, 0); }
            50% { transform: translate(-100px, -100px); }
        }

        /* Additional decorative circles for richer background */
        .hero::after {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(240, 147, 251, 0.15) 0%, transparent 60%);
            border-radius: 50%;
            top: 50%;
            right: 10%;
            transform: translateY(-50%);
            z-index: 1;
            animation: float1 22s ease-in-out infinite reverse;
            pointer-events: none;
        }

        .hero-content {
            position: relative;
            z-index: 2;
            text-align: center;
            max-width: 900px;
            padding: 0 40px;
            animation: fadeInUp 1s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .hero-subtitle {
            font-size: 18px;
            font-weight: 600;
            color: #f093fb;
            text-transform: uppercase;
            letter-spacing: 3px;
            margin-bottom: 20px;
            animation: fadeInUp 1s ease-out 0.2s backwards;
        }

        .hero-title {
            font-size: 72px;
            font-weight: 900;
            line-height: 1.1;
            margin-bottom: 25px;
            background: linear-gradient(135deg, #ffffff 0%, #e0e0e0 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: fadeInUp 1s ease-out 0.4s backwards;
            text-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }

        .hero-description {
            font-size: 20px;
            color: rgba(255, 255, 255, 0.8);
            line-height: 1.6;
            margin-bottom: 40px;
            animation: fadeInUp 1s ease-out 0.6s backwards;
        }

        .hero-cta {
            display: flex;
            gap: 20px;
            justify-content: center;
            animation: fadeInUp 1s ease-out 0.8s backwards;
        }

        .btn-primary, .btn-secondary {
            padding: 18px 40px;
            border-radius: 14px;
            font-weight: 700;
            font-size: 16px;
            text-decoration: none;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #ffffff;
            box-shadow: 0 8px 30px rgba(102, 126, 234, 0.5);
        }

        .btn-primary:hover {
            box-shadow: 0 12px 40px rgba(102, 126, 234, 0.7);
            transform: translateY(-3px);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
            border: 2px solid rgba(255, 255, 255, 0.3);
            backdrop-filter: blur(10px);
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(255, 255, 255, 0.5);
            transform: translateY(-3px);
        }

        /* Features Section */
        .features {
            padding: 120px 60px;
            background: linear-gradient(180deg, #0a0a0a 0%, #1a1a2e 100%);
            position: relative;
        }

        .section-header {
            text-align: center;
            margin-bottom: 80px;
        }

        .section-subtitle {
            font-size: 16px;
            font-weight: 600;
            color: #f093fb;
            text-transform: uppercase;
            letter-spacing: 2px;
            margin-bottom: 15px;
        }

        .section-title {
            font-size: 48px;
            font-weight: 900;
            margin-bottom: 20px;
            background: linear-gradient(135deg, #ffffff 0%, #e0e0e0 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .section-description {
            font-size: 18px;
            color: rgba(255, 255, 255, 0.7);
            max-width: 700px;
            margin: 0 auto;
            line-height: 1.6;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 40px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .feature-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 40px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            opacity: 0;
            transition: opacity 0.3s;
        }

        .feature-card:hover::before {
            opacity: 1;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 60px rgba(102, 126, 234, 0.3);
            border-color: rgba(102, 126, 234, 0.5);
        }

        .feature-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            margin-bottom: 25px;
            position: relative;
            z-index: 1;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        }

        .feature-title {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 15px;
            position: relative;
            z-index: 1;
        }

        .feature-description {
            font-size: 16px;
            color: rgba(255, 255, 255, 0.7);
            line-height: 1.6;
            position: relative;
            z-index: 1;
        }

        /* Stats Section */
        .stats {
            padding: 100px 60px;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            position: relative;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 60px;
            max-width: 1200px;
            margin: 0 auto;
            text-align: center;
        }

        .stat-item {
            animation: fadeInUp 1s ease-out;
            transition: transform 0.3s;
        }

        .stat-item:hover {
            transform: translateY(-10px);
        }

        .stat-number {
            font-size: 64px;
            font-weight: 900;
            background: linear-gradient(135deg, #667eea 0%, #f093fb 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
            text-shadow: 0 0 30px rgba(102, 126, 234, 0.5);
        }

        .stat-label {
            font-size: 18px;
            color: rgba(255, 255, 255, 0.8);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* CTA Section */
        .cta {
            padding: 120px 60px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .cta::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 500px;
            height: 500px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            animation: float 20s ease-in-out infinite;
        }

        .cta::after {
            content: '';
            position: absolute;
            bottom: -50%;
            left: -10%;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50%;
            animation: float 25s ease-in-out infinite reverse;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-50px) rotate(180deg); }
        }

        .cta-content {
            position: relative;
            z-index: 1;
            max-width: 800px;
            margin: 0 auto;
        }

        .cta h2 {
            font-size: 48px;
            font-weight: 900;
            margin-bottom: 25px;
            color: #ffffff;
        }

        .cta p {
            font-size: 20px;
            margin-bottom: 40px;
            color: rgba(255, 255, 255, 0.9);
            line-height: 1.6;
        }

        .cta .btn-primary {
            background: #ffffff;
            color: #667eea;
            display: inline-block;
        }

        .cta .btn-primary:hover {
            background: rgba(255, 255, 255, 0.95);
            transform: translateY(-3px) scale(1.05);
        }

        /* Footer */
        footer {
            padding: 60px 60px 30px;
            background: #0a0a0a;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .footer-content {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 60px;
            margin-bottom: 40px;
        }

        .footer-section h3 {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 20px;
            background: linear-gradient(135deg, #667eea 0%, #f093fb 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .footer-section p, .footer-section a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            line-height: 2;
            transition: color 0.3s;
            display: block;
        }

        .footer-section a:hover {
            color: #ffffff;
            padding-left: 5px;
        }

        .footer-bottom {
            text-align: center;
            padding-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.5);
            font-size: 14px;
        }

        /* Mobile Menu */
        .mobile-menu-toggle {
            display: none;
            flex-direction: column;
            gap: 6px;
            cursor: pointer;
        }

        .mobile-menu-toggle span {
            width: 28px;
            height: 3px;
            background: #ffffff;
            border-radius: 3px;
            transition: all 0.3s;
        }

        /* Responsive */
        @media (max-width: 768px) {
            nav {
                padding: 15px 20px;
            }

            .nav-links {
                display: none;
            }

            .mobile-menu-toggle {
                display: flex;
            }

            .auth-buttons {
                gap: 10px;
            }

            .btn-signin, .btn-signup {
                padding: 10px 20px;
                font-size: 13px;
            }

            .hero-title {
                font-size: 42px;
            }

            .hero-description {
                font-size: 16px;
            }

            .hero-cta {
                flex-direction: column;
                align-items: center;
            }

            .btn-primary, .btn-secondary {
                width: 100%;
                max-width: 300px;
            }

            .section-title {
                font-size: 36px;
            }

            .features, .stats, .cta {
                padding: 60px 20px;
            }

            footer {
                padding: 40px 20px 20px;
            }

            .cta h2 {
                font-size: 32px;
            }

            .stat-number {
                font-size: 48px;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav id="navbar">
        <div class="logo">💪 FITZONE</div>
        <div class="nav-links">
            <a href="#home">Home</a>
            <a href="#features">Features</a>
            <a href="#contact">Contact</a>
        </div>
        <div class="auth-buttons">
            <a href="login.jsp" class="btn-signin">Sign In</a>
            <a href="register.jsp" class="btn-signup">Sign Up</a>
        </div>
        <div class="mobile-menu-toggle">
            <span></span>
            <span></span>
            <span></span>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero" id="home">
        <div class="hero-background"></div>
        <div class="hero-content">
            <div class="hero-subtitle">Welcome to FitZone</div>
            <h1 class="hero-title">Transform Your Body, Transform Your Life</h1>
            <p class="hero-description">
                Join our state-of-the-art fitness center and experience personalized training,
                advanced equipment, and a supportive community that will help you achieve your fitness goals.
            </p>
            <div class="hero-cta">
                <a href="register.jsp" class="btn-primary">Get Started Today</a>
                <a href="#features" class="btn-secondary">Explore Features</a>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features" id="features">
        <div class="section-header">
            <div class="section-subtitle">Why Choose Us</div>
            <h2 class="section-title">Premium Features & Benefits</h2>
            <p class="section-description">
                Experience world-class facilities and comprehensive tools designed to help you succeed
            </p>
        </div>

        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">📊</div>
                <h3 class="feature-title">Smart Dashboard</h3>
                <p class="feature-description">
                    Track your progress with an intuitive dashboard that shows attendance, membership status, and performance metrics in real-time.
                </p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">✅</div>
                <h3 class="feature-title">Easy Attendance Tracking</h3>
                <p class="feature-description">
                    Mark your attendance effortlessly and keep track of your workout consistency with our streamlined check-in system.
                </p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">📅</div>
                <h3 class="feature-title">Flexible Membership Plans</h3>
                <p class="feature-description">
                    Choose from monthly, quarterly, half-yearly, or annual plans that fit your schedule and budget perfectly.
                </p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">👥</div>
                <h3 class="feature-title">Expert Trainers</h3>
                <p class="feature-description">
                    Work with certified professionals who create personalized workout plans tailored to your fitness goals.
                </p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">🏋️</div>
                <h3 class="feature-title">Premium Equipment</h3>
                <p class="feature-description">
                    Access state-of-the-art fitness equipment and facilities maintained to the highest standards.
                </p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">📱</div>
                <h3 class="feature-title">24/7 Access</h3>
                <p class="feature-description">
                    Manage your membership, view records, and update your profile anytime, anywhere through our platform.
                </p>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats">
        <div class="stats-grid">
            <div class="stat-item">
                <div class="stat-number">5000+</div>
                <div class="stat-label">Active Members</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">50+</div>
                <div class="stat-label">Expert Trainers</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">100+</div>
                <div class="stat-label">Fitness Programs</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">98%</div>
                <div class="stat-label">Success Rate</div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta">
        <div class="cta-content">
            <h2>Ready to Start Your Fitness Journey?</h2>
            <p>Join thousands of members who have transformed their lives. Sign up today and get your first week free!</p>
            <a href="register.jsp" class="btn-primary">Join Now - Free Trial</a>
        </div>
    </section>

    <!-- Footer -->
    <footer id="contact">
        <div class="footer-content">
            <div class="footer-section">
                <h3>💪 FITZONE</h3>
                <p>Transform your body and mind with our comprehensive fitness management system and world-class facilities.</p>
            </div>
            <div class="footer-section">
                <h3>Quick Links</h3>
                <a href="#home">Home</a>
                <a href="#features">Features</a>
                <a href="register.jsp">Sign Up</a>
                <a href="login.jsp">Sign In</a>
            </div>
            <div class="footer-section">
                <h3>Contact Us</h3>
                <p>📧 info@fitzone.com</p>
                <p>📞 +91 1234567890</p>
                <p>📍 123 Fitness Street, Delhi</p>
            </div>
            <div class="footer-section">
                <h3>Hours</h3>
                <p>Monday - Friday: 5am - 11pm</p>
                <p>Saturday - Sunday: 6am - 10pm</p>
                <p>24/7 Member Portal Access</p>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2024 FitZone Gym Management System. All rights reserved.</p>
        </div>
    </footer>

    <script>
        // Navbar scroll effect
        window.addEventListener('scroll', () => {
            const navbar = document.getElementById('navbar');
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });

        // Smooth scroll for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Intersection Observer for fade-in animations
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -100px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        // Observe all feature cards and stat items
        document.querySelectorAll('.feature-card, .stat-item').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(30px)';
            el.style.transition = 'all 0.6s ease-out';
            observer.observe(el);
        });
    </script>
</body>
</html>