# -------- Stage 1: Build & Test --------
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Optimize dependencies layer
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY . .

# Set memory limits and run tests without forking issues
ENV MAVEN_OPTS="-Xmx1024m"
RUN mvn clean verify -DforkCount=1 -DreuseForks=false

# -------- Stage 2: Runtime --------
FROM openjdk:8-jdk-alpine
WORKDIR /app

# Copy the built JAR file
COPY --from=build /app/target/demo-workshop-2.1.2.jar app.jar

# Run the JAR
ENTRYPOINT ["java", "-jar", "app.jar"]
