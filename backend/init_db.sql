-- Create database
CREATE DATABASE IF NOT EXISTS attendance_db;
USE attendance_db;

-- Subjects table
CREATE TABLE subjects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(100) NOT NULL,
    subject_code VARCHAR(20) UNIQUE,
    required_percentage DECIMAL(5,2) DEFAULT 75.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Timetable table
CREATE TABLE timetable (
    id INT PRIMARY KEY AUTO_INCREMENT,
    subject_id INT NOT NULL,
    day_of_week ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    room_number VARCHAR(20),
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    UNIQUE KEY unique_slot (subject_id, day_of_week, start_time)
);

-- Attendance table
CREATE TABLE attendance (
    id INT PRIMARY KEY AUTO_INCREMENT,
    subject_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('Present','Absent','Cancelled','Not Taken') NOT NULL,
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    UNIQUE KEY unique_attendance (subject_id, attendance_date)
);

-- Insert sample data
INSERT INTO subjects (subject_name, subject_code, required_percentage) VALUES
('Mathematics', 'MATH101', 75.00),
('Physics', 'PHY101', 75.00),
('Chemistry', 'CHEM101', 75.00);

INSERT INTO timetable (subject_id, day_of_week, start_time, end_time, room_number) VALUES
(1, 'Monday', '09:00:00', '10:00:00', 'Room 201'),
(2, 'Monday', '11:00:00', '12:00:00', 'Lab 3'),
(1, 'Wednesday', '10:00:00', '11:00:00', 'Room 201');