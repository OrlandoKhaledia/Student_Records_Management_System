# Student Records Management System

The **Student Records Management System** is a MySQL-based database designed to manage schools in Rwanda by storing and organizing essential data about students, courses, teachers, enrollments, and grades. It provides a complete backend structure with role-based access control and transactional support.

---

## Table of Contents
1. [Introduction](#introduction)
2. [What the Project Does](#what-the-project-does)
3. [Why the Project is Useful](#why-the-project-is-useful)
4. [Getting Started](#getting-started)
    - [Requirements](#requirements)
    - [Steps to Run](#steps-to-run-in-mysql-workbench)
5. [Project ERD](#project-erd-structure)
6. [Where Users Can Get Help](#where-users-can-get-help)
7. [Maintainers and Contributors](#maintainers-and-contributors)
8. [Notes](#notes)

---

## Introduction
This project is a **Student Records Management System** implemented entirely in **MySQL**. It provides a comprehensive backend database structure to manage:

- Students, schools, and programs  
- Courses and class sections  
- Enrollments and grades  
- Users, roles, and privileges  
- Audit logs for monitoring actions  

The system ensures proper access control, transactional safety, and role-based permissions for administrators, teachers, and staff.

---

## What the Project Does
- Stores detailed information about schools, programs, students, courses, and class sections.  
- Manages user accounts, roles, and role-based privileges.  
- Tracks student enrollments and course grades.  
- Provides audit logs to monitor user actions.  
- Supports transactional operations and savepoints to prevent data loss during insertions.  
- Implements role-based access control to ensure users only perform allowed actions.  

---

## Why the Project is Useful
- **Educational Institutions:** Helps schools and colleges maintain accurate records of students, courses, and grades.  
- **Role Management:** Ensures proper access control between administrators, teachers, and staff.  
- **Data Integrity:** Uses transactions, savepoints, and foreign key constraints to maintain consistent data.  
- **Scalability:** Easily extendable to include modules like reporting, attendance, and analytics.  

---

## Getting Started

### Requirements
- **MySQL Server 8.x** or higher  
- **MySQL Workbench** (or any MySQL client)  

### Steps to Run in MySQL Workbench
1. Open **MySQL Workbench** and connect to your MySQL server.  
2. Open a new **SQL Script** tab.  
3. Copy the full database SQL script into the tab.  
4. Execute the script step by step or all at once:  
   - **Step 1:** Database initialization (`DROP DATABASE`, `CREATE DATABASE`, `USE`).  
   - **Step 2:** Create tables and indexes.  
   - **Step 3:** Insert sample data with transaction control (`START TRANSACTION`, `SAVEPOINTS`, `COMMIT`).  
   - **Step 4:** Create database users and assign privileges.  
5. Verify that all tables, indexes, and sample data have been created successfully.  
6. Use the database by connecting with the created users (`admin_user`, `teacher_user`, `staff_user`).  

---

## Project ERD Structure

**Tables Overview**

| Table | Columns / Notes |
|-------|----------------|
| USERS | `user_id` PK, `username`, `password_hash`, `full_name`, `email`, `status` |
| ROLES | `role_id` PK, `role_name`, `description` |
| USER_ROLES | `user_role_id` PK, `user_id` FK, `role_id` FK, `assigned_at` |
| PRIVILEGES | `privilege_id` PK, `privilege_name`, `description` |
| ROLE_PRIVILEGES | `role_privilege_id` PK, `role_id` FK, `privilege_id` FK, `assigned_at` |
| SCHOOLS | `school_id` PK, `name`, `type`, `location`, `established_year`, `language_of_instruction` |
| PROGRAMS | `program_id` PK, `name`, `level`, `duration_years`, `school_id` FK |
| STUDENTS | `student_id` PK, `first_name`, `last_name`, `dob`, `gender`, `nationality`, `school_id` FK, `enrollment_date`, `status` |
| STUDENT_PROFILES | `student_id` PK, `address_line1`, `address_line2`, `city`, `postal_code`, `phone`, `emergency_contact_name`, `emergency_contact_phone` |
| ENROLLMENTS | `enrollment_id` PK, `student_id` FK, `program_id` FK, `start_year`, `end_year` |
| COURSES | `course_id` PK, `name`, `program_id` FK, `credits` |
| CLASS_SECTIONS | `section_id` PK, `course_id` FK, `year`, `term`, `teacher_name` |
| COURSE_ENROLLMENTS | `course_enrollment_id` PK, `enrollment_id` FK, `section_id` FK, `grade` |
| AUDIT_LOGS | `log_id` PK, `user_id` FK, `action`, `action_time`, `description` |

---

## Where Users Can Get Help
- **MySQL Documentation:** [https://dev.mysql.com/doc/](https://dev.mysql.com/doc/)  
- **GitHub Issues:** Use the Issues tab to report bugs or ask questions.  
- **Community Forums:** Stack Overflow, MySQL forums, or other developer communities.  

---

## Maintainers and Contributors
- **Maintainer:** Orlando Houston (Original developer)  
- **Contributors:** Open to developers and DBAs who want to contribute features, optimizations, or fixes.  
- **How to Contribute:** Fork the project, make changes, and submit a pull request.  

---

## Notes
- This project is **backend-only**; frontend interfaces can be integrated using this database.  
- Sample passwords are placeholders; use secure hashing in production environments.  
