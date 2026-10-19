#!/usr/bin/env bash
set -euo pipefail

# Verhindert automatische Shutdown-/Sleep-Trigger, solange dieses Skript läuft.
# Optional kann ein systemd User-Autostart eingerichtet werden.

SCRIPT_PATH="$(readlink -f "$0")"
WHAT="shutdown:sleep:idle"
WHO="AutoShutdownBlocker"
WHY="Automatischen Shutdown/Sleep verhindern"
MODE="block"
UNIT_NAME="prevent-auto-shutdown.service"
UNIT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
UNIT_PATH="$UNIT_DIR/$UNIT_NAME"

require_inhibit() {
  if ! command -v systemd-inhibit >/dev/null 2>&1; then
    echo "Fehler: systemd-inhibit wurde nicht gefunden." >&2
    echo "Tipp: Auf nicht-systemd-Systemen ein alternatives Tool wie caffeinate (macOS) nutzen." >&2
    exit 1
  fi
}

show_help() {
  cat <<USAGE
Nutzung:
  ./prevent-auto-shutdown.sh [OPTION] [--] [COMMAND ...]

Ohne COMMAND:
  Startet einen Blocker im Vordergrund. Mit Strg+C beenden.

Mit COMMAND:
  Führt den Befehl aus und blockiert Auto-Shutdown/Sleep nur währenddessen.

Optionen:
  --install-autostart   Installiert und aktiviert systemd User-Autostart (enable --now)
  --remove-autostart    Entfernt den systemd User-Autostart
  -h, --help            Hilfe anzeigen

Beispiele:
  ./prevent-auto-shutdown.sh
  ./prevent-auto-shutdown.sh -- bash -c 'echo job läuft; sleep 600'
  ./prevent-auto-shutdown.sh --install-autostart
USAGE
}

install_autostart() {
  require_inhibit
  mkdir -p "$UNIT_DIR"
  cat > "$UNIT_PATH" <<UNIT
[Unit]
Description=Prevent automatic shutdown/sleep after login
After=default.target

[Service]
Type=simple
ExecStart=$SCRIPT_PATH
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
UNIT

  systemctl --user daemon-reload
  systemctl --user enable --now "$UNIT_NAME"

  echo "Autostart aktiviert: $UNIT_PATH"
  echo "Service-Status prüfen mit: systemctl --user status $UNIT_NAME"
}

remove_autostart() {
  if command -v systemctl >/dev/null 2>&1; then
    systemctl --user disable --now "$UNIT_NAME" >/dev/null 2>&1 || true
    systemctl --user daemon-reload >/dev/null 2>&1 || true
  fi
  rm -f "$UNIT_PATH"
  echo "Autostart entfernt (falls vorhanden)."
}

main() {
  case "${1:-}" in
    -h|--help)
      show_help
      exit 0
      ;;
    --install-autostart)
      install_autostart
      exit 0
      ;;
    --remove-autostart)
      remove_autostart
      exit 0
      ;;
  esac

  if [[ "${1:-}" == "--" ]]; then
    shift
  fi

  require_inhibit

  if [[ "$#" -gt 0 ]]; then
    exec systemd-inhibit --what="$WHAT" --who="$WHO" --why="$WHY" --mode="$MODE" -- "$@"
  else
    echo "Auto-Shutdown/Sleep wird blockiert. Beende mit Strg+C ..."
    exec systemd-inhibit --what="$WHAT" --who="$WHO" --why="$WHY" --mode="$MODE" -- bash -c 'while :; do sleep 3600; done'
  fi
}

main "$@"
