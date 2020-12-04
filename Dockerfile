# Multistage build is a handy way to get the war file and base cas configuration.

# Create base image, and install dependencies. 
FROM registry.access.redhat.com/ubi7-minimal:7.7 as base
# Shared dependencies for build and deploy. Clean cache to keep final image small.
RUN microdnf update && microdnf install --nodocs java-11-openjdk-headless git && rm -rf /var/cache/yum
# Add github host key to known hosts.
RUN mkdir ~/.ssh && echo "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> ~/.ssh/known_hosts
ENV JAVA_HOME=/usr/lib/jvm/jre-11-openjdk

# Create builder image, and construct overlay 
FROM base as builder
COPY overlay /overlay
RUN cd overlay; ./gradlew explodeWar --no-daemon

# Create deployable image, and copy overlay from builder step.
FROM base
# Exploded war from cas overlay.
COPY --from=builder /overlay/build/cas /cas
COPY --from=builder /overlay/etc /etc
COPY wrapper.sh /cas
EXPOSE 8080 8080
WORKDIR /cas
ENTRYPOINT ["/cas/wrapper.sh"]
