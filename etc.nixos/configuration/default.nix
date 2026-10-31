{ config, pkgs, ... }:

{
  imports = [
    # !----------------
    # ! Configuration
    # !-----------------
    # ? - target system
    ./laptop/gpd-duo

    # ? - shell configuration
    ./alias.nix

    # ? - packages
    ./system-packages.nix
    ./user-packages.nix

    # ? - packages
    ./fonts.nix

    # !----------------
    # ! Module 
    # !-----------------
    # ? - display manager 
    ../modules/lm-sensors.nix
    # ? - display manager 
    ../modules/niri.nix

    # ? -  shell
    ../modules/zsh.nix
    ../modules/app-image.nix

    # ? -  networking 
    ../modules/network-manager-applet.nix
    ../modules/cloudflare-vpn.nix

    # ? -  development tools
    ../modules/github-cli.nix
    ../modules/docker.nix
    ../modules/nginx.nix
    ../modules/postgresql.nix

    # ????
    ../modules/polkit-gnome.nix

    # ? - video
    ../modules/vulkan-tools.nix

    # ? -  others
    ../modules/xdg-desktop-portal.nix
  ];
}
