/*
--------------------
Module Description
--------------------

Core hardware and base system configuration for the Gpd-Duo.

- Forces the hostname to "CyberDeckDuo" via lib.mkForce, overriding
  any lower-priority hostname set elsewhere (e.g. a global default).

- Enables redistributable firmware, required for AMD graphics/wifi/
  bluetooth blobs to load correctly.

- Enables AMD microcode updates (mkDefault, so it can still be
  overridden if needed) — patches CPU-level bugs/security issues at
  boot.

- Enables the graphics stack (Mesa/driver loading) with 32-bit support,
  which is what makes packages like vulkan-tools actually functional.

- Enables Bluetooth and has it power on automatically at boot.
- Configures libinput for the touchpad: tap-to-click and natural
  scrolling enabled.

- Sets lid-close behavior to Hibernate (paired with the hibernation
  setup in power.nix and swap.nix — resume_offset/resumeDevice there
  are what make this actually resume correctly instead of failing).

- Reduces console log verbosity to level 3 (quiet-ish, only errors/
  warnings shown) and passes "quiet" as a kernel param to suppress
  most boot-time logging for a cleaner boot screen.

This module is the device's hardware/identity foundation — audio,
networking ports, and power tuning are split into their own dedicated
files (audio.nix, networking.nix, power.nix) rather than living here.

*/

{ config, pkgs, lib, ... }:

{
  networking.hostName = lib.mkForce "CyberDeckDuo";

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = lib.mkDefault true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
    };
  };
  services.logind.settings = {
    Login = {
      HandleLidSwitch = "hibernate";
    };
  };

  boot.consoleLogLevel = 3;

  boot.kernelParams = [
  "quiet"
  "random.trust_cpu=0"
];
}
