ARG ARCH=
FROM ${ARCH}debian:buster-slim
LABEL maintainer="docker@llamaq.com"

RUN apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
    netcat-openbsd nginx nginx-extras  \
  && apt-get -y clean && apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443
VOLUME /opt/config
ENV PUID=1000 PGID=1000

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

HEALTHCHECK --interval=1m --timeout=10s \
  CMD nc -z localhost 80 || exit 1

CMD /entrypoint.sh
