FROM eclipse-temurin:17-jdk-jammy AS builder

WORKDIR /app

COPY mvnw pom.xml ./
COPY .mvn .mvn

RUN ./mvnw dependency:go-offline


COPY src src

RUN ./mvnw clean package -DskipTests

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Steal the compiled JAR from Stage 1 and leave the bulky source code behind
COPY --from=builder /app/target/*.jar app.jar

# Tell Docker which port the app uses
EXPOSE 8080

# The command to start the application
ENTRYPOINT ["java", "-jar", "app.jar"]
