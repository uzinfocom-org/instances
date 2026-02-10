{
  config,
  outputs,
  ...
}:
{
  imports = [
    # Top level abstractions
    outputs.nixosModules.web
    outputs.nixosModules.mail
    outputs.nixosModules.auth
    outputs.nixosModules.matrix

    # Per app preconfigured abstractions
    outputs.nixosModules.apps.uchar-website
  ];

  sops.secrets = {
    # Keycloak oriented services
    "auth/database" = {
      sopsFile = ../../../secrets/berk/auth.yaml;
    };

    # Mail oriented services
    "mail/hashed" = {
      key = "mail/hashed";
      sopsFile = ../../../secrets/berk/mail.yaml;
    };

    # Matrix oriented secrets
    "matrix/server" = {
      format = "binary";
      owner = "matrix-synapse";
      sopsFile = ../../../secrets/berk/matrix/server.hell;
    };
    "matrix/authentication" = {
      format = "binary";
      owner = "matrix-authentication-service";
      sopsFile = ../../../secrets/berk/matrix/authentication.hell;
    };
    "matrix/push" = {
      format = "binary";
      owner = "matrix-sygnal";
      path = "/var/lib/matrix-sygnal/sygnal.yaml";
      sopsFile = ../../../secrets/berk/matrix/push.hell;
    };
    "matrix/ident" = {
      format = "binary";
      owner = "matrix-sygnal";
      path = "/var/lib/matrix-sygnal/service_account.json";
      sopsFile = ../../../secrets/berk/matrix/saccount.hell;
    };
  };

  # https://ns1.berk.uz
  uzinfocom = {
    www = {
      enable = true;
      domain = "ns1.uzberk.uz";
    };

    # https://(chat|matrix).berk.uz
    matrix = {
      enable = true;
      domain = "uzberk.uz";
      cap = true;

      synapse.extra-config-files = [
        config.sops.secrets."matrix/server".path
      ];

      matrix-authentication-service.extra-config-files = [
        config.sops.secrets."matrix/authentication".path
      ];

      matrix-sygnal = {
        enable = true;
        config-file = config.sops.secrets."matrix/push".path;
      };
    };

    # https://auth.uzberk.uz
    auth = rec {
      enable = true;
      realm = "uzberk.uz";
      password = config.sops.secrets."auth/database".path;
    };

    # (smtp|imap)://mail.uzberk.uz
    mail = {
      enable = true;
      domain = "uzberk.uz";
      password = config.sops.secrets."mail/hashed".path;
    };

    # *://*
    apps = {
      # https://berk.uz
      uchar.website = {
        enable = true;
        domain = "uzberk.uz";
      };
    };
  };
}
