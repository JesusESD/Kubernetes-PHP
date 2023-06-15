pipeline {
  
  environment {
    dockerimagename = "jesusesd5/myphpapp"
    dockerImage = ""
  }

  agent any

  stages {

    stage('Checkout Source') {
      steps {
        git branch: 'main', url: 'https://github.com/JesusESD/php-app'
      }
    }

    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build dockerimagename
        }
      }
    }

    stage('Pushing Image') {
      environment {
        registryCredential = 'DockerRegister'
      }
      steps{
        script {
          docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
            dockerImage.push("latest")
          }
        }
      }
    }

    stage('Deploying container to Kubernetes') {
      steps{
        script {
          withKubeCredentials(kubectlCredentials: [[credentialsId: 'TestKubernetes',serverUrl: 'https://192.168.68.119:6443']]) {
            sh 'curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.20.5/bin/linux/amd64/kubectl"'  
            sh 'chmod u+x ./kubectl'
            sh './kubectl delete pod php-app-pod'
            sh './kubectl delete service phpapp-svc'
            sh './kubectl run php-app-pod --image=jesusesd5/myphpapp'
            sh './kubectl expose pod php-app-pod --type=NodePort --port=8080 --target-port=8080 --name=phpapp-svc'
          }
        }
      }
    }
  }
}
