# CAS 6 overlay on Redhat Universal Base Image 7

Docs go here.

Create a [github access token](https://github.com/settings/tokens) with at least the `['public_repo', 'read:packages']` scopes.

## Quickstart

If you do:
```
docker login -u USERNAME -p TOKEN docker.pkg.github.com
docker pull docker.pkg.github.com/prairieops/cas6-rh-ubi7/cas6-rh-ubi7:latest
docker run --rm   --name testcas -p 127.0.0.1:8443:8443 cas6-rh-ubi7
```
Then you should be able to access the CAS app in the container at https://127.0.0.1/cas.

`s/docker/podman/g` if appropriate. 
