-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 05, 2026 at 08:36 AM
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
-- Database: `bargain_ai_hybrid`
--

-- --------------------------------------------------------

--
-- Table structure for table `conversations`
--

CREATE TABLE `conversations` (
  `id` bigint(20) NOT NULL,
  `session_id` varchar(100) NOT NULL,
  `product_id` int(11) NOT NULL,
  `initial_price` decimal(10,2) NOT NULL,
  `final_price` decimal(10,2) DEFAULT NULL,
  `status` enum('active','completed','walked_away') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `ended_at` timestamp NULL DEFAULT NULL,
  `turns_count` int(11) DEFAULT 0,
  `duration_seconds` int(11) DEFAULT 0,
  `customer_type` enum('aggressive','polite','hesitant','comparison','impulse') DEFAULT 'polite'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `conversations`
--

INSERT INTO `conversations` (`id`, `session_id`, `product_id`, `initial_price`, `final_price`, `status`, `created_at`, `ended_at`, `turns_count`, `duration_seconds`, `customer_type`) VALUES
(1, 'session_1766949384_7994', 2, 12000.00, NULL, 'active', '2025-12-28 19:16:24', NULL, 3, 0, 'polite'),
(2, 'session_1766949575_8156', 2, 12000.00, NULL, 'active', '2025-12-28 19:19:35', NULL, 5, 0, 'polite'),
(3, 'session_1766949934_6188', 1, 1000.00, 750.00, 'completed', '2025-12-28 19:25:34', '2025-12-28 19:26:00', 3, 26, 'polite'),
(4, 'session_1766950034_6078', 3, 3500.00, 3500.00, 'walked_away', '2025-12-28 19:27:14', '2025-12-28 19:27:24', 1, 10, 'polite'),
(5, 'session_1766950061_5967', 3, 3500.00, NULL, 'active', '2025-12-28 19:27:41', NULL, 0, 0, 'polite'),
(6, 'session_1766950101_6040', 1, 1000.00, NULL, 'active', '2025-12-28 19:28:21', NULL, 0, 0, 'polite'),
(7, 'session_1766950157_3521', 4, 800.00, 650.00, 'completed', '2025-12-28 19:29:17', '2025-12-28 19:30:45', 3, 88, 'polite'),
(8, 'session_1766950415_8504', 3, 3500.00, 2900.00, 'walked_away', '2025-12-28 19:33:35', '2025-12-28 19:34:46', 3, 71, 'polite'),
(9, 'session_1766950724_6850', 4, 800.00, 600.00, 'walked_away', '2025-12-28 19:38:44', '2025-12-28 19:40:23', 3, 99, 'polite'),
(10, 'session_1766950930_9141', 2, 12000.00, 12000.00, 'walked_away', '2025-12-28 19:42:10', '2025-12-28 19:42:45', 1, 35, 'polite'),
(11, 'session_1766951162_3168', 3, 3500.00, 3500.00, 'walked_away', '2025-12-28 19:46:02', '2025-12-28 19:46:05', 1, 3, 'polite'),
(12, 'session_1766951190_1259', 3, 3500.00, 2700.00, 'completed', '2025-12-28 19:46:30', '2025-12-28 19:49:18', 4, 168, 'polite'),
(13, 'session_1766951443_7117', 3, 3500.00, 5000.00, 'completed', '2025-12-28 19:50:43', '2025-12-28 19:51:16', 3, 33, 'polite'),
(14, 'session_1766951533_2955', 1, 1000.00, 1000.00, 'completed', '2025-12-28 19:52:13', '2025-12-28 19:56:58', 5, 285, 'polite'),
(15, 'session_1766951941_4881', 1, 1000.00, NULL, 'active', '2025-12-28 19:59:01', NULL, 0, 0, 'polite'),
(16, 'session_1766952039_4741', 1, 1000.00, NULL, 'active', '2025-12-28 20:00:39', NULL, 2, 0, 'polite'),
(17, 'session_1766952750_9692', 3, 3500.00, 2200.00, 'completed', '2025-12-28 20:12:30', '2025-12-28 20:16:24', 9, 234, 'polite'),
(18, 'session_1766953165_2544', 1, 1000.00, NULL, 'active', '2025-12-28 20:19:25', NULL, 2, 0, 'polite'),
(19, 'session_1766953211_5248', 1, 1000.00, NULL, 'active', '2025-12-28 20:20:11', NULL, 2, 0, 'polite'),
(20, 'session_1766953362_3084', 3, 3500.00, NULL, 'active', '2025-12-28 20:22:42', NULL, 6, 0, 'polite'),
(21, 'session_1766953714_5362', 4, 800.00, 700.00, 'completed', '2025-12-28 20:28:34', '2025-12-28 20:31:25', 6, 171, 'polite'),
(22, 'session_1766999060_3554', 2, 12000.00, NULL, 'active', '2025-12-29 09:04:20', NULL, 4, 0, 'polite'),
(23, 'session_1766999343_8260', 3, 3500.00, 2000.00, 'completed', '2025-12-29 09:09:03', '2025-12-29 09:18:12', 7, 549, 'polite'),
(24, 'session_1767000052_4693', 2, 12000.00, NULL, 'active', '2025-12-29 09:20:52', NULL, 3, 0, 'polite'),
(25, 'session_1767028902_7008', 2, 12000.00, 9250.00, 'completed', '2025-12-29 17:21:42', '2025-12-29 17:29:01', 7, 439, 'polite'),
(26, 'session_1767029495_3561', 2, 12000.00, 9600.00, 'walked_away', '2025-12-29 17:31:35', '2025-12-29 17:31:53', 2, 18, 'polite'),
(27, 'session_1767029532_9721', 4, 800.00, 400.00, 'completed', '2025-12-29 17:32:12', '2025-12-29 17:36:54', 8, 282, 'polite'),
(28, 'session_1767070371_6424', 3, 3500.00, NULL, 'active', '2025-12-30 04:52:51', NULL, 5, 0, 'polite'),
(29, 'session_1767071309_9968', 1, 1000.00, NULL, 'active', '2025-12-30 05:08:29', NULL, 0, 0, 'polite'),
(30, 'session_1767071393_9215', 2, 12000.00, NULL, 'active', '2025-12-30 05:09:53', NULL, 3, 0, 'polite'),
(31, 'session_1767072035_2914', 3, 3500.00, 5000.00, 'completed', '2025-12-30 05:20:35', '2025-12-30 05:21:42', 1, 67, 'polite'),
(32, 'session_1767073497_7385', 1, 1000.00, NULL, 'active', '2025-12-30 05:44:57', NULL, 0, 0, 'polite'),
(33, 'session_1767073973_4675', 1, 1000.00, NULL, 'active', '2025-12-30 05:52:53', NULL, 0, 0, 'polite'),
(34, 'session_1767113291_2677', 2, 12000.00, 10300.00, 'completed', '2025-12-30 16:48:11', '2025-12-30 16:52:13', 8, 242, 'polite'),
(35, 'session_1767675264_5326', 3, 3500.00, 3000.00, 'walked_away', '2026-01-06 04:54:24', '2026-01-06 04:57:30', 8, 186, 'polite'),
(36, 'session_1767675497_2108', 1, 1000.00, 950.00, 'completed', '2026-01-06 04:58:17', '2026-01-06 05:02:37', 2, 260, 'polite'),
(37, 'session_1767675824_1809', 1, 1000.00, 900.00, 'completed', '2026-01-06 05:03:44', '2026-01-06 05:06:01', 3, 137, 'polite'),
(38, 'session_1767676680_8441', 1, 1000.00, NULL, 'active', '2026-01-06 05:18:00', NULL, 0, 0, 'polite'),
(39, 'session_1767676695_5752', 1, 1000.00, 800.00, 'completed', '2026-01-06 05:18:15', '2026-01-06 05:22:34', 10, 259, 'polite'),
(40, 'session_1771863232_6492', 1, 1000.00, 850.00, 'completed', '2026-02-23 16:13:52', '2026-02-23 16:15:50', 5, 118, 'polite'),
(41, '80c043fd-b011-4bf0-9518-0a46c410d04b', 1, 1000.00, NULL, 'active', '2026-02-23 17:55:35', NULL, 0, 0, 'polite'),
(42, 'a3f72b5a-b4de-4079-8642-605270ab66d7', 1, 1000.00, NULL, 'active', '2026-02-23 17:55:48', NULL, 0, 0, 'polite'),
(43, '50e52a08-4b35-4dd5-95f2-243925b5f2ca', 1, 1000.00, NULL, 'active', '2026-02-23 18:08:22', NULL, 3, 0, 'polite'),
(44, '4b0c7f69-3308-4042-9220-06bdb3d0b6c7', 1, 1000.00, NULL, 'active', '2026-02-23 18:11:16', NULL, 1, 0, 'polite'),
(45, 'a9444eca-10a4-45ad-a9c1-c775d3c918f5', 1, 1000.00, 900.00, 'completed', '2026-02-23 18:18:49', '2026-02-23 18:20:14', 2, 85, 'polite'),
(46, '9f7f8495-53b1-44e1-8bfb-37a5f1fccabd', 1, 1000.00, NULL, 'active', '2026-03-04 18:46:24', NULL, 3, 0, 'polite');

-- --------------------------------------------------------

--
-- Table structure for table `conversation_messages`
--

CREATE TABLE `conversation_messages` (
  `id` bigint(20) NOT NULL,
  `conversation_id` bigint(20) NOT NULL,
  `turn_number` int(11) NOT NULL,
  `speaker` enum('customer','shopkeeper') NOT NULL,
  `message_text` text NOT NULL,
  `extracted_price` decimal(10,2) DEFAULT NULL,
  `emotion` varchar(20) DEFAULT NULL,
  `intent` varchar(50) DEFAULT NULL,
  `used_llm` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `conversation_messages`
--

INSERT INTO `conversation_messages` (`id`, `conversation_id`, `turn_number`, `speaker`, `message_text`, `extracted_price`, `emotion`, `intent`, `used_llm`, `created_at`) VALUES
(1, 1, 1, 'customer', 'mai iska 700 tak sakta hoon', 700.00, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:17:31'),
(2, 1, 2, 'customer', '600', 600.00, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:17:40'),
(3, 1, 3, 'customer', '₹700 doge', 700.00, 'NEUTRAL', 'price_offer', 0, '2025-12-28 19:17:58'),
(4, 2, 1, 'customer', 'Hello,How are you ?', NULL, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:20:15'),
(5, 2, 1, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹12,000 hai.', NULL, NULL, NULL, 0, '2025-12-28 19:20:15'),
(6, 2, 2, 'customer', 'main iska 9000 tak de sakta hoon', 9000.00, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:20:34'),
(7, 2, 3, 'customer', 'kya features hai?', NULL, 'NEUTRAL', 'feature_query', 0, '2025-12-28 19:21:20'),
(8, 2, 3, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹10,800 hai.', NULL, NULL, NULL, 0, '2025-12-28 19:21:20'),
(9, 2, 4, 'customer', '10000', 10000.00, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:21:40'),
(10, 2, 5, 'customer', '10000', 10000.00, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:21:46'),
(11, 3, 1, 'customer', '650', 650.00, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:25:47'),
(12, 3, 1, 'shopkeeper', 'Bhai, ₹900 de sakta hoon. (₹100 discount!)', NULL, NULL, NULL, 0, '2025-12-28 19:25:47'),
(13, 3, 2, 'customer', '700', 700.00, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:25:55'),
(14, 3, 2, 'shopkeeper', 'Bhai, ₹810 de sakta hoon. (₹190 discount!)', NULL, NULL, NULL, 0, '2025-12-28 19:25:55'),
(15, 3, 3, 'customer', '750', 750.00, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:26:00'),
(16, 3, 3, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹750 me aapka!', NULL, NULL, NULL, 0, '2025-12-28 19:26:00'),
(17, 4, 1, 'customer', 'Bye', NULL, 'NEUTRAL', 'walk_away', 0, '2025-12-28 19:27:24'),
(18, 4, 1, 'shopkeeper', 'Koi baat nahi bhai. Kabhi aur aana! 🙏', NULL, NULL, NULL, 0, '2025-12-28 19:27:24'),
(19, 7, 1, 'customer', 'kya features hai?', NULL, 'NEUTRAL', 'feature_query', 0, '2025-12-28 19:29:33'),
(20, 7, 1, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹800 hai.', NULL, NULL, NULL, 0, '2025-12-28 19:29:33'),
(21, 7, 2, 'customer', '600', 600.00, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:29:48'),
(22, 7, 2, 'shopkeeper', 'Bhai, ₹720 de sakta hoon. (₹80 discount!)', NULL, NULL, NULL, 0, '2025-12-28 19:29:48'),
(23, 7, 3, 'customer', 'mai iska 650 de sakta hoon use jiyaadaa nahi de sakta hoon', 650.00, 'NEUTRAL', 'walk_away', 0, '2025-12-28 19:30:45'),
(24, 7, 3, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹650 me aapka!', NULL, NULL, NULL, 0, '2025-12-28 19:30:45'),
(25, 8, 1, 'customer', 'Hello, How are you ?', NULL, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:34:00'),
(26, 8, 1, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹3,500 hai.', NULL, NULL, NULL, 0, '2025-12-28 19:34:00'),
(27, 8, 2, 'customer', 'me iska 500 tak de sakta hoon', 500.00, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:34:19'),
(28, 8, 2, 'shopkeeper', 'Bhai, ₹2,900 de sakta hoon. (₹600 discount!)', NULL, NULL, NULL, 0, '2025-12-28 19:34:19'),
(29, 8, 3, 'customer', 'nahi toh phir tum hi rakho tumhare pass', NULL, 'NEUTRAL', 'walk_away', 0, '2025-12-28 19:34:46'),
(30, 8, 3, 'shopkeeper', 'Koi baat nahi bhai. Kabhi aur aana! 🙏', NULL, NULL, NULL, 0, '2025-12-28 19:34:46'),
(31, 9, 1, 'customer', 'mai iska 300 de sakta hoon', 300.00, 'NEUTRAL', 'price_offer', 0, '2025-12-28 19:39:12'),
(32, 9, 1, 'shopkeeper', 'Bhai, ₹690 de sakta hoon. (₹110 discount!)', NULL, NULL, NULL, 0, '2025-12-28 19:39:12'),
(33, 9, 2, 'customer', 'Amazon pe ₹350 ka mil raha hai, aur features bhi better hai', 350.00, 'POLITE', 'feature_query', 0, '2025-12-28 19:39:33'),
(34, 9, 2, 'shopkeeper', 'Bhai, ₹600 de sakta hoon. (₹200 discount!)', NULL, NULL, NULL, 1, '2025-12-28 19:39:34'),
(35, 9, 3, 'customer', 'Main to soch raha hoon ki yeh worth hai ya nahi, kya warranty diya hai?', NULL, 'NEUTRAL', 'walk_away', 0, '2025-12-28 19:40:23'),
(36, 9, 3, 'shopkeeper', 'Koi baat nahi bhai. Kabhi aur aana! 🙏', NULL, NULL, NULL, 0, '2025-12-28 19:40:23'),
(37, 10, 1, 'customer', 'Main to soch raha hoon ki yeh worth hai ya nahi, kya warranty diya hai?', NULL, 'NEUTRAL', 'walk_away', 0, '2025-12-28 19:42:45'),
(38, 10, 1, 'shopkeeper', 'Koi baat nahi bhai. Kabhi aur aana! 🙏', NULL, NULL, NULL, 0, '2025-12-28 19:42:45'),
(39, 11, 1, 'customer', 'Main to soch raha hoon ki yeh worth hai ya nahi, kya warranty diya hai?', NULL, 'NEUTRAL', 'walk_away', 0, '2025-12-28 19:46:05'),
(40, 11, 1, 'shopkeeper', 'Koi baat nahi bhai. Kabhi aur aana! 🙏', NULL, NULL, NULL, 0, '2025-12-28 19:46:05'),
(41, 12, 1, 'customer', 'me iska 1500 de sakta hoon', 1500.00, 'NEUTRAL', 'price_offer', 0, '2025-12-28 19:47:22'),
(42, 12, 1, 'shopkeeper', 'Bhai, ₹3,100 de sakta hoon. (₹400 discount!)', NULL, NULL, NULL, 0, '2025-12-28 19:47:22'),
(43, 12, 2, 'customer', 'Amazon pe toh iska price 2100 he yaahaa par itna costly kiu he', 2100.00, 'COMPARING', 'comparison', 0, '2025-12-28 19:48:00'),
(44, 12, 2, 'shopkeeper', 'Bhai, ₹3,100 to ₹2,800 kam nahi karenga, ₹3,000 par chalne ke liye taiyaar hoon.', NULL, NULL, NULL, 1, '2025-12-28 19:48:05'),
(45, 12, 3, 'customer', 'please 2500 me de do bhaiya..!', 2500.00, 'POLITE', 'polite', 0, '2025-12-28 19:48:45'),
(46, 12, 3, 'shopkeeper', 'Bhai, ₹2,800 de sakta hoon. (₹700 discount!)', NULL, NULL, NULL, 0, '2025-12-28 19:48:45'),
(47, 12, 4, 'customer', 'ok last 2700 me de do na mera na aapkaa please', 2700.00, 'POLITE', 'polite', 0, '2025-12-28 19:49:18'),
(48, 12, 4, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹2,700 me aapka!', NULL, NULL, NULL, 0, '2025-12-28 19:49:18'),
(49, 13, 1, 'customer', 'kon si brand ki watch he ye ?', NULL, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:51:03'),
(50, 13, 1, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹3,500 hai.', NULL, NULL, NULL, 0, '2025-12-28 19:51:03'),
(51, 13, 2, 'customer', 'kon si brand ki watch he ye ?', NULL, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:51:08'),
(52, 13, 2, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹3,500 hai.', NULL, NULL, NULL, 0, '2025-12-28 19:51:08'),
(53, 13, 3, 'customer', '5000', 5000.00, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:51:16'),
(54, 13, 3, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹5,000 me aapka!', NULL, NULL, NULL, 0, '2025-12-28 19:51:16'),
(55, 14, 1, 'customer', 'Warranty kitne saal ki hai?', NULL, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:52:44'),
(56, 14, 1, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹1,000 hai.', NULL, NULL, NULL, 0, '2025-12-28 19:52:44'),
(57, 14, 2, 'customer', 'Kya features hai?', NULL, 'NEUTRAL', 'feature_query', 0, '2025-12-28 19:54:46'),
(58, 14, 2, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹1,000 hai.', NULL, NULL, NULL, 0, '2025-12-28 19:54:46'),
(59, 14, 3, 'customer', 'Do lene par kitne hoga?', NULL, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:55:04'),
(60, 14, 3, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹1,000 hai.', NULL, NULL, NULL, 0, '2025-12-28 19:55:04'),
(61, 14, 4, 'customer', 'Amazon pe ₹600 ka mil raha hai.Kripiya 600 me dedo please ?', 600.00, 'POLITE', 'polite', 0, '2025-12-28 19:56:11'),
(62, 14, 4, 'shopkeeper', 'Bhai, yeh sab features hai, aur wo bhi 30 ghante tak chalne wale battery ke saath aaya hai, ₹1,000 mein yaar.', NULL, NULL, NULL, 1, '2025-12-28 19:56:17'),
(63, 14, 5, 'customer', '1000', 1000.00, 'NEUTRAL', 'negotiating', 0, '2025-12-28 19:56:58'),
(64, 14, 5, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹1,000 me aapka!', NULL, NULL, NULL, 0, '2025-12-28 19:56:58'),
(65, 16, 1, 'customer', 'Kya features hai?', NULL, 'NEUTRAL', 'features_query', 0, '2025-12-28 20:00:39'),
(66, 16, 1, 'shopkeeper', 'Bhai, isme Noise Cancellation, 30hr Battery, Wireless, Voice Assistant features hai. Bohot accha quality hai!', NULL, NULL, NULL, 1, '2025-12-28 20:00:41'),
(67, 16, 2, 'customer', 'Warranty kitne saal ki hai?', NULL, 'NEUTRAL', 'warranty_query', 0, '2025-12-28 20:00:41'),
(68, 16, 2, 'shopkeeper', 'Bhai, 1 Year warranty hai. Full guarantee!', NULL, NULL, NULL, 1, '2025-12-28 20:00:42'),
(69, 17, 1, 'customer', 'kya features hai?', NULL, 'NEUTRAL', 'features_query', 0, '2025-12-28 20:12:41'),
(70, 17, 1, 'shopkeeper', 'Bhai, isme Smart Watch, Heart Rate, Water Resistant, GPS features hai. Bohot accha quality hai!', NULL, NULL, NULL, 0, '2025-12-28 20:12:41'),
(71, 17, 2, 'customer', 'Warranty kitne saal ki hai?', NULL, 'NEUTRAL', 'warranty_query', 0, '2025-12-28 20:13:02'),
(72, 17, 2, 'shopkeeper', 'Bhai, 1 Year warranty hai. Full guarantee!', NULL, NULL, NULL, 0, '2025-12-28 20:13:02'),
(73, 17, 3, 'customer', 'Amazon me toh 1500 kaa de raahaa he yaahaa par itna costly kiu hai?', 1500.00, 'COMPARING', 'comparison', 0, '2025-12-28 20:13:47'),
(74, 17, 3, 'shopkeeper', 'Bhai, yeh market mein best price hai. ₹3,000 se kam nahi ho sakta.', NULL, NULL, NULL, 1, '2025-12-28 20:13:49'),
(75, 17, 4, 'customer', 'last kitna tak discount ho sakta he ?', NULL, 'NEUTRAL', 'final_offer', 0, '2025-12-28 20:14:14'),
(76, 17, 4, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹3,000 hai.', NULL, NULL, NULL, 0, '2025-12-28 20:14:14'),
(77, 17, 5, 'customer', 'me iska 1500 de sakta hoon', 1500.00, 'NEUTRAL', 'price_offer', 0, '2025-12-28 20:14:30'),
(78, 17, 5, 'shopkeeper', 'Bhai, ₹2,700 de sakta hoon. (₹800 discount!)', NULL, NULL, NULL, 0, '2025-12-28 20:14:30'),
(79, 17, 6, 'customer', 'bohot costly he bhai ye toh', NULL, 'NEUTRAL', 'negotiating', 0, '2025-12-28 20:14:54'),
(80, 17, 6, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹2,700 hai.', NULL, NULL, NULL, 0, '2025-12-28 20:14:54'),
(81, 17, 7, 'customer', 'Dusre online platfrom me toh 2000 me de raahaa he', 2000.00, 'COMPARING', 'comparison', 0, '2025-12-28 20:15:41'),
(82, 17, 7, 'shopkeeper', 'Bhai, yeh market mein best price hai. ₹2,400 se kam nahi ho sakta.', NULL, NULL, NULL, 0, '2025-12-28 20:15:41'),
(83, 17, 8, 'customer', 'last 2050 de sakta hoon eskaa me', 2050.00, 'NEUTRAL', 'final_offer', 0, '2025-12-28 20:16:13'),
(84, 17, 8, 'shopkeeper', '⚠️ Bhai final bol rahe ho to ₹2,200 last price.', NULL, NULL, NULL, 0, '2025-12-28 20:16:13'),
(85, 17, 9, 'customer', 'ok 2200', 2200.00, 'POLITE', 'negotiating', 0, '2025-12-28 20:16:24'),
(86, 17, 9, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹2,200 me aapka!', NULL, NULL, NULL, 0, '2025-12-28 20:16:24'),
(87, 18, 1, 'customer', 'Kya features hai?', NULL, 'NEUTRAL', 'features_query', 0, '2025-12-28 20:19:25'),
(88, 18, 1, 'shopkeeper', 'Bhai, isme Noise Cancellation, 30hr Battery, Wireless, Voice Assistant features hai. Bohot accha quality hai!', NULL, NULL, NULL, 0, '2025-12-28 20:19:25'),
(89, 18, 2, 'customer', 'Warranty kitne saal ki hai?', NULL, 'NEUTRAL', 'warranty_query', 0, '2025-12-28 20:19:25'),
(90, 18, 2, 'shopkeeper', 'Bhai, 1 Year warranty hai. Full guarantee!', NULL, NULL, NULL, 0, '2025-12-28 20:19:25'),
(91, 19, 1, 'customer', 'Kya features hai?', NULL, 'NEUTRAL', 'features_query', 0, '2025-12-28 20:20:11'),
(92, 19, 1, 'shopkeeper', 'Bhai, isme Noise Cancellation, 30hr Battery, Wireless, Voice Assistant features hai. Bohot accha quality hai!', NULL, NULL, NULL, 0, '2025-12-28 20:20:11'),
(93, 19, 2, 'customer', 'Warranty kitne saal ki hai?', NULL, 'NEUTRAL', 'warranty_query', 0, '2025-12-28 20:20:11'),
(94, 19, 2, 'shopkeeper', 'Bhai, 1 Year warranty hai. Full guarantee!', NULL, NULL, NULL, 0, '2025-12-28 20:20:11'),
(95, 20, 1, 'customer', 'kya features hai isme?', NULL, 'NEUTRAL', 'features_query', 0, '2025-12-28 20:22:46'),
(96, 20, 1, 'shopkeeper', 'Bhai, isme Smart Watch, Heart Rate, Water Resistant, GPS features hai. Bohot accha quality hai!', NULL, NULL, NULL, 0, '2025-12-28 20:22:46'),
(97, 20, 2, 'customer', 'Bahot gussa  aa raha hai, itna mahanga kyun? Please bhai, thoda kam karo.', NULL, 'POLITE', 'angry', 0, '2025-12-28 20:23:37'),
(98, 20, 2, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹3,500 hai.', NULL, NULL, NULL, 0, '2025-12-28 20:23:37'),
(99, 20, 3, 'customer', 'Amazon pe ₹1500 ka mil raha hai aur markat me 1750 ka', 1500.00, 'COMPARING', 'comparison', 0, '2025-12-28 20:24:25'),
(100, 20, 3, 'shopkeeper', 'Bhai, yeh market mein best price hai. ₹3,000 se kam nahi ho sakta.', NULL, NULL, NULL, 0, '2025-12-28 20:24:25'),
(101, 20, 4, 'customer', 'features kya he iskaa?', NULL, 'NEUTRAL', 'features_query', 0, '2025-12-28 20:24:46'),
(102, 20, 4, 'shopkeeper', 'Bhai, isme Smart Watch, Heart Rate, Water Resistant, GPS features hai. Bohot accha quality hai!', NULL, NULL, NULL, 0, '2025-12-28 20:24:46'),
(103, 20, 5, 'customer', 'i like the features but the price is too high?', NULL, 'NEUTRAL', 'features_query', 0, '2025-12-28 20:25:18'),
(104, 20, 5, 'shopkeeper', 'Bhai, isme Smart Watch, Heart Rate, Water Resistant, GPS features hai. Bohot accha quality hai!', NULL, NULL, NULL, 0, '2025-12-28 20:25:18'),
(105, 20, 6, 'customer', 'i like the features but the price is too high?', NULL, 'NEUTRAL', 'features_query', 0, '2025-12-28 20:28:06'),
(106, 20, 6, 'shopkeeper', 'Bhai, isme Smart Watch, Heart Rate, Water Resistant, GPS features hai. Bohot accha quality hai!', NULL, NULL, NULL, 0, '2025-12-28 20:28:06'),
(107, 21, 1, 'customer', 'i like the features but the price is too high?', NULL, 'NEUTRAL', 'features_query', 0, '2025-12-28 20:28:38'),
(108, 21, 1, 'shopkeeper', 'Arre, bhai, ₹800 toh bahut mehnga hai, par StyleWear ka quality toh bahut achcha hai, yaar?', NULL, NULL, NULL, 1, '2025-12-28 20:28:41'),
(109, 21, 2, 'customer', 'ok', NULL, 'POLITE', 'negotiating', 0, '2025-12-28 20:30:28'),
(110, 21, 2, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹800 hai.', NULL, NULL, NULL, 0, '2025-12-28 20:30:28'),
(111, 21, 3, 'customer', 'i like the features but the price is too high?', NULL, 'NEUTRAL', 'features_query', 0, '2025-12-28 20:30:35'),
(112, 21, 3, 'shopkeeper', 'Arre bhai, ₹700 toh kuch kam nahi, par ₹750 toh main aapko bahut accha deal deta hoon, yaar?', NULL, NULL, NULL, 1, '2025-12-28 20:30:38'),
(113, 21, 4, 'customer', 'ok deal done..!', NULL, 'POLITE', 'negotiating', 0, '2025-12-28 20:31:02'),
(114, 21, 4, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹800 hai.', NULL, NULL, NULL, 0, '2025-12-28 20:31:02'),
(115, 21, 5, 'customer', '700', 700.00, 'NEUTRAL', 'negotiating', 0, '2025-12-28 20:31:07'),
(116, 21, 5, 'shopkeeper', 'Bhai, ₹720 de sakta hoon. (₹80 discount!)', NULL, NULL, NULL, 0, '2025-12-28 20:31:07'),
(117, 21, 6, 'customer', 'no i can give 700 not more than that', 700.00, 'NEUTRAL', 'negotiating', 0, '2025-12-28 20:31:25'),
(118, 21, 6, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹700 me aapka!', NULL, NULL, NULL, 0, '2025-12-28 20:31:25'),
(119, 22, 1, 'customer', 'Kripya 9000 kar dijiye, Amazon par 9500 kaa milraahaa he', 9000.00, 'POLITE', 'comparison', 0, '2025-12-29 09:05:30'),
(120, 22, 1, 'shopkeeper', 'Bhai, main aapko ₹11,500 kharidne ke liye taiyaar hoon, yaar?', NULL, NULL, NULL, 1, '2025-12-29 09:05:33'),
(121, 22, 2, 'customer', 'Warranty kitne saal ki hai?', NULL, 'NEUTRAL', 'warranty_query', 0, '2025-12-29 09:06:26'),
(122, 22, 2, 'shopkeeper', 'Bhai, 2 Years warranty hai. Full guarantee!', NULL, NULL, NULL, 0, '2025-12-29 09:06:26'),
(123, 22, 3, 'customer', 'kya features hai?', NULL, 'NEUTRAL', 'features_query', 0, '2025-12-29 09:06:45'),
(124, 22, 3, 'shopkeeper', 'Bhai, isme 6GB RAM, 128GB Storage, 48MP Camera, 5000mAh features hai. Bohot accha quality hai!', NULL, NULL, NULL, 0, '2025-12-29 09:06:45'),
(125, 22, 4, 'customer', 'what are its features ?', NULL, 'NEUTRAL', 'features_query', 0, '2025-12-29 09:07:01'),
(126, 22, 4, 'shopkeeper', 'Bhai, isme 6GB RAM, 128GB Storage, 48MP Camera, 5000mAh features hai. Bohot accha quality hai!', NULL, NULL, NULL, 0, '2025-12-29 09:07:01'),
(127, 23, 1, 'customer', 'I want to take in bulk quantity?', NULL, 'NEUTRAL', 'bulk_purchase', 0, '2025-12-29 09:09:40'),
(128, 23, 1, 'shopkeeper', 'Bhai, bulk mein ₹3,150 per piece de sakta hoon. Kitne chahiye?', NULL, NULL, NULL, 0, '2025-12-29 09:09:40'),
(129, 23, 2, 'customer', 'me bulk me lunga toh iska 2000 tak de sakta hoon', 2000.00, 'NEUTRAL', 'bulk_purchase', 0, '2025-12-29 09:14:28'),
(130, 23, 2, 'shopkeeper', 'Bhai, bulk mein ₹2,790 per piece de sakta hoon. Kitne chahiye?', NULL, NULL, NULL, 0, '2025-12-29 09:14:28'),
(131, 23, 3, 'customer', 'I want 50 watch', 50.00, 'NEUTRAL', 'negotiating', 0, '2025-12-29 09:15:00'),
(132, 23, 3, 'shopkeeper', 'Bhai, ₹2,800 de sakta hoon. (₹700 discount!)', NULL, NULL, NULL, 0, '2025-12-29 09:15:00'),
(133, 23, 4, 'customer', 'last kitna de sakte hoo mujhe 50 watch chahiye', 50.00, 'NEUTRAL', 'final_offer', 0, '2025-12-29 09:15:36'),
(134, 23, 4, 'shopkeeper', '⚠️ Bhai final bol rahe ho to ₹2,500 last price.', NULL, NULL, NULL, 0, '2025-12-29 09:15:36'),
(135, 23, 5, 'customer', '2000 last dunga nahi toh deal cancel ?', 2000.00, 'NEUTRAL', 'final_offer', 0, '2025-12-29 09:16:39'),
(136, 23, 5, 'shopkeeper', '✅ Theek hai bhai! ₹2,000 me deal!', NULL, NULL, NULL, 0, '2025-12-29 09:16:39'),
(137, 23, 6, 'customer', 'ok deal done', NULL, 'POLITE', 'negotiating', 0, '2025-12-29 09:18:06'),
(138, 23, 6, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹2,200 hai.', NULL, NULL, NULL, 0, '2025-12-29 09:18:06'),
(139, 23, 7, 'customer', '2000', 2000.00, 'NEUTRAL', 'negotiating', 0, '2025-12-29 09:18:12'),
(140, 23, 7, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹2,000 me aapka!', NULL, NULL, NULL, 0, '2025-12-29 09:18:12'),
(141, 24, 1, 'customer', 'How are you ?', NULL, 'NEUTRAL', 'negotiating', 0, '2025-12-29 09:21:00'),
(142, 24, 1, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹12,000 hai.', NULL, NULL, NULL, 0, '2025-12-29 09:21:00'),
(143, 24, 2, 'customer', 'i want to do query about a session id ?', NULL, 'NEUTRAL', 'negotiating', 0, '2025-12-29 09:21:17'),
(144, 24, 2, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹12,000 hai.', NULL, NULL, NULL, 0, '2025-12-29 09:21:17'),
(145, 24, 3, 'customer', 'session_1766999343_8260', NULL, 'NEUTRAL', 'negotiating', 0, '2025-12-29 09:21:39'),
(146, 24, 3, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹12,000 hai.', NULL, NULL, NULL, 0, '2025-12-29 09:21:39'),
(147, 25, 1, 'customer', 'Amazon par toh iskaa price 11000 he.kripya 9000 me de do', 11000.00, 'POLITE', 'comparison', 0, '2025-12-29 17:24:58'),
(148, 25, 1, 'shopkeeper', 'Arre bhai, is phone ki koi deal nahin kar sakte, main iski khaarcha hai ₹12,000, toh kuch kam nahin kar sakta.', NULL, NULL, NULL, 1, '2025-12-29 17:25:03'),
(149, 25, 2, 'customer', 'Toh phir kitna me doge ?', NULL, 'NEUTRAL', 'price_query', 0, '2025-12-29 17:25:45'),
(150, 25, 2, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹12,000 hai.', NULL, NULL, NULL, 0, '2025-12-29 17:25:45'),
(151, 25, 3, 'customer', 'main toh iska 9000 de sakta hoon', 9000.00, 'NEUTRAL', 'price_offer', 0, '2025-12-29 17:26:08'),
(152, 25, 3, 'shopkeeper', 'Bhai, ₹10,800 de sakta hoon. (₹1,200 discount!)', NULL, NULL, NULL, 0, '2025-12-29 17:26:08'),
(153, 25, 4, 'customer', 'online market me toh iska price 9100 he yaar', 9100.00, 'COMPARING', 'comparison', 0, '2025-12-29 17:26:42'),
(154, 25, 4, 'shopkeeper', 'Bhai, yeh market mein best price hai. ₹9,700 se kam nahi ho sakta.', NULL, NULL, NULL, 0, '2025-12-29 17:26:42'),
(155, 25, 5, 'customer', 'what are its features bro?', NULL, 'NEUTRAL', 'features_query', 0, '2025-12-29 17:27:08'),
(156, 25, 5, 'shopkeeper', 'Bhai, yeh phone ka 48MP camera aur 5000mAh battery bahut achha hai, ₹9,700 mein to bahut achha deal hai yaar!', NULL, NULL, NULL, 1, '2025-12-29 17:27:14'),
(157, 25, 6, 'customer', 'As per its features i will pay 9100 not more than will make something less on it?', 9100.00, 'NEUTRAL', 'features_query', 0, '2025-12-29 17:28:08'),
(158, 25, 6, 'shopkeeper', 'Bhai, ₹9100 toh wahi offer hai jo tumne pehle kiya tha, lekin main aapko ₹9,700 mein deal karne mein majboor nahi hoon, yaar!', NULL, NULL, NULL, 1, '2025-12-29 17:28:11'),
(159, 25, 7, 'customer', 'ok nahi mera na tumhara 9250 me deal done karte he', 9250.00, 'POLITE', 'walk_away', 0, '2025-12-29 17:29:01'),
(160, 25, 7, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹9,250 me aapka!', NULL, NULL, NULL, 0, '2025-12-29 17:29:01'),
(161, 26, 1, 'customer', '5000', 5000.00, 'NEUTRAL', 'negotiating', 0, '2025-12-29 17:31:42'),
(162, 26, 1, 'shopkeeper', 'Bhai, ₹10,700 de sakta hoon. (₹1,300 discount!)', NULL, NULL, NULL, 0, '2025-12-29 17:31:42'),
(163, 26, 2, 'customer', 'nahi 5550', 5550.00, 'NEUTRAL', 'walk_away', 0, '2025-12-29 17:31:53'),
(164, 26, 2, 'shopkeeper', 'Koi baat nahi bhai. Kabhi aur aana! 🙏', NULL, NULL, NULL, 0, '2025-12-29 17:31:53'),
(165, 27, 1, 'customer', '50', 50.00, 'NEUTRAL', 'negotiating', 0, '2025-12-29 17:32:17'),
(166, 27, 1, 'shopkeeper', 'Bhai, ₹640 de sakta hoon. (₹160 discount!)', NULL, NULL, NULL, 0, '2025-12-29 17:32:17'),
(167, 27, 2, 'customer', 'main iska 150 de sakta hoon', 150.00, 'NEUTRAL', 'price_offer', 0, '2025-12-29 17:32:38'),
(168, 27, 2, 'shopkeeper', 'Bhai, ₹520 de sakta hoon. (₹280 discount!)', NULL, NULL, NULL, 0, '2025-12-29 17:32:38'),
(169, 27, 3, 'customer', 'ab tum mujhe gussa dilaarahe hoon,loot lagaa ke rakha he yrr tum logo ne toh', NULL, 'ANGRY', 'angry', 0, '2025-12-29 17:33:36'),
(170, 27, 3, 'shopkeeper', 'Bhai, ₹580 de sakta hoon, yeh toh bahut accha deal hai, yaar?', NULL, NULL, NULL, 1, '2025-12-29 17:33:41'),
(171, 27, 4, 'customer', 'bohot mahanga ho jaayegaa yr toh', NULL, 'ANGRY', 'angry', 0, '2025-12-29 17:34:12'),
(172, 27, 4, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹520 hai.', NULL, NULL, NULL, 0, '2025-12-29 17:34:12'),
(173, 27, 5, 'customer', '200 dunga', 200.00, 'NEUTRAL', 'price_offer', 0, '2025-12-29 17:34:46'),
(174, 27, 5, 'shopkeeper', 'Bhai, ₹470 de sakta hoon. (₹330 discount!)', NULL, NULL, NULL, 0, '2025-12-29 17:34:46'),
(175, 27, 6, 'customer', 'kripya 200 me de dijye aapka bohot meherbani hogaa', 200.00, 'POLITE', 'polite', 0, '2025-12-29 17:36:40'),
(176, 27, 6, 'shopkeeper', 'Bhai, ₹420 de sakta hoon. (₹380 discount!)', NULL, NULL, NULL, 0, '2025-12-29 17:36:40'),
(177, 27, 7, 'customer', 'ok', NULL, 'POLITE', 'negotiating', 0, '2025-12-29 17:36:45'),
(178, 27, 7, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹420 hai.', NULL, NULL, NULL, 0, '2025-12-29 17:36:45'),
(179, 27, 8, 'customer', '400 is last', 400.00, 'NEUTRAL', 'final_offer', 0, '2025-12-29 17:36:54'),
(180, 27, 8, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹400 me aapka!', NULL, NULL, NULL, 0, '2025-12-29 17:36:54'),
(181, 28, 1, 'customer', 'Iska features kya hai aur warranty kitne saal ki hai?', NULL, 'NEUTRAL', 'features_query', 0, '2025-12-30 04:53:51'),
(182, 28, 1, 'shopkeeper', 'Bhai, Watch TimeMaster mein Smart Watch, Heart Rate monitoring, Water Resistant aur GPS ka feature hai. Warranty 1 saal ki hai, ji.', NULL, NULL, NULL, 1, '2025-12-30 04:53:55'),
(183, 28, 2, 'customer', 'Amazon pe toh 1500 me milraahaa he ye watch', 1500.00, 'COMPARING', 'comparison', 0, '2025-12-30 04:55:43'),
(184, 28, 2, 'shopkeeper', 'Bhai, yeh market mein best price hai. ₹3,100 se kam nahi ho sakta.', NULL, NULL, NULL, 0, '2025-12-30 04:55:43'),
(185, 28, 3, 'customer', 'Kripya 1600 me kar dijiye, Online market me 1500 me de raahaa he', 1600.00, 'POLITE', 'comparison', 0, '2025-12-30 04:57:11'),
(186, 28, 3, 'shopkeeper', 'Bhai, yeh watch market mein bahut hi acchi quality hai, ₹3,100 mein bhi aapko lagta hai yaar? Main aapko 1500 se kam nahin de sakta, par main aapko 1550 mein le ja sakta hoon, kya?', NULL, NULL, NULL, 1, '2025-12-30 04:57:16'),
(187, 28, 4, 'customer', 'ok 1550 me do', 1550.00, 'POLITE', 'negotiating', 0, '2025-12-30 04:58:00'),
(188, 28, 4, 'shopkeeper', 'Bhai, ₹2,800 de sakta hoon. (₹700 discount!)', NULL, NULL, NULL, 0, '2025-12-30 04:58:00'),
(189, 28, 5, 'customer', '1550', 1550.00, 'NEUTRAL', 'negotiating', 0, '2025-12-30 04:58:19'),
(190, 28, 5, 'shopkeeper', 'Bhai, ₹2,500 de sakta hoon. (₹1,000 discount!)', NULL, NULL, NULL, 0, '2025-12-30 04:58:19'),
(191, 30, 1, 'customer', '6', 6.00, 'NEUTRAL', 'negotiating', 0, '2025-12-30 05:09:58'),
(192, 30, 1, 'shopkeeper', 'Bhai, ₹10,500 de sakta hoon. (₹1,500 discount!)', NULL, NULL, NULL, 0, '2025-12-30 05:09:58'),
(193, 30, 2, 'customer', 'Amazon pe toh 6000 kaa deraahaa he', 6000.00, 'COMPARING', 'comparison', 0, '2025-12-30 05:10:23'),
(194, 30, 2, 'shopkeeper', 'Bhai, yeh market mein best price hai. ₹9,400 se kam nahi ho sakta.', NULL, NULL, NULL, 0, '2025-12-30 05:10:23'),
(195, 30, 3, 'customer', 'iska features kiya he', NULL, 'NEUTRAL', 'features_query', 0, '2025-12-30 05:10:35'),
(196, 30, 3, 'shopkeeper', 'Bhai, isme 6GB RAM, 128GB Storage, 48MP Camera, 5000mAh features hai. Bohot accha quality hai!', NULL, NULL, NULL, 0, '2025-12-30 05:10:35'),
(197, 31, 1, 'customer', 'I will pay 5000 for this product', 5000.00, 'NEUTRAL', 'negotiating', 0, '2025-12-30 05:21:42'),
(198, 31, 1, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹5,000 me aapka!', NULL, NULL, NULL, 0, '2025-12-30 05:21:42'),
(199, 34, 1, 'customer', 'main iska 6500 de skata hoon', 6500.00, 'NEUTRAL', 'price_offer', 0, '2025-12-30 16:48:40'),
(200, 34, 1, 'shopkeeper', 'Bhai, ₹11,400 de sakta hoon. (₹600 discount!)', NULL, NULL, NULL, 0, '2025-12-30 16:48:40'),
(201, 34, 2, 'customer', 'mera bhai ne kal hi 6500 kaa kharidaa he amazon se', 6500.00, 'COMPARING', 'comparison', 0, '2025-12-30 16:49:08'),
(202, 34, 2, 'shopkeeper', 'Bhai, yeh market mein best price hai. ₹10,850 se kam nahi ho sakta.', NULL, NULL, NULL, 0, '2025-12-30 16:49:08'),
(203, 34, 3, 'customer', 'amazon me toh iska price 6500 he tum toh loot rahe hoo', 6500.00, 'ANGRY', 'comparison', 0, '2025-12-30 16:49:41'),
(204, 34, 3, 'shopkeeper', 'Bhai, ₹11,400 de sakta hoon, lekin main tumhe ₹11,200 de sakta hoon, kya?', NULL, NULL, NULL, 1, '2025-12-30 16:49:44'),
(205, 34, 4, 'customer', 'iskaa features aur warranty kesaa he', NULL, 'NEUTRAL', 'features_query', 0, '2025-12-30 16:50:08'),
(206, 34, 4, 'shopkeeper', 'Bhai, isme 6GB RAM, 128GB Storage, 48MP Camera, 5000mAh features hai. Bohot accha quality hai!', NULL, NULL, NULL, 0, '2025-12-30 16:50:08'),
(207, 34, 5, 'customer', 'warranty kitna hoga isme', NULL, 'NEUTRAL', 'warranty_query', 0, '2025-12-30 16:50:25'),
(208, 34, 5, 'shopkeeper', 'Bhai, 2 Years warranty hai. Full guarantee!', NULL, NULL, NULL, 0, '2025-12-30 16:50:25'),
(209, 34, 6, 'customer', 'thik he toh 7000 me dedo please', 7000.00, 'POLITE', 'polite', 0, '2025-12-30 16:50:41'),
(210, 34, 6, 'shopkeeper', 'Bhai, ₹10,300 de sakta hoon. (₹1,700 discount!)', NULL, NULL, NULL, 0, '2025-12-30 16:50:41'),
(211, 34, 7, 'customer', 'last kitna me doge nahi toh me amazon se kharid lunga', NULL, 'COMPARING', 'final_offer', 0, '2025-12-30 16:51:13'),
(212, 34, 7, 'shopkeeper', 'Bhai, ₹10,300 hai, par main aapko ₹10,500 de sakta hoon, yaar?', NULL, NULL, NULL, 1, '2025-12-30 16:51:19'),
(213, 34, 8, 'customer', '10300 me hai aur tum mujhe 10500  me doge', 10300.00, 'NEUTRAL', 'negotiating', 0, '2025-12-30 16:52:13'),
(214, 34, 8, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹10,300 me aapka!', NULL, NULL, NULL, 0, '2025-12-30 16:52:13'),
(215, 35, 1, 'customer', 'main iska 1500 dunga', 1500.00, 'NEUTRAL', 'price_offer', 0, '2026-01-06 04:55:04'),
(216, 35, 1, 'shopkeeper', 'Bhai, ₹3,300 de sakta hoon. (₹200 discount!)', NULL, NULL, NULL, 0, '2026-01-06 04:55:04'),
(217, 35, 2, 'customer', 'Amazon me toh 1600 kaa de raahaa he', 1600.00, 'COMPARING', 'comparison', 0, '2026-01-06 04:55:30'),
(218, 35, 2, 'shopkeeper', 'Bhai, yeh market mein best price hai. ₹3,150 se kam nahi ho sakta.', NULL, NULL, NULL, 0, '2026-01-06 04:55:30'),
(219, 35, 3, 'customer', 'Iska features kiya he?', NULL, 'NEUTRAL', 'features_query', 0, '2026-01-06 04:55:53'),
(220, 35, 3, 'shopkeeper', 'Bhai, yeh watch bahut hi acchi quality mein hai, ₹3,150 mein to bahut mehnga nahi hai, yaar?', NULL, NULL, NULL, 1, '2026-01-06 04:55:57'),
(221, 35, 4, 'customer', 'what is its feature', NULL, 'NEUTRAL', 'features_query', 0, '2026-01-06 04:56:09'),
(222, 35, 4, 'shopkeeper', 'Bhai, isme Smart Watch, Heart Rate, Water Resistant, GPS features hai. Bohot accha quality hai!', NULL, NULL, NULL, 0, '2026-01-06 04:56:09'),
(223, 35, 5, 'customer', 'warranty kitna he', NULL, 'NEUTRAL', 'warranty_query', 0, '2026-01-06 04:56:25'),
(224, 35, 5, 'shopkeeper', 'Bhai, 1 Year warranty hai. Full guarantee!', NULL, NULL, NULL, 0, '2026-01-06 04:56:25'),
(225, 35, 6, 'customer', 'iska features or warranty kiya he', NULL, 'NEUTRAL', 'features_query', 0, '2026-01-06 04:56:50'),
(226, 35, 6, 'shopkeeper', 'Bhai, isme Smart Watch, Heart Rate, Water Resistant, GPS features hai. Bohot accha quality hai!', NULL, NULL, NULL, 0, '2026-01-06 04:56:50'),
(227, 35, 7, 'customer', 'last kina me doge tum', NULL, 'NEUTRAL', 'final_offer', 0, '2026-01-06 04:57:07'),
(228, 35, 7, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹3,150 hai.', NULL, NULL, NULL, 0, '2026-01-06 04:57:09'),
(229, 35, 8, 'customer', '2000 uuse jiyaadaa nahi de sakta hoon', 2000.00, 'NEUTRAL', 'walk_away', 0, '2026-01-06 04:57:29'),
(230, 35, 8, 'shopkeeper', 'Koi baat nahi bhai. Kabhi aur aana! 🙏', NULL, NULL, NULL, 0, '2026-01-06 04:57:33'),
(231, 36, 1, 'customer', 'main iska 500 dunga', 500.00, 'NEUTRAL', 'price_offer', 0, '2026-01-06 05:02:12'),
(232, 36, 1, 'shopkeeper', 'Bhai, ₹950 de sakta hoon. (₹50 discount!)', NULL, NULL, NULL, 0, '2026-01-06 05:02:12'),
(233, 36, 2, 'customer', '950 toh bohot jiyaadaa hoga me 550 dunga', 950.00, 'NEUTRAL', 'price_offer', 0, '2026-01-06 05:02:37'),
(234, 36, 2, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹950 me aapka!', NULL, NULL, NULL, 0, '2026-01-06 05:02:37'),
(235, 37, 1, 'customer', '500', 500.00, 'NEUTRAL', 'negotiating', 0, '2026-01-06 05:03:59'),
(236, 37, 1, 'shopkeeper', 'Bhai, ₹950 de sakta hoon. (₹50 discount!)', NULL, NULL, NULL, 0, '2026-01-06 05:03:59'),
(237, 37, 2, 'customer', 'amazon me toh 550 me de rahaahe me iska 525 de sakta hu', 550.00, 'COMPARING', 'comparison', 0, '2026-01-06 05:05:02'),
(238, 37, 2, 'shopkeeper', 'Bhai, ₹900 ka offer karo ya phir main kuch aur dikhaoonga.', NULL, NULL, NULL, 1, '2026-01-06 05:05:06'),
(239, 37, 3, 'customer', 'nahi bhai bohot jiyaadaa huya 900 uthna de skata market or online se bhi jiyaadaa he', 900.00, 'COMPARING', 'comparison', 0, '2026-01-06 05:05:51'),
(240, 37, 3, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹900 me aapka!', NULL, NULL, NULL, 1, '2026-01-06 05:06:01'),
(241, 39, 1, 'customer', '500', 500.00, 'NEUTRAL', 'negotiating', 0, '2026-01-06 05:18:29'),
(242, 39, 1, 'shopkeeper', 'Bhai, ₹950 de sakta hoon. (₹50 discount!)', NULL, NULL, NULL, 0, '2026-01-06 05:18:29'),
(243, 39, 2, 'customer', 'market me toh iska price 600 he bhai', 600.00, 'COMPARING', 'comparison', 0, '2026-01-06 05:19:59'),
(244, 39, 2, 'shopkeeper', 'Bhai, yeh market mein best price hai. ₹900 se kam nahi ho sakta.', NULL, NULL, NULL, 0, '2026-01-06 05:19:59'),
(245, 39, 3, 'customer', 'par amazon me toh 550 kaa de raahaa he yaahaa itna mehenge kiu', 550.00, 'COMPARING', 'comparison', 0, '2026-01-06 05:20:32'),
(246, 39, 3, 'shopkeeper', 'Bhai, yeh market mein best price hai. ₹850 se kam nahi ho sakta.', NULL, NULL, NULL, 0, '2026-01-06 05:20:32'),
(247, 39, 4, 'customer', 'iska feautures kiya he ?', NULL, 'NEUTRAL', 'negotiating', 0, '2026-01-06 05:20:57'),
(248, 39, 4, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹850 hai.', NULL, NULL, NULL, 0, '2026-01-06 05:20:57'),
(249, 39, 5, 'customer', 'what is its features ?', NULL, 'NEUTRAL', 'features_query', 0, '2026-01-06 05:21:11'),
(250, 39, 5, 'shopkeeper', 'Bhai, isme Noise Cancellation, 30hr Battery, Wireless, Voice Assistant features hai. Bohot accha quality hai!', NULL, NULL, NULL, 0, '2026-01-06 05:21:11'),
(251, 39, 6, 'customer', 'iska features', NULL, 'NEUTRAL', 'features_query', 0, '2026-01-06 05:21:20'),
(252, 39, 6, 'shopkeeper', 'Bhai, isme Noise Cancellation, 30hr Battery, Wireless, Voice Assistant features hai. Bohot accha quality hai!', NULL, NULL, NULL, 0, '2026-01-06 05:21:20'),
(253, 39, 7, 'customer', 'warranty ?', NULL, 'NEUTRAL', 'warranty_query', 0, '2026-01-06 05:21:27'),
(254, 39, 7, 'shopkeeper', 'Bhai, 1 Year warranty hai. Full guarantee!', NULL, NULL, NULL, 0, '2026-01-06 05:21:27'),
(255, 39, 8, 'customer', 'Amazon me toh 600 kaa de raahaa he', 600.00, 'COMPARING', 'comparison', 0, '2026-01-06 05:21:51'),
(256, 39, 8, 'shopkeeper', 'Bhai, yeh market mein best price hai. ₹800 se kam nahi ho sakta.', NULL, NULL, NULL, 0, '2026-01-06 05:21:51'),
(257, 39, 9, 'customer', 'ok', NULL, 'POLITE', 'negotiating', 0, '2026-01-06 05:21:59'),
(258, 39, 9, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹800 hai.', NULL, NULL, NULL, 0, '2026-01-06 05:21:59'),
(259, 39, 10, 'customer', '800 toh bohot jiyaa ho jaayega me iska 650 dunga', 800.00, 'NEUTRAL', 'price_offer', 0, '2026-01-06 05:22:34'),
(260, 39, 10, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹800 me aapka!', NULL, NULL, NULL, 0, '2026-01-06 05:22:34'),
(261, 40, 1, 'customer', 'main iska 200 dunga kiu ki online me iska price itna hi he', 200.00, 'COMPARING', 'comparison', 0, '2026-02-23 16:14:40'),
(262, 40, 1, 'shopkeeper', 'Bhai, yeh market mein best price hai. ₹950 se kam nahi ho sakta.', NULL, NULL, NULL, 0, '2026-02-23 16:14:44'),
(263, 40, 2, 'customer', 'thik he toh 500 me de do amazon onlime me itna me detaa he', 500.00, 'COMPARING', 'comparison', 0, '2026-02-23 16:15:20'),
(264, 40, 2, 'shopkeeper', 'Bhai, yeh market mein best price hai. ₹900 se kam nahi ho sakta.', NULL, NULL, NULL, 0, '2026-02-23 16:15:20'),
(265, 40, 3, 'customer', 'last kitna me doge tum', NULL, 'NEUTRAL', 'final_offer', 0, '2026-02-23 16:15:33'),
(266, 40, 3, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹900 hai.', NULL, NULL, NULL, 0, '2026-02-23 16:15:33'),
(267, 40, 4, 'customer', 'me 600 dunga', 600.00, 'NEUTRAL', 'price_offer', 0, '2026-02-23 16:15:41'),
(268, 40, 4, 'shopkeeper', 'Bhai, ₹850 de sakta hoon. (₹150 discount!)', NULL, NULL, NULL, 0, '2026-02-23 16:15:41'),
(269, 40, 5, 'customer', 'ok 850', 850.00, 'POLITE', 'negotiating', 0, '2026-02-23 16:15:50'),
(270, 40, 5, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹850 me aapka!', NULL, NULL, NULL, 0, '2026-02-23 16:15:50'),
(271, 43, 1, 'customer', '₹800 doge?', 800.00, 'NEUTRAL', 'price_offer', 0, '2026-02-23 18:08:25'),
(272, 43, 1, 'shopkeeper', 'Bhai, ₹950 de sakta hoon. (₹50 discount!)', NULL, NULL, NULL, 0, '2026-02-23 18:08:25'),
(273, 43, 2, 'customer', '₹850 final?', 850.00, 'NEUTRAL', 'final_offer', 0, '2026-02-23 18:08:28'),
(274, 43, 2, 'shopkeeper', '⚠️ Bhai final bol rahe ho to ₹900 last price.', NULL, NULL, NULL, 0, '2026-02-23 18:08:28'),
(275, 43, 3, 'customer', 'Warranty kitne saal ki hai?', NULL, 'NEUTRAL', 'warranty_query', 0, '2026-02-23 18:08:31'),
(276, 43, 3, 'shopkeeper', 'Bhai, 1 Year warranty hai. Full guarantee!', NULL, NULL, NULL, 0, '2026-02-23 18:08:31'),
(277, 44, 1, 'customer', '₹70,000 doge?', NULL, 'NEUTRAL', 'price_offer', 0, '2026-02-23 18:13:06'),
(278, 44, 1, 'shopkeeper', 'Kitna de sakte ho bhai? Current price ₹1,000 hai.', NULL, NULL, NULL, 0, '2026-02-23 18:13:06'),
(279, 45, 1, 'customer', '?800 doge?', 800.00, 'NEUTRAL', 'price_offer', 0, '2026-02-23 18:19:24'),
(280, 45, 1, 'shopkeeper', 'Bhai, ₹950 de sakta hoon. (₹50 discount!)', NULL, NULL, NULL, 0, '2026-02-23 18:19:24'),
(281, 45, 2, 'customer', '?900 doge?', 900.00, 'NEUTRAL', 'price_offer', 0, '2026-02-23 18:20:14'),
(282, 45, 2, 'shopkeeper', '🎉 Wah bhai! Deal pakki! ₹900 me aapka!', NULL, NULL, NULL, 0, '2026-02-23 18:20:14'),
(283, 46, 1, 'customer', '₹800 doge?', 800.00, 'NEUTRAL', 'price_offer', 0, '2026-03-04 18:46:27'),
(284, 46, 1, 'shopkeeper', 'Bhai, ₹950 de sakta hoon. (₹50 discount!)', NULL, NULL, NULL, 0, '2026-03-04 18:46:27'),
(285, 46, 2, 'customer', '₹850 final?', 850.00, 'NEUTRAL', 'final_offer', 0, '2026-03-04 18:46:30'),
(286, 46, 2, 'shopkeeper', '⚠️ Bhai final bol rahe ho to ₹900 last price.', NULL, NULL, NULL, 0, '2026-03-04 18:46:30'),
(287, 46, 3, 'customer', 'Warranty kitne saal ki hai?', NULL, 'NEUTRAL', 'warranty_query', 0, '2026-03-04 18:46:33'),
(288, 46, 3, 'shopkeeper', 'Bhai, 1 Year warranty hai. Full guarantee!', NULL, NULL, NULL, 0, '2026-03-04 18:46:33');

-- --------------------------------------------------------

--
-- Table structure for table `customer_profiles`
--

CREATE TABLE `customer_profiles` (
  `id` bigint(20) NOT NULL,
  `fingerprint` varchar(255) DEFAULT NULL,
  `total_negotiations` int(11) DEFAULT 0,
  `successful_negotiations` int(11) DEFAULT 0,
  `avg_concession_rate` float DEFAULT 0.15,
  `preferred_discount_range` varchar(50) DEFAULT NULL,
  `last_seen` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_profiles`
--

INSERT INTO `customer_profiles` (`id`, `fingerprint`, `total_negotiations`, `successful_negotiations`, `avg_concession_rate`, `preferred_discount_range`, `last_seen`, `created_at`) VALUES
(1, 'a68d1e5044564f5e', 0, 0, 0.15, NULL, '2025-12-28 19:17:31', '2025-12-28 19:17:31'),
(2, 'a3a9c644f4730700', 0, 0, 0.15, NULL, '2025-12-28 19:17:40', '2025-12-28 19:17:40'),
(3, 'b51a453b0910403b', 0, 0, 0.15, NULL, '2025-12-28 19:17:58', '2025-12-28 19:17:58'),
(4, 'cc26f47d582c9e1d', 0, 0, 0.15, NULL, '2025-12-28 19:20:15', '2025-12-28 19:20:15'),
(5, '0079f17ebfddc65a', 0, 0, 0.15, NULL, '2025-12-28 19:20:34', '2025-12-28 19:20:34'),
(6, 'de22a3ea529301cd', 0, 0, 0.15, NULL, '2025-12-28 19:21:20', '2025-12-28 19:21:20'),
(7, 'fb43190d0ca15ea6', 0, 0, 0.15, NULL, '2025-12-28 19:21:40', '2025-12-28 19:21:40'),
(8, 'd4b7e3574ec6bf81', 0, 0, 0.15, NULL, '2025-12-28 19:25:47', '2025-12-28 19:25:47'),
(9, '58e468fcafc94823', 0, 0, 0.15, NULL, '2025-12-28 19:25:55', '2025-12-28 19:25:55'),
(10, '6ad8ee89d48cad4e', 1, 1, 0.15, NULL, '2025-12-28 19:26:00', '2025-12-28 19:26:00'),
(11, '8efdd33a843327ff', 1, 0, 0.15, NULL, '2025-12-28 19:27:24', '2025-12-28 19:27:24'),
(12, 'b2416b2c04d63a96', 1, 1, 0.15, NULL, '2025-12-28 19:30:45', '2025-12-28 19:30:45'),
(13, '58a6e672aa627365', 0, 0, 0.15, NULL, '2025-12-28 19:34:00', '2025-12-28 19:34:00'),
(14, '752eabdbf4a5d1b1', 0, 0, 0.15, NULL, '2025-12-28 19:34:19', '2025-12-28 19:34:19'),
(15, '5e87582accefebc9', 1, 0, 0.15, NULL, '2025-12-28 19:34:46', '2025-12-28 19:34:46'),
(16, '0169841aeffac960', 0, 0, 0.15, NULL, '2025-12-28 19:39:11', '2025-12-28 19:39:11'),
(17, '1b9d17156f013ed4', 0, 0, 0.15, NULL, '2025-12-28 19:39:33', '2025-12-28 19:39:33'),
(18, '16ac9633a4f37ff0', 3, 0, 0.15, NULL, '2025-12-28 19:46:05', '2025-12-28 19:40:23'),
(19, '674c870697e604cf', 0, 0, 0.15, NULL, '2025-12-28 19:47:22', '2025-12-28 19:47:22'),
(20, '767fa0c12c148f60', 0, 0, 0.15, NULL, '2025-12-28 19:48:00', '2025-12-28 19:48:00'),
(21, '513e26bf5d1ca798', 0, 0, 0.15, NULL, '2025-12-28 19:48:45', '2025-12-28 19:48:45'),
(22, '195f1970f8a1e6e4', 1, 1, 0.15, NULL, '2025-12-28 19:49:18', '2025-12-28 19:49:18'),
(23, 'df5a47145dd779ba', 0, 0, 0.15, NULL, '2025-12-28 19:51:03', '2025-12-28 19:51:03'),
(24, 'e4e6b9d13afe8e3d', 1, 1, 0.15, NULL, '2025-12-28 19:51:16', '2025-12-28 19:51:16'),
(25, '9590d9fbb9072ec5', 0, 0, 0.15, NULL, '2025-12-28 19:52:44', '2025-12-28 19:52:44'),
(26, '673a2c126e42093a', 0, 0, 0.15, NULL, '2025-12-28 19:54:46', '2025-12-28 19:54:46'),
(27, '80f6171c0d9ab989', 0, 0, 0.15, NULL, '2025-12-28 19:55:04', '2025-12-28 19:55:04'),
(28, 'a4bc311427965a1d', 0, 0, 0.15, NULL, '2025-12-28 19:56:11', '2025-12-28 19:56:11'),
(29, 'd0aadf323d45f9a7', 1, 1, 0.15, NULL, '2025-12-28 19:56:58', '2025-12-28 19:56:58'),
(30, '0cb0ffb46dd153e6', 0, 0, 0.15, NULL, '2025-12-28 20:00:39', '2025-12-28 20:00:39'),
(31, 'bab043089059adf9', 0, 0, 0.15, NULL, '2025-12-28 20:00:39', '2025-12-28 20:00:39'),
(32, '4e1d28274e61e0e4', 0, 0, 0.15, NULL, '2025-12-28 20:00:39', '2025-12-28 20:00:39'),
(33, 'b3031f42059d1c56', 0, 0, 0.15, NULL, '2025-12-28 20:00:39', '2025-12-28 20:00:39'),
(34, '3e2e60bece74b920', 0, 0, 0.15, NULL, '2025-12-28 20:00:39', '2025-12-28 20:00:39'),
(35, '004adc34b46bd896', 0, 0, 0.15, NULL, '2025-12-28 20:00:39', '2025-12-28 20:00:39'),
(36, '4be75cbf3d983228', 0, 0, 0.15, NULL, '2025-12-28 20:00:39', '2025-12-28 20:00:39'),
(37, '8bf234992378f67e', 0, 0, 0.15, NULL, '2025-12-28 20:00:39', '2025-12-28 20:00:39'),
(38, '9703a16458842c00', 0, 0, 0.15, NULL, '2025-12-28 20:00:39', '2025-12-28 20:00:39'),
(39, '7e2a486b81d459ab', 0, 0, 0.15, NULL, '2025-12-28 20:00:39', '2025-12-28 20:00:39'),
(40, '181e366d852efc57', 0, 0, 0.15, NULL, '2025-12-28 20:00:39', '2025-12-28 20:00:39'),
(41, 'dd19727a0ee0a740', 0, 0, 0.15, NULL, '2025-12-28 20:00:39', '2025-12-28 20:00:39'),
(42, '55573f78141c4042', 0, 0, 0.15, NULL, '2025-12-28 20:13:47', '2025-12-28 20:13:47'),
(43, 'e028891acc2e170c', 0, 0, 0.15, NULL, '2025-12-28 20:14:14', '2025-12-28 20:14:14'),
(44, '15708f1edd89303c', 0, 0, 0.15, NULL, '2025-12-28 20:14:54', '2025-12-28 20:14:54'),
(45, '0fd372c4cbd56b12', 0, 0, 0.15, NULL, '2025-12-28 20:15:41', '2025-12-28 20:15:41'),
(46, 'b5980f71bae5567d', 0, 0, 0.15, NULL, '2025-12-28 20:16:13', '2025-12-28 20:16:13'),
(47, 'ae814f44462956a1', 1, 1, 0.15, NULL, '2025-12-28 20:16:24', '2025-12-28 20:16:24'),
(48, '4edb779d9844a436', 0, 0, 0.15, NULL, '2025-12-28 20:22:46', '2025-12-28 20:22:46'),
(49, 'a13cba20d1e443e2', 0, 0, 0.15, NULL, '2025-12-28 20:23:37', '2025-12-28 20:23:37'),
(50, '1a00de1c9473723b', 0, 0, 0.15, NULL, '2025-12-28 20:24:25', '2025-12-28 20:24:25'),
(51, '37f0e08e58ff2d0f', 0, 0, 0.15, NULL, '2025-12-28 20:24:46', '2025-12-28 20:24:46'),
(52, 'b8c9abc9ad6d2bca', 0, 0, 0.15, NULL, '2025-12-28 20:25:18', '2025-12-28 20:25:18'),
(53, 'e39eceac57b0e88d', 0, 0, 0.15, NULL, '2025-12-28 20:30:28', '2025-12-28 20:30:28'),
(54, '90a55f5eec0a95a4', 0, 0, 0.15, NULL, '2025-12-28 20:31:01', '2025-12-28 20:31:01'),
(55, 'ef721775d7606c31', 1, 1, 0.15, NULL, '2025-12-28 20:31:25', '2025-12-28 20:31:25'),
(56, '2ffe5f95ab0d8fa4', 0, 0, 0.15, NULL, '2025-12-29 09:05:30', '2025-12-29 09:05:30'),
(57, 'db861bc1fe6dc6dd', 0, 0, 0.15, NULL, '2025-12-29 09:07:01', '2025-12-29 09:07:01'),
(58, '47ea9c1e72e7c619', 0, 0, 0.15, NULL, '2025-12-29 09:09:40', '2025-12-29 09:09:40'),
(59, '70cf173d8f90b95f', 0, 0, 0.15, NULL, '2025-12-29 09:14:28', '2025-12-29 09:14:28'),
(60, '4703299f028cac73', 0, 0, 0.15, NULL, '2025-12-29 09:15:00', '2025-12-29 09:15:00'),
(61, 'b8c1f7ec572e1e07', 0, 0, 0.15, NULL, '2025-12-29 09:15:36', '2025-12-29 09:15:36'),
(62, 'b49c6dcb3ded942d', 0, 0, 0.15, NULL, '2025-12-29 09:16:39', '2025-12-29 09:16:39'),
(63, 'fa87050a70e2a83b', 0, 0, 0.15, NULL, '2025-12-29 09:18:06', '2025-12-29 09:18:06'),
(64, '03885bafcc8a903b', 1, 1, 0.15, NULL, '2025-12-29 09:18:12', '2025-12-29 09:18:12'),
(65, '7171521784cd4162', 0, 0, 0.15, NULL, '2025-12-29 09:21:00', '2025-12-29 09:21:00'),
(66, '1dc6621fcfc6eab0', 0, 0, 0.15, NULL, '2025-12-29 09:21:17', '2025-12-29 09:21:17'),
(67, 'd7a6b95aa2a3049c', 0, 0, 0.15, NULL, '2025-12-29 09:21:39', '2025-12-29 09:21:39'),
(68, '418302e0ba847ff8', 0, 0, 0.15, NULL, '2025-12-29 17:24:57', '2025-12-29 17:24:57'),
(69, '09a6cbd14f3ecb1e', 0, 0, 0.15, NULL, '2025-12-29 17:25:45', '2025-12-29 17:25:45'),
(70, '9ed0f943de7e447e', 0, 0, 0.15, NULL, '2025-12-29 17:26:08', '2025-12-29 17:26:08'),
(71, '6320948fbd99a8d7', 0, 0, 0.15, NULL, '2025-12-29 17:26:42', '2025-12-29 17:26:42'),
(72, 'd6aaa93ca431b73f', 0, 0, 0.15, NULL, '2025-12-29 17:27:08', '2025-12-29 17:27:08'),
(73, 'fc6804bcdcbd79c9', 0, 0, 0.15, NULL, '2025-12-29 17:28:08', '2025-12-29 17:28:08'),
(74, '3a5cae33e4984967', 1, 1, 0.15, NULL, '2025-12-29 17:29:01', '2025-12-29 17:29:01'),
(75, '551e57876c2c4643', 1, 0, 0.15, NULL, '2025-12-29 17:31:53', '2025-12-29 17:31:53'),
(76, '0b13df0c5f457c20', 0, 0, 0.15, NULL, '2025-12-29 17:32:17', '2025-12-29 17:32:17'),
(77, '12c542b6fc3973a5', 0, 0, 0.15, NULL, '2025-12-29 17:32:38', '2025-12-29 17:32:38'),
(78, '2970f6647c7af218', 0, 0, 0.15, NULL, '2025-12-29 17:33:36', '2025-12-29 17:33:36'),
(79, '020c0d3b421f93b6', 0, 0, 0.15, NULL, '2025-12-29 17:34:12', '2025-12-29 17:34:12'),
(80, 'f659d238e12b094b', 0, 0, 0.15, NULL, '2025-12-29 17:34:46', '2025-12-29 17:34:46'),
(81, 'c44d9be5a8f1208e', 0, 0, 0.15, NULL, '2025-12-29 17:36:40', '2025-12-29 17:36:40'),
(82, '67a133faf5467b68', 1, 1, 0.15, NULL, '2025-12-29 17:36:54', '2025-12-29 17:36:54'),
(83, '2adc7eb71eba6a3d', 0, 0, 0.15, NULL, '2025-12-30 04:53:51', '2025-12-30 04:53:51'),
(84, '152e8cb8adc8474e', 0, 0, 0.15, NULL, '2025-12-30 04:55:43', '2025-12-30 04:55:43'),
(85, '89ecb6f9f565fe23', 0, 0, 0.15, NULL, '2025-12-30 04:57:11', '2025-12-30 04:57:11'),
(86, 'a232117dd4aeb889', 0, 0, 0.15, NULL, '2025-12-30 04:58:00', '2025-12-30 04:58:00'),
(87, '4d2119374d97d182', 0, 0, 0.15, NULL, '2025-12-30 04:58:19', '2025-12-30 04:58:19'),
(88, '3b77ffec80d225c9', 0, 0, 0.15, NULL, '2025-12-30 05:09:58', '2025-12-30 05:09:58'),
(89, 'cedd484d0763ff1e', 0, 0, 0.15, NULL, '2025-12-30 05:10:23', '2025-12-30 05:10:23'),
(90, '0520f968bf5938cf', 0, 0, 0.15, NULL, '2025-12-30 05:10:35', '2025-12-30 05:10:35'),
(91, '84e16cabccfd18b3', 1, 1, 0.15, NULL, '2025-12-30 05:21:42', '2025-12-30 05:21:42'),
(92, '99d964f44ce35c8f', 0, 0, 0.15, NULL, '2025-12-30 16:48:40', '2025-12-30 16:48:40'),
(93, '282fa03d684d81b3', 0, 0, 0.15, NULL, '2025-12-30 16:49:08', '2025-12-30 16:49:08'),
(94, 'c731b3ef85d15cd2', 0, 0, 0.15, NULL, '2025-12-30 16:49:41', '2025-12-30 16:49:41'),
(95, '5e23a978f88a85ad', 0, 0, 0.15, NULL, '2025-12-30 16:50:08', '2025-12-30 16:50:08'),
(96, '46b111a5b3f70ff4', 0, 0, 0.15, NULL, '2025-12-30 16:50:25', '2025-12-30 16:50:25'),
(97, '5d33c6a6b6379f24', 0, 0, 0.15, NULL, '2025-12-30 16:50:41', '2025-12-30 16:50:41'),
(98, '490eb83bad5e2570', 0, 0, 0.15, NULL, '2025-12-30 16:51:13', '2025-12-30 16:51:13'),
(99, '5afcd641edac650a', 1, 1, 0.15, NULL, '2025-12-30 16:52:13', '2025-12-30 16:52:13'),
(100, '494607a9f6ea90f4', 0, 0, 0.15, NULL, '2026-01-06 04:55:04', '2026-01-06 04:55:04'),
(101, 'f224b1dbac73f1b8', 0, 0, 0.15, NULL, '2026-01-06 04:55:30', '2026-01-06 04:55:30'),
(102, '653b915b6716250c', 0, 0, 0.15, NULL, '2026-01-06 04:55:53', '2026-01-06 04:55:53'),
(103, 'a9d6f95da1dd6fbf', 0, 0, 0.15, NULL, '2026-01-06 04:56:09', '2026-01-06 04:56:09'),
(104, '993a5154eb137f2b', 0, 0, 0.15, NULL, '2026-01-06 04:56:25', '2026-01-06 04:56:25'),
(105, '6d1ef9eab915e184', 0, 0, 0.15, NULL, '2026-01-06 04:56:50', '2026-01-06 04:56:50'),
(106, '5ea3ba4d84f91afe', 0, 0, 0.15, NULL, '2026-01-06 04:57:07', '2026-01-06 04:57:07'),
(107, 'c293caee2587552b', 1, 0, 0.15, NULL, '2026-01-06 04:57:31', '2026-01-06 04:57:29'),
(108, '2f176659265a85bf', 0, 0, 0.15, NULL, '2026-01-06 05:02:12', '2026-01-06 05:02:12'),
(109, 'ac0e869badd07f84', 1, 1, 0.15, NULL, '2026-01-06 05:02:37', '2026-01-06 05:02:37'),
(110, '7b3cbd95990d6a2c', 0, 0, 0.15, NULL, '2026-01-06 05:03:59', '2026-01-06 05:03:59'),
(111, 'f03e3dbcc9e4514e', 0, 0, 0.15, NULL, '2026-01-06 05:05:02', '2026-01-06 05:05:02'),
(112, '3f6820f413f8c45c', 1, 1, 0.15, NULL, '2026-01-06 05:06:01', '2026-01-06 05:05:51'),
(113, '92b52091ccc2ceac', 0, 0, 0.15, NULL, '2026-01-06 05:19:59', '2026-01-06 05:19:59'),
(114, '3fb296ce3ddfd61c', 0, 0, 0.15, NULL, '2026-01-06 05:20:32', '2026-01-06 05:20:32'),
(115, '663c52392cdbc98d', 0, 0, 0.15, NULL, '2026-01-06 05:20:57', '2026-01-06 05:20:57'),
(116, 'ee91a867a6437c22', 0, 0, 0.15, NULL, '2026-01-06 05:21:11', '2026-01-06 05:21:11'),
(117, 'b0f0993347ea53cf', 0, 0, 0.15, NULL, '2026-01-06 05:21:20', '2026-01-06 05:21:20'),
(118, '65679175fc4953eb', 0, 0, 0.15, NULL, '2026-01-06 05:21:27', '2026-01-06 05:21:27'),
(119, '9460760a3d76ed41', 0, 0, 0.15, NULL, '2026-01-06 05:21:51', '2026-01-06 05:21:51'),
(120, 'b46ef438691a98a0', 1, 1, 0.15, NULL, '2026-01-06 05:22:34', '2026-01-06 05:22:34'),
(121, '0901028d2b739c95', 0, 0, 0.15, NULL, '2026-02-23 16:14:39', '2026-02-23 16:14:39'),
(122, '943cd15af69d39f8', 0, 0, 0.15, NULL, '2026-02-23 16:15:20', '2026-02-23 16:15:20'),
(123, 'c4f62c4f250d8b66', 0, 0, 0.15, NULL, '2026-02-23 16:15:33', '2026-02-23 16:15:33'),
(124, '3b981272b5550c78', 0, 0, 0.15, NULL, '2026-02-23 16:15:41', '2026-02-23 16:15:41'),
(125, 'ff2959b02d5eacd0', 1, 1, 0.15, NULL, '2026-02-23 16:15:50', '2026-02-23 16:15:50'),
(126, 'test_user_123', 0, 0, 0.15, NULL, '2026-02-23 17:55:35', '2026-02-23 17:55:35'),
(127, '0ce9bc4e7973fa41', 0, 0, 0.15, NULL, '2026-02-23 18:08:25', '2026-02-23 18:08:25'),
(128, '68791b095d75d8f0', 0, 0, 0.15, NULL, '2026-02-23 18:08:28', '2026-02-23 18:08:28'),
(129, '73fa1a67170c7587', 0, 0, 0.15, NULL, '2026-02-23 18:13:06', '2026-02-23 18:13:06'),
(130, 'test123', 0, 0, 0.15, NULL, '2026-02-23 18:18:49', '2026-02-23 18:18:49'),
(131, '6f90f313949cb8d0', 0, 0, 0.15, NULL, '2026-02-23 18:19:24', '2026-02-23 18:19:24'),
(132, '5dc8791dcff5c286', 1, 1, 0.15, NULL, '2026-02-23 18:20:14', '2026-02-23 18:20:14');

-- --------------------------------------------------------

--
-- Table structure for table `llm_usage`
--

CREATE TABLE `llm_usage` (
  `id` bigint(20) NOT NULL,
  `conversation_id` bigint(20) NOT NULL,
  `turn_number` int(11) NOT NULL,
  `provider` varchar(50) NOT NULL,
  `model` varchar(100) NOT NULL,
  `prompt_tokens` int(11) DEFAULT NULL,
  `completion_tokens` int(11) DEFAULT NULL,
  `cost` decimal(10,6) DEFAULT NULL,
  `response_time_ms` int(11) DEFAULT NULL,
  `success` tinyint(1) DEFAULT 1,
  `error_message` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `llm_usage`
--

INSERT INTO `llm_usage` (`id`, `conversation_id`, `turn_number`, `provider`, `model`, `prompt_tokens`, `completion_tokens`, `cost`, `response_time_ms`, `success`, `error_message`, `created_at`) VALUES
(1, 9, 2, 'openrouter', 'google/gemini-flash-1.5', NULL, NULL, NULL, NULL, 0, 'OpenRouter API Error: 404', '2025-12-28 19:39:34'),
(2, 12, 2, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', 127, 14, 0.000070, 4611, 1, NULL, '2025-12-28 19:48:05'),
(3, 14, 4, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', 142, 21, 0.000082, 6652, 1, NULL, '2025-12-28 19:56:17'),
(4, 16, 1, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', NULL, NULL, NULL, NULL, 0, 'OpenRouter API Error: 429', '2025-12-28 20:00:41'),
(5, 16, 2, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', NULL, NULL, NULL, NULL, 0, 'OpenRouter API Error: 429', '2025-12-28 20:00:42'),
(6, 17, 3, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', NULL, NULL, NULL, NULL, 0, 'OpenRouter API Error: 429', '2025-12-28 20:13:49'),
(7, 21, 1, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', 107, 16, 0.000061, 2778, 1, NULL, '2025-12-28 20:28:41'),
(8, 21, 3, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', 147, 18, 0.000083, 3040, 1, NULL, '2025-12-28 20:30:38'),
(9, 22, 1, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', 109, 10, 0.000059, 2471, 1, NULL, '2025-12-29 09:05:33'),
(10, 25, 1, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', 110, 21, 0.000065, 5225, 1, NULL, '2025-12-29 17:25:03'),
(11, 25, 5, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', 144, 20, 0.000082, 6093, 1, NULL, '2025-12-29 17:27:14'),
(12, 25, 6, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', 167, 23, 0.000095, 2541, 1, NULL, '2025-12-29 17:28:11'),
(13, 27, 3, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', 137, 12, 0.000075, 4386, 1, NULL, '2025-12-29 17:33:41'),
(14, 28, 1, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', 109, 22, 0.000065, 3576, 1, NULL, '2025-12-30 04:53:55'),
(15, 28, 3, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', 170, 35, 0.000103, 4799, 1, NULL, '2025-12-30 04:57:16'),
(16, 34, 3, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', 152, 13, 0.000083, 3089, 1, NULL, '2025-12-30 16:49:44'),
(17, 34, 7, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', 139, 11, 0.000075, 6353, 1, NULL, '2025-12-30 16:51:19'),
(18, 35, 3, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', 139, 17, 0.000078, 4184, 1, NULL, '2026-01-06 04:55:57'),
(19, 37, 2, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', 123, 11, 0.000067, 3539, 1, NULL, '2026-01-06 05:05:06'),
(20, 37, 3, 'openrouter', 'meta-llama/llama-3.2-3b-instruct:free', NULL, NULL, NULL, NULL, 0, 'HTTPSConnectionPool(host=\'openrouter.ai\', port=443): Read timed out. (read timeout=10)', '2026-01-06 05:06:01');

-- --------------------------------------------------------

--
-- Table structure for table `negotiation_patterns`
--

CREATE TABLE `negotiation_patterns` (
  `id` int(11) NOT NULL,
  `pattern_type` varchar(50) NOT NULL,
  `pattern_text` varchar(500) NOT NULL,
  `response_template` text NOT NULL,
  `success_rate` float DEFAULT 0.5,
  `use_count` int(11) DEFAULT 0,
  `last_used` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `negotiation_patterns`
--

INSERT INTO `negotiation_patterns` (`id`, `pattern_type`, `pattern_text`, `response_template`, `success_rate`, `use_count`, `last_used`, `is_active`, `created_at`) VALUES
(1, 'price_offer', '₹?\\s*(\\d+)\\s*(doge|do|de|denge|dunga)', 'Bhai, ₹{} tak aa sakta hoon.', 0.5, 0, NULL, 1, '2025-12-28 19:01:36'),
(2, 'final_offer', 'final|last|bas|khatam|antim', 'Bhai final bol rahe ho to ₹{} last price.', 0.5, 0, NULL, 1, '2025-12-28 19:01:36'),
(3, 'comparison', 'market|online|amazon|flipkart|cheaper', 'Quality ka farak hai bhai. ₹{} best hai.', 0.5, 0, NULL, 1, '2025-12-28 19:01:36'),
(4, 'polite', 'please|kripya|shukriya|meherbani|aap', 'Aapke liye ₹{} kar deta hoon.', 0.5, 0, NULL, 1, '2025-12-28 19:01:36'),
(5, 'angry', 'gussa|naraz|mahanga|loot|chor', 'Arre bhai! ₹{} se kam impossible!', 0.5, 0, NULL, 1, '2025-12-28 19:01:36'),
(6, 'hesitant', 'sochta|dekhta|maybe|baad me', 'Jara sochiye, ₹{} accha deal hai.', 0.5, 0, NULL, 1, '2025-12-28 19:01:36'),
(7, 'walk_away', 'bye|quit|stop|nahi|chhod', 'Koi baat nahi bhai. Kabhi aur aana.', 0.5, 0, NULL, 1, '2025-12-28 19:01:36'),
(8, 'price_query', 'kitna|kya price|how much|daam', 'Current price ₹{} hai bhai.', 0.5, 0, NULL, 1, '2025-12-28 19:01:36'),
(9, 'feature_query', 'feature|specification|detail|kya hai', 'Yeh {} hai. {} warranty hai.', 0.5, 0, NULL, 1, '2025-12-28 19:01:36');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `cost_price` decimal(10,2) NOT NULL,
  `selling_price` decimal(10,2) NOT NULL,
  `min_price` decimal(10,2) NOT NULL,
  `features` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`features`)),
  `warranty` varchar(50) DEFAULT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `stock_quantity` int(11) DEFAULT 1,
  `popularity_score` float DEFAULT 0.5,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `image_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `category`, `cost_price`, `selling_price`, `min_price`, `features`, `warranty`, `brand`, `stock_quantity`, `popularity_score`, `created_at`, `image_url`) VALUES
(1, 'Bluetooth Headphones', 'Electronics', 600.00, 1000.00, 800.00, '[\"Noise Cancellation\", \"30hr Battery\", \"Wireless\", \"Voice Assistant\"]', '1 Year', 'SoundPro', 1, 0.5, '2025-12-28 19:01:36', 'products/headphone.jpg'),
(2, 'Smartphone', 'Electronics', 8000.00, 12000.00, 10000.00, '[\"6GB RAM\", \"128GB Storage\", \"48MP Camera\", \"5000mAh\"]', '2 Years', 'TechMax', 1, 0.5, '2025-12-28 19:01:36', 'products/phone.jpg'),
(3, 'Watch', 'Fashion', 2000.00, 3500.00, 2800.00, '[\"Smart Watch\", \"Heart Rate\", \"Water Resistant\", \"GPS\"]', '1 Year', 'TimeMaster', 1, 0.5, '2025-12-28 19:01:36', 'products/watch.jpg'),
(4, 'T-Shirt', 'Clothing', 300.00, 800.00, 500.00, '[\"Pure Cotton\", \"Premium Quality\", \"Multiple Colors\"]', 'None', 'StyleWear', 1, 0.5, '2025-12-28 19:01:36', 'products/t-shirt.jpg');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `conversations`
--
ALTER TABLE `conversations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `idx_session` (`session_id`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `conversation_messages`
--
ALTER TABLE `conversation_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_conversation_turn` (`conversation_id`,`turn_number`);

--
-- Indexes for table `customer_profiles`
--
ALTER TABLE `customer_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `fingerprint` (`fingerprint`);

--
-- Indexes for table `llm_usage`
--
ALTER TABLE `llm_usage`
  ADD PRIMARY KEY (`id`),
  ADD KEY `conversation_id` (`conversation_id`);

--
-- Indexes for table `negotiation_patterns`
--
ALTER TABLE `negotiation_patterns`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pattern_type` (`pattern_type`),
  ADD KEY `idx_success_rate` (`success_rate`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_popularity` (`popularity_score`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `conversations`
--
ALTER TABLE `conversations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `conversation_messages`
--
ALTER TABLE `conversation_messages`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=289;

--
-- AUTO_INCREMENT for table `customer_profiles`
--
ALTER TABLE `customer_profiles`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=133;

--
-- AUTO_INCREMENT for table `llm_usage`
--
ALTER TABLE `llm_usage`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `negotiation_patterns`
--
ALTER TABLE `negotiation_patterns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `conversations`
--
ALTER TABLE `conversations`
  ADD CONSTRAINT `conversations_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `conversation_messages`
--
ALTER TABLE `conversation_messages`
  ADD CONSTRAINT `conversation_messages_ibfk_1` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`);

--
-- Constraints for table `llm_usage`
--
ALTER TABLE `llm_usage`
  ADD CONSTRAINT `llm_usage_ibfk_1` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;