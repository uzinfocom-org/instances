{
  inputs,
  outputs,
  lib,
  ...
}: {
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    outputs.nixosModules.ssh
    outputs.nixosModules.zsh
    outputs.nixosModules.maid
    outputs.nixosModules.motd
    outputs.nixosModules.root
    outputs.nixosModules.secret
    outputs.nixosModules.network
    outputs.nixosModules.nixpkgs

    # User configs
    outputs.nixosModules.users.efael

    # Import your deployed service list
    ./services

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Home Manager NixOS Module
    inputs.home-manager.nixosModules.home-manager
  ];

  # Hostname of the system
  networking.hostName = "Efael";

  # Entirely disable hibernation
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  # Don't ask for password
  security.sudo.wheelNeedsPassword = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Sometimes, shits need some little direct fixes
  home-manager.users.sakhib.programs.topgrade.settings = {
    # Remove cache cleaninx as it deletes all derivations
    pre_commands = lib.mkForce {};

    # Target configuration link to another
    linux = lib.mkForce {
      nix_arguments = "--flake github:uzinfocom-org/instances --option tarball-ttl 0";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
