FROM composer:1.7 as build

COPY app/ /app/
RUN composer install --no-interaction --no-scripts --no-progress --optimize-autoloader 
WORKDIR /app/

FROM php:7.2-alpine3.8
ENV PATH "$PATH:/app/vendor/bin/"
COPY ssh-config /root/.ssh/config
RUN \
    chmod u=r,go= /root/.ssh/config && \
    apk --no-cache add rsync=3.1.3-r1 openssh-client=7.7_p1-r3
COPY --from=build /app/ /app/
