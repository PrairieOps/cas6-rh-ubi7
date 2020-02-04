# Multistage build is a handy way to get the war file and base cas configuration.
FROM apereo/cas:v6.1.3 as cas
# You'll need a redhat registry service account.
# https://access.redhat.com/terms-based-registry/#/accounts
FROM registry.redhat.io/ubi7/ubi:7.7
# Dependencies.
RUN yum install -y java-11-openjdk-headless; mkdir -p /cas-overlay
# war file for cas overlay.
COPY --from=cas /cas-overlay/cas.war /cas-overlay/cas.war
# base configuration.
COPY --from=cas /etc/cas /etc/cas
EXPOSE 8080 8443
ENTRYPOINT ["java", "-server", "-noverify", "-Xmx2048M", "-jar", "/cas-overlay/cas.war"]
