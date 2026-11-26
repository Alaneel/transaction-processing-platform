# syntax=docker/dockerfile:1@sha256:4edf897a3ffa55b89f906fc8cc78afdb3f1834cc9c7083565e611a8a7d5fe99e
FROM eclipse-temurin:21-jdk-alpine@sha256:0bfc69a4758a86710e5c474032d28400a8bd00874766f9e8b1642ac2fd293159 AS build
WORKDIR /workspace
COPY .mvn/ .mvn/
COPY mvnw pom.xml LICENSE THIRD_PARTY_NOTICES.md ./
COPY src/ src/
COPY docker/alpine-packages.lock docker/install-alpine-patches.sh /tmp/tpp-security/
RUN sh /tmp/tpp-security/install-alpine-patches.sh /tmp/tpp-security/alpine-packages.lock libpng zlib \
    && rm -rf /tmp/tpp-security \
    && chmod +x mvnw && ./mvnw -B -ntp -DskipTests package

FROM eclipse-temurin:21-jre-alpine@sha256:51ab5e3302e7141ce665ca3ea85e8b5cd648eafbc3c0c90dd79d6537684e4555
COPY docker/alpine-packages.lock docker/install-alpine-patches.sh /tmp/tpp-security/
RUN sh /tmp/tpp-security/install-alpine-patches.sh /tmp/tpp-security/alpine-packages.lock libpng zlib \
    && rm -rf /tmp/tpp-security \
    && addgroup -g 10001 app && adduser -D -u 10001 -G app app
WORKDIR /app
COPY --from=build --chown=app:app /workspace/target/*.jar /app/application.jar
USER app
EXPOSE 8080
HEALTHCHECK --interval=10s --timeout=3s --start-period=40s --retries=5 \
  CMD wget -q -O /dev/null http://127.0.0.1:8080/actuator/health/readiness || exit 1
ENTRYPOINT ["java", "-jar", "/app/application.jar"]
