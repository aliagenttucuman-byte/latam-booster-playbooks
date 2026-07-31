WITH predictions AS (
    SELECT
        CUSTOMER_ID,
        snapshot_date,
        propension_pred
    FROM `{{ project }}.{{ predictions_dataset }}.predictions`
    WHERE snapshot_date BETWEEN
        DATE_SUB(DATE '2025-11-19', INTERVAL {{ backtest_window_months | default(3) }} MONTH)
        AND DATE '2025-11-19'
),

ground_truth AS (
    SELECT
        CUSTOMER_ID,
        snapshot_date,
        TARGET_3M
    FROM `ss-data-dev.nelsonacosta_ob_processed_feature_feature.development_workspace_hands_on_master_cl`
    WHERE TARGET_3M IS NOT NULL
)

SELECT
    p.CUSTOMER_ID,
    p.snapshot_date,
    p.propension_pred,
    g.TARGET_3M
FROM predictions p
INNER JOIN ground_truth g
    ON p.CUSTOMER_ID = g.CUSTOMER_ID
    AND p.snapshot_date = g.snapshot_date