pipeline {

  agent {
     label 'Slave01'
  }

  environment {
    CREDENTIALS_ID = 'awsCredentials'
  }

  stage('checkout') {
    node {
      cleanWs()
      checkout scm
    }
  }

  stages {
  // Run terraform init
  stage('init') {
    steps {
      withCredentials([[
        $class: 'AmazonWebServicesCredentialsBinding',
        credentialsId: ${CREDENTIALS_ID},
        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
      ]]) {
        ansiColor('xterm') {
          sh 'terraform init'
        }
      }
    }
  }

  // Run terraform plan
  stage('plan') {
    steps {
      withCredentials([[
        $class: 'AmazonWebServicesCredentialsBinding',
        credentialsId: ${CREDENTIALS_ID},
        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
      ]]) {
        ansiColor('xterm') {
          sh 'terraform plan'
        }
      }
    }
  }

  if (env.BRANCH_NAME == 'master') {

    // Run terraform apply
    stage('apply') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: ${CREDENTIALS_ID},
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          ansiColor('xterm') {
            sh 'terraform apply -auto-approve'
          }
        }
      }
    }

    // Run terraform show
    stage('show') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: ${CREDENTIALS_ID},
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          ansiColor('xterm') {
            sh 'terraform show'
          }
        }
      }
    }
   }
  }
}

