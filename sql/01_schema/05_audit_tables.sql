/* =========================================================
   File   : sql/01_schema/05_audit_tables.sql
   Objects: etl_load_batch
   Purpose: Audit table to track batch loads
   Notes  : DDL extracted from existing DB; cleaned for repo use
   ========================================================= */

USE saudi_real_state_dw;

CREATE TABLE `etl_load_batch` (
  `batch_id` bigint NOT NULL AUTO_INCREMENT,
  `source_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `source_period` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `loaded_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `row_count` int DEFAULT NULL,
  `notes` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
