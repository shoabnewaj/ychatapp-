# Stage 1: Build the Maven project
FROM maven:3.8.8-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run in Tomcat 10
FROM tomcat:10.1-jdk17
WORKDIR /usr/local/tomcat

# Clean default webapps
RUN rm -rf webapps/*

# Copy compiled WAR file as ROOT.war to serve at the root context /
COPY --from=builder /app/target/ychatApp-1.0.0.war webapps/ROOT.war

# Expose the standard port
EXPOSE 8080

# Dynamically change the Tomcat listener port to Railway's $PORT environment variable and run Tomcat
CMD ["/bin/sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/g\" conf/server.xml && catalina.sh run"]
