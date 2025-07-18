#!/bin/bash

set -e

APP_NAME="Stockify"
APP_DIR="$HOME/.local/share/$APP_NAME"
DESKTOP_FILE="$HOME/.local/share/applications/stockify.desktop"
BIN_LINK="$HOME/.local/bin/stockify"

echo "🧹 Uninstalling $APP_NAME..."

# Remove app files
if [ -d "$APP_DIR" ]; then
    rm -rf "$APP_DIR"
    echo "🗑️ Removed application directory: $APP_DIR"
else
    echo "ℹ️ Application directory not found: $APP_DIR"
fi

# Remove .desktop file
if [ -f "$DESKTOP_FILE" ]; then
    rm "$DESKTOP_FILE"
    echo "🗑️ Removed desktop entry: $DESKTOP_FILE"
else
    echo "ℹ️ Desktop entry not found: $DESKTOP_FILE"
fi

# Remove binary symlink
if [ -L "$BIN_LINK" ]; then
    rm "$BIN_LINK"
    echo "🗑️ Removed binary link: $BIN_LINK"
else
    echo "ℹ️ Binary link not found: $BIN_LINK"
fi

echo "✅ $APP_NAME has been fully uninstalled."
