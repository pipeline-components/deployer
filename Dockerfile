FROM composer:1.7 as build

COPY composer.json /composer/
ENV COMPOSER_HOME /composer/
RUN composer global install --no-interaction --no-scripts --no-progress

FROM php:7.2-alpine3.8
ENV COMPOSER_HOME /composer/
ENV PATH "$PATH:/composer/vendor/bin/"
RUN apk --no-cache add rsync=3.1.3-r1 openssh-client=7.7_p1-r3
COPY ssh-config /root/.ssh/config
COPY --from=build /composer/ /composer/
