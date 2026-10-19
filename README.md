# aidrax-framer-demo

AIDRAX Framer UI mit Neon, Avatar & LiveStatus.

## AIDRAX Neon Style

Dieses Projekt enthält ein minimales Beispiel für ein Interface im AIDRAX-Neon-Design. Öffne die Datei `index.html` in einem Browser, um die dunkle Oberfläche mit leuchtenden Akzentfarben zu sehen. Die zugehörigen Styles befinden sich in `aidrax-neon.css`.

## Script: automatischen Shutdown verhindern

Im Projekt liegt ein Script `prevent-auto-shutdown.sh`, das über `systemd-inhibit` automatische Shutdown-/Sleep-Trigger blockiert.

### Starten (dauerhaft bis Abbruch)

```bash
./prevent-auto-shutdown.sh
```

### Nur während eines Befehls blockieren

```bash
./prevent-auto-shutdown.sh -- <dein_befehl>
```

Beispiel:

```bash
./prevent-auto-shutdown.sh -- bash -c 'sleep 600'
```

### Autostart beim Login (sofort + dauerhaft)

Damit der Blocker direkt nach der Anmeldung startet und dauerhaft aktiv bleibt:

```bash
./prevent-auto-shutdown.sh --install-autostart
```

Der Befehl erstellt einen `systemd --user` Service, aktiviert ihn mit `enable --now` (startet also sofort) und setzt `Restart=always`.

Status prüfen:

```bash
systemctl --user status prevent-auto-shutdown.service
```

Autostart wieder entfernen:

```bash
./prevent-auto-shutdown.sh --remove-autostart
```


### Download / Ein-Klick-Installation

Wenn du das als Download-Skript nutzen willst, verwende:

```bash
./prevent-auto-shutdown-installer.sh
```

Das Installer-Skript kopiert den Blocker nach `/data2/prevent-auto-shutdown.sh` und aktiviert direkt den dauerhaften Login-Autostart.

Nur kopieren (ohne Autostart):

```bash
./prevent-auto-shutdown-installer.sh --copy-only
```
