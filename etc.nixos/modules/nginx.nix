{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs;
      [
        # ? - High-performance HTTP and reverse proxy server
        nginx
      ];
  };

  services.nginx.enable = true;
}

/* --------------------
   Module Description
   --------------------

   Nginx web/reverse-proxy server setup.

   - services.nginx.enable = true
     Enables and starts the nginx service. Installing the nginx
     package alone does not start the server — this option is
     required for it to actually run.
     
   - nginx package
     Provides the nginx binary and CLI tooling.

   Note: with no virtualHosts or server blocks configured elsewhere,
   nginx will start with its default configuration and serve nothing
   meaningful. Actual site/proxy configuration needs to be declared
   separately (e.g. services.nginx.virtualHosts).
*/