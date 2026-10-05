FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install OpenCode
RUN curl -fsSL https://opencode.ai/install | bash
ENV PATH="/root/.opencode/bin:${PATH}"

# Install FileBrowser (corrected URL)
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# Create the workspace directory (Railway volume will be mounted here)
RUN mkdir -p /srv

# Copy and prepare the start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Environment variables
ENV OPENCODE_SERVER_HOSTNAME=0.0.0.0
ENV OPENCODE_SERVER_PORT=4096
ENV FILEBROWSER_PORT=8080

EXPOSE 4096 8080

CMD ["/start.sh"]
