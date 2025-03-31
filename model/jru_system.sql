-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 31, 2025 at 02:41 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jru_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `assignments`
--

CREATE TABLE `assignments` (
  `assignment_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `due_date` datetime NOT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `external_link` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assignments`
--

INSERT INTO `assignments` (`assignment_id`, `course_id`, `title`, `description`, `due_date`, `file_path`, `user_id`, `created_at`, `external_link`) VALUES
(1, 18, 'sdsd', 'sdsd', '0000-00-00 00:00:00', 'uploads\\iamot_09_final.doc', 22, '2025-02-14 12:48:52', NULL),
(25, 18, 'asda', 'gui', '2025-11-22 00:00:00', 'uploads\\Gultiano_IT321_Task4.pdf', 22, '2025-02-20 08:01:28', NULL),
(26, 23, 'qasas', 'asas', '2222-02-22 00:00:00', 'uploads\\Gultiano_IT321_Task4.pdf', 22, '2025-02-20 08:43:45', NULL),
(27, 29, 'ads2', '3qeq', '1111-11-11 00:00:00', 'uploads\\Gultiano_IT321_Task4.pdf', 22, '2025-02-20 08:56:23', NULL),
(28, 18, '12222', 'asa121', '1111-11-11 00:00:00', 'uploads\\Untitled design.jpg', 22, '2025-02-24 00:46:48', NULL),
(29, 24, 'sakbiufiuop[k', 'jkuhgioihpo', '1111-11-11 00:00:00', 'uploads\\jru_system (2).sql', 22, '2025-02-24 08:37:57', NULL),
(30, 36, 'aiugibi', 'honmoinoin', '1111-11-11 00:00:00', 'uploads\\Gultiano_TLA2.docx', 22, '2025-02-24 12:39:58', NULL),
(31, 18, 'qwqw1', '111', '2025-03-31 00:00:00', 'https://forms.gle/FzBi16X5JbpMcdu77', 22, '2025-03-30 11:32:37', NULL),
(32, 18, 'AHAHAHAHH', 'AHAHAHAH', '2025-03-31 00:00:00', '/uploads/inventory-summary-2025-03-11.csv', 22, '2025-03-31 02:34:50', NULL),
(33, 18, 'HUIHUHUHUHU', 'HUHUHUHU', '2025-03-20 00:00:00', 'https://docs.google.com/forms/d/e/1FAIpQLSc6vNAigL6-BpNkAMm1Nqx3Gu2bCRPDvuwuV3CVyWmSpLHRBQ/viewform', 22, '2025-03-31 02:35:07', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `assignment_submissions`
--

CREATE TABLE `assignment_submissions` (
  `submission_id` int(11) NOT NULL,
  `assignment_id` int(11) DEFAULT NULL,
  `student_id` int(11) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `grade` decimal(5,2) DEFAULT NULL,
  `feedback` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `course_id` int(11) NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `section` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `class_schedule` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`course_id`, `course_name`, `section`, `user_id`, `class_schedule`) VALUES
(18, 'ITELECT3', 'BSCS-3l', 22, 'MON: 1:00pm to 4:00pm'),
(19, 'ITELECT4', 'BSCS-3D', 23, 'MON'),
(20, 'ITELECT4', 'BSCS-3D', 23, 'MON'),
(21, 'SAS', 'SA', 23, 'string'),
(22, 'SAS', 'SA', 23, 'string'),
(23, 'asas', 'asas', 22, 'asa'),
(24, 'asas', 'asas', 22, 'MON'),
(25, 'asas', 'asas', 22, 'MON'),
(26, '212', 'string', 22, 'string'),
(27, '212', 'string', 22, 'string'),
(28, '212', 'string', 22, 'string'),
(29, 'qwerty', 'IT', 22, 'MON'),
(30, 'ITERA', 'CMBS', 23, 'FRI'),
(31, 'ITERA', 'CMBS', 23, 'FRI'),
(32, 'sssss', 'ssss', 22, 'sat'),
(33, 'sssss', 'ssss', 22, 'sat'),
(34, 'string', 'string', 22, 'string'),
(35, 'string', 'string', 22, 'string'),
(36, 'Sample Course', 'A', 22, 'MWF 10-11am'),
(37, 'hieee', 'string', 22, 'string'),
(38, 'hieee', 'string', NULL, 'string'),
(39, 'ddddddddddd', 'string', NULL, 'saa'),
(40, 'NET121', 'BSIT', 23, 'WED'),
(41, 'PROG1', 'BSIS', 23, 'THU'),
(55, 'PROG2', 'BSIS', 23, 'SAT');

-- --------------------------------------------------------

--
-- Table structure for table `course_content`
--

CREATE TABLE `course_content` (
  `content_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `file_path` varchar(255) DEFAULT NULL,
  `instructor_name` varchar(255) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `course_content`
--

INSERT INTO `course_content` (`content_id`, `course_id`, `title`, `content`, `created_at`, `file_path`, `instructor_name`, `user_id`) VALUES
(9, 18, 'string', 'string', '2025-02-13 21:23:52', 'uploads\\Integrating+Modern+Management+Tools+In+Education.pdf', NULL, 22),
(10, 19, 'wa lageeee', 'aAAAA', '2025-02-13 21:34:05', 'uploads\\jru_system.sql', NULL, 23),
(11, 20, 'HAHHAHAHA', 'HUHUHUHUH', '2025-02-13 23:36:37', 'uploads\\jru_system.sql', NULL, 23),
(12, 23, 'AAAAAAAAA', 'VVVVVVV', '2025-02-13 23:53:53', 'uploads\\(TEXAS) Week 5-Activity 2 - Sheet1.csv', NULL, 22),
(13, 24, 'asas', 'asasa', '2025-02-24 11:52:20', 'uploads\\jru_system.sql', NULL, 22),
(14, 36, 'mv jhgi', 'jkvuyfyu', '2025-02-24 11:52:50', 'uploads\\Gultiano_TLA2.docx', NULL, 22);

-- --------------------------------------------------------

--
-- Table structure for table `course_materials`
--

CREATE TABLE `course_materials` (
  `material_id` int(11) NOT NULL,
  `course_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `content` text DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `instructor_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `exams`
--

CREATE TABLE `exams` (
  `exam_id` int(11) NOT NULL,
  `course_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `exam_date` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `duration_minutes` int(11) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `external_link` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `exams`
--

INSERT INTO `exams` (`exam_id`, `course_id`, `title`, `description`, `exam_date`, `created_at`, `duration_minutes`, `file_path`, `user_id`, `external_link`) VALUES
(1, 22, 'string', 'string', '0000-00-00 00:00:00', '2025-02-20 08:25:10', 11, 'uploads\\Gultiano_IT321_Task4.pdf', 23, NULL),
(2, 18, 'WQWAAAA', 'jhjkhjkh', '2020-11-22 00:00:00', '2025-02-20 08:31:57', 30, 'uploads\\Gultiano_IT321_Task4.pdf', 22, NULL),
(3, 23, 'QWERTY', 'hujhfhjb', '2222-02-22 00:00:00', '2025-02-20 08:44:08', 20, 'uploads\\Gultiano_IT3A_Task2.docx', 22, NULL),
(4, 24, 'Prelim', 'jkbjhgskdjn', '2222-11-11 00:00:00', '2025-02-23 23:07:55', 30, 'uploads\\Gultiano_IT3A_Task2.docx', 22, NULL),
(5, 18, 'adfasda', 'dsasas', '1111-11-11 00:00:00', '2025-02-23 23:14:59', 11, 'uploads\\Gultiano_IT3A_Task2.docx', 22, NULL),
(6, 18, 'biuiouho', '\';pkm\';m', '2025-03-25 00:00:00', '2025-03-30 10:54:37', 30, 'https://forms.gle/FzBi16X5JbpMcdu77', 22, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `exam_submissions`
--

CREATE TABLE `exam_submissions` (
  `submission_id` int(11) NOT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `student_id` int(11) DEFAULT NULL,
  `answers` text DEFAULT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `grade` decimal(5,2) DEFAULT NULL,
  `feedback` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades`
--

CREATE TABLE `grades` (
  `grade_id` int(11) NOT NULL,
  `student_id` int(11) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `assignment_id` int(11) DEFAULT NULL,
  `quiz_id` int(11) DEFAULT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `grade` decimal(5,2) NOT NULL,
  `feedback` text DEFAULT NULL,
  `recorded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instructors`
--

CREATE TABLE `instructors` (
  `instructor_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `hire_date` date DEFAULT curdate(),
  `department` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `instructors`
--

INSERT INTO `instructors` (`instructor_id`, `user_id`, `name`, `hire_date`, `department`) VALUES
(7, 21, 'faculty', '2025-02-11', 'Unknown Department'),
(8, 22, 'geric', '2025-02-11', 'Unknown Department'),
(9, 23, 'gi', '2025-02-12', 'Unknown Department');

-- --------------------------------------------------------

--
-- Table structure for table `quizzes`
--

CREATE TABLE `quizzes` (
  `quiz_id` int(11) NOT NULL,
  `course_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `quiz_date` date DEFAULT NULL,
  `duration_minutes` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `external_link` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quizzes`
--

INSERT INTO `quizzes` (`quiz_id`, `course_id`, `title`, `description`, `created_at`, `quiz_date`, `duration_minutes`, `user_id`, `external_link`) VALUES
(2, 25, 'asas', 'asa', '2025-02-20 09:22:59', '2222-02-22', 30, 22, NULL),
(3, 22, 'klhghlkj', 'kjhklhjlkj', '2025-02-23 10:21:33', '1111-11-11', 22, 23, NULL),
(4, 37, 'asasa', 'sasa', '2025-02-24 00:43:21', '1111-11-11', 11, 22, NULL),
(9, 18, 'string', 'string', '2025-03-30 09:33:32', '0000-00-00', 10, 22, 'https://forms.gle/fakWLQQgTLqboFrh8'),
(10, 18, 'AHAHAHAHAH', 'LM, KLJBOIN', '2025-03-31 06:11:42', '0000-00-00', 20, 22, 'https://docs.google.com/forms/d/e/1FAIpQLSc6vNAigL6-BpNkAMm1Nqx3Gu2bCRPDvuwuV3CVyWmSpLHRBQ/viewform');

-- --------------------------------------------------------

--
-- Table structure for table `quiz_submissions`
--

CREATE TABLE `quiz_submissions` (
  `submission_id` int(11) NOT NULL,
  `quiz_id` int(11) DEFAULT NULL,
  `student_id` int(11) DEFAULT NULL,
  `answers` text DEFAULT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `grade` decimal(5,2) DEFAULT NULL,
  `feedback` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `student_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `student_number` varchar(50) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `enrollment_date` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`student_id`, `user_id`, `student_number`, `first_name`, `last_name`, `enrollment_date`) VALUES
(1, 24, '', 'mykkkk', '', '2025-02-13'),
(5, 29, 'SN000029', 'asd', '', '2025-02-13'),
(6, 30, 'SN000030', 'John', 'Doe', '2025-02-13');

-- --------------------------------------------------------

--
-- Table structure for table `student_courses`
--

CREATE TABLE `student_courses` (
  `enrollment_id` int(11) NOT NULL,
  `student_id` int(11) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `enrolled_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_courses`
--

INSERT INTO `student_courses` (`enrollment_id`, `student_id`, `course_id`, `enrolled_at`) VALUES
(10, 24, 18, '2025-02-14 04:06:52'),
(11, 27, 18, '2025-02-14 04:06:56'),
(12, 29, 19, '2025-02-14 04:24:50'),
(13, 27, 19, '2025-02-14 04:24:55'),
(14, 27, 24, '2025-02-24 11:52:07'),
(15, 27, 36, '2025-02-24 11:52:34');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('student','faculty','admin') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `name`, `email`, `password`, `role`, `created_at`) VALUES
(9, 'admin', 'admin@admin', 'string', 'admin', '2025-02-11 19:20:17'),
(21, 'faculty', 'faculty@123', 'faculty', 'faculty', '2025-02-12 10:30:40'),
(22, 'geric', 'geric@2', 'heric', 'faculty', '2025-02-12 11:14:03'),
(23, 'gi', 'gi@1', 'gi', 'faculty', '2025-02-13 06:35:57'),
(24, 'mykkkk', 'student@1', 'myk', 'student', '2025-02-14 01:31:34'),
(27, 'gelo', 'gelo@3', 'gelo', 'student', '2025-02-14 03:32:23'),
(28, 'coy', 'coy@4', 'coy', 'student', '2025-02-14 03:38:40'),
(29, 'asd', 'asd@asd', '12', 'student', '2025-02-14 03:43:33'),
(30, 'John Doe', 'john.doe@example.com', 'aa', 'student', '2025-02-14 03:44:11');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assignments`
--
ALTER TABLE `assignments`
  ADD PRIMARY KEY (`assignment_id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `assignment_submissions`
--
ALTER TABLE `assignment_submissions`
  ADD PRIMARY KEY (`submission_id`),
  ADD KEY `assignment_id` (`assignment_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`course_id`),
  ADD KEY `fk_courses_users` (`user_id`);

--
-- Indexes for table `course_content`
--
ALTER TABLE `course_content`
  ADD PRIMARY KEY (`content_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `course_materials`
--
ALTER TABLE `course_materials`
  ADD PRIMARY KEY (`material_id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `instructor_id` (`instructor_id`),
  ADD KEY `content_id` (`content_id`),
  ADD KEY `fk_course_materials_user` (`user_id`);

--
-- Indexes for table `exams`
--
ALTER TABLE `exams`
  ADD PRIMARY KEY (`exam_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `exam_submissions`
--
ALTER TABLE `exam_submissions`
  ADD PRIMARY KEY (`submission_id`),
  ADD KEY `exam_id` (`exam_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `grades`
--
ALTER TABLE `grades`
  ADD PRIMARY KEY (`grade_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `assignment_id` (`assignment_id`),
  ADD KEY `quiz_id` (`quiz_id`),
  ADD KEY `exam_id` (`exam_id`);

--
-- Indexes for table `instructors`
--
ALTER TABLE `instructors`
  ADD PRIMARY KEY (`instructor_id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `quizzes`
--
ALTER TABLE `quizzes`
  ADD PRIMARY KEY (`quiz_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `quiz_submissions`
--
ALTER TABLE `quiz_submissions`
  ADD PRIMARY KEY (`submission_id`),
  ADD KEY `quiz_id` (`quiz_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD UNIQUE KEY `student_number` (`student_number`);

--
-- Indexes for table `student_courses`
--
ALTER TABLE `student_courses`
  ADD PRIMARY KEY (`enrollment_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `assignments`
--
ALTER TABLE `assignments`
  MODIFY `assignment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `assignment_submissions`
--
ALTER TABLE `assignment_submissions`
  MODIFY `submission_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `course_content`
--
ALTER TABLE `course_content`
  MODIFY `content_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `course_materials`
--
ALTER TABLE `course_materials`
  MODIFY `material_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `exams`
--
ALTER TABLE `exams`
  MODIFY `exam_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `exam_submissions`
--
ALTER TABLE `exam_submissions`
  MODIFY `submission_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades`
--
ALTER TABLE `grades`
  MODIFY `grade_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `instructors`
--
ALTER TABLE `instructors`
  MODIFY `instructor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `quizzes`
--
ALTER TABLE `quizzes`
  MODIFY `quiz_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `quiz_submissions`
--
ALTER TABLE `quiz_submissions`
  MODIFY `submission_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `student_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `student_courses`
--
ALTER TABLE `student_courses`
  MODIFY `enrollment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assignments`
--
ALTER TABLE `assignments`
  ADD CONSTRAINT `assignments_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `assignments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `assignment_submissions`
--
ALTER TABLE `assignment_submissions`
  ADD CONSTRAINT `assignment_submissions_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`assignment_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `assignment_submissions_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `fk_courses_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `course_content`
--
ALTER TABLE `course_content`
  ADD CONSTRAINT `course_content_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE;

--
-- Constraints for table `course_materials`
--
ALTER TABLE `course_materials`
  ADD CONSTRAINT `course_materials_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `course_materials_ibfk_2` FOREIGN KEY (`instructor_id`) REFERENCES `instructors` (`instructor_id`),
  ADD CONSTRAINT `course_materials_ibfk_3` FOREIGN KEY (`content_id`) REFERENCES `course_content` (`content_id`),
  ADD CONSTRAINT `fk_course_materials_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `exams`
--
ALTER TABLE `exams`
  ADD CONSTRAINT `exams_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE;

--
-- Constraints for table `exam_submissions`
--
ALTER TABLE `exam_submissions`
  ADD CONSTRAINT `exam_submissions_ibfk_1` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`exam_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `exam_submissions_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `grades`
--
ALTER TABLE `grades`
  ADD CONSTRAINT `grades_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `grades_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `grades_ibfk_3` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`assignment_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `grades_ibfk_4` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`quiz_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `grades_ibfk_5` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`exam_id`) ON DELETE SET NULL;

--
-- Constraints for table `instructors`
--
ALTER TABLE `instructors`
  ADD CONSTRAINT `fk_instructor_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `quizzes`
--
ALTER TABLE `quizzes`
  ADD CONSTRAINT `quizzes_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE;

--
-- Constraints for table `quiz_submissions`
--
ALTER TABLE `quiz_submissions`
  ADD CONSTRAINT `quiz_submissions_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`quiz_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `quiz_submissions_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `fk_student_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `student_courses`
--
ALTER TABLE `student_courses`
  ADD CONSTRAINT `student_courses_fk` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_courses_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
