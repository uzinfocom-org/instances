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
  networking.hostName = "Internal-Uchar";

  uzinfocom = {
    # Users of system
    accounts = {
      teams = with lib.uteams; [
        leads
        admins
        uchar
      ];
      users = with lib.umembers; [
        unknown
      ];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
