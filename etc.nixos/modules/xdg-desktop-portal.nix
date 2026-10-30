{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      # ? - Desktop integration portal
      xdg-desktop-portal
      # ? - wlroots backend for xdg-desktop-portal
      xdg-desktop-portal-wlr
    ];
  };

  xdg.portal = {
    config.common.default = "*";
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };
}

/* --------------------
   Module Description
   --------------------

   XDG Desktop Portal setup — enables sandboxed/portal-aware apps
   (screen sharing, screenshot tools, file pickers) to interact with
   the Wayland session.

   - xdg.portal.enable = true
     Enables the portal service itself.
   
   - xdg.portal.extraPortals = [ xdg-desktop-portal-wlr ]
     Registers the wlroots backend as an available portal
     implementation — required since xdg-desktop-portal alone has no
     backend, it just routes requests to whichever backend is
     registered.
     
   - xdg.portal.config.common.default = "*"
     Tells the portal to use any available backend by default when a
     specific one isn't requested, rather than requiring explicit
     per-interface backend configuration.
   
   - xdg-desktop-portal / xdg-desktop-portal-wlr packages
     The portal daemon and its wlroots-specific backend implementation.

   Note: xdg-desktop-portal-wlr covers screen capture/screenshot
   portals but not the file-chooser portal — GTK apps needing native
   file dialogs may also need xdg-desktop-portal-gtk registered
   alongside it if that becomes relevant later.
*/