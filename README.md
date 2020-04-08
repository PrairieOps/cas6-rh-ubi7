# CAS 6 with overlay built on Redhat Universal Base Image 7

The is the build environment for our CAS 6 Docker container.
It includes a custom overlay based on the Apero [CAS overlay template](https://github.com/apereo/cas-overlay-template). 

## Quickstart 

First, create a [github access token](https://github.com/settings/tokens) with at least the `['public_repo', 'read:packages']` scopes. You'll need this to pull the container. 

Then, to run the latest build from the GitHub package registry, do:
```
docker login -u USERNAME -p TOKEN docker.pkg.github.com
docker pull docker.pkg.github.com/oulibraries/cas6-rh-ubi7/cas6-rh-ubi7:latest
docker run --rm   --name testcas -p 127.0.0.1:8080:8080 cas6-rh-ubi7
```
Once that's running, you should be able to access the CAS app in the container. 

## Configuration

You can use environment variables to configure the CAS container on startup:

* `PRIVATE_GIT_SERVICE_REGISTRY` - URL for a git repo containing a file-based service registry
* `SPRING_APPLICATION_JSON`- JSON-formatted string containing [CAS Properties](https://apereo.github.io/cas/6.1.x/configuration/Configuration-Properties.html)


## Local Build Instructions 

To download the `ubi7-minimal` base image, you'll need to authenticate with the RedHat package registry using a RedHat Developer Account(https://developers.redhat.com/) or a (Registry Service Account)[https://access.redhat.com/terms-based-registry/] (which can be created with your developer account).

`docker login -u USERNAME https://registry.redhat.io`

To build the container, run:

`docker build  . --file=Dockerfile --tag local-test-cas`
