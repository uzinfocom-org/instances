{
  lib,
  inputs,
  config,
  ...
}:
let
  cfg = config.uzinfocom.mail;

  all-domain = [ cfg.domain ] ++ cfg.alias;

  forEachDomain = domain: {
    "admin@${domain}" = {
      quota = "2G";
      hashedPasswordFile = cfg.password;
      aliases = [
        "abuse@${domain}"
        "security@${domain}"
        "alerts@${domain}"
        "postmaster@${domain}"
      ];
    };

    "support@${domain}" = {
      quota = "2G";
      hashedPasswordFile = cfg.password;
      aliases = [
        "developers@${domain}"
        "maintainers@${domain}"
      ];
    };

    "noreply@${domain}" = {
      quota = "2G";
      sendOnly = true;
      hashedPasswordFile = cfg.password;
    };
  };
in
{
  imports = [
    inputs.simple-nixos-mailserver.nixosModule
  ];

  options = {
    uzinfocom.mail = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Deploy a mail service in server.";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        example = "uzinfocom.uz";
        description = "Use the appointed domain for mail service.";
      };

      alias = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        example = [ "example.com" ];
        description = "";
      };

      password = lib.mkOption {
        type = lib.types.path;
        default = null;
        description = "Path of file containing password for service accounts";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    mailserver = {
      enable = true;
      fqdn = "mail.${cfg.domain}";
      domains = all-domain;

      localDnsResolver = false;
      indexDir = "/var/lib/dovecot/indices";
      fullTextSearch = {
        enable = true;
        # index new email as they arrive
        autoIndex = true;
        # forcing users to write body
        enforced = "body";
      };

      # Generating hashed passwords:
      # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
      loginAccounts = all-domain |> map forEachDomain |> lib.mkMerge;

      # Use Let's Encrypt certificates. Note that this needs to set up a stripped
      # down nginx and opens port 80.
      certificateScheme = "acme-nginx";

      stateVersion = 3;
    };
  };
}
