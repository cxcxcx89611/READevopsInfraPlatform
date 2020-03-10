pipeline {
 agent {
  label 'Slave01'
 }
 stages {
  stage('checkout') {
   steps{
     cleanWs()
     checkout scm
   }
  }
  stage('init') {
     steps{
        withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: credentialsId,
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
         ]]) {
        sh 'terraform init'
       }
     }
    }

   stage('plan') {
        steps{
           withCredentials([[
                       $class: 'AmazonWebServicesCredentialsBinding',
                       credentialsId: credentialsId,
                       accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                       secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]]) {
           sh 'terraform plan'
          }
        }
   }
   stage('apply') {
           steps{
              withCredentials([[
                          $class: 'AmazonWebServicesCredentialsBinding',
                          credentialsId: credentialsId,
                          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
               ]]) {
             sh 'terraform apply -auto-approve'
             }
         }
      }
   stage('show') {
              steps{
                 withCredentials([[
                             $class: 'AmazonWebServicesCredentialsBinding',
                             credentialsId: credentialsId,
                             accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                             secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                  ]]) {
                sh 'terraform show'
                }
     }
   }
 }
}
