/* =========================================================
   File   : sql/06_performance/02_constraints.sql
   Purpose: Add foreign key constraints after all tables exist
   Notes  : Run AFTER sql/01_schema/*
           : If this fails, you have referential issues to fix
   ========================================================= */

USE saudi_real_state_dw;

SET FOREIGN_KEY_CHECKS = 0;

ALTER TABLE `_raw_deals`
  ADD CONSTRAINT `fk_raw_batch`
  FOREIGN KEY (`batch_id`) REFERENCES `etl_load_batch` (`batch_id`)
  ON UPDATE RESTRICT
  ON DELETE RESTRICT;

ALTER TABLE `fact_deals`
  ADD CONSTRAINT `fk_fact_date`
  FOREIGN KEY (`date_id`) REFERENCES `dim_date` (`date_id`)
  ON UPDATE RESTRICT
  ON DELETE RESTRICT;

ALTER TABLE `fact_deals`
  ADD CONSTRAINT `fk_fact_location`
  FOREIGN KEY (`location_id`) REFERENCES `dim_location` (`location_id`)
  ON UPDATE RESTRICT
  ON DELETE RESTRICT;

ALTER TABLE `fact_deals`
  ADD CONSTRAINT `fk_fact_property`
  FOREIGN KEY (`property_id`) REFERENCES `dim_property` (`property_id`)
  ON UPDATE RESTRICT
  ON DELETE RESTRICT;

SET FOREIGN_KEY_CHECKS = 1;
