-- ============================================================================
-- export_propensity.sql
-- ----------------------------------------------------------------------------
-- Repo origen : latamairlines/data/shared-services/cross/nelsonacosta-ob/
--               nelsonacosta-ob-data-to-bucket (rama develop)
-- Path origen : assets/export_propensity.sql
-- Consumido por: cosmos.gcp.bigquery.bigquery_to_storage (Cloud Run Job)
-- Placeholders : {project} y {dataset} inyectados via query_args
-- Sanitización : ninguna requerida (query pura, sin PII)
-- ============================================================================

SELECT
  CONCAT(
    "Customer ", CAST(CUSTOMER_ID AS STRING),
    " has ",
    CASE
      WHEN PROPENSITY >= 0.7 THEN "ALTA"
      WHEN PROPENSITY >= 0.4 THEN "MEDIA"
      ELSE "BAJA"
    END,
    " propensity (",
    ROUND(PROPENSITY, 3), ") for period ", CAST(snapshot_date AS STRING),
    ". Last updated: ", FORMAT_TIMESTAMP('%Y-%m-%d %H:%M:%S', CURRENT_TIMESTAMP())
  ) AS content
FROM {project}.{dataset}.CUSTOMER_PREDICTIONS
