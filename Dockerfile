FROM debian:bookworm-slim

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install OpenCode using the official script
RUN curl -fsSL https://opencode.ai/install | bash

# Ensure the opencode binary is in the PATH
ENV PATH="/root/.opencode/bin:${PATH}"

# Set default environment variables for the web server
ENV OPENCODE_SERVER_HOSTNAME=0.0.0.0
ENV OPENCODE_SERVER_PORT=4096

# Expose the default port (Railway will override this with its own PORT variable)
EXPOSE 4096

# The command to start the web interface
CMD ["opencode", "web", "--hostname", "0.0.0.0", "--port", "4096"]
