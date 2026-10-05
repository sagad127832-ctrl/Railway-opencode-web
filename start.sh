#!/bin/bash
set -e

# FileBrowser database lives on the persistent volume so settings/users survive redeploys
DB_PATH=/srv/.filebrowser.db

# Initialize FileBrowser on first run (volume is empty)
if [ ! -f "$DB_PATH" ]; then
    echo "==> Initializing FileBrowser database at $DB_PATH"
    filebrowser -d "$DB_PATH" config init
    filebrowser -d "$DB_PATH" config set --root /srv --address 0.0.0.0 --port "$FILEBROWSER_PORT"

    # Create the admin user from environment variables
    FB_USER="${FILEBROWSER_USER:-admin}"
    FB_PASS="${FILEBROWSER_PASSWORD:-adminadmin123}"

    echo "==> Creating FileBrowser admin user: $FB_USER"
    filebrowser -d "$DB_PATH" users add "$FB_USER" "$FB_PASS" --perm.admin
fi

# Start FileBrowser in the background
echo "==> Starting FileBrowser on port $FILEBROWSER_PORT"
filebrowser -d "$DB_PATH" --root /srv --address 0.0.0.0 --port "$FILEBROWSER_PORT" &

# Start OpenCode Web in the foreground (keeps the container alive)
echo "==> Starting OpenCode Web on port $OPENCODE_SERVER_PORT"
exec opencode web --hostname 0.0.0.0 --port "$OPENCODE_SERVER_PORT"
