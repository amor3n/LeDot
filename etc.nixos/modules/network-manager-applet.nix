{ config, pkgs, lib, ... }:

{
  environment = {
    systemPackages = with pkgs; [
        # ? - TUI wifi interface
        networkmanagerapplet
      ];
    };

  networking.networkmanager.enable = lib.mkForce true;
}

/* --------------------
   Module Description
   --------------------

   NetworkManager setup, split into two required parts — the applet
   alone does not provide networking.

   - networking.networkmanager.enable = lib.mkForce true
     Enables and starts the NetworkManager daemon, which handles the
     actual network connections (wifi, ethernet, VPN profiles, etc.).
     Forced with mkForce to override any lower-priority networking
     backend set elsewhere.
     
   - networkmanagerapplet
     TUI/tray interface for interacting with NetworkManager — lets
     you view/connect to networks, but is non-functional without the
     daemon above running.

   Without networking.networkmanager.enable, the applet package would
   be installed but have nothing to connect to.
*/