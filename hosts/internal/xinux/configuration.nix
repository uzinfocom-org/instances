{
  outputs,
  lib,
  ...
}:
{
  imports = [
    # System related configs
    outputs.nixosModules.base
    outputs.nixosModules.extra
    outputs.nixosModules.users

    # Service oriented configs
    ./services.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  # Hostname of the system
  networking = {
    hostId = "b9ebe929";
    hostName = "Internal-Xinux";
  };

  uzinfocom = {
    # Users of system
    accounts.teams = with lib.uteams; [
      leads
      admins
      xinux
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
