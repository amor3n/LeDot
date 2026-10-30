{ config, pkgs, ... }:

{
  users.groups.docker.members = [ "amor_iii" ];

  virtualisation.docker.enable = true;

  environment = {
    systemPackages = with pkgs; [
      # ?-
      docker
      # ?-
      docker-compose
    ];
  };
}

/*
--------------------
Module Description
--------------------

Docker container runtime setup.

- virtualisation.docker.enable = true
  Enables and starts the Docker daemon (dockerd) as a system service.

- users.groups.docker.members
  Adds "amor_iii" to the docker group, allowing docker commands to run
  without sudo. Requires a re-login (or new shell session) after first
  activation for group membership to take effect.

- docker / docker-compose packages
  CLI tooling for building/running containers and multi-container
  compose stacks.

Without virtualisation.docker.enable, the docker/docker-compose
packages would be installed but non-functional — no daemon to talk to.
*/