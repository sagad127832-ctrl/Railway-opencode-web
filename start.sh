#!/bin/bash
set -e

DB_PATH=/srv/.filebrowser.db

# Initialize FileBrowser on first run
if [ ! -f "$DB_PATH" ]; then
    echo "==> Initializing FileBrowser database"
    filebrowser -d "$DB_PATH" config init
    filebrowser -d "$DB_PATH" config set --root /srv --address 0.0.0.0 --port "$FILEBROWSER_PORT"

    FB_USER="${FILEBROWSER_USER:-admin}"
    FB_PASS="${FILEBROWSER_PASSWORD:-adminadmin123}"
    filebrowser -d "$DB_PATH" users add "$FB_USER" "$FB_PASS" --perm.admin
fi

# Start FileBrowser
echo "==> Starting FileBrowser on port $FILEBROWSER_PORT"
filebrowser -d "$DB_PATH" --root / --address 0.0.0.0 --port "$FILEBROWSER_PORT" &

# IMPORTANT: cd into /srv so OpenCode's project picker starts there
cd /srv

echo "==> Starting OpenCode Web on port $OPENCODE_SERVER_PORT (cwd: $(pwd))"
exec opencode web --hostname 0.0.0.0 --port "$OPENCODE_SERVER_PORT"
