---
titulo: Prerequisitos globales - Setup del entorno Booster
autor: Nelson Acosta
version: 1.0.0
last_validated: 2026-07-31
tiempo_estimado: 30 min
---

# Prerequisitos globales

Setup comun para trabajar los 6 repos del hands-on. Correr esto UNA vez al arrancar el hands-on. Si algo aca falla, no arrancar los playbooks de repos.

Todos los comandos asumen una laptop Dell LATAM Windows + PowerShell (la que te da LATAM) y un servidor Linux auxiliar para tareas de forensics (opcional).

Volver al [README](./00-README.md). Terminos: [glosario](./01-glossary.md).

---

## Indice

- [Antes de arrancar](#antes-de-arrancar)
- [Setup en la laptop Dell LATAM (Windows / PowerShell)](#setup-en-la-laptop-dell-latam-windows--powershell)
- [Setup en el servidor Linux auxiliar (opcional para forensics)](#setup-en-el-servidor-linux-auxiliar-opcional-para-forensics)
- [Checklist final](#checklist-final)
- [Pitfalls comunes en el setup](#pitfalls-comunes-en-el-setup)
  - [Pitfall S1 - setx /M falla por UAC](#pitfall-s1---setx-m-falla-por-uac-en-laptop-dell-13-jul-2026)
  - [Pitfall S2 - Backtick vs caret](#pitfall-s2---backtick-vs-caret-en-powershell-13-jul-2026)
  - [Pitfall S3 - pip.ini filtra secretos](#pitfall-s3---pip-config-globalextra-index-url-filtra-secretos-13-jul-2026)
  - [Pitfall S4 - HTTP Basic Access denied](#pitfall-s4---http-basic-access-denied-al-clonar-repo-privado-08-jul-2026)
  - [Pitfall S5 - Email de commit incorrecto](#pitfall-s5---email-de-commit-incorrecto-15-jul-2026)

---

## Antes de arrancar

Tener:

- [ ] Cuenta corporativa `nelsonacosta@latam.com` activa (SSO Google LATAM).
- [ ] Cuenta Globant activa (email `nelson.acosta.globant@latam.com`).
- [ ] Aprobado el alta en `ai-sharedservices` (MR mergeado en `gitlab-group-management/gitlab-groups-members`).
- [ ] Sandbox aprobado por CPM (email de Data Hub).
- [ ] GCP Project IDs de dev y prod confirmados por CPM (Diego).

Si alguno de los 5 falta, primero ejecutar el flujo de onboarding (no cubierto por esta serie).

---

## Setup en la laptop Dell LATAM (Windows / PowerShell)

### 1. Verificar herramientas base

```powershell
git --version         # >= 2.40
python --version      # 3.10.x o 3.11.x
gcloud --version      # cualquier version reciente
terraform --version   # >= 1.5, < 2.0
curl.exe --version    # incluido en Windows 10/11
```

Si falta algo, instalar desde:
- Git: https://git-scm.com/download/win
- Python: microsoft store o python.org (evitar 3.12 hasta validar Cosmos-core)
- gcloud: https://cloud.google.com/sdk/docs/install
- Terraform: `winget install HashiCorp.Terraform`

### 2. Configurar git para el dominio LATAM

```powershell
git config --global user.email "nelson.acosta.globant@latam.com"
git config --global user.name "Nelson Acosta"
```

Verificar:

```powershell
git config --global user.email
# debe imprimir nelson.acosta.globant@latam.com, NO @globant.com
```

### 3. GitLab Personal Access Token

Ir a: https://gitlab.com/-/user_settings/personal_access_tokens

- Nombre: `booster-cli`
- Expira: 90 dias
- Scopes: `read_api`, `read_repository`, `write_repository`

Guardar en variable de entorno (NUNCA en pip.ini, NUNCA en repos, NUNCA en este playbook):

```powershell
$env:GITLAB_TOKEN = "<pegar-token-aqui>"
```

Para persistir en la sesion del usuario (sin admin):

```powershell
setx GITLAB_TOKEN "<pegar-token-aqui>"
```

Verificar:

```powershell
curl.exe -sI -H "PRIVATE-TOKEN: $env:GITLAB_TOKEN" https://gitlab.com/api/v4/user | Select-Object -First 1
# HTTP/2 200
```

### 4. gcloud auth

```powershell
gcloud auth login nelsonacosta@latam.com
gcloud auth application-default login
gcloud config set project <project-id-dev>
gcloud config set compute/region us-east1
```

Verificar:

```powershell
gcloud config list
```

### 5. Python venv del hands-on

```powershell
cd C:\Repo_LATAM
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
```

### 6. Artifactory (pip contra el registry interno LATAM)

**NO** persistir la API key en `pip.ini`. Setear como env var en cada sesion:

```powershell
$env:ARTIFACTORY_USER = "nelson.acosta.globant"
$env:ARTIFACTORY_TOKEN = "<pegar-api-key-aqui>"
```

Test contra el repo pypi interno:

```powershell
curl.exe -sI -u "$env:ARTIFACTORY_USER`:$env:ARTIFACTORY_TOKEN" `
  "https://artifactoryrepo1.appslatam.com/artifactory/api/pypi/cosmos/simple/"
# HTTP/1.1 200 OK
```

Si da 401, esperar 10-30 min despues del alta en `ai-sharedservices` (propagacion IAM).

### 7. Directorio de trabajo

```powershell
New-Item -ItemType Directory -Force -Path C:\Repo_LATAM\nelsonacosta-ob
cd C:\Repo_LATAM\nelsonacosta-ob
```

Todos los repos del hands-on se clonan aca.

---

## Setup en el servidor Linux auxiliar (opcional para forensics)

Solo si vas a hacer forensics de pipelines (extraccion masiva de datos de GitLab API).

### 1. Herramientas

```bash
which git curl jq gcloud terraform python3
# todos deben responder path
```

Instalar lo que falte con apt o snap.

### 2. Variables

```bash
export GITLAB_TOKEN="<pegar-token-aqui>"
```

Persistir en `~/.bashrc` o `~/.zshrc`:

```bash
echo 'export GITLAB_TOKEN="<pegar-token-aqui>"' >> ~/.bashrc
```

NUNCA commitear tokens reales al repo.

### 3. Verificacion

```bash
curl -sI -H "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  https://gitlab.com/api/v4/user | head -1
# HTTP/2 200
```

---

## Checklist final

Antes de arrancar `repos/01-infraestructure.md`, todos estos comandos tienen que pasar:

```powershell
# En la laptop Dell LATAM
git config --global user.email                    # nelson.acosta.globant@latam.com
gcloud config get-value project                   # <project-id-dev>
gcloud config get-value compute/region            # us-east1
python --version                                  # 3.10.x o 3.11.x
terraform --version                               # >= 1.5
curl.exe -sI -H "PRIVATE-TOKEN: $env:GITLAB_TOKEN" https://gitlab.com/api/v4/user | Select-Object -First 1
# HTTP/2 200
```

Si los 6 pasan, estas listo para `01-infraestructure.md`.

---

## Pitfalls comunes en el setup

### Pitfall S1 - setx /M falla por UAC en laptop Dell (13-jul-2026)

Sintoma:
```
ERROR: Access to the registry path is denied.
```

Causa: la laptop Dell LATAM no tiene privilegios de admin para escribir en `HKLM`.

Fix: usar `setx` sin `/M` (queda en `HKCU`) o directamente `$env:` no-persistente.

### Pitfall S2 - Backtick vs caret en PowerShell (13-jul-2026)

Sintoma:
```
Unexpected token '^' in expression or statement
```

Causa: guias oficiales de LATAM usan `^` (bash) para continuar linea, PowerShell usa `` ` `` (backtick).

Fix: reemplazar `^` por `` ` `` en comandos multi-linea. O poner el comando en una sola linea.

### Pitfall S3 - pip config global.extra-index-url filtra secretos (13-jul-2026)

Sintoma: la API key de Artifactory queda plana en `%APPDATA%\pip\pip.ini` y en el historial de PowerShell.

Causa: la guia oficial LATAM sugiere el patron con `<user>:<key>@` inline. Persiste en disco.

Fix: usar env vars (`$env:ARTIFACTORY_TOKEN`) y NO persistir en pip.ini. Si ya persistio: `Remove-Item "$env:APPDATA\pip\pip.ini" -Force` + rotar la key en Artifactory.

### Pitfall S4 - HTTP Basic Access denied al clonar repo privado (08-jul-2026)

Sintoma:
```
remote: HTTP Basic: Access denied
fatal: Authentication failed for 'https://gitlab.com/latamairlines/...'
```

Causa: el repo es privado y el PAT no tiene scope `read_repository`, o la cuenta no es miembro del grupo.

Fix: regenerar el PAT con scope `read_repository` + verificar acceso al grupo en GitLab UI. Alternativa temporal: descargar el ZIP desde la UI GitLab.

### Pitfall S5 - Email de commit incorrecto (15-jul-2026)

Sintoma: MR rechazado por CI porque el committer no tiene dominio `@latam.com`.

Causa: git config global tiene `@globant.com` en vez de `nelson.acosta.globant@latam.com`.

Fix:
```powershell
git config --global user.email "nelson.acosta.globant@latam.com"
# Si el commit ya se hizo:
git commit --amend --reset-author --no-edit
```
