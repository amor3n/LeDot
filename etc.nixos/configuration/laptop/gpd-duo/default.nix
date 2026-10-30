{ config, pkgs, ... }:

{
  imports = [
    ./power.nix
    ./display.nix
    ./networking.nix
    ./audio.nix
    ./system.nix
    ./system-packages.nix
    ./locale.nix
  ];
}

