FROM frolvlad/alpine-oraclejdk8:full

RUN apk add --no-cache bash curl tini py-pip python \
        libuuid && \
    pip install --no-cache-dir --upgrade pip awscli && \
    curl -sLo /newrelic.jar https://s3.amazonaws.com/dev-sup-public/newrelic/newrelic.jar && \
    curl -sLo /newrelic.yml https://s3.amazonaws.com/dev-sup-public/newrelic/newrelic.yml

ENV JAVA_OPTS -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
EXPOSE 8080
CMD ["start"]
