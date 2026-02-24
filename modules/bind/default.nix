{
  config,
  lib,
  ...
}:
let
  generateZone =
    zone: type:
    let
      master = type == "master";
      file = "/var/dns/${zone}.zone";
    in
    if master then
      {
        inherit master file;
        inherit (config.uzinfocom.nameserver) slaves;
        extraConfig = ''
          ${lib.optionalString (config.uzinfocom.nameserver.slaves != [ ]) ''
            notify yes;
            also-notify { ${lib.concatStringsSep "; " config.uzinfocom.nameserver.slaves}; };
            allow-update { ${lib.concatStringsSep "; " config.uzinfocom.nameserver.slaves}; localhost; };
          ''}
        '';
      }
    else
      {
        inherit master file;
        inherit (config.uzinfocom.nameserver) masters;
        extraConfig = ''
          masterfile-format text;
        '';
      };

  # Map through given array of zones and generate zone object list
  zonesMap =
    zones: type:
    lib.listToAttrs (
      map (zone: {
        name = zone;
        value = generateZone zone type;
      }) zones
    );

  # If type is master, activate system.activationScripts.copyZones
  mastetFiles = lib.mkIf (config.uzinfocom.nameserver.type == "master") {
    system.activationScripts.copyZones = lib.mkForce {
      text = ''
        # Create /var/dns
        mkdir -p /var/dns

        # Copy all zone files to /var/dns
        for zoneFile in ${../../data/zones}/*.zone; do
          cp -f "$zoneFile" /var/dns/
        done

        # Give perms over everything for named
        chown -R named:named /var/dns
        chmod 750 /var/dns
        find /var/dns -type f -exec chown named:named {} \;
      '';
      deps = [ ];
    };
  };

  # If type is master, activate system.activationScripts.copyZones
  slaveFiles = lib.mkIf (config.uzinfocom.nameserver.type != "master") {
    system.activationScripts.copyZones = lib.mkForce {
      text = ''
        # Create /var/dns
        mkdir -p /var/dns

        # Time for clean-up
        rm -rf /var/dns/*

        # Give perms over everything for named
        chown -R named:named /var/dns
        chmod 750 /var/dns
        find /var/dns -type f -exec chown named:named {} \;
      '';
      deps = [ ];
    };
  };

  cfg = {
    services.bind = {
      inherit (config.uzinfocom.nameserver) enable;
      directory = "/var/bind";
      zones = zonesMap config.uzinfocom.nameserver.zones config.uzinfocom.nameserver.type;
      extraConfig = config.uzinfocom.nameserver.extra;
    };

    networking = {
      resolvconf.useLocalResolver = false;

      # DNS standard port for connections + that require more than 512 bytes
      firewall = {
        allowedUDPPorts = [ 53 ];
        allowedTCPPorts = [ 53 ];
      };
    };
  };
in
{
  options = {
    uzinfocom.nameserver = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the nameserver service";
      };

      type = lib.mkOption {
        type = lib.types.enum [
          "master"
          "slave"
        ];
        default = "master";
        description = "The type of the bind zone, either 'master' or 'slave'.";
      };

      masters = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          # Uzinfocom Uchar (NS-1)
          "91.212.89.25"
        ];
        description = "IP address of the master server.";
      };

      slaves = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          # Uzinfocom Uchar (NS-2)
          "91.212.89.28"
        ];
        description = "List of slave servers.";
      };

      zones = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default =
          builtins.readDir ../../data/zones
          |> lib.attrsets.filterAttrs (n: v: v == "regular")
          |> lib.attrsets.mapAttrsToList (n: _: n)
          |> map (f: lib.strings.removeSuffix ".zone" f);
        description = "List of zones to be served.";
      };

      extra = lib.mkOption {
        type = lib.types.lines;
        description = "Extra zone config to be appended at the end of the zone section.";
        default = "";
      };
    };
  };

  config =
    lib.mkMerge [
      cfg
      mastetFiles
      slaveFiles
    ]
    |> lib.mkIf config.uzinfocom.nameserver.enable;

  meta = {
    doc = ./readme.md;
    buildDocsInSandbox = true;
    maintainers = with lib.maintainers; [ orzklv ];
  };
}
