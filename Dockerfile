# Use an official Maven image to build the application
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy source code
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src

# Package the application
RUN mvn clean package -DskipTests

# ------------------------
# Runtime Image
# ------------------------
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# Copy the jar file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

