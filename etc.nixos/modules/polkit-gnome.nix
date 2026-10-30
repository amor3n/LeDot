{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs;
      [
        # ? - Polkit authentication agent
        polkit_gnome
      ];
  };

  security.polkit.enable = true;
}

/* --------------------
   Module Description
   --------------------

   Polkit authentication agent setup.

   - security.polkit.enable = true
     Enables the polkit service itself, which handles privilege
     escalation prompts (e.g. mounting drives, installing packages
     via a GUI, network changes) without requiring a terminal sudo
     password each time.
     
   - polkit_gnome
     The GUI authentication agent that actually displays the prompt
     dialog. polkit.enable alone starts the backend service, but
     without an agent running in the session, privilege requests will
     silently fail with no dialog shown — the agent binary needs to
     be launched at session start (e.g. via an exec-once line in your
     compositor config), since niri does not do this automatically.
*/