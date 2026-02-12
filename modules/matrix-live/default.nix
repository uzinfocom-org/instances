{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.uzinfocom.matrix-live;

  homeservers = servers: (lib.strings.concatStringsSep "," servers);
in
{
  imports = [
    # Proxy reversing
    ./proxy.nix
  ];

  options = {
    uzinfocom.matrix-live = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Matrix Livekit deployment module.";
      };

      key = lib.mkOption {
        type = lib.types.path;
        default = "/run/livekit.key";
        example = "/var/lib/some.key";
        description = "Location where service should create key to connect livekit and jwt with each other.";
      };

      homeserver = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        example = "example.com";
        description = "The homeserver to associate this livekit server with.";
      };

      homeserver-instances = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        example = [
          "example.com"
          "something.com"
        ];
        description = "Another homeservers that can use this livekit server.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.livekit = {
      enable = true;
      openFirewall = true;
      keyFile = cfg.key;
      settings.room.auto_create = false;
    };

    services.lk-jwt-service = {
      enable = true;
      keyFile = cfg.key;
      livekitUrl = "wss://livekit.${cfg.homeserver}";
    };

    # Comma seperated access restriction to livekit room creation by homeservers
    systemd.services.lk-jwt-service.environment.LIVEKIT_FULL_ACCESS_HOMESERVERS =
      if ((builtins.length cfg.homeserver-instances) == 0) then
        "*"
      else
        homeservers ([ cfg.homeserver ] ++ cfg.homeserver-instances);

    systemd.services.livekit-key = {
      before = [
        "lk-jwt-service.service"
        "livekit.service"
      ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        livekit
        coreutils
        gawk
      ];
      script = ''
        echo "Key missing, generating key"
        echo "lk-jwt-service: $(livekit-server generate-keys | tail -1 | awk '{print $3}')" > "${cfg.key}"
      '';
      serviceConfig.Type = "oneshot";
      unitConfig.ConditionPathExists = "!${cfg.key}";
    };

  };
}
