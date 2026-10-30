{ config, pkgs, lib, ... }:

{
  environment = {
    systemPackages = with pkgs;
      [
        # ? - Vulkan utilities and diagnostics
        vulkan-tools
      ];
  };

  hardware.graphics.enable = lib.mkForce true;
}

/* --------------------
   Module Description
   --------------------

   Vulkan diagnostic tooling.

   - hardware.graphics.enable = lib.mkForce true
     Enables the graphics driver stack (Mesa/loader), forced to
     override any lower-priority setting elsewhere. This is what
     lets vulkaninfo/vkcube actually find a GPU device to talk to.
     
   - vulkan-tools
     Provides vulkaninfo, vkcube, and other Vulkan diagnostic/testing
     binaries.

   Without hardware.graphics.enable, vulkan-tools would be installed
   but vulkaninfo would report zero available devices.
*/