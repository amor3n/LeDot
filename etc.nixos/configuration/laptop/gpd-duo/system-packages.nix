/* --------------------
   Module Description
   --------------------

   Gpd-Duo-specific audio utilities, layered on top of the PipeWire
   setup declared in audio.nix.

   - pavucontrol — GUI mixer for controlling per-app volume, input/
     output device selection, and routing. Works against PipeWire
     through its PulseAudio-compatible interface (pulse.enable in
     audio.nix).
   - alsa-utils  — low-level ALSA CLI tools (amixer, aplay, etc.) for
     direct hardware-level audio control/debugging, useful when
     diagnosing issues below the PipeWire layer.

   These are device-specific packages, separate from any global
   systemPackages list, since they pair directly with this device's
   audio.nix configuration.
   
*/

{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      # ? Allows to control the audio via an in interface
      pavucontrol
      # ? - Audio control utilities
      alsa-utils
    ];
  };
}

