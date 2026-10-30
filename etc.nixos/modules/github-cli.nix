{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs;
      [
        # ? - GitHub CLI
        gh
      ];
  };

}

/* --------------------
   Module Description
   --------------------

   GitHub CLI package.

   Requires one-time manual authentication before use — installing
   the package alone does not log you in:
     gh auth login

   Without running this, gh commands that touch a GitHub account
   (pull requests, issues, repo creation, etc.) will fail until
   authenticated.
*/