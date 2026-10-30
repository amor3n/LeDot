{ config, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    # auth method params (trust | scram-sha-256)
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser origin-address auth-method
      local all     all                    scram-sha-256
      host  all     all      127.0.0.1/32  scram-sha-256
      host  all     all      ::1/128       scram-sha-256
  
    '';
    ensureDatabases = [ "postgres" ];
    ensureUsers = [
      {
        name = "postgres";
        ensureDBOwnership = true;
      }
    ];
  };
}