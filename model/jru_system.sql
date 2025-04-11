-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 11, 2025 at 09:53 AM
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
(34, 73, 'Understanding the Deming Cycle & Test Script Creation', 'Please read the instructions carefully. After completing this, kindly submit it in editable document format and follow the filename structure: LASTNAME_Finals-TLA5_03282025\r\nResearch and define the in your own understanding and provide an example of how the PDCA cycle applies to Software Testing.\r\nResearch what elements must be included when writing a in software testing and identify and list the of a structured test script.\r\nProvide the source where you have gotten the information and include the date it was published. Once you have completed your research, using the information you have gathered, create test scripts based on the following scenarios:\r\nA banking application allows users to log in with a username and password. The system should lock the account after three failed attempts. Write a test script to validate this functionality.\r\nAn e-commerce website allows customers to add items to their cart and proceed to checkout. The system should display a confirmation message when an order is successfully placed. Write a test script to validate this functionality.', '2025-04-04 00:00:00', NULL, 41, '2025-04-04 09:48:31', NULL),
(35, 73, 'dbkj', ';mpocn', '2025-02-05 00:00:00', '/uploads/Pre-departure-Orientation.pdf', 41, '2025-04-09 05:06:08', NULL);

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
  `feedback` text DEFAULT NULL,
  `external_link` varchar(255) DEFAULT NULL,
  `submission_text` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assignment_submissions`
--

INSERT INTO `assignment_submissions` (`submission_id`, `assignment_id`, `student_id`, `file_path`, `submitted_at`, `grade`, `feedback`, `external_link`, `submission_text`) VALUES
(25, 35, 43, 'uploads\\76c95dd8-34da-4cd8-aa80-9864e9a1030e_Tech business purple logo (3).png', '2025-04-11 04:52:09', NULL, NULL, NULL, 'asa');

-- --------------------------------------------------------

--
-- Table structure for table `calendar_events`
--

CREATE TABLE `calendar_events` (
  `event_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `time` time DEFAULT NULL,
  `description` text DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `course_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `calendar_events`
--

INSERT INTO `calendar_events` (`event_id`, `title`, `date`, `time`, `description`, `type`, `user_id`, `created_at`, `updated_at`, `course_id`) VALUES
(1, 'Orientation', '2025-04-15', '07:40:00', 'Cebu Orientation', 'meeting', 41, '2025-04-11 05:39:47', '2025-04-11 05:39:47', 73);

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `comment_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `entity_type` enum('assignment','quiz','material','exam') NOT NULL,
  `entity_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`comment_id`, `user_id`, `entity_type`, `entity_id`, `content`, `created_at`) VALUES
(1, 43, 'quiz', 15, 'HI', '2025-04-11 19:48:51');

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
(18, 'ITELECT3', 'BSCS-3l', NULL, 'MON: 1:00pm to 4:00pm'),
(19, 'ITELECT4', 'BSCS-3D', NULL, 'MON'),
(20, 'ITELECT4', 'BSCS-3D', NULL, 'MON'),
(21, 'SAS', 'SA', NULL, 'string'),
(22, 'SAS', 'SA', NULL, 'string'),
(23, 'asas', 'asas', NULL, 'asa'),
(24, 'asas', 'asas', NULL, 'MON'),
(25, 'asas', 'asas', NULL, 'MON'),
(26, '212', 'string', NULL, 'string'),
(27, '212', 'string', NULL, 'string'),
(28, '212', 'string', NULL, 'string'),
(29, 'qwerty', 'IT', NULL, 'MON'),
(30, 'ITERA', 'CMBS', NULL, 'FRI'),
(31, 'ITERA', 'CMBS', NULL, 'FRI'),
(32, 'sssss', 'ssss', NULL, 'sat'),
(33, 'sssss', 'ssss', NULL, 'sat'),
(34, 'string', 'string', NULL, 'string'),
(35, 'string', 'string', NULL, 'string'),
(36, 'Sample Course', 'A', NULL, 'MWF 10-11am'),
(37, 'hieee', 'string', NULL, 'string'),
(38, 'hieee', 'string', NULL, 'string'),
(39, 'ddddddddddd', 'string', NULL, 'saa'),
(40, 'NET121', 'BSIT', NULL, 'WED'),
(41, 'PROG1', 'BSIS', NULL, 'THU'),
(55, 'PROG2', 'BSIS', NULL, 'SAT'),
(56, 'SE', 'BSIT3A', NULL, 'TUESDAY'),
(58, 'ELEC014', 'BSIT-3A', NULL, 'MON-THU'),
(68, 'ELEC014', 'BSIT-3B', NULL, 'TUE-FRI'),
(69, 'ELEC014', 'BSCS-3A', NULL, 'MON-WED'),
(70, 'GEC010', 'BSPH-2A', NULL, 'TUE'),
(71, 'GEC010', 'BSN-3B', NULL, 'TUE'),
(72, 'GEC010', 'BSN-3C', NULL, 'WED'),
(73, 'ELEC014', 'BSIT-3A', 41, 'FRI'),
(74, 'ELEC014', 'BSIT-3B', 41, 'THU'),
(75, 'ELEC014', 'BSCS-3A', 41, 'MON'),
(76, 'GEC010', 'BSPH-2A', 41, 'TUE'),
(77, 'GEC010', 'BSN-1A', 41, 'MON'),
(79, 'GEC010', 'BSN-1B', 41, 'TUE'),
(81, 'GEC010', 'BSN-1C', 41, 'FRI');

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
(14, 36, 'mv jhgi', 'jkvuyfyu', '2025-02-24 11:52:50', 'uploads\\Gultiano_TLA2.docx', NULL, 22),
(15, 56, 'GAA', 'FD', '2025-03-31 07:15:47', 'uploads\\inventory-summary-2025-03-11 (1).csv', NULL, 22),
(16, 73, 'Pre-Survey form for the Cebu Tour', 'Good day @everyone and Happy New Year! For those who are enrolled in ELEC014 - Seminars, Workshops, please accomplish this pre-survey form for the Cebu Tour:\r\n', '2025-04-04 09:06:49', 'uploads\\Gultiano_TLA4.pdf', NULL, 41),
(18, 73, 'Parents Orientation', 'Good day @everyone! For Seminars, Tours, and Workshops, please be informed that there will be a parent\'s orientation on January 18, 2025 (Saturday) 10AM - 12 NN @ L205 to discuss the proposed itenerary for the Cebu Tour and other important details related to it. This orientation will be conducted in hybrid setup. Thank you!', '2025-04-04 09:18:17', NULL, NULL, 41),
(19, 73, 'Seminar Session', 'Good day @everyone, due to a conflict of schedules in labs, please be informed that we will have our seminar session tomorrow @ 9am - 12nn via Google Meet. I will send the meet link later. Thank you!\r\n', '2025-04-04 09:18:46', NULL, NULL, 41),
(20, 73, 'Seminar Session', 'Good day everyone!\r\nDue to unforeseen changes, we will have our seminar session tomorrow @ 1PM - 5 PM via Google Meet:', '2025-04-04 09:19:30', NULL, NULL, 41),
(21, 73, 'Local Industry Tour', 'Good evening, everyone!\r\n\r\nIMPORTANT ANNOUNCEMENT‼️\r\n\r\nDue to the limited seating capacity of the bus for our local industry tour, the visit to the Mindanao Media Hub will be conducted in two batches:\r\n\r\nFebruary 20, 2025: BSIT 3A and CS 3 will participate in the tour.\r\nBSIT 3B: Your schedule will be announced as soon as possible.\r\n\r\n\r\nAdditionally, all students are required to secure their ₱50.00 payment tomorrow (9:00 AM - 10:30 AM) at L201.\r\n\r\nPlease stay tuned for further updates. Thank you for your cooperation and understanding!', '2025-04-04 09:21:34', NULL, NULL, 41),
(22, 73, 'Pre-Departure content', 'Good day everyone, sending you the copy of the pre-departure orientation content', '2025-04-04 09:24:15', 'uploads\\Pre-departure-Orientation.pdf', NULL, 41);

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
(6, 18, 'biuiouho', '\';pkm\';m', '2025-03-25 00:00:00', '2025-03-30 10:54:37', 30, 'https://forms.gle/FzBi16X5JbpMcdu77', 22, NULL),
(7, 25, ' cscS', 'CZCSD', '2025-03-04 00:00:00', '2025-03-31 07:01:32', 12, '/uploads/inventory-summary-2025-03-11.csv', 22, NULL),
(8, 25, 'XCASFQW', 'DSD', '2025-04-24 00:00:00', '2025-03-31 07:02:07', 21, 'https://github.com/orent143/BeataIMS/blob/updated/IMS/src/views/ims/Stock.vue', 22, NULL),
(9, 73, 'Prelim Exam', 'Please read the following instructions carefully before beginning the assessment:\r\nRead each question carefully before providing your answer. Pay attention to any instructions or details provided in the question.\r\nThis assessment is to be completed individually. Collaboration with other individuals or consulting unauthorized materials is strictly prohibited.', '2025-04-04 00:00:00', '2025-04-04 09:47:36', 60, 'https://docs.google.com/forms/d/e/1FAIpQLSfar0bqNJfbp06w14avZ4dzxjgAPXyGMaC79mXGIz9LgtODqA/alreadyresponded?hr_submission=ChkIn6OTsdQPEhAIhZePwYgUEgcI8_DEwYIVEAE', 41, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `exam_submissions`
--

CREATE TABLE `exam_submissions` (
  `submission_id` int(11) NOT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `student_id` int(11) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `external_link` varchar(255) DEFAULT NULL,
  `submission_text` text DEFAULT NULL,
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
  `recorded_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `school_year` varchar(9) NOT NULL,
  `semester` enum('1st','2nd') NOT NULL,
  `prelim_grade` decimal(5,2) DEFAULT NULL,
  `midterm_grade` decimal(5,2) DEFAULT NULL,
  `finals_grade` decimal(5,2) DEFAULT NULL,
  `overall_grade` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `grades`
--

INSERT INTO `grades` (`grade_id`, `student_id`, `course_id`, `recorded_at`, `school_year`, `semester`, `prelim_grade`, `midterm_grade`, `finals_grade`, `overall_grade`) VALUES
(2, 43, 73, '2025-04-09 08:00:25', '2024-2025', '1st', 85.00, 74.00, 75.00, 78.00),
(3, 35, 73, '2025-04-09 10:40:49', '2024-2025', '1st', 70.00, 80.00, 90.00, 80.00),
(4, 34, 73, '2025-04-09 11:40:36', '2024-2025', '1st', 82.00, 60.00, 75.00, 72.33);

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
(10, 18, 'AHAHAHAHAH', 'LM, KLJBOIN', '2025-03-31 06:11:42', '0000-00-00', 20, 22, 'https://docs.google.com/forms/d/e/1FAIpQLSc6vNAigL6-BpNkAMm1Nqx3Gu2bCRPDvuwuV3CVyWmSpLHRBQ/viewform'),
(15, 73, 'eqqe', 'qdada', '2025-04-08 10:19:11', '2025-02-05', 20, 41, 'https://mail.google.com/mail/u/0/?pli=1#inbox/FMfcgzQZTzdWzvRHvMRvfncjpWrBMwhM');

-- --------------------------------------------------------

--
-- Table structure for table `quiz_submissions`
--

CREATE TABLE `quiz_submissions` (
  `submission_id` int(11) NOT NULL,
  `quiz_id` int(11) DEFAULT NULL,
  `student_id` int(11) DEFAULT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `grade` decimal(5,2) DEFAULT NULL,
  `feedback` text DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `external_link` varchar(255) DEFAULT NULL,
  `submission_text` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quiz_submissions`
--

INSERT INTO `quiz_submissions` (`submission_id`, `quiz_id`, `student_id`, `submitted_at`, `grade`, `feedback`, `file_path`, `external_link`, `submission_text`) VALUES
(4, 15, 43, '2025-04-11 04:47:25', NULL, NULL, 'uploads\\dfacc462-bd31-4137-92fa-d65dc3219ff6_Top 5 Cybersecurity Threats in 2023 and How to Defend Against Them _ Aurosign.jpg', NULL, 'sasa');

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
  `degree` varchar(100) NOT NULL,
  `enrollment_date` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`student_id`, `user_id`, `student_number`, `first_name`, `last_name`, `degree`, `enrollment_date`) VALUES
(7, 34, 'SN000034', 'Asi', '', '', '2025-04-01'),
(8, 35, 'SN000035', 'Kobe', '', '', '2025-04-01'),
(9, 36, 'SN000036', 'Tine', '', '', '2025-04-01'),
(44, 43, 'SN000043', 'Geric', 'Gultiano', 'Information Technology', '2025-04-11');

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
(22, 43, 73, '2025-04-04 08:57:49'),
(23, 35, 73, '2025-04-09 09:18:02'),
(26, 34, 73, '2025-04-09 09:56:59');

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
(34, 'Asi', 'ivaldez_220000000293@uic.edu.ph', 'ASI', 'student', '2025-04-02 05:19:18'),
(35, 'Kobe', 'kcorpuz_220000002183@uic.edu.ph', 'kobe', 'student', '2025-04-02 05:20:46'),
(36, 'Tine', 'justineslozada@gmail.com', 'JUSTINE', 'student', '2025-04-02 05:23:53'),
(40, 'Admin', 'orentgultiano11@gmail.com', '$2b$12$ldWtvfFWUHI46kxGYCJBq.e/AY2rCaOJ2RRRdHW95zwl9aiFcVEKq', 'admin', '2025-04-03 11:46:34'),
(41, 'Sir Geric', 'wlage35@gmail.com', '$2b$12$SGCrupcTfBGfLBjzYP1e5ubVpZNlPibPR0UIcCc4DKNVLAWWfVcsG', 'faculty', '2025-04-04 08:25:13'),
(43, 'Geric Gultiano', 'ggultiano_220000000886@uic.edu.ph', '$2b$12$uRsjgAU6XLaxbUfg21pL8.r4P27tAmsqaVvHDUzN/YLeaTFSIPRlu', 'student', '2025-04-04 08:31:48');

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
-- Indexes for table `calendar_events`
--
ALTER TABLE `calendar_events`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`comment_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `entity_type` (`entity_type`,`entity_id`);

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
  ADD KEY `course_id` (`course_id`);

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
  MODIFY `assignment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `assignment_submissions`
--
ALTER TABLE `assignment_submissions`
  MODIFY `submission_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `calendar_events`
--
ALTER TABLE `calendar_events`
  MODIFY `event_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `comment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT for table `course_content`
--
ALTER TABLE `course_content`
  MODIFY `content_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `course_materials`
--
ALTER TABLE `course_materials`
  MODIFY `material_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `exams`
--
ALTER TABLE `exams`
  MODIFY `exam_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `exam_submissions`
--
ALTER TABLE `exam_submissions`
  MODIFY `submission_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `grades`
--
ALTER TABLE `grades`
  MODIFY `grade_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `instructors`
--
ALTER TABLE `instructors`
  MODIFY `instructor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `quizzes`
--
ALTER TABLE `quizzes`
  MODIFY `quiz_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `quiz_submissions`
--
ALTER TABLE `quiz_submissions`
  MODIFY `submission_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `student_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `student_courses`
--
ALTER TABLE `student_courses`
  MODIFY `enrollment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

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
-- Constraints for table `calendar_events`
--
ALTER TABLE `calendar_events`
  ADD CONSTRAINT `calendar_events_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `calendar_events_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`),
  ADD CONSTRAINT `calendar_events_ibfk_3` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`);

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

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
  ADD CONSTRAINT `grades_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE;

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
