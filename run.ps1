param(
  [string]$AwsRegion = "ap-south-1",
  [string]$ClusterName = "capstone_project",
  [string]$AdminCidr = "0.0.0.0/0"
)

$ErrorActionPreference = "Stop"

function Require-Command($name) {
  if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
    throw "Missing required command: $name"
  }
}

Require-Command "docker"

Write-Host "Using AWS_REGION=$AwsRegion, CLUSTER_NAME=$ClusterName, ADMIN_CIDR=$AdminCidr"

if (-not $env:AWS_ACCESS_KEY_ID) {
  $env:AWS_ACCESS_KEY_ID = Read-Host "Enter AWS_ACCESS_KEY_ID"
}
if (-not $env:AWS_SECRET_ACCESS_KEY) {
  $secure = Read-Host "Enter AWS_SECRET_ACCESS_KEY" -AsSecureString
  $env:AWS_SECRET_ACCESS_KEY = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
  )
}

$env:AWS_REGION = $AwsRegion
$env:CLUSTER_NAME = $ClusterName
$env:ADMIN_CIDR = $AdminCidr

Write-Host "Building runner image..."
docker compose -f docker-compose.ci.yml build runner

Write-Host "Running full pipeline via Ansible (bootstrap -> vpc -> eks -> ecr -> build/push -> deploy -> vault -> dast)..."
docker compose -f docker-compose.ci.yml run --rm runner "ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/site.yml"

Write-Host "Done. Check zap-report.html (if ELB was ready) and Jenkins console output for full logs."


