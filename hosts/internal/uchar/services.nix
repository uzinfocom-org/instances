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
    outputs.nixosModules.matrix-py
    outputs.nixosModules.matrix-live

    # Per app preconfigured abstractions
    outputs.nixosModules.apps.uchar-website
  ];

  sops.secrets = {
    # Mail oriented services
    "mail/hashed" = {
      key = "mail/hashed";
      sopsFile = ../../../secrets/sabine/mail.yaml;
    };

    # Matrix oriented secrets
    "matrix/server" = {
      format = "binary";
      owner = "matrix-synapse";
      sopsFile = ../../../secrets/sabine/matrix/server.hell;
    };
    "matrix/authentication" = {
      format = "binary";
      owner = "matrix-authentication-service";
      sopsFile = ../../../secrets/sabine/matrix/authentication.hell;
    };
  };

  # https://ns2.uchar.uz
  uzinfocom = {
    www = {
      enable = true;
      domain = "ns1.uchar.uz";
    };

    # https://(chat|matrix).sabine.uz
    matrix = {
      enable = true;
      domain = "sabine.uz";
      call = "self-hosted";

      synapse.extra-config-files = [
        config.sops.secrets."matrix/server".path
      ];

      matrix-authentication-service.extra-config-files = [
        config.sops.secrets."matrix/authentication".path
      ];
    };

    # https://(livekit(-jwt)|call).sabine.uz
    matrix-live = {
      enable = true;
      homeserver = "sabine.uz";
    };

    # (smtp|imap)://mail.sabine.uz
    mail = {
      enable = true;
      domain = "sabine.uz";
      password = config.sops.secrets."mail/hashed".path;
    };

    # *://*
    apps = {
      # https://uchar.uz
      uchar.website = {
        enable = true;
        domain = "sabine.uz";
      };
    };
  };
}
