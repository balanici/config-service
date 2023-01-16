#FROM eclipse-temurin:17 AS builder
FROM eclipse-temurin:17-jre AS builder
WORKDIR workspace
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} config-service.jar
RUN java -Djarmode=layertools -jar config-service.jar extract

#FROM eclipse-temurin:17
FROM eclipse-temurin:17-jre
RUN useradd somenonroot
USER somenonroot
WORKDIR workspace
COPY --from=builder workspace/dependencies/ ./
COPY --from=builder workspace/spring-boot-loader/ ./
COPY --from=builder workspace/snapshot-dependencies/ ./
COPY --from=builder workspace/application/ ./

ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
