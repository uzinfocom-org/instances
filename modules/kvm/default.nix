{
  lib,
  config,
  modulesPath,
  ...
}: let
  cfg = config.uzinfocom.kvm;
in {
  imports = [
    # QEMU Guest profile
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  options = {
    uzinfocom.kvm = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable kvm proxmox support on server.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Proxmox cloud init
    services.cloud-init.network.enable = true;

    # Qemu guest service
    services.qemuGuest.enable = lib.mkDefault true;
  };
}
