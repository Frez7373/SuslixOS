# SuslixOS 2.0.0

**SuslixOS** is a desktop operating system for CC:Tweaked, inspired by OpusOS, OneOS, CloverOS and the wider ComputerCraft ecosystem.

## 2.0.0

- Animated startup screen
- Multi-user login and per-user passwords
- User switching and password management
- Windows/task style multitasking through `multishell`
- Task Manager
- Persistent settings
- Universal Home navigation button in the shared UI
- Desktop shortcuts and custom user applications
- Package Center and open-source integrations
- Terminal, Files, Network, Devices, Monitor, Calculator, Clock, Help and Turtle tools
- Recovery and automatic startup backup

## Install / update

Run on a CC:Tweaked computer with HTTP enabled:

```text
wget run https://raw.githubusercontent.com/Frez7373/SuslixOS/main/installer.lua
```

The installer backs up the previous `/startup.lua` to `/suslix/backup/startup.lua` and installs the complete 2.0 system.

## Custom applications

Open **My Apps** and choose **Add app**. SuslixOS can copy a `.lua` application from the computer or download one from a URL. User applications are stored under `/suslix/user_apps/` and are included in the desktop application list.

## References / integrations

- OpusOS — `kepler155c/opus`
- OneOS — `oeed/OneOS`
- CloverOS — `PalorderSoftWorksOfficial/CloverOS`
- Basalt 2 — `Pyroxenium/Basalt2`
- Pixelbox Lite — `9551-Dev/pixelbox_lite`
- Artist — `SquidDev-CC/artist`
- Mildly Better Shell — `SquidDev-CC/mbs`
- Telem — `cyberbit/telem`

Upstream projects remain their own projects; SuslixOS does not claim ownership of their code.
