{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;
}

/*
--------------------
Module Description
--------------------

Zsh shell configuration, set as the system default shell.

- programs.zsh.enable = true
  Enables Zsh system-wide and ensures it's properly registered as a
  valid login shell (required for users.defaultUserShell to work
  correctly — installing zsh as a plain package without this would
  leave it usable but not selectable as a default shell).

- enableCompletion — tab-completion system for commands/arguments.

- autosuggestions.enable — inline suggestions based on command history
  as you type.

- syntaxHighlighting.enable — real-time syntax highlighting of
  commands in the prompt (valid commands, paths, etc. shown
  differently from invalid ones).

- users.defaultUserShell = pkgs.zsh
  Sets Zsh as the default login shell for all users, replacing the
  default (typically bash).
*/