#!/usr/bin/env bash
set -euo pipefail

if [[ "$EUID" -eq 0 && -n "${SUDO_USER:-}" ]]; then
  echo "Error: Please run this script as your normal user, not via sudo." >&2
  exit 1
fi

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6 2>/dev/null || echo "$HOME")

INSTALL_DIR="${1:-$REAL_HOME/.local/bin}"
mkdir -p "$INSTALL_DIR"

REPO_BASE="https://raw.githubusercontent.com/dyokism/dns-switch/main/src"

get_file() {
  local filename="$1"
  local target="$2"
  
  if [[ -f "$filename" ]]; then
    cp "$filename" "$target"
  elif [[ -f "$(dirname "$0")/$filename" ]]; then
    cp "$(dirname "$0")/$filename" "$target"
  else
    echo "Downloading $filename..."
    if command -v curl >/dev/null 2>&1; then
      curl -sSL "$REPO_BASE/$filename" -o "$target"
    elif command -v wget >/dev/null 2>&1; then
      wget -qO "$target" "$REPO_BASE/$filename"
    else
      echo "Error: curl or wget required to download files." >&2
      exit 1
    fi
  fi
}

get_file "dns-switch" "$INSTALL_DIR/dns-switch"
chmod +x "$INSTALL_DIR/dns-switch"

mkdir -p "$REAL_HOME/.config/dns-switch"
if [[ ! -f "$REAL_HOME/.config/dns-switch/providers.conf" ]]; then
  get_file "providers.conf" "$REAL_HOME/.config/dns-switch/providers.conf"
fi

echo "Installed dns-switch to $INSTALL_DIR"
"$INSTALL_DIR/dns-switch" install
