---
titulo: Glosario - Onboarding Booster LATAM Airlines
autor: Nelson Acosta
version: 1.0.0
last_validated: 2026-07-31
---

# Glosario

Terminos que aparecen en todos los playbooks. Si algo no lo entendes en un .md, buscalo aca primero.

Volver al [README](./00-README.md).

---

## Indice

- [Organizacional](#organizacional) - Booster, Buddy, CPM, Staff, ADO
- [Plataforma](#plataforma) - Cosmos, Backstage, Data Hub, Sandbox, BQO
- [Infraestructura](#infraestructura) - GCS, BQ, Vertex, Cloud Functions, Artifact Registry, Terraform
- [CI/CD](#cicd) - Pipeline, Stage, MR, Terraform apply policy, CODEOWNERS
- [GitLab](#gitlab) - Path canonico, PAT, Grupo raiz, ai-sharedservices
- [Modelo ML](#modelo-ml) - Propension, Master table, 6 fuentes, RFM, HUB, XGBoost, Stratify
- [GenAI](#genai) - LangGraph, Light RAG, GenAI Gateway, Chatbot GenAI
- [GCP](#gcp) - Project ID, us-east1, Service Account, IAM Bindings
- [Namespace ob](#namespace-ob) - Convencion de nombres de repos
- [Terraform apply policy](#terraform-apply-policy) - Reglas de plan vs apply
- [Errores clasicos](#errores-clasicos-busca-aca-antes-de-googlear)

---

## Organizacional

**Booster**. Rol de contratista externo (Globant, Neuralworks, Accenture) que se suma al squad de LATAM Airlines por 3-6 meses.

**Buddy / OnBuddy**. Booster senior asignado por RRHH para acompañar al Booster nuevo el primer mes. Mi Buddy fue Rudy (Neuralworks).

**BP (Business Partner)**. Responsable de RRHH del equipo. Para temas de HR, no tecnicos.

**CPM (Cloud Platform Management)**. Equipo interno LATAM que administra Cosmos, sandboxes, bundles y aprobaciones de infra base. Contacto principal: Diego.

**Staff**. Nivel de seniority. Staff Booster = Booster con capacidad de aprobar MRs de otros Boosters. En ADO: Diego, Rudy.

**Squad Data & AI Ops (ADO)**. Squad donde entra este hands-on. Sub-grupos: ADO Sales, ADO CPM, ADO ML.

---

## Plataforma

**Cosmos**. Framework interno LATAM para desarrollar productos de datos e IA. No es open source. Se compone de:
- **Bundle**: infra compartida por dominio (ai-sharedservices, adosales, etc.).
- **Product**: producto individual de un Booster (`nelsonacosta-ob`).
- **Modulos Terraform**: reusables (`gcs_bucket`, `bq_dataset`, `bq_table`, `vertex_pipeline`).

**Backstage**. Portal interno LATAM (fork de Spotify Backstage) para scaffoldear productos Cosmos, ver catalogo y templates.

**Data Hub**. Portal interno LATAM donde se piden sandboxes y acceso a fuentes de datos.

**Sandbox**. Ambiente GCP efimero (60 dias, no extendible) que se le asigna a cada Booster para el hands-on.

**BQO (BigQuery Operations)**. Capa de abstraccion Cosmos sobre BigQuery. Encapsula queries, schemas y jobs. Usado por `03-ml-propension` para construir la master table.

---

## Infraestructura

**GCS**. Google Cloud Storage. Buckets para artefactos de ML, logs de ingesta, etc.

**BQ**. BigQuery. Warehouse. Datasets y tablas.

**Vertex AI Pipelines**. Servicio GCP para orquestar pipelines de ML (KFP). Usado por `02-orchestrator`.

**Cloud Functions**. FaaS GCP. Usado por `04-data-to-bucket` para ingesta event-driven.

**Cloud Run**. Servicio serverless para containers. Usado por `06-chatbot-ob`.

**Artifact Registry**. Registry GCP para imagenes Docker y paquetes Python. Se espeja en Artifactory interno de LATAM.

**Terraform**. IaC oficial. Todos los repos tienen `infrastructure/*.tf`.

---

## CI/CD

**Pipeline**. En este contexto = GitLab CI/CD pipeline (no confundir con Vertex Pipeline). Definido en `.gitlab-ci.yml`.

**Stage**. Etapa del pipeline: `lint`, `test`, `plan`, `apply`, `deploy`.

**MR (Merge Request)**. Equivalente a Pull Request en GitHub. Reviewer aprueba, autor mergea.

**terraform plan / apply**. `plan` corre en branches (feature). `apply` solo en `develop` post-merge.

**CODEOWNERS**. Archivo `CODEOWNERS` en la raiz del repo. Define quien tiene que aprobar cada path.

---

## GitLab

**Path canonico repos**. `latamairlines/data/data-ai-ops/data-ops/shared-services/cross/nelsonacosta-ob/<repo>`.

**PAT (Personal Access Token)**. Token para llamar la API de GitLab. Legacy token con scope `read_api` es lo que funciona (no fine-grained).

**Grupo raiz**. `latamairlines` en gitlab.com. Bajo el hay 46 subgrupos y 2980 repos.

**ai-sharedservices**. Team group donde entran los Boosters de ML/GenAI. Alta via MR en `gitlab-group-management/gitlab-groups-members`.

---

## Modelo ML

**Propension**. Modelo que predice la probabilidad de que un pasajero compre un ticket. Target binario `has_booked`.

**Master table**. Tabla plana en BQ que junta las 6 fuentes en una fila por `customer_id`. Fuente de features del modelo.

**6 fuentes**. GA4 (comportamiento web), Comercial (ventas), Referencia (rutas), Customer segmentacion, Customer gestion (HUB), Customer marketing.

**RFM**. Recency, Frequency, Monetary. Feature clasica de segmentacion de clientes.

**Customer Management (HUB)**. Tabla `customer_management` en dataset `cus-data-prod`. Es el hub de joins (todos los `customer_id` viven aca).

**XGBoost**. Modelo de gradient boosting usado en `03-ml-propension`.

**Stratify**. Parametro de `sklearn.train_test_split`. Pitfall: en sklearn >=1.3 no acepta `stratify=True` (bool), hay que pasar `stratify=y`.

---

## GenAI

**LangGraph**. Framework para armar workflows de LLM. Usado en `06-chatbot-ob`.

**Light RAG**. Version simplificada de RAG (Retrieval Augmented Generation). Vector store + LLM.

**GenAI Gateway**. Servicio interno LATAM que centraliza acceso a modelos LLM.

**Chatbot GenAI**. Repo `nelsonacosta-ob-chatbot-ob`. Consume el modelo de propension + LLM para dar recomendaciones conversacionales.

---

## GCP

**Project ID**. Ejemplo `ss-data-dev`. Los IDs los asigna CPM.

**us-east1**. Region default LATAM. NUNCA usar `us-central1` (esta prohibido en Cosmos).

**Service Account (SA)**. Cuenta de servicio GCP. Los pipelines de CI usan `cosmos-cicd@<project>.iam.gserviceaccount.com`.

**IAM Bindings**. Permisos entre SA y recursos. Definidos en Terraform (`gcs_bucket_iam`, `bq_dataset_iam`).

---

## Namespace ob

Convencion de nombre para los repos del hands-on: `<username>-ob-<pieza>`.

En mi caso:
- `nelsonacosta-ob-infraestructure` (typo `e` incluido, es asi en LATAM)
- `nelsonacosta-ob-orchestrator`
- `nelsonacosta-ob-ml-propension`
- `nelsonacosta-ob-data-to-bucket`
- `nelsonacosta-ob-ingest-ga4`
- `nelsonacosta-ob-chatbot-ob`

El sufijo `-ob` viene de "onboarding". Es el marker que usa CPM para distinguir sandboxes de Boosters de repos productivos.

---

## Terraform apply policy

Reglas canonicas para `terraform` en Cosmos:

| Contexto | `terraform plan` | `terraform apply` |
|---|---|---|
| Branch feature | Si (CI) | NO (bloqueado) |
| MR abierto a `develop` | Si (CI) | NO (bloqueado) |
| Post-merge a `develop` | Si (CI) | Si (CI, solo en `develop`) |
| Post-merge a `main` | Si (CI) | Si (CI, solo prod) |
| Local (laptop Dell) | Si | NO (no tenes las credenciales) |

Consecuencia practica: pipeline verde en tu branch NO significa que la infra se aplico. Solo el pipeline post-merge en `develop` aplica.

Contraparte de aprobacion: reviewer aprueba el MR, autor mergea. Nunca al reves.

---

## Errores clasicos (busca aca antes de googlear)

**403 en `POST /pipelineJobs`**. El usuario no tiene permiso, solo el CI SA lo hace. Ver `02-orchestrator.md`.

**`tags/latest` NO existe** en modulos Terraform Cosmos. Fijar version explicita (ejemplo `1.126.0`).

**BOM en archivos generados con PowerShell `Out-File -Encoding utf8`**. Leer con `encoding="utf-8-sig"` en Python.

**stratify=True (bool) con sklearn >=1.3**. Pasar `stratify=y` (array), no `True`.

**HTTP Basic Access denied al clonar**. Falta PAT o falta acceso al grupo. Alternativa: descargar zip desde UI GitLab.
