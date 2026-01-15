/* =========================================================
   File   : sql/07_ops/00_reset_dev.sql
   Purpose: DEV reset (drop objects safely)
   WARNING: This DROPS tables/views/procs. Use only in DEV.
   ========================================================= */

USE saudi_real_state_dw;

SET FOREIGN_KEY_CHECKS = 0;

-- Drop views (add more as you create them)
DROP VIEW IF EXISTS vw_fact_deals_enriched;

-- Drop procedures
DROP PROCEDURE IF EXISTS sp_load_realestate_batch;

-- Drop tables (dependency order)
DROP TABLE IF EXISTS fact_deals;
DROP TABLE IF EXISTS stg_deals;

DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_property;
DROP TABLE IF EXISTS dim_location;

DROP TABLE IF EXISTS _raw_deals;
DROP TABLE IF EXISTS etl_load_batch;

-- Optional / temp objects
DROP TABLE IF EXISTS _raw_deals_fix_backup;

SET FOREIGN_KEY_CHECKS = 1;
