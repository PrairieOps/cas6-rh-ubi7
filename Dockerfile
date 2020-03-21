# Multistage build is a handy way to get the war file and base cas configuration.
# You'll need a redhat registry service account.
# https://access.redhat.com/terms-based-registry/#/accounts
FROM registry.redhat.io/ubi7-minimal:7.7 as base
# Shared dependencies for build and deploy. Clean cache to keep final image small.
RUN microdnf update && microdnf install --nodocs java-11-openjdk-headless git && rm -rf /var/cache/yum
# Add github host key to known hosts.
RUN mkdir ~/.ssh && echo "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> ~/.ssh/known_hosts
ENV JAVA_HOME=/usr/lib/jvm/jre-11-openjdk
# Build.
FROM base as builder
ARG BRANCH=6.1
#RUN microdnf --nodocs install git
# Properly cache our remote data from github.
ADD https://api.github.com/repos/PrairieOps/cas-overlay-template/git/refs/heads/${BRANCH} version.json
RUN git clone -b ${BRANCH} https://github.com/PrairieOps/cas-overlay-template.git; cd cas-overlay-template; ./gradlew explodeWar

# The deployable imagie.
FROM base
# Exploded war from cas overlay.
COPY --from=builder /cas-overlay-template/build/cas /cas
COPY --from=builder /cas-overlay-template/etc /etc
COPY wrapper.sh /cas
EXPOSE 8080 8080
WORKDIR /cas
ENTRYPOINT ["/cas/wrapper.sh"]
