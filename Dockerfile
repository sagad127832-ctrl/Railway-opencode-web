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

# Install FileBrowser (latest version)
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/filebrowser/master/get.sh | bash

# Set up FileBrowser directory and database
RUN mkdir -p /srv && \
    filebrowser config init --database /database.db && \
    filebrowser config set --root /srv --address 0.0.0.0 --port 8080

# Create a start script to run both services
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Environment variables
ENV OPENCODE_SERVER_HOSTNAME=0.0.0.0
ENV OPENCODE_SERVER_PORT=4096
ENV FILEBROWSER_PORT=8080

EXPOSE 4096 8080

CMD ["/start.sh"]
