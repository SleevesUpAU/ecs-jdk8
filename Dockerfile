FROM frolvlad/alpine-oraclejdk8:full

RUN apk add --no-cache bash curl tini py-pip python unzip \
        libuuid && \
    pip install --no-cache-dir --upgrade pip awscli && \
    curl -sLo /newrelic.jar https://s3.amazonaws.com/dev-sup-public/newrelic/newrelic.jar && \
    curl -sLo /newrelic.yml https://s3.amazonaws.com/dev-sup-public/newrelic/newrelic.yml && \
    curl -O https://releases.hashicorp.com/vault/0.10.4/vault_0.10.4_linux_amd64.zip && \
    curl -O https://releases.hashicorp.com/consul/1.2.2/consul_1.2.2_linux_amd64.zip && \
    unzip vault_0.10.4_linux_amd64.zip && \
    unzip consul_1.2.2_linux_amd64.zip && \
    rm vault_0.10.4_linux_amd64.zip consul_1.2.2_linux_amd64.zip && \
    mv vault consul /usr/local/bin/ 


ENV JAVA_OPTS -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
EXPOSE 8080
CMD ["start"]
