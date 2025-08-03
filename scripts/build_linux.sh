#!/bin/bash
set -e

echo -e "

"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    🏭 Stockify Linux Builder 🏭                    ║"
echo "║              Building your awesome app! 🎯                   ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "
"

# === Config ===
FRONTEND_DIR="stockify_app_flutter"
BACKEND_DIR="stockify_backend_golang"
DIST_DIR="dist"
APP_NAME="Stockify"
APP_EXEC="$APP_NAME"
LIB_NAME="libinventory.*"

# Spinner function
wait_for() {
    local pid=$1
    local name=$2
    local spin='|/-\'
    local i=0
    echo -n "⏳ Waiting for $name... "
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf '\r%s Waiting for $name...' "${spin:$i:1}"
        sleep 0.1
    done
    wait $pid
    local status=$?
    if [ $status -ne 0 ]; then
        printf "❌ $name failed! 
"
        exit $status
    fi
    printf "✅ $name finished successfully! 
"
}

echo "═══════════════════════════════════════════════════════════════"
echo "📖 STEP 1: Reading version from pubspec.yaml"
echo "═══════════════════════════════════════════════════════════════"
APP_VERSION=$(grep 'version:' "$FRONTEND_DIR/pubspec.yaml" | awk '{print $2}' | cut -d'+' -f1)
if [ -z "$APP_VERSION" ]; then
    echo "❌ Version not found in pubspec.yaml"
    exit 1
fi
echo "✅ Version found: $APP_VERSION"
echo -e "
"

TAR_NAME="${APP_NAME}-linux-v${APP_VERSION}.tar.gz"
APP_OUT_DIR="$DIST_DIR/$APP_NAME"

# Build Steps in Parallel
echo "═══════════════════════════════════════════════════════════════"
echo "🚀 STEP 2 & 3: Starting Parallel Builds (Frontend & Backend)"
echo "═══════════════════════════════════════════════════════════════"

# Build Flutter App
echo "🦋 Building Flutter App (Release)..."
cd "$FRONTEND_DIR"
flutter build linux --release &
FLUTTER_PID=$!
cd ..

# Build Go backend
echo "🐹 Building Go Backend (Shared Library)..."
cd "$BACKEND_DIR"
GOOS=linux GOARCH=amd64 go build -o libinventory.so -buildmode=c-shared ./src &
GO_PID=$!
cd ..

# Wait for builds to complete
wait_for $FLUTTER_PID "Flutter build"
wait_for $GO_PID "Go backend build"
echo -e "
"

# === Step 4: Package Files ===
echo "═══════════════════════════════════════════════════════════════"
echo "📁 STEP 4: Packaging Files"
echo "═══════════════════════════════════════════════════════════════"
rm -rf "$APP_OUT_DIR"
mkdir -p "$APP_OUT_DIR/lib"
echo "✅ Cleaned and created distribution directory."

cp -r "$FRONTEND_DIR/build/linux/x64/release/bundle/"* "$APP_OUT_DIR/"
echo "✅ Copied Flutter build output."

shopt -s nullglob
for file in "$BACKEND_DIR"/$LIB_NAME; do
  mv "$file" "$APP_OUT_DIR/lib/"
done
shopt -u nullglob
echo "✅ Moved Go backend library."
echo -e "
"

# === Step 5: Create .desktop file ===
echo "═══════════════════════════════════════════════════════════════"
echo "📝 STEP 5: Creating .desktop file"
echo "═══════════════════════════════════════════════════════════════"
cat > "$APP_OUT_DIR/stockify.desktop" <<EOF
[Desktop Entry]
Name=Stockify
Description=Inventory Management System
GenericName=Inventory Management System
Version=$APP_VERSION
Keywords=Stockify;Inventory;Management;System
Exec=$HOME/.local/share/Stockify/$APP_EXEC
Icon=stockify
Type=Application
Categories=Utility;Office
StartupWMClass=Stockify
StartupNotify=true
EOF
echo "✅ .desktop file created."
echo -e "
"

# === Step 6: Create Installer Script ===
echo "═══════════════════════════════════════════════════════════════"
echo "📜 STEP 6: Creating Installer Script"
echo "═══════════════════════════════════════════════════════════════"
cat > "$APP_OUT_DIR/install.sh" <<'EOF'
#!/bin/bash
set -e
echo -e "
"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                   📦 Stockify Installer 📦                   ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "
"

APP_DIR="$HOME/.local/share/Stockify"
DESKTOP_FILE="$HOME/.local/share/applications/stockify.desktop"
BIN_LINK="$HOME/.local/bin/stockify"

echo "🚀 Installing Stockify to $APP_DIR..."

# Get the directory where the installer script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$APP_DIR"
cp -r "$SCRIPT_DIR"/* "$APP_DIR"
echo "✅ Application files copied."

mkdir -p "$(dirname "$DESKTOP_FILE")"
cp "$SCRIPT_DIR/stockify.desktop" "$DESKTOP_FILE"
echo "✅ Desktop entry created."

mkdir -p "$(dirname "$BIN_LINK")"
ln -sf "$APP_DIR/Stockify" "$BIN_LINK"
echo "✅ Binary link created."

# Install icon to system location
if [ -f "$APP_DIR/data/flutter_assets/assets/icons/icon.png" ]; then
    ICON_DIR="$HOME/.local/share/icons/hicolor/48x48/apps/"
    mkdir -p "$ICON_DIR"
    cp "$APP_DIR/data/flutter_assets/assets/icons/icon.png" "$ICON_DIR/stockify.png"
    echo "✅ Icon installed."
fi

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$HOME/.local/share/applications/"
    echo "✅ Desktop database updated."
fi

echo -e "
🎉 Stockify installed successfully! 🎉"
echo "You can now run the application by typing 'stockify' in your terminal."
EOF
chmod +x "$APP_OUT_DIR/install.sh"
echo "✅ Installer script created and made executable."
echo -e "
"

# === Step 7: Create Uninstaller Script ===
echo "═══════════════════════════════════════════════════════════════"
echo "🗑️ STEP 7: Creating Uninstaller Script"
echo "═══════════════════════════════════════════════════════════════"
cat > "$APP_OUT_DIR/uninstall.sh" <<'EOF'
#!/bin/bash
set -e
echo -e "
"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                 🗑️ Stockify Uninstaller 🗑️                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "
"

APP_NAME="Stockify"
APP_DIR="$HOME/.local/share/$APP_NAME"
DESKTOP_FILE="$HOME/.local/share/applications/stockify.desktop"
BIN_LINK="$HOME/.local/bin/stockify"
ICON_FILE="$HOME/.local/share/icons/hicolor/48x48/apps/stockify.png"
DELETE_DATA=false

# Parse arguments
if [[ "$1" == "--delete-data" ]]; then
  DELETE_DATA=true
fi

echo "Uninstalling $APP_NAME..."

# Handle data directory
if [ -d "$APP_DIR" ]; then
    if [ "$DELETE_DATA" = true ]; then
        read -p "❓ Are you sure you want to delete all application data? This cannot be undone. (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🔥 Deleting entire application directory (including data)..."
            rm -rf "$APP_DIR"
            echo "✅ Removed: $APP_DIR"
        else
            echo "🛑 Uninstallation cancelled by user."
            exit 0
        fi
    else
        echo "🗑️ Deleting application files but preserving database..."
        find "$APP_DIR" -mindepth 1 ! -name 'inventory.db' -delete
        echo "✅ Application files removed. Database preserved in: $APP_DIR"
    fi
else
    echo "ℹ️ Application directory not found, skipping."
fi

# Remove .desktop file
if [ -f "$DESKTOP_FILE" ]; then
    rm "$DESKTOP_FILE"
    echo "✅ Removed desktop entry."
else
    echo "ℹ️ Desktop entry not found, skipping."
fi

# Remove binary symlink
if [ -L "$BIN_LINK" ]; then
    rm "$BIN_LINK"
    echo "✅ Removed binary link."
else
    echo "ℹ️ Binary link not found, skipping."
fi

# Remove icon
if [ -f "$ICON_FILE" ]; then
    rm "$ICON_FILE"
    echo "✅ Removed icon."
else
    echo "ℹ️ Icon not found, skipping."
fi

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$HOME/.local/share/applications/"
    echo "✅ Desktop database updated."
fi

echo -e "
🎉 $APP_NAME has been successfully uninstalled. 🎉"
EOF
chmod +x "$APP_OUT_DIR/uninstall.sh"
echo "✅ Uninstaller script created and made executable."
echo -e "
"

# === Step 8: Package as tar.gz ===
echo "═══════════════════════════════════════════════════════════════"
echo "📦 STEP 8: Packaging into .tar.gz"
echo "═══════════════════════════════════════════════════════════════"
cd "$DIST_DIR"
tar -czf "$TAR_NAME" "$APP_NAME"
cd ..
echo "✅ Packaged successfully!"
echo -e "
"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                   🎉 BUILD COMPLETE! 🎉                    ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo "📦 Package created at: $DIST_DIR/$TAR_NAME"
echo "To install, extract the archive and run the install.sh script."
echo -e "
"