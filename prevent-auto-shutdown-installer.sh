#!/usr/bin/env bash
set -euo pipefail

# One-click installer: installiert den Blocker nach /data2
# und aktiviert Autostart direkt + dauerhaft per systemd --user.

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_SCRIPT="$SRC_DIR/prevent-auto-shutdown.sh"
TARGET_DIR="/data2"
TARGET_SCRIPT="$TARGET_DIR/prevent-auto-shutdown.sh"

show_help() {
  cat <<USAGE
Nutzung:
  ./prevent-auto-shutdown-installer.sh [--copy-only] [-h|--help]

Optionen:
  --copy-only   Kopiert nur das Script nach /data2, ohne Autostart-Aktivierung
  -h, --help    Hilfe anzeigen
USAGE
}

COPY_ONLY="false"
case "${1:-}" in
  -h|--help)
    show_help
    exit 0
    ;;
  --copy-only)
    COPY_ONLY="true"
    ;;
esac

if [[ ! -f "$SRC_SCRIPT" ]]; then
  echo "Fehler: $SRC_SCRIPT wurde nicht gefunden." >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
cp "$SRC_SCRIPT" "$TARGET_SCRIPT"
chmod +x "$TARGET_SCRIPT"

if [[ "$COPY_ONLY" == "true" ]]; then
  echo "Script kopiert nach: $TARGET_SCRIPT"
  exit 0
fi

"$TARGET_SCRIPT" --install-autostart

echo ""
echo "Fertig. Der Shutdown-Blocker ist installiert und im Autostart aktiv."
echo "Installierter Pfad: $TARGET_SCRIPT"
echo "Status: systemctl --user status prevent-auto-shutdown.service"
