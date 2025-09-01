-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 01, 2025 at 04:24 PM
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
-- Database: `purplebug_olshop`
--

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_login_attempts`
--

CREATE TABLE `failed_login_attempts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `email` varchar(255) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `attempted_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `failed_login_attempts`
--

INSERT INTO `failed_login_attempts` (`id`, `email`, `ip_address`, `attempted_at`, `created_at`, `updated_at`) VALUES
(1, 'asdasda@asdac.om', '127.0.0.1', '2025-09-01 05:08:55', '2025-09-01 05:08:55', '2025-09-01 05:08:55');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_08_29_073224_create_personal_access_tokens_table', 1),
(5, '2025_08_31_133241_add_user_id_to_orders_table', 2),
(6, '2025_09_01_120748_create_failed_login_attempts_table', 3),
(7, '2025_09_01_125445_add_status_to_users_table', 4);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `customer_name` varchar(255) NOT NULL,
  `image` varchar(500) DEFAULT NULL,
  `product_name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `customer_name`, `image`, `product_name`, `price`, `stock`, `quantity`, `status`, `user_id`) VALUES
(1, 'Keith Lorenz Recede', 'asusa15.png', 'Asus Tuf A15 Gaming Laptop', 499.00, 70, 1, 'Canceled', NULL),
(2, 'Joseph Andrei Tallado', 'acerpred.jpg', 'Acer Predator Helios 300', 699.00, 3, 3, 'Canceled', NULL),
(3, 'Keith Lorenz Recede', 'tecno.jpg', 'Tecno Camon 20 Pro', 299.00, 25, 1, 'Pending', 4),
(4, 'Joseph Andrei Tallado', 'airpods2.jpg', 'Apple AirPods Pro', 50.00, 40, 1, 'Pending', 3);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'auth_token', '5acecf7475b5cb2086054c739cc6dcc7de7ac1c53c74826f5ec333756c22b199', '[\"*\"]', NULL, NULL, '2025-08-30 12:11:42', '2025-08-30 12:11:42'),
(2, 'App\\Models\\User', 1, 'auth_token', '5aa45c60e2f533620ea4d44d0c957371690c92a80e2c90538e7281d34e9e0993', '[\"*\"]', NULL, NULL, '2025-08-30 12:11:58', '2025-08-30 12:11:58'),
(3, 'App\\Models\\User', 2, 'auth_token', 'b57dcd80c25fe2f0d972329c9d72a44123c6129dace31f96d6acc2aa5ee21250', '[\"*\"]', NULL, NULL, '2025-08-30 13:23:35', '2025-08-30 13:23:35'),
(4, 'App\\Models\\User', 2, 'auth_token', '5d53424cb872155e08cc08a0d018e4a2348b40e00223f2bca48881a2ecd6e9fc', '[\"*\"]', NULL, NULL, '2025-08-30 13:23:48', '2025-08-30 13:23:48'),
(5, 'App\\Models\\User', 1, 'auth_token', '150cecde6d2950b77fa0e0ef530804e9b0e7f3efa39029949253e0dcc4572ec1', '[\"*\"]', NULL, NULL, '2025-08-30 13:24:12', '2025-08-30 13:24:12'),
(6, 'App\\Models\\User', 4, 'auth_token', 'cadefac5d5f6ae007f7c4ec58d0bf6f7abb3965540b25864584cf205b25ec580', '[\"*\"]', NULL, NULL, '2025-08-31 01:25:25', '2025-08-31 01:25:25'),
(7, 'App\\Models\\User', 4, 'auth_token', '8431223504d6b3be6dfdc4c2c7e7d72c8824308b6d07a76f444916fd3326f0af', '[\"*\"]', NULL, NULL, '2025-08-31 01:25:38', '2025-08-31 01:25:38'),
(8, 'App\\Models\\User', 1, 'auth_token', 'db94bf02fd8b3658f607ac030d9c666fb8ca485815749edd00e255d80f03bc29', '[\"*\"]', NULL, NULL, '2025-08-31 01:50:00', '2025-08-31 01:50:00'),
(9, 'App\\Models\\User', 4, 'auth_token', '61db57189f971bff9661df3f7f94899c781a989d184db42385f6b8e1953b9197', '[\"*\"]', NULL, NULL, '2025-08-31 03:50:39', '2025-08-31 03:50:39'),
(10, 'App\\Models\\User', 4, 'auth_token', 'c448a650a9874376ebcfcb1304b942900a0949f57364cd01471cf92598f9fa94', '[\"*\"]', NULL, NULL, '2025-08-31 03:55:06', '2025-08-31 03:55:06'),
(11, 'App\\Models\\User', 1, 'auth_token', '8562aa7427ee0b6b90796e02111daac70c44f90b6a2eb07c502c1400c2885586', '[\"*\"]', NULL, NULL, '2025-08-31 04:27:22', '2025-08-31 04:27:22'),
(12, 'App\\Models\\User', 1, 'auth_token', '3b69cf82ca425360d37e130f834c7a106bf5e1ed49459d12eecb064182276a15', '[\"*\"]', NULL, NULL, '2025-08-31 04:27:52', '2025-08-31 04:27:52'),
(13, 'App\\Models\\User', 1, 'auth_token', '1134ead498cb0417b838cb957b6014ce7864fec18b70348e9bff53b64714d725', '[\"*\"]', NULL, NULL, '2025-08-31 04:29:01', '2025-08-31 04:29:01'),
(14, 'App\\Models\\User', 4, 'auth_token', 'a776e58c3342d213f9d1a585d7f8833ad006dca612a0974babf56480757fa294', '[\"*\"]', NULL, NULL, '2025-08-31 05:06:58', '2025-08-31 05:06:58'),
(15, 'App\\Models\\User', 3, 'auth_token', '070347b174d93455eeb6762ce104e0d17ab226a8734cb5aed0e824825a3b91ef', '[\"*\"]', '2025-08-31 05:35:10', NULL, '2025-08-31 05:21:48', '2025-08-31 05:35:10'),
(16, 'App\\Models\\User', 4, 'auth_token', '148ca458320f5a787d753c97676703a1032be7c3bd3d1b02dfcbef3c5cd6e440', '[\"*\"]', '2025-08-31 05:35:45', NULL, '2025-08-31 05:35:24', '2025-08-31 05:35:45'),
(17, 'App\\Models\\User', 3, 'auth_token', '73639fe752b8128ee085d1812922dbdee78c850a4c01d0c7a188fed468ed0021', '[\"*\"]', '2025-08-31 05:36:21', NULL, '2025-08-31 05:36:05', '2025-08-31 05:36:21'),
(18, 'App\\Models\\User', 1, 'auth_token', 'f2bacf2bfc148c6dc0a308a8cbd621c0dd9792d263c387d626750dc65ba59437', '[\"*\"]', '2025-08-31 05:36:56', NULL, '2025-08-31 05:36:29', '2025-08-31 05:36:56'),
(19, 'App\\Models\\User', 1, 'auth_token', '51a51eeaca5122f13cc8979e2645db8e3228bae076ce41b21d712c8356d2c85a', '[\"*\"]', '2025-08-31 06:48:27', NULL, '2025-08-31 06:43:59', '2025-08-31 06:48:27'),
(20, 'App\\Models\\User', 1, 'auth_token', '27b5698dc1e653f278fcf04d859f257633c0aee2de974de48754578816c0b431', '[\"*\"]', '2025-08-31 06:48:43', NULL, '2025-08-31 06:48:40', '2025-08-31 06:48:43'),
(21, 'App\\Models\\User', 1, 'auth_token', '5ffb0e80bcfc0af202cb14282fe994edf4e8d11e423bea1b4dcbd5d1276e7c8b', '[\"*\"]', '2025-08-31 09:28:03', NULL, '2025-08-31 08:37:02', '2025-08-31 09:28:03'),
(22, 'App\\Models\\User', 1, 'auth_token', 'c26b9517ad29cdc2ee28aecc8a313208758978eef60450f0f08746706ced291f', '[\"*\"]', '2025-09-01 03:54:49', NULL, '2025-08-31 09:28:12', '2025-09-01 03:54:49'),
(23, 'App\\Models\\User', 1, 'auth_token', '3ae291afc9208293631f3392d32c996743c3e0d7c7efd52ca6db07cd3b30de4c', '[\"*\"]', '2025-09-01 03:58:06', NULL, '2025-09-01 03:55:08', '2025-09-01 03:58:06'),
(24, 'App\\Models\\User', 1, 'auth_token', 'c4dffd639168c930a69443187780a1e66fd9c0d429b3c465d2beaae39eaca0bb', '[\"*\"]', '2025-09-01 05:02:40', NULL, '2025-09-01 04:38:47', '2025-09-01 05:02:40'),
(25, 'App\\Models\\User', 5, 'auth_token', '08a4f47dec11cf8f919f5adde66e2bc03b48eb8aeb10a724b6f4db0abea489df', '[\"*\"]', '2025-09-01 05:02:58', NULL, '2025-09-01 05:02:53', '2025-09-01 05:02:58'),
(26, 'App\\Models\\User', 1, 'auth_token', 'a363e68a8796f8ae1cfced6a58026abdd8750c21aa490391b4a36374b787ae9b', '[\"*\"]', '2025-09-01 05:08:20', NULL, '2025-09-01 05:03:06', '2025-09-01 05:08:20'),
(27, 'App\\Models\\User', 1, 'auth_token', 'd7228b1d8333ff812c7b6c5d461c7e0e7d449f505301263f1474806be22820e8', '[\"*\"]', '2025-09-01 05:09:26', NULL, '2025-09-01 05:09:07', '2025-09-01 05:09:26'),
(28, 'App\\Models\\User', 1, 'auth_token', '11406d7ad200c7a544b6216233d5e951a61e43264169f8d680a33324b8960544', '[\"*\"]', '2025-09-01 05:59:04', NULL, '2025-09-01 05:47:38', '2025-09-01 05:59:04'),
(29, 'App\\Models\\User', 1, 'auth_token', 'c66e6de00b0b3c398ff1233c5adf69db42fc441383103ef51ad2bd3be137fc02', '[\"*\"]', '2025-09-01 06:18:32', NULL, '2025-09-01 06:18:24', '2025-09-01 06:18:32');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `stock` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `product_name`, `stock`, `price`, `category`, `image`, `created_at`, `updated_at`) VALUES
(1, 'Tecno Camon 20 Pro', 24, 299.00, 'Smartphones', 'tecno.jpg', '2025-08-31 10:40:55', '2025-08-31 05:35:42'),
(2, 'Apple iPhone 12', 40, 799.00, 'Smartphones', 'iphone12.jpg', '2025-08-31 10:40:55', NULL),
(3, 'Asus Tuf A15 Gaming Laptop', 69, 499.00, 'Laptops', 'asusa15.png', '2025-08-31 10:40:55', '2025-08-31 05:12:53'),
(4, 'Apple AirPods Pro', 39, 50.00, 'Audio', 'airpods2.jpg', '2025-08-31 10:40:55', '2025-08-31 05:36:18'),
(5, 'Acer Predator Helios 300', 1, 699.00, 'Laptops', 'acerpred.jpg', '2025-08-31 13:20:57', '2025-09-01 05:58:57');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `firstName` varchar(25) NOT NULL,
  `lastName` varchar(25) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `userType` varchar(255) DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `firstName`, `lastName`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `userType`, `status`) VALUES
(1, 'Kian Razen', 'Dimaano', 'kian@example.com', NULL, '$2y$12$nFYOktxPQD5Dx79UJkQ9Eu3VoAcYOfrYUSCKiqXzVQB5/uZNnvLHy', NULL, '2025-08-30 12:11:42', '2025-08-30 12:11:42', 'admin', 'active'),
(3, 'Joseph Andrei', 'Tallado', 'andrei@example.com', NULL, '$2y$12$kRo2k/fPOSHVX6hz3rSljeB8u9eRHpYgysIdflH4j.09IY9Ghmeei', NULL, '2025-08-30 15:23:58', '2025-08-30 15:27:25', 'guest', 'active'),
(4, 'Keith Lorenz', 'Recede', 'keith@example.com', NULL, '$2y$12$u/kmMn9SEHnitT.hpnYYPOsCjR0VKsqZGN/R58zdgaldQ41hw01cq', NULL, '2025-08-31 01:25:25', '2025-08-31 01:25:25', 'guest', 'active'),
(5, 'Prince Tyron', 'Lopez', 'prince@example.com', NULL, '$2y$12$H/g7mLdA91wipY1PkzsGu.Q3yCIhefa9ovhUqynVGyisBE.1fflMC', NULL, '2025-09-01 04:51:26', '2025-09-01 05:02:38', 'guest', 'inactive');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `failed_login_attempts`
--
ALTER TABLE `failed_login_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `failed_login_attempts_email_attempted_at_index` (`email`,`attempted_at`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `orders_user_id_foreign` (`user_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_login_attempts`
--
ALTER TABLE `failed_login_attempts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
