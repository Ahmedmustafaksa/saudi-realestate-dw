/* =========================================================
   File   : sql/01_schema/04_fact.sql
   Objects: fact_deals
   Purpose: Fact table for deals (FKs added later)
   Notes  : DDL extracted from existing DB; cleaned for repo use
   ========================================================= */

USE saudi_real_state_dw;

CREATE TABLE `fact_deals` (
  `fact_id` bigint NOT NULL AUTO_INCREMENT,
  `batch_id` bigint NOT NULL,
  `deal_ref_no` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `date_id` int NOT NULL,
  `location_id` bigint NOT NULL,
  `property_id` bigint NOT NULL,
  `property_count` bigint unsigned DEFAULT NULL,
  `price` decimal(18,6) DEFAULT NULL,
  `area` decimal(18,6) DEFAULT NULL,
  `price_per_sqm` decimal(18,6) DEFAULT NULL,
  PRIMARY KEY (`fact_id`),
  UNIQUE KEY `uk_fact_deal` (`batch_id`,`deal_ref_no`),
  KEY `ix_fact_date` (`date_id`),
  KEY `ix_fact_location` (`location_id`),
  KEY `ix_fact_property` (`property_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
