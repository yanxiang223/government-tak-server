# ============================================================================
# TAK Server Docker Image Build
# ============================================================================
# This Dockerfile builds a TAK Server image for deployment to CCE.
# You need to obtain the TAK Server distribution from official sources.
# ============================================================================

FROM ubuntu:22.04

# Install Java and other dependencies
RUN apt-get update && apt-get install -y \
    openjdk-17-jre \
    curl \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# TAK Server version
ENV TAK_VERSION=5.4.0

# Create tak user
RUN useradd -m -s /bin/bash tak

# TAK Server installation directory
ENV TAK_HOME=/opt/tak
RUN mkdir -p ${TAK_HOME} && chown -R tak:tak ${TAK_HOME}

WORKDIR ${TAK_HOME}

# Note: You need to place takserver-docker-distro-X.X.X.zip in the build context
# Download from official TAK government sources
# COPY takserver-docker-distro-${TAK_VERSION}.zip /tmp/

# Uncomment the following after placing the distribution file:
# RUN unzip /tmp/takserver-docker-distro-${TAK_VERSION}.zip -d ${TAK_HOME} && \
#     rm /tmp/takserver-docker-distro-${TAK_VERSION}.zip

# Copy configuration
COPY config /opt/tak/config
COPY data /opt/tak/data

# Set ownership
RUN chown -R tak:tak ${TAK_HOME}

# Switch to tak user
USER tak

# Expose ports
EXPOSE 8089 8443 8080 8443

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8089/status || exit 1

# Start TAK Server
CMD ["/opt/tak/start-tak.sh"]
