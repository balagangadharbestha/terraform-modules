pipeline {
  agent any

  parameters {
    string(name: 'GIT_REPO', defaultValue: 'https://github.com/balagangadharbestha/terraform-modules.git', description: 'Git repository URL')
    string(name: 'GIT_BRANCH', defaultValue: 'feature', description: 'Git branch to build from')
    choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Terraform action to run')
    booleanParam(name: 'AUTO_APPROVE', defaultValue: true, description: 'Auto approve apply/destroy?')
  }

  environment {
    TF_VAR_private_key_path = "${WORKSPACE}/terraform-key.pem"
  }

  stages {
          stage('Checkout Code') {
      steps {
        git branch: "${params.GIT_BRANCH}",
            url: "${params.GIT_REPO}"
      }
    }
    stage('Prepare PEM') {
      steps {
           input message: "Approve to proceed with PEM file preparation?"
        withCredentials([file(credentialsId: 'PEM_FILE', variable: 'PEM_FILE')]) {
          sh '''
            echo "📥 Copying PEM file..."
            cp "$PEM_FILE" terraform-us-east-1.pem
            chmod 600 terraform-us-east-1.pem
          '''
        }
      }
    }

    stage('Terraform Init & Validate') {
      steps {
           input message: "Proceed with terraform init and validate?"
        sh '''
          terraform init
          terraform validate
        '''
      }
    }

    stage('Terraform Action') {
      steps {
          input message: "Proceed with terraform ${params.ACTION}?"
        script {
          if (params.ACTION == 'plan') {
            sh 'terraform plan -out=tfplan'
          } else if (params.ACTION == 'apply') {
            if (params.AUTO_APPROVE) {
              sh 'terraform apply -auto-approve'
            } else {
              sh 'terraform apply'
            }
          } else if (params.ACTION == 'destroy') {
            if (params.AUTO_APPROVE) {
              sh 'terraform destroy -auto-approve'
            } else {
              sh 'terraform destroy'
            }
          } else {
            error "Invalid ACTION: ${params.ACTION}"
          }
        }
      }
    }
  }

  post {
    cleanup {
      sh 'rm -f terraform-us-east-1.pem tfplan || true'
    }
  }
}
