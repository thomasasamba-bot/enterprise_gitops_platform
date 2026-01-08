FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /services/product-service
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /services/product-service
COPY --from=builder /services/product-service/target/*.jar app.jar

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
