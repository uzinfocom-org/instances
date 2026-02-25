{
  config,
  outputs,
  ...
}:
{
  imports = [
    # Top level abstractions
    outputs.nixosModules.web
    outputs.nixosModules.bind
    outputs.nixosModules.mail
    outputs.nixosModules.auth
    outputs.nixosModules.matrix-py
    outputs.nixosModules.matrix-live

    # Per app preconfigured abstractions
    outputs.nixosModules.apps.uchar-website
    outputs.nixosModules.apps.xinuxmgr-bot
    outputs.nixosModules.apps.uzinfocom-website
  ];

  sops.secrets = {
    # Mail oriented services
    "mail/hashed" = {
      key = "mail/hashed";
      sopsFile = ../../../secrets/mail.yaml;
    };

    # Keycloak database password
    "auth/database" = {
      sopsFile = ../../../secrets/secrets.yaml;
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

  # Uzinfocom Services
  uzinfocom = {
    # https://ns1.oss.uzinfocom.uz
    www = {
      enable = true;
      domain = "ns1.oss.uzinfocom.uz";
    };

    # bind://ns1.oss.uzinfocom.uz
    nameserver = {
      enable = true;
      type = "master";
    };

    # https://auth.oss.uzinfocom.uz
    auth = {
      enable = true;
      password = config.sops.secrets."auth/database".path;
    };

    # https://(chat|matrix).uchar.uz
    matrix = {
      enable = true;
      domain = "uchar.uz";
      call = "self-hosted";
      client = true;

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

    # https://(livekit(-jwt)|call).uchar.uz
    matrix-live = {
      enable = true;
      homeserver = "uchar.uz";
    };

    # (smtp|imap)://mail.oss.uzinfocom.uz
    mail = {
      enable = true;
      domain = "oss.uzinfocom.uz";
      alias = [ "uchar.uz" ];
      password = config.sops.secrets."mail/hashed".path;
    };

    # *://*
    apps = {
      # https://uchar.uz
      uchar.website.enable = true;

      # https://*.uzinfocom.uz
      uzinfocom = {
        # https://*.uzinfocom.uz
        enable = true;
        # https://link.uzinfocom.uz
        # social.enable = true;
        # https://oss.uzinfocom.uz
        # website.enable = true;
      };

      # https://t.me/xinuxmgrbot
      xinux.bot.enable = true;
    };
  };
}
