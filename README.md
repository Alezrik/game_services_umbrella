# GameServices.Umbrella

## Building Releases

### Get Production Dependencies

* mix deps.get --only prod

### Compile Services

* MIX_ENV=prod mix compile

### Build Static Resources

* cd apps/game_services_web/assets && npm install && node node_modules/webpack/bin/webpack.js --mode production && cd ../../..

* cd apps/game_services_web && mix phx.digest && cd ../..

### Build Release

* MIX_ENV=prod mix release


## Make tasks

* build - build tz.gz in root folder
* release - build release docker
* release-local - build release docker and push to local registry
* run-local - run latest release
* clean-build - clean build dockers

## Minikube

* minikube start
* eval $(minikube docker-env)
* make build
* make release-local
* kubectl apply -f k8s/game_services_umbrella-deployment.yaml

### Service

* kubectl create -f k8s/game_services_umbrella-service.yaml 

### Secrets

values are bse64 enc

* echo -n "postgres" | base64

* kubectl create -f k8s/game_services_umbrella-secrets.yaml 


