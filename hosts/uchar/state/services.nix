{
  config,
  outputs,
  ...
}: {
  imports = [
    # Top level abstractions
    outputs.nixosModules.web
    outputs.nixosModules.mail
    outputs.nixosModules.matrix

    # Per app preconfigured abstractions
    # ...
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
    };

    # (smtp|imap)://mail.uchar.uz
    mail = {
      enable = true;
      domain = "uchar.uz";
      password = config.sops.secrets."mail/hashed".path;
    };
  };
}
