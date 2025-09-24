
-- 1. DATABASE INITIALIZATION

DROP DATABASE IF EXISTS student_records_db;
CREATE DATABASE student_records_db;
USE student_records_db;

-- 2. USER MANAGEMENT AND ACCESS CONTROL STRUCTURES

-- Roles Table
CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);
CREATE INDEX idx_role_name ON roles(role_name);

-- Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Active', 'Inactive') DEFAULT 'Active'
);
CREATE INDEX idx_username ON users(username);
CREATE INDEX idx_email ON users(email);

-- User Roles
CREATE TABLE user_roles (
    user_role_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE,
    UNIQUE(user_id, role_id)
);
CREATE INDEX idx_user_roles_user ON user_roles(user_id);
CREATE INDEX idx_user_roles_role ON user_roles(role_id);

-- Audit Logs
CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    action VARCHAR(255) NOT NULL,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
CREATE INDEX idx_audit_user ON audit_logs(user_id);

-- Privileges
CREATE TABLE privileges (
    privilege_id INT AUTO_INCREMENT PRIMARY KEY,
    privilege_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);
CREATE INDEX idx_privilege_name ON privileges(privilege_name);

-- Role Privileges
CREATE TABLE role_privileges (
    role_privilege_id INT AUTO_INCREMENT PRIMARY KEY,
    role_id INT NOT NULL,
    privilege_id INT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE,
    FOREIGN KEY (privilege_id) REFERENCES privileges(privilege_id) ON DELETE CASCADE,
    UNIQUE(role_id, privilege_id)
);
CREATE INDEX idx_role_priv_role ON role_privileges(role_id);
CREATE INDEX idx_role_priv_priv ON role_privileges(privilege_id);

-- 3. ACADEMIC STRUCTURE

-- Schools
CREATE TABLE schools (
    school_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    type ENUM('Public', 'Private') NOT NULL,
    location VARCHAR(255),
    established_year YEAR,
    language_of_instruction ENUM('Kinyarwanda', 'English', 'French', 'Mixed') DEFAULT 'Mixed'
);
CREATE INDEX idx_school_name ON schools(name);

-- Programs
CREATE TABLE programs (
    program_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    level ENUM('Pre-Primary', 'Primary', 'Ordinary Level', 'Advanced Level', 'Tertiary') NOT NULL,
    duration_years INT NOT NULL,
    school_id INT NOT NULL,
    FOREIGN KEY (school_id) REFERENCES schools(school_id) ON DELETE CASCADE
);
CREATE INDEX idx_program_name ON programs(name);
CREATE INDEX idx_program_school ON programs(school_id);

-- Students
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') DEFAULT 'Other',
    nationality VARCHAR(100) DEFAULT 'Rwandan',
    school_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    status ENUM('Active', 'Graduated', 'Transferred', 'Dropped Out') DEFAULT 'Active',
    FOREIGN KEY (school_id) REFERENCES schools(school_id) ON DELETE CASCADE
);
CREATE INDEX idx_student_name ON students(last_name, first_name);
CREATE INDEX idx_student_school ON students(school_id);

-- Student Profiles
CREATE TABLE student_profiles (
    student_id INT PRIMARY KEY,
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    phone VARCHAR(20),
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);
CREATE INDEX idx_student_profile_city ON student_profiles(city);

-- Enrollments
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    program_id INT NOT NULL,
    start_year YEAR NOT NULL,
    end_year YEAR,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (program_id) REFERENCES programs(program_id) ON DELETE CASCADE,
    UNIQUE(student_id, program_id)
);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_program ON enrollments(program_id);

-- Courses
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    program_id INT NOT NULL,
    credits TINYINT NOT NULL DEFAULT 3,
    FOREIGN KEY (program_id) REFERENCES programs(program_id) ON DELETE CASCADE,
    UNIQUE(name, program_id)
);
CREATE INDEX idx_course_name ON courses(name);
CREATE INDEX idx_course_program ON courses(program_id);

-- Class Sections
CREATE TABLE class_sections (
    section_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    year YEAR NOT NULL,
    term ENUM('Term 1', 'Term 2', 'Term 3') NOT NULL,
    teacher_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);
CREATE INDEX idx_class_course ON class_sections(course_id);

-- Course Enrollments
CREATE TABLE course_enrollments (
    course_enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    section_id INT NOT NULL,
    grade VARCHAR(2),
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES class_sections(section_id) ON DELETE CASCADE,
    UNIQUE(enrollment_id, section_id)
);
CREATE INDEX idx_course_enrollment ON course_enrollments(enrollment_id);
CREATE INDEX idx_course_section ON course_enrollments(section_id);

-- 4. SAMPLE DATA WITH TRANSACTION CONTROL AND SAVEPOINTS

START TRANSACTION;

-- Roles
SAVEPOINT before_roles;
INSERT INTO roles (role_name, description) VALUES
('Admin', 'Full access to manage the system'),
('Teacher', 'Can manage courses, sections, and grades'),
('Staff', 'Can manage student profiles and enrollments');

-- Users
SAVEPOINT before_users;
INSERT INTO users (username, password_hash, full_name, email) VALUES
('admin', 'plp@2025', 'System Administrator', 'admin@mineduc.rw'),
('teacher_Umulisa', 'teacher@123', 'Mrs. Umulisa', 'teacher_Umulisa@mineduc.rw'),
('staff_Christa', 'staff@123', 'Mrs. Christa', 'staff_Christa@mineduc.rw');

-- User Roles
SAVEPOINT before_user_roles;
INSERT INTO user_roles (user_id, role_id) VALUES
(1, 1), (2, 2), (3, 3);

-- Privileges
SAVEPOINT before_privileges;
INSERT INTO privileges (privilege_name, description) VALUES
('manage_students', 'Create, update, and view student records'),
('manage_courses', 'Create, update, and view courses'),
('manage_enrollments', 'Manage student enrollments'),
('manage_grades', 'Record and update student grades'),
('manage_users', 'Create and manage system users'),
('view_reports', 'Access reports and analytics');

-- Assign Privileges
SAVEPOINT before_role_privileges;
INSERT INTO role_privileges (role_id, privilege_id)
SELECT 1, privilege_id FROM privileges;

INSERT INTO role_privileges (role_id, privilege_id)
SELECT 2, privilege_id FROM privileges
WHERE privilege_name IN ('manage_courses','manage_grades','view_reports');

INSERT INTO role_privileges (role_id, privilege_id)
SELECT 3, privilege_id FROM privileges
WHERE privilege_name IN ('manage_students','manage_enrollments','view_reports');

-- Schools
SAVEPOINT before_schools;
INSERT INTO schools (name, type, location, established_year, language_of_instruction) VALUES
('King David International School', 'Private', 'Kigali', 2010, 'English'),
('Gisagara Secondary School', 'Public', 'Gisagara', 1995, 'Kinyarwanda');

-- Programs
SAVEPOINT before_programs;
INSERT INTO programs (name, level, duration_years, school_id) VALUES
('Primary Education', 'Primary', 6, 2),
('Ordinary Level Education', 'Ordinary Level', 3, 2),
('Advanced Level Education', 'Advanced Level', 3, 2);

-- Students
SAVEPOINT before_students;
INSERT INTO students (first_name, last_name, dob, gender, school_id, enrollment_date) VALUES
('Orlando Houston', 'BUCYEDUSENGE', '1996-06-20', 'Male', 1, '2011-09-01'),
('Jeanne', 'Uwineza', '2004-08-22', 'Female', 2, '2011-10-11');

-- Profiles
SAVEPOINT before_profiles;
INSERT INTO student_profiles (student_id, address_line1, city, phone, emergency_contact_name, emergency_contact_phone) VALUES
(1, 'KK356ST', 'Kigali', '+250788123456', 'Orlando Houston BUCYEDUSENGE', '+250780893634'),
(2, 'KG601Ave', 'Gisagara', '+250788987654', 'Jeanne Uwineza', '+250788321654');

-- Enrollments
SAVEPOINT before_enrollments;
INSERT INTO enrollments (student_id, program_id, start_year, end_year) VALUES
(1, 1, 2011, 2017),
(2, 1, 2010, 2016);

-- Courses
SAVEPOINT before_courses;
INSERT INTO courses (name, program_id, credits) VALUES
('Mathematics', 1, 4),
('English Language', 1, 3),
('Physics', 2, 4);

-- Sections
SAVEPOINT before_sections;
INSERT INTO class_sections (course_id, year, term, teacher_name) VALUES
(1, 2016, 'Term 1', 'Mr. Hakizimana'),
(2, 2016, 'Term 1', 'Mrs. Uwase'),
(3, 2016, 'Term 1', 'Mr. Niyonzima');

-- Course Enrollments
SAVEPOINT before_course_enrollments;
INSERT INTO course_enrollments (enrollment_id, section_id, grade) VALUES
(1, 1, 'A'),
(1, 2, 'B+'),
(2, 1, 'B');

COMMIT;

-- 5. DATA CONTROL LANGUAGE (DCL)  USER CREATION

-- Create DB Users safely (avoid error 1396)
DROP USER IF EXISTS 'admin_user'@'localhost';
DROP USER IF EXISTS 'teacher_user'@'localhost';
DROP USER IF EXISTS 'staff_user'@'localhost';

CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'Admin#2025';
CREATE USER 'teacher_user'@'localhost' IDENTIFIED BY 'Teach#2025';
CREATE USER 'staff_user'@'localhost' IDENTIFIED BY 'Staff#2025';

-- Grant Privileges
GRANT ALL PRIVILEGES ON student_records_db.* TO 'admin_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON student_records_db.* TO 'teacher_user'@'localhost';
GRANT SELECT, INSERT ON student_records_db.students TO 'staff_user'@'localhost';

FLUSH PRIVILEGES;
