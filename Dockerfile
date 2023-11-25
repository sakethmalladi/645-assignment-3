# Use the official OpenJDK base image with the latest Java
FROM openjdk:latest

# Set the working directory inside the container
WORKDIR /app

# Copy your Spring Boot application JAR file to the container
COPY /target/HW3-0.0.1-SNAPSHOT.jar /app/app.jar

# Expose the port that your Spring Boot application listens on (replace with your application's actual port)
EXPOSE 8081

# Define the command to run your Spring Boot application
CMD ["java", "-jar", "app.jar", "--server.port=8081"]
