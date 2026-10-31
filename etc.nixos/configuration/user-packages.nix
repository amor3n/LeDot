/*
  --------------------
  Module Description
  --------------------

  User package list for user `amor_iii`, applied globally across targets.

  Covers user-space applications, terminal utilities, shell replacements,
  and the full user development toolchain (compilers, language runtimes,
  build generators, database tools, formatters, cross-compilation assets,
  browsers, and editor).
*/

{ config, pkgs, ... }:

{
  users.users.amor_iii = {
    packages = with pkgs; [
      # !----------------------------------
      # ! Development Tools
      # !-----------------------------------------------------------------------------------------------------------------------
      # ? - Build system generator
      cmake
      # ? - GNU compiler collection
      gcc
      # ? - GitHub CLI
      gh
      # ? - Version control system
      git
      # ? - Nix code formatter
      nixfmt
      # ? - Node.js runtime
      nodejs
      # ? - Python 3 interpreter
      python3
      # ? - Rust toolchain manager
      rustup
      # ? - MinGW-w64 cross-compiler for building Windows .exe from Linux
      pkgs.pkgsCross.mingwW64.buildPackages.gcc
      # ? - Static pthreads lib required by rustc's windows-gnu linker step
      pkgs.pkgsCross.mingwW64.windows.pthreads
      # ? - TLS/crypto library, required by openssl-sys and similar Rust crates
      openssl
      # ? - Locate compiled libraries for builds (needed by Rust/Node crates linking C libs)
      pkg-config
      # ? - Shell script formatter
      shfmt
      # ? - Code editor
      vscode
      # ? - Zig compiler
      zig
      # ? - Object-relational database system CLI & client tools
      postgresql
      # ? - Command-line utility for SQLx database migrations & queries
      sqlx-cli
    ];
  };
}

# * ----------------------------------------------------------------------------
# * for user specific packages just make a new user packages
# * ----------------------------------------------------------------------------
