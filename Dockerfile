# ── Stage 1: Build WAR with Maven ──────────────────────────────
FROM maven:3.9.6-eclipse-temurin-11 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# ── Stage 2: Run on Tomcat 9 ───────────────────────────────────
FROM tomcat:9.0-jdk11

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy built WAR as ROOT
COPY --from=build /app/target/AIBRDGenerator.war /usr/local/tomcat/webapps/ROOT.war

# Tomcat runs on 8080 — Railway must be told to use 8080
EXPOSE 8080

CMD ["catalina.sh", "run"]
