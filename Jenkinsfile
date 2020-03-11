pipeline {
 agent {
  label 'Slave01'
 }
 environment {
 credentialsId = 'awsCredentials'
 devEnvPrivateKey = "/home/jenkins-slave-01/.ssh/id_rsa_ec2"
 devEnvPrivateIP = "172.31.3.86"
 devArtifactsDeploymentTargetDir = "/home/ec2-user/REA_Deployment/artifacts/SinatraApp"
 devArtifactsDeploymentSourceDir = "/home/jenkins-slave-01/workspace/artifacts/SinatraAPP"
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

   stage('configure') {
                 steps{
                    withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: credentialsId,
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                     ]]) {
                     ansiColor('xterm') {
                   sh '''
                                whoami
                                pwd
                                ssh -i ${devEnvPrivateKey} ec2-user@${devEnvPrivateIP} "mkdir -p ${devArtifactsDeploymentTargetDir}"
                                scp -ri ${devEnvPrivateKey} ${devArtifactsDeploymentSourceDir}/* ec2-user@${devEnvPrivateIP} :${devArtifactsDeploymentTargetDir}/
                                '''
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
                            sh '''
                                ssh -oStrictHostKeyChecking=no -oIdentityFile=${devEnvPrivateKey} ec2-user@${devEnvPrivateIP}  << EOF
                                                  cd ${devArtifactsDeploymentTargetDir}
                                                  docker build -t sinatra-1.0 .
                                                  docker rm -f sinatra_container
                                                  docker run -d -p 80:9292 --name sinatra_container sinatra-1.0:latest
                                '''
                       }
              }
      }
 }
}
