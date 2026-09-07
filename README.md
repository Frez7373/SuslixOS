# SuslixOS

**SuslixOS** is a desktop-oriented operating system for CC:Tweaked, inspired by the architecture and ideas of OpusOS, OneOS, CloverOS and the wider ComputerCraft ecosystem.

## What is included

- Windows-style desktop and Start menu
- Keyboard shortcuts and mouse/monitor-touch interaction
- Terminal and file manager
- System monitor and detailed system information
- Device/peripheral browser
- Network and Rednet tools
- Calculator and clock
- Process manager built around CC:Tweaked multishell
- Turtle control panel
- Help Center
- Package Center with optional open-source integrations
- Recovery files and automatic startup backup during installation
- Modular `/apps`, `/lib`, and `/sys` layout

## Install

Run on a CC:Tweaked computer with HTTP enabled:

```text
wget run https://raw.githubusercontent.com/Frez7373/SuslixOS/main/installer.lua
```

The installer backs up the current `/startup.lua` to `/suslix/backup/startup.lua` before replacing it.

## Open-source ecosystem used as references/integrations

OpusOS provided the inspiration for networking, remote access, UI, file management and turtle-oriented functionality. Its documented features include multitasking, Telnet, VNC, remote filesystem access, a GUI, file manager and A* turtle pathfinding.

OneOS demonstrates a strong tab-oriented desktop model, application store, file browser, peripheral browser, package/archive handling and auto-updating design.

CloverOS demonstrates a modern Windows-like CC:Tweaked desktop approach and a network installer.

The Package Center optionally integrates open-source projects including Basalt 2, Pixelbox Lite, Artist, MBS and Telem. These projects remain external upstream projects; SuslixOS does not claim ownership of their code.

## Credits / references

- OpusOS — `kepler155c/opus`
- OneOS — `oeed/OneOS`
- CloverOS — `PalorderSoftWorksOfficial/CloverOS`
- Basalt 2 — `Pyroxenium/Basalt2`
- Pixelbox Lite — `9551-Dev/pixelbox_lite`
- Artist — `SquidDev-CC/artist`
- Mildly Better Shell — `SquidDev-CC/mbs`
- Telem — `cyberbit/telem`

## Roadmap

The next major SuslixOS layer is intended to add real windowed multitasking, background services, inter-computer remote desktop/shell, an A* turtle navigation service, app manifests and versioned package updates, monitor-optimized UI, notifications, user profiles and a larger application catalogue.

SuslixOS targets CC:Tweaked rather than replacing the underlying Minecraft mod. It is designed to run on top of CraftOS APIs and remain modular.
