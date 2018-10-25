.PHONY: help

APP_VSN ?= `grep 'version:' mix.exs | cut -d '"' -f2`
BUILD ?= `git rev-parse --short HEAD`

help:
	@echo "game_services_umbrella:$(APP_VSN)-$(BUILD)"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: clean-build## Build the Docker image
	docker build --build-arg APP_NAME=game_services_umbrella \
	--build-arg SKIP_PHOENIX=false \
	--build-arg APP_VSN=$(APP_VSN) \
	-t game_services_umbrella:build . \
	--file ./Dockerfile.build \
	&& docker create --name game_services_umbrella-build game_services_umbrella:build \
	&& docker cp game_services_umbrella-build:/opt/app/_build/prod/rel/game_services_umbrella/releases/$(APP_VSN)/game_services_umbrella.tar.gz ./ \
	&& $(MAKE) clean-build

release: ## Build the Docker image
	docker build --build-arg APP_NAME=game_services_umbrella \
	--build-arg SKIP_PHOENIX=true \
	--build-arg APP_VSN=$(APP_VSN) \
	-t game_services_umbrella:$(APP_VSN)-$(BUILD) \
	-t game_services_umbrella:latest . \
	--file ./Dockerfile.release

release-local: ## Build the Docker image
	docker build --build-arg APP_NAME=game_services_umbrella \
		--build-arg SKIP_PHOENIX=true \
		--build-arg APP_VSN=$(APP_VSN) \
		-t localhost:5000/game_services_umbrella:latest . \
		--file ./Dockerfile.release \
		&& docker push localhost:5000/game_services_umbrella:latest


run: ## Run the app in Docker
	docker run --env-file config/docker.env \
	-p 4000:4000 \
	--rm -it game_services_umbrella:latest

run-local:
	docker run --env-file config/docker.env \
		-p 4000:4000 \
		 --entrypoint=""  \
		--rm -it localhost:5000/game_services_umbrella:latest bin/game_services_umbrella foreground

clean-build:
	docker rmi game_services_umbrella:build --force || true \
	&& docker rm game_services_umbrella-build --force || true