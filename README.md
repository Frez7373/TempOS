# TempOS 1.0.0

TempOS is a modular desktop operating system for CC:Tweaked on Minecraft 1.16.5.

## Highlights
- BIOS-style bootloader with hardware/filesystem/network checks and progress animation
- Recovery mode and safe-mode support from the existing TempOS core
- Touchscreen desktop with keyboard fallback
- Modular system services for networking, peripherals, processes and security
- Settings, File Manager, Terminal, Calculator, Clock, System Info, Task Manager, Text Editor, Devices, Network, Security and Updater apps
- External monitor support
- Modem, printer, speaker and disk-drive detection/testing
- Crash containment around application and desktop execution
- Persistent settings and logs under `/tempOS`
- One-command HTTP installer

## Requirements
- Minecraft 1.16.5
- CC:Tweaked
- Computer or Advanced Computer
- Optional monitor, modem, printer, speaker and disk drive

## Installation
Enable the CC:Tweaked HTTP API, then run:

```text
wget run https://raw.githubusercontent.com/Frez7373/TempOS/main/install.lua
```

The installer downloads the release manifest and all required files automatically.

## Recovery
Recovery is available through `boot/recovery.lua` and is entered automatically if the bootloader detects a critical startup failure.

## Project structure
- `boot/` — bootloader and recovery
- `system/` — kernel services
- `ui/` — theme, widgets and desktop
- `apps/` — user applications
- `bin/` — recovery helpers
- `config/`, `data/`, `tempOS/` — runtime data and logs

## Troubleshooting
Boot failures are logged to `/tempOS/logs/boot.log`. Application crashes are written to `/tempOS/logs/crash.log`. You can use recovery to inspect logs or repair the installation.

## License
MIT
