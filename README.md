# CAS 6 overlay on Redhat Universal Base Image 7

Docs go here.

Create a [github access token](https://github.com/settings/tokens) with at least the `read:packages` scope.

docker login

`docker login -u USERNAME -p TOKEN docker.pkg.github.com`

docker pull

`pull docker.pkg.github.com/prairieops/cas6-rh-ubi7/cas6-rh-ubi7:latest`
