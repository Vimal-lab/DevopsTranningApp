## Jenkins setup (safe) for this project

### 1) Change the Jenkins admin password (important)
If you shared your Jenkins password anywhere, **change it immediately**.

### 2) Install/ensure plugins
- **Pipeline**
- **Credentials Binding**
- **AWS Credentials** (optional but recommended)

### 3) Create Jenkins credentials (do not hardcode)
Create the following credential IDs:

- **`aws-creds`** (required)
  - Type: **AWS Credentials**
  - Stores: `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` (ideally short-lived)

Optional (recommended):
- **`vault-token`**
  - Type: **Secret text**
  - Used if you switch Vault from dev mode to real secret injection

### 4) Agent requirements
The Jenkins agent that runs the pipeline must have:
- `docker` (and permission to run Docker)

The pipeline runs everything inside Docker (`docker-compose.ci.yml`), so you do **not** need to install:
- terraform / awscli / ansible / kubectl / helm on the agent

### 5) Create pipeline job
- SCM: point to this repository
- Jenkinsfile path: `Jenkinsfile`
- Run the job


