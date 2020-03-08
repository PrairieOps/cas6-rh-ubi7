# Multistage build is a handy way to get the war file and base cas configuration.
# You'll need a redhat registry service account.
# https://access.redhat.com/terms-based-registry/#/accounts
FROM registry.redhat.io/ubi7/ubi:7.7 as builder
ARG BRANCH=6.1
RUN yum install -y java-11-openjdk-headless git;
# Properly cache our remote data from github.
ADD https://api.github.com/repos/PrairieOps/cas-overlay-template/git/refs/heads/${BRANCH} version.json
RUN git clone -b ${BRANCH} https://github.com/PrairieOps/cas-overlay-template.git; cd cas-overlay-template; ./gradlew explodeWar

# The deployable image.
FROM registry.redhat.io/ubi7/ubi:7.7
# Dependencies.
RUN yum install -y java-11-openjdk-headless
# war file for cas overlay.
COPY --from=builder /cas-overlay-template/build/cas /cas
COPY --from=builder /cas-overlay-template/etc /etc
EXPOSE 8080 8080
WORKDIR /cas
ENTRYPOINT ["java", "-server", "-noverify", "-Xmx2048M", "org.springframework.boot.loader.WarLauncher"]
