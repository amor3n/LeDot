/* --------------------
   Module Description
   --------------------

   Global shell alias definitions and shortcut commands for navigating
   and managing the dotfiles/system config, plus quality-of-life
   overrides for common CLI tools.
   
*/

{ config, pkgs, ... }:

let
  # ? - Origin Paths
  dir-etc-nixos = "/etc/nixos";
  dir-home-config = "$HOME/.config";
  dir-scripts = "$HOME/LeDot/scripts";
  dir-dots = "$HOME/LeDot";

  # ? - Flags
  disable-gpu = "--disable-gpu";
  use-wayland = "--ozone-platform=wayland";
  enable-wayland-support = "--enable-features=UseOzonePlatform";

  # ? - Editor
  editor-flags = "${use-wayland} ${enable-wayland-support}";
  editor = "code ${editor-flags}";
in {
  # ? -
  environment.shellAliases = {

    # ? - Modification
    nix-mod = "${editor} ${dir-dots}";
    
    # ? - Scripts
    git-auth = "bash ${dir-scripts}/git/git-auth.sh";
    home-user-switch = "bash ${dir-scripts}/home-user-switch.sh";
    storage-mount = "bash ${dir-scripts}/storage/mount.sh";
    storage-unmount = "bash ${dir-scripts}/storage/un-mount.sh";
    cd-storage = "source ${dir-scripts}/storage/cd.sh";

    # ? -  Nixos Alias/Override
    nixos-rebuild-switch = "sudo nixos-rebuild switch -I nixos-config=${dir-dots}/etc.nixos/configuration.nix";
    nixos-channel-update = "sudo nix-channel --update && switch-dots-rebuild";
    nixos-os-update = "bash ${dir-scripts}/nixos-update.sh";

    # ? - Program Alias/Override
    ls = "eza --icons";
    grep = "rg";
    find = "fd";
    reboot = "sudo reboot now";
    shutdown = "sudo shutdown now";
    code = "${editor}";
    # slack = "slack ${use-wayland} ${enable-wayland-support}";
    # gchrome = "google-chrome-stable ${use-wayland} ${enable-wayland-support}";

    # ? - Helpers
    myKeys = "cat $HOME/Pandora/keys";
  };
}
