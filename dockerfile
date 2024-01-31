# Use Maven image to build the application
FROM maven:3-eclipse-temurin-11-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the Maven POM file and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the application source code
COPY src ./src

# Build the application
RUN mvn package

# Use an official OpenJDK runtime as a base image
FROM openjdk:23-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the builder stage
COPY --from=builder /app/target/my-app-1.jar ./app.jar

# Expose the port the app runs on
EXPOSE 4567

# Run the application
CMD ["java", "-jar", "app.jar"]
