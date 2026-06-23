# Stage 1: Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
# Download dependencies for caching
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run stage
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
# Create log directory explicitly matching application.properties
RUN mkdir logs 

# FIX: Copy the compiled jar from the 'build' stage container, not the runner workspace
COPY --from=build /app/target/eurekaServer-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8761
ENTRYPOINT ["java", "-jar", "app.jar"]
