pipeline {
  agent any
  environment {
    registry = "pulakanand/jenkins-project"
    registryCredential = 'dockerhub'
    //dockerImage = ''
  }
  stages {
    stage('Git clone') {
      steps {
        script {
            withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'GITHUB_PASSWORD', usernameVariable: 'GITHUB_USER')])
           {
            sh 'git fetch --all'
          }    
        }
      }
    }
    stage('Image Building') {
      steps{
        script {
          sh "docker image prune --all"
          sh "docker build -t pulakanand/jenkins-project:v1 ."
          sh "docker run -d --rm pulakanand/jenkins-project:v1"
          echo "New image built"
        }
      }
    }
    stage('Pushing image') {
      steps {
        script {
          withCredentials([string(credentialsId: 'dockerhub_key', variable: 'dockerhub_key')]){
            sh "docker login -u pulakanand -p ${dockerhub_key}" 
            echo "Dockerhub registry logged in"
            sh "docker push pulakanand/jenkins-project:v1"       
          }
        }
      }
    }
    stage('nginx deployment') {
      steps {
        script {
          kubeconfig(credentialsId: 'kuber_key', serverUrl: 'https://192.168.49.2:8443') {
              sh "kubectl apply -f deployment.yaml"
              echo "Deployment done."
              sh "kubectl get pods"
              sh "kubectl get deployments
          }   
        }
      }
    }
  }
  post {
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
  }
}
