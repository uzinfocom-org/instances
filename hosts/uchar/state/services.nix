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
    outputs.nixosModules.matrix

    # Per app preconfigured abstractions
    outputs.nixosModules.apps.uchar-website
  ];

  sops.secrets = {
    # Mail oriented services
    "mail/hashed" = {
      key = "mail/hashed";
      sopsFile = ../../../secrets/uchar/mail.yaml;
    };

    # Matrix oriented secrets
    "matrix/server" = {
      format = "binary";
      owner = "matrix-synapse";
      sopsFile = ../../../secrets/uchar/matrix/server.hell;
    };
    "matrix/authentication" = {
      format = "binary";
      owner = "matrix-authentication-service";
      sopsFile = ../../../secrets/uchar/matrix/authentication.hell;
    };
    "matrix/push" = {
      format = "binary";
      owner = "matrix-sygnal";
      path = "/var/lib/matrix-sygnal/sygnal.yaml";
      sopsFile = ../../../secrets/uchar/matrix/push.hell;
    };
    "matrix/ident" = {
      format = "binary";
      owner = "matrix-sygnal";
      path = "/var/lib/matrix-sygnal/service_account.json";
      sopsFile = ../../../secrets/uchar/matrix/saccount.hell;
    };
  };

  # https://ns1.uchar.uz
  uzinfocom = {
    www = {
      enable = true;
      domain = "ns1.uchar.uz";
    };

    # https://(chat|matrix).uchar.uz
    matrix = {
      enable = true;
      domain = "uchar.uz";

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

    # (smtp|imap)://mail.uchar.uz
    mail = {
      enable = true;
      domain = "uchar.uz";
      password = config.sops.secrets."mail/hashed".path;
    };

    # *://*
    apps = {
      # https://uchar.uz
      uchar.website.enable = true;
    };
  };
}
