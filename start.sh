#!/bin/bash

# Start FileBrowser in the background
filebrowser --database /database.db --root /srv --address 0.0.0.0 --port $FILEBROWSER_PORT &

# Start OpenCode Web in the foreground
opencode web --hostname 0.0.0.0 --port $OPENCODE_SERVER_PORT
