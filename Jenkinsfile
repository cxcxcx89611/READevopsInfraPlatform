pipeline {
 agent {
  label 'Slave01'
 }
 environment {
 credentialsId = 'awsCredentials'
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
         ansiColor('xterm') {
        sh 'terraform init'
        }
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
            ansiColor('xterm') {
           sh 'terraform plan'
           }
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
               ansiColor('xterm') {
             sh 'terraform apply -auto-approve'
             }
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
                  ansiColor('xterm') {
                sh 'terraform show'
                }
                }
     }
   }

   stage('deploy') {
                 steps{
                    withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: credentialsId,
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                     ]]) {
                     ansiColor('xterm') {
                   sh '''
                                ssh -i ~/.ssh/id_rsa jenkins-slave-01@172.31.3.86 "mkdir -p /home/ec2-user/REA_Deployment/artifacts/SinatraApp/"
                                scp -ri ~/.ssh/id_rsa /home/jenkins-slave-01/workspace/artifacts/SinatraAPP/* ec2-user@172.31.3.86:/home/ec2-user/REA_Deployment/artifacts/SinatraApp/
                                ssh -i ~/.ssh/id_rsa jenkins-slave-01@172.31.3.86 "cd /home/ec2-user/REA_Deployment/artifacts/SinatraApp/ && docker build -t SinatraAPPImage-1.0 && docker run -d -p 80:9292 --name SinatraAPPContainer SinatraAPPImage-1.0"
                                '''
                   }
                 }
        }
      }
 }
}
