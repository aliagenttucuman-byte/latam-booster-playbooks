-- get_on_boarding_master.sql
-- Master query del training pipeline propensión LATAM.
-- Fuente: hands_on_master_cl.sqlx (Dataform) → 18.5M customers × 16 snapshots × 47 cols.
-- Positive rate validado 19.63% (17.7-20.8% por snapshot, sin drift).
-- 22-jul-2026 · Opción B (SELECT explícito).

SELECT
    -- Keys
    CUSTOMER_ID,
    snapshot_date,
    YM,

    -- Volumen tickets por región
    N_TICKETS_DOM,
    N_TICKETS_REG,
    N_TICKETS_LH,
    N_TICKETS_TOTAL,

    -- Fare avg por región
    FARE_AVG_DOM,
    FARE_AVG_REG,
    FARE_AVG_LH,

    -- Fare sum por región
    FARE_SUM_DOM,
    FARE_SUM_REG,
    FARE_SUM_LH,

    -- Fare family × región (7 familias × 3 regiones = 21 features)
    N_TICKETS_FARE_BASIC_DOM,
    N_TICKETS_FARE_BASIC_REG,
    N_TICKETS_FARE_BASIC_LH,
    N_TICKETS_FARE_LIGHT_DOM,
    N_TICKETS_FARE_LIGHT_REG,
    N_TICKETS_FARE_LIGHT_LH,
    N_TICKETS_FARE_PLUS_DOM,
    N_TICKETS_FARE_PLUS_REG,
    N_TICKETS_FARE_PLUS_LH,
    N_TICKETS_FARE_TOP_DOM,
    N_TICKETS_FARE_TOP_REG,
    N_TICKETS_FARE_TOP_LH,
    N_TICKETS_FARE_PREMIUM_DOM,
    N_TICKETS_FARE_PREMIUM_REG,
    N_TICKETS_FARE_PREMIUM_LH,

    -- Behavior
    ANTIQUITY_DAYS,
    AVG_DAYS_BUY_FLY,
    AVG_DAYS_ADV_PURCHASE,

    -- Digital (placeholders v1, resolver cuando se poblee GA4)
    N_SESSIONS_WEB,
    N_SESSIONS_APP,
    CONVERSION_WEB,
    CONVERSION_APP,

    -- Loyalty (placeholders v1)
    LOYALTY_PROGRAM,
    LOYALTY_CATEGORY,

    -- Demographics (placeholders v1)
    COUNTRY_RESIDENCE,
    GENDER,
    AGE,
    MARITAL_STATUS,

    -- Customer voice (placeholders v1)
    N_COMPLAINTS,
    N_SURVEYS,
    NPS_SCORE,

    -- Loyalty engagement (placeholders v1)
    N_UPGRADES,
    CANJE_POINTS,

    -- Target (ya viene calculado de Dataform)
    TARGET_3M

FROM `{project}.{dataset}.development_workspace_hands_on_master_cl`
WHERE TARGET_3M IS NOT NULL
