{ config, pkgs, ... }:

{
  # ------------------------------------
  # Import Selection
  # ------------------------------------
  imports = [
    ./hardware-configuration.nix
    ./users
    ./configuration
  ];

  # ------------------------------------
  # Bootloader.
  # ------------------------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Nixos"; # Define your hostname.

  # ------------------------------------
  # Networking
  # ------------------------------------
  networking.networkmanager.enable = true;

  # ------------------------------------
  # TimeZone.
  # ------------------------------------
  time.timeZone = "Asia/Manila";

  # ------------------------------------
  # System Language
  # ------------------------------------
  i18n.defaultLocale = "en_PH.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_PH.UTF-8";
    LC_IDENTIFICATION = "en_PH.UTF-8";
    LC_MEASUREMENT = "en_PH.UTF-8";
    LC_MONETARY = "en_PH.UTF-8";
    LC_NAME = "en_PH.UTF-8";
    LC_NUMERIC = "en_PH.UTF-8";
    LC_PAPER = "en_PH.UTF-8";
    LC_TELEPHONE = "en_PH.UTF-8";
    LC_TIME = "en_PH.UTF-8";
  };

  # ------------------------------------
  # Keyboard Key-map
  # ------------------------------------
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  # ------------------------------------
  # System Configuration
  # ------------------------------------
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ------------------------------------
  # System Packages
  # ------------------------------------
  environment.systemPackages = with pkgs; [
    # Editor
    vscode
    # Browser
    librewolf
    # Utilities
    git
  ];

  system.stateVersion = "26.05";

}
