# GameServices

A collection of services for games

## Apps

* game_services - data services
* game_services_web - frontend ui
* mix_docker - set of helpful mix tasks for docker
* mix_kubernetes - set of helpful mix tasks for kubernetes

## Development Environment

### Install Pre-Reqs

* minikube - for testing cluster deployment - https://github.com/kubernetes/minikube
* docker - https://www.docker.com/

### Mix Tasks

#### Docker Tasks

Start up a local docker registry

```bash
mix docker start_local_registry 
```

Get base docker image

```bash
mix docker get_base_docker
```

Build the App Builder

```bash
mix docker build_builder
```

Build App Latest Version

```bash
mix docker build_umbrella 
```

Build Release Docker

```bash
mix docker build_release
```

#### Kubernetes Tasks

Start Minikube

```bash
mix kubernetes start_minikube 
```

Create Kubernetes User

```bash
mix kubernetes create_auth_user
```

Create Kubernetes Secrets

```bash
mix kubernetes create_secrets 
```

Create Headless Service

```bash
mix kubernetes create_headless
```

Create Loadbalancer Service

```bash
mix kubernetes create_service
```

Deploy Release docker to Kubernetes

```bash
mix kubernetes deploy 
```

### Minikube/Kubernetes commands

Check Health of Kubernetes

```bash
kubectl get pods -n kube-system
```

Forward registry requests

```bash
kubectl port-forward --namespace kube-system $(kubectl get po -n kube-system | grep kube-registry-v0 | \
awk '{print $1;}') 5000:5000
```

Launch Mininkube UI in browser

```bash
minikube dashboard
```

Connect to a Running Pod

```bash
kubectl get pods
kubectl exec -it POD_NAME -c SERVICENAME -- /bin/bash
./bin/SERVICENAME remote_console
```

Switch to Minikube Docker

```bash
eval $(minikube docker-env)
```

Revert to regular docker

```bash
eval $(docker-machine env -u)
```

### Initial Deployment Steps

```bash
mix kubernetes start_minikube
# make sure services are all Running Status
mix kubernetes status
mix docker start_local_registry 
##
# in a seperate console - will lock console
kubectl port-forward --namespace kube-system $(kubectl get po -n kube-system | grep kube-registry-v0 | \
awk '{print $1;}') 5000:5000
## 
eval $(minikube docker-env)
mix docker get_base_docker
mix docker build_builder
mix docker build_umbrella
mix docker build_release
mix kubernetes create_auth_user # only required once
mix kubernetes create_secrets
mix kubernetes create_headless
mix kubernetes create_service
mix kubernetes deploy
```

