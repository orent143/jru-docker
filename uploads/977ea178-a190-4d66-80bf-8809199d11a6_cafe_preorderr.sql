-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 18, 2025 at 03:10 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cafe_preorderr`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` enum('drinks','food') NOT NULL,
  `icon` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `type`, `icon`, `created_at`) VALUES
(1, 'Ice Coffees', 'drinks', 'fas fa-coffee', '2025-03-13 13:18:04'),
(2, 'Pasta & Dishes', 'food', 'fas fa-utensils', '2025-03-13 13:18:04'),
(3, 'Hot Coffees', 'drinks', 'fas fa-mug-hot', '2025-03-13 13:18:04'),
(4, 'Blended Frappes', 'drinks', 'fas fa-wine-glass-alt', '2025-03-13 13:18:04'),
(6, 'Milkteas', 'drinks', 'fas fa-glass-whiskey', '2025-03-13 13:18:04'),
(7, 'Chocolate Drinks', 'drinks', 'fas fa-glass-martini', '2025-03-13 13:18:04'),
(9, 'Juice Drinks', 'drinks', 'fas fa-blender', '2025-03-13 13:18:04'),
(12, 'Pastries', 'food', 'fas fa-bread-slice', '2025-03-16 06:54:24'),
(13, 'Crispy', 'food', 'fas fa-cheese', '2025-03-16 06:56:17'),
(14, 'Letchon', 'food', 'fas fa-egg', '2025-03-16 07:02:49'),
(15, 'Nachos', 'food', 'fas fa-bacon', '2025-03-16 14:47:52'),
(16, 'Fish', 'food', 'fas fa-utensils', '2025-03-17 05:17:49');

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `image` varchar(255) NOT NULL,
  `category` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`id`, `name`, `price`, `image`, `category`) VALUES
(8, 'Ice Peppermint Latte', 115.00, '/uploads/avatars/20250312_155401_peppermint-latte.png', 'Ice Coffees'),
(9, 'Ice Matcha Cafe Latte', 115.00, '/uploads/avatars/20250312_155401_matcha-cafe-latte.png', 'Ice Coffees'),
(10, 'Ice Cafe Latte', 80.00, '/uploads/avatars/20250312_155401_ice-cafe-latte.png', 'Ice Coffees'),
(11, 'Ice Caramel Macchiato', 115.00, '/uploads/avatars/20250312_155401_caramel-macchiato.png', 'Ice Coffees'),
(12, 'Ice Angel Affogato', 115.00, '/uploads/avatars/20250312_155401_angel-affogato.png', 'Ice Coffees'),
(13, 'Ice Spanish Latte', 115.00, '/uploads/avatars/20250312_155401_spanish-latte.png', 'Ice Coffees'),
(14, 'Ice Cappuccino', 115.00, '/uploads/avatars/20250312_155401_ice-cappuccino.png', 'Ice Coffees'),
(15, 'Ice Cafe Mocha', 115.00, '/uploads/avatars/20250312_155401_cafe-mocha.png', 'Ice Coffees'),
(16, 'Ice Salted Caramel Macchiato', 115.00, '/uploads/avatars/20250312_155401_salted-caramel-macchiato.png', 'Ice Coffees'),
(17, 'Ice White Choco Mocha', 115.00, '/uploads/avatars/20250312_155401_white-choco-mocha.png', 'Ice Coffees'),
(18, 'Ice Vanilla Latte', 115.00, '/uploads/avatars/20250312_155401_vanilla-latte.png', 'Ice Coffees'),
(19, 'Ice Hazelnut Latte', 115.00, '/uploads/avatars/20250312_155401_hazelnut-latte.png', 'Ice Coffees'),
(20, 'Ice Cafe Frizzy', 80.00, '/uploads/avatars/20250312_155401_cafe-frizzy.png', 'Ice Coffees'),
(21, 'Ice Americano Lemon', 90.00, '/uploads/avatars/20250312_155401_americano-lemon.png', 'Ice Coffees'),
(22, 'Ice Cafe Americano', 75.00, '/uploads/avatars/20250312_155401_ice-cafe-americano.png', 'Ice Coffees'),
(23, 'Hot Cafe Americano', 70.00, '/uploads/avatars/20250312_155401_cafe-americano.png', 'Hot Coffees'),
(24, 'Hot Peppermint Latte', 90.00, '/uploads/avatars/20250312_155401_hot-peppermint-latte.png', 'Hot Coffees'),
(25, 'Hot Matcha Cafe Latte', 90.00, '/uploads/avatars/20250312_155401_hot-matcha-cafe-latte.png', 'Hot Coffees'),
(26, 'Hot Cafe Latte', 85.00, '/uploads/avatars/20250312_155401_cafe-latte.png', 'Hot Coffees'),
(27, 'Hot Cafe Latte Macchiato', 85.00, '/uploads/avatars/20250312_155401_hot-cafelattemacc.png', 'Hot Coffees'),
(28, 'Hot Caramel Macchiato', 90.00, '/uploads/avatars/20250312_155401_hot-caramel-macchiato.png', 'Hot Coffees'),
(29, 'Hot Spanish Latte', 90.00, '/uploads/avatars/20250312_155401_hot-spanish-latte.png', 'Hot Coffees'),
(30, 'Hot Cappuccino', 75.00, '/uploads/avatars/20250312_155401_hot-cappuccino.png', 'Hot Coffees'),
(31, 'Hot Cafe Mocha', 90.00, '/uploads/avatars/20250312_155401_hot-cafe-mocha.png', 'Hot Coffees'),
(32, 'Hot Salted Caramel Macchiato', 90.00, '/uploads/avatars/20250312_155401_hot-salted-caramel-macchiato.png', 'Hot Coffees'),
(33, 'Hot Vanilla Latte', 90.00, '/uploads/avatars/20250312_155401_hot-vanilla-latte.png', 'Hot Coffees'),
(34, 'Hot Hazelnut Latte', 90.00, '/uploads/avatars/20250312_155401_hot-hazelnut-latte.png', 'Hot Coffees'),
(35, 'Hot Tea Pot', 60.00, '/uploads/avatars/20250312_155401_hotea-pot.png', 'Hot Coffees'),
(36, 'Apple Juice', 55.00, '/uploads/avatars/20250312_155401_apple.png', 'Juice Drinks'),
(42, 'Yakult Orange Lemonade', 75.00, '/uploads/avatars/20250312_155401_yakult-orange-lemonade.png', 'Juice Drinks'),
(54, 'Mogu-Mogu Yakult', 55.00, '/uploads/avatars/20250312_155401_mogu-mogu-yakult.png', 'Juice Drinks'),
(57, 'Mango Matcha Latte', 75.00, '/uploads/avatars/20250312_155401_mango-matcha-latte.png', 'Juice Drinks'),
(75, 'Hot Chocolate', 75.00, '/uploads/avatars/20250312_155401_hot-chocolate.png', 'Chocolate Drinks'),
(93, 'Hoty', 234.00, '/uploads/avatars/20250312_175256_d.png', 'Hot Coffees'),
(120, 'Yakult Strawberry Lemonade', 75.00, '/uploads/avatars/20250312_221551_yakult-strawberry-lemonade.png', 'Juice Drinks'),
(122, 'Strawberry Mango Blue Lemonade', 75.00, '/uploads/avatars/20250312_221551_strawberry-mango-blue-lemonade.png', 'Juice Drinks'),
(124, 'Strawberry Apple Lemonade', 75.00, '/uploads/avatars/20250312_221551_strawberry-apple-lemonade.png', 'Juice Drinks'),
(127, 'Fresh Lemon Juice', 60.00, '/uploads/avatars/20250312_221551_fresh-lemon.png', 'Juice Drinks'),
(130, 'Mogu-Mogu Yakult with Honey', 75.00, '/uploads/avatars/20250312_221551_mogu-mogu-yakult-with-honey.png', 'Juice Drinks'),
(134, 'Wintermelon Milktea', 60.00, '/uploads/avatars/20250312_221552_wintermelon-milktea.png', 'Milkteas'),
(135, 'Okinawa Milktea', 60.00, '/uploads/avatars/20250312_221552_okinawa-milktea.png', 'Milkteas'),
(136, 'Mango Milktea', 60.00, '/uploads/avatars/20250312_221552_mango-milktea.png', 'Milkteas'),
(137, 'Oreo Milktea', 60.00, '/uploads/avatars/20250312_221552_oreo-milktea.png', 'Milkteas'),
(138, 'Caramel Milktea', 60.00, '/uploads/avatars/20250312_221552_caramel-milktea.png', 'Milkteas'),
(139, 'Chocolate Milktea', 60.00, '/uploads/avatars/20250312_221552_chocolate-milktea.png', 'Milkteas'),
(140, 'Mocha Milktea', 60.00, '/uploads/avatars/20250312_221552_mocha-milktea.png', 'Milkteas'),
(141, 'Matcha Milktea', 60.00, '/uploads/avatars/20250312_221552_matcha-milktea.png', 'Milkteas'),
(142, 'Taro Milktea', 60.00, '/uploads/avatars/20250312_221552_taro-milktea.png', 'Milkteas'),
(143, 'Red Velvet Milktea', 60.00, '/uploads/avatars/20250312_221552_red-velvet-milktea.png', 'Milkteas'),
(144, 'Ube Milktea', 60.00, '/uploads/avatars/20250312_221552_ube-milktea.png', 'Milkteas'),
(145, 'Pandan Milktea', 60.00, '/uploads/avatars/20250312_221552_pandan-milktea.png', 'Milkteas'),
(146, 'Strawberry Milktea', 60.00, '/uploads/avatars/20250312_221552_strawberry-milktea.png', 'Milkteas'),
(147, 'Melon Milktea', 60.00, '/uploads/avatars/20250312_221552_melon-milktea.png', 'Milkteas'),
(148, 'Ube Taro Milktea', 60.00, '/uploads/avatars/20250312_221552_ube-taro-milktea.png', 'Milkteas'),
(150, 'Cold Chocolate', 85.00, '/uploads/avatars/20250312_221552_cold-chocolate.png', 'Chocolate Drinks'),
(152, 'Ube Frappe', 90.00, '/uploads/avatars/20250312_221552_ube.png', 'Blended Frappes'),
(153, 'Mocha Frappe', 135.00, '/uploads/avatars/20250312_221552_mocha.png', 'Blended Frappes'),
(154, 'Matcha Frappe', 90.00, '/uploads/avatars/20250312_221552_matcha.png', 'Blended Frappes'),
(155, 'Mango Frappe', 90.00, '/uploads/avatars/20250312_221552_mango-frappe.png', 'Blended Frappes'),
(156, 'Chocolate Frappe', 90.00, '/uploads/avatars/20250312_221552_chocolate.png', 'Blended Frappes'),
(157, 'Strawberry Frappe', 90.00, '/uploads/avatars/20250312_221552_strawberry.png', 'Blended Frappes'),
(158, 'Pandan Frappe', 90.00, '/uploads/avatars/20250312_221552_pandan.png', 'Blended Frappes'),
(159, 'Avocado Frappe', 90.00, '/uploads/avatars/20250312_221552_avocado.png', 'Blended Frappes'),
(160, 'Melon Frappe', 90.00, '/uploads/avatars/20250312_221552_melon.png', 'Blended Frappes'),
(161, 'Cookies & Coffee Frappe', 135.00, '/uploads/avatars/20250312_221552_cookies-and-coffee.png', 'Blended Frappes'),
(162, 'Carbonara', 70.00, '/uploads/avatars/20250312_221552_carbonara.png', 'Pasta & Dishes'),
(163, 'Baked Mac', 70.00, '/uploads/avatars/20250312_221552_bakemac.png', 'Pasta & Dishes'),
(164, 'Tuna Pasta', 70.00, '/uploads/avatars/20250312_221552_tunapasta.png', 'Pasta & Dishes'),
(168, 'Cake', 256.00, '/uploads/avatars/20250316_145437_images_1.jpg', 'Pastries'),
(169, 'Caramel Cake', 600.00, '/uploads/avatars/20250316_145603_d.avif', 'Pastries'),
(170, 'Letchon Baboy 50kg', 10750.00, '/uploads/avatars/20250316_150700_lechon-boodle-fight-1wpq72h954frcijq.jpg', 'Letchon'),
(171, 'sadsa', 23.00, '/uploads/avatars/20250316_224904_cafe-logo1_1.png', 'Nachos'),
(172, 'Fishda', 250.00, '/uploads/avatars/20250317_131844_images.jpg', 'Fish'),
(173, 'Fried Chicken', 45.00, '/uploads/avatars/20250317_150202_crispy-fried-chicken-plate-with-salad-carrot_1150-20212.avif', 'Crispy'),
(174, 'Ice Cafe Mocha', 115.00, '/uploads/avatars/20250317_203849_cafe-mocha.png', 'Ice Coffee'),
(175, 'Ice Salted Caramel Macchiato', 115.00, '/uploads/avatars/20250317_203853_salted-caramel-macchiato.png', 'Ice Coffee'),
(176, 'Ice White Choco Mocha', 115.00, '/uploads/avatars/20250317_203853_white-choco-mocha.png', 'Ice Coffee'),
(177, 'Ice Vanilla Latte', 115.00, '/uploads/avatars/20250317_203853_vanilla-latte.png', 'Ice Coffee'),
(178, 'Ice Hazelnut Latte', 115.00, '/uploads/avatars/20250317_203853_hazelnut-latte.png', 'Ice Coffee'),
(179, 'Ice Cafe Frizzy', 80.00, '/uploads/avatars/20250317_203853_cafe-frizzy.png', 'Ice Coffee'),
(180, 'Ice Americano Lemon', 90.00, '/uploads/avatars/20250317_203853_americano-lemon.png', 'Ice Coffee'),
(181, 'Ice Cafe Americano', 75.00, '/uploads/avatars/20250317_203854_ice-cafe-americano.png', 'Ice Coffee'),
(182, 'Hot Cafe Americano', 70.00, '/uploads/avatars/20250317_203854_cafe-americano.png', 'Hot Coffee'),
(183, 'Hot Peppermint Latte', 90.00, '/uploads/avatars/20250317_203854_hot-peppermint-latte.png', 'Hot Coffee'),
(184, 'Hot Matcha Cafe Latte', 90.00, '/uploads/avatars/20250317_203854_hot-matcha-cafe-latte.png', 'Hot Coffee'),
(185, 'Hot Cafe Latte', 85.00, '/uploads/avatars/20250317_203854_cafe-latte.png', 'Hot Coffee'),
(186, 'Hot Cafe Latte Macchiato', 85.00, '/uploads/avatars/20250317_203854_hot-cafelattemacc.png', 'Hot Coffee'),
(187, 'Hot Caramel Macchiato', 90.00, '/uploads/avatars/20250317_203854_hot-caramel-macchiato.png', 'Hot Coffee'),
(188, 'Hot Spanish Latte', 90.00, '/uploads/avatars/20250317_203854_hot-spanish-latte.png', 'Hot Coffee'),
(189, 'Hot Cappuccino', 75.00, '/uploads/avatars/20250317_203854_hot-cappuccino.png', 'Hot Coffee'),
(190, 'Hot Cafe Mocha', 90.00, '/uploads/avatars/20250317_203854_hot-cafe-mocha.png', 'Hot Coffee'),
(191, 'Hot Salted Caramel Macchiato', 90.00, '/uploads/avatars/20250317_203854_hot-salted-caramel-macchiato.png', 'Hot Coffee'),
(192, 'Hot Vanilla Latte', 90.00, '/uploads/avatars/20250317_203854_hot-vanilla-latte.png', 'Hot Coffee'),
(193, 'Hot Hazelnut Latte', 90.00, '/uploads/avatars/20250317_203854_hot-hazelnut-latte.png', 'Hot Coffee'),
(194, 'Hot Tea Pot', 60.00, '/uploads/avatars/20250317_203854_hotea-pot.png', 'Hot Coffee'),
(196, 'Carrot Juice', 60.00, '/uploads/avatars/20250317_203854_carrot.png', 'Juice Drinks'),
(197, 'Mango Juice', 55.00, '/uploads/avatars/20250317_203854_mango.png', 'Juice Drinks'),
(198, 'Yakult Lemonade', 55.00, '/uploads/avatars/20250317_203854_yakult-lemonade.png', 'Juice Drinks'),
(200, 'Yakult Apple Lemonade', 75.00, '/uploads/avatars/20250317_203854_yakult-apple-lemonade.png', 'Juice Drinks'),
(202, 'Yakult Sprite Lemonade', 75.00, '/uploads/avatars/20250317_203854_yakult-sprite-lemonade.png', 'Juice Drinks'),
(203, 'Yakult Mango Lemonade', 75.00, '/uploads/avatars/20250317_203854_yakult-mango-lemonade.png', 'Juice Drinks'),
(204, 'Yakult Caramel Lemonade', 75.00, '/uploads/avatars/20250317_203855_yakult-caramel-lemonade.png', 'Juice Drinks'),
(206, 'Strawberry Lemonade', 75.00, '/uploads/avatars/20250317_203855_strawberry-lemonade.png', 'Juice Drinks'),
(208, 'Strawberry Orange Blue Lemonade', 75.00, '/uploads/avatars/20250317_203855_strawberry-orange-blue-lemonade.png', 'Juice Drinks'),
(210, 'Orange Juice', 75.00, '/uploads/avatars/20250317_203855_orange.png', 'Juice Drinks'),
(211, 'Apple Carrot Juice', 75.00, '/uploads/avatars/20250318_002746_apple-carrot.png', 'Juice Drinks'),
(214, 'Mogu-Mogu Yakult w/ Lemon', 55.00, '/uploads/avatars/20250317_203855_mogu-mogu-yakult-with-lemon.png', 'Juice Drinks'),
(217, 'Mango Strawberry Latte', 75.00, '/uploads/avatars/20250317_203855_mango-strawberry-latte.png', 'Juice Drinks'),
(218, 'Avocado Milktea', 60.00, '/uploads/avatars/20250318_002759_avocado-milktea.png', 'Milkteas'),
(219, 'Wintermelon Milktea', 60.00, '/uploads/avatars/20250317_203855_wintermelon-milktea.png', 'Milkteas'),
(220, 'Okinawa Milktea', 60.00, '/uploads/avatars/20250317_203855_okinawa-milktea.png', 'Milkteas'),
(221, 'Mango Milktea', 60.00, '/uploads/avatars/20250317_203856_mango-milktea.png', 'Milkteas'),
(222, 'Oreo Milktea', 60.00, '/uploads/avatars/20250317_203856_oreo-milktea.png', 'Milkteas'),
(223, 'Caramel Milktea', 60.00, '/uploads/avatars/20250317_203856_caramel-milktea.png', 'Milkteas'),
(224, 'Chocolate Milktea', 60.00, '/uploads/avatars/20250317_203856_chocolate-milktea.png', 'Milkteas'),
(225, 'Mocha Milktea', 60.00, '/uploads/avatars/20250317_203856_mocha-milktea.png', 'Milkteas'),
(226, 'Matcha Milktea', 60.00, '/uploads/avatars/20250317_203856_matcha-milktea.png', 'Milkteas'),
(227, 'Taro Milktea', 60.00, '/uploads/avatars/20250317_203856_taro-milktea.png', 'Milkteas'),
(228, 'Red Velvet Milktea', 60.00, '/uploads/avatars/20250317_203856_red-velvet-milktea.png', 'Milkteas'),
(229, 'Ube Milktea', 60.00, '/uploads/avatars/20250317_203856_ube-milktea.png', 'Milkteas'),
(230, 'Pandan Milktea', 60.00, '/uploads/avatars/20250317_203856_pandan-milktea.png', 'Milkteas'),
(231, 'Strawberry Milktea', 60.00, '/uploads/avatars/20250317_203856_strawberry-milktea.png', 'Milkteas'),
(232, 'Melon Milktea', 60.00, '/uploads/avatars/20250317_203856_melon-milktea.png', 'Milkteas'),
(233, 'Ube Taro Milktea', 60.00, '/uploads/avatars/20250317_203856_ube-taro-milktea.png', 'Milkteas'),
(234, 'Hot Chocolate', 75.00, '/uploads/avatars/20250317_203856_hot-chocolate.png', 'Chocolate Drinks'),
(235, 'Cold Chocolate', 85.00, '/uploads/avatars/20250317_203856_cold-chocolate.png', 'Chocolate Drinks'),
(236, 'Cookies & Cream Frappe', 90.00, '/uploads/avatars/20250317_203856_cookies-and-cream.png', 'Blended Frappes'),
(237, 'Ube Frappe', 90.00, '/uploads/avatars/20250317_203856_ube.png', 'Blended Frappes'),
(238, 'Mocha Frappe', 135.00, '/uploads/avatars/20250317_203856_mocha.png', 'Blended Frappes'),
(239, 'Matcha Frappe', 90.00, '/uploads/avatars/20250317_203856_matcha.png', 'Blended Frappes');

-- --------------------------------------------------------

--
-- Table structure for table `item_stocks`
--

CREATE TABLE `item_stocks` (
  `id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `min_stock_level` int(11) DEFAULT 10,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

--
-- Dumping data for table `item_stocks`
--

INSERT INTO `item_stocks` (`id`, `item_id`, `quantity`, `min_stock_level`, `last_updated`) VALUES
(2, 8, 999999, 10, '2025-03-17 12:47:25'),
(3, 9, 0, 10, '2025-03-17 16:26:12'),
(4, 10, 0, 10, '2025-03-17 16:26:30'),
(5, 11, 94, 10, '2025-03-16 08:03:50'),
(6, 12, 98, 10, '2025-03-16 07:58:09'),
(7, 13, 99, 10, '2025-03-16 07:58:09'),
(8, 14, 99, 10, '2025-03-16 07:58:09'),
(9, 15, 100, 10, '2025-03-16 04:45:39'),
(10, 16, 99, 10, '2025-03-16 07:58:09'),
(11, 17, 99, 10, '2025-03-16 07:58:09'),
(12, 18, 99, 10, '2025-03-16 07:58:09'),
(13, 19, 99, 10, '2025-03-16 07:58:09'),
(14, 20, 99, 10, '2025-03-16 07:58:09'),
(15, 21, 99, 10, '2025-03-16 07:58:09'),
(16, 22, 100, 10, '2025-03-16 04:45:58'),
(17, 23, 100, 10, '2025-03-16 04:46:01'),
(18, 24, 100, 10, '2025-03-16 04:46:03'),
(19, 25, 100, 10, '2025-03-16 04:46:06'),
(20, 26, 100, 10, '2025-03-16 04:46:09'),
(21, 27, 100, 10, '2025-03-16 04:46:11'),
(22, 28, 100, 10, '2025-03-16 04:46:14'),
(23, 29, 100, 10, '2025-03-16 04:46:18'),
(24, 30, 100, 10, '2025-03-16 04:46:20'),
(25, 31, 100, 10, '2025-03-16 04:46:22'),
(26, 32, 100, 10, '2025-03-16 04:46:24'),
(27, 33, 100, 10, '2025-03-16 04:46:29'),
(28, 34, 100, 10, '2025-03-16 04:46:31'),
(29, 35, 100, 10, '2025-03-16 04:46:34'),
(30, 36, 100, 10, '2025-03-16 04:46:36'),
(36, 42, 100, 10, '2025-03-16 04:47:03'),
(39, 54, 100, 10, '2025-03-16 04:47:12'),
(40, 57, 100, 10, '2025-03-16 04:47:16'),
(41, 75, 97, 10, '2025-03-17 04:55:07'),
(43, 93, 100, 10, '2025-03-16 04:47:21'),
(46, 120, 100, 10, '2025-03-16 04:47:26'),
(48, 122, 100, 10, '2025-03-16 04:47:33'),
(50, 124, 100, 10, '2025-03-16 04:47:37'),
(53, 127, 100, 10, '2025-03-16 04:47:45'),
(55, 130, 100, 10, '2025-03-16 04:47:50'),
(58, 134, 100, 10, '2025-03-16 04:47:59'),
(59, 135, 100, 10, '2025-03-16 04:48:01'),
(60, 136, 100, 10, '2025-03-16 04:48:03'),
(61, 137, 100, 10, '2025-03-16 04:48:06'),
(62, 138, 100, 10, '2025-03-16 04:48:08'),
(63, 139, 100, 10, '2025-03-16 04:48:11'),
(64, 140, 200, 10, '2025-03-16 04:49:24'),
(65, 141, 100, 10, '2025-03-16 04:49:26'),
(66, 142, 100, 10, '2025-03-16 04:49:28'),
(67, 143, 100, 10, '2025-03-16 04:49:32'),
(68, 144, 100, 10, '2025-03-16 04:49:34'),
(69, 145, 100, 10, '2025-03-16 04:49:37'),
(70, 146, 100, 10, '2025-03-16 04:49:39'),
(71, 147, 100, 10, '2025-03-16 04:49:42'),
(72, 148, 100, 10, '2025-03-16 04:49:44'),
(73, 150, 96, 10, '2025-03-17 04:55:07'),
(74, 152, 0, 10, '2025-03-18 02:08:41'),
(75, 153, 98, 10, '2025-03-17 05:07:09'),
(76, 154, 99, 10, '2025-03-17 04:55:07'),
(77, 155, 99, 10, '2025-03-17 04:55:07'),
(78, 156, 99, 10, '2025-03-17 04:55:07'),
(79, 157, 99, 10, '2025-03-17 04:55:07'),
(80, 158, 100, 10, '2025-03-16 04:50:05'),
(81, 159, 99, 10, '2025-03-17 04:55:07'),
(82, 160, 99, 10, '2025-03-17 04:55:07'),
(83, 161, 100, 10, '2025-03-16 04:50:12'),
(84, 162, 98, 10, '2025-03-17 04:55:07'),
(85, 163, 99, 10, '2025-03-17 04:55:07'),
(86, 164, 99, 10, '2025-03-17 04:55:07'),
(89, 168, 99, 0, '2025-03-16 07:01:37'),
(90, 169, 98, 0, '2025-03-16 14:47:06'),
(91, 170, 999999, 0, '2025-03-17 05:14:07'),
(92, 171, 100, 0, '2025-03-16 14:51:32'),
(93, 172, 999998, 0, '2025-03-17 05:40:35'),
(94, 173, 21, 0, '2025-03-17 07:03:44'),
(95, 174, 0, 0, '2025-03-17 12:38:49'),
(96, 175, 0, 0, '2025-03-17 12:38:53'),
(97, 176, 0, 0, '2025-03-17 12:38:53'),
(98, 177, 0, 0, '2025-03-17 12:38:53'),
(99, 178, 0, 0, '2025-03-17 12:38:53'),
(100, 179, 0, 0, '2025-03-17 12:38:53'),
(101, 180, 0, 0, '2025-03-17 12:38:53'),
(102, 181, 0, 0, '2025-03-17 12:38:54'),
(103, 182, 0, 0, '2025-03-17 12:38:54'),
(104, 183, 0, 0, '2025-03-17 12:38:54'),
(105, 184, 0, 0, '2025-03-17 12:38:54'),
(106, 185, 0, 0, '2025-03-17 12:38:54'),
(107, 186, 0, 0, '2025-03-17 12:38:54'),
(108, 187, 0, 0, '2025-03-17 12:38:54'),
(109, 188, 0, 0, '2025-03-17 12:38:54'),
(110, 189, 0, 0, '2025-03-17 12:38:54'),
(111, 190, 0, 0, '2025-03-17 12:38:54'),
(112, 191, 0, 0, '2025-03-17 12:38:54'),
(113, 192, 0, 0, '2025-03-17 12:38:54'),
(114, 193, 0, 0, '2025-03-17 12:38:54'),
(115, 194, 0, 0, '2025-03-17 12:38:54'),
(117, 196, 0, 0, '2025-03-17 12:38:54'),
(118, 197, 0, 0, '2025-03-17 12:38:54'),
(119, 198, 0, 0, '2025-03-17 12:38:54'),
(121, 200, 0, 0, '2025-03-17 12:38:54'),
(123, 202, 0, 0, '2025-03-17 12:38:54'),
(124, 203, 0, 0, '2025-03-17 12:38:54'),
(125, 204, 0, 0, '2025-03-17 12:38:55'),
(127, 206, 0, 0, '2025-03-17 12:38:55'),
(129, 208, 0, 0, '2025-03-17 12:38:55'),
(131, 210, 0, 0, '2025-03-17 12:38:55'),
(132, 211, 0, 0, '2025-03-17 12:38:55'),
(135, 214, 0, 0, '2025-03-17 12:38:55'),
(138, 217, 0, 0, '2025-03-17 12:38:55'),
(139, 218, 0, 0, '2025-03-17 12:38:55'),
(140, 219, 0, 0, '2025-03-17 12:38:55'),
(141, 220, 0, 0, '2025-03-17 12:38:55'),
(142, 221, 0, 0, '2025-03-17 12:38:56'),
(143, 222, 0, 0, '2025-03-17 12:38:56'),
(144, 223, 0, 0, '2025-03-17 12:38:56'),
(145, 224, 0, 0, '2025-03-17 12:38:56'),
(146, 225, 0, 0, '2025-03-17 12:38:56'),
(147, 226, 0, 0, '2025-03-17 12:38:56'),
(148, 227, 0, 0, '2025-03-17 12:38:56'),
(149, 228, 0, 0, '2025-03-17 12:38:56'),
(150, 229, 0, 0, '2025-03-17 12:38:56'),
(151, 230, 0, 0, '2025-03-17 12:38:56'),
(152, 231, 0, 0, '2025-03-17 12:38:56'),
(153, 232, 0, 0, '2025-03-17 12:38:56'),
(154, 233, 0, 0, '2025-03-17 12:38:56'),
(155, 234, 0, 0, '2025-03-17 12:38:56'),
(156, 235, 0, 0, '2025-03-17 12:38:56'),
(157, 236, 999999, 0, '2025-03-17 16:25:11'),
(158, 237, 999999, 0, '2025-03-17 16:25:15'),
(159, 238, 999999, 0, '2025-03-17 16:25:20'),
(160, 239, 999999, 0, '2025-03-17 16:25:23');

--
-- Triggers `item_stocks`
--
DELIMITER $$
CREATE TRIGGER `check_stock_level` AFTER UPDATE ON `item_stocks` FOR EACH ROW BEGIN
    IF NEW.quantity <= NEW.min_stock_level AND NEW.quantity > 0 THEN
        INSERT INTO stock_alerts (item_id, alert_type, message)
        VALUES (NEW.item_id, 'low_stock', CONCAT('Low stock alert: Item is below minimum stock level'));
    ELSEIF NEW.quantity = 0 THEN
        INSERT INTO stock_alerts (item_id, alert_type, message)
        VALUES (NEW.item_id, 'out_of_stock', CONCAT('Out of stock alert: Item has no stock remaining'));
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `track_stock_changes` AFTER UPDATE ON `item_stocks` FOR EACH ROW BEGIN
    IF NEW.quantity != OLD.quantity THEN
        INSERT INTO stock_transactions (
            item_id,
            transaction_type,
            quantity,
            previous_quantity,
            new_quantity,
            reason
        )
        VALUES (
            NEW.item_id,
            CASE 
                WHEN NEW.quantity > OLD.quantity THEN 'add'
                WHEN NEW.quantity < OLD.quantity THEN 'subtract'
                ELSE 'adjustment'
            END,
            ABS(NEW.quantity - OLD.quantity),
            OLD.quantity,
            NEW.quantity,
            'Stock update'
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(3) UNSIGNED NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `items` text NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `customer_name`, `items`, `status`, `created_at`) VALUES
(1, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 12:57:12'),
(2, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 12:58:08'),
(3, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 12:58:27'),
(4, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 12:58:52'),
(5, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 2, \"price\": 115.0}]', 'completed', '2025-02-26 12:59:13'),
(6, 'Lors', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 13:06:21'),
(7, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 2, \"price\": 115.0}]', 'completed', '2025-02-26 13:07:42'),
(8, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 13:08:09'),
(9, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 13:08:39'),
(10, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 13:25:10'),
(11, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'declined', '2025-02-26 13:32:48'),
(12, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 13:34:15'),
(13, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 13:44:30'),
(14, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 13:44:58'),
(15, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 13:59:16'),
(16, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 13:59:56'),
(17, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 2, \"price\": 80.0}]', 'declined', '2025-02-26 14:00:55'),
(18, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 14:01:33'),
(19, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 2, \"price\": 80.0}]', 'completed', '2025-02-26 14:15:35'),
(20, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 14:47:52'),
(21, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 15:38:02'),
(22, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 15:54:28'),
(23, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 15:54:52'),
(24, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 16:15:38'),
(25, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 16:15:58'),
(26, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 16:16:27'),
(27, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 16:17:38'),
(28, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 2, \"price\": 80.0}]', 'completed', '2025-02-26 16:43:37'),
(29, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 16:44:31'),
(30, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 17:06:47'),
(31, 'Lors', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 17:07:12'),
(32, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 17:07:59'),
(33, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 17:13:13'),
(34, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 17:13:38'),
(35, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 17:13:55'),
(36, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 17:29:58'),
(37, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 17:30:26'),
(38, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 17:30:35'),
(39, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 17:35:44'),
(40, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 17:35:50'),
(41, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 17:52:40'),
(42, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-26 17:52:46'),
(43, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 17:57:19'),
(44, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'declined', '2025-02-26 17:59:03'),
(45, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}, {\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Angel Affogato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 18:01:59'),
(46, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 18:21:59'),
(47, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 18:22:35'),
(48, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 18:22:51'),
(49, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-26 18:23:58'),
(50, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 2, \"price\": 115.0}]', 'completed', '2025-02-27 10:56:25'),
(51, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-27 13:53:36'),
(52, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 2, \"price\": 80.0}, {\"name\": \"Ice Peppermint Latte\", \"quantity\": 18, \"price\": 115.0}, {\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Angel Affogato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-27 16:39:45'),
(53, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-27 16:40:33'),
(54, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 03:29:48'),
(55, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 03:31:12'),
(56, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 03:31:25'),
(57, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'declined', '2025-02-28 03:32:18'),
(58, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 04:17:14'),
(59, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 04:24:10'),
(60, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 04:59:00'),
(61, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'declined', '2025-02-28 04:59:22'),
(62, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 05:06:53'),
(63, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 05:18:42'),
(64, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}, {\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 05:18:59'),
(65, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 05:58:31'),
(66, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 05:59:17'),
(67, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 06:02:51'),
(68, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 06:05:44'),
(69, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 06:06:07'),
(70, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 10:53:30'),
(71, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'declined', '2025-02-28 11:13:26'),
(72, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 11:30:15'),
(73, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 2, \"price\": 115.0}]', 'completed', '2025-02-28 11:40:52'),
(74, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 11:54:55'),
(75, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 12:05:04'),
(76, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 12:06:09'),
(77, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 12:21:38'),
(78, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 12:35:06'),
(79, 'Lors', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 12:35:14'),
(80, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:31:27'),
(81, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:38:41'),
(82, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:39:10'),
(83, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:39:22'),
(84, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:39:54'),
(85, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:40:54'),
(86, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:41:17'),
(87, 'Princess', '[{\"name\": \"Ice Angel Affogato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:41:26'),
(88, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:42:14'),
(89, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:42:41'),
(90, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:42:51'),
(91, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:43:46'),
(92, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 13:44:06'),
(93, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:49:33'),
(94, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:54:16'),
(95, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:54:50'),
(96, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:56:39'),
(97, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'declined', '2025-02-28 13:59:09'),
(98, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 13:59:20'),
(99, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:00:52'),
(100, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:04:58'),
(101, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:05:47'),
(102, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:06:03'),
(103, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:07:07'),
(104, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:07:20'),
(105, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:08:25'),
(106, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:08:35'),
(107, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:09:58'),
(108, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:12:00'),
(109, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:12:24'),
(110, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 2, \"price\": 115.0}]', 'completed', '2025-02-28 14:14:30'),
(111, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:14:59'),
(112, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:16:56'),
(113, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:17:20'),
(114, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:17:30'),
(115, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:17:39'),
(116, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:18:59'),
(117, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:20:22'),
(118, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:21:42'),
(119, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:21:53'),
(120, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:22:26'),
(121, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:24:32'),
(122, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:24:46'),
(123, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:26:34'),
(124, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:26:58'),
(125, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 2, \"price\": 115.0}]', 'completed', '2025-02-28 14:27:16'),
(126, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:28:53'),
(127, 'Princess', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:29:10'),
(128, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:29:23'),
(129, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:32:03'),
(130, 'Princess', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:32:16'),
(131, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:33:53'),
(132, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:34:18'),
(133, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:34:35'),
(134, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 2, \"price\": 115.0}]', 'completed', '2025-02-28 14:34:46'),
(135, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:34:54'),
(136, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:35:07'),
(137, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:35:16'),
(138, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:35:36'),
(139, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:35:46'),
(140, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:36:06'),
(141, 'Princess', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:36:20'),
(142, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:37:17'),
(143, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:37:30'),
(144, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:38:04'),
(145, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:38:44'),
(146, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:39:02'),
(147, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:40:02'),
(148, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:40:18'),
(149, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:40:32'),
(150, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:40:51'),
(151, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:42:52'),
(152, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:43:06'),
(153, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:44:33'),
(154, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:44:50'),
(155, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:44:58'),
(156, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:45:21'),
(157, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:45:33'),
(158, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:45:46'),
(159, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:45:57'),
(160, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:46:21'),
(161, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:47:58'),
(162, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:48:06'),
(163, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:48:30'),
(164, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:48:55'),
(165, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:49:09'),
(166, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:49:19'),
(167, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:49:26'),
(168, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:49:35'),
(169, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 14:50:36'),
(170, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:50:44'),
(171, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:51:14'),
(172, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:51:23'),
(173, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 14:51:36'),
(174, 'Lors', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 16:02:41'),
(175, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 16:19:19'),
(176, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 16:27:00'),
(177, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 16:28:49'),
(178, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 16:29:24'),
(179, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-02-28 16:48:23'),
(180, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'declined', '2025-02-28 16:48:30'),
(181, 'Princess', '[{\"name\": \"Carbonara\", \"quantity\": 1, \"price\": 70.0}]', 'completed', '2025-02-28 16:52:27'),
(182, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-02-28 17:02:19'),
(183, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'declined', '2025-03-01 05:26:43'),
(184, 'Princess', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 05:54:38'),
(185, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 09:41:52'),
(186, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 09:57:02'),
(187, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 100, \"price\": 115.0}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 100, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 100, \"price\": 80.0}, {\"name\": \"Cookies & Coffee Frappe\", \"quantity\": 100, \"price\": 135.0}]', 'completed', '2025-03-01 10:11:51'),
(188, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-01 10:34:16'),
(189, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-01 10:34:25'),
(190, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-01 10:43:40'),
(191, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-01 10:43:50'),
(192, 'Princess', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 10:44:16'),
(193, 'Princess', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 10:58:11'),
(194, 'Princess', '[]', 'completed', '2025-03-01 10:58:14'),
(195, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-01 10:58:27'),
(196, 'Princess', '[]', 'completed', '2025-03-01 10:58:30'),
(197, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 10:58:47'),
(198, 'Princess', '[]', 'completed', '2025-03-01 10:58:50'),
(199, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 10:59:45'),
(200, 'Princess', '[]', 'completed', '2025-03-01 10:59:48'),
(201, 'Princess', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 11:00:00'),
(202, 'Princess', '[]', 'completed', '2025-03-01 11:00:04'),
(203, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'declined', '2025-03-01 11:00:24'),
(204, 'Princess', '[]', 'completed', '2025-03-01 11:00:28'),
(205, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-01 11:00:33'),
(206, 'Princess', '[]', 'completed', '2025-03-01 11:00:37'),
(207, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-01 11:04:54'),
(208, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-01 11:05:05'),
(209, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-01 11:05:16'),
(210, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-01 11:09:52'),
(211, 'Princess', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-01 11:10:06'),
(212, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-01 11:13:16'),
(213, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Tuna Pasta\", \"quantity\": 1, \"price\": 70.0}]', 'completed', '2025-03-01 11:14:20'),
(214, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-01 15:43:39'),
(215, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 15:43:50'),
(216, 'Princess', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 12, \"price\": 80.0}]', 'completed', '2025-03-01 15:58:35'),
(217, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 3, \"price\": 80.0}, {\"name\": \"Ice Caramel Macchiato\", \"quantity\": 9, \"price\": 115.0}]', 'completed', '2025-03-01 16:03:05'),
(218, 'Princess', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Cappuccino\", \"quantity\": 4, \"price\": 115.0}]', 'completed', '2025-03-01 16:06:48'),
(219, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 5, \"price\": 115.0}]', 'completed', '2025-03-01 16:17:39'),
(220, 'Princess', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 7, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-01 16:32:11'),
(221, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 6, \"price\": 80.0}]', 'declined', '2025-03-01 16:46:36'),
(222, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 2, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 7, \"price\": 80.0}, {\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Cappuccino\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 16:51:33'),
(223, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 16:51:42'),
(224, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 2, \"price\": 115.0}]', 'completed', '2025-03-01 16:51:57'),
(225, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 16:52:07'),
(226, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 16:53:26'),
(227, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 16:53:33'),
(228, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 16:53:48'),
(229, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 16:53:57'),
(230, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 16:54:05'),
(231, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 2, \"price\": 115.0}]', 'completed', '2025-03-01 16:54:15'),
(232, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-01 16:54:22'),
(233, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 3, \"price\": 115.0}, {\"name\": \"Ice Caramel Macchiato\", \"quantity\": 2, \"price\": 115.0}, {\"name\": \"Hot Ice Cappuccino\", \"quantity\": 1, \"price\": 75.0}, {\"name\": \"Hot Matcha Cafe Latte\", \"quantity\": 1, \"price\": 90.0}]', 'completed', '2025-03-02 03:14:37'),
(234, 'Lors', '[{\"name\": \"Ice Spanish Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-02 03:49:45'),
(235, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-02 03:49:53'),
(236, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}, {\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Spanish Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-02 03:51:59'),
(237, 'Lors', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 3, \"price\": 115.0}, {\"name\": \"Ube Frappe\", \"quantity\": 1, \"price\": 90.0}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 2, \"price\": 115.0}]', 'completed', '2025-03-02 05:27:09'),
(238, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Peppermint Latte\", \"quantity\": 3, \"price\": 115.0}]', 'completed', '2025-03-02 13:15:41'),
(239, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-02 15:34:50'),
(240, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 2, \"price\": 115.0}]', 'completed', '2025-03-03 12:33:32'),
(241, 'Lors', '[{\"name\": \"Ice Spanish Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Apple Juice\", \"quantity\": 1, \"price\": 55.0}, {\"name\": \"Hot Cafe Americano\", \"quantity\": 1, \"price\": 70.0}, {\"name\": \"Ice Peppermint Latte\", \"quantity\": 8, \"price\": 115.0}]', 'completed', '2025-03-03 13:20:13'),
(242, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 3, \"price\": 115.0}]', 'completed', '2025-03-03 14:12:34'),
(243, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-03 14:13:36'),
(244, 'Lors', '[{\"name\": \"Ice Angel Affogato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-03 14:13:42'),
(245, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 5, \"price\": 115.0}, {\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Carbonara\", \"quantity\": 1, \"price\": 70.0}, {\"name\": \"Ice Angel Affogato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-03 16:13:30'),
(246, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Peppermint Latte\", \"quantity\": 2, \"price\": 115.0}]', 'completed', '2025-03-03 16:18:49'),
(247, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-04 04:09:33'),
(248, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-04 09:33:53'),
(249, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 2, \"price\": 115.0}]', 'completed', '2025-03-05 04:31:51'),
(250, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 4, \"price\": 115.0}]', 'completed', '2025-03-05 04:55:42'),
(251, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 04:57:27'),
(252, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-05 04:57:33'),
(253, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 04:57:39'),
(254, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 04:57:44'),
(255, 'Lors', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 04:57:51'),
(256, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 04:57:58'),
(257, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 04:58:07'),
(258, 'Lors', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 04:58:15'),
(259, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 04:58:24'),
(260, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 9, \"price\": 115.0}]', 'completed', '2025-03-05 04:58:31'),
(261, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-05 04:58:39'),
(262, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 05:00:07'),
(263, 'Lors', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 05:00:21'),
(264, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-05 05:00:36'),
(265, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 05:00:53'),
(266, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 05:01:11'),
(267, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 05:01:42'),
(268, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 05:03:03'),
(269, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-05 05:03:12'),
(270, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-05 05:05:01'),
(271, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 2, \"price\": 115.0}]', 'completed', '2025-03-05 05:06:27'),
(272, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-05 05:06:34'),
(273, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 2, \"price\": 115.0}]', 'completed', '2025-03-05 05:07:17'),
(274, 'Lors', '[{\"name\": \"Cold Chocolate\", \"quantity\": 1, \"price\": 85.0}, {\"name\": \"Ice Salted Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 05:19:57'),
(275, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 06:21:27'),
(276, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 07:40:47'),
(277, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 10:46:40'),
(278, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 14:30:50'),
(279, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 2, \"price\": 115.0}, {\"name\": \"Cookies & Cream Frappe\", \"quantity\": 1, \"price\": 90.0}]', 'completed', '2025-03-05 14:56:10'),
(280, 'Princess', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-05 16:10:27'),
(281, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}, {\"name\": \"Hot Cafe Americano\", \"quantity\": 1, \"price\": 70.0}, {\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-06 12:36:28'),
(282, 'Lors', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-08 15:53:43'),
(283, 'Lors', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-09 09:53:01'),
(284, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-10 08:44:50'),
(285, 'Lors', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'declined', '2025-03-10 09:48:13'),
(286, 'choco', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-10 10:15:48'),
(287, 'Lors', '[{\"name\": \"Hot Peppermint Latte\", \"quantity\": 1, \"price\": 90.0}, {\"name\": \"Hot Cafe Latte\", \"quantity\": 1, \"price\": 85.0}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Yakult Orange Lemonade\", \"quantity\": 1, \"price\": 75.0}, {\"name\": \"Carrot Juice\", \"quantity\": 1, \"price\": 60.0}, {\"name\": \"Hot Cafe Americano\", \"quantity\": 1, \"price\": 70.0}, {\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-11 09:00:48'),
(288, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 18, \"price\": 115.0}]', 'completed', '2025-03-11 11:21:49'),
(289, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Hot Cafe Latte\", \"quantity\": 1, \"price\": 85.0}, {\"name\": \"Orange Juice\", \"quantity\": 1, \"price\": 75.0}]', 'declined', '2025-03-11 11:27:51'),
(290, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}, {\"name\": \"Ice Spanish Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-12 05:09:33'),
(291, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 18, \"price\": 115.0}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Tuna Pasta\", \"quantity\": 1, \"price\": 70.0}]', 'completed', '2025-03-12 06:18:05'),
(292, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-12 07:10:16'),
(293, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"323\", \"quantity\": 1, \"price\": 213.0}, {\"name\": \"Hot Cafe Americano\", \"quantity\": 1, \"price\": 70.0}, {\"name\": \"Carbonara\", \"quantity\": 1, \"price\": 70.0}]', 'completed', '2025-03-12 07:24:05'),
(294, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"323\", \"quantity\": 1, \"price\": 213.0}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Okinawa Milktea\", \"quantity\": 1, \"price\": 60.0}, {\"name\": \"Chicken\", \"quantity\": 1, \"price\": 250.0}, {\"name\": \"Apple Juice\", \"quantity\": 1, \"price\": 55.0}, {\"name\": \"Carrot Juice\", \"quantity\": 1, \"price\": 60.0}, {\"name\": \"Chocos\", \"quantity\": 1, \"price\": 232.0}]', 'declined', '2025-03-12 07:40:48'),
(295, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-12 08:57:50'),
(296, 'Lors', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-12 08:57:56'),
(297, 'Lors', '[{\"name\": \"Chicken\", \"quantity\": 1, \"price\": 250.0}]', 'completed', '2025-03-12 09:42:42'),
(298, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-12 09:43:34'),
(299, 'Lors', '[{\"name\": \"Chicken\", \"quantity\": 1, \"price\": 250.0}]', 'completed', '2025-03-12 09:46:17'),
(300, 'Lors', '[{\"name\": \"Chocvo\", \"quantity\": 1, \"price\": 123.0}]', 'completed', '2025-03-12 09:49:10'),
(301, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Chocvo\", \"quantity\": 1, \"price\": 123.0}]', 'completed', '2025-03-12 09:52:34'),
(302, 'Lors', '[{\"name\": \"Hoty\", \"quantity\": 1, \"price\": 234.0}]', 'completed', '2025-03-12 09:53:26'),
(303, 'Lors', '[{\"name\": \"Chocvo\", \"quantity\": 1, \"price\": 123.0}]', 'completed', '2025-03-12 09:55:05'),
(304, 'Lors', '[{\"name\": \"Ice Cafe Americano\", \"quantity\": 1, \"price\": 75.0}, {\"name\": \"Chocvo\", \"quantity\": 1, \"price\": 123.0}]', 'completed', '2025-03-12 09:57:31'),
(305, 'Lors', '[{\"name\": \"Ice Angel Affogato\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"Chocvo\", \"quantity\": 1, \"price\": 123.0}]', 'completed', '2025-03-12 10:00:30'),
(306, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}, {\"name\": \"Chocvo\", \"quantity\": 1, \"price\": 123.0}, {\"name\": \"Chicken\", \"quantity\": 1, \"price\": 250.0}, {\"name\": \"2132\", \"quantity\": 1, \"price\": 213.0}, {\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-12 10:05:53'),
(307, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-12 10:09:44'),
(308, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}, {\"name\": \"2132\", \"quantity\": 1, \"price\": 213.0}]', 'declined', '2025-03-12 10:10:18'),
(309, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0}]', 'completed', '2025-03-12 10:13:13'),
(310, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0}]', 'completed', '2025-03-12 10:15:47'),
(311, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}, {\"name\": \"Ice Cappuccino\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cappuccino.png\"}]', 'completed', '2025-03-12 13:49:07'),
(312, 'Lors', '[{\"name\": \"2132\", \"quantity\": 1, \"price\": 213.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_180500_crocodile.jpg\"}]', 'completed', '2025-03-12 13:49:55'),
(313, 'Lors', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_peppermint-latte.png\"}, {\"name\": \"Chocvo\", \"quantity\": 1, \"price\": 123.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_174853_indulge-this-delightful-hot-chocolate-topped-with-creamy-whipped-cream-chocolate-shavings-perfect-winter-warmer-treat_191095-77920.avif\"}, {\"name\": \"Crocodile\", \"quantity\": 1, \"price\": 2500.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_180500_crocodile.jpg\"}, {\"name\": \"Cold Chocolate\", \"quantity\": 1, \"price\": 85.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_cold-chocolate.png\"}, {\"name\": \"Hot Cafe Americano\", \"quantity\": 1, \"price\": 70.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_cafe-americano.png\"}]', 'completed', '2025-03-12 15:36:02'),
(314, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}, {\"name\": \"Chicken\", \"quantity\": 1, \"price\": 250.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_152643_chicken-sandwich.jpg\"}]', 'completed', '2025-03-12 15:57:47'),
(315, 'Lorskiee', '[{\"name\": \"Ice Angel Affogato\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_angel-affogato.png\"}, {\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_peppermint-latte.png\"}, {\"name\": \"Chicken\", \"quantity\": 1, \"price\": 250.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_152643_chicken-sandwich.jpg\"}, {\"name\": \"Chocvo\", \"quantity\": 1, \"price\": 123.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_174853_indulge-this-delightful-hot-chocolate-topped-with-creamy-whipped-cream-chocolate-shavings-perfect-winter-warmer-treat_191095-77920.avif\"}]', 'completed', '2025-03-13 13:22:37'),
(316, 'Lorskiee', '[{\"name\": \"eheys\", \"quantity\": 1, \"price\": 222.0, \"image\": \"http://localhost:8000/uploads/avatars/20250313_212611_cappuccino.jpg\"}]', 'completed', '2025-03-13 13:26:30'),
(317, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_matcha-cafe-latte.png\"}]', 'completed', '2025-03-15 14:25:59'),
(318, 'Lors', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 2, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_matcha-cafe-latte.png\"}]', 'completed', '2025-03-15 14:26:55'),
(319, '2321312', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_caramel-macchiato.png\"}]', 'completed', '2025-03-15 14:30:25'),
(320, 'Princess', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'completed', '2025-03-15 14:39:10'),
(321, 'fert', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_caramel-macchiato.png\"}]', 'declined', '2025-03-15 14:40:23'),
(322, 'fert', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_peppermint-latte.png\"}]', 'completed', '2025-03-16 02:57:57'),
(323, 'fert', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_peppermint-latte.png\"}]', 'completed', '2025-03-16 02:58:14'),
(324, 'fert', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_peppermint-latte.png\"}]', 'completed', '2025-03-16 03:00:02');
INSERT INTO `orders` (`id`, `customer_name`, `items`, `status`, `created_at`) VALUES
(325, 'fert', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_peppermint-latte.png\"}]', 'completed', '2025-03-16 03:03:56'),
(326, 'fert', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_peppermint-latte.png\"}]', 'completed', '2025-03-16 03:07:32'),
(327, 'fert', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_peppermint-latte.png\"}]', 'declined', '2025-03-16 03:10:47'),
(328, 'fert', '[{\"name\": \"Ice Peppermint Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_peppermint-latte.png\"}]', 'completed', '2025-03-16 03:12:37'),
(329, 'fert', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'completed', '2025-03-16 03:23:39'),
(330, 'fert', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'declined', '2025-03-16 03:28:04'),
(331, 'fert', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'declined', '2025-03-16 03:28:33'),
(332, 'fert', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'declined', '2025-03-16 03:29:14'),
(333, 'fert', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'declined', '2025-03-16 03:29:37'),
(334, 'fert', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'declined', '2025-03-16 03:29:50'),
(335, 'fert', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'completed', '2025-03-16 03:33:26'),
(336, 'fert', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'declined', '2025-03-16 03:40:22'),
(337, 'fert', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_matcha-cafe-latte.png\"}]', 'completed', '2025-03-16 04:00:01'),
(338, 'fert', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'completed', '2025-03-16 04:00:04'),
(339, 'fert', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 2, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 8, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_matcha-cafe-latte.png\"}]', 'declined', '2025-03-16 04:03:23'),
(340, 'fert', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}, {\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 2, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_matcha-cafe-latte.png\"}]', 'completed', '2025-03-16 03:59:59'),
(341, 'fert', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 7, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_matcha-cafe-latte.png\"}]', 'completed', '2025-03-16 04:03:53'),
(342, 'fert', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'completed', '2025-03-16 04:12:31'),
(343, 'fert', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'completed', '2025-03-16 04:14:23'),
(344, 'fert', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'completed', '2025-03-16 04:15:39'),
(345, 'fert', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'completed', '2025-03-16 04:22:28'),
(346, 'fert', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'completed', '2025-03-16 04:24:41'),
(347, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_matcha-cafe-latte.png\"}, {\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_caramel-macchiato.png\"}, {\"name\": \"Ice Angel Affogato\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_angel-affogato.png\"}, {\"name\": \"Cold Chocolate\", \"quantity\": 1, \"price\": 85.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_cold-chocolate.png\"}]', 'completed', '2025-03-16 04:51:04'),
(348, 'Goku', '[{\"name\": \"Carbonara\", \"quantity\": 1, \"price\": 70.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_carbonara.png\"}, {\"name\": \"Cake\", \"quantity\": 1, \"price\": 256.0, \"image\": \"http://localhost:8000/uploads/avatars/20250316_145437_images_1.jpg\"}]', 'completed', '2025-03-16 07:01:14'),
(349, 'Goku', '[{\"name\": \"Letchon Baboy 50kg\", \"quantity\": 5, \"price\": 10750.0, \"image\": \"http://localhost:8000/uploads/avatars/20250316_150700_lechon-boodle-fight-1wpq72h954frcijq.jpg\"}, {\"name\": \"Hot Cafe Americano\", \"quantity\": 1, \"price\": 70.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_cafe-americano.png\"}]', 'declined', '2025-03-16 07:11:38'),
(350, 'Goku', '[{\"name\": \"Hot Cafe Americano\", \"quantity\": 1, \"price\": 70.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_cafe-americano.png\"}, {\"name\": \"Hot Matcha Cafe Latte\", \"quantity\": 1, \"price\": 90.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_hot-matcha-cafe-latte.png\"}, {\"name\": \"Hot Cafe Latte Macchiato\", \"quantity\": 1, \"price\": 85.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_hot-cafelattemacc.png\"}]', 'declined', '2025-03-16 07:12:34'),
(351, 'Goku', '[{\"name\": \"Hot Peppermint Latte\", \"quantity\": 1, \"price\": 90.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_hot-peppermint-latte.png\"}, {\"name\": \"Hot Caramel Macchiato\", \"quantity\": 1, \"price\": 90.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_hot-caramel-macchiato.png\"}, {\"name\": \"Hot Salted Caramel Macchiato\", \"quantity\": 1, \"price\": 90.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_hot-salted-caramel-macchiato.png\"}]', 'declined', '2025-03-16 07:16:43'),
(352, 'Goku', '[{\"name\": \"Hot Matcha Cafe Latte\", \"quantity\": 1, \"price\": 90.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_hot-matcha-cafe-latte.png\"}, {\"name\": \"Hot Vanilla Latte\", \"quantity\": 1, \"price\": 90.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_hot-vanilla-latte.png\"}, {\"name\": \"Letchon Baboy 50kg\", \"quantity\": 1, \"price\": 10750.0, \"image\": \"http://localhost:8000/uploads/avatars/20250316_150700_lechon-boodle-fight-1wpq72h954frcijq.jpg\"}, {\"name\": \"Caramel Cake\", \"quantity\": 1, \"price\": 600.0, \"image\": \"http://localhost:8000/uploads/avatars/20250316_145603_d.avif\"}]', 'declined', '2025-03-16 07:21:16'),
(353, 'Goku', '[{\"name\": \"Caramel Cake\", \"quantity\": 1, \"price\": 600.0, \"image\": \"http://localhost:8000/uploads/avatars/20250316_145603_d.avif\"}]', 'declined', '2025-03-16 07:22:03'),
(354, 'Goku', '[{\"name\": \"Caramel Cake\", \"quantity\": 1, \"price\": 600.0, \"image\": \"http://localhost:8000/uploads/avatars/20250316_145603_d.avif\"}, {\"name\": \"Cake\", \"quantity\": 1, \"price\": 256.0, \"image\": \"http://localhost:8000/uploads/avatars/20250316_145437_images_1.jpg\"}]', 'declined', '2025-03-16 07:22:43'),
(355, 'Goku', '[{\"name\": \"Cold Chocolate\", \"quantity\": 1, \"price\": 85.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_cold-chocolate.png\"}]', 'completed', '2025-03-16 07:23:03'),
(356, 'Goku', '[{\"name\": \"Cold Chocolate\", \"quantity\": 1, \"price\": 85.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_cold-chocolate.png\"}]', 'completed', '2025-03-16 07:27:32'),
(357, 'Goku', '[{\"name\": \"Hot Chocolate\", \"quantity\": 1, \"price\": 75.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_hot-chocolate.png\"}]', 'completed', '2025-03-16 07:27:41'),
(358, 'Goku', '[{\"name\": \"Cold Chocolate\", \"quantity\": 1, \"price\": 85.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_cold-chocolate.png\"}]', 'declined', '2025-03-16 07:32:13'),
(359, 'f', '[{\"name\": \"Hot Chocolate\", \"quantity\": 1, \"price\": 75.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_hot-chocolate.png\"}, {\"name\": \"Letchon Baboy 50kg\", \"quantity\": 1, \"price\": 10750.0, \"image\": \"http://localhost:8000/uploads/avatars/20250316_150700_lechon-boodle-fight-1wpq72h954frcijq.jpg\"}, {\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_caramel-macchiato.png\"}]', 'completed', '2025-03-16 07:43:51'),
(360, 'f', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'declined', '2025-03-16 07:45:31'),
(361, 'f', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_matcha-cafe-latte.png\"}]', 'completed', '2025-03-16 07:47:58'),
(362, 'f', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_caramel-macchiato.png\"}, {\"name\": \"Ice Cafe Latte\", \"quantity\": 2, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'completed', '2025-03-16 07:52:58'),
(363, 'f', '[{\"name\": \"Ice Cafe Latte\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cafe-latte.png\"}]', 'completed', '2025-03-16 07:56:01'),
(364, 'f', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_caramel-macchiato.png\"}, {\"name\": \"Ice Americano Lemon\", \"quantity\": 1, \"price\": 90.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_americano-lemon.png\"}, {\"name\": \"Ice White Choco Mocha\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_white-choco-mocha.png\"}, {\"name\": \"Ice Salted Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_salted-caramel-macchiato.png\"}, {\"name\": \"Ice Cafe Frizzy\", \"quantity\": 1, \"price\": 80.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_cafe-frizzy.png\"}, {\"name\": \"Ice Angel Affogato\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_angel-affogato.png\"}, {\"name\": \"Ice Spanish Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_spanish-latte.png\"}, {\"name\": \"Ice Cappuccino\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_ice-cappuccino.png\"}, {\"name\": \"Ice Vanilla Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_vanilla-latte.png\"}, {\"name\": \"Ice Hazelnut Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_hazelnut-latte.png\"}]', 'completed', '2025-03-16 07:57:13'),
(365, 'f', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_caramel-macchiato.png\"}]', 'completed', '2025-03-16 08:01:23'),
(366, 'f', '[{\"name\": \"Ice Caramel Macchiato\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_caramel-macchiato.png\"}]', 'completed', '2025-03-16 08:03:20'),
(367, 'Lors', '[{\"name\": \"Ice Matcha Cafe Latte\", \"quantity\": 1, \"price\": 115.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_matcha-cafe-latte.png\"}]', 'completed', '2025-03-16 13:58:32'),
(368, 'Lors', '[{\"name\": \"Letchon Baboy 50kg\", \"quantity\": 1, \"price\": 10750.0, \"image\": \"http://localhost:8000/uploads/avatars/20250316_150700_lechon-boodle-fight-1wpq72h954frcijq.jpg\"}]', 'completed', '2025-03-16 13:59:33'),
(369, 'Lorsss1s', '[{\"name\": \"Caramel Cake\", \"quantity\": 2, \"price\": 600.0, \"image\": \"http://localhost:8000/uploads/avatars/20250316_145603_d.avif\"}]', 'completed', '2025-03-16 14:46:48'),
(370, 'Lorsss1s', '[{\"name\": \"Letchon Baboy 50kg\", \"quantity\": 1, \"price\": 10750.0, \"image\": \"http://localhost:8000/uploads/avatars/20250316_150700_lechon-boodle-fight-1wpq72h954frcijq.jpg\"}]', 'completed', '2025-03-17 04:48:19'),
(371, 'Ako si lors', '[{\"name\": \"Letchon Baboy 50kg\", \"quantity\": 2, \"price\": 10750.0, \"image\": \"http://localhost:8000/uploads/avatars/20250316_150700_lechon-boodle-fight-1wpq72h954frcijq.jpg\"}, {\"name\": \"Hot Chocolate\", \"quantity\": 1, \"price\": 75.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_155401_hot-chocolate.png\"}, {\"name\": \"Cold Chocolate\", \"quantity\": 1, \"price\": 85.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_cold-chocolate.png\"}, {\"name\": \"Baked Mac\", \"quantity\": 1, \"price\": 70.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_bakemac.png\"}, {\"name\": \"Carbonara\", \"quantity\": 1, \"price\": 70.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_carbonara.png\"}, {\"name\": \"Tuna Pasta\", \"quantity\": 1, \"price\": 70.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_tunapasta.png\"}, {\"name\": \"Strawberry Frappe\", \"quantity\": 1, \"price\": 90.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_strawberry.png\"}, {\"name\": \"Ube Frappe\", \"quantity\": 1, \"price\": 90.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_ube.png\"}, {\"name\": \"Matcha Frappe\", \"quantity\": 1, \"price\": 90.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_matcha.png\"}, {\"name\": \"Mocha Frappe\", \"quantity\": 1, \"price\": 135.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_mocha.png\"}, {\"name\": \"Mango Frappe\", \"quantity\": 1, \"price\": 90.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_mango-frappe.png\"}, {\"name\": \"Melon Frappe\", \"quantity\": 1, \"price\": 90.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_melon.png\"}, {\"name\": \"Chocolate Frappe\", \"quantity\": 1, \"price\": 90.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_chocolate.png\"}, {\"name\": \"Avocado Frappe\", \"quantity\": 1, \"price\": 90.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_avocado.png\"}]', 'completed', '2025-03-17 04:54:02'),
(372, 'Ako si lors', '[{\"name\": \"Mocha Frappe\", \"quantity\": 1, \"price\": 135.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_mocha.png\"}]', 'completed', '2025-03-17 05:05:29'),
(373, 'Ako si lors', '[{\"name\": \"Letchon Baboy 50kg\", \"quantity\": 1, \"price\": 10750.0, \"image\": \"http://localhost:8000/uploads/avatars/20250316_150700_lechon-boodle-fight-1wpq72h954frcijq.jpg\"}]', 'completed', '2025-03-17 05:07:59'),
(374, 'Ako si lors', '[{\"name\": \"Letchon Baboy 50kg\", \"quantity\": 1, \"price\": 10750.0, \"image\": \"http://localhost:8000/uploads/avatars/20250316_150700_lechon-boodle-fight-1wpq72h954frcijq.jpg\"}]', 'completed', '2025-03-17 05:10:15'),
(375, 'Ako si lors', '[{\"name\": \"Letchon Baboy 50kg\", \"quantity\": 1, \"price\": 10750.0, \"image\": \"http://localhost:8000/uploads/avatars/20250316_150700_lechon-boodle-fight-1wpq72h954frcijq.jpg\"}]', 'completed', '2025-03-17 05:11:34'),
(376, 'Ako si lors', '[{\"name\": \"Fishda\", \"quantity\": 1, \"price\": 250.0, \"image\": \"http://localhost:8000/uploads/avatars/20250317_131844_images.jpg\"}]', 'completed', '2025-03-17 05:19:13'),
(377, 'Ako si lors', '[{\"name\": \"Fishda\", \"quantity\": 1, \"price\": 250.0, \"image\": \"http://localhost:8000/uploads/avatars/20250317_131844_images.jpg\"}]', 'completed', '2025-03-17 05:20:13'),
(378, 'ferty', '[{\"name\": \"Fishda\", \"quantity\": 1, \"price\": 250.0, \"image\": \"http://localhost:8000/uploads/avatars/20250317_131844_images.jpg\"}]', 'declined', '2025-03-17 05:30:02'),
(379, 'ferty', '[{\"name\": \"Fishda\", \"quantity\": 1, \"price\": 250.0, \"image\": \"http://localhost:8000/uploads/avatars/20250317_131844_images.jpg\"}]', 'declined', '2025-03-17 05:34:01'),
(380, 'ferty', '[{\"name\": \"Fishda\", \"quantity\": 1, \"price\": 250.0, \"image\": \"http://localhost:8000/uploads/avatars/20250317_131844_images.jpg\"}]', 'completed', '2025-03-17 05:34:57'),
(381, 'ferty', '[{\"name\": \"Fishda\", \"quantity\": 1, \"price\": 250.0, \"image\": \"http://localhost:8000/uploads/avatars/20250317_131844_images.jpg\"}]', 'completed', '2025-03-17 05:37:32'),
(382, 'ferty', '[{\"name\": \"Fishda\", \"quantity\": 1, \"price\": 250.0, \"image\": \"http://localhost:8000/uploads/avatars/20250317_131844_images.jpg\"}]', 'declined', '2025-03-17 05:39:44'),
(383, 'ferty', '[{\"name\": \"Fishda\", \"quantity\": 1, \"price\": 250.0, \"image\": \"http://localhost:8000/uploads/avatars/20250317_131844_images.jpg\"}]', 'completed', '2025-03-17 05:40:14'),
(384, 'Cess', '[{\"name\": \"Mocha Frappe\", \"quantity\": 1, \"price\": 135.0, \"image\": \"http://localhost:8000/uploads/avatars/20250312_221552_mocha.png\"}]', 'declined', '2025-03-17 06:57:50'),
(385, 'lorskieee', '[{\"name\": \"Fried Chicken\", \"quantity\": 9, \"price\": 45.0, \"image\": \"http://localhost:8000/uploads/avatars/20250317_150202_crispy-fried-chicken-plate-with-salad-carrot_1150-20212.avif\"}]', 'completed', '2025-03-17 07:03:23');

-- --------------------------------------------------------

--
-- Table structure for table `stock_alerts`
--

CREATE TABLE `stock_alerts` (
  `id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `alert_type` enum('low_stock','out_of_stock') NOT NULL,
  `message` varchar(255) NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_alerts`
--

INSERT INTO `stock_alerts` (`id`, `item_id`, `alert_type`, `message`, `is_read`, `created_at`) VALUES
(16, 11, 'low_stock', 'Low stock alert: Item is below minimum stock level', 0, '2025-03-16 03:41:43'),
(17, 11, 'out_of_stock', 'Out of stock alert: Item has no stock remaining', 0, '2025-03-16 03:41:55'),
(18, 162, 'out_of_stock', 'Out of stock alert: Item has no stock remaining', 0, '2025-03-16 03:43:08'),
(23, 10, 'out_of_stock', 'Out of stock alert: Item has no stock remaining', 0, '2025-03-16 04:38:57'),
(26, 170, 'out_of_stock', 'Out of stock alert: Item has no stock remaining', 0, '2025-03-17 04:48:38'),
(27, 170, 'out_of_stock', 'Out of stock alert: Item has no stock remaining', 0, '2025-03-17 05:11:04'),
(28, 170, 'out_of_stock', 'Out of stock alert: Item has no stock remaining', 0, '2025-03-17 05:13:59'),
(29, 152, 'out_of_stock', 'Out of stock alert: Item has no stock remaining', 0, '2025-03-17 05:15:16'),
(30, 8, 'low_stock', 'Low stock alert: Item is below minimum stock level', 0, '2025-03-17 05:22:37'),
(31, 172, 'out_of_stock', 'Out of stock alert: Item has no stock remaining', 0, '2025-03-17 05:38:43'),
(32, 172, 'out_of_stock', 'Out of stock alert: Item has no stock remaining', 0, '2025-03-17 05:39:14'),
(33, 8, 'out_of_stock', 'Out of stock alert: Item has no stock remaining', 0, '2025-03-17 06:45:46'),
(34, 8, 'out_of_stock', 'Out of stock alert: Item has no stock remaining', 0, '2025-03-17 06:45:54'),
(35, 8, 'low_stock', 'Low stock alert: Item is below minimum stock level', 0, '2025-03-17 06:45:57'),
(36, 8, 'out_of_stock', 'Out of stock alert: Item has no stock remaining', 0, '2025-03-17 12:47:11'),
(37, 8, 'out_of_stock', 'Out of stock alert: Item has no stock remaining', 0, '2025-03-17 12:47:21'),
(38, 9, 'out_of_stock', 'Out of stock alert: Item has no stock remaining', 0, '2025-03-17 16:26:12'),
(39, 10, 'out_of_stock', 'Out of stock alert: Item has no stock remaining', 0, '2025-03-17 16:26:30'),
(40, 152, 'out_of_stock', 'Out of stock alert: Item has no stock remaining', 0, '2025-03-18 02:08:41');

-- --------------------------------------------------------

--
-- Table structure for table `stock_transactions`
--

CREATE TABLE `stock_transactions` (
  `id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `transaction_type` enum('add','subtract','adjustment') NOT NULL,
  `quantity` int(11) NOT NULL,
  `previous_quantity` int(11) NOT NULL,
  `new_quantity` int(11) NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_transactions`
--

INSERT INTO `stock_transactions` (`id`, `item_id`, `transaction_type`, `quantity`, `previous_quantity`, `new_quantity`, `reason`, `created_by`, `created_at`) VALUES
(9, 8, 'add', 254, 0, 254, 'Stock update', NULL, '2025-03-16 02:57:24'),
(17, 8, 'subtract', 1, 254, 253, 'Stock update', NULL, '2025-03-16 03:12:44'),
(18, 9, 'add', 10, 0, 10, 'Stock update', NULL, '2025-03-16 03:13:59'),
(19, 10, 'add', 50, 0, 50, 'Stock update', NULL, '2025-03-16 03:23:18'),
(20, 10, 'subtract', 1, 50, 49, 'Stock update', NULL, '2025-03-16 03:23:46'),
(21, 10, 'subtract', 1, 49, 48, 'Stock update', NULL, '2025-03-16 03:35:53'),
(22, 11, 'add', 232, 0, 232, 'Stock update', NULL, '2025-03-16 03:41:32'),
(23, 11, 'subtract', 231, 232, 1, 'Stock update', NULL, '2025-03-16 03:41:43'),
(24, 11, 'subtract', 1, 1, 0, 'Stock update', NULL, '2025-03-16 03:41:55'),
(25, 10, 'subtract', 1, 48, 47, 'Stock update', NULL, '2025-03-16 03:42:03'),
(26, 162, 'add', 50, 0, 50, 'Stock update', NULL, '2025-03-16 03:42:30'),
(27, 162, 'subtract', 1, 50, 49, 'Stock update', NULL, '2025-03-16 03:42:51'),
(28, 162, 'add', 49, 49, 98, 'Stock update', NULL, '2025-03-16 03:43:01'),
(29, 162, 'subtract', 98, 98, 0, 'Stock update', NULL, '2025-03-16 03:43:08'),
(30, 8, 'add', 2, 253, 255, 'Stock update', NULL, '2025-03-16 03:45:34'),
(31, 8, 'add', 230, 255, 485, 'Stock update', NULL, '2025-03-16 03:45:40'),
(32, 8, 'subtract', 485, 485, 0, 'Stock update', NULL, '2025-03-16 03:45:50'),
(33, 10, 'subtract', 1, 47, 46, 'Stock update', NULL, '2025-03-16 03:59:59'),
(34, 9, 'subtract', 2, 10, 8, 'Stock update', NULL, '2025-03-16 03:59:59'),
(35, 9, 'subtract', 1, 8, 7, 'Stock update', NULL, '2025-03-16 04:00:01'),
(36, 10, 'subtract', 1, 46, 45, 'Stock update', NULL, '2025-03-16 04:00:04'),
(46, 9, 'subtract', 7, 7, 0, 'Stock update', NULL, '2025-03-16 04:03:53'),
(47, 9, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:08:11'),
(48, 8, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:11:52'),
(49, 10, 'subtract', 1, 45, 44, 'Stock update', NULL, '2025-03-16 04:14:35'),
(50, 10, 'subtract', 1, 44, 43, 'Stock update', NULL, '2025-03-16 04:14:47'),
(51, 10, 'subtract', 1, 43, 42, 'Stock update', NULL, '2025-03-16 04:16:22'),
(52, 11, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:32:44'),
(53, 12, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:38:45'),
(54, 10, 'subtract', 42, 42, 0, 'Stock update', NULL, '2025-03-16 04:38:57'),
(55, 10, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:45:24'),
(56, 14, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:45:30'),
(57, 13, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:45:34'),
(58, 15, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:45:39'),
(59, 16, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:45:42'),
(60, 17, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:45:45'),
(61, 18, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:45:48'),
(62, 19, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:45:51'),
(63, 20, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:45:53'),
(64, 21, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:45:56'),
(65, 22, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:45:58'),
(66, 23, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:46:01'),
(67, 24, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:46:03'),
(68, 25, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:46:06'),
(69, 26, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:46:09'),
(70, 27, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:46:11'),
(71, 28, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:46:14'),
(72, 29, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:46:18'),
(73, 30, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:46:20'),
(74, 31, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:46:22'),
(75, 32, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:46:24'),
(76, 33, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:46:29'),
(77, 34, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:46:31'),
(78, 35, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:46:34'),
(79, 36, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:46:36'),
(85, 42, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:47:03'),
(88, 54, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:47:12'),
(89, 57, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:47:16'),
(90, 75, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:47:19'),
(91, 93, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:47:21'),
(93, 120, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:47:26'),
(95, 122, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:47:33'),
(97, 124, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:47:37'),
(100, 127, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:47:45'),
(102, 130, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:47:50'),
(105, 134, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:47:59'),
(106, 135, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:48:01'),
(107, 136, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:48:03'),
(108, 137, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:48:06'),
(109, 138, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:48:08'),
(110, 139, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:48:11'),
(111, 140, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:48:14'),
(112, 140, 'add', 100, 100, 200, 'Stock update', NULL, '2025-03-16 04:49:24'),
(113, 141, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:49:26'),
(114, 142, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:49:28'),
(115, 143, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:49:32'),
(116, 144, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:49:34'),
(117, 145, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:49:37'),
(118, 146, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:49:39'),
(119, 147, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:49:42'),
(120, 148, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:49:44'),
(121, 150, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:49:46'),
(122, 152, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:49:49'),
(123, 153, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:49:51'),
(124, 154, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:49:53'),
(125, 155, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:49:57'),
(126, 156, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:49:59'),
(127, 157, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:50:02'),
(128, 158, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:50:05'),
(129, 159, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:50:07'),
(130, 160, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:50:09'),
(131, 161, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:50:12'),
(132, 162, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:50:14'),
(133, 163, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:50:17'),
(134, 164, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 04:50:21'),
(137, 10, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-16 04:50:53'),
(138, 10, 'subtract', 1, 99, 98, 'Stock update', NULL, '2025-03-16 04:50:54'),
(139, 9, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-16 04:51:29'),
(140, 11, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-16 04:51:29'),
(141, 12, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-16 04:51:29'),
(142, 150, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-16 04:51:29'),
(143, 168, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 06:55:07'),
(144, 162, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-16 07:01:37'),
(145, 168, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-16 07:01:37'),
(146, 169, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 07:01:49'),
(147, 170, 'add', 20, 0, 20, 'Stock update', NULL, '2025-03-16 07:04:37'),
(148, 150, 'subtract', 1, 99, 98, 'Stock update', NULL, '2025-03-16 07:32:15'),
(149, 150, 'subtract', 1, 98, 97, 'Stock update', NULL, '2025-03-16 07:32:17'),
(150, 75, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-16 07:32:18'),
(151, 9, 'subtract', 1, 99, 98, 'Stock update', NULL, '2025-03-16 07:49:17'),
(152, 75, 'subtract', 1, 99, 98, 'Stock update', NULL, '2025-03-16 07:52:02'),
(153, 170, 'subtract', 1, 20, 19, 'Stock update', NULL, '2025-03-16 07:52:02'),
(154, 11, 'subtract', 1, 99, 98, 'Stock update', NULL, '2025-03-16 07:52:02'),
(155, 11, 'subtract', 1, 98, 97, 'Stock update', NULL, '2025-03-16 07:53:31'),
(156, 10, 'subtract', 2, 98, 96, 'Stock update', NULL, '2025-03-16 07:53:31'),
(157, 10, 'subtract', 1, 96, 95, 'Stock update', NULL, '2025-03-16 07:56:40'),
(158, 11, 'subtract', 1, 97, 96, 'Stock update', NULL, '2025-03-16 07:58:09'),
(159, 21, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-16 07:58:09'),
(160, 17, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-16 07:58:09'),
(161, 16, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-16 07:58:09'),
(162, 20, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-16 07:58:09'),
(163, 12, 'subtract', 1, 99, 98, 'Stock update', NULL, '2025-03-16 07:58:09'),
(164, 13, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-16 07:58:09'),
(165, 14, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-16 07:58:09'),
(166, 18, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-16 07:58:09'),
(167, 19, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-16 07:58:09'),
(168, 11, 'subtract', 1, 96, 95, 'Stock update', NULL, '2025-03-16 08:02:59'),
(169, 11, 'subtract', 1, 95, 94, 'Stock update', NULL, '2025-03-16 08:03:50'),
(170, 9, 'subtract', 1, 98, 97, 'Stock update', NULL, '2025-03-16 13:58:58'),
(171, 170, 'subtract', 1, 19, 18, 'Stock update', NULL, '2025-03-16 13:59:55'),
(172, 169, 'subtract', 2, 100, 98, 'Stock update', NULL, '2025-03-16 14:47:06'),
(173, 171, 'add', 100, 0, 100, 'Stock update', NULL, '2025-03-16 14:51:32'),
(174, 170, 'subtract', 17, 18, 1, 'Stock update', NULL, '2025-03-17 04:42:42'),
(177, 170, 'subtract', 1, 1, 0, 'Stock update', NULL, '2025-03-17 04:48:38'),
(178, 170, 'add', 4, 0, 4, 'Stock update', NULL, '2025-03-17 04:53:16'),
(179, 170, 'subtract', 2, 4, 2, 'Stock update', NULL, '2025-03-17 04:55:07'),
(180, 75, 'subtract', 1, 98, 97, 'Stock update', NULL, '2025-03-17 04:55:07'),
(181, 150, 'subtract', 1, 97, 96, 'Stock update', NULL, '2025-03-17 04:55:07'),
(182, 163, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-17 04:55:07'),
(183, 162, 'subtract', 1, 99, 98, 'Stock update', NULL, '2025-03-17 04:55:07'),
(184, 164, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-17 04:55:07'),
(185, 157, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-17 04:55:07'),
(186, 152, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-17 04:55:07'),
(187, 154, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-17 04:55:07'),
(188, 153, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-17 04:55:07'),
(189, 155, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-17 04:55:07'),
(190, 160, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-17 04:55:07'),
(191, 156, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-17 04:55:07'),
(192, 159, 'subtract', 1, 100, 99, 'Stock update', NULL, '2025-03-17 04:55:07'),
(193, 170, 'add', 5, 2, 7, 'Stock update', NULL, '2025-03-17 05:05:40'),
(194, 153, 'subtract', 1, 99, 98, 'Stock update', NULL, '2025-03-17 05:07:09'),
(195, 170, 'subtract', 1, 7, 6, 'Stock update', NULL, '2025-03-17 05:08:23'),
(196, 170, 'subtract', 1, 6, 5, 'Stock update', NULL, '2025-03-17 05:10:51'),
(197, 170, 'subtract', 5, 5, 0, 'Stock update', NULL, '2025-03-17 05:11:04'),
(198, 170, 'add', 9999, 0, 9999, 'Stock update', NULL, '2025-03-17 05:11:17'),
(199, 170, 'subtract', 1, 9999, 9998, 'Stock update', NULL, '2025-03-17 05:11:45'),
(200, 170, 'subtract', 9996, 9998, 2, 'Stock update', NULL, '2025-03-17 05:13:55'),
(201, 170, 'subtract', 2, 2, 0, 'Stock update', NULL, '2025-03-17 05:13:59'),
(202, 170, 'add', 999999, 0, 999999, 'Stock update', NULL, '2025-03-17 05:14:07'),
(203, 152, 'subtract', 99, 99, 0, 'Stock update', NULL, '2025-03-17 05:15:16'),
(204, 172, 'add', 20, 0, 20, 'Stock update', NULL, '2025-03-17 05:19:04'),
(205, 172, 'subtract', 1, 20, 19, 'Stock update', NULL, '2025-03-17 05:21:19'),
(206, 152, 'add', 999999, 0, 999999, 'Stock update', NULL, '2025-03-17 05:22:07'),
(207, 8, 'subtract', 99, 100, 1, 'Stock update', NULL, '2025-03-17 05:22:37'),
(208, 8, 'add', 999998, 1, 999999, 'Stock update', NULL, '2025-03-17 05:22:43'),
(209, 172, 'subtract', 1, 19, 18, 'Stock update', NULL, '2025-03-17 05:22:48'),
(210, 172, 'subtract', 1, 18, 17, 'Stock update', NULL, '2025-03-17 05:35:24'),
(211, 172, 'subtract', 1, 17, 16, 'Stock update', NULL, '2025-03-17 05:38:16'),
(212, 172, 'subtract', 16, 16, 0, 'Stock update', NULL, '2025-03-17 05:38:43'),
(213, 172, 'add', 999999, 0, 999999, 'Stock update', NULL, '2025-03-17 05:38:50'),
(214, 172, 'add', 20, 999999, 1000019, 'Stock update', NULL, '2025-03-17 05:39:00'),
(215, 172, 'add', 16, 1000019, 1000035, 'Stock update', NULL, '2025-03-17 05:39:10'),
(216, 172, 'subtract', 1000035, 1000035, 0, 'Stock update', NULL, '2025-03-17 05:39:14'),
(217, 172, 'add', 10, 0, 10, 'Stock update', NULL, '2025-03-17 05:39:20'),
(218, 172, 'add', 999989, 10, 999999, 'Stock update', NULL, '2025-03-17 05:39:23'),
(219, 172, 'subtract', 1, 999999, 999998, 'Stock update', NULL, '2025-03-17 05:40:35'),
(220, 8, 'add', 10, 999999, 1000009, 'Stock update', NULL, '2025-03-17 06:45:42'),
(221, 8, 'subtract', 1000009, 1000009, 0, 'Stock update', NULL, '2025-03-17 06:45:46'),
(222, 8, 'add', 999999, 0, 999999, 'Stock update', NULL, '2025-03-17 06:45:51'),
(223, 8, 'subtract', 999999, 999999, 0, 'Stock update', NULL, '2025-03-17 06:45:54'),
(224, 8, 'add', 10, 0, 10, 'Stock update', NULL, '2025-03-17 06:45:57'),
(225, 8, 'add', 999989, 10, 999999, 'Stock update', NULL, '2025-03-17 06:46:02'),
(226, 173, 'add', 30, 0, 30, 'Stock update', NULL, '2025-03-17 07:02:57'),
(227, 173, 'subtract', 9, 30, 21, 'Stock update', NULL, '2025-03-17 07:03:44'),
(228, 8, 'subtract', 999999, 999999, 0, 'Stock update', NULL, '2025-03-17 12:47:11'),
(229, 8, 'add', 999999, 0, 999999, 'Stock update', NULL, '2025-03-17 12:47:14'),
(230, 8, 'subtract', 999999, 999999, 0, 'Stock update', NULL, '2025-03-17 12:47:21'),
(231, 8, 'add', 999999, 0, 999999, 'Stock update', NULL, '2025-03-17 12:47:25'),
(232, 236, 'add', 999999, 0, 999999, 'Stock update', NULL, '2025-03-17 16:25:11'),
(233, 237, 'add', 999999, 0, 999999, 'Stock update', NULL, '2025-03-17 16:25:15'),
(234, 238, 'add', 999999, 0, 999999, 'Stock update', NULL, '2025-03-17 16:25:20'),
(235, 239, 'add', 999999, 0, 999999, 'Stock update', NULL, '2025-03-17 16:25:23'),
(236, 9, 'subtract', 97, 97, 0, 'Stock update', NULL, '2025-03-17 16:26:12'),
(237, 10, 'subtract', 95, 95, 0, 'Stock update', NULL, '2025-03-17 16:26:30'),
(238, 152, 'subtract', 999999, 999999, 0, 'Stock update', NULL, '2025-03-18 02:08:41');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `course` varchar(255) NOT NULL,
  `gender` varchar(50) NOT NULL,
  `avatar` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `username`, `course`, `gender`, `avatar`) VALUES
(78, 'mlapating_220000001421@uic.edu.ph', '$2b$12$MVxLmcCRoLSkV3VTfX2hE.ta9YvC35G6i0Xj20CU2JMc3L6Dgejyq', 'Lors', 'BSIT-3A', 'Male', '/uploads/avatars/mlapating_220000001421@uic.edu.ph_zoro.jpg'),
(79, 'pbolinquit_220000001421@uic.edu.ph', '$2b$12$.4.Tg3VfADSSZYVikUU7gu70RyojOq.issmnp100QH.x98fAvbof2', 'Princess', 'BSCS', 'Female', '/uploads/avatars/pbolinquit_220000001421@uic.edu.ph_robin san.jpg'),
(80, 'malapating_220000001421@uic.edu.ph', '$2b$12$uAQ9HbzYTY0qwVypHVg4UePW168Qzy5gqs0k/KycHPLLrwiWDF95e', 'Lorsss', '', '', ''),
(81, 'mlapating@uic.edu.ph', '$2b$12$u4u/mnJhjjiWkmGxROzmAOym4LOFB7mQKpNycs.HtBVyg2Y4NSI3G', 'Lorskie', '', '', '/uploads/avatars/mlapating@uic.edu.ph_garp.jpg'),
(82, 'mlapatin_220000001421@uic.edu.ph', '$2b$12$24J/Rb5agdlL5XrRqGFivO7B23A2IVK0VKUOXwskiCZkrveNH4cdq', 'Lors11', 'BSBA', 'Other', '/uploads/avatars/mlapatin_220000001421@uic.edu.ph_garp.jpg'),
(83, 'choco_220000001421@uic.edu.ph', '$2b$12$07/21pGASo0yUoe9NCDGEOWUBLeylAsTw8ysLfIFfGImJgCwIXrPO', 'choco', '', '', '/uploads/avatars/choco_220000001421@uic.edu.ph_sanji.jpg'),
(84, 'mlapatings_220000001421@uic.edu.ph', '$2b$12$zGj3FKFOV62gdaEtohTot.b6WvBrLZkvm9eqY5JOIazu1HrGnHhYG', 'Lorskiee', '', '', ''),
(85, 'mlapatingaa_220000001421@uic.edu.ph', '$2b$12$sq4tLjAznqrVrlIEnQZ8s.nmGeozYBdi7FPBw3M3h28FBfZ0tWd7m', '2321312', '', '', ''),
(86, 'mlapatingqw_220000001421@uic.edu.ph', '$2b$12$vb9LfCFNc/pid3KwipxgweQz2o//NGw2DceJnsjAcktrYJ6ZK3BBK', 'fert', '', '', '/uploads/avatars/mlapatingqw_220000001421@uic.edu.ph_default-avatar.png'),
(87, 'mlapatingw_220000001421@uic.edu.ph', '$2b$12$PgxJgF2mChdLO5eD9hUHBuI6QSwlXwhEM/cpOE1vXiCRK4EQJ1Wp.', 'Goku', '', '', '/uploads/avatars/mlapatingw_220000001421@uic.edu.ph_Ultra-Instinct-Dragon_Ball-goku.jpg'),
(88, 'mlapatingz_220000001421@uic.edu.ph', '$2b$12$bFpvr0CwPq/9rj1dEHEaeuRycJWkQlzFJY4Ey/x/1.mAPC9QBj1xq', 'Hero', '', '', ''),
(89, 'mlapatingff_220000001421@uic.edu.ph', '$2b$12$eozWuLFLhi.5FIqrZRiXK.Y.Iuzb9URterpbAS4HSTn5eFrk.G43y', 'f', '', '', '/uploads/avatars/mlapatingff_220000001421@uic.edu.ph_zoro san.jpg'),
(90, 'mlapating1_220000001421@uic.edu.ph', '$2b$12$/8cShikpGs4n3QyZU0WnRuCVT7djypeyndGz3OMOBX3EQ33YAy1C2', 'Lorsss1s', '', '', ''),
(91, 'mlapating111_220000001421@uic.edu.ph', '$2b$12$c846HOfw8F1D9qllm43TcOSrnEMPE4orFFy3me8Dl.Jktxg76hQF.', 'dsd', '', '', ''),
(92, 'akosilors@uic.edu.ph', '$2b$12$WBtNlxqg3kq9d86B4I0ySuHggCavEljSHVqTyYsPI6N9612EA3MSa', 'Ako si lors', '', '', ''),
(93, 'fert@uic.edu.ph', '$2b$12$aaJBuITuUEN/HR0VKCLcpOOmHbBX9wYTQlfVoT7nW2Ge/Uv1JsH2y', 'ferty', '', '', '/uploads/avatars/fert@uic.edu.ph_robin san.jpg'),
(94, 'laurence@uic.edu.ph', '$2b$12$o3kSkeXFGv3pr090y1R75uokYk0eagvlOji2JbMwaRtDIRehz6uHW', 'Lor.', '', '', ''),
(95, 'ako13@uic.edu.ph', '$2b$12$eVr2dNJzeSHAKXV67vg4duPrOJmgTwU0KpnfjGM7iKghfPmtaZSJO', 'ako', '', '', ''),
(96, 'akoto@uic.edu.ph', '$2b$12$VJdcD9o2oESjYg6gL12jb.6EOjqtv94un/sR7FDerOfljPE/YC6W6', 'akoto', '', '', ''),
(97, 'cess@uic.edu.ph', '$2b$12$OFPD.h8xqGUFMoM3wrEVcer.WeK.gpD.NK6uGH8mxTBt1F1EvZ0xG', 'Cess', '', '', ''),
(98, 'lorskie@uic.edu.ph', '$2b$12$2wQ3qKrDqw/eFU50PUWXgeoExZ5mFclzC6JS1IfZUbS9MDJGyHNS2', 'lorskieee', '', '', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `item_stocks`
--
ALTER TABLE `item_stocks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_order_customer` (`id`,`customer_name`);

--
-- Indexes for table `stock_alerts`
--
ALTER TABLE `stock_alerts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `stock_transactions`
--
ALTER TABLE `stock_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=240;

--
-- AUTO_INCREMENT for table `item_stocks`
--
ALTER TABLE `item_stocks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=386;

--
-- AUTO_INCREMENT for table `stock_alerts`
--
ALTER TABLE `stock_alerts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `stock_transactions`
--
ALTER TABLE `stock_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=239;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=99;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `item_stocks`
--
ALTER TABLE `item_stocks`
  ADD CONSTRAINT `item_stocks_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `stock_alerts`
--
ALTER TABLE `stock_alerts`
  ADD CONSTRAINT `stock_alerts_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `stock_transactions`
--
ALTER TABLE `stock_transactions`
  ADD CONSTRAINT `stock_transactions_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
