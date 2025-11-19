

# ===== Build Stage =====
FROM maven:3.9.6-amazoncorretto-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -q -e -DskipTests clean package

# ===== Run Stage =====
FROM amazoncorretto:17
WORKDIR /app
COPY --from=build /app/target/app-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
