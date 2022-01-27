pipeline {
  agent any
  environment {
    registry = "pulakanand/jenkins-project"
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
  stages {
    stage('Cloning Git') {
      steps {
        script {
            withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'GITHUB_PASSWORD', usernameVariable: 'GITHUB_USER')])
           {
            sh 'git fetch --all'
            echo "Repository is Fetched"
          }    
        }
      }
    }
    stage('Building Image') {
      steps{
        script {
          sh "docker image prune --all"
          sh "docker build -t pulakanand/jenkins-project:v1 ."
          sh "docker run -d --rm pulakanand/jenkins-project:v1"
          echo "A New Image has been built"
        }
      }
    }
    stage('Push image') {
      steps {
        script {
          withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USER')]){
            sh "docker login -u pulakanand -p ${dockerhub_secret_key}" 
            echo "Logged in to Docker registry"
            sh "docker push pulakanand/jenkins-project:v1"       
          }
        }
      }
    }
    stage('Deploying nginx') {
      steps {
        script {
          kubeconfig(credentialsId: 'k8s_id', serverUrl: 'https://192.168.49.2:8443') {
            try {
              sh "kubectl apply -f deployment.yaml"
              echo "Successfully Deployed."
              sh "kubectl get pods"
              sh "kubectl get deployments"
              }
            catch (err) {
              echo "Pods and Deployments are availbale already, listed here."
              sh "kubectl get pods"
              sh "kubectl get deployments"
            }
          }   
        }
      }
    }
  }
  /*post {
    success {
      emailext body: '''$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS:
          Check console output at $BUILD_URL to view the results.''', 
          subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!', 
          to: 'pulakanand@sigmoidanalytics.com'
    }
    failure {
      emailext body: '''$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS:
          Check console output at $BUILD_URL to view the results.''',
          subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!',
          to: 'pulakanand@sigmoidanalytics.com'
    }
  }*/
}
