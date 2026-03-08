{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.uzinfocom.hydra;
in
{
  options = {
    uzinfocom.hydra = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Deploy NixOS native CI/CD.";
      };

      hydra = lib.mkOption {
        type = lib.types.port;
        default = 3123;
        description = "Port to expose web interface.";
      };

      cache = lib.mkOption {
        type = lib.types.port;
        default = 3124;
        description = "Port to expose cache binaries.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "hydra/sign" = {
        mode = "0440";
        format = "binary";
        owner = "hydra-queue-runner";
        group = "hydramyot";
        sopsFile = ../../secrets/xinux/hydra/cache-private.hell;
      };

      "hydra/config" = {
        mode = "0440";
        format = "binary";
        owner = "hydra-www";
        group = "hydramyot";
        sopsFile = ../../secrets/xinux/hydra/config.hell;
      };

      "hydra/env" = {
        mode = "0440";
        format = "binary";
        owner = "hydra-queue-runner";
        group = "hydramyot";
        sopsFile = ../../secrets/xinux/hydra/env.hell;
      };
    };

    users.groups.hydramyot = {
      members = [
        "hydra"
        "hydra-www"
        "hydra-queue-runner"
      ];
    };

    nix = {
      # Enable remote building
      distributedBuilds = true;

      # Remote machines
      buildMachines = [
        {
          hostName = "localhost";
          protocol = null;
          system = "x86_64-linux";
          speedFactor = 1;
          supportedFeatures = [
            "kvm"
            "nixos-test"
            "big-parallel"
            "benchmark"
          ];
          maxJobs = 64;
        }
      ];
    };

    systemd.services = {
      hydra-notify = {
        serviceConfig.EnvironmentFile = config.sops.secrets."hydra/env".path;
      };
    };

    services = {
      postgresql.enable = lib.mkDefault true;

      hydra = {
        enable = true;
        port = cfg.hydra;
        logo = ./logo.png;
        listenHost = "localhost";
        hydraURL = "https://hydra.xinux.uz";
        smtpHost = "mail.oss.uzinfocom.uz";
        notificationSender = "support@oss.uzinfocom.uz";

        useSubstitutes = true;
        # Use host machine as build farm
        # buildMachinesFiles = [];

        extraEnv.HYDRA_FORCE_SEND_MAIL = "1";

        extraConfig = ''
          <git-input>
            timeout = 3600
          </git-input>

          Include ${config.sops.secrets."hydra/config".path}
        '';
      };

      nix-serve = {
        enable = true;
        port = cfg.cache;
        bindAddress = "localhost";
        secretKeyFile = config.sops.secrets."hydra/sign".path;
      };

      nginx.virtualHosts = {
        "hydra.xinux.uz" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = with config.services.hydra; "http://${listenHost}:${toString port}";
          };
        };

        "cache.xinux.uz" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = with config.services.nix-serve; "http://${bindAddress}:${toString port}";
          };
        };
      };
    };
  };

  meta = {
    doc = ./readme.md;
    buildDocsInSandbox = true;
    maintainers = with lib.maintainers; [ orzklv ];
  };
}
