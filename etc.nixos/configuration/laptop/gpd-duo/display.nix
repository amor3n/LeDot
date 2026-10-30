/*
--------------------
Module Description
--------------------

Fixes the GPD Duo's known factory display defect: the internal eDP
panel is physically mounted upside down, and the external DP output
needs a matching forced resolution to stay in sync when docked/extended.

This is a hardware quirk specific to GPD's device line (documented
across multiple GPD models, not unique to this unit) — the panel
orientation is wrong by default and has no firmware-level fix, only
kernel-level correction.

- video=eDP-1:2880x1800,panel_orientation=upside_down
  Forces the correct native resolution and corrects orientation for
  the internal laptop display (eDP-1), which ships upside down.

- video=DP-3:2880x1800
  Forces the same native resolution on the external DisplayPort output,
  so the two displays stay aligned when both are active (e.g. dual-screen
  or docked use).

Without these kernel params, the internal display renders upside down
from first boot, before any compositor or display manager loads.
*/

{ config, pkgs, lib, ... }:

{
  boot = {
    kernelParams = [
      # ? - Set resolution and panel orientation for laptop eDP display
      "video=eDP-1:2880x1800,panel_orientation=upside_down"
      # ? - Set resolution for external DP display
      "video=DP-3:2880x1800"
    ];
  };
}

