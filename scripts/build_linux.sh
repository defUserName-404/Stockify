#!/bin/bash

set -e

# === Config ===
FRONTEND_DIR="stockify_app_flutter"
BACKEND_DIR="stockify_backend_golang"
DIST_DIR="dist"
APP_NAME="Stockify"
APP_EXEC="$APP_NAME"
LIB_NAME="libinventory.*"

# === Parse args ===
if [[ "$1" == "--install" ]]; then
  INSTALL_AFTER=true
fi

# Spinner function
wait_for() {
    local pid=$1
    local name=$2
    local spin='|/-\'
    local i=0

    echo "⏳ Waiting for $name..."

    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${spin:$i:1} $name..."
        sleep 0.1
    done

    wait $pid
    local status=$?
    if [ $status -ne 0 ]; then
        echo -e "\n❌ $name failed!"
        exit $status
    fi

    echo -e "\n✅ $name finished"
}

echo "🚀 Building $APP_NAME..."

# === Step 1: Get Version ===
echo "🔍 Getting version from pubspec.yaml..."
APP_VERSION=$(grep 'version:' "$FRONTEND_DIR/pubspec.yaml" | awk '{print $2}' | cut -d'+' -f1)

if [ -z "$APP_VERSION" ]; then
    echo "❌ Version not found in pubspec.yaml"
    exit 1
fi
echo "✅ Version found: $APP_VERSION"

TAR_NAME="${APP_NAME}-linux-v${APP_VERSION}.tar.gz"
APP_OUT_DIR="$DIST_DIR/$APP_NAME"

# === Step 2: Build Flutter App ===
echo "📦 Starting Flutter build..."
cd "$FRONTEND_DIR"
flutter build linux --release &
FLUTTER_PID=$!
cd ..

# === Step 3: Build Go backend ===
echo "🔨 Starting Go backend build..."
cd "$BACKEND_DIR"
GOOS=linux GOARCH=amd64 go build -o libinventory.so -buildmode=c-shared ./src &
GO_PID=$!
cd ..

# === Wait for builds to complete ===
wait_for $FLUTTER_PID "Flutter build"
wait_for $GO_PID "Go backend build"

# === Step 4: Package Files ===
echo "📁 Setting up distribution directory..."
rm -rf "$APP_OUT_DIR"
mkdir -p "$APP_OUT_DIR/lib"

cp -r "$FRONTEND_DIR/build/linux/x64/release/bundle/"* "$APP_OUT_DIR/"
shopt -s nullglob
for file in "$BACKEND_DIR"/$LIB_NAME; do
  mv "$file" "$APP_OUT_DIR/lib/"
done
shopt -u nullglob

# === Step 5: Create .desktop file ===
cat > "$APP_OUT_DIR/stockify.desktop" <<EOF
[Desktop Entry]
Name=Stockify
Description=Inventory Management System
GenericName=Inventory Management System
Version=$APP_VERSION
Keywords=Stockify;Inventory;Management;System
Exec=\${HOME}/.local/share/Stockify/$APP_EXEC
Icon=stockify
Type=Application
Categories=Utility;Office
StartupWMClass=Stockify
StartupNotify=true
EOF

# === Step 6: Installer Script ===
cat > "$APP_OUT_DIR/install.sh" <<'EOF'
#!/bin/bash
set -e

APP_DIR="$HOME/.local/share/Stockify"
DESKTOP_FILE="$HOME/.local/share/applications/stockify.desktop"
BIN_LINK="$HOME/.local/bin/stockify"

echo "📦 Installing Stockify to $APP_DIR..."

# Get the directory where the installer script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$APP_DIR"
cp -r "$SCRIPT_DIR"/* "$APP_DIR"

mkdir -p "$(dirname "$DESKTOP_FILE")"
cp "$SCRIPT_DIR/stockify.desktop" "$DESKTOP_FILE"

mkdir -p "$(dirname "$BIN_LINK")"
ln -sf "$APP_DIR/Stockify" "$BIN_LINK"

# Install icon to system location (optional)
if [ -f "$APP_DIR/data/flutter_assets/assets/icons/icon.png" ]; then
    mkdir -p "$HOME/.local/share/icons/hicolor/48x48/apps/"
    cp "$APP_DIR/data/flutter_assets/assets/icons/icon.png" "$HOME/.local/share/icons/hicolor/48x48/apps/stockify.png"
fi

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$HOME/.local/share/applications/"
fi

echo "✅ Installed successfully."
echo "📌 Run with: stockify"
EOF

chmod +x "$APP_OUT_DIR/install.sh"

# === Step 7: Package as tar.gz ===
echo "📦 Creating $TAR_NAME..."
cd "$DIST_DIR"
tar -czf "$TAR_NAME" "$APP_NAME"
cd ..

echo "🎉 Package created at $DIST_DIR/$TAR_NAME"

# === Step 8: Optional Installation ===
if $INSTALL_AFTER; then
  echo "📌 Running installer script..."
  cd "$APP_OUT_DIR"
  ./install.sh
  cd ../..  # Go back to original directory
  echo "✅ Installation complete. Package remains at $DIST_DIR/$TAR_NAME"
else
  echo "🎉 Done! Package created at $DIST_DIR/$TAR_NAME"
fi
