
#### This is a Repository for Build , Test and Deploy React&Spring-boot Application via Jenkins multibranch Pipeline. 
### In this repo, I didn't separate react from spring-boot so I deployed it all in one container.

#### To use this repo, You need to check the pre-request first as below:

1. I use here jenkins as CI/CD Tool, so you need to have jenkins to run this pipeline. Jenkins server should support docker. You can use the below to create jenkins sever that support docker:

```
#create docker image
FROM  jenkins/jenkins:lts
USER root
RUN curl -sSL https://get.docker.com/ | sh
USER jenkins

```

```
#run jenkins in a container
docker run --name jenkins -p 8080:8080 -p 50000:50000 --restart=always \
  --group-add `stat -c %g /var/run/docker.sock` \
  -v $(pwd)/jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins-docker
```

2. You should install the below plugins in your jenkins:

```
Blue Ocean , CloudBees Docker Build and Publish plugin, Docker API Plugin, Docker Pipeline, Docker plugin, 	
docker-build-step, 	Maven Integration plugin, Pipeline, Kubernetes Credentials Plugin, Kubernetes Plugin, Kubernetes Continuous Deploy Plugin,
Kubernetes Client API Plugin, 
```

3. You should add your Dockerhub credential ,Github  credential and Kubernetes credential in jenkins via manage credential.  






### After you finished the pre-request, You able to use this repo by adding jenkinsfile in this repo with your credentials that you set in pre-request step in the environment section in this file. After that you can create your multibranch pipeline using this jenkinsfile.  


