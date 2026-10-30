{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs;
      [
        # ? - Hardware info utilities like lspci
        lm_sensors
      ];
  };
}

/* --------------------
   Module Description
   --------------------

   lm_sensors package for hardware temperature/fan/voltage monitoring.

   May require a one-time interactive detection step before showing
   full output — installing the package alone only gets you the
   binaries:
     sudo sensors-detect

   sensors-detect probes hardware and reports which kernel module(s)
   to load, if any are found. If it does find something, add the
   module declaratively so it loads automatically on every boot:
     boot.kernelModules = [ "it87" ];  # example — actual module name(s)
                                        # depend on what sensors-detect
                                        # reports for this hardware

   Note: on laptops, sensors-detect commonly finds nothing over I2C/
   SMBus, since thermal management is handled by the embedded
   controller via ACPI rather than exposed sensor chips. This does
   NOT mean lm_sensors is non-functional — CPU (k10temp), GPU
   (amdgpu), NVMe, WiFi, ACPI thermal zone, and battery sensors are
   often already exposed automatically via standard PCI/ACPI kernel
   drivers, with zero setup required. Run `sensors` directly to check
   before assuming setup is needed.
*/