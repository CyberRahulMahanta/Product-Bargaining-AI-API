-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 05, 2026 at 08:13 AM
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
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
