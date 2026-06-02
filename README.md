
# DevOps Portfolio Project - Spring Boot + Docker + Kubernetes (kind) + Jenkins CI/CD

## Repository

https://github.com/jsonam21/Devops_Demo_Project/

## Project Overview

This project demonstrates a complete DevOps CI/CD workflow for a Java Spring Boot application using:

* Java Spring Boot
* Maven
* Docker
* Kubernetes (kind)
* Jenkins
* GitHub

The Jenkins pipeline automatically:

1. Pulls source code from GitHub
2. Builds the Spring Boot JAR using Maven
3. Creates a Docker image
4. Loads the image into a kind Kubernetes cluster
5. Deploys the application using Kubernetes manifests
6. Updates the running deployment with the latest image
7. Validates the deployment rollout

---

## Architecture

```text
GitHub
   |
   v
Jenkins (Docker Container)
   |
   v
Maven Build
   |
   v
Docker Image Build
   |
   v
kind Kubernetes Cluster
   |
   v
Spring Boot Application
```

---

## Project Structure

```text
Devops_Demo_Project/
|
├── application/
│   ├── springboot-app/
│   │   ├── src/
│   │   ├── pom.xml
│   │   └── target/
│   │
│   └── dockerfile
|
├── kubernetes/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   └── service.yaml
|
├── Jenkinsfile
|
└── README.md
```

---

# Spring Boot Application

## REST Controller

```java
package com.example.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/")
    public String hello() {
        return "Hello from DevOps Portfolio Project!";
    }

    @GetMapping("/health")
    public String health() {
        return "Application is healthy";
    }
}
```

---

# Maven Build

Build application:

```bash
mvn clean package
```

Generated artifact:

```text
target/*.jar
```

---

# Docker

## Dockerfile

```dockerfile
FROM eclipse-temurin:17-jre

WORKDIR /app

COPY springboot-app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
```

## Build Docker Image

```bash
docker build \
-t springboot-devops-app:v1 \
-f application/dockerfile \
application
```

## Run Container

```bash
docker run -d \
-p 8080:8080 \
--name springboot-app \
springboot-devops-app:v1
```

---

# Kubernetes (kind)

## Create Cluster

```bash
kind create cluster --name dev-cluster
```

Verify:

```bash
kubectl get nodes
```

---

# Kubernetes Manifests

## Namespace

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: devops-demo
```

## Deployment

Features:

* 2 replicas
* Resource requests and limits
* Readiness probe
* Liveness probe

```yaml
resources:
  requests:
    cpu: "200m"
    memory: "256Mi"

  limits:
    cpu: "500m"
    memory: "512Mi"
```

Health checks:

```yaml
readinessProbe:
  httpGet:
    path: /health
    port: 8080

livenessProbe:
  httpGet:
    path: /health
    port: 8080
```

---

## Service

```yaml
type: ClusterIP
```

Port mapping:

```text
Service Port     : 80
Target Port      : 8080
Container Port   : 8080
```

---

# Jenkins Setup

## Run Jenkins in Docker

```bash
docker run -d ^
--name jenkins ^
-p 8081:8080 ^
-p 50000:50000 ^
-v jenkins_data:/var/jenkins_home ^
-v //var/run/docker.sock:/var/run/docker.sock ^
-v "%USERPROFILE%\.kube:/var/jenkins_home/.kube" ^
jenkins/jenkins:lts
```

---

## Why Docker Socket Mount?

```text
-v //var/run/docker.sock:/var/run/docker.sock
```

Purpose:

Allows Jenkins container to use the Docker daemon running on the host machine.

Without this mount:

```bash
docker build
docker images
docker ps
```

would fail inside Jenkins.

---

## Why Mount Kubeconfig?

```text
-v "%USERPROFILE%\.kube:/var/jenkins_home/.kube"
```

Purpose:

Allows Jenkins container to access the Kubernetes cluster.

Without kubeconfig:

```bash
kubectl get nodes
```

fails because Jenkins has no cluster credentials.

---

# Kubeconfig Networking Fixes

## Problem

Inside Jenkins container:

```bash
kubectl get nodes
```

returned:

```text
Authentication required
```

or

```text
Forbidden
```

because kind kubeconfig referenced localhost.

Example:

```yaml
server: https://127.0.0.1:61486
```

Inside container:

```text
127.0.0.1 = Jenkins container itself
```

not the Kubernetes API server.

---

## Fix

Change server entry inside mounted kubeconfig:

```yaml
server: https://host.docker.internal:61486
```

or use the Windows host IP address.

This allows Jenkins container to reach the Kubernetes API server running on the host.

---

# Jenkins Pipeline

Pipeline stages:

## 1. Git Checkout

Pull source code from GitHub.

## 2. Build JAR

```bash
mvn clean package
```

## 3. Build Docker Image

```bash
docker build
```

## 4. Load Image into kind

```bash
kind load docker-image \
springboot-devops-app:<build-number> \
--name dev-cluster
```

## 5. Deploy to Kubernetes

```bash
kubectl apply -f kubernetes/
```

## 6. Update Deployment Image

```bash
kubectl set image deployment/springboot-app \
springboot-app=springboot-devops-app:<build-number>
```

## 7. Validate Deployment

```bash
kubectl rollout status deployment/springboot-app
```

---

# Accessing the Application

The service is ClusterIP.

Therefore it is only reachable from inside the cluster.

Use port-forwarding:

```bash
kubectl port-forward \
service/springboot-service \
9090:80 \
-n devops-demo
```

Access:

```text
http://localhost:9090
```

Health endpoint:

```text
http://localhost:9090/health
```

---

# Common Issues Encountered

## Docker Desktop Stuck at "Starting Docker Engine"

Resolved by:

* Reinstalling Docker Desktop
* Ensuring WSL2 was installed
* Restarting Windows

Verify:

```bash
wsl -l -v
docker version
```

---

## Maven Not Found

Error:

```text
mvn : command not found
```

Resolution:

* Install Maven
* Add Maven bin directory to PATH

---

## JAVA_HOME Not Set

Resolution:

Configure:

```text
JAVA_HOME
```

and update PATH.

---

## Package Name Mismatch

Error:

```text
declared package does not match expected package
```

Resolution:

Ensure Java package declaration matches directory structure.

---

## InvalidImageName

Cause:

Incorrect image tag format.

Wrong:

```text
springboot-devops-app:{BUILD_TAG}
```

Correct:

```text
springboot-devops-app:${BUILD_TAG}
```

---

## Deployment Progress Deadline Exceeded

Cause:

Pods not becoming healthy.

Diagnosis:

```bash
kubectl get pods
kubectl describe pod
kubectl logs
```

---

# Future Enhancements

* Terraform Infrastructure as Code
* AWS VPC provisioning
* AWS EKS deployment
* Jenkins Webhooks

---

# Skills Demonstrated

* Java Spring Boot
* Maven
* Docker
* Kubernetes
* kind
* Jenkins
* GitHub
* CI/CD Pipelines
* Containerization
* Kubernetes Troubleshooting
* Linux Administration
* DevOps Automation

```
```



