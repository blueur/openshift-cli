FROM alpine:latest

MAINTAINER Blueur

ARG GLIBC_VERSION
ENV GLIBC_VERSION=${GLIBC_VERSION:-2.27-r0}
ARG OC_VERSION
ENV OC_VERSION=${OC_VERSION:-v3.9.0}
ARG OC_TAG
ENV OC_TAG=${OC_TAG:-191fece}

RUN apk add --no-cache \
    ca-certificates \
    wget

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -O /tmp/glibc.apk

RUN apk add --no-cache \
    tar \
    /tmp/glibc.apk

RUN wget https://github.com/openshift/origin/releases/download/${OC_VERSION}/openshift-origin-client-tools-${OC_VERSION}-${OC_TAG}-linux-64bit.tar.gz -O /tmp/oc.tar.gz
RUN tar -zxf /tmp/oc.tar.gz --strip-components=1 -C /tmp/ && \
    mv /tmp/oc /usr/bin/ && \
    rm -rf /tmp/*

CMD ["oc"]
