{
  lib,
  pkgs,
  domains,
  ...
}:
let
  keyFile = "/run/livekit.key";

  homeservers =
    servers:
    if ((builtins.length servers) == 0) then "*" else (lib.strings.concatStringsSep "," servers);
in
{
  services.livekit = {
    inherit keyFile;
    enable = true;
    openFirewall = true;
    settings.room.auto_create = false;
  };

  services.lk-jwt-service = {
    inherit keyFile;
    enable = true;
    livekitUrl = "wss://${domains.livekit}";
  };

  # Comma seperated access restriction to livekit room creation by homeservers
  systemd.services.lk-jwt-service.environment.LIVEKIT_FULL_ACCESS_HOMESERVERS = homeservers [ ];

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
      echo "lk-jwt-service: $(livekit-server generate-keys | tail -1 | awk '{print $3}')" > "${keyFile}"
    '';
    serviceConfig.Type = "oneshot";
    unitConfig.ConditionPathExists = "!${keyFile}";
  };
}
