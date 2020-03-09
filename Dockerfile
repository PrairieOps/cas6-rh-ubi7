# Multistage build is a handy way to get the war file and base cas configuration.
# You'll need a redhat registry service account.
# https://access.redhat.com/terms-based-registry/#/accounts
FROM registry.redhat.io/ubi7-minimal:7.7 as base
# Shared dependencies for build and deploy. Clean cache to keep final image small.
RUN microdnf update && microdnf install java-11-openjdk-headless && rm -rf /var/cache/yum
# Build.
FROM base as builder
ARG BRANCH=6.1
RUN microdnf install git which
# Properly cache our remote data from github.
ADD https://api.github.com/repos/PrairieOps/cas-overlay-template/git/refs/heads/${BRANCH} version.json
RUN git clone -b ${BRANCH} https://github.com/PrairieOps/cas-overlay-template.git; cd cas-overlay-template; ./gradlew explodeWar

# The deployable imagie.
FROM base
# Exploded war from cas overlay.
COPY --from=builder /cas-overlay-template/build/cas /cas
COPY --from=builder /cas-overlay-template/etc /etc
EXPOSE 8080 8080
WORKDIR /cas
ENTRYPOINT ["java", "-server", "-noverify", "-Xmx2048M", "org.springframework.boot.loader.WarLauncher"]
