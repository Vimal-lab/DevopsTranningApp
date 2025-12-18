## DevopsTranningApp – Assessment Deliverables

This repo contains:
- **Terraform** to create VPC (2 public + 2 private subnets), IGW, NAT, route tables, security groups, **EKS + node group**, and **ECR repo**
- **Kubernetes manifests** to deploy the application on EKS behind a **Classic ELB**
- **Ansible** playbooks to orchestrate infra + build + deploy
- **Jenkinsfile** to automate everything (calls Ansible) with **SAST + DAST + Vault**

### 1) Terraform (AWS Infra + EKS + ECR)
Terraform directories:
- `VimalDemoWebApp/Terraform/bootstrap`: creates the S3 state bucket + DynamoDB lock table (no pre-created bucket needed)
- `VimalDemoWebApp/Terraform/vpc`: VPC, subnets, IGW, NAT, routes (subnets tagged for EKS/ELB)
- `VimalDemoWebApp/Terraform/eks`: EKS cluster + managed node group + security groups
- `VimalDemoWebApp/Terraform/ecr`: ECR repository

> Note: The pipeline runs the `bootstrap` stack first to create a new state bucket + lock table, then initializes the other stacks using `terraform init -backend-config ...`.

### 2) Docker Image
Because the repo does not include C# source (`.csproj`), the Docker image packages the **compiled output**:
- Dockerfile: `VimalDemoWebApp/Dockerfile`

### 3) Kubernetes Manifests (Classic ELB)
Manifests:
- `VimalDemoWebApp/k8s/app/namespace.yaml`
- `VimalDemoWebApp/k8s/app/deployment.yaml` (image placeholder `__IMAGE__`)
- `VimalDemoWebApp/k8s/app/service.yaml` (Classic ELB; SG placeholder `__ELB_SG_ID__`)

### 4) Jenkins Automation
Pipeline:
- `Jenkinsfile`

Ansible orchestration:
- `ansible/playbooks/site.yml` (runs Terraform + Docker build/push + kubectl deploy + Helm Vault + OWASP ZAP)

Expected Jenkins credentials:
- **AWS creds**: credential id `aws-creds` (AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY)

### Security note (important)
Do **not** hardcode AWS keys in files or commits. Store them in **Jenkins Credentials** (or Vault) and inject via the pipeline.
If you ever shared keys in chat/email, **revoke/rotate them immediately** in AWS IAM.

Do **not** share or commit Jenkins usernames/passwords either. Use Jenkins’ **Credentials** store and prefer short-lived credentials (OIDC/STS) where possible.

### Run it locally (Windows) using Docker (recommended)
This runs Ansible/Terraform/AWS CLI inside a container (no Ansible install on Windows).

#### Option 1 (simplest): run the script
From repo root:
- `powershell -ExecutionPolicy Bypass -File .\\run.ps1`

#### Option 2: manual Docker compose (if you prefer)
1) Set environment variables in PowerShell (**use rotated creds; do not commit them**):
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION` (optional, default `ap-south-1`)
- `CLUSTER_NAME` (optional, default `capstone_project`)
- `ADMIN_CIDR` (optional, default `0.0.0.0/0`, recommended: your `x.x.x.x/32`)

2) Run from repo root:
- `docker compose -f docker-compose.ci.yml build runner`
- `docker compose -f docker-compose.ci.yml run --rm runner "ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/site.yml"`

Tools assumed available on the Jenkins agent:
- `ansible-playbook`, `docker`, `terraform`, `aws`, `kubectl`, `helm`


