{
  lib,
  config,
  ...
}: let
  cfg = config.uzinfocom.auth;
in {
  options = {
    uzinfocom.auth = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Setup Keycloak IDM service.";
      };

      realm = lib.mkOption {
        description = "Name of the realm, typically it's base domain";
        type = lib.types.str;
        default = "uchar.uz";
      };

      domain = lib.mkOption {
        description = "The domain name where the service is hosted at";
        type = lib.types.str;
        default = "auth.${config.uzinfocom.auth.realm}";
      };

      password = lib.mkOption {
        description = "Database password file path";
        type = lib.types.path;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts.${config.uzinfocom.auth.domain} = {
      enableACME = true;
      forceSSL = true;

      extraConfig = ''
        access_log /var/log/nginx/${config.uzinfocom.auth.domain}-access.log;
        error_log /var/log/nginx/${config.uzinfocom.auth.domain}-error.log;
      '';

      locations = {
        "= /" = {
          extraConfig = ''
            return 302 /realms/${cfg.realm}/account;
          '';
        };

        "/" = {
          extraConfig = ''
            proxy_pass http://${
              config.services.keycloak.settings.http-host
            }:${
              toString config.services.keycloak.settings.http-port
            };
            proxy_buffer_size 8k;
          '';
        };
      };
    };

    services.keycloak = {
      inherit (cfg) enable;
      # initialAdminPassword = "e6Wcm0RrtegMEwl";
      database = {
        type = "postgresql";
        passwordFile = cfg.password;
      };
      settings = {
        hostname = config.uzinfocom.auth.domain;
        http-host = "127.0.0.1";
        http-port = 8080;
        proxy-headers = "xforwarded";
        http-enabled = true;
      };
    };
  };
}
