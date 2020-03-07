# Multistage build is a handy way to get the war file and base cas configuration.
FROM registry.redhat.io/ubi7/ubi:7.7 as builder
RUN yum install -y java-11-openjdk-headless git; git clone https://github.com/PrairieOps/cas-overlay-template.git; cd cas-overlay-template; git checkout 6.1; ./gradlew build
# You'll need a redhat registry service account.
# https://access.redhat.com/terms-based-registry/#/accounts
FROM registry.redhat.io/ubi7/ubi:7.7
# Dependencies.
RUN yum install -y java-11-openjdk-headless; mkdir -p /cas-overlay
# war file for cas overlay.
COPY --from=builder /cas-overlay-template/build/libs/cas.war /cas-overlay/cas.war
COPY --from=builder /cas-overlay-template/etc /etc
# base configuration.
#COPY --from=cas /etc/cas /etc/cas
EXPOSE 8080 8080
ENTRYPOINT ["java", "-server", "-noverify", "-Xmx2048M", "-jar", "/cas-overlay/cas.war"]
