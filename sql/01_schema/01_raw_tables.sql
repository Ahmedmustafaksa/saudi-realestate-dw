/* =========================================================
   File   : sql/01_schema/01_raw_tables.sql
   Objects: _raw_deals
   Purpose: Raw landing table (source-as-is)
   Notes  : DDL extracted from existing DB; cleaned for repo use
   ========================================================= */

USE saudi_real_state_dw;

CREATE TABLE `_raw_deals` (
  `raw_id` bigint NOT NULL AUTO_INCREMENT,
  `batch_id` bigint NOT NULL,
  `source_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `source_period` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `loaded_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `region` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `city` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `district` varchar(250) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `deal_ref_no` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `deal_date` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `deal_date_hijri` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `property_class` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `property_type` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `property_count` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `price` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `area` varchar(60) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `plan_no` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `parcel_no` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `source_price_per_sqm` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`raw_id`),
  UNIQUE KEY `uk_batch_ref` (`batch_id`,`deal_ref_no`),
  KEY `idx_raw_dealref` (`deal_ref_no`),
  KEY `idx_raw_loc` (`region`,`city`,`district`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
