pipeline {
    agent any
    
    environment {
         maventool= 'TEST'                     // Add the maven tool that used by jenkins
         giturl = 'https://github.com/EslamSaberSoliman/spring-boot-react-all-in-one.git'   // Add the code repo here
         imagename = "eslamzaineldeen/react-spring-allinone"         // Add the name of the image in the dockerhub repo
         imagenamebranch=""
         branch = "${env.BRANCH_NAME}"                    // set the branch from git repo
         registryCredential = 'eslam_docker_hub'          // docker hub credential in jenkins manage credential
         kubernetesCredential = "kubernetes_cluster"      // kubernetes credential in jenkins manage credential
         gitCredential = 'infra-github'      // git credential in jenkins manage credential
         dockerImage = ''                                 // Def dockerImage 
         deploymentfile="app.yml"                         // app deployment file of master branch
         deploymentfeaturefile="app-feature.yml"          // app deployment file of other branches
         appname='react-springboot'                       // appname that you want
         namespace= 'deploy'                              // namespace that you want
         servicename = 'react-springboot'                 // servicename that you want
         servicetype = 'NodePort'                         // servicetype
         
        }
        
    tools {
        maven maventool
    }
   
    stages {
        
        stage ('CHECK OUT') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '**']], extensions: [], userRemoteConfigs: [[credentialsId: gitCredential, url: giturl]]])
                //checkout([$class: 'GitSCM', branches: [[name: '**']], extensions: [], userRemoteConfigs: [[url: giturl]]])
            }
        }

        
        stage ('Build') {
            steps {
                sh 'mvn clean install' 
            }
            
        }
        
        
        stage ('Test') {
            steps {
                sh 'mvn test' 
            }
            
        }
        
       
        stage('Building image feature') {
         when { not { branch 'master'}}
            steps{
               script {

                  dockerImage = docker.build imagename + "_${branch}"

                }
            }    
            
        } 


        stage('Building image master') {
        when {
             branch 'master'
         }
            steps{
               script {

                         dockerImage = docker.build imagename

                }
            }
        }

       
        stage('Deploy Image') { 
            steps{
                script {
                   docker.withRegistry( '', registryCredential ) {
                   dockerImage.push("$BUILD_NUMBER")
                   dockerImage.push('latest')
                   }
                }
            }
        }
/*        
        stage('Remove Unused docker image master') {
          when { 
               branch 'master'
          }
             steps{
                  sh "docker rmi $imagename:$BUILD_NUMBER"
                  sh "docker rmi $imagename:latest"
            }
        }

        stage('Remove Unused docker image feature') {
            
          when { not { branch 'master'}}
             steps{
                sh "docker rmi ${imagename}_${branch}:${BUILD_NUMBER}"
                sh "docker rmi ${imagename}_${branch}:latest"   
            }
            
        }
*/

        stage('Deploy APP feature') {
             agent {
                label 'kubernetes'
            }
            
            when { not { branch 'master'}}
              steps{
                checkout([$class: 'GitSCM', branches: [[name: '**']], extensions: [], userRemoteConfigs: [[credentialsId: gitCredential, url: giturl]]])
                kubernetesDeploy(configs:deploymentfeaturefile, kubeconfigId:kubernetesCredential,enableConfigSubstitution: true)
            }
        } 
       

        stage('Deploy APP master') {
             agent {
                label 'kubernetes'
            }
        when { 
            branch 'master'
            
        }
              steps{
                checkout([$class: 'GitSCM', branches: [[name: '**']], extensions: [], userRemoteConfigs: [[credentialsId: gitCredential, url: giturl]]])
                kubernetesDeploy(configs:deploymentfile, kubeconfigId:kubernetesCredential,enableConfigSubstitution: true)
            }    
        }

    }
}
