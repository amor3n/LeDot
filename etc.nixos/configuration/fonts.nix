/*
--------------------
Module Description
--------------------

Global font packages, available system-wide across all targets.

Covers general-purpose text rendering (noto-fonts + color emoji) and
a broad set of monospace/coding fonts (Fira Code, JetBrains Mono,
Hack, Meslo, Source Code Pro, Iosevka, Inconsolata, Cascadia Code,
DejaVu) for use across terminal, editor, and UI elements. Includes
the Fira Code Nerd Font variant for icon/glyph support in tools that
expect Nerd Font glyphs (e.g. starship, fuzzel, status bars).

adwaita-icon-theme is included here as well since icon rendering for
GTK apps depends on it being present alongside the font stack.
*/

{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.fira-code
      fira-code
      jetbrains-mono
      hack-font
      meslo-lg
      source-code-pro
      iosevka
      inconsolata
      dejavu_fonts
      cascadia-code
      adwaita-icon-theme
    ];
}

