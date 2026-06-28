# ---- Build stage: compile with the Maven wrapper, no local Maven needed ----
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# Copy wrapper + pom first and pre-fetch dependencies, so this layer is cached
# unless the dependencies themselves change.
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw && ./mvnw dependency:go-offline -B

# Now copy sources and build the executable jar.
COPY src/ src/
RUN ./mvnw clean package -DskipTests -B

# ---- Runtime stage: small JRE image, just the jar ----
FROM eclipse-temurin:21-jre AS runtime
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

# Once spring-boot-starter-actuator is on the classpath, you can enable a proper
# health check (also used by the K8s readiness probe later):
# HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
#     CMD wget -qO- http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
