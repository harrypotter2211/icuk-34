# -------- Stage 1: Build and test --------
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy everything into the container
COPY . .

# Build the project and run tests (mvn verify runs tests + checks)
RUN mvn clean verify

# -------- Stage 2: Runtime image --------
FROM openjdk:8-jdk-alpine
WORKDIR /app

# Copy the built JAR from the previous stage
COPY --from=build /app/target/demo-workshop-2.1.2.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
