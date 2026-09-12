# TempOS

A lightweight desktop-style operating system for CC:Tweaked 1.16.5.

## Install

Enable HTTP in the CC:Tweaked config, then run:

```lua
wget run https://raw.githubusercontent.com/Frez7373/TempOS/main/installer.lua
```

The installer creates `/tempOS`, installs the startup shim and reboots the computer.

## Compatibility

- CC:Tweaked 1.16.5 target
- Computer / Advanced Computer
- Monitor and monitor_touch when a monitor is attached
- Keyboard input
- Modem/rednet when available

TempOS deliberately does not use `require()`. Modules are loaded through `dofile()` from the TempOS tree and every application is isolated behind `pcall` so an application error can return to the desktop.

## Architecture

`startup` -> `tempOS/boot/loader.lua` -> `kernel/kernel.lua` -> system managers -> desktop -> applications.

Core managers include network, devices, settings, security, application management, logging, updates and recovery.

## Recovery

If the desktop or kernel fails, the bootloader provides Recovery Mode. Recovery can reset settings, inspect core files and perform a factory reset.

## Notes

TempOS uses only standard CC:Tweaked APIs and avoids assumptions about optional peripherals. Some advanced features, such as network communication or monitors, activate only when the corresponding hardware/API exists.
