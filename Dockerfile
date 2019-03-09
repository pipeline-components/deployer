FROM composer:1.8 as build

COPY app/ /app/
RUN composer install --no-interaction --no-scripts --no-progress --optimize-autoloader 
WORKDIR /app/

FROM php:7.3-alpine3.8
ENV PATH "$PATH:/app/vendor/bin/"
COPY ssh-config /root/.ssh/config
RUN \
    chmod u=r,go= /root/.ssh/config && \
    apk --no-cache add rsync=3.1.3-r1 openssh-client=7.7_p1-r4 git=2.18.1-r0
COPY --from=build /app/ /app/

WORKDIR /code/
# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <spam.me@grols.ch>" \
    org.label-schema.description="Deployer.org in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Deployer" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/deployer/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/deployer/" \
    org.label-schema.vendor="Pipeline Components"
