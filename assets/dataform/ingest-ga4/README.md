# ingest-ga4 · SQL/Schema artifacts

Copias sanitizadas de los schemas del repo `nelsonacosta-ob-ingest-ga4` (rama `develop`).

## Archivos

| Archivo                          | Origen (GitLab)                           | Propósito                                                   |
|----------------------------------|-------------------------------------------|-------------------------------------------------------------|
| `biglake_table.json`             | `schemas/biglake_table.json`              | Schema BigLake de 100 columnas GA4 sobre el processed bucket |
| `completion_topic_schema.avsc`   | `schemas/completion_topic_schema.avsc`    | Avro schema del topic Pub/Sub de quality-gate               |

**No hay SQL en este repo** — la lógica de transformación vive en el módulo `cosmos.pipelines.ingestion`
(cosmos-pipelines) que se importa desde `process_file.py` / `process_file_router.py`. Este servicio
sólo orquesta lectura + schema application + escritura Parquet particionada.

## Fuente autoritativa GitLab (rama `develop`)

- https://gitlab.com/latamairlines/data/shared-services/cross/nelsonacosta-ob/nelsonacosta-ob-ingest-ga4/-/blob/develop/schemas/biglake_table.json
- https://gitlab.com/latamairlines/data/shared-services/cross/nelsonacosta-ob/nelsonacosta-ob-ingest-ga4/-/blob/develop/schemas/completion_topic_schema.avsc
