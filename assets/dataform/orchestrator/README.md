# orchestrator — Dataform assets

**No hay `.sqlx` propios en `develop` de este repo.**

## Por qué

`orchestrator-ob` es el **scaffold Dataform** del Booster: define el proyecto Dataform (`workflow_settings.yaml`), las constantes de entorno (`includes/constants.js`), los policy tags de dev (`includes/policy_tags/dev_policy_tags.js`) y la infra Terraform que crea el repo Dataform en GCP + los workflows configs.

El árbol `definitions/` en `develop` contiene solo archivos `.keep` — es el ganchito estructural, no hay transformaciones SQL productivas ahí.

Las transformaciones SQL reales del hands-on viven en:

- `ml-propension/assets/training/get_on_boarding_master.sql` — training set (LIMIT 100000)
- `ml-propension/assets/inference/get_on_boarding_master.sql` — inference set (sin LIMIT)
- `ml-propension/assets/get_backtest_dataset.sql` — JOIN predictions × ground_truth

Ver `../ml-propension/` en este mismo repo para las versiones sanitizadas.

## Fuente autoritativa

- `orchestrator-ob` en GitLab LATAM: `latamairlines/data/shared-services/cross/nelsonacosta-ob/orchestrator-ob`
- Rama de trabajo: `develop`
- Path del scaffold Dataform: `definitions/` (vacío en el hands-on)
- Config Dataform: `workflow_settings.yaml` en la raíz

## Cuándo se llenan `definitions/`

Cuando un caso de uso concreto necesita transformaciones propias del orchestrator (no del ML). En el hands-on de propensión ese caso no se dio: el ML tiene sus queries y el orchestrator se limita a levantar la infra Dataform.
