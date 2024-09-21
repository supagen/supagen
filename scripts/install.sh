#!/usr/bin/env bash

# Function to log messages with date and time
log_message() {
    echo -e "$1"
}

# Detect OS and architecture
OS="$(uname -s)"
ARCH="$(uname -m)"

# Map OS name
case "$OS" in
  Linux*)  OS='linux' ;;
  Darwin*) OS='macos' ;;
  *)       log_message "Unsupported OS"; exit 1 ;;
esac

case "$ARCH" in
  x86_64)  ARCH='x64' ;;
  arm64)   ARCH='arm64' ;;
  armv7l)  ARCH='arm' ;;
  *)       log_message "Unsupported architecture"; exit 1 ;;
esac

# Terminal colors setup
Color_Off='\033[0m'       # Reset
Green='\033[0;32m'        # Green
Red='\033[0;31m'          

success() {
    log_message "${Green}$1${Color_Off}"
}

error() {
    log_message "${Red}error: $1${Color_Off}" >&2
    exit 1
}

# Log detected OS and architecture
log_message "Detected OS: $OS"
log_message "Detected Architecture: $ARCH"

# Check for curl
if ! command -v curl &> /dev/null; then
    error "curl is required but not installed."
fi

# Get installed supagen version if exists
INSTALLED_SUPAGEN_VERSION=""
if command -v supagen &> /dev/null; then
    INSTALLED_SUPAGEN_VERSION=$(supagen version 2>&1) || error "Failed to fetch installed supagen version."
fi

# Define the URL of the supagen binary
if [ -z "$1" ]; then
  SUPAGEN_VERSION=$(curl -s https://api.github.com/repos/supagen/supagen/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  if [ -z "$SUPAGEN_VERSION" ]; then
      error "Failed to fetch latest supagen version."
  fi
else
  SUPAGEN_VERSION="$1"
fi

log_message "Installing supagen version $SUPAGEN_VERSION."

# Setup installation directory and symlink
SUPAGEN_DIR="$HOME/.supagen"
SUPAGEN_DIR_BIN="$SUPAGEN_DIR/bin"
SYMLINK_TARGET="/usr/local/bin/supagen"

# Create supagen directory if it doesn't exist
mkdir -p "$SUPAGEN_DIR" || error "Failed to create supagen directory: $SUPAGEN_DIR."

# Check if SUPAGEN_DIR exists, and if it does delete it
if [ -d "$SUPAGEN_DIR_BIN" ]; then
    log_message "supagen bin directory already exists. Removing it."
    if ! rm -rf "$SUPAGEN_DIR_BIN"; then
        error "Failed to remove existing supagen directory: $SUPAGEN_DIR_BIN."
    fi
fi

# Download supagen
URL="https://github.com/supagen/supagen/releases/download/$SUPAGEN_VERSION/supagen-$SUPAGEN_VERSION-$OS-$ARCH.tar.gz"
if ! curl -L "$URL" -o supagen.tar.gz; then
    error "Download failed. Check your internet connection and URL: $URL"
fi


# Extract binary to the new location
if ! tar xzf supagen.tar.gz -C "$SUPAGEN_DIR" 2>&1; then
    error "Extraction failed. Check permissions and tar.gz file integrity."
fi

# Cleanup
if ! rm -f supagen.tar.gz; then
    error "Failed to cleanup"
fi

# Rename SUPAGEN_DIR/supagen to SUPAGEN_DIR/bin
if ! mv "$SUPAGEN_DIR/supagen" "$SUPAGEN_DIR_BIN"; then
    error "Failed to move supagen to bin directory."
fi

# Create a symlink
if ! sudo ln -sf "$SUPAGEN_DIR_BIN/supagen" "$SYMLINK_TARGET"; then
    error "Failed to create symlink."
fi

# Verify installation
if ! command -v supagen &> /dev/null; then
    error "Installation verification failed. supagen may not be in PATH or failed to execute."
fi

INSTALLED_SUPAGEN_VERSION=$(supagen version 2>&1) || error "Failed to verify installed supagen version."
success "supagen $INSTALLED_SUPAGEN_VERSION installed successfully."
