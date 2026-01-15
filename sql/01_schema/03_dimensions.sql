/* =========================================================
   File   : sql/01_schema/03_dimensions.sql
   Objects: dim_date, dim_location, dim_property
   Purpose: Dimensions for analytics model
   Notes  : DDL extracted from existing DB; cleaned for repo use
   ========================================================= */

USE saudi_real_state_dw;

CREATE TABLE `dim_date` (
  `date_id` int NOT NULL,
  `full_date` date NOT NULL,
  `year` smallint NOT NULL,
  `quarter` tinyint NOT NULL,
  `month` tinyint NOT NULL,
  `month_name` varchar(25) COLLATE utf8mb4_general_ci NOT NULL,
  `day` tinyint NOT NULL,
  `day_name` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `week_of_year` tinyint NOT NULL,
  `is_weekend` tinyint NOT NULL,
  `hijri_date_str` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`date_id`),
  UNIQUE KEY `uk_dim_date` (`full_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `dim_location` (
  `location_id` bigint NOT NULL AUTO_INCREMENT,
  `region` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `city` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `district` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`location_id`),
  UNIQUE KEY `uk_location` (`region`,`city`,`district`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `dim_property` (
  `property_id` bigint NOT NULL AUTO_INCREMENT,
  `property_class` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `property_type` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`property_id`),
  UNIQUE KEY `uk_property` (`property_class`,`property_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
