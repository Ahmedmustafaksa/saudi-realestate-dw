/* =========================================================
   File   : sql/00_bootstrap/00_create_database.sql
   Purpose: Create project database (initial setup)
   Notes  : Safe to re-run (IF NOT EXISTS)
   ========================================================= */

CREATE DATABASE IF NOT EXISTS saudi_real_state_dw
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE saudi_real_state_dw;
-- push test