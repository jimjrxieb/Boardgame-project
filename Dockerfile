FROM eclipse-temurin:17-jre-alpine

# Create non-root user
RUN addgroup -g 1001 appuser && \
    adduser -u 1001 -G appuser -s /bin/sh -D appuser

# Set working directory and ownership
WORKDIR /app
RUN chown -R appuser:appuser /app

# Copy JAR file
COPY --chown=appuser:appuser target/database_service_project-0.0.6.jar app.jar

# Switch to non-root user
USER appuser

EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
