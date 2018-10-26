#!/usr/bin/env bash
mix kubernetes start_minikube
eval $(minikube docker-env) # REQUIRED
mix docker start_local_registry
mix docker get_base_docker
mix docker build_builder
mix docker build_umbrella
mix docker build_release
mix kubernetes create_auth_user # only required once
mix kubernetes create_secrets
mix kubernetes create_headless
mix kubernetes create_service
mix kubernetes deploy