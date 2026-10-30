/*
--------------------
Module Description
--------------------

Audio configuration for Gpd-Duo, using PipeWire as the audio server
in place of PulseAudio.

- Disables PulseAudio explicitly to avoid conflicts with PipeWire's
  own audio handling.

- Enables PipeWire as the core audio/video routing daemon, with:
  - WirePlumber as the session manager (handles device/stream policy).
  - ALSA support, including 32-bit compatibility for apps that only
    ship 32-bit audio libraries (e.g. some Wine/Proton titles).
  - PulseAudio-compatible interface (pulse.enable) so PulseAudio-only
    clients continue to work transparently through PipeWire.

- Enables rtkit, which grants PipeWire real-time scheduling priority
  to prevent audio glitches/underruns under system load.
*/


{ config, pkgs, ... }:

{
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;

    wireplumber = {
      enable = true;
    };

    audio = {
      enable = true;
    };

    alsa = {
      enable = true;
      support32Bit = true;
    };

    pulse = {
      enable = true;
    };
  };

  security.rtkit.enable = true;
}

