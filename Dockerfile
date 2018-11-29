FROM frolvlad/alpine-oraclejdk8:full

RUN apk add --no-cache bash curl tini py-pip python \
        libuuid && \
    pip install --no-cache-dir --upgrade pip awscli && \
    curl -sLo /newrelic.jar https://s3.amazonaws.com/unlockd-releases/newrelic-agent/3.47.0/newrelic.jar && \
    curl -sLo /newrelic.yml https://s3.amazonaws.com/unlockd-releases/newrelic-agent/3.47.0/newrelic.yml

ENV JAVA_OPTS -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD ["start"]
EXPOSE 8080