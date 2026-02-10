{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}:
let
  cfg = config.uzinfocom.kvm;
in
{
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

    # Remove network card offloading
    systemd.services.ethtool-ens18 = {
      description = "ethtool-ens18";

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${pkgs.ethtool}/bin/ethtool -K ens18 gso off gro off tso off tx off rx off rxvlan off txvlan off";
      };

      # https://systemd.io/NETWORK_ONLINE/
      wantedBy = [ "network-pre.target" ];
    };
  };
}
