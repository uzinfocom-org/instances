{
  config,
  outputs,
  ...
}:
{
  imports = [
    # Top level abstractions
    outputs.nixosModules.web
    # outputs.nixosModules.mail
    outputs.nixosModules.matrix-py
  ];

  sops.secrets = { };

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
      client = true;
      call = "self-hosted";

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
