{
  # pkgs,
  lib,
  config,
  ...
}: let
  raid = lib.mkIf config.boot.bios.raided {
    boot.swraid = {
      enable = true;
      mdadmConf = ''
        MAILADDR support@oss.uzinfocom.uz
      '';
    };
  };

  uefi = lib.mkIf config.boot.bios.uefi {
    boot.loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  mirrors = lib.mkIf (config.boot.bios.mirrors != []) {
    boot.loader.grub.mirroredBoots = [
      {
        devices = config.boot.bios.mirrors;
        path = "/boot";
      }
    ];
  };

  devices = lib.mkIf (config.boot.bios.devices != []) {
    boot.loader.grub.devices = config.boot.bios.devices;
  };

  cfg = lib.mkIf config.boot.bios.enable {boot.loader.grub.enable = true;};
in {
  options = {
    boot.bios = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable server bootloaders.";
      };

      raided = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable software RAID for boot partition.";
      };

      mirrors = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "List of devices to mirror the boot partition to.";
      };

      devices = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "List of devices to install GRUB.";
      };

      uefi = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable UEFI boot.";
      };
    };
  };

  config = lib.mkMerge [
    raid
    mirrors
    devices
    uefi
    cfg
  ];
}
