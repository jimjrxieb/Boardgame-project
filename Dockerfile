FROM adoptopenjdk/openjdk11

# Create non-root user
RUN addgroup -g 1001 appuser && \
    adduser -u 1001 -G appuser -s /bin/sh -D appuser

# Set working directory and ownership
WORKDIR /app
RUN chown -R appuser:appuser /app

# Copy JAR file
COPY --chown=appuser:appuser target/database_service_project-0.0.4.jar app.jar

# Switch to non-root user
USER appuser

EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
