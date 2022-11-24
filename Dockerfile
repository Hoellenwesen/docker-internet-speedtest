FROM alpine:3.17
LABEL maintainer="Hoellenwesen <https://github.com/Hoellenwesen>"

ARG TARGETPLATFORM

RUN apk add --no-cache wget curl jq \
    && if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE=x86_64; \
    elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then ARCHITECTURE=armhf; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=aarch64; \
    else ARCHITECTURE=amd64; fi \
    && wget -O speedtest-cli.tgz https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-${ARCHITECTURE}.tgz \
    && tar zxvf speedtest-cli.tgz \
    && rm speedtest-cli.tgz \
    && mv speedtest* /usr/bin/

#HEALTHCHECK --interval=5m --timeout=5s --retries=1 \
#    CMD ./healthcheck.sh

WORKDIR /opt/speedtest

ADD scripts/ .

RUN chmod +x ./speedtest.sh \
    && chmod +x ./healthcheck.sh

CMD ./speedtest.sh