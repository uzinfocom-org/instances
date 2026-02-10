{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.uzinfocom.network;

  gateway4 =
    ip:
    let
      parts = lib.splitString "." ip;
    in
    lib.concatStringsSep "." (lib.take 3 parts ++ [ "1" ]);

  ipv4 = lib.mkIf (cfg.ipv4.address != null) {
    networking = {
      interfaces = {
        "${cfg.interface}" = {
          ipv4.addresses = [
            {
              inherit (cfg.ipv4) address;
              prefixLength = cfg.ipv4.subnet;
            }
          ];
        };
      };

      # If you want to configure the default gateway
      defaultGateway = {
        address = cfg.ipv4.gateway;
        interface = "${cfg.interface}";
      };
    };
  };

  ipv6 = lib.mkIf (cfg.ipv6.address != null) {
    networking = {
      interfaces = {
        "${cfg.interface}" = {
          ipv6.addresses = [
            {
              inherit (cfg.ipv6) address;
              prefixLength = cfg.ipv6.subnet;
            }
          ];
        };
      };

      # If you want to configure the default gateway
      defaultGateway6 = {
        address = "fe80::1"; # Replace with your actual gateway for IPv6
        interface = "${cfg.interface}";
      };
    };
  };

  packs = {
    environment.systemPackages = with pkgs; [
      dig
      inetutils
    ];
  };

  main = {
    networking = {
      useDHCP = cfg.dhcp;

      interfaces = {
        "${cfg.interface}" = {
          useDHCP = cfg.dhcp;
        };
      };

      # DNS configuration
      nameservers = cfg.nameserver;
    };
  };

  mkWarning = msg: {
    warnings = [ msg ];
  };

  warnings = lib.mkIf (!cfg.dhcp && cfg.ipv4.address == null) (
    mkWarning "are you SURE that you want to go without any public ip address at ${config.networking.hostName}?"
  );

  merge = lib.mkMerge [
    main
    ipv4
    ipv6
    packs
    warnings
  ];
in
{
  options = {
    uzinfocom.network = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable networking configs.";
      };

      interface = lib.mkOption {
        type = lib.types.str;
        default = "eth0";
        description = "Network interface.";
      };

      dhcp = lib.mkEnableOption "dhcp for networks.";

      ipv4 = {
        address = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = "IPv4 address for target.";
        };
        subnet = lib.mkOption {
          type = lib.types.int;
          default = 24;
          description = "Subnet of ipv4 address .";
        };
        gateway = lib.mkOption {
          type = lib.types.str;
          default = gateway4 cfg.ipv4.address;
          description = "Gateway address for acquiring ip address.";
        };
      };

      ipv6 = {
        address = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = "IPv6 address for target.";
        };
        subnet = lib.mkOption {
          type = lib.types.int;
          default = 64;
          description = "Subnet of ipv6 address .";
        };
        gateway = lib.mkOption {
          type = lib.types.str;
          default = "fe80::1";
          description = "Gateway address for acquiring ip address.";
        };
      };

      nameserver = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "1.1.1.1"
          "1.0.0.1"
        ];
        description = "DNS nameserver for targets.";
      };
    };
  };

  config = lib.mkIf cfg.enable merge;

  meta = {
    doc = ./readme.md;
    buildDocsInSandbox = true;
    maintainers = with lib.maintainers; [ orzklv ];
  };
}
