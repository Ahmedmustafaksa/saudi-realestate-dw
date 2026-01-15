/* =========================================================
   File   : sql/01_schema/02_staging_tables.sql
   Objects: stg_deals
   Purpose: Staging (cleaned/typed) layer
   Notes  : DDL extracted from existing DB; cleaned for repo use
   ========================================================= */

USE saudi_real_state_dw;

CREATE TABLE `stg_deals` (
  `batch_id` bigint NOT NULL,
  `region` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `city` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `district` varchar(250) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `deal_ref_no` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `deal_date` date DEFAULT NULL,
  `deal_date_hijri` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `property_class` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `property_type` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `property_count` bigint unsigned DEFAULT NULL,
  `price` decimal(24,6) DEFAULT NULL,
  `area` decimal(24,6) DEFAULT NULL,
  `price_per_sqm` decimal(24,6) DEFAULT NULL,
  UNIQUE KEY `uk_stg_deals_batch_ref` (`batch_id`,`deal_ref_no`),
  KEY `ix_stg_location` (`region`,`city`,`district`),
  KEY `ix_stg_prop` (`property_class`,`property_type`),
  KEY `ix_stg_date` (`deal_date`),
  KEY `ix_stg_ref` (`deal_ref_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
