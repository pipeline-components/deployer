FROM composer:2.9.2 as composer

FROM php:8.4.15-alpine3.22 as build
COPY --from=composer /usr/bin/composer /usr/bin/composer
WORKDIR /app/
COPY app/ /app/
RUN chmod a+rx /usr/bin/composer && /usr/bin/composer install --no-interaction --no-scripts --no-progress --optimize-autoloader

FROM pipelinecomponents/base-entrypoint:0.5.0 as entrypoint

FROM php:8.4.15-alpine3.22
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD dep

ENV PATH "$PATH:/app/vendor/bin/"
COPY ssh-config /root/.ssh/config
# hadolint ignore=DL3018
RUN \
    chmod u=r,go= /root/.ssh/config && \
    apk --no-cache add bash rsync openssh-client git
COPY --from=build /app/ /app/

WORKDIR /code/
# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <dev@pipeline-components.dev>" \
    org.label-schema.description="Deployer.org in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Deployer" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/deployer/blob/main/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/deployer/" \
    org.label-schema.vendor="Pipeline Components"
