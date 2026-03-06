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

      type = lib.mkOption {
        type = lib.types.enum [
          "qemu"
          "vmware"
        ];
        default = "qemu";
        description = "Type of guest virtualization environment the machine is in.";
      };

    };
  };

  config = lib.mkIf cfg.enable {
    # Proxmox cloud init
    services.cloud-init.network.enable = if (cfg.type == "qemu") then (lib.mkDefault true) else false;

    # Qemu guest service
    services.qemuGuest.enable = if (cfg.type == "qemu") then (lib.mkDefault true) else false;

    # Add vmware guest additions
    virtualisation.vmware.guest.enable = if (cfg.type == "vmware") then (lib.mkDefault true) else false;

    # Remove network card offloading
    systemd.services = lib.mkIf (cfg.type == "qemu") {
      ethtool-ens18 = {
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
  };
}
