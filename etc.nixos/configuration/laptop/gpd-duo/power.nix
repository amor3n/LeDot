/*

--------------------
Module Description
--------------------

Power management and hibernation configuration for the Gpd-Duo.

- Enables general power management and power-profiles-daemon, which
  provides the performance/balanced/power-saver profile switching
  used by desktop environments and power applets.

- Configures upower to trigger Hibernate automatically once battery
  drops to 10%, preventing dirty shutdowns from full battery drain.

- Kernel params:

    amd_pstate=active        — enables the active AMD P-State CPU
                                frequency scaling driver, for better
                                power/performance scaling on AMD silicon
                                than the older acpi-cpufreq driver.

    nvme_core.default_ps_max_latency_us=0
                              — disables NVMe drive power-state
                                transitions (APST), trading some power
                                savings for avoiding drive latency/
                                stutter or wake issues some NVMe
                                controllers have with aggressive power
                                states.

    resume_offset=452216832  — tells the kernel the exact offset of the
                                swapfile (used for hibernation) on disk,
                                required when hibernating to a swapfile
                                rather than a dedicated swap partition.

- boot.resumeDevice points the kernel at the disk containing the swap/
  hibernation image, by UUID, so it can resume from hibernation on boot.

Together, resume_offset + resumeDevice are what make the earlier
services.logind.settings.HandleLidSwitch = "hibernate" (in system.nix)
actually work correctly.

*/

{ config, pkgs, lib, ... }:

{
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  services.upower = {
    enable = true;
    percentageAction = 10;
    criticalPowerAction = "Hibernate";
  };

  boot.kernelParams = [
    "amd_pstate=active"
    "nvme_core.default_ps_max_latency_us=0"
  ] ;

  boot.resumeDevice = "/dev/disk/by-uuid/06fcb66f-beaa-42c7-bbba-2cefdd408dbb";
}


