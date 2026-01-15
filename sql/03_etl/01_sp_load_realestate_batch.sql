/* =========================================================
   File   : sql/03_etl/01_sp_load_realestate_batch.sql
   Object : sp_load_realestate_batch
   Purpose: Orchestrate batch load (raw -> stg -> dims -> fact)
   Notes  : Company-style export (no DEFINER; portable)
   ========================================================= */
USE saudi_real_state_dw;

DROP PROCEDURE IF EXISTS sp_load_realestate_batch;

DELIMITER $$
CREATE PROCEDURE `sp_load_realestate_batch`(IN p_batch_id BIGINT)
BEGIN
  DECLARE v_missing_location BIGINT DEFAULT 0;
  DECLARE v_missing_property BIGINT DEFAULT 0;
  DECLARE v_missing_date     BIGINT DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    UPDATE etl_load_batch
    SET notes = CONCAT('FAILED at ', NOW()),
        row_count = NULL
    WHERE batch_id = p_batch_id;
  END;

  START TRANSACTION;

  -- 1) تنظيف إعادة التشغيل
  DELETE FROM fact_deals WHERE batch_id = p_batch_id;
  DELETE FROM stg_deals  WHERE batch_id = p_batch_id;

  -- 2) إدخال STG من RAW (لاحظ: INSERT ثم WITH)
  INSERT INTO stg_deals
  (batch_id, deal_ref_no, region, city, district, deal_date, deal_date_hijri,
   property_class, property_type, property_count, price, area, price_per_sqm)
  WITH cleaned AS (
    SELECT
      r.batch_id,
      NULLIF(TRIM(r.deal_ref_no),'') AS deal_ref_no,

      NULLIF(TRIM(r.region),'') AS region,
      NULLIF(TRIM(r.city),'')   AS city,

      CASE
        WHEN NULLIF(TRIM(r.district),'') IS NULL THEN NULL
        WHEN TRIM(r.district) LIKE '%/%' THEN NULLIF(TRIM(SUBSTRING_INDEX(r.district,'/',-1)),'')
        ELSE NULLIF(TRIM(r.district),'')
      END AS district,

      CASE
        WHEN NULLIF(TRIM(r.deal_date),'') IS NULL THEN NULL
        WHEN TRIM(r.deal_date) LIKE '%/%/%' THEN STR_TO_DATE(TRIM(r.deal_date),'%Y/%c/%e') 
        ELSE NULL
      END AS deal_date,

      NULLIF(TRIM(r.deal_date_hijri),'') AS deal_date_hijri,

      NULLIF(TRIM(r.property_class),'') AS property_class,
      NULLIF(TRIM(r.property_type),'')  AS property_type,

      CAST(NULLIF(TRIM(r.property_count),'') AS UNSIGNED) AS property_count,

      CAST(NULLIF(REPLACE(TRIM(r.price),',',''),'') AS DECIMAL(18,6)) AS price,
      CAST(NULLIF(REPLACE(TRIM(r.area), ',', ''),'') AS DECIMAL(18,6)) AS area
    FROM _raw_deals r
    WHERE r.batch_id = p_batch_id
      AND NULLIF(TRIM(r.deal_ref_no),'') IS NOT NULL
  )
  SELECT
    batch_id, deal_ref_no, region, city, district, deal_date, deal_date_hijri,
    property_class, property_type, property_count, price, area,
    ROUND(price / NULLIF(area,0), 6) AS price_per_sqm
  FROM cleaned;

  -- 3) Upsert dims
  INSERT INTO dim_location(region, city, district)
  SELECT DISTINCT TRIM(region), TRIM(city), TRIM(district)
  FROM stg_deals
  WHERE batch_id = p_batch_id
    AND NULLIF(TRIM(region),'')   IS NOT NULL
    AND NULLIF(TRIM(city),'')     IS NOT NULL
    AND NULLIF(TRIM(district),'') IS NOT NULL
  ON DUPLICATE KEY UPDATE location_id = location_id;

  INSERT INTO dim_property(property_class, property_type)
  SELECT DISTINCT TRIM(property_class), TRIM(property_type)
  FROM stg_deals
  WHERE batch_id = p_batch_id
    AND NULLIF(TRIM(property_class),'') IS NOT NULL
    AND NULLIF(TRIM(property_type),'')  IS NOT NULL
  ON DUPLICATE KEY UPDATE property_id = property_id;

  -- 4) QC
  SELECT
    SUM(l.location_id IS NULL),
    SUM(p.property_id IS NULL),
    SUM(d.date_id IS NULL)
  INTO v_missing_location, v_missing_property, v_missing_date
  FROM stg_deals s
  LEFT JOIN dim_location l
    ON l.region = TRIM(s.region) AND l.city = TRIM(s.city) AND l.district = TRIM(s.district)
  LEFT JOIN dim_property p
    ON p.property_class = TRIM(s.property_class) AND p.property_type = TRIM(s.property_type)
  LEFT JOIN dim_date d
    ON d.full_date = s.deal_date
  WHERE s.batch_id = p_batch_id;

  IF v_missing_location > 0 OR v_missing_property > 0 OR v_missing_date > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'QC FAILED: Missing dimension keys (location/property/date)';
  END IF;

  -- 5) Load Fact
  INSERT INTO fact_deals
  (batch_id, deal_ref_no, location_id, property_id, date_id, price, area, property_count, price_per_sqm)
  SELECT
    s.batch_id,
    s.deal_ref_no,
    l.location_id,
    p.property_id,
    d.date_id,
    s.price,
    s.area,
    s.property_count,
    s.price_per_sqm
  FROM stg_deals s
  JOIN dim_location l
    ON l.region = TRIM(s.region) AND l.city = TRIM(s.city) AND l.district = TRIM(s.district)
  JOIN dim_property p
    ON p.property_class = TRIM(s.property_class) AND p.property_type = TRIM(s.property_type)
  JOIN dim_date d
    ON d.full_date = s.deal_date
  WHERE s.batch_id = p_batch_id;

  -- 6) close batch
  UPDATE etl_load_batch
   SET notes = CONCAT(
      'SUCCESS at ', NOW(),
      ' | stg=', (SELECT COUNT(*) FROM stg_deals  WHERE batch_id=p_batch_id),
      ' | fact=',(SELECT COUNT(*) FROM fact_deals WHERE batch_id=p_batch_id)
    )
   WHERE batch_id = p_batch_id;
   
  
    
  COMMIT;
END$$
DELIMITER ;
