# 💪 Gym Membership Management System

A comprehensive web-based Gym Management System built with JSP, JDBC, and MySQL. This system provides separate portals for gym members and administrators to manage memberships, track attendance, and monitor gym operations efficiently.

## 📋 Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Prerequisites](#prerequisites)
- [Installation & Setup](#installation--setup)
- [Database Configuration](#database-configuration)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Contributing](#contributing)

## ✨ Features

### 👤 User Portal
- **User Registration & Authentication**: Secure signup and login system
- **Personal Dashboard**: View personalized statistics and membership information
- **Attendance Management**: Mark daily gym attendance
- **Profile Management**: View and update personal information
- **Membership Tracking**: Monitor active membership plans and status

### 🔐 Admin Portal
- **Admin Dashboard**: Overview of gym operations with real-time statistics
- **User Management**: 
  - View all registered members
  - Edit user information
  - Delete user accounts
- **Membership Management**: 
  - Create and manage membership plans
  - Track active/inactive memberships
  - Update membership status
- **Attendance Monitoring**: 
  - View attendance records
  - Track daily attendance statistics
  - Generate attendance reports

### 🎨 UI/UX Features
- Modern glassmorphism design with gradient overlays
- Responsive layout for all screen sizes
- Interactive animations and transitions
- Dark theme with purple gradient accents
- Intuitive navigation and user-friendly interface

## 🛠️ Technologies Used

### Backend
- **JSP (JavaServer Pages)**: Server-side rendering and business logic
- **JDBC (Java Database Connectivity)**: Database interaction
- **MySQL**: Relational database management
- **Java 8+**: Core programming language

### Frontend
- **HTML5**: Semantic markup
- **CSS3**: Modern styling with animations
  - Flexbox & Grid layouts
  - CSS animations and transitions
  - Glassmorphism effects
- **JavaScript**: Client-side interactivity

### Development Tools
- **Apache Tomcat**: Web server and servlet container
- **Maven**: Build automation and dependency management
- **IntelliJ IDEA**: Integrated Development Environment
- **MySQL Workbench**: Database design and management

## 📦 Prerequisites

Before running this project, ensure you have the following installed:

1. **Java Development Kit (JDK) 8 or higher**
   ```bash
   java -version
   ```

2. **Apache Tomcat 9.x or higher**
   - Download from Apache Tomcat Official Website

3. **MySQL Server 8.x or higher**
   ```bash
   mysql --version
   ```

4. **Maven 3.x**
   ```bash
   mvn -version
   ```

5. **MySQL JDBC Driver**
   - Add to your project dependencies or download from MySQL Connector/J official website

## 🚀 Installation & Setup

### Step 1: Download or Clone the Repository

Download the project or clone it from your GitHub repository.

```bash
cd gym-management-system
```

### Step 2: Database Setup

1. **Create Database**
   ```sql
   CREATE DATABASE gym_management;
   USE gym_management;
   ```

2. **Create Tables**

   ```sql
   -- Users Table
   CREATE TABLE users (
       id INT AUTO_INCREMENT PRIMARY KEY,
       name VARCHAR(100) NOT NULL,
       mobile VARCHAR(15) NOT NULL,
       email VARCHAR(100) UNIQUE NOT NULL,
       address TEXT,
       password VARCHAR(255) NOT NULL,
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );

   -- Admin Table
   CREATE TABLE admin (
       admin_id INT AUTO_INCREMENT PRIMARY KEY,
       name VARCHAR(100) NOT NULL,
       email VARCHAR(100) UNIQUE NOT NULL,
       password VARCHAR(255) NOT NULL,
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );

   -- Membership Table
   CREATE TABLE membership (
       membership_id INT AUTO_INCREMENT PRIMARY KEY,
       user_id INT NOT NULL,
       plan_name VARCHAR(100) NOT NULL,
       duration VARCHAR(50) NOT NULL,
       amount DECIMAL(10,2) NOT NULL,
       start_date DATE NOT NULL,
       end_date DATE NOT NULL,
       status ENUM('Active', 'Inactive') DEFAULT 'Active',
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
   );

   -- Attendance Table
   CREATE TABLE attendance (
       attendance_id INT AUTO_INCREMENT PRIMARY KEY,
       user_id INT NOT NULL,
       date DATE NOT NULL,
       time TIME NOT NULL,
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
       UNIQUE KEY unique_attendance (user_id, date)
   );
   ```

3. **Insert Sample Admin Account**
   ```sql
   INSERT INTO admin (name, email, password) 
   VALUES ('Admin', 'admin@gym.com', 'admin123');
   ```

### Step 3: Configure Database Connection

Update the database credentials in `src/main/java/com/gym/database/DBConnect.java`:

```java
private static final String URL = "jdbc:mysql://localhost:3306/gym_management";
private static final String USERNAME = "root";
private static final String PASSWORD = "your_mysql_password";
```

### Step 4: Build and Deploy

1. **Using Maven**
   ```bash
   mvn clean install
   ```

2. **Deploy to Tomcat**
   - Copy the generated WAR file from `target/` to Tomcat's `webapps/` directory
   - Or configure IntelliJ IDEA to run with Tomcat directly

3. **Start Tomcat Server**
   ```bash
   # On Windows
   catalina.bat run
   
   # On Linux/Mac
   catalina.sh run
   ```

### Step 5: Access the Application

- **User Portal**: `http://localhost:8080/gym-management/login.jsp`
- **Registration**: `http://localhost:8080/gym-management/register.jsp`

**Default Admin Credentials:**
- Email: `admin@gym.com`
- Password: `admin123`

## 📁 Project Structure

```
Gym Membership Management System/
├── .idea/                          # IntelliJ IDEA configuration
├── .mvn/                           # Maven wrapper files
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── gym/
│       │           └── database/
│       │               └── DBConnect.java    # Database connection utility
│       ├── resources/                        # Configuration files
│       └── webapp/
│           ├── assets/
│           │   └── style.css                 # Main stylesheet
│           ├── images/
│           │   └── gym-background.jpg        # Background image
│           └── WEB-INF/
│               ├── admin_dashboard.jsp       # Admin main dashboard
│               ├── admin_delete_user.jsp     # Delete user functionality
│               ├── admin_edit_user.jsp       # Edit user information
│               ├── admin_manage_membership.jsp  # Membership management
│               ├── admin_manage_users.jsp    # User management
│               ├── admin_view_attendance.jsp # Attendance records
│               ├── attendance.jsp            # Mark attendance
│               ├── dashboard.jsp             # User dashboard
│               ├── delete_user.jsp           # User account deletion
│               ├── edit_member.jsp           # Edit member profile
│               ├── index.jsp                 # Landing page
│               ├── login.jsp                 # Login page
│               ├── logout.jsp                # Logout handler
│               ├── register.jsp              # User registration
│               └── view_records.jsp          # View user records
├── target/                                   # Compiled files
├── .gitignore                                # Git ignore rules
├── pom.xml                                   # Maven configuration
└── README.md                                 # Project documentation
```

## 🎯 Usage

### For Users

1. **Registration**
   - Navigate to the registration page
   - Fill in: Name, Mobile, Email, Address, Password
   - Click "Register Now"

2. **Login**
   - Select "User Login"
   - Enter your email and password
   - Access your personal dashboard

3. **Mark Attendance**
   - Go to "Mark Attendance" from dashboard
   - Click "Mark Present" button
   - Attendance is recorded with date and time

4. **View Profile**
   - Access "My Profile" to view personal information
   - View attendance history and membership details

### For Administrators

1. **Login**
   - Select "Admin Login"
   - Enter admin credentials
   - Access admin dashboard

2. **Manage Users**
   - View all registered members
   - Edit user information
   - Delete user accounts (removes all associated data)

3. **Manage Memberships**
   - Create new membership plans
   - Update membership status (Active/Inactive)
   - Track membership duration and amounts

4. **View Attendance**
   - Monitor daily attendance
   - View attendance statistics
   - Track member participation

## 🔒 Security Considerations

⚠️ **Important Security Notes:**

This project is intended for educational purposes. Before deploying to production:

1. **Password Security**: Implement password hashing (BCrypt, PBKDF2)
   ```java
   // Don't store plain text passwords!
   // Use: BCrypt.hashpw(password, BCrypt.gensalt())
   ```

2. **SQL Injection**: Always use PreparedStatements (already implemented)
3. **Session Management**: Add session timeout and CSRF protection
4. **Input Validation**: Add server-side validation for all inputs
5. **HTTPS**: Deploy with SSL/TLS encryption
6. **Authentication**: Consider using frameworks like Spring Security

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. **Commit your changes**
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/AmazingFeature
   ```
5. **Open a Pull Request**

### Contribution Guidelines
- Follow existing code style and conventions
- Add comments for complex logic
- Test thoroughly before submitting
- Update documentation as needed

## 🐛 Known Issues

- Password reset functionality not implemented
- Email notifications not configured
- Advanced reporting features pending
- Mobile app version not available

## 🔮 Future Enhancements

- [ ] Password reset via email
- [ ] Advanced analytics dashboard
- [ ] Payment gateway integration
- [ ] QR code-based attendance
- [ ] Trainer management module
- [ ] Workout plan assignments
- [ ] Push notifications
- [ ] Mobile application (Android/iOS)
- [ ] RESTful API development

## 👨‍💻 Author

**Prajesh Singh Meena**
- GitHub: https://github.com/prajeshmeena69
- LinkedIn: www.linkedin.com/in/prajesh-singh-meena-607437327

## 🙏 Acknowledgments

- Inspired by modern gym management needs
- UI design influenced by glassmorphism trends
- Community feedback and contributions

---

⭐ **Star this repository if you find it helpful!**

📫 **For questions or feedback, please open an issue on GitHub.**

---

**Built with ❤️ using JSP, JDBC, and MySQL**
