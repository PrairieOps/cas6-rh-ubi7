# Docker Build For CAS 6 With Overlay 

The is the build environment for our CAS 6 Docker container. It includes a custom overlay based on the Apero [CAS overlay template](https://github.com/apereo/cas-overlay-template). 

## Configuration

You can use environment variables to configure the CAS container on startup:

* `PRIVATE_GIT_SERVICE_REGISTRY` - URL for a git repo containing a JSON-file-based [service registry](https://apereo.github.io/cas/6.1.x/services/JSON-Service-Management.html#json-service-registry) - since it's private, you'll probably need to embed credentials, eg. `https://user:pass@git.example.com/org/repo`
* `PRIVATE_GIT_DISCO_FEEDS`- URL for a git repo containing a JSON-file-based [identity provider discovery service](https://apereo.github.io/cas/6.1.x/integration/Delegate-Authentication-SAML.html#identity-provider-discovery-service) - since it's private, you'll probably need to embed credentials, eg. `https://user:pass@git.example.com/org/repo`
* `BRANCH` - the git branch pulled for the previous two repositories
* `SPRING_APPLICATION_JSON`- JSON-formatted string containing [CAS Properties](https://apereo.github.io/cas/6.1.x/configuration/Configuration-Properties.html) - this should be single-quoted

## Running prebuilt images

To run the latest build from the GitHub Container Registry, do:
```
docker pull ghcr.io/shareok/cas6-rh-ubi7/cas6-rh-ubi7:main
docker run \
--rm --name testcas \
-p 127.0.0.1:8080:8080 \
-e PRIVATE_GIT_SERVICE_REGISTRY=some_service_reg_url \
-e PRIVATE_GIT_DISCO_FEEDS=some_feed_repo_url \
-e BRANCH=some_branch \
-e SPRING_APPLICATION_JSON='some_spring_app_config_json' \ 
cas6-rh-ubi7
```
Once that's running, you should be able to access the CAS app in the container. 

## Local Build Instructions 

To build the container, run:

`docker build  . --file=Dockerfile --tag local-test-cas`

## Automated Container Registry Build 

A GitHub action to rebuild this container when the `master` branch of this repo is updated is configued at `.github/workflows/dockerpush.yml`. This action depends on GitHub Secrets:

* `CR_USER` - a GitHub Container Registry username
* `CR_PAT` - a GitHub Container Registry password/token
