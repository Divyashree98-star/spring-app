# ---------- Stage 1: Build ----------
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app
COPY . .

RUN mvn clean package -DskipTests


# ---------- Stage 2: Runtime ----------
FROM gcr.io/distroless/java17-debian11

WORKDIR /app

# Copy only jar from builder
COPY --from=builder /app/target/*.jar app.jar

# Run as non-root (distroless default safe)
USER nonroot

ENTRYPOINT ["java","-jar","app.jar"]
