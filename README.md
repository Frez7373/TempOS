# TempOS

**TempOS 1.0.0** is a modular graphical operating system for CC:Tweaked targeting Minecraft 1.16.5.

## Highlights

- Bootloader with hardware/filesystem checks and recovery entry
- Modular kernel and event bus
- Touchscreen-aware desktop and GUI widgets
- External monitor detection
- Modem/network service with a unified API
- Peripheral/device manager
- Settings, File Manager, Terminal, Calculator, Clock
- System Information, Task Manager, Text Editor, Security
- Network and Updater applications
- Safe Mode and Recovery Mode
- Crash/boot logging
- One-command network installer

## Requirements

- Minecraft 1.16.5
- CC:Tweaked
- HTTP API enabled for installation and updates
- A standard Computer or Advanced Computer
- Optional: Monitor, Modem, Speaker, Printer, Disk Drive

## Installation

Run on a CC:Tweaked computer:

```text
wget run https://raw.githubusercontent.com/Frez7373/TempOS/main/install.lua
```

The installer downloads the release manifest, creates directories and installs the current TempOS release.

## Desktop controls

Touch or click application buttons. Keyboard is supported for terminal-style apps and recovery. `F4` requests shutdown from the desktop.

## Recovery

The bootloader can enter recovery after a failed startup. Recovery provides Normal Boot, Safe Mode, Repair, Factory Reset, Logs, Recovery Shell and shutdown paths.

## Architecture

```text
startup.lua
└── boot/boot.lua
    └── system/kernel.lua
        ├── system/events.lua
        ├── system/process.lua
        ├── system/network.lua
        ├── system/peripherals.lua
        └── ui/desktop.lua
            └── apps/*
```

## Applications

`settings`, `filemanager`, `terminal`, `calculator`, `clock`, `systeminfo`, `taskmanager`, `editor`, `security`, `devices`, `network`, `updater`.

## Troubleshooting

If networking does not work, enable the CC:Tweaked HTTP API and ensure the computer can access GitHub. If a monitor is unavailable, TempOS falls back to the computer terminal. Missing peripherals are treated as optional and should not prevent boot.

## Versioning

TempOS follows `MAJOR.MINOR.PATCH` release numbering.
