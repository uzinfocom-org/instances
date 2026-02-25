{
  lib,
  inputs,
  config,
  ...
}:
let
  domain = "link.uzinfocom.uz";
  cfg = config.uzinfocom.apps.uzinfocom;
in
{
  imports = [
    inputs.uzinfocom-taggis.nixosModules.server
  ];

  options = {
    uzinfocom.apps.uzinfocom.social = {
      enable = lib.mkEnableOption "Uzinfocom's Social Website";
    };
  };

  config = lib.mkIf cfg.social.enable {
    services = {
      uzinfocom.taggis = {
        enable = true;
        port = 51004;
        host = "127.0.0.1";

        proxy = {
          inherit domain;
          enable = false;
          proxy = "nginx";
        };
      };

      nginx.virtualHosts = {
        ${domain} = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/".proxyPass =
              "http://${config.services.uzinfocom.taggis.host}:${toString config.services.uzinfocom.taggis.port}";
          };
        };
      };
    };

  };
}
