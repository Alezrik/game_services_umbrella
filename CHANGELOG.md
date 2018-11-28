# Game Services Umbrella Change Log

## 0.3.0
* Started work on UE4 Client - https://github.com/Alezrik/game_services_client-UE4
* introduce workflow for CMSG_HEARTBEAT

## 0.2.0
* Implement TCP Server
* re-enable dialyzer
* bump phoenix to 1.4
* introduce a tcp command processor
* fix up logging in all apps
* introduce tcp serialize and deserializer
* introduce workflow for CMSG_AUTHENTICATE_CHALLENGE
* change :random to :rand
* introduce workflow for CMSG_AUTHENTICATE
* fix logger conf
* introduce tcp_client for responses to tcp requests
* a tcp client can authenticate a user

## 0.1.0
* integrate libcluster
* integrate swarm
* deployment to kubernetes
* mix tasks for build helpers
* Fix up deployment scripts
* add User schema
* add Credential schema
* add undeploy and upsert-deploy to kubernetes tasks
* add user lookup by credential
* integrate credo
* integrate dialyzer
* integrate dockerhub for base images to speed up deployment
* integrate circle-ci
* user registration workflow
* enhance documentation
* circle-ci workflows for builds
* user login workflow
* Integrate Guardian Login
* add Property Tests
* add Code Coverage
* create cluster manager
* cluster manager switches swarm on and off depending on config
* disabled dialyzer - https://github.com/Alezrik/game_services_umbrella/issues/22
* connection logout route
* credential input requirements
* update to phoenix 1.4-rc3
* fix builds and deploy for windows - https://github.com/Alezrik/game_services_umbrella/issues/26
* added some basic requirements for Credentials
* Register now has messages
* added more unit tests

