FROM maven:3.8.6-openjdk-8 AS build

WORKDIR /app

# Copy project files
COPY . .

# Limit memory and force single-threaded tests with minimal environment
ENV MAVEN_OPTS="-Xmx512m"

# (Temporary) Run a known good test only to isolate the issue
RUN mvn test -Dtest=SmokeTest -e -X -DforkCount=1 -DreuseForks=false
