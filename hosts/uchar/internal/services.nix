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
    outputs.nixosModules.matrix-live

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
  };

  # https://ns2.uchar.uz
  uzinfocom = {
    www = {
      enable = true;
      domain = "ns1.uchar.uz";
    };

    # https://(chat|matrix).trashiston.uz
    matrix = {
      enable = true;
      domain = "trashiston.uz";
      call = "self-hosted";

      synapse.extra-config-files = [
        config.sops.secrets."matrix/server".path
      ];

      matrix-authentication-service.extra-config-files = [
        config.sops.secrets."matrix/authentication".path
      ];
    };

    # https://(livekit(-jwt)|call).trashiston.uz
    matrix-live = {
      enable = true;
      homeserver = "trashiston.uz";
    };

    # (smtp|imap)://mail.uchar.uz
    mail = {
      enable = true;
      domain = "trashiston.uz";
      password = config.sops.secrets."mail/hashed".path;
    };

    # *://*
    apps = {
      # https://uchar.uz
      uchar.website = {
        enable = true;
        domain = "trashiston.uz";
      };
    };
  };
}
