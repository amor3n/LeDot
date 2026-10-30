{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs;
      [
        # ? - Free Vpn
        cloudflare-warp

      ];
  };
}

/* --------------------
   Module Description
   --------------------

  installing the package Cloudflare WARP VPN package alone does not start
   entry since it ships its own daemon (warp-svc) that must be
   the VPN tunnel.

   Post-install setup required:
     systemctl status warp-svc          # check if the unit exists/is running
     sudo systemctl enable --now warp-svc   # enable + start it if not

   Once enabled, warp-cli can be used to configure and connect the
   tunnel.
*/