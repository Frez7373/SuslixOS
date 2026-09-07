# SuslixOS

SuslixOS is a modern desktop-oriented operating system for CC:Tweaked, inspired by the architecture and feature set of OpusOS while being implemented as its own project.

## Install

On a fresh CC:Tweaked computer with the HTTP API enabled:

```text
wget run https://raw.githubusercontent.com/Frez7373/SuslixOS/main/installer.lua
```

The installer downloads the system files, creates the SuslixOS directory and config, then reboots the computer.

## Included

- Windows-like desktop and Start menu
- Touch/mouse UI support on advanced computers and monitors
- File Manager with keyboard and mouse selection
- Suslix Terminal
- Network Center: modem discovery, rednet and GPS tools
- Device Center: printer, speaker, redstone and peripheral tools
- System Monitor
- Settings
- Package Center / extension catalog
- CraftOS `edit` integration
- Suslix core UI and filesystem helper libraries

## Architecture direction

SuslixOS follows the practical strengths that made OpusOS notable: a GUI, multitasking-friendly design, networking, remote-management potential, filesystem tooling and turtle-oriented expansion.

## Open-source ecosystem integrations

The package catalog points to established CC:Tweaked projects such as Basalt/Basalt2, Pixelbox Lite and Artist. These are optional extensions so the base OS stays small and boots on a broad range of computers.

## Requirements

- CC:Tweaked
- HTTP API enabled for installation and online extensions
- Advanced Computer recommended for mouse/touch support

## Status

Version: 1.0.0-alpha
