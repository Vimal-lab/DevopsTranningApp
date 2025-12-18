pipeline {
  agent any

  options {
    timestamps()
    ansiColor('xterm')
  }

  environment {
    AWS_REGION   = 'ap-south-1'
    CLUSTER_NAME = 'capstone_project'
    TF_IN_AUTOMATION = 'true'
    KUBECONFIG = "${WORKSPACE}/.kubeconfig"
  }

  stages {
    stage('Orchestrate via Ansible (Terraform + Docker + EKS + Vault + DAST)') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
          sh '''
            set -eux
            docker compose -f docker-compose.ci.yml build runner
            docker compose -f docker-compose.ci.yml run --rm runner "ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/site.yml"
          '''
        }
      }
      post {
        always {
          archiveArtifacts artifacts: 'zap-report.html', allowEmptyArchive: true
        }
      }
    }
  }
}


