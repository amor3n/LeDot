{ config, pkgs, ... }:

{

  environment = {
    systemPackages = with pkgs; [
      # ?-
      niri
      # ? Application Manager
      fuzzel
      # ? Terminal
      alacritty
      # ? - Screen locker 
      swaylock
      # ? -Idle management daemon
      swayidle
    ];
  };

  # programs.niri = { enable = false; };
}

/* --------------------
   Module Description
   --------------------

   Niri (scrollable-tiling Wayland compositor) session and core
   companion tools.

   - niri              — the compositor itself
   - fuzzel            — application launcher
   - alacritty         — terminal emulator
   - swaylock          — screen locker
   - swayidle          — idle management daemon

   programs.niri.enable is currently commented out — niri is being
   installed as a plain package rather than through the dedicated
   NixOS module. This means session integration niri's own module
   would normally provide (e.g. session file registration for display
   managers, PAM/polkit wiring) is not automatically set up; niri is
   likely being launched manually (e.g. from a TTY or greeter exec
   line) rather than selected from a display manager's session list.
*/
