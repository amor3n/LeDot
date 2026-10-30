/*
--------------------
Module Description
--------------------

Networking identity and firewall configuration for the Gpd-Duo.

- Sets the system hostname to "CyberDeckDuo".
- Enables the firewall, with explicit TCP ports opened for local
  development/services:
    6969 — custom/dev service port
    8080 — common alt-HTTP / dev server port
    8000 — common dev server port (e.g. Node, Python http.server, etc.)

All other inbound ports remain blocked by default since the firewall
stays enabled; only the listed ports are exposed.
*/

{ config, pkgs, ... }:

{
  networking.hostName = "CyberDeckDuo";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 6969 8080 8000 ];
  };
}
