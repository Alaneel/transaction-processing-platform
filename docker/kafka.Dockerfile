# syntax=docker/dockerfile:1@sha256:4edf897a3ffa55b89f906fc8cc78afdb3f1834cc9c7083565e611a8a7d5fe99e
FROM eclipse-temurin:21-jre-alpine@sha256:51ab5e3302e7141ce665ca3ea85e8b5cd648eafbc3c0c90dd79d6537684e4555 AS patched-jre
FROM apache/kafka:4.3.1@sha256:77e3df9054047a88b520d0cc46e16696d3b22022e1d580aeccd2632df6532837
USER root
COPY alpine-packages.lock install-alpine-patches.sh kafka-libraries.lock update-kafka-libraries.sh /tmp/tpp-security/
RUN sh /tmp/tpp-security/install-alpine-patches.sh /tmp/tpp-security/alpine-packages.lock \
      libcrypto3 libssl3 openssl libexpat libpng zlib p11-kit p11-kit-trust sqlite-libs \
    && sh /tmp/tpp-security/update-kafka-libraries.sh /tmp/tpp-security/kafka-libraries.lock \
    && rm -rf /tmp/tpp-security /opt/java/openjdk
COPY --from=patched-jre /opt/java/openjdk/ /opt/java/openjdk/
ENV JAVA_VERSION=jdk-21.0.12.1+1
LABEL org.opencontainers.image.title="TPP local Kafka 4.3.1 security derivative" \
      org.opencontainers.image.base.name="apache/kafka:4.3.1" \
      org.opencontainers.image.base.digest="sha256:77e3df9054047a88b520d0cc46e16696d3b22022e1d580aeccd2632df6532837"
USER appuser
