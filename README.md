# Saudi Real Estate Deals DW (MySQL)

## Run order 

1. `sql/00_bootstrap/00_create_database.sql`
2. `sql/01_schema/05_audit_tables.sql`
3. `sql/01_schema/03_dimensions.sql`
4. `sql/01_schema/01_raw_tables.sql`
5. `sql/01_schema/02_staging_tables.sql`
6. `sql/01_schema/04_fact.sql`
7. `sql/03_etl/01_sp_load_realestate_batch.sql`
8. `sql/06_performance/02_constraints.sql`  (adds FKs)

> Use `sql/07_ops/00_reset_dev.sql` only for development resets.
> After running (1–8), you can load a batch: `CALL sp_load_realestate_batch(<batch_id>);`
