[![CircleCI](https://circleci.com/gh/Alezrik/game_services_umbrella.svg?style=svg)](https://circleci.com/gh/Alezrik/game_services_umbrella)
![Coverage Status](https://coveralls.io/repos/github/Alezrik/game_services_umbrella/badge.svg?branch=master)](https://coveralls.io/github/Alezrik/game_services_umbrella?branch=master)

# GameServicesUmbrella

A collection of Services (better project name pending) to manage Multi Player Games.  Services will enable games to create a persistent multi player world.  Unreal Engine 4 will be used as the Game Client / Game Server(s) in a Multi Player RPG.

## Getting Started

Setting Up your Machine for Development / Test and Local Deployment

## Documentation

Generate Documentation

```bash
mix doc && open doc/index.html
```

### Installing / Local Deployment Game Services

Install [Docker](http://www.docker.io/) - Docker containers for local deployment build/release

Install [Minikube](https://github.com/kubernetes/minikube) - local Kubernetes - local deployment environment

Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - Kubernetes cli

Clone project

```bash
git clone https://github.com/Alezrik/game_services_umbrella.git
```

Install NPM packages

```bash
cd apps/game_services_web/assets
npm install
```

Startup minikube

```bash
mix kubernetes start_minikube
```

Verify Minikube services are up and running

```bash
mix kubernetes status
```

Switch to Minikube docker service

```bash
eval $(minikube docker-env)
```

Build Services Umbrella

```bash
mix docker build_umbrella
```

Create Release

```bash
mix docker build_release
```

Create Service User for Kubernetes

```bash
mix kubernetes create_auth_user
```

Create Secrets for Services

```bash
mix kubernetes create_secrets
```

Create a Headless Service for Internal Cluster

```bash
mix kubernetes create_headless
```

Create an External Service for external http access

```bash
mix kubernetes create_service
```

Create GameServicesUmbrella cluster

```bash
mix kubernetes deploy
```

Verify Cluster / Kubernetes Deployment

```bash
minikube dashboard
```


## Running in Development Environment

NOTE: When running in development locally you will see some unintended messages from swarm (Issue)[https://github.com/Alezrik/game_services_umbrella/issues/15]

```bash
mix phx.server
```

## Executing Unit tests

NOTE: When running unit tests locally you will see some unintended messages from swarm (Issue)[https://github.com/Alezrik/game_services_umbrella/issues/15]

```bash
mix test
```

## Elixir OTP Apps
* [authentication](apps/authentication/README.md) - Authentication Service
* [game_services](apps/game_services/README.md) - Database Services
* [game_services_web](apps/game_services_web/README.md) - [Pheonixframework](http://www.phoenixframework.org) - HTTP Frontend Service
* [mix_docker](apps/mix_docker/README.md) - mix tasks for interacting with docker
* [mix_kubernetes](apps/mix_kubernetes/README.md) - mix tasks for interacting with kubernetes/minikube
* [user_manager](apps/user_manager/README.md) - services for managing user accounts

## Changelog

Project [Changelog](CHANGELOG.md)

## Helpfuck Docker / Kubernetes Commands

Reset Docker to Normal Docker Service

```bash
eval $(docker-machine env -u)
```

Connect to a Running Pod

```bash
kubectl get pods
kubectl exec -it POD_NAME -c SERVICENAME -- /bin/bash
./bin/SERVICENAME remote_console
```