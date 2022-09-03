CREATE TABLE IF NOT EXISTS `esegovic_login` (
  `identifier` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `key` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
