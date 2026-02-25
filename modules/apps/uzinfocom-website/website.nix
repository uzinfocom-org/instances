{
  lib,
  inputs,
  config,
  ...
}:
let
  domain = "oss.uzinfocom.uz";
  cfg = config.uzinfocom.apps.uzinfocom;
in
{
  imports = [
    inputs.uzinfocom-website.nixosModules.server
  ];

  options = {
    uzinfocom.apps.uzinfocom = {
      website = {
        enable = lib.mkEnableOption "Uzinfocom OSS'es Website";
      };
    };
  };

  config = lib.mkIf cfg.website.enable {
    services = {
      uzinfocom.website = lib.mkIf cfg.website.enable {
        enable = true;
        port = 51003;
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
          serverAliases = [ "uoss.uz" ];
          locations = {
            "/".proxyPass =
              "http://${config.services.uzinfocom.website.host}:${toString config.services.uzinfocom.website.port}";
          };
        };
      };
    };

  };
}
