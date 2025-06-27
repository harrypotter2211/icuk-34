# -------- Stage 1: Build & Test --------
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom and download dependencies first
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the code
COPY . .

# Set JVM memory options
ENV MAVEN_OPTS="-Xmx1024m"

# Run tests with JaCoCo disabled to avoid crashes
RUN mvn clean verify -Pno-jacoco -DforkCount=1 -DreuseForks=false

# -------- Stage 2: Runtime --------
FROM openjdk:8-jdk-alpine
WORKDIR /app

# Copy the JAR from the build stage
COPY --from=build /app/target/demo-workshop-2.1.2.jar app.jar

# Start the application
ENTRYPOINT ["java", "-jar", "app.jar"]
