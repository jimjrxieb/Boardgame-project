FROM adoptopenjdk/openjdk11

# Create non-root user
RUN addgroup -g 1001 appuser && \
    adduser -u 1001 -G appuser -s /bin/sh -D appuser

# Set working directory and ownership
WORKDIR /app
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

EXPOSE 8080
