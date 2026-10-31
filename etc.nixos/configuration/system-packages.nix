/*
  --------------------
  Module Description
  --------------------

  Global system package list, applied across all target systems
  (not device-specific — see Gpd-Duo/system-packages.nix for that).

  Covers baseline tooling every machine is expected to have regardless
  of target: Wayland/niri session utilities, hardware/power CLI tools,
  video playback, system monitoring, archive handling, core networking
  clients, shell utilities, and the GTK/Qt runtime libraries required for
  GUI apps to render correctly under Wayland/niri.
*/

{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      # !----------------------------------
      # ! Wayland / Desktop Session
      # !-----------------------------------------------------------------------------------------------------------------------
      # ? - Application launcher
      fuzzel
      # ? - Notification daemon
      mako
      # ? - Idle management daemon
      swayidle
      # ? - Screen locker
      swaylock

      # !----------------------------------
      # ! Hardware / Power
      # !-----------------------------------------------------------------------------------------------------------------------
      # ? - CLI battery status
      acpi
      # ? - Adjust screen/backlight brightness
      brightnessctl
      # ? - Hardware info utilities like lspci
      pciutils

      # !----------------------------------
      # ! Audio / Video
      # !-----------------------------------------------------------------------------------------------------------------------
      # ? - Video Player
      mpv

      # !----------------------------------
      # ! System Monitoring
      # !-----------------------------------------------------------------------------------------------------------------------
      # ? - System monitoring and resource viewer
      btop
      # ? - Interactive process viewer
      htop
      # ? - JSON processor
      jq
      # ? - List open files and associated processes
      lsof
      # ? - Hardware and BIOS/SMBIOS information tool
      dmidecode

      # !----------------------------------
      # ! Browser
      # !-----------------------------------------------------------------------------------------------------------------------
      # ? - Web browser
      librewolf
      # ? - Onion Routing Web browser
      tor-browser

      # !----------------------------------
      # ! Social
      # !-----------------------------------------------------------------------------------------------------------------------
      # ? - Discord  ┐( ˘_˘)┌
      discord

      # !----------------------------------
      # ! Terminal
      # !-----------------------------------------------------------------------------------------------------------------------
      # ? - GPU-accelerated terminal emulator
      alacritty

      # !----------------------------------
      # ! Shell
      # !-----------------------------------------------------------------------------------------------------------------------
      # ? - Modern replacement for ls
      eza
      # ? - Simple, fast alternative to find
      fd
      # ? - Fast grep alternative
      ripgrep
      # ? - Cross-shell prompt and customizer
      starship

      # !----------------------------------
      # ! Archives
      # !-----------------------------------------------------------------------------------------------------------------------
      # ? - File archiver for 7z and other formats
      p7zip

      # !----------------------------------
      # ! Bluetooth
      # !-----------------------------------------------------------------------------------------------------------------------
      # ? - bluetooth tui
      bluetui

      # !----------------------------------
      # ! Networking
      # !-----------------------------------------------------------------------------------------------------------------------
      # ? - Network data transfer tool
      curl
      # ? - Command-line network downloader
      wget
      # ? - Domain and IP registration information lookup
      whois

      # !----------------------------------
      # ! Shell
      # !-----------------------------------------------------------------------------------------------------------------------
      # ? - clipboard access (wl-copy/wl-paste) - lots of scripts assume this exists
      wl-clipboard
      # ? - Display directory tree structure
      tree
      # ? - Core system utilities (dmesg, lsblk, fdisk, etc.)
      util-linux

      # !----------------------------------
      # ! Gui Dependencies
      # !-----------------------------------------------------------------------------------------------------------------------
      # ? - icon theme, GTK apps look iconless without it
      adwaita-icon-theme
      # ? - Accessibility toolkit
      atk
      # ? - 2D graphics library
      cairo
      # ? - Core application building blocks
      glib
      # ? - Desktop settings schemas
      gsettings-desktop-schemas
      # ? - GTK 3 toolkit
      gtk3
      # ? - GTK 4 toolkit
      gtk4
      # ? - Text rendering library
      pango
      # ? - Qt app theming (GTK's counterpart)
      qt6Packages.qt6ct
      # ? - Xwayland rootless integration
      xwayland-satellite
    ];
  };
}
