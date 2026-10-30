{ config, pkgs, ... }:

{
    users.users.amor_iii = {
    isNormalUser = true;
    description = "Amor Novilunio III";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };
}

  # * ----------------------------------------------------------------------------
  # * ⚠️ Reminder:
  # * You must manually set the password for this user after install:
  # * sudo passwd amor_iii
  # * ----------------------------------------------------------------------------