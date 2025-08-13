{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.www;

  mkDefaultHost = {
    domain ? cfg.default.domain,
    cert ? cfg.default.cert,
    alias ? cfg.default.alias,
    root ? cfg.default.root,
  }: {
    ${domain} = lib.mkMerge [
      {
        inherit root;
        serverAliases = alias;
      }
      (lib.mkIf cert {
        forceSSL = true;
        enableACME = true;
      })
    ];
  };

  default = {
    # Configure Nginx
    services.nginx = {
      # Enable the Nginx web server
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;

      # Default virtual host
      virtualHosts = lib.mkIf cfg.default.enable (mkDefaultHost {});
    };

    # Accepting ACME Terms
    security.acme = {
      acceptTerms = true;
      defaults = {
        # It won't work due to world blockage
        # dnsResolver = "8.8.8.8:53";
        email = "support@oss.uzinfocom.uz";
      };
    };

    # Ensure the firewall allows HTTP and HTTPS traffic
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    networking.firewall.allowedUDPPorts = [
      80
      443
    ];
  };

  extra = {
    # Extra configurations for Nginx
    services.nginx = {
      # User provided hosts
      virtualHosts = cfg.hosts;
    };
  };

  merge = lib.mkMerge [
    default
    extra
  ];
in {
  options = {
    services.www = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the web server/proxy";
      };

      default = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Disabling default domains as FQDN.";
        };

        cert = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Automatic SSL certificate provision.";
        };

        domain = lib.mkOption {
          type = lib.types.str;
          default = "oss.uzinfocom.uz";
          description = "The default domain of instance.";
        };

        alias = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "List of extra aliases to host.";
        };

        root = lib.mkOption {
          type = lib.types.str;
          default = "${pkgs.uzinfocom.gate}";
          description = "The default domain of instance.";
        };
      };

      hosts = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = {};
        description = "List of hosted services instances.";
      };
    };
  };

  config = lib.mkIf config.services.www.enable merge;
}
